-- db/seed.sql
-- Datos semilla reproducibles, aplicados via docker-entrypoint-initdb.d
-- justo despues de db/schema.sql. Contiene el usuario admin documentado
-- en el README (Bloque B.1).
--
-- Credenciales del usuario admin (documentadas en README.md):
--   email:      admin@uteq.edu.ec
--   contraseña: Admin123!
--
-- El hash fue generado con BCrypt (factor de costo 10), el mismo
-- algoritmo que usa UsuarioService.registrar() en la aplicacion.

INSERT INTO usuarios (nombre, email, contraseña, rol, fecha_registro)
VALUES (
           'Administrador',
           'admin@uteq.edu.ec',
           '$2b$10$FmzB3a6KgYjlrS5KfW6bp.gLaHQQam6VDdUMxIQVSpxyQ1wsHWI1q',
           'ADMIN',
           NOW()
       );

-- Materias base para poder probar el sistema de inmediato
INSERT INTO materia (nombre) VALUES
                                 ('Aplicaciones Web'),
                                 ('Base de Datos'),
                                 ('Cálculo Integral');

-- Respuestas predefinidas del chatbot híbrido (Respuestas_bot)
INSERT INTO respuestas_bot (palabra_clave, respuesta, activo) VALUES
                                                                  ('horario', 'Puedes consultar tu horario completo en la sección "Mis horarios" del dashboard.', TRUE),
                                                                  ('tareas', 'Tus tareas pendientes aparecen en la sección "Mis tareas" del dashboard.', TRUE),
                                                                  ('calificaciones', 'Tus calificaciones y promedio general están disponibles en "Calificaciones".', TRUE);