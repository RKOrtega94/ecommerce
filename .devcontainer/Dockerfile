# Use a Microsoft base image that supports Java and Node.js
FROM mcr.microsoft.com/devcontainers/base:ubuntu

# Avoid prompts from apt
ENV DEBIAN_FRONTEND=noninteractive

# Install necessary dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg \
    lsb-release \
    software-properties-common \
    && rm -rf /var/lib/apt/lists/*

# Set user to vscode
USER vscode

# Add Bun to PATH
ENV PATH="/home/vscode/.bun/bin:${PATH}"
