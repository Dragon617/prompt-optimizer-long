@echo off
echo Testing if port 8999 is accessible...

REM Try to connect to localhost:8999
powershell -Command "try { $tcp = New-Object Net.Sockets.TcpClient; $tcp.Connect('localhost', 8999); Write-Host 'Port 8999 is open and accepting connections'; $tcp.Close() } catch { Write-Host 'Port 8999 is not accessible or not responding' }"

echo.
echo If the port is not accessible, try these troubleshooting steps:
echo 1. Check if Docker containers are running: docker-compose ps
echo 2. Check container logs: docker-compose logs
echo 3. Restart the services: docker-compose down ^&^& docker-compose up -d
echo 4. Verify firewall settings to ensure port 8999 is not blocked

pause