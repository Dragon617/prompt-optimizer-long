@echo off

echo ================================
echo Prompt Optimizer Deployment Script
echo ================================

REM Check if Docker is installed
echo Checking if Docker is installed...
docker --version >nul 2>&1
if %errorlevel% neq 0 (
    echo Error: Docker not found. Please install Docker first.
    pause
    exit /b 1
)

REM Check if Docker Compose is installed
echo Checking if Docker Compose is installed...
docker-compose --version >nul 2>&1
if %errorlevel% neq 0 (
    echo Error: Docker Compose not found. Please install Docker Compose first.
    pause
    exit /b 1
)

REM Check if docker-compose.yml file exists
if not exist "docker-compose.yml" (
    echo Error: docker-compose.yml file not found. Please run this script in the project root directory.
    pause
    exit /b 1
)

REM Stop and remove existing containers
echo Stopping and removing existing containers...
docker-compose down

REM Build and start services
echo Building and starting services...
docker-compose up -d --build

if %errorlevel% equ 0 (
    echo.
    echo ================================
    echo Deployment completed successfully!
    echo.
    echo You can access the application at:
    echo http://localhost:8999
    echo.
    echo To view logs: docker-compose logs -f
    echo To stop services: docker-compose down
    echo ================================
    
    REM Wait a moment for services to start
    timeout /t 5 /nobreak >nul
    
    REM Show running containers
    echo.
    echo Running containers:
    docker-compose ps
    
) else (
    echo.
    echo ================================
    echo Error occurred during deployment. Please check the logs above.
    echo ================================
    
    REM Show running containers
    echo.
    echo Running containers:
    docker-compose ps
    
    REM Show logs for debugging
    echo.
    echo Last 20 lines of logs:
    docker-compose logs --tail=20
    
    echo ================================
)

pause