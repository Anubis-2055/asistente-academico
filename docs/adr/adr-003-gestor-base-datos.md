# ADR-003: Gestor de base de datos

## Title
Elección de PostgreSQL 16 como motor de base de datos relacional.

## Status
Aceptada

## Context
El sistema requiere un motor relacional que soporte: integridad
referencial estricta entre entidades académicas (usuarios, materias,
tareas, calificaciones, avisos), procedimientos almacenados/funciones
parametrizadas para operaciones que no son CRUD elemental (JOIN,
agregación, actualización masiva — exigido por A.2.2), y que sea
software libre sin costo de licenciamiento.

Alternativas consideradas:
- **MySQL/MariaDB**: descartado porque su soporte de funciones/
  procedimientos almacenados con `RETURNS TABLE` y tipos compuestos es
  más limitado que el de PostgreSQL, lo cual dificultaba las funciones
  de agregación del dashboard (ver `fn_obtener_resumen_academico`).
- **SQL Server**: descartado por licenciamiento comercial no viable para
  un proyecto académico que además debe ser reproducible sin
  restricciones de licencia (Bloque B/E).
- **PostgreSQL 16 (elegido)**: soporte maduro de PL/pgSQL, funciones que
  retornan conjuntos de filas, tipos `NUMERIC` con precisión exacta
  (relevante para promedios de calificaciones), y es software libre.

## Decision
Se adopta **PostgreSQL 16** como motor de base de datos, con el esquema
aplicado exclusivamente desde `db/schema.sql` (contenedor Docker) y
migraciones versionadas con Flyway (`src/main/resources/db/migration/`)
para desarrollo local — nunca mediante
`spring.jpa.hibernate.ddl-auto=update`.

## Consequences
**Positivas:**
- Funciones SQL con `RETURNS TABLE` permiten proyecciones (DTOs) que no
  corresponden a ninguna entidad JPA, requeridas para el dashboard.
- Sin costo de licenciamiento; reproducible por terceros sin
  restricciones.

**Negativas / trade-offs:**
- El equipo tuvo menos experiencia previa con PL/pgSQL que con T-SQL de
  SQL Server (usado en cursos anteriores de Base de Datos), lo que
  implicó una curva de aprendizaje adicional al escribir las funciones
  del Bloque A.2.
- Se detectó y corrigió durante el desarrollo un problema de duplicidad
  de tablas por sensibilidad a mayúsculas/minúsculas en identificadores
  no citados (Hibernate genera SQL sin comillas, PostgreSQL pliega a
  minúscula); se estandarizó todo el esquema a minúsculas sin comillas
  para evitar este problema de forma permanente.

## Referencias
- `db/schema.sql`, `src/main/resources/db/migration/V1__schema_inicial.sql`
