# ===========================
# Stage 1: Dependencies Cache
# ===========================
FROM gradle:9.2.1-jdk25 AS dependencies

WORKDIR /app

# Copy only dependency-related files first (better layer caching)
COPY --chown=gradle:gradle gradle/ gradle/
COPY --chown=gradle:gradle gradlew build.gradle settings.gradle ./
COPY --chown=gradle:gradle libs/ libs/

# Download dependencies (cached unless dependency files change)
RUN gradle dependencies --no-daemon || true

# ===========================
# Stage 2: Build Application
# ===========================
FROM gradle:9.2.1-jdk25 AS builder

ARG LAYER
ARG SERVICE

WORKDIR /app

# Copy cached dependencies from previous stage
COPY --from=dependencies /home/gradle/.gradle /home/gradle/.gradle

# Copy all necessary files
COPY --chown=gradle:gradle gradle/ gradle/
COPY --chown=gradle:gradle gradlew build.gradle settings.gradle ./
COPY --chown=gradle:gradle libs/ libs/

# Create empty directories for ALL projects first (prevent Gradle configuration failures)
RUN grep "include" settings.gradle | \
    grep -oP "(?<=')[^']*(?=')" | \
    tr ':' '/' | \
    while read -r project_path; do \
        mkdir -p "$project_path/src/main/java" && \
        mkdir -p "$project_path/src/main/resources" && \
        echo 'plugins { id "java" }' > "$project_path/build.gradle" || true; \
    done

# Now copy the actual source for the target service
COPY --chown=gradle:gradle ${LAYER}/ ${LAYER}/

# Also copy the services directory (needed for all service modules)
COPY --chown=gradle:gradle core/ core/
COPY --chown=gradle:gradle services/ services/

# Build the specific service (skip tests for build stage)
RUN gradle :${LAYER}:${SERVICE}:dependencies --no-daemon && \
    gradle :${LAYER}:${SERVICE}:build --no-daemon -x test && \
    rm -rf /home/gradle/.gradle/caches/build-cache-* && \
    rm -rf /home/gradle/.gradle/caches/*/generated*

# ===========================
# Stage 3: Runtime (Optimized)
# ===========================
FROM eclipse-temurin:25-jre-alpine AS runtime

ARG LAYER
ARG SERVICE
ARG SERVER_PORT
ARG GRPC_PORT

# Metadata labels
LABEL application="${SERVICE}" \
      layer="${LAYER}" \
      version="${VERSION}"

WORKDIR /app

# Install security updates and required tools, then clean up
RUN apk update && \
    apk upgrade --no-cache && \
    apk add --no-cache dumb-init && \
    rm -rf /var/cache/apk/* && \
    addgroup -g 1001 -S spring && \
    adduser -u 1001 -S spring -G spring -h /app

# Copy only the built JAR (smallest possible layer)
COPY --from=builder --chown=spring:spring \
    /app/${LAYER}/${SERVICE}/build/libs/*.jar app.jar

# Security: Remove unnecessary permissions
RUN chmod 500 /app && \
    chmod 400 /app/app.jar

# Switch to non-root user
USER spring:spring

# Use dumb-init to properly handle signals and zombie processes
ENTRYPOINT ["/usr/bin/dumb-init", "--"]

# JVM flags for containerized environments
# Memory settings: UseContainerSupport, MaxRAMPercentage, InitialRAMPercentage
# Garbage Collection: UseG1GC, MaxGCPauseMillis
# Performance: OptimizeStringConcat, UseStringDeduplication
# Security: java.security.egd
# Monitoring: PrintCommandLineFlags
CMD ["java", \
     "-XX:+UseContainerSupport", \
     "-XX:MaxRAMPercentage=75.0", \
     "-XX:InitialRAMPercentage=50.0", \
     "-XX:+UseG1GC", \
     "-XX:MaxGCPauseMillis=200", \
     "-XX:+OptimizeStringConcat", \
     "-XX:+UseStringDeduplication", \
     "-Djava.security.egd=file:/dev/./urandom", \
     "-XX:+PrintCommandLineFlags", \
     "-jar", "app.jar"]

# Health check (adjust endpoint as needed)
HEALTHCHECK --interval=30s --timeout=3s --start-period=40s --retries=3 \
    CMD wget --no-verbose --tries=1 --spider http://localhost:${SERVER_PORT}/health/${SERVICE}/status || exit 1

EXPOSE ${SERVER_PORT} ${GRPC_PORT}