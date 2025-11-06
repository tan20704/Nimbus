@echo off
echo Building React Docker App with Multi-Stage Build...
docker build -t react-docker-app .

echo.
echo Building Single-Stage version for comparison...
docker build -f Dockerfile.single-stage -t react-docker-app-single .

echo.
echo Comparing image sizes:
docker images | findstr react-docker-app

echo.
echo Starting the multi-stage container on port 3000...
echo Open http://localhost:3000 in your browser
echo Press Ctrl+C to stop the container
docker run -p 3000:80 react-docker-app