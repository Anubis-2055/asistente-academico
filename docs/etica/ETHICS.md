# Declaración Ética — ETHICS.md

Conforme al Bloque F de la guía de la Tercera Entrega, este documento
declara los aspectos éticos del uso de datos y de participantes en el
proyecto "Asistente Virtual Académico con Chatbot Híbrido".

## 1. Fuentes de datos y su licencia

Todos los datos utilizados durante el desarrollo (usuarios, materias,
tareas, calificaciones, avisos) son **datos sintéticos de prueba**,
creados por el propio equipo para fines de desarrollo y demostración.
No se ha utilizado, en ningún momento, una base de datos real de
estudiantes de la UTEQ ni de ninguna institución educativa.

El código fuente del proyecto se licencia bajo MIT (ver `LICENSE`).

## 2. Tratamiento de datos personales

El sistema, en su estado actual (v0.9.0-rc), no gestiona datos de
estudiantes reales. Los campos que en un despliegue real contendrían
información personal identificable (nombre, correo, contraseña) están
poblados únicamente con datos ficticios (ej. `alucard.prueba@uteq.edu.ec`,
`admin@uteq.edu.ec`) durante todo el desarrollo y las pruebas.

De llegar a desplegarse con datos reales en el futuro, el sistema ya
implementa como mínimo:
- Contraseñas almacenadas con hash BCrypt (nunca en texto plano).
- Autenticación stateless vía JWT, sin exponer credenciales entre
  peticiones.
- Separación de acceso a datos por rol (en desarrollo, ver ADR-006).

## 3. Mecanismo de consentimiento informado (pruebas de usabilidad)

Para las pruebas de usabilidad del Bloque C.3 (System Usability Scale),
que sí involucran participantes humanos reales, el equipo utiliza un
formulario de consentimiento informado (ver
`docs/etica/consentimientos/plantilla.md`) que cada participante debe
firmar antes de participar. El formulario explica:
- El propósito de la prueba (evaluar la usabilidad del sistema, no al
  participante).
- Que la participación es voluntaria y puede abandonarse en cualquier
  momento sin consecuencias.
- Que los datos recolectados (respuestas SUS) se anonimizan y se
  identifican solo por código (P01, P02, ...), nunca por nombre.

## 4. Ausencia de datos identificables en el repositorio público

El repositorio público de este proyecto (`github.com/Michael-XFM/asistente-academico`)
**no contiene**:
- Formularios de consentimiento firmados (quedan fuera del repositorio,
  archivados solo localmente por el equipo).
- Nombres reales de los participantes de las pruebas de usabilidad
  (solo códigos P01, P02, ...).
- Ninguna credencial real de producción (las que aparecen en
  `db/seed.sql` y en la documentación son explícitamente de desarrollo,
  documentadas como tales).

## 5. Alcance declarado

Este proyecto es un Proyecto Fin de Curso (PFC) académico de la UTEQ,
sin fines comerciales ni despliegue en producción con usuarios reales
durante el período de esta entrega.
