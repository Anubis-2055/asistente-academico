# CU-03 — Consulta del dashboard académico

Plantilla de Cockburn, niveles de precisión 1 a 4.

## Nivel 1 — Actor principal y objetivo

- **Actor principal:** Estudiante autenticado
- **Objetivo:** Ver de un vistazo su situación académica actual (tareas
  pendientes, promedio, avisos) sin navegar por secciones separadas.
- **Alcance:** Sistema Asistente Virtual Académico (backend + frontend)
- **Nivel:** Meta de usuario (user-goal)
- **Interesados y sus intereses:**
  - *Estudiante:* quiere información agregada rápida, sin múltiples
    clics.
  - *Sistema:* debe calcular la agregación de forma eficiente (p95 ≤
    200 ms con caché caliente, ver REQ-NF-001) y sin exponer datos de
    otros usuarios.
- **Precondición:** El usuario está autenticado.
- **Garantía de éxito:** El usuario ve un resumen correcto y actualizado
  de su propia información académica.

## Nivel 2 — Escenario principal de éxito

1. El estudiante inicia sesión y es redirigido a `dashboard.html`.
2. El frontend ejecuta `GET /api/dashboard` con el JWT.
3. `DashboardController` resuelve el usuario autenticado a partir del
   email del token (nunca de un parámetro enviado por el cliente).
4. `DashboardRepository` invoca `fn_obtener_resumen_academico` (JOIN +
   agregación: `COUNT`, `AVG`, `MIN` sobre `tareas`, `calificaciones`,
   `avisos`) y `fn_listar_tareas_pendientes` (JOIN `tareas`+`materia`
   con columna calculada de días restantes).
5. El sistema devuelve el resumen y la lista de tareas pendientes.
6. El frontend renderiza las tarjetas del dashboard con los datos reales.

## Escenario alterno — Marcar avisos como leídos

1. El estudiante hace clic en "Marcar todos como leídos".
2. El frontend envía `PUT /api/dashboard/avisos/marcar-leidos`.
3. `DashboardRepository` invoca `fn_marcar_avisos_leidos` (actualización
   masiva de todos los avisos no leídos del usuario).
4. El sistema devuelve la cantidad de avisos actualizados.
5. El frontend vuelve a pedir el dashboard para reflejar el cambio.

## Nivel 3 — Condiciones de extensión

- **3a. Usuario del token no existe en la base (caso raro, cuenta
  eliminada tras emitir el token):** el sistema responde 404.
- **4a. Redis no disponible al momento de validar el token:** no afecta
  este caso de uso directamente (se resuelve en el filtro JWT antes de
  llegar aquí, con política fail-open, ver CU-01).
- **4b. Usuario sin tareas/calificaciones/avisos aún (cuenta nueva):**
  las funciones SQL devuelven `0`/`NULL` de forma segura (`COUNT`
  devuelve 0, `AVG` sobre conjunto vacío devuelve `NULL`), el frontend
  debe mostrar un estado vacío coherente ("Aún sin calificaciones").

## Nivel 4 — Pasos de manejo de extensión

- **Para 3a:** el frontend, al recibir 404, limpia sesión y redirige al
  login (mismo tratamiento que un token inválido).
- **Para 4b:** `dashboard.html` ya maneja el caso `promedioGeneral ==
  null` mostrando el texto "Aún sin calificaciones" en vez de un
  número — verificado en el código actual de `cargarDashboard()`.

## Trazabilidad

REQ-F-004, REQ-F-005 → HU-03 → `DashboardController`,
`DashboardRepository`, `fn_obtener_resumen_academico`,
`fn_listar_tareas_pendientes`, `fn_marcar_avisos_leidos` → verificado
manualmente en navegador; benchmark k6 pendiente (Bloque C.1)
