-- fn_listar_tareas_pendientes.sql
-- Propósito: Lista las tareas pendientes de un usuario con el nombre de su
--            materia y los días restantes hasta la fecha de entrega.
-- Parámetros de entrada: p_id_usuario (integer) — id del usuario autenticado.
-- Retorna: conjunto de filas (id_tarea, titulo, materia, fecha_entrega, dias_restantes).
-- Tablas afectadas (solo lectura): Tareas, Materia.
-- Motivo de Stored Procedure/función (no ORM): requiere JOIN entre Tareas y
--   Materia, más una columna calculada (dias_restantes) que no existe en
--   ninguna entidad JPA — es una proyección (DTO), no una entidad completa.

CREATE OR REPLACE FUNCTION fn_listar_tareas_pendientes(p_id_usuario INTEGER)
    RETURNS TABLE (
                      id_tarea       INTEGER,
                      titulo         VARCHAR,
                      materia        VARCHAR,
                      fecha_entrega  DATE,
                      dias_restantes INTEGER
                  )
    LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
        SELECT
            t.id_tarea,
            t.titulo,
            m.nombre AS materia,
            t.fecha_entrega,
            (t.fecha_entrega - CURRENT_DATE)::INTEGER AS dias_restantes
        FROM tareas t
                 JOIN materia m ON m.id_materia = t.id_materia
        WHERE t.id_usuario = p_id_usuario
          AND t.fecha_entrega >= CURRENT_DATE
        ORDER BY t.fecha_entrega ASC;
END;
$$;