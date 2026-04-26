# ----- Andera-Shiny ----
#
# Shiny dashboard para el análisis exploratorio de microbiomas.
# Los módulos Shiny viven en R/ y son autocargados por Shiny.

# ----- Paquetes de interfaz -----
library(shiny)
library(shinycssloaders)
library(shinydashboard)
library(shinyalert)
library(shinyWidgets)
library(shinymeta)
library(htmlwidgets)

# ----- Tema del dashboard -----
library(fresh)

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
  theme_light() +
    theme(text = element_text(size = 16, family = "serif"))
)
