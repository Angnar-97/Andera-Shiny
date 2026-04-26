# Módulo: Diversidad Alfa y Beta
# Muestra plot_richness() con los índices seleccionados, coloreado por una
# variable de metadata.

mod_diversity_ui <- function(id) {
  ns <- NS(id)
  tagList(
    tags$div(class = "andera-page",
      tags$h2("Diversidad alfa y beta", class = "andera-page-title"),
      tags$p(class = "andera-page-lead",
        "Estimaciones de diversidad alfa (Chao1, ACE, Shannon, Simpson, InvSimpson, ",
        "Fisher) mediante ", tags$code("phyloseq::plot_richness"), "."
      ),

      bslib::layout_columns(
        col_widths = c(4, 8),

        bslib::card(
          bslib::card_header(bsicons::bs_icon("sliders"), " Parámetros"),
          bslib::card_body(
            selectInput(
              ns("diversity"), "Índices de diversidad",
              choices  = c("Chao1", "ACE", "Shannon", "Simpson", "InvSimpson", "Fisher"),
              multiple = TRUE,
              selected = c("Shannon", "Simpson")
            ),
            uiOutput(ns("alpha_variableui")),
            tags$div(class = "andera-actions",
              actionButton(ns("update_diversity"), "Actualizar",
                           class = "btn btn-primary",
                           icon  = icon("arrow-right"))
            )
          )
        ),

        bslib::card(
          bslib::card_header(bsicons::bs_icon("bar-chart-line"), " Riqueza / diversidad"),
          bslib::card_body(
            shinycssloaders::withSpinner(plotOutput(ns("diversityPlot"), height = "520px"),
                                          type = 5),
            tags$div(class = "andera-actions",
              downloadButton(ns("download_diversity"), "Descargar (.png)",
                             class = "btn-outline-secondary")
            )
          )
        )
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
        "Variable de metadata",
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
