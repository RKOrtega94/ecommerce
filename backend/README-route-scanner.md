# Gateway Route Scanner Library

Esta librería permite escanear automáticamente las rutas de los servicios Spring Boot **incluyendo documentación Swagger/OpenAPI** y enviarlas a Kafka para que el Gateway las procese y genere rutas dinámicas almacenadas en una base de datos H2.

## Características

- ✅ Escaneo automático de controladores REST
- ✅ **Escaneo automático de rutas Swagger/OpenAPI**
- ✅ **Agregador de documentación centralizado**
- ✅ Envío de configuración de rutas a Kafka
- ✅ Procesamiento automático en el Gateway
- ✅ Almacenamiento en base de datos H2
- ✅ Gestión de rutas dinámicas
- ✅ API REST para administración de rutas
- ✅ **Interfaz web para acceso a documentación agregada**

## Arquitectura

```
[Microservicio] -> [Route Scanner] -> [Kafka] -> [Gateway] -> [H2 Database] -> [Dynamic Routes]
                                                     ↓
[Swagger UI Aggregator] <- [http://localhost:8080/swagger-aggregator]
```

## Nuevas Funcionalidades - Swagger

### 🔄 Escaneo Automático de Swagger

La librería detecta automáticamente si un servicio tiene Swagger/OpenAPI configurado y genera las rutas necesarias:

```java
// ✅ Detecta automáticamente estas rutas:
/swagger-ui/**           → Swagger UI interface
/swagger-ui.html         → Swagger UI index  
/v3/api-docs/**          → OpenAPI JSON/YAML
/swagger-resources/**    → Swagger resources
/webjars/**              → UI assets
```

### 📊 Agregador Centralizado

El Gateway proporciona un punto único de acceso a toda la documentación:

**🏠 Página Principal**: `http://localhost:8080/swagger-aggregator`

**📖 Documentación por Servicio**:
- `http://localhost:8080/docs/{service}/swagger-ui/index.html`
- `http://localhost:8080/docs/{service}/v3/api-docs`

**🔗 Acceso Directo**:
- `http://localhost:8080/{service}/swagger-ui/index.html`

## Configuración

### 1. Para los Microservicios

Agregar las dependencias en el `build.gradle`:

```gradle
dependencies {
    implementation project(':libs:component-scan')
    implementation 'org.springframework.kafka:spring-kafka'
    
    // Para Swagger/OpenAPI (opcional pero recomendado)
    implementation 'org.springdoc:springdoc-openapi-starter-webmvc-ui:2.2.0'
}
```

Configurar `application.yml`:

```yaml
spring:
  application:
    name: tu-servicio
  kafka:
    bootstrap-servers: localhost:9092

route:
  scanner:
    enabled: true
    controller:
      enabled: true    # Escanea controladores REST
    swagger:
      enabled: true    # Escanea rutas de Swagger

# Configuración de Swagger (opcional)
springdoc:
  api-docs:
    enabled: true
    path: /v3/api-docs
  swagger-ui:
    enabled: true
    path: /swagger-ui.html
```

### 2. Para el Gateway

Dependencias necesarias en `build.gradle`:

```gradle
dependencies {
    implementation 'org.springframework.cloud:spring-cloud-starter-gateway'
    implementation 'org.springframework.boot:spring-boot-starter-data-jpa'
    implementation 'com.h2database:h2'
    implementation 'org.springframework.kafka:spring-kafka'
}
```

## Uso

### Automático

La librería se activa automáticamente cuando la aplicación está lista (`ApplicationReadyEvent`) y:

1. **Controladores REST**: Escanea todos los controladores en el paquete `ec.com.ecommerce`
2. **Rutas Swagger**: Detecta automáticamente si Swagger está disponible y genera rutas
3. Extrae las rutas y métodos HTTP
4. Genera configuraciones de rutas para el Gateway
5. Envía los mensajes a Kafka en el topic `gateway-route-config`

### Acceso a Documentación Swagger

Una vez que los servicios están registrados, puedes acceder a:

**🏠 Página Principal del Agregador**:
```
http://localhost:8080/swagger-aggregator
```

**📖 Swagger UI por Servicio**:
```
http://localhost:8080/docs/{service-name}/swagger-ui/index.html
```

