# Helpers compartidos entre tests.
# `file.path("..", "..")` desde tests/testthat/ lleva a la raíz del proyecto.
app_dir <- normalizePath(file.path("..", ".."), mustWork = TRUE)

new_driver <- function(name, ...) {
  shinytest2::AppDriver$new(
    app_dir        = app_dir,
    name           = name,
    load_timeout   = 60 * 1000,   # 60s — las deps Bioc tardan en cargar
    timeout        = 20 * 1000,
    ...
  )
}
