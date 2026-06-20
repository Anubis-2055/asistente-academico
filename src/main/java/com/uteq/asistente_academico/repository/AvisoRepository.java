package com.uteq.asistente_academico.repository;

import com.uteq.asistente_academico.entity.Aviso;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;

public interface AvisoRepository extends JpaRepository<Aviso, Integer> {
    List<Aviso> findByUsuario_IdUsuarioAndLeidoFalse(Integer idUsuario);
}