# ADR-006: Estrategia de acceso a datos (ORM vs. procedimientos almacenados)

## Title
Separación estricta entre CRUD elemental (Spring Data JPA / ORM) y
operaciones complejas (funciones SQL en PostgreSQL), según la
especificación Jakarta Persistence 2.1.

## Context
La guía de la Tercera Entrega exige (Bloque A.2) que el sistema adopte
una estrategia híbrida de acceso a datos, donde las consultas simples se
resuelvan vía ORM y toda operación con JOIN, agregación, actualización
masiva, o proyecciones que no correspondan a una entidad JPA, se
encapsule en procedimientos/funciones SQL versionadas.

Alternativas consideradas:
- **Todo vía ORM (incluyendo consultas complejas con JPQL/Criteria API)**:
  descartado porque la directriz de la asignatura lo prohíbe
  explícitamente para operaciones no elementales, y porque construir
  agregaciones complejas en JPQL resulta menos legible y más difícil de
  optimizar que en SQL nativo dentro de la base de datos.
- **Todo vía procedimientos almacenados (incluyendo CRUD simple)**:
  descartado por ser una sobre-ingeniería innecesaria; el CRUD elemental
  de una entidad (crear, leer por PK, listar paginado, actualizar por PK,
  borrado lógico) se resuelve de forma natural y seguro con Spring Data
  JPA sin necesidad de una función SQL dedicada.
- **Separación estricta según el tipo de operación (elegida)**: CRUD
  elemental vía `JpaRepository`/`CrudRepository`; todo lo demás vía
  funciones PL/pgSQL invocadas con `@Query(nativeQuery = true)` y
  parámetros nombrados.

## Decision
Se implementan 3 funciones SQL parametrizadas en `db/procs/`, cada una
cubriendo una de las categorías obligatorias de operaciones no
elementales: `fn_obtener_resumen_academico` (agregación con `COUNT`/
`AVG`/`MIN` sobre 3 tablas), `fn_listar_tareas_pendientes` (JOIN entre
`tareas` y `materia` con columna calculada), y `fn_marcar_avisos_leidos`
(actualización masiva sobre múltiples filas). Todas se invocan desde
`DashboardRepository` mediante `@Query(nativeQuery = true)` con
parámetros nombrados (`:idUsuario`), sin concatenación de entrada de
usuario en ningún caso. Cada función está documentada en
`docs/basedatos/CATALOGO-SP.md`.

## Consequences
**Positivas:**
- Elimina por diseño el riesgo de inyección SQL en las operaciones
  complejas, ya que las funciones PL/pgSQL con parámetros tipados no
  permiten construir SQL dinámico a partir de la entrada.
- La lógica de agregación vive en la base de datos, más cercana a los
  datos, reduciendo el volumen de datos transferido al backend.

**Negativas / trade-offs:**
- Depuración más difícil: los errores dentro de una función PL/pgSQL no
  siempre son tan claros en los logs de Spring Boot como una excepción
  de Java, y requieren revisar el log de PostgreSQL o probar la función
  directamente en SQL.
- Duplicación potencial de lógica de negocio entre el backend y las
  funciones SQL si no se documentan bien (mitigado con el catálogo).

## Referencias
- `db/procs/*.sql`, `docs/basedatos/CATALOGO-SP.md`
- `src/main/java/.../repository/DashboardRepository.java`
