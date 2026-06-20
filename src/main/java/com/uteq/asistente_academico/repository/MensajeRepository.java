package com.uteq.asistente_academico.repository;

import com.uteq.asistente_academico.entity.Mensaje;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;

public interface MensajeRepository extends JpaRepository<Mensaje, Integer> {
    List<Mensaje> findByUsuario_IdUsuario(Integer idUsuario);
}