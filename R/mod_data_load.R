# Módulo: Carga de Datos
# Permite cargar un objeto phyloseq desde archivo o desde los datasets de
# ejemplo del paquete phyloseq. Expone un reactive con el phyloseq "cargado"
# (es decir, aceptado por el usuario al pulsar 'Actualizar').

mod_data_load_ui <- function(id) {
  ns <- NS(id)
  tabItem(
    tabName = "data_load",
    fluidRow(
      box(
        title = "Carga de Datos",
        status = "primary", solidHeader = TRUE, collapsible = TRUE, width = 12,
        radioButtons(
          ns("data_source"), "Seleccione la Fuente de Datos",
          choices  = c("Archivo", "Conjunto de datos de ejemplo"),
          selected = "Conjunto de datos de ejemplo"
        ),
        conditionalPanel(
          condition = sprintf("input['%s'] == 'Archivo'", ns("data_source")),
          fileInput(ns("file1"), "Elija un archivo Phyloseq")
        ),
        conditionalPanel(
          condition = sprintf("input['%s'] == 'Conjunto de datos de ejemplo'", ns("data_source")),
          selectInput(
            ns("dataset"), "Seleccione un objeto phyloseq de muestra",
            choices  = c("Global Patterns", "Enterotype", "Soil"),
            selected = "Global Patterns"
          )
        ),
        actionButton(ns("update"), "Actualizar"),
        downloadButton(ns("downloadData"), "Descargar phyloseq (.rds)")
      ),
      box(
        title = "Resumen del Objeto Phyloseq",
        status = "primary", solidHeader = TRUE, collapsible = TRUE, width = 12,
        shinycssloaders::withSpinner(verbatimTextOutput(ns("physeq_summary")))
      ),
      box(
        title = "Árbol Filogenético",
        status = "primary", solidHeader = TRUE, collapsible = TRUE, width = 12,
        shinycssloaders::withSpinner(plotOutput(ns("phylo_tree"))),
        br(),
        downloadButton(ns("download_tree"), "Descargar árbol (.png)")
      )
    )
  )
}

mod_data_load_server <- function(id) {
  moduleServer(id, function(input, output, session) {
    # Reactive que refleja la selección actual (cambia al instante).
    pending_ps <- reactive({
      if (input$data_source == "Archivo") {
        req(input$file1)
        readRDS(input$file1$datapath)
      } else {
        load_example_dataset(input$dataset)
      }
    })

    # Solo se actualiza al pulsar 'Actualizar': el resto de la app lo ve.
    loaded_ps <- reactiveVal(NULL)
    observeEvent(input$update, loaded_ps(pending_ps()))

    tree_plot <- reactive({
      ps <- loaded_ps()
      if (is.null(ps) || !has_tree(ps)) return(NULL)
      color_col <- if ("SampleType" %in% colnames(phyloseq::sample_data(ps))) "SampleType" else NULL
      phyloseq::plot_tree(ps, color = color_col)
    })

    output$physeq_summary <- renderPrint({
      ps <- loaded_ps()
      validate(need(ps, "Pulsa 'Actualizar' para cargar el objeto phyloseq."))
      print(ps)
    })

    output$phylo_tree <- renderPlot({
      ps <- loaded_ps()
      validate(need(ps, "Pulsa 'Actualizar' para cargar el objeto phyloseq."))
      validate(need(has_tree(ps),
                    "El objeto phyloseq cargado carece de árbol filogenético."))
      tree_plot()
    })

    output$downloadData  <- download_rds(loaded_ps, "phyloseq")
    output$download_tree <- download_plot(tree_plot, "phylo-tree",
                                          width = 8, height = 8)

    loaded_ps
  })
}
