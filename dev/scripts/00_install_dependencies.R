# ===================================================================================================================
# 0) Cerrar la app y trabajar en una sesión limpia
# ===================================================================================================================

# Si estás en RStudio, haz antes:
# Session -> Restart R

# ===================================================================================================================
# 1) Vector de paquetes
# ===================================================================================================================

cran_pkgs <- c(
  "shiny",
  "shinycssloaders",
  "shinydashboard",
  "shinyalert",
  "shinyWidgets",
  "shinymeta",
  "htmlwidgets",
  "fresh",
  "tidyverse",
  "data.table",
  "DT",
  "skimr",
  "ggcorrplot",
  "ggstatsplot",
  "PMCMRplus",
  "psych",
  "palettetown",
  "ggsci",
  "viridis",
  "RColorBrewer"
)

bioc_pkgs <- c(
  "phyloseq",
  "vegan",
  "microbiome",
  "ComplexHeatmap"
)

all_pkgs <- c(cran_pkgs, bioc_pkgs)

# ===================================================================================================================
# 2) Descargar cualquier namespace cargado que pueda dar conflicto
# ===================================================================================================================

loaded_now <- intersect(all_pkgs, loadedNamespaces())

for (pkg in rev(loaded_now)) {
  try(unloadNamespace(pkg), silent = TRUE)
}

# ===================================================================================================================
# 3) Eliminar instalaciones previas para evitar mezclas raras
# ===================================================================================================================

installed_now <- rownames(installed.packages())
to_remove <- intersect(all_pkgs, installed_now)

if (length(to_remove) > 0) {
  remove.packages(to_remove)
}

# ===================================================================================================================
# 4) Reinstalar CRAN en binario
# ===================================================================================================================

options(pkgType = "binary")
install.packages(cran_pkgs, dependencies = TRUE, type = "binary")

# ===================================================================================================================
# 5) Instalar y fijar Bioconductor para R 4.5
# ===================================================================================================================

if (!requireNamespace("BiocManager", quietly = TRUE)) {
  install.packages("BiocManager", type = "binary")
}

BiocManager::install(version = "3.22", ask = FALSE)

BiocManager::install(
  bioc_pkgs,
  ask = FALSE,
  update = TRUE
)

# ===================================================================================================================
# 6) Validación de Bioconductor
# ===================================================================================================================

BiocManager::valid()

# ===================================================================================================================
# 7) Comprobación final de versiones clave
# ===================================================================================================================

pkgs_check <- c("dplyr", "ggstatsplot", "phyloseq", "microbiome", "ComplexHeatmap", "vegan")
sapply(pkgs_check, packageVersion)

# ===================================================================================================================
# 8) Cargar paquetes
# ===================================================================================================================

library(shiny)
library(shinycssloaders)
library(shinydashboard)
library(shinyalert)
library(shinyWidgets)
library(shinymeta)
library(htmlwidgets)

library(fresh)

library(tidyverse)
library(data.table)
library(DT)

library(skimr)
library(ggcorrplot)
library(ggstatsplot)
library(PMCMRplus)
library(psych)

library(phyloseq)
library(vegan)
library(microbiome)
library(ComplexHeatmap)

library(palettetown)
library(ggsci)
library(viridis)
library(RColorBrewer)