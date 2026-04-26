# Módulo: Grafos
# Red de similaridad entre muestras o taxa con phyloseq::plot_net().

mod_graphs_ui <- function(id) {
  ns <- NS(id)
  tagList(
    tags$div(class = "andera-page",
      tags$h2("Redes de similaridad", class = "andera-page-title"),
      tags$p(class = "andera-page-lead",
        "Grafos con ", tags$code("phyloseq::plot_net"),
        ": nodos muestras o taxa, aristas por debajo del umbral de distancia."
      ),

      bslib::layout_columns(
        col_widths = c(4, 8),

        bslib::card(
          bslib::card_header(bsicons::bs_icon("sliders"), " Parámetros"),
          bslib::card_body(
            radioButtons(
              ns("type"), "Tipo de red",
              choices  = c("Muestras" = "samples", "Taxa" = "taxa"),
              selected = "samples",
              inline   = TRUE
            ),
            selectInput(
              ns("distance"), "Distancia ecológica",
              choices  = c("jaccard", "bray", "unifrac", "wunifrac"),
              selected = "jaccard"
            ),
            sliderInput(
              ns("maxdist"), "Distancia máxima (umbral de enlace)",
              min = 0.1, max = 1, value = 0.4, step = 0.05
            ),
            uiOutput(ns("color_variable_ui")),
            tags$div(class = "andera-actions",
              actionButton(ns("update_graph"), "Actualizar",
                           class = "btn btn-primary",
                           icon = icon("arrow-right"))
            )
          )
        ),

        bslib::card(
          bslib::card_header(bsicons::bs_icon("diagram-3"), " Red"),
          bslib::card_body(
            shinycssloaders::withSpinner(plotOutput(ns("networkPlot"), height = "560px"),
                                          type = 5),
            tags$div(class = "andera-actions",
              downloadButton(ns("download_graph"), "Descargar (.png)",
                             class = "btn-outline-secondary")
            )
          )
        )
      )
    )
  )
}

mod_graphs_server <- function(id, physeq) {
  moduleServer(id, function(input, output, session) {
    output$color_variable_ui <- renderUI({
      req(physeq())
      ps <- physeq()
      if (isTRUE(input$type == "taxa")) {
        tt <- tryCatch(phyloseq::tax_table(ps, errorIfNULL = FALSE),
                       error = function(e) NULL)
        choices <- if (!is.null(tt)) c("(ninguna)", colnames(tt)) else "(ninguna)"
      } else {
        choices <- c("(ninguna)", colnames(phyloseq::sample_data(ps)))
      }
      selectInput(
        session$ns("color_variable"),
        "Colorear por variable",
        choices = choices
      )
    })

    graph_plot <- reactiveVal(NULL)

    observe({
      physeq()
      graph_plot(NULL)
    })

    observeEvent(input$update_graph, {
      req(physeq(), input$distance, input$maxdist, input$type)
      ps <- physeq()

      if (input$distance %in% c("unifrac", "wunifrac") && !has_tree(ps)) {
        shinyalert::shinyalert(
          title = "Error",
          text  = "La distancia seleccionada requiere un árbol filogenético.",
          type  = "error"
        )
        return()
      }

      color_var <- input$color_variable
      if (is.null(color_var) || color_var == "(ninguna)") color_var <- NULL

      p <- tryCatch(
        withProgress(
          message = "Construyendo red",
          detail  = paste("Distancia:", input$distance),
          value   = NULL,
          phyloseq::plot_net(
            ps,
            distance = input$distance,
            maxdist  = input$maxdist,
            color    = color_var,
            type     = input$type
          )
        ),
        error = function(e) {
          shinyalert::shinyalert(
            title = "Error al construir la red",
            text  = e$message,
            type  = "error"
          )
          NULL
        }
      )
      if (!is.null(p)) graph_plot(p)
    })

    output$networkPlot <- renderPlot({
      p <- graph_plot()
      validate(need(p, "Pulsa 'Actualizar' para construir la red."))
      p
    })

    output$download_graph <- download_plot(graph_plot, "red",
                                           width = 10, height = 8)
  })
}
