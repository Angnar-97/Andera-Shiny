# Módulo: Mapas de Calor
# Muestra plot_heatmap() con etiquetas por OTU y por Species.

mod_heatmaps_ui <- function(id) {
  ns <- NS(id)
  tabItem(
    tabName = "heatmaps",
    fluidRow(
      box(
        title = "Mapas de Calor",
        status = "primary", solidHeader = TRUE, collapsible = TRUE, width = 12,
        actionButton(ns("update_heatmaps"), "Actualizar")
      ),
      box(
        title = "Mapa de Calor de Abundancia de OTUs",
        status = "primary", solidHeader = TRUE, collapsible = TRUE, width = 12,
        shinycssloaders::withSpinner(plotOutput(ns("heatmap_otus"))),
        br(),
        downloadButton(ns("download_heatmap_otus"), "Descargar heatmap OTU (.png)")
      ),
      box(
        title = "Mapa de Calor de Abundancia de Especies",
        status = "primary", solidHeader = TRUE, collapsible = TRUE, width = 12,
        shinycssloaders::withSpinner(plotOutput(ns("heatmap_species"))),
        br(),
        downloadButton(ns("download_heatmap_species"), "Descargar heatmap Species (.png)")
      )
    )
  )
}

mod_heatmaps_server <- function(id, physeq) {
  moduleServer(id, function(input, output, session) {
    heatmap_source <- reactiveVal(NULL)

    observe({
      physeq()
      heatmap_source(NULL)
    })

    observeEvent(input$update_heatmaps, {
      req(physeq())
      heatmap_source(physeq())
    })

    plot_otus <- reactive({
      ps <- heatmap_source()
      if (is.null(ps)) return(NULL)
      phyloseq::plot_heatmap(ps, taxa.label = "OTU")
    })

    plot_species <- reactive({
      ps <- heatmap_source()
      if (is.null(ps)) return(NULL)
      tt <- tryCatch(phyloseq::tax_table(ps, errorIfNULL = FALSE),
                     error = function(e) NULL)
      if (is.null(tt) || !"Species" %in% colnames(tt)) return(NULL)
      phyloseq::plot_heatmap(ps, taxa.label = "Species")
    })

    output$heatmap_otus <- renderPlot({
      ps <- heatmap_source()
      validate(need(ps, "Pulsa 'Actualizar' para generar los mapas de calor."))
      plot_otus()
    })

    output$heatmap_species <- renderPlot({
      ps <- heatmap_source()
      validate(need(ps, "Pulsa 'Actualizar' para generar los mapas de calor."))
      tt <- tryCatch(phyloseq::tax_table(ps, errorIfNULL = FALSE),
                     error = function(e) NULL)
      validate(need(!is.null(tt) && "Species" %in% colnames(tt),
                    "El objeto phyloseq no tiene el rango 'Species' en tax_table."))
      plot_species()
    })

    output$download_heatmap_otus    <- download_plot(plot_otus,    "heatmap-otus",
                                                     width = 10, height = 8)
    output$download_heatmap_species <- download_plot(plot_species, "heatmap-species",
                                                     width = 10, height = 8)
  })
}
