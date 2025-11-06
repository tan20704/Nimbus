# Dockerize Full Stack Applications

This repository demonstrates Docker containerization techniques for full-stack applications, focusing on multi-stage builds and optimization strategies.

## Projects

### React Docker Multi-Stage Build

A complete React application demonstrating multi-stage Docker builds for optimal production deployment.

**Features:**
- Multi-stage Dockerfile (Node.js build → Nginx production)
- Custom Nginx configuration with routing and caching
- Comprehensive .dockerignore for build optimization
- ~90% size reduction compared to single-stage builds
- Production-ready security headers and compression

**Quick Start:**
```bash
# For the organized structure (recommended):
cd react-docker-app
docker build -t react-docker-app .
docker run -p 3000:80 react-docker-app

# For the root-level files (legacy):
docker build -t react-docker-app .
docker run -p 3000:80 react-docker-app
```

**Image Size Comparison:**
- Multi-stage: ~25-30MB
- Single-stage: ~400-500MB
- Reduction: ~90%

## Key Concepts Demonstrated

1. **Multi-Stage Builds**: Separate build and runtime environments
2. **Image Optimization**: Minimal production images
3. **Security**: Non-root users, security headers
4. **Performance**: Static asset caching, compression
5. **Best Practices**: .dockerignore, layer optimization

## Repository Structure

This repository contains both an organized project structure and root-level React files for flexibility:

```
Dockerize_FS/
├── README.md
├── react-docker-app/          # Organized React project (recommended)
│   ├── Dockerfile             # Multi-stage configuration
│   ├── Dockerfile.single-stage # Comparison build
│   ├── .dockerignore          # Build optimization
│   ├── nginx.conf             # Production web server config
│   └── src/                   # React application source
├── Dockerfile                 # Root-level Docker config
├── src/                       # Root-level React source
└── package.json               # Root-level package config
```

## Getting Started

1. Clone the repository:
   ```bash
   git clone https://github.com/abhigyan-21/Dockerize_FS.git
   cd Dockerize_FS
   ```

2. Choose your preferred structure:
   - **Organized approach**: `cd react-docker-app` (recommended)
   - **Root-level approach**: Use files in root directory

## Prerequisites

- Docker Desktop
- Node.js (for local development)
- Git

## Contributing

Feel free to contribute additional containerization examples, optimizations, or improvements to existing projects.
