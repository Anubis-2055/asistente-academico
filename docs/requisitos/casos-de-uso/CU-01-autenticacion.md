# CU-01 — Autenticación segura

Plantilla de Cockburn, niveles de precisión 1 a 4.

## Nivel 1 — Actor principal y objetivo

- **Actor principal:** Estudiante o Docente (cualquier usuario registrado)
- **Objetivo:** Iniciar sesión de forma segura y obtener acceso a las
  funcionalidades protegidas del sistema.
- **Alcance:** Sistema Asistente Virtual Académico (backend + frontend)
- **Nivel:** Meta de usuario (user-goal)
- **Interesados y sus intereses:**
  - *Usuario:* quiere acceder rápido, sin exponer su contraseña.
  - *Sistema/equipo:* quiere evitar accesos no autorizados y ataques de
    fuerza bruta.
- **Precondición:** El usuario ya está registrado en el sistema.
- **Garantía de éxito (postcondición):** El usuario recibe un JWT válido
  y puede acceder a endpoints protegidos hasta que el token expire o
  cierre sesión.

## Nivel 2 — Escenario principal de éxito

1. El usuario abre `index.html` e introduce su correo y contraseña.
2. El frontend envía `POST /api/auth/login` con las credenciales.
3. El sistema busca al usuario por email (`UsuarioRepository.findByEmail`).
4. El sistema verifica la contraseña con BCrypt.
5. El sistema genera un JWT firmado (claims `sub`, `rol`, `nombre`,
   `iat`, `exp`) y lo devuelve junto con el nombre y rol del usuario.
6. El frontend guarda el token y redirige al usuario al dashboard.
7. En cada petición posterior a un endpoint protegido, el frontend
   incluye el token en el header `Authorization: Bearer <token>`.
8. `JwtAuthFilter` valida la firma y expiración del token, y verifica
   que no esté en la blacklist de Redis, antes de permitir el acceso.

## Nivel 3 — Condiciones de extensión

- **3a. Email no registrado:** el sistema responde 400 con
  "Usuario no encontrado".
- **3b. Contraseña incorrecta:** el sistema responde 400 con
  "Contraseña incorrecta".
- **7a. Token ausente o mal formado:** el sistema responde 403.
- **8a. Token expirado:** el sistema responde 403; el frontend redirige
  al login.
- **8b. Token en la blacklist (usuario cerró sesión antes):** el sistema
  responde 403.
- **8c. Redis no disponible:** el sistema NO bloquea la autenticación
  (política fail-open, ver ADR-002); se asume que el token no está
  revocado y se continúa validando solo la firma/expiración.

## Nivel 4 — Pasos de manejo de extensión

- **Para 3a/3b:** el frontend muestra el mensaje de error devuelto por
  el backend en la interfaz de login, sin revelar si el problema fue el
  email o la contraseña específicamente (evita enumeración de usuarios
  — mejora identificada, no implementada aún: actualmente si distingue).
- **Para 7a/8a/8b:** el frontend limpia el `localStorage` y redirige a
  `index.html` (ver `dashboard.html`, función de manejo de 401/403).
- **Para 8c:** no requiere manejo especial en el frontend; la petición
  se resuelve normalmente porque el backend no la rechaza.

## Trazabilidad

REQ-F-001, REQ-F-002 → HU-01 → `AuthController`, `JwtAuthFilter`,
`AuthService`, `RedisService` → `AuthServiceTest`
