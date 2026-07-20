-- fn_obtener_resumen_academico.sql
-- Propósito: Calcula el resumen agregado del dashboard de un usuario:
--            total de tareas pendientes, promedio general de calificaciones,
--            total de avisos no leídos y fecha de la próxima entrega.
-- Parámetros de entrada: p_id_usuario (integer) — id del usuario autenticado.
-- Retorna: una fila con 4 columnas (tabla de 1 sola fila).
-- Tablas afectadas (solo lectura): Tareas, Calificaciones, Avisos.
-- Motivo de Stored Procedure/función (no ORM): combina agregaciones
--   (COUNT, AVG, MIN) sobre tres tablas distintas en una sola proyección
--   que no corresponde a ninguna entidad JPA.

CREATE OR REPLACE FUNCTION fn_obtener_resumen_academico(p_id_usuario INTEGER)
    RETURNS TABLE (
                      tareas_pendientes INTEGER,
                      promedio_general  NUMERIC(4,2),
                      avisos_no_leidos  INTEGER,
                      proxima_entrega   DATE
                  )
    LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
        SELECT
            (SELECT COUNT(*)::INTEGER
             FROM tareas t
             WHERE t.id_usuario = p_id_usuario
               AND t.fecha_entrega >= CURRENT_DATE)                       AS tareas_pendientes,
            (SELECT ROUND(AVG(c.nota), 2)
             FROM calificaciones c
             WHERE c.id_usuario = p_id_usuario)                           AS promedio_general,
            (SELECT COUNT(*)::INTEGER
             FROM avisos a
             WHERE a.id_usuario = p_id_usuario
               AND a.leido = FALSE)                                       AS avisos_no_leidos,
            (SELECT MIN(t.fecha_entrega)
             FROM tareas t
             WHERE t.id_usuario = p_id_usuario
               AND t.fecha_entrega >= CURRENT_DATE)                       AS proxima_entrega;
END;
$$;