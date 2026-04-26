# Módulo: PERMANOVA
# Test de varianza multivariante con vegan::adonis2 sobre la distancia elegida.

mod_permanova_ui <- function(id) {
  ns <- NS(id)
  tagList(
    tags$div(class = "andera-page",
      tags$h2("PERMANOVA", class = "andera-page-title"),
      tags$p(class = "andera-page-lead",
        "Test multivariante por permutaciones con ",
        tags$code("vegan::adonis2"),
        ". Evalúa diferencias en la composición de comunidades entre grupos."
      ),

      bslib::layout_columns(
        col_widths = c(4, 8),

        bslib::card(
          bslib::card_header(bsicons::bs_icon("sliders"), " Parámetros"),
          bslib::card_body(
            selectInput(
              ns("distance_permanova"), "Distancia ecológica",
              choices = c("bray", "jaccard", "unifrac", "wunifrac")
            ),
            uiOutput(ns("grouping_variable_ui")),
            numericInput(
              ns("permutations"), "Número de permutaciones",
              value = 999, min = 99, step = 100
            ),
            tags$div(class = "andera-actions",
              actionButton(ns("update_permanova"), "Ejecutar PERMANOVA",
                           class = "btn btn-primary",
                           icon = icon("play"))
            )
          )
        ),

        bslib::card(
          bslib::card_header(bsicons::bs_icon("table"), " Resultados"),
          bslib::card_body(
            shinycssloaders::withSpinner(tableOutput(ns("permanovaResults")),
                                          type = 5),
            tags$div(class = "andera-actions",
              downloadButton(ns("download_permanova"), "Descargar (.csv)",
                             class = "btn-outline-secondary")
            )
          )
        )
      )
    )
  )
}

mod_permanova_server <- function(id, physeq) {
  moduleServer(id, function(input, output, session) {
    output$grouping_variable_ui <- renderUI({
      req(physeq())
      selectInput(
        session$ns("grouping_variable"),
        "Variable de agrupación",
        choices = colnames(phyloseq::sample_data(physeq()))
      )
    })

    permanova_result <- reactiveVal(NULL)

    observe({
      physeq()
      permanova_result(NULL)
    })

    observeEvent(input$update_permanova, {
      req(physeq(), input$distance_permanova, input$grouping_variable,
          input$permutations)
      ps          <- physeq()
      dist_method <- input$distance_permanova

      if (dist_method %in% c("unifrac", "wunifrac") && !has_tree(ps)) {
        shinyalert::shinyalert(
          title = "Error",
          text  = "La distancia seleccionada requiere un árbol filogenético.",
          type  = "error"
        )
        return()
      }

      result <- tryCatch(
        withProgress(message = "PERMANOVA", value = 0, {
          incProgress(0.2, detail = "Calculando matriz de distancias")
          d    <- phyloseq::distance(ps, method = dist_method)
          incProgress(0.2, detail = "Preparando modelo")
          sdat <- as(phyloseq::sample_data(ps), "data.frame")
          frm  <- stats::reformulate(input$grouping_variable, response = "d")
          incProgress(0.6, detail = sprintf("Permutaciones (%d)", input$permutations))
          vegan::adonis2(frm, data = sdat, permutations = input$permutations)
        }),
        error = function(e) {
          shinyalert::shinyalert(
            title = "Error al ejecutar PERMANOVA",
            text  = e$message,
            type  = "error"
          )
          NULL
        }
      )
      if (is.null(result)) return()

      permanova_result(result)
    })

    output$permanovaResults <- renderTable({
      res <- permanova_result()
      validate(need(res, "Pulsa 'Ejecutar PERMANOVA' para obtener resultados."))
      as.data.frame(res)
    }, rownames = TRUE, digits = 4)

    output$download_permanova <- download_csv(permanova_result, "permanova")
  })
}
