# CU-04 — Consulta al asistente conversacional

Plantilla de Cockburn, niveles de precisión 1 a 4.

**Estado: PENDIENTE DE IMPLEMENTACIÓN.** Este caso de uso describe el
comportamiento deseado del chatbot híbrido, declarado desde la Entrega
1A como diferenciador central del proyecto, pero cuyo backend
(`ChatbotController`/`ChatbotService`) aún no existe en el código. Se
documenta ahora para dejar claro el diseño esperado y facilitar su
implementación en la Entrega Final.

## Nivel 1 — Actor principal y objetivo

- **Actor principal:** Estudiante autenticado
- **Objetivo:** Obtener una respuesta rápida a una pregunta académica en
  lenguaje natural, sin tener que navegar por el dashboard.
- **Alcance:** Sistema Asistente Virtual Académico (backend + Gemini API)
- **Nivel:** Meta de usuario (user-goal)
- **Interesados y sus intereses:**
  - *Estudiante:* quiere una respuesta natural y rápida.
  - *Sistema:* quiere minimizar el costo/latencia de llamadas a la
    Gemini API, resolviendo con respuestas predefinidas cuando sea
    posible (ver `justificacion-tecnologias.md`, ADR-001).
- **Precondición:** El usuario está autenticado; existe al menos una
  fila activa en `respuestas_bot` para el camino de respuesta
  predefinida.
- **Garantía de éxito:** El usuario recibe una respuesta relevante a su
  pregunta.

## Nivel 2 — Escenario principal de éxito (respuesta predefinida)

1. El estudiante escribe una pregunta en `chatbot.html` (ej. "¿qué
   tareas tengo pendientes?").
2. El frontend envía la pregunta a un endpoint del chatbot (a definir,
   ej. `POST /api/chatbot/consulta`) junto con el JWT.
3. El backend busca coincidencia por palabra clave en `respuestas_bot`
   (`activo = true`).
4. Si hay coincidencia, el backend devuelve la `respuesta` predefinida
   directamente, sin llamar a la Gemini API.
5. El frontend muestra la respuesta en la conversación.

## Escenario alterno — Sin coincidencia predefinida

1-2. Igual que el escenario principal.
3. El backend no encuentra ninguna palabra clave coincidente en
   `respuestas_bot`.
4. El backend construye un prompt (posiblemente incluyendo contexto del
   usuario, ej. su resumen del dashboard) y lo envía a la Gemini API.
5. El backend recibe la respuesta generada y la devuelve al frontend.
6. *(Opcional, a definir)* la interacción se registra en la tabla
   `mensajes` para historial de conversación.

## Nivel 3 — Condiciones de extensión

- **4a (predefinida). Múltiples palabras clave coinciden:** a definir —
  ¿se prioriza la más específica, la primera insertada, o se combinan?
- **4b (Gemini). La Gemini API no responde o excede el tiempo límite:**
  el backend debe devolver un mensaje de error controlado al usuario,
  no dejar la petición colgada indefinidamente (requiere timeout
  explícito en la llamada HTTP a la Gemini API).
- **4c (Gemini). La Gemini API devuelve contenido inapropiado o fuera de
  contexto académico:** a definir — ¿se filtra la respuesta antes de
  mostrarla al usuario?

## Nivel 4 — Pasos de manejo de extensión

- **Para 4a:** se recomienda ordenar por longitud de coincidencia de
  palabra clave (más específica primero) como regla simple inicial.
- **Para 4b:** configurar un timeout (ej. 8-10 segundos) en el cliente
  HTTP hacia la Gemini API, y devolver un mensaje tipo "El asistente no
  está disponible en este momento, intenta de nuevo" ante fallo o
  timeout.
- **Para 4c:** pendiente de decisión de diseño; posible mitigación
  inicial: system prompt que restrinja el alcance temático de las
  respuestas generadas.

## Trazabilidad

REQ-F-006 (pendiente) → HU-04 (pendiente) → *(sin código aún)* →
estado: **pendiente** — este caso de uso sirve como especificación de
partida para cuando se implemente.
