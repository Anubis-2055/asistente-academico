package com.uteq.asistente_academico.dto;

import java.time.LocalDate;

/**
 * Proyección de Spring Data para el resultado de la función SQL
 * fn_listar_tareas_pendientes. No corresponde a ninguna entidad JPA:
 * combina Tarea + Materia (JOIN) más una columna calculada.
 */
public interface TareaPendienteProjection {
    Integer getIdTarea();
    String getTitulo();
    String getMateria();
    LocalDate getFechaEntrega();
    Integer getDiasRestantes();
}