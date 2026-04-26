# Módulo: Mapas de Calor
# Muestra plot_heatmap() con etiquetas por OTU y por Species.

mod_heatmaps_ui <- function(id) {
  ns <- NS(id)
  tagList(
    tags$div(class = "andera-page",
      tags$h2("Mapas de calor", class = "andera-page-title"),
      tags$p(class = "andera-page-lead",
        "Heatmaps de abundancias ordenados por NMDS con ",
        tags$code("phyloseq::plot_heatmap"),
        ". Etiquetado a nivel de OTU/ASV y, si existe, de especie."
      ),

      bslib::layout_columns(
        col_widths = c(4, 8),

        bslib::card(
          bslib::card_header(bsicons::bs_icon("sliders"), " Acción"),
          bslib::card_body(
            tags$p(class = "andera-card-help",
              "Pulsa ", tags$b("Actualizar"),
              " para regenerar los mapas con el dataset activo."
            ),
            tags$div(class = "andera-actions",
              actionButton(ns("update_heatmaps"), "Actualizar",
                           class = "btn btn-primary",
                           icon = icon("arrow-right"))
            )
          )
        ),

        bslib::navset_card_tab(
          title = "Resultado",
          bslib::nav_panel(
            "Por OTU/ASV",
            shinycssloaders::withSpinner(plotOutput(ns("heatmap_otus"), height = "580px"),
                                          type = 5),
            tags$div(class = "andera-actions",
              downloadButton(ns("download_heatmap_otus"), "Descargar (.png)",
                             class = "btn-outline-secondary")
            )
          ),
          bslib::nav_panel(
            "Por especie",
            shinycssloaders::withSpinner(plotOutput(ns("heatmap_species"), height = "580px"),
                                          type = 5),
            tags$div(class = "andera-actions",
              downloadButton(ns("download_heatmap_species"), "Descargar (.png)",
                             class = "btn-outline-secondary")
            )
          )
        )
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
