package com.uteq.asistente_academico.repository;

import com.uteq.asistente_academico.entity.Sesion;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.Optional;

public interface SesionRepository extends JpaRepository<Sesion, Integer> {
    Optional<Sesion> findByToken(String token);
}