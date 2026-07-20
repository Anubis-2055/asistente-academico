# Historias de Usuario — Asistente Virtual Académico

Formato Connextra (As a ⟨rol⟩, I want ⟨objetivo⟩, so that ⟨beneficio⟩),
siguiendo los criterios INVEST de Cohn. Cada historia tiene sus criterios
de aceptación en Gherkin (Given/When/Then).

---

## HU-01 — Autenticación segura

**As a** estudiante de la UTEQ,
**I want** iniciar sesión con mi correo institucional y contraseña,
**so that** pueda acceder de forma segura a mi información académica sin
que otros usuarios puedan ver o modificar mis datos.

**Criterios INVEST:**
- Independent: no depende de otras historias para completarse.
- Negotiable: el mecanismo (JWT vs sesión) se decidió vía ADR-002.
- Valuable: sin esto, ninguna otra funcionalidad es accesible de forma segura.
- Estimable: alcance claro (login + validación de token).
- Small: cabe en un sprint corto.
- Testable: criterios de aceptación verificables abajo.

### Criterios de aceptación (Gherkin)

```gherkin
Escenario: Login exitoso
  Given un usuario registrado con email "alucard.prueba@uteq.edu.ec"
    y contraseña "Prueba123"
  When envía sus credenciales a POST /api/auth/login
  Then el sistema responde con código 200
    y el cuerpo de la respuesta incluye un token JWT válido

Escenario: Login con contraseña incorrecta
  Given un usuario registrado
  When envía una contraseña incorrecta
  Then el sistema responde con código 400
    y un mensaje indicando el error

Escenario: Acceso a recurso protegido sin token
  Given un endpoint protegido, por ejemplo GET /api/dashboard
  When se solicita sin header Authorization
  Then el sistema responde con código 403

Escenario: Acceso a recurso protegido con token válido
  Given un token JWT válido y no expirado, no revocado
  When se solicita GET /api/dashboard con ese token
  Then el sistema responde con código 200
```

**Trazabilidad:** REQ-F-001, REQ-F-002 → CU-01

---

## HU-02 — Gestión de tareas académicas

**As a** estudiante,
**I want** crear, ver, editar y eliminar mis tareas académicas,
**so that** pueda llevar control de mis pendientes por materia.

**Criterios INVEST:** cumple todos; es CRUD elemental sobre una entidad
propia del usuario, independiente y testeable de forma aislada.

### Criterios de aceptación (Gherkin)

```gherkin
Escenario: Crear una tarea
  Given un estudiante autenticado
  When envía POST /api/tareas con título, materia y fecha de entrega válidos
  Then el sistema responde con código 201 (o 200 según implementación)
    y la tarea queda visible en su listado paginado

Escenario: Listar tareas paginadas
  Given un estudiante con más de 10 tareas registradas
  When solicita GET /api/tareas?page=0&size=10
  Then el sistema responde con exactamente 10 tareas
    y metadatos de paginación (total de páginas, total de elementos)

Escenario: Editar una tarea propia
  Given una tarea existente del estudiante autenticado
  When envía PUT /api/tareas/{id} con datos actualizados
  Then el sistema responde con código 200
    y los cambios quedan reflejados al volver a consultar la tarea
```

**Trazabilidad:** REQ-F-003 → CU-02

---

## HU-03 — Dashboard con resumen académico

**As a** estudiante,
**I want** ver de un vistazo mis tareas pendientes, mi promedio general
y mis avisos sin leer al entrar al sistema,
**so that** no tenga que revisar cada sección por separado para saber
qué tengo pendiente.

**Criterios INVEST:** cumple todos; requiere agregación de datos de
varias tablas (JOIN/agregación), por lo que su implementación usa
procedimientos almacenados (ver A.2.2 y ADR-006).

### Criterios de aceptación (Gherkin)

```gherkin
Escenario: Ver resumen académico
  Given un estudiante autenticado con 2 tareas pendientes,
    2 calificaciones registradas y 2 avisos no leídos
  When solicita GET /api/dashboard
  Then el sistema responde con código 200
    y el campo "resumen.tareasPendientes" es igual a 2
    y el campo "resumen.avisosNoLeidos" es igual a 2
    y el campo "resumen.promedioGeneral" refleja el promedio real

Escenario: Marcar avisos como leídos en bloque
  Given un estudiante con 2 avisos no leídos
  When solicita PUT /api/dashboard/avisos/marcar-leidos
  Then el sistema responde con "avisosMarcados": 2
    y una consulta posterior a GET /api/dashboard muestra "avisosNoLeidos": 0
```

**Trazabilidad:** REQ-F-004, REQ-F-005 → CU-03

---

## HU-04 — Consulta al asistente conversacional (pendiente)

**As a** estudiante,
**I want** preguntarle al asistente virtual cosas como "¿cuántas tareas
tengo pendientes?" en lenguaje natural,
**so that** no tenga que navegar por el dashboard para obtener una
respuesta rápida.

**Estado: PENDIENTE DE IMPLEMENTACIÓN.** Esta historia se mantiene en el
backlog documentado, pero su backend (ChatbotController/ChatbotService)
no existe aún al momento de este borrador. Se completa este criterio de
aceptación una vez implementado:

```gherkin
Escenario: Consulta con respuesta predefinida
  Given el usuario pregunta algo relacionado a la palabra clave "tareas"
  When se envía al endpoint del chatbot
  Then responde con el texto predefinido asociado en respuestas_bot

Escenario: Consulta sin coincidencia predefinida
  Given el usuario hace una pregunta sin palabra clave conocida
  When se envía al endpoint del chatbot
  Then el sistema consulta la Gemini API
    y devuelve una respuesta generada relevante a la pregunta
```

**Trazabilidad:** REQ-F-006 (pendiente) → CU-04 (pendiente)