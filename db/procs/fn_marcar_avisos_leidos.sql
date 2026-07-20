-- fn_marcar_avisos_leidos.sql
-- Propósito: Marca como leídos TODOS los avisos pendientes de un usuario
--            de una sola vez, y devuelve cuántas filas fueron actualizadas.
-- Parámetros de entrada: p_id_usuario (integer) — id del usuario autenticado.
-- Retorna: INTEGER — cantidad de avisos que se marcaron como leídos.
-- Tablas afectadas (escritura): avisos.
-- Motivo de Stored Procedure/función (no ORM): es una actualización masiva
--   sobre múltiples filas (no una sola fila por su clave primaria), por lo
--   que no califica como CRUD elemental según A.2.1 y debe encapsularse
--   como función/procedimiento según A.2.2.

CREATE OR REPLACE FUNCTION fn_marcar_avisos_leidos(p_id_usuario INTEGER)
RETURNS INTEGER
LANGUAGE plpgsql
AS $$
DECLARE
v_filas_actualizadas INTEGER;
BEGIN
UPDATE avisos
SET leido = TRUE
WHERE id_usuario = p_id_usuario
  AND leido = FALSE;

GET DIAGNOSTICS v_filas_actualizadas = ROW_COUNT;
RETURN v_filas_actualizadas;
END;
$$;