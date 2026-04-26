# Módulo: PERMANOVA
# Test de varianza multivariante con vegan::adonis2 sobre la distancia elegida.

mod_permanova_ui <- function(id) {
  ns <- NS(id)
  tabItem(
    tabName = "permanova",
    fluidRow(
      box(
        title = "PERMANOVA",
        status = "primary", solidHeader = TRUE, collapsible = TRUE, width = 12,
        selectInput(
          ns("distance_permanova"), "Tipo de distancia",
          choices = c("bray", "jaccard", "unifrac", "wunifrac")
        ),
        uiOutput(ns("grouping_variable_ui")),
        numericInput(
          ns("permutations"), "Número de permutaciones",
          value = 999, min = 99, step = 100
        ),
        actionButton(ns("update_permanova"), "Ejecutar PERMANOVA")
      ),
      box(
        title = "Resultados",
        status = "primary", solidHeader = TRUE, collapsible = TRUE, width = 12,
        shinycssloaders::withSpinner(tableOutput(ns("permanovaResults"))),
        br(),
        downloadButton(ns("download_permanova"), "Descargar tabla (.csv)")
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
