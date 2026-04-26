# Tema del dashboard (paquete fresh) + paleta gráfica de Andera.
# El generador CSS original vive en scripts/theme_generator.R; este archivo
# define el objeto `mytheme` que ui.R consume con use_theme() y una paleta
# discreta que se aplica por defecto a todos los ggplots.

# ----- Tema shinydashboard -----
mytheme <- fresh::create_theme(
  fresh::adminlte_color(
    light_blue = "#5D263E"
  ),
  fresh::adminlte_sidebar(
    width              = "400px",
    dark_bg            = "#D8DEE9",
    dark_hover_bg      = "#81A1C1",
    dark_color         = "#5D263E",
    dark_submenu_color = "#5D263E"
  ),
  fresh::adminlte_global(
    content_bg   = "#FFF",
    box_bg       = "#D8DEE9",
    info_box_bg  = "#D8DEE9"
  )
)

# ----- Paleta gráfica -----
# Primarios del tema + complementarios que combinan bien con el árbol celta.
andera_palette <- c(
  "#5D263E",  # burgundy (primario)
  "#81A1C1",  # nord blue
  "#2E8B57",  # verde musgo
  "#C9AF53",  # ocre
  "#6A4E94",  # morado profundo
  "#D97757",  # terracota
  "#5B7083"  # gris azulado
)

scale_color_andera <- function(...) ggplot2::scale_color_manual(values = andera_palette, ...)
scale_fill_andera  <- function(...) ggplot2::scale_fill_manual(values = andera_palette, ...)

# Aplica la paleta como default discreto para todos los ggplots.
options(
  ggplot2.discrete.colour = andera_palette,
  ggplot2.discrete.fill   = andera_palette
)
