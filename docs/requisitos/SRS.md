# Software Requirements Specification (SRS)
## Asistente Virtual Académico con Chatbot Híbrido — UTEQ

Conforme a la plantilla de Software Requirements Specification de
ISO/IEC/IEEE 29148:2018. Versión correspondiente al estado v0.9.0-rc
(Entrega 3, 24 de julio de 2026).

---

## 1. Introducción

### 1.1 Propósito
Este documento especifica los requisitos funcionales y no funcionales del
sistema "Asistente Virtual Académico con Chatbot Híbrido", desarrollado
para la Universidad Técnica Estatal de Quevedo (UTEQ) como Proyecto Fin
de Curso de la asignatura Aplicaciones Web.

### 1.2 Alcance
El sistema permite a estudiantes de la UTEQ consultar información
académica (tareas, horarios, calificaciones, avisos) a través de un
dashboard web y un asistente conversacional híbrido (respuestas
predefinidas + Gemini API), con autenticación segura mediante JWT.

### 1.3 Definiciones, acrónimos y abreviaturas
- **JWT**: JSON Web Token, RFC 7519.
- **ORM**: Object-Relational Mapping.
- **SP**: Stored Procedure (procedimiento almacenado).
- **PFC**: Proyecto Fin de Curso.
- **MoSCoW**: Must, Should, Could, Won't — técnica de priorización.

### 1.4 Referencias
- ISO/IEC/IEEE 29148:2018 — Requirements Engineering.
- INCOSE Guide to Writing Requirements v4.
- RFC 7519 (JWT), RFC 7807 (Problem Details).
- Guía de la Tercera Entrega del PFC, Ing. Guerrero Ulloa, UTEQ, 2026.

### 1.5 Resumen
Las secciones siguientes describen la perspectiva del producto, sus
usuarios, restricciones, y el detalle de los requisitos funcionales y no
funcionales, cada uno con criterio de aceptación medible y trazabilidad
hacia historias de usuario, código, pruebas y evidencia empírica.

---

## 2. Descripción global

### 2.1 Perspectiva del producto
Aplicación web standalone (Spring Boot + PostgreSQL + Redis), con
frontend HTML/JS servido de forma estática. No depende de sistemas
externos de la UTEQ (no hay integración con el SGA institucional en esta
fase); el chatbot consume la API externa de Gemini para generación de
lenguaje natural.

### 2.2 Funciones del producto (resumen)
- Registro y autenticación de usuarios (JWT stateless).
- CRUD de tareas académicas.
- Dashboard con resumen académico agregado (tareas pendientes, promedio,
  avisos).
- Marcado masivo de avisos como leídos.
- Asistente conversacional híbrido (pendiente de implementación completa;
  ver REQ-F-006 y ADR correspondiente).

### 2.3 Características de los usuarios
| Actor | Descripción | Nivel técnico esperado |
|---|---|---|
| Estudiante | Usuario principal; consulta su información académica | Ninguno (usuario final) |
| Administrador | Gestiona datos base del sistema (materias, respuestas del bot) | Ninguno (usuario final) |

### 2.4 Restricciones
- Debe ejecutarse en PostgreSQL 16 y Redis 7 (decisión documentada en
  ADR-002 y ADR-003, Bloque D).
- Backend en Java 21 LTS / Spring Boot 3.5.x.
- Sin presupuesto para servicios de pago adicionales al de Gemini API.

### 2.5 Supuestos y dependencias
- Se asume disponibilidad de la Gemini API durante el desarrollo y la
  demostración.
- Se asume que los usuarios tienen conexión a internet estable (no hay
  modo offline).

---

## 3. Requisitos específicos

Cada requisito sigue el patrón `[condición] [sujeto] shall [acción]
[objeto] [restricción]` de ISO/IEC/IEEE 29148, y cumple las nueve
características de calidad individuales del INCOSE Guide v4 (Necessary,
Appropriate, Unambiguous, Complete, Singular, Feasible, Verifiable,
Correct, Conforming).

### 3.1 Requisitos funcionales

