# 🛍️ E-Commerce Microservices Project

This is a comprehensive e-commerce platform built with microservices architecture, featuring Spring Boot backend services, Angular frontend, and modern DevOps practices.

## 🏗️ Architecture Overview

### Backend Services (Spring Boot + gRPC)

- **Core Services**: Config Server, API Gateway, Discovery Server, Identity Service
- **Business Services**: Security Service, Core Business Service
- **Shared Libraries**: Commons, gRPC Common, Messaging, XML Signer

### Frontend

- **Angular Application**: Modern web interface with server-side rendering

### Infrastructure

- **Database**: PostgreSQL with multi-database setup
- **Messaging**: Apache Kafka for event-driven communication
- **Caching**: Redis for session management
- **Containerization**: Docker & Docker Compose

## � Prerequisites

### Required Software

- **Git** (v2.20+)
- **Java** (JDK 17 or higher)
- **Docker** & **Docker Compose** (v2.0+)
- **Node.js** (v18+) and **npm/yarn** (for frontend)
- **PowerShell** or **Bash** terminal

### Recommended IDEs

- **IntelliJ IDEA** (for backend services)
- **VS Code** (for frontend and general development)

## 🚀 Complete Setup Guide

### Step 1: Clone the Repository

```bash
# Clone the main repository
git clone https://github.com/RKOrtega94/ecommerce.git
cd ecommerce
```

### Step 2: Initialize All Submodules

```bash
# Initialize and update all git submodules
git submodule update --init --recursive

# Sync submodule URLs and fetch latest changes
git submodule sync --recursive
git submodule foreach 'git fetch origin && git checkout main && git pull origin main'
```

**Expected Submodules:**

- ✅ `backend/core/config_server` - Spring Cloud Config Server
- ✅ `backend/core/discovery-server` - Eureka Service Discovery  
- ✅ `backend/core/gateway` - API Gateway
- ✅ `backend/core/identity` - Identity Service
- ✅ `backend/core/properties` - Configuration Properties
- ✅ `backend/libs/commons` - Common Libraries
- ✅ `backend/libs/grpc-common` - gRPC Common Components
- ✅ `backend/libs/messaging` - Messaging Libraries
- ✅ `backend/libs/xml_signer` - XML Signing Utilities
- ✅ `backend/services/core` - Core Business Service
- ✅ `backend/services/security` - Security Service
- ✅ `frontend` - Angular Frontend Application

### Step 3: Infrastructure Setup

#### 3.1 Start Infrastructure Services

```bash
# Start all infrastructure services (databases, messaging, etc.)
docker-compose up -d zookeeper kafka kafka-ui redis database pgadmin

# Wait for services to be healthy (check with)
docker-compose ps
```

#### 3.2 Verify Infrastructure

