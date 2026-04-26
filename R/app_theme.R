# ----- Tema bslib + paleta ggplot para Andera -----
#
# Paleta "medioambiental / microbioma" — tono sage + toque dorado:
#   primary   #4A6D5E  (verde sage profundo — primary accesible sobre blanco)
#   secondary #B87355  (terracota — suelo/tierra)
#   success   #8FA872  (hoja sage — más muted que leaf verde)
#   info      #5B7D8C  (azul grisáceo — agua)
#   warning   #D4A437  (ámbar — avisos visibles)
#   danger    #8C3B3B  (oxblood)
#   bg        #FAF7F0  (crema/hueso)
#   fg        #2A3D32  (verde bosque oscuro — más cálido que el forest puro)
#
# Toque dorado (accent secundario, editorial):
#   gold      #C4A962  (usado en eyebrows, ::selection, hover sutiles)
#
# Tipografía editorial:
#   Crimson Pro   — display / headings
#   Inter         — body
#   JetBrains Mono — código

andera_theme <- function() {
  bslib::bs_theme(
    version      = 5,
    bootswatch   = NULL,
    primary      = "#4A6D5E",
    secondary    = "#B87355",
    success      = "#8FA872",
    info         = "#5B7D8C",
    warning      = "#D4A437",
    danger       = "#8C3B3B",
    bg           = "#FAF7F0",
    fg           = "#2A3D32",
    base_font    = bslib::font_google("Inter"),
    heading_font = bslib::font_google("Crimson Pro"),
    code_font    = bslib::font_google("JetBrains Mono"),

    # ---- Global tokens ----
    "body-bg"          = "#FAF7F0",
    "body-color"       = "#2A3D32",
    "border-radius"    = "0.5rem",
    "border-radius-sm" = "0.35rem",
    "border-radius-lg" = "0.65rem",

    # ---- Cards ----
    "card-border-color" = "#E5DDC9",
    "card-cap-bg"       = "#FFFFFF",
    "card-bg"           = "#FFFFFF",

    # ---- Navbar ----
    "navbar-bg"                 = "#2A3D32",
    "navbar-dark-color"         = "rgba(255,255,255,0.72)",
    "navbar-dark-hover-color"   = "#FFFFFF",
    "navbar-dark-active-color"  = "#FFFFFF",
    "navbar-brand-font-size"    = "1.25rem",

    # ---- Inputs / buttons ----
    "input-border-color"       = "#D4CAB2",
    "input-focus-border-color" = "#4A6D5E",
    "btn-font-weight"          = "500"
  )
}

# ---------------------------------------------------------------------------
# Paleta ggplot coherente con el tema (sage + terracota + toque dorado).
# ---------------------------------------------------------------------------

andera_palette <- c(
  "#4A6D5E",  # sage deep (primary)
  "#B87355",  # terracota (secondary)
  "#C4A962",  # gold (accent editorial)
  "#8FA872",  # sage leaf
  "#5B7D8C",  # water blue
  "#8C3B3B",  # oxblood
  "#6B4A7A",  # muted purple
  "#2E5D5C"   # deep teal
)

scale_color_andera <- function(...) ggplot2::scale_color_manual(values = andera_palette, ...)
scale_fill_andera  <- function(...) ggplot2::scale_fill_manual (values = andera_palette, ...)

# Aplica la paleta como default discreto para todos los ggplots.
options(
  ggplot2.discrete.colour = andera_palette,
  ggplot2.discrete.fill   = andera_palette
)
