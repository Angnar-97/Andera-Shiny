# ----- Servidor de la Aplicación ----
# Orquesta los módulos de R/ y comparte el phyloseq activo entre pestañas.

server <- function(input, output, session) {
  # ----- Portada + Contacto -----
  mod_home_server   ("home", session)
  mod_contact_server("contact")

  # ----- Carga + filtrado -----
  physeq          <- mod_data_load_server("data_load")
  physeq_filtered <- mod_filtering_server("filtering", physeq)

  # ----- Banner global -----
  mod_dataset_banner_server("banner", physeq, physeq_filtered)

  # Phyloseq "activo": el filtrado si existe, si no el original.
  active_physeq <- reactive({
    filt <- physeq_filtered()
    if (!is.null(filt)) filt else physeq()
  })

  # ----- Módulos de análisis -----
  mod_diversity_server("diversity", active_physeq)
  mod_heatmaps_server ("heatmaps",  active_physeq)
  mod_pcoa_server     ("pcoa",      active_physeq)
  mod_permanova_server("permanova", active_physeq)
  mod_graphs_server   ("grafos",    active_physeq)
}