- **PostgreSQL**: [http://localhost:5050](http://localhost:5050) (pgAdmin)
  - Email: `admin@admin.com`
  - Password: `admin`
- **Kafka UI**: [http://localhost:9000](http://localhost:9000)
- **Redis**: `localhost:6379`

### Step 4: Backend Services Setup

#### 4.1 Build All Backend Projects

```bash
# Build the entire backend (from root)
./gradlew build

# Or build individually
cd backend
./gradlew build
```

#### 4.2 Start Core Services (Order is Important!)

##### Config Server (Start First)

```bash
# Start Config Server first (other services depend on it)
docker-compose up -d config-server

# Wait for health check to pass
docker-compose logs -f config-server
```

**URL**: [http://localhost:8888](http://localhost:8888)

##### Discovery Server (If implemented)

```bash
# Build and start discovery server
cd backend/core/discovery-server
./gradlew bootRun
```

##### Gateway

```bash
# Start API Gateway
docker-compose up -d gateway

# Check gateway logs
docker-compose logs -f gateway
```

**URL**: [http://localhost:8080](http://localhost:8080)

#### 4.3 Start Business Services

##### Security Service

```bash
# Start Security Service
docker-compose up -d security-server

# Monitor startup
docker-compose logs -f security-server
```

**URLs**:

- REST API: [http://localhost:8082](http://localhost:8082)
- gRPC: `localhost:9082`

##### Core Service

```bash
# Build and start core service
cd backend/services/core
./gradlew bootRun

# Or with Docker (if Dockerfile exists)
docker build -t core-service .
docker run -p 8083:8083 --network ecommerce_default core-service
```

##### Identity Service

```bash
# Build and start identity service
cd backend/core/identity
./gradlew bootRun
```

### Step 5: Frontend Setup

#### 5.1 Install Dependencies

```bash
cd frontend
npm install
# or
yarn install
```

#### 5.2 Start Development Server

```bash
# Start Angular development server
npm start
# or
ng serve

# Or start with specific configuration
npm run start:dev
```

**URL**: [http://localhost:4200](http://localhost:4200)

### Step 6: Verification & Testing

#### 6.1 Health Checks

```bash
# Check all service health
curl http://localhost:8888/actuator/health  # Config Server
curl http://localhost:8080/actuator/health  # Gateway
curl http://localhost:8082/actuator/health  # Security Service

# Check through gateway
curl http://localhost:8080/health/config_server/status
curl http://localhost:8080/health/gateway/status
curl http://localhost:8080/health/security/status
```

#### 6.2 Service Discovery Verification

```bash
# Check registered services (if using Eureka)
curl http://localhost:8761/eureka/apps
```

#### 6.3 Database Verification

- Access pgAdmin: [http://localhost:5050](http://localhost:5050)
- Verify databases are created: `security`, `core`, `identity`

## 🚀 Quick Start (For Development)

### Full Stack Startup (Recommended Order)

```bash
# 1. Start infrastructure
docker-compose up -d zookeeper kafka kafka-ui redis database pgadmin

# 2. Start core services
docker-compose up -d config-server
sleep 30  # Wait for config server
docker-compose up -d gateway

# 3. Start business services
docker-compose up -d security-server

# 4. Start frontend
cd frontend && npm start

# 5. Verify everything is running
docker-compose ps
```

### Development Mode (Local Services)

```bash
# Infrastructure only
docker-compose up -d zookeeper kafka kafka-ui redis database pgadmin

# Run services locally
cd backend/core/config_server && ./gradlew bootRun &
cd backend/core/gateway && ./gradlew bootRun &
cd backend/services/security && ./gradlew bootRun &
cd frontend && npm start &
```

## � Development Instructions

### Working with Submodules

```bash
# Update all submodules to latest
git submodule update --remote

# Work on a specific submodule
cd backend/services/security
git checkout -b feature/new-feature
# Make changes...
git add .
git commit -m "feat: add new feature"
git push origin feature/new-feature
```

### Building Specific Services

```bash
# Build only commons library
cd backend/libs/commons
./gradlew publishToMavenLocal

# Build security service
cd backend/services/security
./gradlew build

# Build with dependencies
./gradlew build --refresh-dependencies
```

### Running Tests

```bash
# Run all tests
./gradlew test

# Run tests for specific service
cd backend/services/security
./gradlew test

# Run integration tests
./gradlew integrationTest
```

## 📚 Service Endpoints Reference

### Core Infrastructure

| Service | Port | Health Check | Purpose |
|---------|------|--------------|---------|
| Config Server | 8888 | `/actuator/health` | Configuration management |
| Gateway | 8080 | `/actuator/health` | API Gateway & routing |
| Discovery Server | 8761 | `/actuator/health` | Service registry |

### Business Services

| Service | Port | gRPC Port | Health Check | Purpose |
|---------|------|-----------|--------------|---------|
| Security | 8082 | 9082 | `/actuator/health` | Authentication & authorization |
| Core | 8083 | 9083 | `/actuator/health` | Core business logic |
| Identity | 8084 | 9084 | `/actuator/health` | User identity management |

### Frontend & Tools

| Service | Port | Purpose |
|---------|------|---------|
| Frontend | 4200 | Angular application |
| pgAdmin | 5050 | Database administration |
| Kafka UI | 9000 | Kafka management |

## 🔐 Environment Configuration

### Create Environment File

```bash
# Create .env file in root directory
cp .env.example .env
```

### Required Environment Variables

```env
# Database
DB_HOST=database
DB_PORT=5432
DB_USER=postgres
DB_PASSWORD=postgres

# Redis
REDIS_HOST=redis
REDIS_PORT=6379
REDIS_PASSWORD=password

# Kafka
KAFKA_BOOTSTRAP_SERVERS=kafka:9092

# JWT
JWT_SECRET=your-secret-key
JWT_EXPIRATION=86400

# Spring Profiles
SPRING_PROFILES_ACTIVE=dev
```

## 🚨 Troubleshooting

### Common Issues

#### Submodule Issues

```bash
# Reset submodules if they're out of sync
git submodule deinit --all
git submodule update --init --recursive

# Force update problematic submodule
git submodule update --init --force backend/libs/commons
```

#### Docker Issues

```bash
# Clean up Docker containers and volumes
docker-compose down -v
docker system prune -f

# Rebuild containers
docker-compose build --no-cache
docker-compose up -d
```

#### Port Conflicts

```bash
# Check what's using ports
netstat -tulpn | grep :8080
# Windows: netstat -ano | findstr :8080

# Kill process using port (Linux/Mac)
sudo lsof -ti:8080 | xargs kill -9
# Windows: taskkill /F /PID <PID>
```

#### Database Connection Issues

```bash
# Reset database
docker-compose down database
docker volume rm ecommerce_postgres-data
docker-compose up -d database
```

## 📝 Notes

- **Service Startup Order**: Config Server → Gateway → Business Services → Frontend
- **Dependencies**: Services depend on Config Server for configuration
- **Database**: PostgreSQL with multiple databases for each service
- **Messaging**: Kafka for asynchronous communication
- **Caching**: Redis for session management and caching
- **Security**: JWT-based authentication with role-based authorization
