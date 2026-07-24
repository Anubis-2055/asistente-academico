# ADR-005: Estrategia de despliegue

## Title
Orquestación de 4 servicios independientes (backend, PostgreSQL, Redis,
frontend estático vía Nginx) con Docker Compose, imágenes fijadas por
digest sha256.

## Context
La Entrega 3 exige reproducibilidad automática: un tercero debe poder
clonar el repositorio y levantar el sistema completo con un solo comando,
sin derivas entre lo que el equipo probó y lo que el revisor ejecuta.

Alternativas consideradas:
- **Instalación manual de cada componente** (Postgres, Redis, Java)
  documentada paso a paso: descartado por ser propenso a errores del
  entorno del revisor y no cumplir el requisito de "un solo comando".
- **Kubernetes**: descartado por ser una complejidad de orquestación
  innecesaria para un sistema de 4 contenedores en el alcance de un PFC
  académico.
- **Docker Compose con imágenes por tag variable** (ej. `postgres:16`):
  descartado porque un tag puede apuntar a una imagen distinta con el
  tiempo (la misma etiqueta se re-publica), rompiendo la reproducibilidad
  exacta exigida por el Bloque B.
- **Docker Compose con imágenes fijadas por digest sha256 (elegido)**:
  cada imagen se referencia por su huella criptográfica exacta, evitando
  cualquier deriva silenciosa entre corridas, incluso si el tag original
  cambia en el registro.

## Decision
Se usa **Docker Compose** con 4 servicios (`postgres`, `redis`,
`backend`, `frontend`), cada imagen base fijada por `@sha256:...` en vez
de por tag. El esquema y los datos semilla de PostgreSQL se aplican
exclusivamente vía `docker-entrypoint-initdb.d` (montando `db/schema.sql`,
las funciones de `db/procs/`, y `db/seed.sql`, en ese orden). Un
`Makefile` expone los objetivos `up`, `down`, `test`, `bench`, `audit`,
`clean` como interfaz única para el revisor.

## Consequences
**Positivas:**
- Reproducibilidad verificada de punta a punta: clonación limpia →
  `make up` → sistema funcional con datos de prueba, sin pasos manuales.
- El build del backend usa una imagen de Maven con Maven ya instalado
  (en vez de que `mvnw` lo descargue en tiempo de build), eliminando una
  dependencia de red que causó fallos intermitentes durante el
  desarrollo.

**Negativas / trade-offs:**
- Los digests deben actualizarse manualmente si se necesita una versión
  más reciente de alguna imagen base; no hay actualización automática
  (es la contrapartida deliberada de fijar por digest en vez de tag).
- El despliegue no incluye todavía un ambiente de producción públicamente
  accesible (exigido recién en la Entrega Final).

## Referencias
- `docker-compose.yml`, `Dockerfile`, `Makefile`, `.env.example`
