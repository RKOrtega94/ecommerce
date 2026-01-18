# Dev Container Setup - All Services Auto-Start

## Overview
The dev container is now configured to automatically start all infrastructure and Spring Boot services on container initialization.

## Architecture
- **Main Dev Container**: `.devcontainer/compose.yml` defines `dev-container` service
- **Included Services**: 
  - Infrastructure: postgres, pgadmin, redis, kafka, kafka-ui, vault
  - Spring Boot Apps: config-server, discovery-server, gateway, global, electronic-signatures
- **Compose Includes**: `.devcontainer/compose.yml` now includes `../backend/compose.yaml` to pull in all Spring services

## Services Auto-Started (via runServices)
```
Infrastructure:
  ✓ postgres          (5432)   - PostgreSQL database
  ✓ pgadmin           (5050)   - Database UI
  ✓ redis             (6379)   - Cache/Session store
  ✓ kafka             (9092)   - Event streaming (also 9093, 9094)
  ✓ kafka-ui          (9000)   - Kafka management UI
  ✓ vault             (8200)   - Secrets management

Spring Boot Applications:
  ✓ config-server     (8888)   - Configuration management
  ✓ discovery-server  (8761)   - Service registry (Eureka)
  ✓ gateway           (8080)   - API Gateway
  ✓ global            (8082)   - Global Service
  ✓ electronic-signatures (8081) - E-Signature Service
```

## Port Forwarding
All ports are automatically forwarded to your local machine:

| Service | Port | Access URL |
|---------|------|------------|
| PgAdmin | 5050 | http://localhost:5050 |
| PostgreSQL | 5432 | localhost:5432 |
| Redis | 6379 | localhost:6379 |
| Vault | 8200 | http://localhost:8200 |
| Kafka UI | 9000 | http://localhost:9000 |
| Config Server | 8888 | http://localhost:8888 |
| Eureka Dashboard | 8761 | http://localhost:8761 |
| Gateway Server | 8080 | http://localhost:8080 |
| Electronic Signatures | 8081 | http://localhost:8081 |
| Global Service | 8082 | http://localhost:8082 |
| Java Debug | 5005 | localhost:5005 |
| Kafka (broker) | 9092 | localhost:9092 |
| Kafka (internal) | 9094 | localhost:9094 |
| LiveReload | 35729 | localhost:35729 |

## Auto-Open Previews
The following ports will automatically open in VS Code previews on devcontainer start:
- Gateway Server (8080)
- Eureka Dashboard (8761)
- PgAdmin (5050)
- Kafka UI (9000)

## Volumes & Live Reload
- Workspace mounted at `/workspace` with Spring DevTools enabled
- Source code changes trigger automatic restart via Spring DevTools
- Gradle cache persisted via `gradle-cache` volume
- Maven cache persisted via `~/.m2` mount

## Startup Flow
1. Dev container starts `dev-container` service
2. `runServices` brings up all configured services in dependency order
3. Infrastructure services start first (postgres → kafka → vault → redis)
4. Spring Boot services start after their dependencies are healthy
5. Health checks validate each service before marking as ready
6. `postStartCommand` displays summary banner with all service URLs

## Environment Variables
All services are configured with:
- Spring profiles: `dev` (in dev-container), `default` (in app services)
- Database credentials: postgres/postgres
- Config Server URL: http://config-server:8888
- Discovery URL: http://discovery-server:8761/eureka/
- Kafka Bootstrap: kafka:9094
- DevTools enabled with live reload

## Troubleshooting

### Services fail to start
1. Check resource limits (Docker Desktop settings - min 4GB RAM recommended)
2. View logs: `docker compose logs <service-name>`
3. Ensure ports aren't in use on host: `netstat -an | grep <port>`

### Config Server unavailable
- Config Server depends on all infra services
- Wait 30-60 seconds for health checks to pass
- Check: `curl http://localhost:8888/health/config-server/status`

### Gateway Server errors
- Depends on: postgres, redis, kafka, config-server, discovery-server
- Check Eureka at: http://localhost:8761 (should show all services)
- Check logs: `docker compose logs gateway`

### Database connection issues
- PostgreSQL may take 30 seconds to initialize
- Check: `psql -h localhost -U postgres -d postgres -c "SELECT 1"`
- Connection string: `postgresql://postgres:postgres@localhost:5432/postgres`

## Files Modified
- `.devcontainer/compose.yml` - Added include for `../backend/compose.yaml`
- `.devcontainer/devcontainer.json` - Added runServices and expanded forwardPorts

## Next Steps
1. Rebuild dev container: `Dev Containers: Rebuild Container`
2. Wait for all services to start (2-3 minutes)
3. Check port forwarding in VS Code Ports view
4. Access services from localhost URLs above

