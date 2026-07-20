# Catálogo de Procedimientos Almacenados y Funciones SQL

Este catálogo documenta cada función/procedimiento SQL usado por el sistema,
conforme a la estrategia de acceso a datos del Bloque A.2 de la Entrega 3:
los CRUD elementales se resuelven vía ORM (Spring Data JPA), y toda
operación que implique JOIN, agregación, actualización masiva o
proyecciones que no correspondan a una entidad se encapsula aquí.

---

## fn_obtener_resumen_academico

- **Archivo:** `db/procs/fn_obtener_resumen_academico.sql`
- **Tipo:** Función (retorna tabla de 1 fila)
- **Propósito:** Calcula el resumen agregado del dashboard de un usuario:
  total de tareas pendientes, promedio general de calificaciones, total de
  avisos no leídos y fecha de la próxima entrega.
- **Parámetros de entrada:** `p_id_usuario INTEGER`
- **Parámetros de salida (columnas):** `tareas_pendientes INTEGER`,
  `promedio_general NUMERIC(4,2)`, `avisos_no_leidos INTEGER`,
  `proxima_entrega DATE`
- **Cursores devueltos:** Ninguno (retorna directamente una fila).
- **Tablas afectadas:** `tareas`, `calificaciones`, `avisos` (solo lectura).
- **Motivo de SP (no ORM):** combina agregaciones (`COUNT`, `AVG`, `MIN`)
  sobre tres tablas distintas en una sola proyección que no corresponde a
  ninguna entidad JPA.
- **Invocado desde:** `DashboardRepository.obtenerResumenAcademico()` vía
  `@Query(nativeQuery = true)` con parámetro nombrado `:idUsuario`.
- **Endpoint que lo usa:** `GET /api/dashboard`

---

## fn_listar_tareas_pendientes

- **Archivo:** `db/procs/fn_listar_tareas_pendientes.sql`
- **Tipo:** Función (retorna conjunto de filas)
- **Propósito:** Lista las tareas pendientes de un usuario con el nombre
  de su materia y los días restantes hasta la fecha de entrega.
- **Parámetros de entrada:** `p_id_usuario INTEGER`
- **Parámetros de salida (columnas):** `id_tarea INTEGER`,
  `titulo VARCHAR`, `materia VARCHAR`, `fecha_entrega DATE`,
  `dias_restantes INTEGER`
- **Cursores devueltos:** Ninguno (retorna un conjunto de filas directo).
- **Tablas afectadas:** `tareas`, `materia` (solo lectura, vía JOIN).
- **Motivo de SP (no ORM):** requiere JOIN entre `tareas` y `materia`, más
  una columna calculada (`dias_restantes`) que no existe en ninguna
  entidad JPA — es una proyección (DTO), no una entidad completa.
- **Invocado desde:** `DashboardRepository.listarTareasPendientes()` vía
  `@Query(nativeQuery = true)` con parámetro nombrado `:idUsuario`.
- **Endpoint que lo usa:** `GET /api/dashboard`

---

## fn_marcar_avisos_leidos

- **Archivo:** `db/procs/fn_marcar_avisos_leidos.sql`
- **Tipo:** Función (retorna escalar, con efecto de escritura)
- **Propósito:** Marca como leídos todos los avisos pendientes de un
  usuario en una sola operación, y devuelve cuántos fueron actualizados.
- **Parámetros de entrada:** `p_id_usuario INTEGER`
- **Parámetros de salida:** `INTEGER` (cantidad de filas actualizadas,
  obtenido con `GET DIAGNOSTICS ... ROW_COUNT`).
- **Cursores devueltos:** Ninguno.
- **Tablas afectadas:** `avisos` (escritura — `UPDATE`).
- **Motivo de SP (no ORM):** es una actualización masiva sobre múltiples
  filas seleccionadas por un criterio distinto de la clave primaria, por
  lo que no califica como CRUD elemental (A.2.1) y debe encapsularse como
  función (A.2.2).
- **Invocado desde:** `DashboardRepository.marcarAvisosLeidos()` vía
  `@Query(nativeQuery = true)` con parámetro nombrado `:idUsuario`. No usa
  `@Modifying` porque PostgreSQL la ejecuta como una función que retorna
  un valor (no como una sentencia `UPDATE` directa desde JDBC).
- **Endpoint que lo usa:** `PUT /api/dashboard/avisos/marcar-leidos`

---

## Convenciones generales

- Todas las funciones reciben parámetros **nombrados y tipados**
  (`p_id_usuario INTEGER`); ninguna construye SQL dinámico ni concatena
  entrada de usuario.
- Nomenclatura: `fn_<verbo>_<sustantivo>.sql` para funciones,
  `sp_<verbo>_<sustantivo>.sql` para procedimientos (`CALL`).
- Todas están versionadas en `db/procs/` y se aplican junto con el
  esquema base al levantar el contenedor de PostgreSQL (Bloque B).