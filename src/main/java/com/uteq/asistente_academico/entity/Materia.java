package com.uteq.asistente_academico.entity;

import jakarta.persistence.*;
import lombok.Data;

@Data
@Entity
@Table(name = "Materia")
public class Materia {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_materia")
    private Integer idMateria;

    @Column(name = "nombre", nullable = false, length = 100)
    private String nombre;
}