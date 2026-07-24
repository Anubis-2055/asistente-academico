# Changelog de Requisitos — CHANGELOG-REQ.md

Registro de cambios a los requisitos del sistema desde la Entrega 1A,
siguiendo la convención de [Keep a Changelog](https://keepachangelog.com/es-ES/1.0.0/)
adaptada a requisitos, conforme al Bloque A.3.4 de la guía.

## [Sin versionar] - 2026-07-20

### Added
- REQ-F-001 a REQ-F-006 (funcionales) y REQ-NF-001 a REQ-NF-004
  (no funcionales) documentados formalmente en `docs/requisitos/SRS.md`,
  consolidando lo implementado desde la Entrega 1B hasta hoy.
- REQ-F-006 (chatbot híbrido) documentado como requisito, aunque su
  implementación sigue pendiente — se mantiene visible en el backlog en
  vez de omitirse, conforme a la regla de la matriz de trazabilidad que
  permite estado "pendiente" para requisitos Should/Could, pero en este
  caso es un Must que se declara explícitamente como deuda técnica.
- REQ-NF-003 (resiliencia ante caída de Redis) agregado como requisito
  formal, derivado directamente de un defecto real encontrado y
  corregido durante el desarrollo (`RedisService.estaEnBlacklist()`).
- REQ-NF-004 (reproducibilidad automática) agregado como requisito
  formal, verificado con `make up` desde clonación limpia.

### Changed
- Ninguno — este es el primer registro formal de requisitos con este
  formato; los cambios previos (Entrega 1A → 1B) no fueron versionados
  con esta disciplina y no se pueden reconstruir retroactivamente con
  precisión, por lo que se declara aquí la fecha de inicio del registro.

### Motivo de los requisitos agregados

Los REQ-NF-003 y REQ-NF-004 no estaban en el diseño original del
sistema; surgieron como consecuencia directa de defectos reales
encontrados y corregidos durante el desarrollo de la Entrega 3 (caída de
Redis tumbando la autenticación completa; tablas duplicadas por
sensibilidad a mayúsculas rompiendo la reproducibilidad). Se documentan
como requisitos formales, no solo como "bugs corregidos", porque
representan propiedades del sistema que deben seguir cumpliéndose hacia
adelante y por tanto merecen verificación continua.

## Próximas actualizaciones esperadas

- Al implementar REQ-F-006 (chatbot), su estado cambiará de "pendiente"
  a "implementado" y luego "verificado", con la historia de usuario
  HU-04 y el caso de uso CU-04 ya redactados de antemano.
- Requisitos de usabilidad (derivados del Bloque C.3, SUS) y de
  accesibilidad (derivados del Bloque C.5, Lighthouse) se agregarán una
  vez ejecutadas esas pruebas.
