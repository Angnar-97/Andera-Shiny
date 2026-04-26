# Módulo: Filtrado
# Filtra el objeto phyloseq por una variable/valor de metadata con ps_filter.
# Expone un reactive con el phyloseq filtrado (o el original si aún no se filtró).

mod_filtering_ui <- function(id) {
  ns <- NS(id)
  tabItem(
    tabName = "filtering",
    fluidRow(
      box(
        title = "Filtrado",
        status = "primary", solidHeader = TRUE, collapsible = TRUE, width = 12,
        numericInput(ns("min_count"), "Número mínimo de conteos", value = 0, min = 0),
        uiOutput(ns("variableui")),
        uiOutput(ns("valueui")),
        actionButton(ns("filter"), "Filtrar"),
        downloadButton(ns("download_filtered"), "Descargar filtrado (.rds)")
      ),
      box(
        title = "Resumen del Objeto Phyloseq",
        status = "primary", solidHeader = TRUE, collapsible = TRUE, width = 12,
        shinycssloaders::withSpinner(verbatimTextOutput(ns("filtered_physeq_summary")))
      ),
      box(
        title = "Árbol Filogenético",
        status = "primary", solidHeader = TRUE, collapsible = TRUE, width = 12,
        shinycssloaders::withSpinner(plotOutput(ns("filtered_phylo_tree"))),
        br(),
        downloadButton(ns("download_tree"), "Descargar árbol (.png)")
      )
    )
  )
}

mod_filtering_server <- function(id, physeq) {
  moduleServer(id, function(input, output, session) {
    physeq_filtered <- reactiveVal(NULL)

    observe({
      ps <- physeq()
      if (!is.null(ps)) physeq_filtered(ps)
    })

    output$variableui <- renderUI({
      req(physeq_filtered())
      selectInput(
        session$ns("variable"),
        "Selecciona una variable de metadata",
        choices = colnames(phyloseq::sample_data(physeq_filtered()))
      )
    })

    output$valueui <- renderUI({
      req(input$variable, physeq_filtered())
      selectizeInput(
        session$ns("value"),
        "Seleccione los valores que desea filtrar",
        choices  = unique(phyloseq::sample_data(physeq_filtered())[, input$variable]),
        multiple = TRUE
      )
    })

    observeEvent(input$filter, {
      req(input$variable, input$value)

      if (!(input$variable %in% colnames(phyloseq::sample_data(physeq_filtered())))) {
        shinyalert::shinyalert(
          title = "Error",
          text  = paste("La variable seleccionada", input$variable,
                        "no existe en los datos de muestra"),
          type  = "error"
        )
        return()
      }

      filtered <- tryCatch(
        microViz::ps_filter(
          physeq_filtered(),
          eval(parse(text = input$variable)) %in% input$value
        ),
        error = function(e) NULL
      )

      if (is.null(filtered)) {
        shinyalert::shinyalert(
          title = "Error",
          text  = "El filtro no pudo ser aplicado. Por favor, verifica las variables y los valores seleccionados.",
          type  = "error"
        )
        return()
      }

      physeq_filtered(filtered)

      showNotification(
        sprintf("Filtro aplicado: %d taxa, %d muestras",
                phyloseq::ntaxa(filtered), phyloseq::nsamples(filtered)),
        type     = "message",
        duration = 4
      )
    })

    tree_plot <- reactive({
      ps <- physeq_filtered()
      if (is.null(ps) || !has_tree(ps)) return(NULL)
      color_col <- if ("SampleType" %in% colnames(phyloseq::sample_data(ps))) "SampleType" else NULL
      phyloseq::plot_tree(ps, color = color_col)
    })

    output$filtered_physeq_summary <- renderPrint({
      ps <- physeq_filtered()
      validate(need(ps, "Carga primero un objeto phyloseq desde 'Carga de Datos'."))
      print(ps)
    })

    output$filtered_phylo_tree <- renderPlot({
      ps <- physeq_filtered()
      validate(need(ps, "Carga primero un objeto phyloseq desde 'Carga de Datos'."))
      validate(need(has_tree(ps),
                    "El objeto phyloseq cargado carece de árbol filogenético."))
      tree_plot()
    })

    output$download_filtered <- download_rds(physeq_filtered, "phyloseq-filtered")
    output$download_tree     <- download_plot(tree_plot, "phylo-tree-filtered",
                                              width = 8, height = 8)

    physeq_filtered
  })
}
