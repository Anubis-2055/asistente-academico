package com.uteq.asistente_academico.repository;

import com.uteq.asistente_academico.dto.ResumenAcademicoProjection;
import com.uteq.asistente_academico.dto.TareaPendienteProjection;
import com.uteq.asistente_academico.entity.Usuario;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

/**
 * Repositorio de acceso a datos para el dashboard académico.
 *
 * Los métodos de aquí NO son CRUD elementales (A.2.1): combinan JOIN,
 * agregaciones y actualizaciones masivas sobre varias filas/tablas, por lo
 * que van encapsulados en funciones SQL (A.2.2), invocadas mediante @Query
 * nativo con parámetros nombrados. Nunca se concatena entrada de usuario
 * en la consulta.
 *
 * Se extiende JpaRepository<Usuario, Integer> (en vez de un tipo genérico)
 * únicamente para que Spring Data identifique este repositorio como parte
 * del módulo JPA y no del módulo Redis, ya que el proyecto tiene ambos
 * módulos de Spring Data activos (JPA + Redis para el blacklist de JWT).
 * No se usan aquí los métodos CRUD heredados de JpaRepository.
 */
public interface DashboardRepository extends JpaRepository<Usuario, Integer> {

    @Query(value = "SELECT * FROM fn_obtener_resumen_academico(:idUsuario)", nativeQuery = true)
    ResumenAcademicoProjection obtenerResumenAcademico(@Param("idUsuario") Integer idUsuario);

    @Query(value = "SELECT * FROM fn_listar_tareas_pendientes(:idUsuario)", nativeQuery = true)
    List<TareaPendienteProjection> listarTareasPendientes(@Param("idUsuario") Integer idUsuario);

    /**
     * fn_marcar_avisos_leidos hace un UPDATE masivo por dentro, pero se
     * invoca aquí como un SELECT normal (no @Modifying) porque PostgreSQL
     * la ejecuta como una función que retorna un valor (la cantidad de
     * filas afectadas), no como una sentencia UPDATE directa. Usar
     * @Modifying aquí sería incorrecto: forzaría a Hibernate a llamar
     * executeUpdate() sobre una sentencia SELECT, lo cual falla en JDBC.
     */
    @Transactional
    @Query(value = "SELECT fn_marcar_avisos_leidos(:idUsuario)", nativeQuery = true)
    Integer marcarAvisosLeidos(@Param("idUsuario") Integer idUsuario);
}