#### REQ-F-001
- **Enunciado:** Al recibir credenciales válidas en `/api/auth/login`,
  el sistema deberá emitir un JWT firmado con los claims `sub`, `rol`,
  `nombre`, `iat`, `exp` en un plazo máximo de 500 ms.
- **Rationale:** La autenticación stateless es la base de todo el
  sistema; sin ella ningún otro requisito es alcanzable (evidencia:
  directriz de la Entrega 1B).
- **Prioridad (MoSCoW):** Must
- **Criterio de aceptación:** Login con credenciales correctas devuelve
  código 200 y un JWT válido; con credenciales incorrectas devuelve 400.
- **Verificación:** Test JUnit `AuthServiceTest` + prueba manual Postman.
- **Trazabilidad:** → HU-01 → CU-01 → `AuthController.login()` →
  `AuthServiceTest` → estado: **verificado**

#### REQ-F-002
- **Enunciado:** El sistema deberá validar el JWT en cada petición a un
  endpoint protegido mediante un filtro (`JwtAuthFilter`), rechazando con
  403 cualquier petición sin token válido.
- **Rationale:** Sin este filtro, cualquier endpoint protegido queda
  expuesto sin autenticación real (observación OBS-05 de la Entrega 1B).
- **Prioridad:** Must
- **Criterio de aceptación:** Petición a `/api/dashboard` sin token →
    403. Con token válido → 200.
- **Verificación:** Test JUnit + prueba manual.
- **Trazabilidad:** → HU-01 → CU-01 → `JwtAuthFilter` →
  (pendiente test automatizado dedicado) → estado: **implementado**

#### REQ-F-003
- **Enunciado:** El sistema deberá permitir al estudiante autenticado
  crear, leer, actualizar y eliminar lógicamente sus propias tareas
  académicas, paginadas.
- **Rationale:** CRUD elemental de la entidad principal, exigido desde
  la Entrega 1B.
- **Prioridad:** Must
- **Criterio de aceptación:** Los 4 endpoints CRUD de Tarea responden
  correctamente y respetan la paginación (`Pageable`).
- **Verificación:** Test JUnit `TareaControllerTest` (pendiente ampliar).
- **Trazabilidad:** → HU-02 → CU-02 → `TareaController` →
  (pendiente test dedicado) → estado: **implementado**

#### REQ-F-004
- **Enunciado:** Al solicitar `GET /api/dashboard`, el sistema deberá
  devolver en una sola respuesta el resumen académico del usuario
  autenticado (tareas pendientes, promedio general, avisos no leídos,
  próxima entrega) en un plazo máximo de 200 ms con caché caliente.
- **Rationale:** Evita múltiples llamadas desde el frontend y centraliza
  la lógica de agregación en la base de datos vía función SQL.
- **Prioridad:** Must
- **Criterio de aceptación:** Respuesta 200 con los 4 campos del resumen
  y la lista de tareas pendientes; p95 < 200 ms (ver Bloque C.1).
- **Verificación:** Prueba manual + benchmark k6 (pendiente, Bloque C).
- **Trazabilidad:** → HU-03 → CU-03 → `DashboardController.obtenerDashboard()`
  → `fn_obtener_resumen_academico`, `fn_listar_tareas_pendientes` →
  evidencia: `docs/mediciones/perf/` (pendiente) → estado: **implementado**

#### REQ-F-005
- **Enunciado:** El sistema deberá permitir al estudiante marcar todos
  sus avisos pendientes como leídos en una sola operación.
- **Rationale:** Evita que el estudiante tenga que marcar avisos uno por
  uno; operación de actualización masiva.
- **Prioridad:** Should
- **Criterio de aceptación:** `PUT /api/dashboard/avisos/marcar-leidos`
  devuelve la cantidad de avisos actualizados y estos dejan de contar
  como no leídos en el siguiente `GET /api/dashboard`.
- **Verificación:** Prueba manual (verificado en navegador).
- **Trazabilidad:** → HU-03 → CU-03 → `DashboardController.marcarAvisosLeidos()`
  → `fn_marcar_avisos_leidos` → estado: **implementado**

