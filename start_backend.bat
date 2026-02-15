@echo off
setlocal

:: Check if PostgreSQL is reachable on default port 5432
powershell -Command "Test-NetConnection -ComputerName localhost -Port 5432 -InformationLevel Quiet" > nul
if %errorlevel% neq 0 (
    echo [ERROR] PostgreSQL is not running on localhost:5432.
    echo Please install PostgreSQL and ensure the service is started.
    echo You also need to create the database: wasl_db
    echo.
    pause
    exit /b 1
)

:: Run Spring Boot app using local Maven
echo [INFO] Starting Wasl Backend...
call backend\maven\apache-maven-3.9.6\bin\mvn.cmd -f backend\pom.xml spring-boot:run

endlocal
