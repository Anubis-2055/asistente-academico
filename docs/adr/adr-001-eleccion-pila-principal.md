# ADR-001: Elección de la pila tecnológica principal

## Title
Elección de Spring Boot + Java 21 (backend) y PostgreSQL + Redis (persistencia)
como pila principal del Asistente Virtual Académico.

## Status
Aceptada

## Context
El PFC requiere una API REST con autenticación stateless, acceso a datos
relacional con soporte de procedimientos almacenados, y un mecanismo de
caché/blacklist para revocación de tokens. El equipo necesitaba una pila
madura, con buena documentación, y compatible con las exigencias
académicas de la asignatura (Spring Data JPA, migraciones versionadas,
contenedores Docker).

Alternativas consideradas:
- **Node.js + Express + Sequelize**: descartado por menor soporte nativo
  para llamadas a procedimientos almacenados parametrizados equivalente
  al de Spring Data JPA (`@Procedure`, `@Query` nativo tipado).
- **Django + PostgreSQL**: descartado porque el equipo tiene más
  experiencia previa con Java/Spring de cursos anteriores de la carrera.
- **Spring Boot + Java 21 LTS**: elegido por soporte oficial de
  `@NamedStoredProcedureQuery`/`@Procedure` (Jakarta Persistence 2.1),
  ecosistema de seguridad maduro (Spring Security + JJWT), y continuidad
  con el stack usado en los cursos de Base de Datos y Aplicaciones Web.

## Decision
Se adopta **Spring Boot 3.5.x sobre Java 21 LTS** para el backend,
**PostgreSQL 16** como motor relacional principal, y **Redis 7** como
almacén de caché/blacklist para revocación de tokens JWT.

## Consequences
**Positivas:**
- Integración directa y bien documentada entre Spring Data JPA y
  procedimientos almacenados de PostgreSQL, requerida por la estrategia
  de acceso a datos del Bloque A.2.
- Java 21 LTS garantiza soporte a largo plazo, relevante porque el PFC
  se extiende varios meses.

**Negativas / trade-offs:**
- Mayor verbosidad de código comparado con alternativas como
  Node.js/Express para el mismo alcance funcional.
- Tiempo de arranque del backend (Spring Boot) más lento que frameworks
  más ligeros, notorio en el ciclo de desarrollo local.

## Referencias
- Ver `docs/arquitectura/justificacion-tecnologias.md` (justificación
  original de Gemini API y PostgreSQL, Entrega 1A / OBS-01).
