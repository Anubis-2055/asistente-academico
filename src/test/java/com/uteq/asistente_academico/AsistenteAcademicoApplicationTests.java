package com.uteq.asistente_academico;

import com.uteq.asistente_academico.entity.Usuario;
import com.uteq.asistente_academico.repository.UsuarioRepository;
import com.uteq.asistente_academico.service.AuthService;
import com.uteq.asistente_academico.service.UsuarioService;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import static org.junit.jupiter.api.Assertions.*;

@SpringBootTest
class AsistenteAcademicoApplicationTests {

	@Autowired
	private UsuarioService usuarioService;

	@Autowired
	private AuthService authService;

	@Autowired
	private UsuarioRepository usuarioRepository;

	@Test
	void loginExitoso() {
		var usuario = usuarioRepository.findByEmail("michael@uteq.edu.ec");
		assertTrue(usuario.isPresent());
		assertTrue(usuarioService.verificarContrasena("admin123", usuario.get().getContrasena()));
	}

	@Test
	void loginConClaveIncorrecta() {
		var usuario = usuarioRepository.findByEmail("michael@uteq.edu.ec");
		assertTrue(usuario.isPresent());
		assertFalse(usuarioService.verificarContrasena("clavemalaa", usuario.get().getContrasena()));
	}

	@Test
	void registroConEmailDuplicado() {
		assertThrows(Exception.class, () -> {
			Usuario u = new Usuario();
			u.setNombre("Duplicado");
			u.setEmail("michael@uteq.edu.ec");
			u.setContrasena("123456");
			u.setRol("estudiante");
			usuarioService.registrar(u);
		});
	}

	@Test
	void accesoSinToken() {
		assertFalse(authService.validarToken("token_invalido"));
	}

	@Test
	void accesoConTokenValido() {
		var usuario = usuarioRepository.findByEmail("michael@uteq.edu.ec");
		assertTrue(usuario.isPresent());
		String token = authService.generarToken(usuario.get());
		assertTrue(authService.validarToken(token));
	}
}