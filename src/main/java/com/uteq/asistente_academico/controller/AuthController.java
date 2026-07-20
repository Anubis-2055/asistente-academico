package com.uteq.asistente_academico.controller;

import com.uteq.asistente_academico.entity.Usuario;
import com.uteq.asistente_academico.service.AuthService;
import com.uteq.asistente_academico.service.UsuarioService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import java.util.HashMap;
import java.util.Map;
import java.util.Optional;

@RestController
@RequestMapping("/api/auth")
@CrossOrigin(origins = {"http://localhost:8080", "http://localhost"})
public class AuthController {

    @Autowired
    private UsuarioService usuarioService;

    @Autowired
    private AuthService authService;

    @PostMapping("/registro")
    public ResponseEntity<?> registro(@RequestBody Usuario usuario) {
        try {
            Usuario nuevo = usuarioService.registrar(usuario);
            Map<String, Object> response = new HashMap<>();
            response.put("mensaje", "Usuario registrado exitosamente");
            response.put("usuario", nuevo.getEmail());
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            return ResponseEntity.badRequest().body("Error al registrar: " + e.getMessage());
        }
    }

    @PostMapping("/login")
    public ResponseEntity<?> login(@RequestBody Map<String, String> credenciales) {
        String email = credenciales.get("email");
        String contrasena = credenciales.get("contrasena");

        Optional<Usuario> usuario = usuarioService.buscarPorEmail(email);

        if (usuario.isEmpty()) {
            return ResponseEntity.badRequest().body("Usuario no encontrado");
        }

        if (!usuarioService.verificarContrasena(contrasena, usuario.get().getContrasena())) {
            return ResponseEntity.badRequest().body("Contraseña incorrecta");
        }

        String token = authService.generarToken(usuario.get());
        Map<String, Object> response = new HashMap<>();
        response.put("token", token);
        response.put("rol", usuario.get().getRol());
        response.put("nombre", usuario.get().getNombre());
        return ResponseEntity.ok(response);
    }
}