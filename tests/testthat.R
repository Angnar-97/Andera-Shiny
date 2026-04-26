# Punto de entrada. Se lanza desde la raíz del proyecto:
#   Rscript tests/testthat.R
library(testthat)
library(shinytest2)

test_dir("tests/testthat", reporter = "progress")
