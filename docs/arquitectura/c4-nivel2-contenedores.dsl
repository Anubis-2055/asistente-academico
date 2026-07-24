workspace "Asistente Virtual Académico" "Diagrama C4 Nivel 2 - Contenedores" {

    model {
        estudiante = person "Estudiante"
        docente = person "Docente / Administrador"

        sistema = softwareSystem "Asistente Virtual Académico" {

            frontend = container "Frontend Web" "Páginas HTML/JS estáticas: login, registro, dashboard, chatbot." "HTML5, JavaScript, Bootstrap 5" "WebApp"

            backend = container "Backend API" "Expone la API REST, autenticación JWT, lógica de negocio y acceso a datos." "Spring Boot 3.5 / Java 21" "API"

            baseDatos = container "Base de datos" "Almacena usuarios, materias, tareas, calificaciones, avisos y las funciones SQL de agregación." "PostgreSQL 16" "Database"

            cache = container "Cache / Blacklist" "Almacena los tokens JWT revocados por logout, con expiración automática (TTL)." "Redis 7" "Database"
        }

        geminiApi = softwareSystem "Gemini API" "Generación de lenguaje natural para el chatbot" {
            tags "Externo"
        }

        estudiante -> frontend "Usa" "HTTPS"
        docente -> frontend "Usa" "HTTPS"
        frontend -> backend "Hace peticiones a" "JSON/HTTPS, JWT en header Authorization"
        backend -> baseDatos "Lee y escribe" "JDBC (Spring Data JPA + funciones SQL)"
        backend -> cache "Verifica y agrega tokens revocados" "Redis Protocol (Lettuce)"
        backend -> geminiApi "Genera respuestas del chatbot" "HTTPS / REST"
    }

    views {
        container sistema "C4_Nivel2_Contenedores" {
            include *
            autoLayout
            title "C4 Nivel 2 — Contenedores del Asistente Virtual Académico"
            description "Muestra los 4 contenedores desplegados (frontend, backend, PostgreSQL, Redis) y la dependencia externa de Gemini API."
        }

        styles {
            element "Person" {
                shape person
                background #08427b
                color #ffffff
            }
            element "WebApp" {
                background #438dd5
                color #ffffff
            }
            element "API" {
                background #1168bd
                color #ffffff
            }
            element "Database" {
                shape cylinder
                background #2e7d46
                color #ffffff
            }
            element "Externo" {
                background #999999
                color #ffffff
            }
        }
    }
}
