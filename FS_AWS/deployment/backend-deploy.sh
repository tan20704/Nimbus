#!/bin/bash

# Backend deployment script for EC2 instances
# Run this script on each backend EC2 instance

set -e

echo "Starting backend deployment..."

# Update system
sudo yum update -y

# Install Node.js if not already installed
if ! command -v node &> /dev/null; then
    curl -sL https://rpm.nodesource.com/setup_18.x | sudo bash -
    sudo yum install -y nodejs
fi

# Install MongoDB
if ! command -v mongod &> /dev/null; then
    echo "Installing MongoDB..."
    sudo tee /etc/yum.repos.d/mongodb-org-7.0.repo > /dev/null <<EOF
[mongodb-org-7.0]
name=MongoDB Repository
baseurl=https://repo.mongodb.org/yum/amazon/2/mongodb-org/7.0/x86_64/
gpgcheck=1
enabled=1
gpgkey=https://www.mongodb.org/static/pgp/server-7.0.asc
EOF
    sudo yum install -y mongodb-org
    sudo systemctl start mongod
    sudo systemctl enable mongod
fi

# Create application directory
sudo mkdir -p /opt/fullstack-app/backend
cd /opt/fullstack-app/backend

# Clone or copy application code (replace with your repository)
# For demo purposes, we'll create the files directly
sudo tee package.json > /dev/null <<'EOF'
{
  "name": "backend",
  "version": "1.0.0",
  "main": "index.js",
  "scripts": {
    "start": "node index.js",
    "dev": "nodemon index.js"
  },
  "dependencies": {
    "express": "^5.1.0",
    "mongoose": "^8.0.0",
    "cors": "^2.8.5",
    "dotenv": "^16.3.1",
    "helmet": "^7.1.0"
  }
}
EOF

# Install dependencies
sudo npm install

# Create environment file
sudo tee .env > /dev/null <<EOF
PORT=3001
MONGODB_URI=mongodb://localhost:27017/fullstack-app
INSTANCE_ID=\${INSTANCE_ID:-backend-unknown}
EOF

# Copy application code (you would typically clone from git)
sudo tee index.js > /dev/null <<'EOF'
const express = require('express');
const mongoose = require('mongoose');
const cors = require('cors');
const helmet = require('helmet');
require('dotenv').config();

const app = express();
const port = process.env.PORT || 3001;

// Middleware
app.use(helmet());
app.use(cors());
app.use(express.json());

// MongoDB connection
const mongoUri = process.env.MONGODB_URI || 'mongodb://localhost:27017/fullstack-app';
mongoose.connect(mongoUri)
  .then(() => console.log('Connected to MongoDB'))
  .catch(err => console.error('MongoDB connection error:', err));

// Task schema
const taskSchema = new mongoose.Schema({
  title: { type: String, required: true },
  completed: { type: Boolean, default: false },
  createdAt: { type: Date, default: Date.now }
});

const Task = mongoose.model('Task', taskSchema);

// Routes
app.get('/health', (req, res) => {
  res.json({ 
    status: 'OK', 
    timestamp: new Date().toISOString(),
    instance: process.env.INSTANCE_ID || 'local'
  });
});

app.get('/api/tasks', async (req, res) => {
  try {
    const tasks = await Task.find().sort({ createdAt: -1 });
    res.json(tasks);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

app.post('/api/tasks', async (req, res) => {
  try {
    const task = new Task({ title: req.body.title });
    await task.save();
    res.status(201).json(task);
  } catch (error) {
    res.status(400).json({ error: error.message });
  }
});

app.put('/api/tasks/:id', async (req, res) => {
  try {
    const task = await Task.findByIdAndUpdate(
      req.params.id,
      { completed: req.body.completed },
      { new: true }
    );
    if (!task) return res.status(404).json({ error: 'Task not found' });
    res.json(task);
  } catch (error) {
    res.status(400).json({ error: error.message });
  }
});

app.delete('/api/tasks/:id', async (req, res) => {
  try {
    const task = await Task.findByIdAndDelete(req.params.id);
    if (!task) return res.status(404).json({ error: 'Task not found' });
    res.json({ message: 'Task deleted' });
  } catch (error) {
    res.status(400).json({ error: error.message });
  }
});

app.listen(port, '0.0.0.0', () => {
  console.log(`Server listening at http://0.0.0.0:${port}`);
  console.log(`Instance ID: ${process.env.INSTANCE_ID || 'local'}`);
});
EOF

# Create systemd service
sudo tee /etc/systemd/system/fullstack-backend.service > /dev/null <<EOF
[Unit]
Description=Full Stack App Backend
After=network.target

[Service]
Type=simple
User=ec2-user
WorkingDirectory=/opt/fullstack-app/backend
ExecStart=/usr/bin/node index.js
Restart=always
RestartSec=10
Environment=NODE_ENV=production
EnvironmentFile=/opt/fullstack-app/backend/.env

[Install]
WantedBy=multi-user.target
EOF

# Set permissions
sudo chown -R ec2-user:ec2-user /opt/fullstack-app

# Start and enable service
sudo systemctl daemon-reload
sudo systemctl enable fullstack-backend
sudo systemctl start fullstack-backend

echo "Backend deployment completed!"
echo "Service status:"
sudo systemctl status fullstack-backend --no-pager