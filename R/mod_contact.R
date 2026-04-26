# Módulo: Contacto — editorial style
# Hero de autor + definition-list de canales + nota del proyecto.

mod_contact_ui <- function(id) {
  ns <- NS(id)
  tagList(

    tags$section(class = "andera-section",
      tags$div(class = "andera-section-head",
        tags$span(class = "andera-eyebrow", "Contacto"),
        tags$h2(class = "andera-section-title", "Autoría y canales")
      ),

      tags$div(class = "andera-contact-card",

        tags$div(class = "andera-contact-header",
          tags$h3(class = "andera-contact-name", "Alejandro Navas González"),
          tags$p(class = "andera-contact-role", "Autor y mantenedor de Andera")
        ),

        tags$p(class = "andera-contact-bio",
          "Andera es un proyecto personal e independiente orientado al análisis ",
          "exploratorio de microbiomas. Si tienes comentarios sobre la herramienta, ",
          "quieres reportar un bug, sugerir una funcionalidad o simplemente discutir ",
          "sobre análisis de datos de secuenciación, cualquiera de los siguientes ",
          "canales está abierto."
        ),

        tags$dl(class = "andera-contact-dl",
          tags$dt("Correo electrónico"),
          tags$dd(tags$a(href = "mailto:angnar@telaris.es", "angnar@telaris.es")),

          tags$dt("Web"),
          tags$dd(tags$a(href = "https://telaris.es",
                         target = "_blank", rel = "noopener", "telaris.es")),

          tags$dt("GitHub"),
          tags$dd(tags$a(href = "https://github.com/Angnar-97",
                         target = "_blank", rel = "noopener",
                         "github.com/Angnar-97")),

          tags$dt("LinkedIn"),
          tags$dd(tags$a(href = "https://www.linkedin.com/in/TU-HANDLE",
                         target = "_blank", rel = "noopener", "LinkedIn"))
        )
      )
    ),

    tags$section(class = "andera-section andera-section-narrow",
      tags$div(class = "andera-section-head",
        tags$span(class = "andera-eyebrow", "Sobre el proyecto"),
        tags$h2(class = "andera-section-title",
                "Open source, independiente, sin afiliación.")
      ),
      tags$div(class = "andera-section-body",
        tags$p(
          "Andera se publica bajo una licencia de código abierto y su desarrollo se ",
          "mantiene en GitHub. Cualquier persona puede clonar el repositorio, ",
          "ejecutar la aplicación localmente, adaptarla a sus necesidades o ",
          "contribuir con mejoras. Los reportes de issues y las pull requests son ",
          "bienvenidos."
        ),
        tags$p(
          "El nombre Andera y el logo del árbol celta hacen referencia al concepto ",
          "de ", tags$em("árbol filogenético"), " y a los vínculos —nudos— entre ",
          "especies en una comunidad. El árbol celta es una representación ",
          "tradicional de interconexión: cada rama influye y depende de las demás. ",
          "La metáfora encaja con el análisis de microbiomas, donde la importancia ",
          "de cada taxón se entiende en relación con el conjunto de la comunidad."
        ),
        tags$p(class = "andera-muted",
          "Proyecto independiente sin afiliación institucional ni comercial."
        )
      )
    )
  )
}

mod_contact_server <- function(id) {
  moduleServer(id, function(input, output, session) {
    # UI puro por ahora.
  })
}
