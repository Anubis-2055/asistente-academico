package com.uteq.asistente_academico.repository;

import com.uteq.asistente_academico.entity.RespuestaBot;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.Optional;

public interface RespuestaBotRepository extends JpaRepository<RespuestaBot, Integer> {
    Optional<RespuestaBot> findByPalabraClaveAndActivoTrue(String palabraClave);
}