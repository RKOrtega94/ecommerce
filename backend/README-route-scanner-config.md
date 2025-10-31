# Route Scanner Configuration Guide

## Overview

The Route Scanner Component automatically detects and registers routes for your microservices. It supports both controller scanning and Swagger/OpenAPI route generation.

## Configuration Properties

### Basic Scanner Controls

```properties
# Enable/disable route scanners
route.scanner.swagger.enabled=true
route.scanner.controller.enabled=true
```

### Swagger Scanner Options

```properties
# Control which Swagger routes to include
route.scanner.swagger.include-webjars=false
route.scanner.swagger.include-swagger-resources=false
```

## What is `/webjars/**`?

**WebJars** are client-side web libraries (like jQuery, Bootstrap, etc.) packaged into JAR files. In the context of Swagger/OpenAPI:

- **Purpose**: Provides CSS, JavaScript, and static assets for Swagger UI
- **Content**: Includes `swagger-ui-bundle.js`, `swagger-ui-standalone-preset.js`, CSS files, etc.
- **Typical Path**: `/webjars/swagger-ui/`

## Configuration Options for WebJars

### Option 1: Disable WebJars Scanning (Recommended)

If you don't need to route WebJars through the gateway:

```properties
route.scanner.swagger.include-webjars=false
```

**Benefits:**
- ✅ Reduces route complexity
- ✅ Each service serves its own Swagger UI assets
- ✅ Better performance (no gateway routing overhead)

### Option 2: Enable WebJars Scanning

If you want centralized WebJars routing through the gateway:

```properties
route.scanner.swagger.include-webjars=true
```

**Use cases:**
- Centralized asset management
- Custom WebJars proxying
- Cross-service asset sharing

## Generated Routes

### When `include-webjars=true`:
- `/swagger-ui/**` → Swagger UI interface
- `/swagger-ui.html` → Swagger UI index page
- `/v3/api-docs/**` → OpenAPI documentation
- `/webjars/**` → Static assets (CSS, JS)
- `/swagger-resources/**` → Legacy Swagger resources
- `/v3/api-docs/swagger-config` → Swagger configuration

### When `include-webjars=false`:
- `/swagger-ui/**` → Swagger UI interface
- `/swagger-ui.html` → Swagger UI index page
- `/v3/api-docs/**` → OpenAPI documentation
- `/v3/api-docs/swagger-config` → Swagger configuration
- ~~`/webjars/**`~~ → **Not generated**
- ~~`/swagger-resources/**`~~ → **Not generated** (if also disabled)

## Examples

### Minimal Configuration (Recommended)
```properties
# Only scan controllers and basic Swagger routes
route.scanner.swagger.enabled=true
route.scanner.controller.enabled=true
route.scanner.swagger.include-webjars=false
route.scanner.swagger.include-swagger-resources=false
```

### Full Configuration
```properties
# Scan everything (more routes, more complexity)
route.scanner.swagger.enabled=true
route.scanner.controller.enabled=true
route.scanner.swagger.include-webjars=true
route.scanner.swagger.include-swagger-resources=true
```

### Documentation Only
```properties
# Only Swagger routes, no controller scanning
route.scanner.swagger.enabled=true
route.scanner.controller.enabled=false
route.scanner.swagger.include-webjars=false
route.scanner.swagger.include-swagger-resources=false
```

## Troubleshooting

### Issue: Swagger UI not loading properly
**Cause**: WebJars assets not accessible
**Solution**: Set `route.scanner.swagger.include-webjars=true`

### Issue: Too many routes being generated
**Cause**: All optional routes are enabled
**Solution**: Use minimal configuration with `include-webjars=false`

### Issue: Legacy Swagger not working
**Cause**: Swagger resources disabled
**Solution**: Set `route.scanner.swagger.include-swagger-resources=true`

## Logs

The scanner provides debug logs showing what routes are generated:

```
DEBUG Generated 4 Swagger routes for service: auth (webjars: false, swagger-resources: false)
DEBUG Skipped WebJars route for service: auth (disabled via configuration)
```

## Best Practices

1. **Use minimal configuration** unless you specifically need WebJars routing
2. **Monitor route count** to avoid gateway complexity
3. **Test Swagger UI** after disabling WebJars to ensure it still works
4. **Use service-specific properties** if different services need different configurations