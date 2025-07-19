#!/bin/bash
# Script to start services for local development and testing with Docker Compose

echo "Building and starting services..."

# Clean and build gradle project
echo "Checking for Gradle installation..."
if ! [ -x "$(command -v gradle)" ]; then
    echo "Gradle is not installed. Please install Gradle to continue."
    exit 1
fi

echo "Building the project with Gradle..."
gradle build --no-daemon -x test

# Ensure Docker is running
if( ! docker info > /dev/null 2>&1 ); then
    
fi