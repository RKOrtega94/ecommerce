# Spring DevTools & Infrastructure - Quick Reference

## 🚀 Quick Start Commands

```bash
# Rebuild DevContainer (after configuration changes)
# Command Palette → "Dev Containers: Rebuild Container"

# Start all services (automated script)
/workspace/.devcontainer/scripts/start-services.sh

# Start individual services manually
cd /workspace/backend/core/config-server && gradle bootRun
cd /workspace/backend/core/discovery-server && gradle bootRun
cd /workspace/backend/core/gateway-server && gradle bootRun
cd /workspace/backend/core/auth-service && gradle bootRun
cd /workspace/backend/services/security-service && gradle bootRun
```

## 🌐 Service URLs (After Startup)

| Service | URL | Description |
|---------|-----|-------------|
| Config Server | http://localhost:8888 | Centralized configuration |
| Eureka Dashboard | http://localhost:8761 | Service registry UI |
| Gateway Server | http://localhost:8080 | API Gateway |
| Auth Service | http://localhost:8081 | Authentication service |
| PgAdmin | http://localhost:5050 | PostgreSQL admin UI |
| PostgreSQL | localhost:5432 | Database server |
| Redis | localhost:6379 | Cache server |
| Kafka | localhost:9092 | Message broker |
| Zookeeper | localhost:2181 | Kafka coordination |

## 📊 Default Credentials

| Service | Username | Password |
|---------|----------|----------|
| PostgreSQL | postgres | postgres |
| PgAdmin | admin@example.com | admin |
| Redis | - | (no password) |

## 🗄️ Database Names

```
auth_db
security_db
global_service_db
electronic_signature_db
gateway_db
```

## 🔧 Environment Variables (Key Ones)

```bash
# Database
DATABASE_HOST=postgres
DATABASE_PORT=5432
DATABASE_USERNAME=postgres
DATABASE_PASSWORD=postgres

# Redis
SPRING_DATA_REDIS_HOST=redis
SPRING_DATA_REDIS_PORT=6379

# Kafka
SPRING_KAFKA_BOOTSTRAP_SERVERS=kafka:29092

# Service Discovery
CONFIG_SERVER_URL=http://localhost:8888
DISCOVERY_SERVER_URL=http://localhost:8761/eureka/

# DevTools
SPRING_DEVTOOLS_RESTART_ENABLED=true
SPRING_DEVTOOLS_LIVERELOAD_ENABLED=true
SPRING_DEVTOOLS_LIVERELOAD_PORT=35729
```

## 🐛 Debugging

```bash
# Attach debugger to port 5005
# In VS Code: Run → Start Debugging → "Attach to Dev Container"

# View service logs
tail -f /workspace/backend/logs/<service-name>.log

# View container logs
docker logs -f <container-name>

# Check service health
docker ps  # All should show "healthy"
```

## 🔄 Hot Reload

1. **Save Java file** → DevTools auto-restarts service (2-3 seconds)
2. **Browser with LiveReload** → Auto-refreshes on changes
3. **Hot code replace** → Method changes without restart (when debugging)

## 📦 Resource Usage

- Dev Container: 4GB RAM, 2 CPUs
- Kafka: 2GB RAM, 2 CPUs
- Redis: 512MB RAM, 0.5 CPU
- Zookeeper: 256MB RAM, 1 CPU

## 🆘 Common Issues

### Services won't start
```bash
docker ps  # Check if infrastructure is healthy
docker logs postgres
docker logs redis
docker logs kafka
```

### Out of memory
```bash
# Increase heap in compose.yaml
JAVA_TOOL_OPTIONS: -Xmx4g  # (default is 2g)
```

### Kafka connection fails
```bash
# Wait for Kafka to be healthy (40s startup)
docker logs kafka | grep "started"
```

### DevTools not reloading
```bash
# Verify profile is active
echo $SPRING_PROFILES_ACTIVE  # should be "dev"

# Check DevTools dependency in build.gradle
# developmentOnly 'org.springframework.boot:spring-boot-devtools'
```

## 📝 Useful Commands

```bash
# Build all projects
cd /workspace/backend && gradle clean build -x test

# Check infrastructure health
docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"

# Stop all services (if you started with script)
kill <PID1> <PID2> <PID3>  # PIDs from start script output

# Clean Gradle cache
cd /workspace/backend && gradle clean

# Check Kafka topics
docker exec -it kafka kafka-topics --bootstrap-server localhost:9092 --list

# Redis CLI
docker exec -it redis redis-cli

# PostgreSQL CLI
docker exec -it postgres psql -U postgres
```

## 📚 Documentation

- Full guide: `.devcontainer/README.md`
- Implementation details: `.devcontainer/IMPLEMENTATION_SUMMARY.md`
- Spring DevTools: `backend/properties/application-dev.properties`

## 💡 Pro Tips

1. Start Config Server first, then Discovery Server, then others
2. Wait for Eureka to show services before testing
3. Use remote debugging instead of logging
4. Install LiveReload browser extension for auto-refresh
5. Monitor resource usage: `docker stats`
6. Use PgAdmin for database management
7. Check Eureka dashboard to verify service registration
8. Kafka auto-creates topics on first use

---
**Need Help?** Check `.devcontainer/README.md` for detailed troubleshooting!

