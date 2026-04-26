# Módulo: Diversidad Alfa y Beta
# Muestra plot_richness() con los índices seleccionados, coloreado por una
# variable de metadata. Recibe un reactive con el phyloseq activo.

mod_diversity_ui <- function(id) {
  ns <- NS(id)
  tabItem(
    tabName = "diversity",
    fluidRow(
      box(
        title = "Estudio de la Riqueza",
        status = "primary", solidHeader = TRUE, collapsible = TRUE, width = 12,
        selectInput(
          ns("diversity"), "Seleccione el tipo de diversidad",
          choices  = c("Chao1", "ACE", "Shannon", "Simpson", "InvSimpson", "Fisher"),
          multiple = TRUE,
          selected = c("Shannon", "Simpson")
        ),
        uiOutput(ns("alpha_variableui")),
        actionButton(ns("update_diversity"), "Actualizar")
      ),
      box(
        title = "Diversidad Alfa & Beta",
        status = "primary", solidHeader = TRUE, collapsible = TRUE, width = 12,
        shinycssloaders::withSpinner(plotOutput(ns("diversityPlot"))),
        br(),
        downloadButton(ns("download_diversity"), "Descargar gráfico (.png)")
      )
    )
  )
}

mod_diversity_server <- function(id, physeq) {
  moduleServer(id, function(input, output, session) {
    output$alpha_variableui <- renderUI({
      req(physeq())
      selectInput(
        session$ns("variable_alpha"),
        "Selecciona una variable de metadata",
        choices = colnames(phyloseq::sample_data(physeq()))
      )
    })

    diversity_plot <- reactiveVal(NULL)

    observe({
      physeq()
      diversity_plot(NULL)
    })

    observeEvent(input$update_diversity, {
      req(physeq(), input$diversity, input$variable_alpha)
      plot <- tryCatch(
        phyloseq::plot_richness(
          physeq(),
          measures = input$diversity,
          color    = input$variable_alpha
        ),
        error = function(e) {
          shinyalert::shinyalert(
            title = "Error al calcular la diversidad",
            text  = e$message,
            type  = "error"
          )
          NULL
        }
      )
      if (!is.null(plot)) diversity_plot(plot)
    })

    output$diversityPlot <- renderPlot({
      plot <- diversity_plot()
      validate(need(plot, "Pulsa 'Actualizar' para calcular la diversidad."))
      plot
    })

    output$download_diversity <- download_plot(diversity_plot, "diversidad",
                                               width = 10, height = 6)
  })
}
