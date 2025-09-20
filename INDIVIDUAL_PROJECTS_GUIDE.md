# Individual Gradle Projects Guide

## Overview

Your ecommerce project has been refactored from a multi-project Gradle build to individual standalone Gradle projects. Each service and library can now be built and deployed independently.

## Project Structure

### Core Services (backend/core/)
- **config-server**: Spring Cloud Config Server
- **discovery-server**: Eureka Discovery Server  
- **gateway**: Spring Cloud Gateway
- **identity**: Identity and Authentication Service

### Business Services (backend/services/)
- **security**: Security and User Management Service

### Libraries (backend/libs/)
- **commons**: Common utilities and shared code
- **grpc-common**: gRPC common configurations and proto files

## Building Individual Projects

Each project can now be built independently:

```bash
# Build config server
cd backend/core/config_server
./gradlew build

# Build discovery server
cd backend/core/discovery-server
./gradlew build

# Build gateway
cd backend/core/gateway
./gradlew build

# Build identity service
cd backend/core/identity
./gradlew build

# Build security service  
cd backend/services/security
./gradlew build

# Build commons library
cd backend/libs/commons
./gradlew build publishToMavenLocal

# Build grpc-common library
cd backend/libs/grpc-common  
./gradlew build publishToMavenLocal
```

## Dependencies Between Projects

### Library Dependencies
Projects that depend on the shared libraries use Maven coordinates:

- **commons library**: `com.rkortega.libs:commons:1.0.0-SNAPSHOT`
- **grpc-common library**: `com.rkortega.libs:grpc-common:1.0.0-SNAPSHOT`

### Publishing Libraries
Before building projects that depend on the libraries, publish them to your local Maven repository:

```bash
# Publish commons library
cd backend/libs/commons
./gradlew publishToMavenLocal

# Publish grpc-common library  
cd backend/libs/grpc-common
./gradlew publishToMavenLocal
```

## Docker Build Process

The Docker containers can still be built using the same process since they copy JAR files from the `build/libs/` directory:

```bash
# Build individual service
cd backend/core/discovery-server
./gradlew build

# Build Docker image (from root directory)
docker compose build discovery-server
```

## Benefits of Individual Projects

1. **Independent Development**: Teams can work on different services independently
2. **Faster Builds**: Only build what you need to change
3. **Independent Deployments**: Deploy services independently
4. **Cleaner Dependencies**: Explicit external dependencies instead of project dependencies
5. **Better CI/CD**: Each project can have its own build pipeline
6. **Easier Testing**: Test individual components in isolation

## Migration from Multi-Project Build

### What Changed
- Each project now has its own `build.gradle` with complete dependency definitions
- Inter-project dependencies converted to Maven dependencies
- Each project has its own Gradle wrapper for independent builds
- Library projects now publish to Maven local repository

### What Stayed the Same
- Source code structure remains unchanged
- Docker configurations remain compatible
- Runtime behavior is identical
- Configuration files and properties unchanged

## Recommended Development Workflow

1. **Library Changes**: 
   - Make changes to commons or grpc-common libraries
   - Build and publish: `./gradlew publishToMavenLocal`
   - Update version if needed

2. **Service Changes**:
   - Make changes to individual services
   - Build independently: `./gradlew build`
   - Test locally or build Docker image

3. **Full System Build**:
   - Build all libraries first
   - Then build all services
   - Use Docker Compose for integration testing

## Troubleshooting

### Build Failures
- Ensure libraries are published to Maven local before building dependent services
- Check that all required dependencies are explicitly declared in each `build.gradle`

### Docker Issues
- Make sure to build the Gradle project before building Docker image
- Verify JAR files exist in `build/libs/` directory

### Dependency Issues  
- Use `./gradlew dependencies` to debug dependency resolution
- Check Maven local repository in `~/.m2/repository/` for published libraries

## Next Steps

Consider setting up:
- Maven repository server (like Nexus) for shared library artifacts
- CI/CD pipelines for each individual project
- Version management strategy for libraries
- Automated testing for individual components