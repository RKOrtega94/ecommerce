# DevContainer Fixes - January 13, 2026

## Issues Resolved

### 1. **Docker Compose Include Conflicts** ✅
**Problem**: Multiple service definition conflicts when including compose files
- `services.postgres conflicts with imported resource`
- `services.redis conflicts with imported resource`
- `services.pgadmin conflicts with imported resource`
- And similar conflicts for kafka, vault, and other services

**Root Cause**: The `.devcontainer/compose.yml` was including multiple service files:
- `./postgres/compose.yml` (defined postgres, pgadmin)
- `./redis/compose.yml` (defined redis)
- `./kafka/compose.yml` (defined kafka, kafka-ui)
- `./vault/compose.yml` (defined vault)
- `../backend/compose.yaml` (ALSO defined all the above)

This created duplicate service definitions which Docker Compose rejects.

**Solution**: 
- Removed redundant individual service includes from `.devcontainer/compose.yml`
- Kept only `../backend/compose.yaml` as the single source of truth for all infrastructure services
- Removed the custom `dev-network` definition and let compose use the default network

**File Changed**: `.devcontainer/compose.yml`

### 2. **Redis Unhealthy - Corrupted Data Volume** ✅
**Problem**: Redis container failed to start with health check errors
```
Can't handle RDB format version 12
Error reading the RDB base file appendonly.aof.1.base.rdb, AOF loading aborted
Unrecoverable error reading the append only file
```

**Root Cause**: Corrupted RDB data files in the redis volume from previous runs with incompatible redis versions.

**Solution**:
- Removed corrupted volume: `docker volume rm backend_redis_data devcontainer_redis_data`
- Force-removed stale containers: `docker rm -f redis`
- Fresh data volume created on next start with clean initialization

**Result**: Redis now starts successfully and passes health checks immediately

### 3. **Port Conflicts - App Services Binding to Dev Container Ports** ✅
**Problem**: Port 8888 (and others) conflicts when trying to start dev-container with gradle services

**Root Cause**: The `devcontainer.json` configured `runServices` to start both:
- Infrastructure services (postgres, redis, etc.) ✅ correct
- Gradle app services (config-server, discovery-server, gateway, etc.) ❌ incorrect

This caused port conflicts because both the infrastructure AND the dev-container were trying to use the same ports.

**Solution**:
- Updated `devcontainer.json` to only run infrastructure services in `runServices`
- App services should run **inside** the dev-container via gradle, not as separate compose services
- Removed from `runServices`:
  - config-server (port 8888)
  - discovery-server (port 8761)
  - gateway (port 8080)
  - global (port 8082)
  - electronic-signatures (port 8081)

**File Changed**: `.devcontainer/devcontainer.json`

## Current Configuration

### Infrastructure Services (Running as Docker services):
- **postgres** (port 5432) - healthy ✅
- **redis** (port 6379) - healthy ✅
- **kafka** (ports 9092-9094) - healthy ✅
- **kafka-ui** (port 9000) - running ✅
- **vault** (port 8200) - healthy ✅
- **pgadmin** (port 5050) - running ✅

### Application Services (Run inside dev-container):
- config-server (port 8888)
- discovery-server (port 8761)
- gateway-server (port 8080)
- auth-service (port 8081)
- global-service (port 8082)
- electronic-signature-service (port 8081)

## Verification

All services verified working:
```bash
✅ docker compose config        # Valid YAML, no conflicts
✅ docker compose ps            # All services healthy/running
✅ redis-cli ping               # PONG
✅ redis-cli INFO server        # Redis responding
✅ psql -U postgres -h localhost  # Postgres accessible
```

## Files Modified

1. **`.devcontainer/compose.yml`**
   - Removed: Individual service includes (postgres, redis, kafka, vault)
   - Added: Single include for `../backend/compose.yaml`
   - Removed: Custom `dev-network` definition

2. **`.devcontainer/devcontainer.json`**
   - Updated `runServices` array
   - Removed: config-server, discovery-server, gateway, global, electronic-signatures
   - Kept: postgres, pgadmin, redis, kafka, kafka-ui, vault

## Next Steps

When starting the dev-container:
1. Infrastructure services will auto-start (postgres, redis, kafka, vault, pgadmin)
2. Inside the dev-container, you can run:
   ```bash
   gradle :core:config-server:bootRun
   gradle :core:discovery-server:bootRun
   gradle :core:gateway-server:bootRun
   # etc.
   ```
3. Or use the Gradle dashboard in VS Code to run services individually

## Cleanup Commands

If you encounter issues in the future:
```bash
# Complete reset
docker compose down -v

# Just rebuild compose files
docker compose config

# Test redis specifically
docker compose up -d redis
docker exec redis redis-cli ping
```

