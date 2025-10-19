@echo off
setlocal enabledelayedexpansion

echo ========================================
echo Starting E-Commerce Platform Services
echo ========================================

REM Create logs directory if it doesn't exist
if not exist logs mkdir logs

REM Start Config Server
echo Starting config-server...
cd core\config-server
start "config-server" cmd /c "..\..\gradlew.bat bootRun > ..\..\logs\config-server.log 2>&1"
cd ..\..
timeout /t 5 /nobreak > nul

REM Start Discovery Server
echo Starting discovery-server...
cd core\discovery-server
start "discovery-server" cmd /c "..\..\gradlew.bat bootRun > ..\..\logs\discovery-server.log 2>&1"
cd ..\..
timeout /t 5 /nobreak > nul

REM Start Gateway Server
echo Starting gateway-server...
cd core\gateway-server
start "gateway-server" cmd /c "..\..\gradlew.bat bootRun > ..\..\logs\gateway-server.log 2>&1"
cd ..\..
timeout /t 5 /nobreak > nul

REM Start Auth Service
echo Starting auth-service...
cd core\auth-service
start "auth-service" cmd /c "..\..\gradlew.bat bootRun > ..\..\logs\auth-service.log 2>&1"
cd ..\..
timeout /t 5 /nobreak > nul

REM Start Security Service
echo Starting security-service...
cd services\security-service
start "security-service" cmd /c "..\..\gradlew.bat bootRun > ..\..\logs\security-service.log 2>&1"
cd ..\..
timeout /t 5 /nobreak > nul

REM Start Subscription Service
echo Starting subscription-service...
cd services\subscription-service
start "subscription-service" cmd /c "..\..\gradlew.bat bootRun > ..\..\logs\subscription-service.log 2>&1"
cd ..\..
timeout /t 5 /nobreak > nul

REM Start Email Service
echo Starting email-service...
cd services\email-service
start "email-service" cmd /c "..\..\gradlew.bat bootRun > ..\..\logs\email-service.log 2>&1"
cd ..\..
timeout /t 5 /nobreak > nul

REM Start Global Service
echo Starting global-service...
cd services\global-service
start "global-service" cmd /c "..\..\gradlew.bat bootRun > ..\..\logs\global-service.log 2>&1"
cd ..\..

echo ========================================
echo All services started!
echo ========================================
echo Logs are available in the 'logs' directory
echo To stop all services, close the terminal windows or run: stop-all-services.bat

pause