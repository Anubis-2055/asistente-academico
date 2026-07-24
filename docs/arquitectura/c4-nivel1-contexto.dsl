workspace "Asistente Virtual Académico" "Diagrama C4 Nivel 1 - Contexto del sistema" {

    model {
        estudiante = person "Estudiante" "Consulta tareas, horarios, calificaciones y avisos; usa el chatbot académico."
        docente = person "Docente / Administrador" "Gestiona materias, tareas y calificaciones de sus estudiantes."

        sistema = softwareSystem "Asistente Virtual Académico" "Permite a estudiantes y docentes de la UTEQ gestionar información académica y consultar un chatbot híbrido." {
        }

        geminiApi = softwareSystem "Gemini API" "Servicio externo de Google usado para generar respuestas del chatbot cuando no hay una respuesta predefinida." {
            tags "Externo"
        }

        estudiante -> sistema "Consulta su dashboard, tareas y usa el chatbot" "HTTPS"
        docente -> sistema "Gestiona materias, tareas y calificaciones" "HTTPS"
        sistema -> geminiApi "Genera respuestas del chatbot para consultas sin coincidencia predefinida" "HTTPS / REST"
    }

    views {
        systemContext sistema "C4_Nivel1_Contexto" {
            include *
            autoLayout
            title "C4 Nivel 1 — Contexto del Asistente Virtual Académico"
            description "Muestra el sistema completo, sus usuarios humanos y la única dependencia externa (Gemini API)."
        }

        styles {
            element "Person" {
                shape person
                background #08427b
                color #ffffff
            }
            element "Software System" {
                background #1168bd
                color #ffffff
            }
            element "Externo" {
                background #999999
                color #ffffff
            }
        }
    }
}
