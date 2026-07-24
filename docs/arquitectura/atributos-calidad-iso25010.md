# Tabla de atributos de calidad — ISO/IEC 25010

Conforme a la norma ISO/IEC 25010:2011 (System and Software Quality
Requirements and Evaluation), este documento identifica, para cada
característica de calidad relevante al proyecto, su prioridad, un
escenario concreto de evaluación, y la estrategia arquitectónica
adoptada para satisfacerla.

| Característica | Subcaracterística | Prioridad | Escenario | Estrategia adoptada |
|---|---|---|---|---|
| **Adecuación funcional** | Completitud funcional | Must | El estudiante puede ver, en una sola petición, su resumen académico (tareas pendientes, promedio, avisos) | Funciones SQL de agregación (`fn_obtener_resumen_academico`) en vez de múltiples llamadas desde el frontend |
| **Eficiencia de desempeño** | Comportamiento temporal | Must | `GET /api/dashboard` responde con p95 ≤ 200 ms con caché caliente | Agregación resuelta en la base de datos (PL/pgSQL), no en el backend; ver Bloque C.1 (benchmark k6, pendiente) |
| **Compatibilidad** | Interoperabilidad | Should | El backend expone una API REST documentada en OpenAPI, consumible por cualquier cliente HTTP | Springdoc OpenAPI en `/api/docs`; contratos JSON estándar, sin acoplamiento al frontend HTML propio |
| **Usabilidad** | Reconocibilidad de la adecuación | Should | Un estudiante nuevo entiende el dashboard sin instrucciones adicionales | Diseño con tarjetas (dashboard.html) que replican las secciones mentales del usuario: horarios, tareas, calificaciones, avisos |
| **Fiabilidad** | Tolerancia a fallos | Must | Una caída del servicio Redis no debe impedir la autenticación de usuarios con tokens válidos | `RedisService.estaEnBlacklist()` con política fail-open: ante `RedisConnectionFailureException`, se registra un WARN y se asume el token no revocado, en vez de rechazar la petición |
| **Fiabilidad** | Capacidad de recuperación | Must | El sistema debe reconstruirse de forma idéntica desde una clonación limpia | Docker Compose con imágenes fijadas por digest sha256, esquema aplicado vía `docker-entrypoint-initdb.d`, `make up` verificado de punta a punta (Bloque B) |
| **Seguridad** | Confidencialidad | Must | Ningún endpoint protegido debe responder sin un JWT válido | `JwtAuthFilter` (`OncePerRequestFilter`) valida firma y expiración en cada petición antes de llegar al controlador |
| **Seguridad** | Resistencia a inyección SQL | Must | Ninguna consulta debe concatenar entrada de usuario | Separación estricta ORM/procedimientos almacenados (A.2): toda operación no elemental usa funciones PL/pgSQL con parámetros nombrados y tipados |
| **Seguridad** | Control de acceso | Must | Un usuario no puede solicitar el dashboard de otro usuario cambiando un parámetro | El `id_usuario` se resuelve siempre desde el JWT autenticado (`Authentication.getName()`), nunca se recibe como parámetro del cliente |
| **Mantenibilidad** | Modularidad | Should | Los procedimientos almacenados deben poder auditarse sin leer el código Java | Cada función SQL vive en un archivo versionado independiente (`db/procs/`) y está documentada en `docs/basedatos/CATALOGO-SP.md` |
| **Mantenibilidad** | Capacidad de prueba | Should | El esquema de base de datos debe ser reproducible para pruebas automatizadas | Migraciones versionadas con Flyway (desarrollo local) + `db/schema.sql` (contenedor Docker), nunca `ddl-auto=update` |
| **Portabilidad** | Adaptabilidad | Could | El sistema debe poder ejecutarse en cualquier máquina con Docker, sin instalar Java/PostgreSQL/Redis manualmente | Todo el stack orquestado con Docker Compose; único requisito del host es tener Docker instalado |

## Notas de trazabilidad

Esta tabla complementa la matriz de trazabilidad de requisitos
(`docs/trazabilidad/matriz.csv`, Bloque A.3.3): mientras la matriz traza
requisitos funcionales y no funcionales individuales hacia código y
pruebas, esta tabla agrupa esos mismos requisitos por la característica
de calidad ISO 25010 que satisfacen, para facilitar la discusión
arquitectónica en el informe técnico (Bloque D).
