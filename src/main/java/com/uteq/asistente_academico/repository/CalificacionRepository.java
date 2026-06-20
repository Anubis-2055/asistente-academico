package com.uteq.asistente_academico.repository;

import com.uteq.asistente_academico.entity.Calificacion;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;

public interface CalificacionRepository extends JpaRepository<Calificacion, Integer> {
    List<Calificacion> findByUsuario_IdUsuario(Integer idUsuario);
}