#### REQ-F-006
- **Enunciado:** El sistema deberá responder consultas académicas en
  lenguaje natural combinando respuestas predefinidas (`respuestas_bot`)
  con generación vía Gemini API cuando la consulta no coincide con
  ninguna palabra clave predefinida.
- **Rationale:** Es el diferenciador central del proyecto ("chatbot
  híbrido") declarado desde la Entrega 1A.
- **Prioridad:** Must
- **Criterio de aceptación:** *(pendiente de definir con precisión una
  vez implementado el chatbot; por ahora solo existe la tabla
  `respuestas_bot` con datos semilla, sin lógica de backend)*.
- **Verificación:** *(pendiente)*
- **Trazabilidad:** → HU-04 *(pendiente redactar)* → CU-04 *(pendiente)*
  → *(sin código aún)* → estado: **pendiente**

### 3.2 Requisitos no funcionales

#### REQ-NF-001 (Rendimiento)
- **Enunciado:** El endpoint `GET /api/dashboard` deberá responder con
  p95 ≤ 200 ms con caché caliente y ≤ 500 ms con caché frío, bajo carga
  de 50 usuarios virtuales concurrentes.
- **Prioridad:** Must
- **Verificación:** Benchmark k6 (Bloque C.1, pendiente).
- **Estado:** pendiente

#### REQ-NF-002 (Seguridad)
- **Enunciado:** Ninguna consulta a la base de datos deberá concatenar
  entrada de usuario; toda operación no elemental deberá usar
  procedimientos/funciones SQL con parámetros nombrados.
- **Prioridad:** Must
- **Verificación:** Revisión de código + `scripts/audit-sql-dynamic.sh`
  (Bloque B/C, pendiente).
- **Estado:** verificado parcialmente (los 3 SPs existentes cumplen;
  falta el script de auditoría automatizado)

#### REQ-NF-003 (Disponibilidad/Resiliencia)
- **Enunciado:** Una caída del servicio Redis no deberá impedir la
  autenticación de usuarios con tokens válidos y no revocados.
- **Rationale:** Redis solo respalda el logout (blacklist), no la
  validación principal del JWT.
- **Prioridad:** Should
- **Criterio de aceptación:** Con Redis caído, un login y una petición
  a `/api/dashboard` con token válido responden 200, no 403/500.
- **Verificación:** Prueba manual (verificado: se detuvo el contenedor
  de Redis y el sistema siguió respondiendo tras el fix de
  `RedisService.estaEnBlacklist()`).
- **Estado:** verificado

#### REQ-NF-004 (Reproducibilidad)
- **Enunciado:** El sistema deberá poder reconstruirse de forma idéntica
  desde una clonación limpia del repositorio con el comando `make up`,
  sin intervención manual adicional más allá de tener Docker instalado.
- **Prioridad:** Must
- **Verificación:** Prueba manual (verificado: `docker compose down -v`
    + `docker compose up -d --build` desde cero, login exitoso con usuario
      admin del seed).
- **Estado:** verificado

---

## 4. Estado de cobertura de la matriz (resumen)

| Estado | Cantidad |
|---|---|
| Verificado | 3 |
| Implementado (sin test automatizado dedicado) | 4 |
| Pendiente | 3 |

*(Este resumen se actualiza en `docs/trazabilidad/matriz.csv`, que es la
fuente de verdad completa — ver Bloque A.3.3)*

---

## Pendientes para completar este documento
- [ ] Requisitos no funcionales adicionales: usabilidad, accesibilidad,
  calidad de código (cobertura).
- [ ] Historias de usuario completas en `docs/requisitos/historias/`
  (formato Connextra + Gherkin) para HU-01 a HU-04.
- [ ] Casos de uso completos en `docs/requisitos/casos-de-uso/`
  (plantilla Cockburn) para CU-01 a CU-04.
- [ ] REQ-F-006 (chatbot) necesita definición completa una vez se
  implemente la lógica del backend.
- [ ] `docs/requisitos/CHANGELOG-REQ.md` con el historial de cambios
  desde la Entrega 1A.