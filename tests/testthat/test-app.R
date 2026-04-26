# Tests de integración end-to-end con shinytest2.
# Cada test lanza una instancia independiente de la app (más lento pero aislado).

load_global_patterns <- function(app) {
  app$set_inputs(
    `data_load-data_source` = "Conjunto de datos de ejemplo",
    `data_load-dataset`     = "Global Patterns"
  )
  app$click("data_load-update")
  app$wait_for_idle()
  invisible(app)
}

test_that("data_load: Global Patterns renders summary with expected taxa count", {
  app <- new_driver("data_load")
  on.exit(app$stop(), add = TRUE)

  load_global_patterns(app)

  summary_text <- app$get_value(output = "data_load-physeq_summary")
  expect_match(summary_text, "phyloseq-class")
  expect_match(summary_text, "19216")
  expect_match(summary_text, "26 samples")
})

test_that("filtering: ps_filter reduces nsamples", {
  app <- new_driver("filtering")
  on.exit(app$stop(), add = TRUE)

  load_global_patterns(app)

  app$set_inputs(sidebarItemExpanded = "filtering", allow_no_input_binding_ = TRUE)
  app$click(selector = "a[data-value='filtering']")
  app$wait_for_idle()

  app$set_inputs(`filtering-variable` = "SampleType")
  app$wait_for_idle()
  app$set_inputs(`filtering-value` = "Feces")
  app$wait_for_idle()
  app$click("filtering-filter")
  app$wait_for_idle(timeout = 20000)

  summary_text <- app$get_value(output = "filtering-filtered_physeq_summary")
  expect_match(summary_text, "phyloseq-class")
  # GlobalPatterns: SampleType == "Feces" tiene 4 muestras
  expect_match(summary_text, "4 samples")
})

test_that("diversity: plot_richness output renders without errors", {
  app <- new_driver("diversity")
  on.exit(app$stop(), add = TRUE)

  load_global_patterns(app)

  app$click(selector = "a[data-value='diversity']")
  app$wait_for_idle()

  app$set_inputs(`diversity-variable_alpha` = "SampleType")
  app$wait_for_idle()
  app$click("diversity-update_diversity")
  app$wait_for_idle(timeout = 30000)

  # El plot debe tener content no vacío
  html <- app$get_html("#diversity-diversityPlot img")
  expect_true(!is.null(html) && nzchar(html))
})

test_that("pcoa: bray distance produces a plot", {
  app <- new_driver("pcoa")
  on.exit(app$stop(), add = TRUE)

  load_global_patterns(app)

  app$click(selector = "a[data-value='pcoa']")
  app$wait_for_idle()

  app$set_inputs(
    `pcoa-distance_pcoa`  = "bray",
    `pcoa-color_variable` = "SampleType"
  )
  app$wait_for_idle()
  app$click("pcoa-update_pcoa")
  app$wait_for_idle(timeout = 60000)

  html <- app$get_html("#pcoa-pcoaPlot img")
  expect_true(!is.null(html) && nzchar(html))
})

test_that("permanova: adonis2 populates the results table", {
  app <- new_driver("permanova")
  on.exit(app$stop(), add = TRUE)

  load_global_patterns(app)

  app$click(selector = "a[data-value='permanova']")
  app$wait_for_idle()

  app$set_inputs(
    `permanova-distance_permanova` = "bray",
    `permanova-grouping_variable`  = "SampleType",
    `permanova-permutations`       = 99
  )
  app$wait_for_idle()
  app$click("permanova-update_permanova")
  app$wait_for_idle(timeout = 90000)

  tbl_html <- app$get_html("#permanova-permanovaResults")
  expect_true(grepl("Df",      tbl_html, fixed = TRUE))
  expect_true(grepl("Pr\\(",  tbl_html))     # columna Pr(>F)
  expect_true(grepl("SampleType", tbl_html))
})

test_that("heatmaps: OTU heatmap renders", {
  app <- new_driver("heatmaps")
  on.exit(app$stop(), add = TRUE)

  load_global_patterns(app)

  app$click(selector = "a[data-value='heatmaps']")
  app$wait_for_idle()
  app$click("heatmaps-update_heatmaps")
  app$wait_for_idle(timeout = 120000)

  html <- app$get_html("#heatmaps-heatmap_otus img")
  expect_true(!is.null(html) && nzchar(html))
})

test_that("grafos: sample network renders", {
  app <- new_driver("grafos")
  on.exit(app$stop(), add = TRUE)

  load_global_patterns(app)

  app$click(selector = "a[data-value='grafos']")
  app$wait_for_idle()

  app$set_inputs(
    `grafos-type`           = "samples",
    `grafos-distance`       = "jaccard",
    `grafos-maxdist`        = 0.9,
    `grafos-color_variable` = "SampleType"
  )
  app$wait_for_idle()
  app$click("grafos-update_graph")
  app$wait_for_idle(timeout = 60000)

  html <- app$get_html("#grafos-networkPlot img")
  expect_true(!is.null(html) && nzchar(html))
})
