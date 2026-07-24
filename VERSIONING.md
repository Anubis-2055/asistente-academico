# Versionado — VERSIONING.md

Este proyecto adopta **Semantic Versioning 2.0.0** (SemVer) de forma
estricta desde la Tercera Entrega, conforme al Bloque E.4 de la guía.

## Regla MAJOR.MINOR.PATCH

Dado un número de versión `MAJOR.MINOR.PATCH`:

- **MAJOR** se incrementa cuando se hacen cambios incompatibles en la
  API (por ejemplo, cambiar la estructura de respuesta de un endpoint
  existente, o eliminar un endpoint).
- **MINOR** se incrementa al agregar funcionalidad nueva de forma
  compatible con versiones anteriores (por ejemplo, un nuevo endpoint,
  una nueva tabla que no rompe nada existente).
- **PATCH** se incrementa al corregir errores de forma compatible
  (por ejemplo, arreglar un bug de seguridad o un cálculo incorrecto,
  sin cambiar contratos de la API).

Se usa el sufijo `-rc` (release candidate) para versiones que aún no
son estables, como el estado actual del proyecto.

## Historial de versiones (tags)

| Versión | Fecha | Hito |
|---|---|---|
| `v0.3.0` | Semana del 4 de junio 2026 | Entrega 1A — corpus de requisitos, arquitectura C4 N1/N2, esqueleto ejecutable |
| `v0.7.0` | Semana del 14 de junio 2026 | Entrega 1B — módulo de autenticación JWT, CRUD de Tarea, Docker Compose |
| `v0.7.1` | 19 de julio 2026 | Cierre de observaciones de las Entregas 1A y 1B (Bloque 0 de la Entrega 3) |
| `v0.9.0-rc` | 24 de julio 2026 | Entrega 3 — reproducibilidad, evidencia empírica, trazabilidad, publicabilidad |
| `v1.0.0` | Semana del 17 de agosto 2026 (planeado) | Entrega Final — sistema estable, cobertura ≥ 70%, producción |

## Convención de commits

Los mensajes de commit siguen **Conventional Commits**:

- `feat:` — nueva funcionalidad
- `fix:` — corrección de errores
- `docs:` — cambios de documentación
- `chore:` — tareas de mantenimiento sin impacto en el código de producción
- `refactor:` — cambios de código que no agregan funcionalidad ni corrigen errores
- `test:` — agregar o corregir pruebas
- `perf:` — cambios que mejoran el rendimiento

Esto permite, en principio, generar el `CHANGELOG.md` de forma
semi-automática a partir del historial de commits.
