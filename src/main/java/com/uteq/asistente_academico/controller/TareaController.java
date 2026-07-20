package com.uteq.asistente_academico.controller;

import com.uteq.asistente_academico.entity.Tarea;
import com.uteq.asistente_academico.repository.TareaRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/tareas")
@CrossOrigin(origins = "http://localhost:8080")
public class TareaController {

    @Autowired
    private TareaRepository tareaRepository;

    @GetMapping
    public ResponseEntity<Page<Tarea>> listar(
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "10") int size) {
        Pageable pageable = PageRequest.of(page, size);
        return ResponseEntity.ok(tareaRepository.findAll(pageable));
    }

    @GetMapping("/{id}")
    public ResponseEntity<Tarea> buscarPorId(@PathVariable Integer id) {
        return tareaRepository.findById(id)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    @PostMapping
    public ResponseEntity<Tarea> crear(@RequestBody Tarea tarea) {
        return ResponseEntity.ok(tareaRepository.save(tarea));
    }

    @PutMapping("/{id}")
    public ResponseEntity<Tarea> actualizar(@PathVariable Integer id, @RequestBody Tarea tarea) {
        return tareaRepository.findById(id)
                .map(t -> {
                    t.setTitulo(tarea.getTitulo());
                    t.setDescripcion(tarea.getDescripcion());
                    t.setFechaEntrega(tarea.getFechaEntrega());
                    return ResponseEntity.ok(tareaRepository.save(t));
                })
                .orElse(ResponseEntity.notFound().build());
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<?> eliminar(@PathVariable Integer id) {
        return tareaRepository.findById(id)
                .map(t -> {
                    tareaRepository.delete(t);
                    return ResponseEntity.ok().build();
                })
                .orElse(ResponseEntity.notFound().build());
    }
}