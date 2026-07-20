-- V1__schema_inicial.sql (CORREGIDO)
-- Esquema en minúsculas, sin comillas, alineado exactamente con las
-- entidades JPA (@Table/@Column). Evita el problema de duplicidad entre
-- tablas "Capitalizadas" (creadas manualmente) y minúsculas (creadas por
-- Hibernate), ya que Hibernate no cita los identificadores por defecto y
-- PostgreSQL pliega los nombres sin comillas a minúscula.

CREATE TABLE usuarios (
                          id_usuario      SERIAL PRIMARY KEY,
                          nombre          VARCHAR(100)  NOT NULL,
                          email           VARCHAR(255)  NOT NULL UNIQUE,
                          contraseña      VARCHAR(255)  NOT NULL,
                          rol             VARCHAR(20)   NOT NULL,
                          fecha_registro  TIMESTAMP
);

CREATE TABLE materia (
                         id_materia  SERIAL PRIMARY KEY,
                         nombre      VARCHAR(100) NOT NULL
);

CREATE TABLE horario (
                         id_horario   SERIAL PRIMARY KEY,
                         id_materia   INTEGER NOT NULL REFERENCES materia(id_materia),
                         dia_semana   VARCHAR(20) NOT NULL,
                         hora_inicio  TIME NOT NULL,
                         hora_fin     TIME NOT NULL,
                         aula         VARCHAR(50)
);

CREATE TABLE tareas (
                        id_tarea      SERIAL PRIMARY KEY,
                        id_materia    INTEGER NOT NULL REFERENCES materia(id_materia),
                        id_usuario    INTEGER NOT NULL REFERENCES usuarios(id_usuario),
                        titulo        VARCHAR(200) NOT NULL,
                        descripcion   TEXT NOT NULL,
                        fecha_entrega DATE NOT NULL
);

CREATE TABLE calificaciones (
                                id_calificacion  SERIAL PRIMARY KEY,
                                id_usuario       INTEGER NOT NULL REFERENCES usuarios(id_usuario),
                                id_materia       INTEGER NOT NULL REFERENCES materia(id_materia),
                                nota             NUMERIC(4,2) NOT NULL
);

CREATE TABLE avisos (
                        id_aviso          SERIAL PRIMARY KEY,
                        id_tarea          INTEGER NOT NULL REFERENCES tareas(id_tarea),
                        id_usuario        INTEGER NOT NULL REFERENCES usuarios(id_usuario),
                        mensaje           TEXT NOT NULL,
                        leido             BOOLEAN NOT NULL DEFAULT FALSE,
                        fecha_generacion  TIMESTAMP
);

CREATE TABLE mensajes (
                          id_mensaje   SERIAL PRIMARY KEY,
                          id_usuario   INTEGER NOT NULL REFERENCES usuarios(id_usuario),
                          contenido    TEXT NOT NULL,
                          tipo         VARCHAR(20) NOT NULL,
                          fecha_envio  TIMESTAMP
);

CREATE TABLE respuestas_bot (
                                id_respuesta   SERIAL PRIMARY KEY,
                                palabra_clave  VARCHAR(100) NOT NULL,
                                respuesta      TEXT NOT NULL,
                                activo         BOOLEAN DEFAULT TRUE
);

CREATE TABLE sesiones (
                          id_sesion     SERIAL PRIMARY KEY,
                          id_usuario    INTEGER REFERENCES usuarios(id_usuario),
                          token         VARCHAR(255) NOT NULL,
                          fecha_inicio  TIMESTAMP,
                          fecha_fin     TIMESTAMP
);