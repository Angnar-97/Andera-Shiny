# Módulo: Banner de estado del dataset
# Franja fija que aparece bajo el navbar con el resumen del phyloseq activo
# y su estado (crudo / filtrado).

mod_dataset_banner_ui <- function(id) {
  ns <- NS(id)
  tags$div(
    class = "andera-banner container-xl",
    uiOutput(ns("banner"))
  )
}

mod_dataset_banner_server <- function(id, physeq, physeq_filtered) {
  moduleServer(id, function(input, output, session) {
    output$banner <- renderUI({
      raw  <- physeq()
      filt <- physeq_filtered()

      if (is.null(raw)) {
        return(tags$div(
          class = "andera-banner-box andera-banner-empty",
          bsicons::bs_icon("exclamation-triangle"),
          tags$strong(" Sin dataset cargado."),
          " Ve a ", tags$em("Datos \u25b8 Carga de Datos"),
          " para cargar un phyloseq o probar con un dataset de ejemplo."
        ))
      }

      n_taxa_raw    <- phyloseq::ntaxa(raw)
      n_samples_raw <- phyloseq::nsamples(raw)

      is_filtered <- !is.null(filt) &&
        (phyloseq::ntaxa(filt)    != n_taxa_raw ||
         phyloseq::nsamples(filt) != n_samples_raw)

      filter_chip <- if (is_filtered) {
        tags$span(class = "andera-banner-chip andera-banner-chip-filtered",
          bsicons::bs_icon("funnel"),
          sprintf(" Filtrado: %d taxa \u00d7 %d muestras",
                  phyloseq::ntaxa(filt), phyloseq::nsamples(filt))
        )
      } else {
        tags$span(class = "andera-banner-chip andera-banner-chip-muted",
          bsicons::bs_icon("funnel"),
          " Sin filtro aplicado"
        )
      }

      tags$div(
        class = "andera-banner-box andera-banner-ok",
        bsicons::bs_icon("check-circle"),
        tags$strong(" Dataset activo: "),
        tags$span(sprintf("%d taxa \u00d7 %d muestras",
                          n_taxa_raw, n_samples_raw)),
        filter_chip
      )
    })
  })
}
