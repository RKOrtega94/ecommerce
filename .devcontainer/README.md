# Spring DevTools Configuration Guide

## Overview
This development environment is configured with Spring DevTools for hot-reload development, automatic restart, and LiveReload support.

## Infrastructure Services

### PostgreSQL
- **Port**: 5432
- **Database Names**: auth_db, security_db, global_service_db, electronic_signature_db, gateway_db
- **User**: postgres
- **Password**: postgres
- **PgAdmin**: http://localhost:5050 (admin@example.com / admin)

### Redis
- **Port**: 6379
- **Persistence**: Both RDB and AOF enabled
- **Max Memory**: 450MB with LRU eviction
- **Config**: `.devcontainer/redis/redis.conf`

### Kafka
- **Broker Port**: 9092 (external), 29092 (internal)
- **Zookeeper Port**: 2181
- **Auto-create Topics**: Enabled
- **Replication Factor**: 1 (development)

## Spring DevTools Features

### 1. Automatic Restart
- **Trigger**: Changes to Java files or resources
- **Poll Interval**: 2 seconds
- **Quiet Period**: 1 second
- **Excluded**: static files, templates, compiled classes

### 2. LiveReload
- **Port**: 35729
- **Browser Extension**: Install LiveReload browser extension
- **Auto-refresh**: Automatically refreshes browser on changes

### 3. Remote Debugging
- **Port**: 5005
- **Configuration**: Already configured in JAVA_TOOL_OPTIONS
- **IDE Setup**: Attach remote debugger to localhost:5005

### 4. Hot Code Replace
- **Enabled**: `java.debug.settings.hotCodeReplace=auto`
- **Supports**: Method body changes, adding methods (limited)

## Environment Variables

All services have access to these environment variables:

### Database
```bash
DATABASE_HOST=postgres
DATABASE_PORT=5432
DATABASE_USERNAME=postgres
DATABASE_PASSWORD=postgres
```

### Service-Specific Databases
```bash
AUTH_DB_NAME=auth_db
SECURITY_DB_NAME=security_db
GLOBAL_DB_NAME=global_service_db
ELECTRONIC_SIGNATURE_DB_NAME=electronic_signature_db
GATEWAY_DB_NAME=gateway_db
```

### Redis
```bash
SPRING_DATA_REDIS_HOST=redis
SPRING_DATA_REDIS_PORT=6379
REDIS_PASSWORD=""
```

### Kafka
```bash
SPRING_KAFKA_BOOTSTRAP_SERVERS=kafka:29092
```

### Service Discovery
```bash
CONFIG_SERVER_URL=http://localhost:8888
DISCOVERY_SERVER_URL=http://localhost:8761/eureka/
```

### DevTools
```bash
SPRING_DEVTOOLS_RESTART_ENABLED=true
SPRING_DEVTOOLS_LIVERELOAD_ENABLED=true
SPRING_DEVTOOLS_LIVERELOAD_PORT=35729
SPRING_DEVTOOLS_REMOTE_SECRET=mysecret
```

## Running Services

### Start All Infrastructure
The devcontainer automatically starts:
- PostgreSQL
- Redis
- Kafka + Zookeeper

### Run Individual Services

#### Config Server
```bash
cd /workspace/backend/core/config-server
gradle bootRun
```

#### Discovery Server (Eureka)
```bash
cd /workspace/backend/core/discovery-server
gradle bootRun
```

#### Gateway Server
```bash
cd /workspace/backend/core/gateway-server
gradle bootRun
```

#### Auth Service
```bash
cd /workspace/backend/core/auth-service
gradle bootRun
```

#### Security Service
```bash
cd /workspace/backend/services/security-service
gradle bootRun
```

## Resource Limits

### Development Container
- **CPUs**: 2 (limit), 1 (reservation)
- **Memory**: 4GB (limit), 2GB (reservation)

### Kafka
- **CPUs**: 2 (limit), 1 (reservation)
- **Memory**: 2GB (limit), 1GB (reservation)

### Zookeeper
- **CPUs**: 1 (limit), 0.5 (reservation)
- **Memory**: 256MB (limit), 128MB (reservation)

### Redis
- **CPUs**: 0.5 (limit), 0.25 (reservation)
- **Memory**: 512MB (limit), 256MB (reservation)

## Health Checks

All services have health checks configured:
- **PostgreSQL**: `pg_isready`
- **Redis**: `redis-cli ping`
- **Kafka**: `kafka-broker-api-versions`
- **Zookeeper**: `echo ruok | nc localhost 2181`

## Debugging

### Attach Remote Debugger (VS Code)

Create `.vscode/launch.json`:
```json
{
  "version": "0.2.0",
  "configurations": [
    {
      "type": "java",
      "name": "Attach to Dev Container",
      "request": "attach",
      "hostName": "localhost",
      "port": 5005
    }
  ]
}
```

### View Logs
```bash
# View service logs
tail -f /workspace/backend/logs/<service-name>.log

# View container logs
docker logs -f <container-name>
```

## Service URLs

After starting services:

- **Config Server**: http://localhost:8888
- **Eureka Dashboard**: http://localhost:8761
- **Gateway Server**: http://localhost:8080
- **Auth Service**: http://localhost:8081
- **PgAdmin**: http://localhost:5050

## Troubleshooting

### Services won't start
1. Check if infrastructure is healthy: `docker ps`
2. Verify health checks: All should show "healthy"
3. Check logs: `docker logs <service-name>`

### DevTools not reloading
1. Verify `spring-boot-devtools` is in dependencies
2. Check `SPRING_PROFILES_ACTIVE=dev` is set
3. Ensure files are being saved (not just in editor buffer)

### Out of Memory
1. Increase dev-container memory limit in `compose.yml`
2. Adjust JVM heap: `-Xmx2g` in JAVA_TOOL_OPTIONS
3. Check Gradle daemon memory usage

### Kafka connection issues
1. Use internal address: `kafka:29092` from containers
2. Use external address: `localhost:9092` from host
3. Wait for Kafka health check to pass (40s start period)

## Best Practices

1. **Start Order**: Config Server → Discovery Server → Other Services
2. **Database Migrations**: Run Flyway migrations before starting services
3. **Hot Reload**: Save files frequently to trigger DevTools restart
4. **Debugging**: Use remote debugging instead of adding `System.out.println`
5. **Resource Management**: Stop unused services to conserve resources

## Additional Configuration

### Custom Environment Variables
Add to `.devcontainer/compose.yml` under `environment:` section

### Custom Ports
Update both `compose.yml` ports mapping and `devcontainer.json` forwardPorts

### Additional Services
Create new compose file in `.devcontainer/<service>/compose.yml` and include in main `compose.yml`

