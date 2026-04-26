# Módulo: PCoA
# Ordenación de las muestras mediante PCoA sobre la distancia seleccionada.

mod_pcoa_ui <- function(id) {
  ns <- NS(id)
  tabItem(
    tabName = "pcoa",
    fluidRow(
      box(
        title = "Ordenación PCoA",
        status = "primary", solidHeader = TRUE, collapsible = TRUE, width = 12,
        selectInput(
          ns("distance_pcoa"), "Tipo de distancia",
          choices = c("bray", "jaccard", "unifrac", "wunifrac")
        ),
        uiOutput(ns("color_variable_ui")),
        actionButton(ns("update_pcoa"), "Actualizar")
      ),
      box(
        title = "PCoA",
        status = "primary", solidHeader = TRUE, collapsible = TRUE, width = 12,
        shinycssloaders::withSpinner(plotOutput(ns("pcoaPlot"))),
        br(),
        downloadButton(ns("download_pcoa"), "Descargar PCoA (.png)")
      )
    )
  )
}

mod_pcoa_server <- function(id, physeq) {
  moduleServer(id, function(input, output, session) {
    output$color_variable_ui <- renderUI({
      req(physeq())
      selectInput(
        session$ns("color_variable"),
        "Colorear por variable",
        choices = c("(ninguna)", colnames(phyloseq::sample_data(physeq())))
      )
    })

    pcoa_result <- reactiveVal(NULL)

    observe({
      physeq()
      pcoa_result(NULL)
    })

    observeEvent(input$update_pcoa, {
      req(physeq(), input$distance_pcoa)
      ps          <- physeq()
      dist_method <- input$distance_pcoa

      if (dist_method %in% c("unifrac", "wunifrac") && !has_tree(ps)) {
        shinyalert::shinyalert(
          title = "Error",
          text  = "La distancia seleccionada requiere un árbol filogenético.",
          type  = "error"
        )
        return()
      }

      ord <- tryCatch(
        withProgress(
          message = "Calculando PCoA",
          detail  = paste("Distancia:", dist_method),
          value   = NULL,
          phyloseq::ordinate(ps, method = "PCoA", distance = dist_method)
        ),
        error = function(e) {
          shinyalert::shinyalert(
            title = "Error al calcular PCoA",
            text  = e$message,
            type  = "error"
          )
          NULL
        }
      )
      if (is.null(ord)) return()

      color_var <- input$color_variable
      if (is.null(color_var) || color_var == "(ninguna)") color_var <- NULL

      pcoa_result(list(ps = ps, ord = ord, color = color_var))
    })

    pcoa_plot <- reactive({
      res <- pcoa_result()
      if (is.null(res)) return(NULL)
      phyloseq::plot_ordination(res$ps, res$ord, type = "samples", color = res$color) +
        ggplot2::geom_point(size = 3)
    })

    output$pcoaPlot <- renderPlot({
      p <- pcoa_plot()
      validate(need(p, "Pulsa 'Actualizar' para calcular la PCoA."))
      p
    })

    output$download_pcoa <- download_plot(pcoa_plot, "pcoa",
                                          width = 8, height = 6)
  })
}
