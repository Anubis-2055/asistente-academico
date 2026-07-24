# CU-02 — Gestión de tareas académicas

Plantilla de Cockburn, niveles de precisión 1 a 4.

## Nivel 1 — Actor principal y objetivo

- **Actor principal:** Estudiante autenticado
- **Objetivo:** Crear, consultar, editar y eliminar (lógicamente) sus
  propias tareas académicas.
- **Alcance:** Sistema Asistente Virtual Académico (backend)
- **Nivel:** Meta de usuario (user-goal)
- **Interesados y sus intereses:**
  - *Estudiante:* quiere llevar control de sus pendientes por materia.
  - *Sistema:* debe garantizar que un estudiante solo vea/modifique sus
    propias tareas, no las de otros.
- **Precondición:** El usuario está autenticado (ver CU-01) y tiene un
  JWT válido.
- **Garantía de éxito:** La tarea queda creada/actualizada/eliminada de
  forma persistente y visible en listados posteriores.

## Nivel 2 — Escenario principal de éxito (crear tarea)

1. El estudiante abre el formulario de nueva tarea.
2. Completa título, descripción, materia y fecha de entrega.
3. El frontend envía `POST /api/tareas` con el JWT en el header.
4. `JwtAuthFilter` valida el token y puebla el `SecurityContext`.
5. `TareaController` recibe la petición y la delega al servicio/repositorio.
6. `TareaRepository` (Spring Data JPA) persiste la nueva fila en la
   tabla `tareas`, asociada al `id_usuario` del token.
7. El sistema responde con la tarea creada y su `id_tarea` asignado.

## Escenario alterno — Listar tareas paginadas

1. El estudiante solicita `GET /api/tareas?page=0&size=10`.
2. El sistema devuelve únicamente las tareas del usuario autenticado
   (filtro por `id_usuario`, CRUD elemental — no requiere procedimiento
   almacenado por ser un filtro directo sobre un atributo de la propia
   entidad, según A.2.1).
3. La respuesta incluye metadatos de paginación (total de páginas,
   total de elementos).

## Nivel 3 — Condiciones de extensión

- **3a. Campos obligatorios faltantes o inválidos:** el sistema responde
  400 (validación).
- **6a. Materia inexistente:** el sistema responde 400/404 (llave
  foránea inválida).
- **General. Intento de editar/eliminar una tarea de OTRO usuario:** el
  sistema debe rechazar la operación — *pendiente de verificación
  explícita*: actualmente el filtro se aplica en las consultas de
  listado, pero conviene confirmar que `actualizar()`/`eliminar()`
  también validan que la tarea pertenezca al usuario autenticado antes
  de aplicar el cambio.

## Nivel 4 — Pasos de manejo de extensión

- **Para 3a:** el frontend muestra los mensajes de validación devueltos
  por el backend, campo por campo.
- **Para la condición general de propiedad:** se recomienda agregar una
  verificación explícita en `TareaController`/`TareaService`
  (`if (!tarea.getIdUsuario().equals(usuarioAutenticado.getIdUsuario())) return 403`)
  antes de aplicar cualquier `UPDATE`/`DELETE` — anotado como mejora
  pendiente para no dejarlo como supuesto sin verificar.

## Trazabilidad

REQ-F-003 → HU-02 → `TareaController`, `TareaRepository` →
(prueba automatizada dedicada pendiente de ampliar)
