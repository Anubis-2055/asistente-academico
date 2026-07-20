package com.uteq.asistente_academico.dto;

import java.math.BigDecimal;
import java.time.LocalDate;

/**
 * Proyección de Spring Data para el resultado de la función SQL
 * fn_obtener_resumen_academico. No corresponde a ninguna entidad JPA:
 * es un DTO de solo lectura para el dashboard.
 */
public interface ResumenAcademicoProjection {
    Integer getTareasPendientes();
    BigDecimal getPromedioGeneral();
    Integer getAvisosNoLeidos();
    LocalDate getProximaEntrega();
}