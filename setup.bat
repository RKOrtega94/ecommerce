@REM Initialize project

@REM 1. Initialize submodules
git submodule init
git submodule update

@REM 2. Check if Docker is installed and running
docker info >nul 2>&1
if %errorlevel% neq 0 (
    @REM Run Docker Desktop
    call "C:\Program Files\Docker\Docker\Docker Desktop.exe" & exit /b
)

@REM 3. Pull and run Nexus3 image
@REM Check if a container named nexus3 already exists
docker ps -a --filter "name=nexus3" --format "{{.Names}}" | findstr nexus3 >nul
if %errorlevel% equ 0 (
    echo Nexus3 container already exists. Skipping creation.
) else (
    docker pull sonatype/nexus3
    docker run -d -p 8081:8081 --name nexus3 sonatype/nexus3
)

@REM 4. Wait for Nexus3 to start
@echo Waiting for Nexus3 to start...
:wait_for_nexus
timeout /t 5 >nul
docker logs nexus3 >nul 2>&1
if %errorlevel% neq 0 (
    echo Nexus3 is not running. Please check the logs.
    exit /b 1
)
@REM Check if Nexus3 is up
curl -s http://localhost:8081 >nul 2>&1
if %errorlevel% neq 0 (
    echo Nexus3 is not accessible. Please check the logs.
    exit /b 1
)