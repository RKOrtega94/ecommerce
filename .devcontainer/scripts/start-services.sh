#!/bin/bash

# Quick Start Script for E-Commerce Microservices
# This script starts services in the correct order

set -e

echo "🚀 Starting E-Commerce Microservices Development Environment"
echo "================================================================"

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check if infrastructure is running
echo -e "\n${YELLOW}📊 Checking infrastructure services...${NC}"

check_service() {
    local service=$1
    local port=$2

    if nc -z localhost $port 2>/dev/null; then
        echo -e "${GREEN}✓${NC} $service is running on port $port"
        return 0
    else
        echo -e "${RED}✗${NC} $service is NOT running on port $port"
        return 1
    fi
}

check_service "PostgreSQL" 5432
check_service "Redis" 6379
check_service "Kafka" 9092

echo -e "\n${YELLOW}⏳ Waiting for infrastructure to be ready...${NC}"
sleep 5

# Navigate to backend directory
cd /workspace/backend

echo -e "\n${YELLOW}🔧 Building project...${NC}"
gradle clean build -x test

echo -e "\n${YELLOW}1️⃣  Starting Config Server (port 8888)...${NC}"
cd /workspace/backend/core/config-server
gradle bootRun > /workspace/logs/config-server-startup.log 2>&1 &
CONFIG_PID=$!
echo "Config Server PID: $CONFIG_PID"

# Wait for Config Server to start
echo "Waiting for Config Server to be ready..."
for i in {1..30}; do
    if nc -z localhost 8888 2>/dev/null; then
        echo -e "${GREEN}✓ Config Server is ready${NC}"
        break
    fi
    echo -n "."
    sleep 2
done

echo -e "\n${YELLOW}2️⃣  Starting Discovery Server (port 8761)...${NC}"
cd /workspace/backend/core/discovery-server
gradle bootRun > /workspace/logs/discovery-server-startup.log 2>&1 &
DISCOVERY_PID=$!
echo "Discovery Server PID: $DISCOVERY_PID"

# Wait for Discovery Server to start
echo "Waiting for Discovery Server to be ready..."
for i in {1..30}; do
    if nc -z localhost 8761 2>/dev/null; then
        echo -e "${GREEN}✓ Discovery Server is ready${NC}"
        break
    fi
    echo -n "."
    sleep 2
done

echo -e "\n${YELLOW}3️⃣  Starting Auth Service (port 8081)...${NC}"
cd /workspace/backend/core/auth-service
gradle bootRun > /workspace/logs/auth-service-startup.log 2>&1 &
AUTH_PID=$!
echo "Auth Service PID: $AUTH_PID"

echo -e "\n${YELLOW}4️⃣  Starting Security Service (port 8082)...${NC}"
cd /workspace/backend/services/security-service
gradle bootRun > /workspace/logs/security-service-startup.log 2>&1 &
SECURITY_PID=$!
echo "Security Service PID: $SECURITY_PID"

echo -e "\n${YELLOW}5️⃣  Starting Gateway Server (port 8080)...${NC}"
cd /workspace/backend/core/gateway-server
gradle bootRun > /workspace/logs/gateway-server-startup.log 2>&1 &
GATEWAY_PID=$!
echo "Gateway Server PID: $GATEWAY_PID"

echo -e "\n${GREEN}================================================================${NC}"
echo -e "${GREEN}✓ All services started successfully!${NC}"
echo -e "${GREEN}================================================================${NC}"

echo -e "\n📋 Service PIDs:"
echo "  Config Server: $CONFIG_PID"
echo "  Discovery Server: $DISCOVERY_PID"
echo "  Auth Service: $AUTH_PID"
echo "  Security Service: $SECURITY_PID"
echo "  Gateway Server: $GATEWAY_PID"

echo -e "\n🌐 Service URLs:"
echo "  Config Server:    http://localhost:8888"
echo "  Eureka Dashboard: http://localhost:8761"
echo "  Gateway Server:   http://localhost:8080"
echo "  Auth Service:     http://localhost:8081"
echo "  PgAdmin:          http://localhost:5050"

echo -e "\n📝 Logs location:"
echo "  /workspace/logs/*-startup.log"

echo -e "\n⚠️  To stop all services, run: kill $CONFIG_PID $DISCOVERY_PID $AUTH_PID $SECURITY_PID $GATEWAY_PID"

echo -e "\n${YELLOW}💡 Tip: Use 'tail -f /workspace/logs/<service>-startup.log' to view logs${NC}"

