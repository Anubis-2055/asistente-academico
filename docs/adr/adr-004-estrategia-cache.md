# ADR-004: Estrategia de caché

## Title
Uso de Redis como almacén de caché para blacklist de tokens JWT
revocados por logout.

## Status
Aceptada

## Context
El esquema de autenticación stateless (ADR-002) necesita un mecanismo de
revocación de tokens que sea de baja latencia y no dependa de la propia
base de datos relacional (para no acoplar la autenticación al
rendimiento de las consultas de negocio).

Alternativas consideradas:
- **Tabla de blacklist en PostgreSQL**: descartado porque cada petición
  autenticada tendría que hacer una consulta SQL adicional, agregando
  latencia y carga a la base de datos principal en cada request.
- **Caché en memoria del propio proceso (ej. `ConcurrentHashMap`)**:
  descartado porque no sobrevive un reinicio del backend y no funciona
  si el sistema escala a múltiples instancias (cada instancia tendría su
  propia blacklist, inconsistente entre sí).
- **Redis (elegido)**: almacén clave-valor en memoria, con soporte
  nativo de expiración (TTL) que coincide naturalmente con la expiración
  del propio JWT, y compartido entre todas las instancias del backend.

## Decision
Se usa **Redis 7** exclusivamente para la blacklist de tokens revocados
por logout. Cada entrada se guarda como `blacklist:<token>` con TTL
igual al tiempo restante de expiración del JWT, de forma que Redis
"olvida" automáticamente el token cuando de todas formas ya habría
expirado por sí solo.

## Consequences
**Positivas:**
- Verificación de blacklist en O(1), de latencia mínima.
- Limpieza automática vía TTL, sin necesidad de un job de limpieza aparte.

**Negativas / trade-offs:**
- Introduce un componente de infraestructura adicional a operar (ver
  ADR-002 sobre la política fail-open ante caída de Redis).
- No se usa Redis para cachear respuestas de lectura frecuente (por
  ejemplo, el propio dashboard) en esta entrega; queda como mejora para
  la Entrega Final, documentado como deuda técnica.

## Referencias
- `src/main/java/.../service/RedisService.java`
- `docker-compose.yml` (servicio `redis`)
