@echo off
setlocal
cd /d "%~dp0backend"
call mvnw spring-boot:run
endlocal
pause
