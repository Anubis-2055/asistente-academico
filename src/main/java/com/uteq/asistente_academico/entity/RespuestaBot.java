package com.uteq.asistente_academico.entity;

import jakarta.persistence.*;
import lombok.Data;

@Data
@Entity
@Table(name = "Respuestas_bot")
public class RespuestaBot {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_respuesta")
    private Integer idRespuesta;

    @Column(name = "palabra_clave", nullable = false, length = 100)
    private String palabraClave;

    @Column(name = "respuesta", nullable = false)
    private String respuesta;

    @Column(name = "activo")
    private Boolean activo = true;
}
