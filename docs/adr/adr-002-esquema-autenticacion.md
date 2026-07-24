# ADR-002: Esquema de autenticación

## Title
Autenticación stateless con JWT firmado (HS256) validado en un filtro
`OncePerRequestFilter`, con revocación respaldada por blacklist en Redis.

## Status
Aceptada

## Context
El sistema necesita distinguir usuarios sin mantener sesiones en el
servidor (stateless, requerido desde la Entrega 1B), permitiendo escalar
horizontalmente sin sincronizar estado de sesión entre instancias. A la
vez, se necesita poder "cerrar sesión" de forma efectiva, lo cual es un
problema conocido de JWT (los tokens no pueden invalidarse por sí solos
antes de su expiración natural).

Alternativas consideradas:
- **Sesiones de servidor (cookies + HttpSession)**: descartado porque
  requiere estado compartido entre instancias si el sistema escala, y la
  directriz de la asignatura exige explícitamente un esquema stateless.
- **JWT sin mecanismo de revocación**: descartado porque un token robado
  o de un usuario deslogueado seguiría siendo válido hasta su expiración
  natural (24 horas), un riesgo de seguridad inaceptable.
- **JWT + blacklist en Redis (elegido)**: combina las ventajas de JWT
  stateless con revocación efectiva mediante una estructura de datos de
  baja latencia.

## Decision
Se emite un JWT firmado con HS256 al hacer login, con claims `sub`
(email), `rol`, `nombre`, `iat`, `exp`. Un filtro `JwtAuthFilter`
(`OncePerRequestFilter`) valida el token en cada petición y consulta
Redis para verificar que no esté en la blacklist de logout. Al cerrar
sesión, el token se agrega a la blacklist con TTL igual al tiempo
restante de expiración.

## Consequences
**Positivas:**
- Escalabilidad horizontal sin estado compartido de sesión.
- Revocación efectiva de tokens en logout.

**Negativas / trade-offs:**
- Introduce una dependencia externa (Redis) para la funcionalidad de
  logout; se mitigó con una política fail-open documentada en
  `RedisService.estaEnBlacklist()`: si Redis no está disponible, el
  sistema asume que el token no está revocado en vez de rechazar toda
  autenticación, priorizando disponibilidad sobre la revocación (que es
  una funcionalidad secundaria, no la validación principal del JWT).
- El JWT actual no incluye aún el claim `aud` (audiencia) ni `jti`
  (identificador único de token) exigidos por la especificación completa
  de RFC 7519 en el bloque A.1 de esta entrega; queda como observación
  pendiente para la Entrega Final.

## Referencias
- RFC 7519 (JSON Web Token).
- `src/main/java/.../security/JwtAuthFilter.java`
- `src/main/java/.../service/RedisService.java`
