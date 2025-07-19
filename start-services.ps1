# PowerShell script to start services for local development and testing with Docker Compose
Write-Host "Building and starting services..." -ForegroundColor Green
# Clean and build gradle project
Write-Host "Checking for Gradle installation..." -ForegroundColor Cyan
if (-not (Get-Command gradle -ErrorAction SilentlyContinue))
{
    Write-Host "Gradle is not installed. Please install Gradle to continue." -ForegroundColor Red
    exit 1
}
Write-Host "Building the project with Gradle..." -ForegroundColor Cyan
gradle clean build --no-daemon -x test

# Start all services using Docker Compose
Write-Host "Starting all services with Docker Compose..." -ForegroundColor Cyan

# Ensure Docker is running
if (-not (Get-Command docker -ErrorAction SilentlyContinue))
{
    Write-Host "Docker is not installed or not running. Please start Docker to continue." -ForegroundColor Red
    exit 1
}

docker compose up -d --build --remove-orphans --force-recreate