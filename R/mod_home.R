# Módulo: Inicio (portada) — editorial landing
#
# Hero asimétrico (arte + contenido), pasos numerados en serif display,
# grid de features con iconos funcionales y accordion "stack" para tech.

mod_home_ui <- function(id) {
  ns <- NS(id)
  tagList(

    # ==================================================================
    # Hero
    # ==================================================================
    tags$section(
      class = "andera-hero",
      tags$div(class = "andera-hero-inner",
        tags$div(class = "andera-hero-art",
          tags$img(
            src   = "celta.png",
            class = "andera-hero-logo",
            alt   = "Andera — árbol celta"
          )
        ),
        tags$div(class = "andera-hero-content",
          tags$span(class = "andera-eyebrow",
                    "Microbiomas \u00b7 phyloseq \u00b7 Shiny"),
          tags$h1(class = "andera-hero-title", "Andera"),
          tags$p(class = "andera-hero-tagline",
                 "Análisis exploratorio e interactivo de microbiomas"),
          tags$p(class = "andera-hero-sub",
            "Carga un objeto phyloseq y explóralo sin escribir código: diversidad ",
            "alfa y beta, ordenación PCoA, PERMANOVA con ", tags$code("vegan::adonis2"),
            ", mapas de calor y redes de similaridad entre muestras o taxa. ",
            "Pensado para datos de secuenciación 16S rRNA, ITS, 18S o metagenómica ",
            "whole-genome shotgun procesados en cualquier pipeline bioinformático."
          ),
          tags$div(class = "andera-hero-actions",
            actionButton(
              ns("start"), "Comenzar análisis",
              class = "btn btn-primary btn-lg andera-cta",
              icon  = icon("arrow-right")
            ),
            tags$a(class = "andera-secondary-link",
                   href = "#workflow", "C\u00f3mo funciona \u2193")
          )
        )
      )
    ),

    # ==================================================================
    # Qué es Andera — narrativa
    # ==================================================================
    tags$section(class = "andera-section",
      tags$div(class = "andera-section-head",
        tags$span(class = "andera-eyebrow", "Qué es Andera"),
        tags$h2(class = "andera-section-title",
                "Exploración de microbiomas, sin código.")
      ),
      tags$div(class = "andera-section-body",
        tags$p(class = "andera-lede",
          "Andera es un dashboard Shiny construido sobre ",
          tags$a(href = "https://rstudio.github.io/bslib/",
                 target = "_blank", rel = "noopener", "bslib"),
          " que integra los paquetes consolidados del ecosistema R/Bioconductor ",
          "para análisis de comunidades microbianas —",
          tags$b("phyloseq"), ", ", tags$b("microViz"), ", ", tags$b("vegan"),
          ", ", tags$b("microbiome"), " y ", tags$b("ComplexHeatmap"),
          "— en una interfaz editorial que guía al usuario desde la carga de la ",
          "tabla OTU/ASV hasta la generación de figuras publicables."
        ),
        tags$p(
          "Reduce la fricción entre un archivo de abundancias microbianas y las ",
          "visualizaciones estándar de ecología microbiana: estimaciones de ",
          tags$b("diversidad alfa"),
          " (Shannon, Simpson, Chao1, ACE, Fisher), comparaciones de ",
          tags$b("diversidad beta"),
          " mediante ordenaciones PCoA sobre distancias Bray–Curtis, Jaccard, ",
          "UniFrac o UniFrac ponderada, tests de hipótesis ",
          tags$b("PERMANOVA"),
          " para evaluar diferencias significativas en la estructura de las ",
          "comunidades, y ", tags$b("redes de similaridad"),
          " entre muestras o taxa."
        ),
        tags$p(class = "andera-muted",
          "Funciona con datos de secuenciación de amplicones (16S rRNA, ITS, 18S) ",
          "y metagenómica whole-genome, procesados con pipelines como DADA2, ",
          "QIIME 2, mothur o MetaPhlAn. Los tres datasets de ejemplo del paquete ",
          "phyloseq (", tags$em("GlobalPatterns"), ", ", tags$em("Enterotype"), ", ",
          tags$em("Soil"), ") permiten explorar la aplicación sin aportar datos propios."
        )
      )
    ),

    # ==================================================================
    # Workflow — pasos numerados
    # ==================================================================
    tags$section(class = "andera-section", id = "workflow",
      tags$div(class = "andera-section-head",
        tags$span(class = "andera-eyebrow", "Workflow"),
        tags$h2(class = "andera-section-title",
                "Cuatro pasos, del phyloseq al gráfico.")
      ),
      tags$div(class = "andera-steps",

        tags$article(class = "andera-step",
          tags$span(class = "andera-step-num", "01"),
          tags$div(class = "andera-step-body",
            tags$h3("Carga tus datos"),
            tags$p(
              "En ", tags$b("Datos \u25b8 Carga de Datos"),
              " sube un objeto phyloseq serializado en ", tags$code(".rds"),
              " (de cualquier pipeline: DADA2, QIIME 2, mothur, BIOM) o elige ",
              "uno de los tres conjuntos de ejemplo: ",
              tags$em("GlobalPatterns"), ", ", tags$em("Enterotype"), " o ",
              tags$em("Soil"), ". Al pulsar ", tags$b("Actualizar"),
              " verás el resumen estructural y, si existe, el árbol filogenético."
            )
          )
        ),

        tags$article(class = "andera-step",
          tags$span(class = "andera-step-num", "02"),
          tags$div(class = "andera-step-body",
            tags$h3("Filtra por metadata"),
            tags$p(
              "En ", tags$b("Datos \u25b8 Filtrado"),
              ", restringe el análisis a un subconjunto de muestras basándote ",
              "en cualquier variable de la ", tags$code("sample_data"), ". ",
              "Internamente se aplica ", tags$code("microViz::ps_filter"),
              ", que respeta la coherencia del objeto phyloseq completo. El ",
              "resultado se propaga automáticamente a todas las pestañas ",
              "de análisis."
            )
          )
        ),

        tags$article(class = "andera-step",
          tags$span(class = "andera-step-num", "03"),
          tags$div(class = "andera-step-body",
            tags$h3("Explora los análisis"),
            tags$p(
              "Las pestañas de ", tags$b("Análisis"), " (Diversidad, Mapas de ",
              "Calor, PCoA, PERMANOVA, Grafos) requieren un clic sobre ",
              tags$b("Actualizar"), " para ejecutar los cálculos. ",
              "Los parámetros ofrecen distancias ecológicas estándar ",
              "(Bray\u2013Curtis, Jaccard, UniFrac, UniFrac ponderada) y el test ",
              "PERMANOVA permite configurar permutaciones y variable de agrupación."
            )
          )
        ),

        tags$article(class = "andera-step",
          tags$span(class = "andera-step-num", "04"),
          tags$div(class = "andera-step-body",
            tags$h3("Exporta los resultados"),
            tags$p(
              "Cada pestaña incluye descarga al pie del gráfico o tabla: ",
              tags$b("PNG"), " a 150 dpi para figuras, ",
              tags$b("CSV"), " para la tabla PERMANOVA y ",
              tags$b(".rds"), " para el phyloseq original o filtrado. ",
              "La nomenclatura incluye la fecha del día para facilitar ",
              "la trazabilidad."
            )
          )
        )
      )
    ),

    # ==================================================================
    # Capacidades
    # ==================================================================
    tags$section(class = "andera-section",
      tags$div(class = "andera-section-head",
        tags$span(class = "andera-eyebrow", "Capacidades"),
        tags$h2(class = "andera-section-title",
                "Qué puedes hacer en Andera.")
      ),
      tags$div(class = "andera-features",

        tags$article(class = "andera-feature",
          tags$div(class = "andera-feature-icon", bsicons::bs_icon("database")),
          tags$div(class = "andera-feature-body",
            tags$h3("Carga y filtrado"),
            tags$p(
              "Phyloseq serializado de cualquier pipeline (DADA2, QIIME 2, ",
              "mothur, BIOM) o datasets de ejemplo. Filtrado tidy por metadata con ",
              tags$code("ps_filter"), "."
            )
          )
        ),

        tags$article(class = "andera-feature",
          tags$div(class = "andera-feature-icon", bsicons::bs_icon("bar-chart-line")),
          tags$div(class = "andera-feature-body",
            tags$h3("Diversidad alfa"),
            tags$p(
              "Índices Chao1, ACE, Shannon, Simpson, InvSimpson y Fisher. ",
              "Visualización con ", tags$code("plot_richness"),
              " coloreada por variable categórica."
            )
          )
        ),

        tags$article(class = "andera-feature",
          tags$div(class = "andera-feature-icon", bsicons::bs_icon("grid-3x3-gap")),
          tags$div(class = "andera-feature-body",
            tags$h3("Mapas de calor"),
            tags$p(
              "Heatmaps ordenados por NMDS con etiquetado a nivel de OTU/ASV o ",
              "especie. Útiles para identificar abundancia diferencial."
            )
          )
        ),

        tags$article(class = "andera-feature",
          tags$div(class = "andera-feature-icon", bsicons::bs_icon("braces")),
          tags$div(class = "andera-feature-body",
            tags$h3("Ordenación PCoA"),
            tags$p(
              "Análisis de coordenadas principales con distancias Bray\u2013Curtis, ",
              "Jaccard, UniFrac y UniFrac ponderada (requieren árbol)."
            )
          )
        ),

        tags$article(class = "andera-feature",
          tags$div(class = "andera-feature-icon", bsicons::bs_icon("calculator")),
          tags$div(class = "andera-feature-body",
            tags$h3("PERMANOVA"),
            tags$p(
              "Test multivariante por permutaciones con ",
              tags$code("vegan::adonis2"),
              ". Configurable: distancia, variable de agrupación, nº de permutaciones."
            )
          )
        ),

        tags$article(class = "andera-feature",
          tags$div(class = "andera-feature-icon", bsicons::bs_icon("diagram-3")),
          tags$div(class = "andera-feature-body",
            tags$h3("Redes de similaridad"),
            tags$p(
              "Grafos con ", tags$code("plot_net"),
              ": nodos muestras o taxa, aristas por debajo del umbral. ",
              "Clusters de co-ocurrencia o agrupamientos de muestras."
            )
          )
        )
      )
    ),

    # ==================================================================
    # Casos de uso
    # ==================================================================
    tags$section(class = "andera-section",
      tags$div(class = "andera-section-head",
        tags$span(class = "andera-eyebrow", "Casos de uso"),
        tags$h2(class = "andera-section-title",
                "Para quién está pensada Andera.")
      ),
      tags$div(class = "andera-usecases",

        tags$article(class = "andera-usecase",
          tags$h4("Investigación en ecología microbiana"),
          tags$p(
            "Exploración rápida de datasets nuevos antes de un análisis en ",
            "profundidad. Detección preliminar de patrones de diversidad, ",
            "outliers y muestras contaminadas."
          )
        ),

        tags$article(class = "andera-usecase",
          tags$h4("Docencia en bioinformática"),
          tags$p(
            "Herramienta visual para cursos de microbiomas. Conecta los conceptos ",
            "ecológicos (diversidad, beta-diversidad, estructura de comunidades) ",
            "con sus implementaciones computacionales."
          )
        ),

        tags$article(class = "andera-usecase",
          tags$h4("Colaboración interdisciplinar"),
          tags$p(
            "Co-investigadores, clínicos o colaboradores sin formación en R ",
            "pueden explorar el dataset durante reuniones de discusión de ",
            "resultados."
          )
        ),

        tags$article(class = "andera-usecase",
          tags$h4("Prototipado previo al informe"),
          tags$p(
            "Generación de figuras preliminares que posteriormente se ",
            "reproducirán con código en R Markdown o Quarto para el ",
            "manuscrito final."
          )
        )
      )
    ),

    # ==================================================================
    # Stack / dependencias (accordion)
    # ==================================================================
    tags$section(class = "andera-section andera-section-narrow",
      tags$div(class = "andera-section-head",
        tags$span(class = "andera-eyebrow", "Stack"),
        tags$h2(class = "andera-section-title",
                "Constru\u00eddo sobre R, Bioconductor y bslib.")
      ),
      bslib::accordion(
        id       = ns("tech"),
        open     = FALSE,
        multiple = FALSE,
        bslib::accordion_panel(
          title = "Dependencias y reproducibilidad",
          icon  = bsicons::bs_icon("stack"),
          tags$p(
            "Andera requiere ", tags$b("R \u2265 4.5"),
            " y Bioconductor. La reproducibilidad del entorno se gestiona con ",
            tags$a(href = "https://rstudio.github.io/renv/", target = "_blank",
                   rel = "noopener", "renv"),
            ". El tema visual se construye con ",
            tags$a(href = "https://rstudio.github.io/bslib/", target = "_blank",
                   rel = "noopener", "bslib"),
            " + Bootstrap 5 y una hoja de estilos propia. Los tests end-to-end ",
            "usan ",
            tags$a(href = "https://rstudio.github.io/shinytest2/", target = "_blank",
                   rel = "noopener", "shinytest2"), "."
          ),
          tags$dl(class = "andera-deps",
            tags$dt("phyloseq"),
            tags$dd("Bioconductor. Estructura canónica OTU/ASV + taxonomía + árbol + metadata, y funciones base de visualización."),
            tags$dt("microViz"),
            tags$dd("R-universe. Extensiones tidy sobre phyloseq; ps_filter con sintaxis dplyr."),
            tags$dt("vegan"),
            tags$dd("CRAN. Ecología de comunidades; adonis2 para PERMANOVA y matrices de distancias ecológicas."),
            tags$dt("microbiome"),
            tags$dd("Bioconductor. Transformaciones (CLR, proporcional, log) y utilidades adicionales."),
            tags$dt("ComplexHeatmap"),
            tags$dd("Bioconductor. Heatmaps con anotación flexible."),
            tags$dt("bslib, bsicons"),
            tags$dd("Framework de tema Bootstrap 5 para Shiny + iconografía Bootstrap."),
            tags$dt("renv"),
            tags$dd("Gestión de dependencias por proyecto para reproducibilidad."),
            tags$dt("shinytest2"),
            tags$dd("Tests end-to-end con Chromium headless.")
          )
        )
      )
    )
  )
}

mod_home_server <- function(id, parent_session) {
  moduleServer(id, function(input, output, session) {
    observeEvent(input$start, {
      bslib::nav_select(id = "tabs", selected = "data_load",
                        session = parent_session)
    })
  })
}
