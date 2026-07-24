# Changelog

Todos los cambios notables de este proyecto se documentan en este
archivo, siguiendo el formato de [Keep a Changelog](https://keepachangelog.com/es-ES/1.0.0/)
y [Semantic Versioning](https://semver.org/lang/es/) (ver `VERSIONING.md`).

## [0.9.0-rc] - 2026-07-24

### Added
- `db/schema.sql` y `db/seed.sql` aplicados automáticamente vía
  `docker-entrypoint-initdb.d` para reproducibilidad completa.
- 3 funciones SQL parametrizadas (`fn_obtener_resumen_academico`,
  `fn_listar_tareas_pendientes`, `fn_marcar_avisos_leidos`) cubriendo
  las 3 categorías obligatorias de operaciones no elementales (JOIN,
  agregación, actualización masiva).
- Endpoint `GET /api/dashboard` con resumen académico agregado.
- Endpoint `PUT /api/dashboard/avisos/marcar-leidos`.
- `Makefile` con objetivos `up`, `down`, `test`, `bench`, `audit`, `clean`.
- `docker-compose.yml` con imágenes fijadas por digest sha256.
- `docs/basedatos/CATALOGO-SP.md` documentando los procedimientos.
- `docs/requisitos/SRS.md` (SRS conforme a ISO/IEC/IEEE 29148).
- `docs/requisitos/historias/` — historias de usuario HU-01 a HU-04.
- `docs/adr/` — 6 Architecture Decision Records (ADR-001 a ADR-006).
- `docs/arquitectura/` — diagramas C4 (niveles 1-3, Structurizr DSL) y
  tabla de atributos de calidad ISO/IEC 25010.
- `docs/observaciones/OBSERVACIONES.md` — bitácora de observaciones de
  las Entregas 1A y 1B, 10/10 cerradas.
- `LICENSE` (MIT), `CITATION.cff`, `CONTRIBUTORS.md`.
- `docs/etica/ETHICS.md` y plantilla de consentimiento informado.
- `VERSIONING.md`.

### Fixed
- Corregido: duplicidad de tablas por sensibilidad a mayúsculas en
  identificadores no citados (esquema estandarizado a minúsculas).
- Corregido: `RedisService.estaEnBlacklist()` ahora falla en modo
  "abierto" (fail-open) ante una caída de Redis, en vez de bloquear
  toda la autenticación del sistema.
- Corregido: build de Docker ya no depende de que `mvnw` descargue
  Maven en tiempo de construcción (usa imagen con Maven preinstalado).

### Security
- Confirmado: ninguna consulta a las tres funciones SQL concatena
  entrada de usuario; todas usan parámetros nombrados y tipados.

## [0.7.1] - 2026-07-19

### Fixed
- Cierre de las observaciones de las Entregas 1A y 1B: justificación de
  tecnologías del diagrama C4, corrección del DDL de base de datos,
  filtro JWT registrado, blacklist de Redis, CRUD de Tarea expuesto,
  Flyway incorporado, CORS restringido a orígenes explícitos.

## [0.7.0] - 2026-06-14 (semana)

### Added
- Módulo de autenticación JWT (registro y login).
- CRUD de Tarea con paginación.
- 5 pruebas JUnit de autenticación.
- Frontend HTML estático (login, registro, dashboard, chatbot).
- Docker Compose inicial.

## [0.3.0] - 2026-06-04 (semana)

### Added
- Corpus de ingeniería de requisitos inicial.
- Diagrama de arquitectura C4 Nivel 1.
- Modelo de base de datos (9 entidades).
- Wireframes de las 4 pantallas principales.
- Planificación del proyecto (Gantt).
