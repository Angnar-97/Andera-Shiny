# ----- Interfaz de la Aplicación ----
# Cada pestaña delega su UI en el *_ui() de su módulo en R/.

ui <- dashboardPage(
  title = "Andera · Exploración de Microbiomas",

  dashboardHeader(
    title = tags$span(
      tags$img(src = "celta.png", class = "andera-logo", alt = "árbol celta"),
      "Andera"
    ),
    titleWidth = 300
  ),

  dashboardSidebar(
    sidebarMenu(
      menuItem("Carga de Datos",         tabName = "data_load", icon = icon("database")),
      menuItem("Filtrado",               tabName = "filtering", icon = icon("yin-yang")),
      menuItem("Diversidad Alfa y Beta", tabName = "diversity", icon = icon("bank")),
      menuItem("Mapas de Calor",         tabName = "heatmaps",  icon = icon("snowflake")),
      menuItem("PCoA",                   tabName = "pcoa",      icon = icon("hurricane")),
      menuItem("PERMANOVA",              tabName = "permanova", icon = icon("flask-vial")),
      menuItem("Grafos",                 tabName = "grafos",    icon = icon("spider"))
    )
  ),

  dashboardBody(
    use_theme(mytheme),
    tags$head(
      tags$link(rel = "icon", type = "image/png", href = "celta.png"),
      tags$link(rel = "stylesheet", type = "text/css", href = "andera.css")
    ),

    mod_dataset_banner_ui("banner"),

    tabItems(
      mod_data_load_ui("data_load"),
      mod_filtering_ui("filtering"),
      mod_diversity_ui("diversity"),
      mod_heatmaps_ui("heatmaps"),
      mod_pcoa_ui("pcoa"),
      mod_permanova_ui("permanova"),
      mod_graphs_ui("grafos")
    ),

    tags$footer(
      class = "andera-footer",
      "Andera · Análisis exploratorio de microbiomas · ",
      tags$a(
        href   = "https://github.com/weimar45/andera",
        target = "_blank",
        "código fuente"
      )
    )
  )
)
