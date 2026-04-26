# Utilidades para trabajar con objetos phyloseq y helpers de descarga.

has_tree <- function(ps) {
  tryCatch(
    !is.null(phyloseq::phy_tree(ps)),
    error = function(e) FALSE
  )
}

load_example_dataset <- function(name) {
  env <- new.env()
  switch(
    name,
    "Global Patterns" = {
      utils::data("GlobalPatterns", package = "phyloseq", envir = env)
      env$GlobalPatterns
    },
    "Enterotype" = {
      utils::data("enterotype", package = "phyloseq", envir = env)
      env$enterotype
    },
    "Soil" = {
      utils::data("soilrep", package = "phyloseq", envir = env)
      env$soilrep
    },
    NULL
  )
}

# ----- Helpers de descarga -----

# downloadHandler para un ggplot que vive en un reactive/función sin argumentos.
# Si el reactive devuelve NULL, la descarga se detiene silenciosamente.
download_plot <- function(plot_reactive, prefix,
                          width = 8, height = 6, dpi = 150) {
  shiny::downloadHandler(
    filename = function() paste0(prefix, "-", Sys.Date(), ".png"),
    content  = function(file) {
      p <- plot_reactive()
      shiny::req(p)
      ggplot2::ggsave(file, plot = p, width = width, height = height, dpi = dpi)
    }
  )
}

# downloadHandler para un data.frame reactive → CSV.
download_csv <- function(df_reactive, prefix) {
  shiny::downloadHandler(
    filename = function() paste0(prefix, "-", Sys.Date(), ".csv"),
    content  = function(file) {
      d <- df_reactive()
      shiny::req(d)
      utils::write.csv(as.data.frame(d), file, row.names = TRUE)
    }
  )
}

# downloadHandler para cualquier objeto R → RDS.
download_rds <- function(obj_reactive, prefix) {
  shiny::downloadHandler(
    filename = function() paste0(prefix, "-", Sys.Date(), ".rds"),
    content  = function(file) {
      obj <- obj_reactive()
      shiny::req(obj)
      saveRDS(obj, file)
    }
  )
}
