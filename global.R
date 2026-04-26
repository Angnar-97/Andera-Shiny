# ----- Andera-Shiny ----
#
# Shiny dashboard para el análisis exploratorio de microbiomas.
# Los módulos Shiny viven en R/ y son autocargados por Shiny.

# ----- Shiny + Bootstrap 5 (bslib) -----
library(shiny)
library(bslib)
library(bsicons)
library(shinycssloaders)
library(shinyalert)
library(shinyWidgets)
library(shinymeta)
library(htmlwidgets)

# ----- Tablas y manipulación de datos -----
library(tidyverse)
library(data.table)
library(DT)

# ----- Estadística -----
library(skimr)
library(ggcorrplot)
library(ggstatsplot)
library(PMCMRplus)
library(psych)

# ----- Bioconductor -----
library(phyloseq)
library(vegan)
library(microbiome)
library(ComplexHeatmap)
library(microViz)

# ----- Paletas -----
library(palettetown)
library(ggsci)
library(viridis)
library(RColorBrewer)

# ----- Tema ggplot común -----
theme_set(
  theme_minimal(base_size = 14, base_family = "serif") +
    theme(
      plot.background  = element_rect(fill = "#FAF7F0", color = NA),
      panel.background = element_rect(fill = "#FAF7F0", color = NA),
      panel.grid.minor = element_blank(),
      panel.grid.major = element_line(color = "#E5DDC9", linewidth = 0.25),
      strip.background = element_rect(fill = "#E5DDC9", color = NA),
      strip.text       = element_text(color = "#1F2E28", face = "bold")
    )
)
