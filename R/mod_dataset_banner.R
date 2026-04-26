# Módulo: Banner de estado del dataset
# Franja que aparece sobre todas las pestañas con el resumen del phyloseq
# activo y su estado (crudo / filtrado).

mod_dataset_banner_ui <- function(id) {
  ns <- NS(id)
  uiOutput(ns("banner"))
}

mod_dataset_banner_server <- function(id, physeq, physeq_filtered) {
  moduleServer(id, function(input, output, session) {
    output$banner <- renderUI({
      raw  <- physeq()
      filt <- physeq_filtered()

      if (is.null(raw)) {
        return(div(
          class = "alert alert-info",
          style = "margin-bottom: 15px;",
          icon("circle-info"),
          " Sin dataset cargado — ve a 'Carga de Datos' para empezar."
        ))
      }

      n_taxa_raw    <- phyloseq::ntaxa(raw)
      n_samples_raw <- phyloseq::nsamples(raw)

      is_filtered <- !is.null(filt) &&
        (phyloseq::ntaxa(filt)    != n_taxa_raw ||
         phyloseq::nsamples(filt) != n_samples_raw)

      filter_tag <- if (is_filtered) {
        tags$span(
          style = "margin-left: 20px; color: #2e7d32; font-weight: 500;",
          icon("filter"),
          sprintf(" Filtrado: %d taxa, %d muestras",
                  phyloseq::ntaxa(filt), phyloseq::nsamples(filt))
        )
      } else {
        tags$span(
          style = "margin-left: 20px; color: #777;",
          icon("filter"),
          " Sin filtro aplicado"
        )
      }

      div(
        class = "alert alert-success",
        style = "margin-bottom: 15px;",
        tags$span(
          icon("database"),
          sprintf(" Dataset: %d taxa, %d muestras",
                  n_taxa_raw, n_samples_raw)
        ),
        filter_tag
      )
    })
  })
}
