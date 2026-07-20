# Justificación de tecnologías — Diagrama C4 Nivel 1

Complementa el diagrama de contexto (C4 N1) del Asistente Virtual Académico, explicando
la elección de las dos tecnologías observadas en la Entrega 1A.

## Gemini API (motor de conversación del chatbot)

El sistema requiere un asistente conversacional capaz de responder preguntas académicas
en lenguaje natural sin que el equipo tenga que entrenar ni mantener un modelo propio.
Se optó por consumir la Gemini API como motor de lenguaje del chatbot híbrido, combinada
con un conjunto de respuestas predefinidas para consultas estructuradas (horarios, tareas,
calificaciones) que no requieren generación de lenguaje. Esta combinación reduce la
dependencia total del servicio externo, limita el costo y la latencia frente a un enfoque
100% basado en LLM, y mantiene el control sobre las respuestas críticas del dominio
académico (por ejemplo, notas o fechas de entrega), donde no es aceptable que un modelo
generativo "alucine" datos.

## PostgreSQL (motor de base de datos)

Se eligió PostgreSQL sobre otras alternativas relacionales por tres razones concretas
para este proyecto: (1) soporte maduro de tipos de datos y restricciones necesarias para
modelar relaciones académicas (usuarios, materias, horarios, tareas, calificaciones) con
integridad referencial estricta; (2) soporte nativo de procedimientos almacenados y
funciones en PL/pgSQL, requerido desde la Tercera Entrega para separar operaciones CRUD
elementales (ORM) de operaciones complejas (reportes, agregaciones, validaciones cruzadas);
y (3) es software libre, sin costo de licenciamiento, adecuado para un proyecto académico
que además debe ser reproducible por terceros sin restricciones de licencia.

> Nota: este texto se reutiliza como base del ADR "Elección de la pila principal"
> exigido en el Bloque D (Documentación arquitectónica) de la Entrega 3.
