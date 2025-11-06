# React Docker Multi-Stage Build

This project demonstrates a React application with a multi-stage Docker build setup.

## Project Structure

```
react-docker-app/
├── Dockerfile          # Multi-stage Docker configuration
├── .dockerignore       # Files to exclude from Docker build
├── nginx.conf          # Custom Nginx configuration
├── package.json        # React app dependencies
└── src/                # React source code
```

## Docker Setup

### Multi-Stage Dockerfile
- **Stage 1 (Build)**: Uses Node.js 18 Alpine to install dependencies and build the React app
- **Stage 2 (Production)**: Uses Nginx Alpine to serve the static files

### Key Features
- Optimized image size by excluding dev dependencies from final image
- Custom Nginx configuration for React routing and caching
- Comprehensive .dockerignore to exclude unnecessary files

## Build and Run Instructions

### Prerequisites
Install Docker Desktop from: https://www.docker.com/products/docker-desktop/

### Build the Docker Image
```bash
cd react-docker-app
docker build -t react-docker-app .
```

### Run the Container
```bash
docker run -p 3000:80 react-docker-app
```

The React app will be available at: http://localhost:3000

### Check Image Size
```bash
# Compare image sizes
docker images react-docker-app

# For comparison, you can also build a single-stage version:
docker build -f Dockerfile.single-stage -t react-docker-app-single .
docker images | grep react-docker-app
```

## Expected Results

- **Multi-stage image**: ~25-30MB (Nginx + built React files)
- **Single-stage image**: ~400-500MB (includes Node.js + all dependencies)
- **Size reduction**: ~90% smaller final image

## Testing

1. Build and run the container
2. Open http://localhost:3000 in your browser
3. Verify the React app loads correctly
4. Check that client-side routing works (if you add React Router)
5. Verify static assets are cached properly (check browser dev tools)