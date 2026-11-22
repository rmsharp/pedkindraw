# G17 planning prototype (S73): a small Shiny app built only from pedkindraw's
# exports, to measure its size, testServer() time and browser time. Not
# package code; every shiny call is shiny:: as it must be with shiny in
# Suggests.
protoUI <- function() {
  shiny::fluidPage(
    shiny::titlePanel("pedkindraw"),
    shiny::sidebarLayout(
      shiny::sidebarPanel(
        width = 3L,
        shiny::fileInput("file", "Pedigree file (CSV)", accept = ".csv"),
        shiny::actionButton("sample", "Use the sample pedigree"),
        shiny::hr(),
        shiny::uiOutput("columnsUI"),
        shiny::radioButtons("show", "Animals to draw",
                            c("Everyone" = "all", "One family" = "family",
                              "Focal animals' ancestors and descendants" = "lineal",
                              "Focal animals' near relatives" = "near")),
        shiny::uiOutput("familyUI"),
        shiny::textAreaInput("focal", "Focal animals (or click one)", rows = 3L),
        shiny::numericInput("maxDist", "Near relatives: steps", 2L, min = 1L),
        shiny::uiOutput("conditionsUI"),
        shiny::radioButtons("edgeStyle", "Lines",
                            c(Rectilinear = "rectilinear", Direct = "direct"),
                            inline = TRUE),
        shiny::hr(),
        shiny::downloadButton("saveSvg", "SVG"),
        shiny::downloadButton("savePdf", "PDF"),
        shiny::downloadButton("savePng", "PNG"),
        shiny::downloadButton("saveCsv", "CSV")
      ),
      shiny::mainPanel(
        width = 9L,
        shiny::tabsetPanel(
          id = "tabs",
          shiny::tabPanel("Diagram", shiny::textOutput("drawn"),
                          visNetwork::visNetworkOutput("diagram", height = "650px")),
          shiny::tabPanel("Checks", shiny::tableOutput("checks")),
          shiny::tabPanel("Table", shiny::tableOutput("table"))
        )
      )
    )
  )
}

protoServer <- function(input, output, session) {
  raw <- shiny::reactiveVal(NULL)
  shiny::observeEvent(input$file, {
    raw(utils::read.csv(input$file$datapath, colClasses = "character",
                        na.strings = c("", "NA")))
  })
  shiny::observeEvent(input$sample, {
    raw(utils::read.csv(system.file("extdata", "obfuscated_rhesus_mhc_ped.csv",
                                    package = "pedkindraw"),
                        colClasses = "character", na.strings = c("", "NA")))
  })
  .pick <- function(name, choices, guess) {
    hit <- choices[tolower(choices) %in% guess]
    shiny::selectInput(name, sprintf("Column: %s", sub("col", "", name)),
                       choices, selected = if (length(hit)) hit[[1L]] else NULL)
  }
  output$columnsUI <- shiny::renderUI({
    shiny::req(raw())
    n <- names(raw())
    shiny::tagList(.pick("colid", n, c("id", "ego", "indid")),
                   .pick("colsire", n, c("sire", "father", "dadid", "fatherid")),
                   .pick("coldam", n, c("dam", "mother", "momid", "motherid")),
                   .pick("colsex", n, c("sex", "gender")))
  })
  ped <- shiny::reactive({
    shiny::req(raw(), input$colid, input$colsire, input$coldam, input$colsex)
    r <- raw()
    p <- data.frame(id = r[[input$colid]], sire = r[[input$colsire]],
                    dam = r[[input$coldam]], sex = r[[input$colsex]])
    p$gen <- findGeneration(p$id, p$sire, p$dam)
    for (col in input$conditions) {
      p[[paste0("affected_", col)]] <- r[[col]] %in% c("1", "TRUE", "Y", "yes")
    }
    p
  })
  output$conditionsUI <- shiny::renderUI({
    shiny::req(raw())
    shiny::selectizeInput("conditions", "Conditions (up to 4)", names(raw()),
                          multiple = TRUE, options = list(maxItems = 4L))
  })
  families <- shiny::reactive({
    p <- ped()
    findPedigreeNumber(p$id, p$sire, p$dam)
  })
  output$familyUI <- shiny::renderUI({
    shiny::req(input$show == "family")
    sizes <- sort(table(families()), decreasing = TRUE)
    shiny::selectInput("family", "Family",
                       stats::setNames(names(sizes),
                                       sprintf("%s (%d animals)", names(sizes), sizes)))
  })
  focalIds <- shiny::reactive({
    ids <- trimws(unlist(strsplit(input$focal %||% "", "[,;\t\n\r ]+")))
    intersect(ids[nzchar(ids)], ped()$id)
  })
  shown <- shiny::reactive({
    p <- ped()
    switch(input$show,
           all = p,
           family = { shiny::req(input$family); p[families() == input$family, ] },
           lineal = {
             shiny::req(length(focalIds()) > 0L)
             keep <- union(trimPedigree(p, focalIds())$id,
                           getDescendantPedigree(p, focalIds())$id)
             p[p$id %in% keep, ]
           },
           near = {
             shiny::req(length(focalIds()) > 0L)
             getNearRelativePedigree(p, focalIds(), input$maxDist)
           })
  })
  layout <- shiny::reactive(makePedigreeMatingLayout(shown(), edgeStyle = input$edgeStyle))
  diagram <- shiny::reactive(drawPedigreeDiagram(
    layout(), edgeStyle = input$edgeStyle,
    onClick = "function(n) { Shiny.setInputValue('clicked', n.nodes); }"))
  output$diagram <- visNetwork::renderVisNetwork(diagram())
  output$drawn <- shiny::renderText(sprintf("%d animals drawn", nrow(shown())))
  shiny::observeEvent(input$clicked, {
    ids <- as.character(unlist(input$clicked))
    ids <- ids[!startsWith(ids, "__")]
    shiny::req(length(ids) > 0L)
    shiny::updateTextAreaInput(session, "focal", value = paste(ids, collapse = "\n"))
  })
  output$checks <- shiny::renderTable(checkPedigree(ped()))
  output$table <- shiny::renderTable(shown())
  .saver <- function(ext) shiny::downloadHandler(
    filename = function() paste0("pedigree.", ext),
    content = function(file) savePedigreeDiagram(diagram(), file))
  output$saveSvg <- .saver("svg")
  output$savePdf <- .saver("pdf")
  output$savePng <- .saver("png")
  output$saveCsv <- shiny::downloadHandler(
    filename = function() "pedigree.csv",
    content = function(file) utils::write.csv(shown(), file, row.names = FALSE))
}