**📄 OpenAPI JSON por Servicio**:
```
http://localhost:8080/docs/{service-name}/v3/api-docs
```

**🔗 Acceso Directo (si prefieres)**:
```
http://localhost:8080/{service-name}/swagger-ui/index.html
```

### Ejemplos Prácticos

Si tienes servicios llamados `auth-service`, `user-service`, y `order-service`:

- **Agregador**: `http://localhost:8080/swagger-aggregator`
- **Auth Docs**: `http://localhost:8080/docs/auth/swagger-ui/index.html`
- **User Docs**: `http://localhost:8080/docs/user/swagger-ui/index.html`
- **Order Docs**: `http://localhost:8080/docs/order/swagger-ui/index.html`

### Manual (API REST)

El Gateway expone endpoints para gestión manual:

```bash
# Ver todas las rutas
GET /admin/routes

# Ver rutas de un servicio específico
GET /admin/routes/service/{serviceName}

# Habilitar/deshabilitar una ruta
PUT /admin/routes/{routeId}/toggle?enabled=true

# Eliminar una ruta
DELETE /admin/routes/{routeId}

# Refrescar rutas
POST /admin/routes/refresh
```

## Formato de Mensajes

### RouteConfigMessage (Kafka)

```json
{
  "routeId": "auth-usercontroller",
  "uri": "lb://auth-service",
  "predicates": ["Path=/api/users/**"],
  "filters": ["StripPrefix=0"],
  "orderNum": 100,
  "description": "Auto-generated route for auth service - UserController",
  "enabled": true,
  "serviceName": "auth"
}
```

## Base de Datos

### Schema H2

```sql
CREATE TABLE routes (
    id VARCHAR(255) PRIMARY KEY,
    uri VARCHAR(500) NOT NULL,
    predicates VARCHAR(1000),
    filters VARCHAR(1000),
    order_num INTEGER,
    description VARCHAR(500),
    enabled BOOLEAN DEFAULT TRUE,
    service_name VARCHAR(255)
);
```

## Ejemplo de Controlador

```java
@RestController
@RequestMapping("/api/users")
public class UserController {
    
    @GetMapping
    public List<User> getUsers() {
        // Generará: Path=/api/users/**
    }
    
    @PostMapping
    public User createUser(@RequestBody User user) {
        // Incluido en: Path=/api/users/**
    }
}
```

## Monitoreo

### Logs

```bash
# Ver escaneo de rutas
grep "Scanning controllers" logs/application.log

# Ver mensajes Kafka
grep "Sent route configuration" logs/application.log

# Ver procesamiento en Gateway
grep "Processed route configuration" logs/gateway.log
```

### Consola H2

Acceder en: `http://localhost:8080/h2-console`
- JDBC URL: `jdbc:h2:mem:gateway`
- User: `sa`
- Password: (vacío)

```sql
-- Ver todas las rutas
SELECT * FROM routes;

-- Ver rutas por servicio
SELECT * FROM routes WHERE service_name = 'auth';

-- Ver rutas habilitadas
SELECT * FROM routes WHERE enabled = true;
```

## Troubleshooting

### Problema: Rutas no se generan

1. Verificar que Kafka esté ejecutándose
2. Verificar configuración de `spring.application.name`
3. Verificar que los controladores estén en el paquete `ec.com.ecommerce`

### Problema: Gateway no recibe rutas

1. Verificar configuración de Kafka en el Gateway
2. Verificar topic `gateway-route-config`
3. Verificar logs del listener

### Problema: Rutas no funcionan

1. Verificar que las rutas estén en la base de datos
2. Verificar que `enabled = true`
3. Ejecutar `POST /admin/routes/refresh`

## Desarrollo

### Testing

```bash
# Compilar la librería
./gradlew :libs:component-scan:build

# Ejecutar tests
./gradlew :libs:component-scan:test

# Ejecutar gateway
./gradlew :core:gateway-server:bootRun
```

### Extensiones

Para agregar nuevas funcionalidades:

1. Extender `ControllerScanner` para nuevos tipos de anotaciones
2. Modificar `RouteConfigMessage` para nuevos campos
3. Actualizar `DatabaseRouteDefinitionRepository` para nuevos filtros/predicados