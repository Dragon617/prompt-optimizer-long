@echo off

echo ================================
echo Prompt Optimizer Local Deployment
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

REM Create a temporary docker-compose file for local building
echo Creating temporary docker-compose file for local building...
(
echo version: '3.8'
echo.
echo services:
echo   prompt-optimizer:
echo     build:
echo       context: .
echo       dockerfile: Dockerfile
echo     container_name: prompt-optimizer
echo     restart: unless-stopped
echo     ports:
echo       - "8999:80"
echo     environment:
echo       - NGINX_PORT=80
echo     security_opt:
echo       - no-new-privileges:true
) > docker-compose.local.yml

REM Build and start services
echo Building and starting services from local source...
docker-compose -f docker-compose.local.yml up -d --build

if %errorlevel% equ 0 (
    echo.
    echo ================================
    echo Local deployment completed successfully!
    echo.
    echo You can access the application at:
    echo http://localhost:8999
    echo.
    echo To view logs: docker-compose -f docker-compose.local.yml logs -f
    echo To stop services: docker-compose -f docker-compose.local.yml down
    echo ================================
) else (
    echo.
    echo ================================
    echo Error occurred during deployment. Please check the logs above.
    echo ================================
)

REM Show running containers
echo.
echo Running containers:
docker-compose -f docker-compose.local.yml ps

REM Pause to see the output
pause