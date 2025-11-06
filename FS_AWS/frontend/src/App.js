import React, { useState, useEffect } from 'react';
import axios from 'axios';

const API_BASE_URL = process.env.REACT_APP_API_URL || '';

function App() {
  const [tasks, setTasks] = useState([]);
  const [newTask, setNewTask] = useState('');
  const [loading, setLoading] = useState(false);
  const [serverStatus, setServerStatus] = useState('checking');
  const [instanceInfo, setInstanceInfo] = useState('');

  useEffect(() => {
    fetchTasks();
    checkServerHealth();
    const interval = setInterval(checkServerHealth, 30000); // Check every 30 seconds
    return () => clearInterval(interval);
  }, []);

  const checkServerHealth = async () => {
    try {
      const response = await axios.get(`${API_BASE_URL}/health`);
      setServerStatus('online');
      setInstanceInfo(response.data.instance || 'unknown');
    } catch (error) {
      setServerStatus('offline');
      setInstanceInfo('');
    }
  };

  const fetchTasks = async () => {
    try {
      setLoading(true);
      const response = await axios.get(`${API_BASE_URL}/api/tasks`);
      setTasks(response.data);
    } catch (error) {
      console.error('Error fetching tasks:', error);
    } finally {
      setLoading(false);
    }
  };

  const addTask = async (e) => {
    e.preventDefault();
    if (!newTask.trim()) return;

    try {
      const response = await axios.post(`${API_BASE_URL}/api/tasks`, {
        title: newTask
      });
      setTasks([response.data, ...tasks]);
      setNewTask('');
    } catch (error) {
      console.error('Error adding task:', error);
    }
  };

  const toggleTask = async (id, completed) => {
    try {
      const response = await axios.put(`${API_BASE_URL}/api/tasks/${id}`, {
        completed: !completed
      });
      setTasks(tasks.map(task => 
        task._id === id ? response.data : task
      ));
    } catch (error) {
      console.error('Error updating task:', error);
    }
  };

  const deleteTask = async (id) => {
    try {
      await axios.delete(`${API_BASE_URL}/api/tasks/${id}`);
      setTasks(tasks.filter(task => task._id !== id));
    } catch (error) {
      console.error('Error deleting task:', error);
    }
  };

  return (
    <div className="container">
      <div className={`status-indicator status-${serverStatus}`}>
        {serverStatus === 'online' ? `Online (${instanceInfo})` : 'Offline'}
      </div>
      
      <header className="header">
        <h1>Task Manager</h1>
        <p>Full-stack app with load balancing</p>
      </header>

      <form onSubmit={addTask} className="task-form">
        <input
          type="text"
          value={newTask}
          onChange={(e) => setNewTask(e.target.value)}
          placeholder="Enter a new task..."
          className="task-input"
        />
        <button type="submit" className="btn btn-primary">
          Add Task
        </button>
      </form>

      {loading ? (
        <p>Loading tasks...</p>
      ) : (
        <ul className="task-list">
          {tasks.map(task => (
            <li key={task._id} className={`task-item ${task.completed ? 'completed' : ''}`}>
              <input
                type="checkbox"
                checked={task.completed}
                onChange={() => toggleTask(task._id, task.completed)}
                className="task-checkbox"
              />
              <span className={`task-title ${task.completed ? 'completed' : ''}`}>
                {task.title}
              </span>
              <button
                onClick={() => deleteTask(task._id)}
                className="btn btn-danger"
              >
                Delete
              </button>
            </li>
          ))}
        </ul>
      )}

      {tasks.length === 0 && !loading && (
        <p style={{ textAlign: 'center', color: '#666' }}>
          No tasks yet. Add one above!
        </p>
      )}
    </div>
  );
}

export default App;