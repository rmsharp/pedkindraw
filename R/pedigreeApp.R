## Copyright(c) 2017-2026 R. Mark Sharp
## This file is part of pedkindraw
## pedkindraw's own code, not copied from nprcgenekeepr (pedkindraw S74, plan
## Phase G17a, gap A3 of docs/research/pedkindraw-gaps-2026-11-18.md; rulings
## R148 and R149, docs/planning/pedigree-app-plan.md sections 5, 7 and 11).
## The app runPedigreeApp() starts: its page and its server, internal so they
## can change (R148). shiny is in Suggests, so every shiny call is written
## shiny:: and runs only after runPedigreeApp() has found shiny.

## The names the app recognises for each of the four columns, in the order it
## prefers them (R149): pedkindraw's own, nprcgenekeepr's (egoid, sireid,
## damid) and Pedixplorer's app's (indid, dadid, fatherid, momid, motherid,
## gender). A column's name is compared after lower-casing it and removing
## spaces, dots and underscores.
.appColumnNames <- list(
  id = c("id", "ego", "egoid", "indid"),
  sire = c("sire", "sireid", "father", "fatherid", "dadid"),
  dam = c("dam", "damid", "mother", "motherid", "momid"),
  sex = c("sex", "gender")
)

## The sex values the app reads as pedkindraw's codes (R149), keyed by the
## value lower-cased with its spaces at either end removed; 1 and 2 are
## kinship2's and PLINK's male and female.
.appSexCodes <- c(m = "M", male = "M", "1" = "M",
                  f = "F", female = "F", "2" = "F",
                  h = "H", hermaphrodite = "H",
                  u = "U", unknown = "U")

#' Guess which of a file's columns are id, sire, dam and sex
#'
#' @param columns the file's column names.
#' @return A character vector named id, sire, dam and sex: for each, the first
#'   column whose name is the earliest of \code{.appColumnNames}' names for it,
#'   or \code{NA} where none matches.
#' @noRd
.guessAppColumns <- function(columns) {
  key <- gsub("[ ._]", "", tolower(columns))
  vapply(.appColumnNames, function(names) {
    for (name in names) {
      hit <- which(key == name)
      if (length(hit) > 0L) {
        return(columns[[hit[[1L]]]])
      }
    }
    NA_character_
  }, character(1L))
}

#' Read the common sex codes as M, F, H and U
#'
#' @param sex the sex values, of any type.
#' @return A character vector: each value of \code{.appSexCodes} read as its
#'   code, any other value (and \code{NA}) as it was.
#' @noRd
.readSexCodes <- function(sex) {
  sex <- as.character(sex)
  read <- unname(.appSexCodes[tolower(trimws(sex))])
  known <- !is.na(read)
  sex[known] <- read[known]
  sex
}

#' Say which sex values the app read as which code
#'
#' @param sex the sex values as the file holds them.
#' @return One sentence naming each value read as another, in the order the
#'   values first appear, or \code{""} when none changed.
#' @noRd
.sexCodeNote <- function(sex) {
  sex <- as.character(sex)
  read <- .readSexCodes(sex)
  changed <- !is.na(sex) & sex != read
  if (!any(changed)) {
    return("")
  }
  paste0("Sex values read as pedkindraw's codes: ",
         toString(unique(paste(sex[changed], "as", read[changed]))), ".")
}

#' The sample pedigree's file
#' @noRd
.appSamplePath <- function() {
  system.file("extdata", "obfuscated_rhesus_mhc_ped.csv",
              package = "pedkindraw")
}

#' Read a pedigree file as text
#'
#' @param path the file.
#' @return A list: \code{data}, the file's rows with every column as text and
#'   empty cells as \code{NA} (\code{NULL} when it could not be read), and
#'   \code{problem}, what went wrong or \code{""}.
#' @noRd
.readAppFile <- function(path) {
  data <- tryCatch(
    utils::read.csv(path, colClasses = "character",
                    na.strings = c("", "NA"), check.names = FALSE),
    error = function(e) e
  )
  if (inherits(data, "error")) {
    return(list(data = NULL, problem = paste("The file could not be read:",
                                             conditionMessage(data))))
  }
  list(data = data, problem = "")
}

#' What is wrong with the rows read, for the page to say
#'
#' @param data the rows read, or \code{NULL}.
#' @param readProblem what went wrong reading them, or \code{""}.
#' @return The first problem found, or \code{""}.
#' @noRd
.appTableProblem <- function(data, readProblem) {
  if (nzchar(readProblem) || is.null(data)) {
    return(readProblem)
  }
  if (ncol(data) < 4L) {
    return(sprintf(paste0("The file has %d columns; the app needs at least ",
                          "four: id, sire, dam and sex."), ncol(data)))
  }
  if (nrow(data) == 0L) {
    return("The file has no animals.")
  }
  ""
}

#' What is wrong with the columns chosen, for the page to say
#'
#' @param columns the columns chosen so far: fewer than four until each of
#'   id, sire, dam and sex has been given one.
#' @return The problem, or \code{""}.
#' @noRd
.appColumnProblem <- function(columns) {
  if (length(columns) < 4L) {
    return("")
  }
  if (!all(nzchar(columns))) {
    return("Choose a column for each of id, sire, dam and sex.")
  }
  if (anyDuplicated(columns) > 0L) {
    return("Choose a different column for each of id, sire, dam and sex.")
  }
  ""
}

#' The pedigree the app draws, from the rows read and the columns chosen
#'
#' @param data the rows read.
#' @param columns the columns chosen, named id, sire, dam and sex.
#' @return A data frame: id, sire and dam as text, sex read by
#'   \code{.readSexCodes()}, then the other columns but any whose name is one
#'   of the four.
#' @noRd
.appPedigree <- function(data, columns) {
  four <- data.frame(id = as.character(data[[columns[["id"]]]]),
                     sire = as.character(data[[columns[["sire"]]]]),
                     dam = as.character(data[[columns[["dam"]]]]),
                     sex = .readSexCodes(data[[columns[["sex"]]]]))
  rest <- !names(data) %in% c(columns, names(columns))
  cbind(four, data[, rest, drop = FALSE])
}

#' Draw a pedigree, keeping what the functions said
#'
#' Adds \code{gen} with \code{findGeneration()} and draws with
#' \code{makePedigreeMatingLayout()} and \code{drawPedigreeDiagram()}. Their
#' warnings and messages, which would reach only the console, are kept as
#' notes, and an error is kept instead of stopping the app.
#'
#' @param ped the pedigree.
#' @return A list: \code{widget} (\code{NULL} when the drawing failed),
#'   \code{notes} and \code{error} (\code{NULL} or the error's message).
#' @noRd
.appDraw <- function(ped) {
  kept <- new.env(parent = emptyenv())
  kept$notes <- character(0L)
  keep <- function(condition, restart) {
    kept$notes <- c(kept$notes, trimws(conditionMessage(condition)))
    invokeRestart(restart)
  }
  widget <- withCallingHandlers(
    tryCatch({
      ped$gen <- findGeneration(ped$id, ped$sire, ped$dam)
      drawPedigreeDiagram(makePedigreeMatingLayout(ped))
    }, error = function(e) e),
    warning = function(w) keep(w, "muffleWarning"),
    message = function(m) keep(m, "muffleMessage")
  )
  if (inherits(widget, "error")) {
    return(list(widget = NULL, notes = kept$notes,
                error = conditionMessage(widget)))
  }
  list(widget = widget, notes = kept$notes, error = NULL)
}

#' How many animals a drawing shows
#' @noRd
.appDrawnCount <- function(widget) {
  ids <- as.character(widget$x$nodes$id)
  n <- sum(!startsWith(ids, "__"))
  sprintf(ngettext(n, "%d animal drawn", "%d animals drawn"), n)
}

#' The app's page
#' @noRd
.pedigreeAppUi <- function() {
  shiny::fluidPage(
    shiny::titlePanel("pedkindraw: draw a pedigree"),
    shiny::sidebarLayout(
      shiny::sidebarPanel(
        width = 3L,
        shiny::fileInput("file", "Pedigree file (CSV or text)",
                         accept = c(".csv", ".txt")),
        shiny::actionButton("sample", "Use the sample pedigree"),
        shiny::hr(),
        shiny::uiOutput("columns"),
        shiny::textOutput("sexNote")
      ),
      shiny::mainPanel(
        width = 9L,
        shiny::tabsetPanel(
          id = "tabs",
          shiny::tabPanel(
            "Diagram",
            shiny::textOutput("drawn"),
            shiny::tagAppendAttributes(shiny::textOutput("problem"),
                                       style = "color: #b00020;"),
            shiny::tagAppendAttributes(shiny::textOutput("notes"),
                                       style = "white-space: pre-wrap;"),
            visNetwork::visNetworkOutput("diagram", height = "650px")
          ),
          shiny::tabPanel("Checks", shiny::textOutput("checkSummary"),
                          shiny::tableOutput("checks")),
          shiny::tabPanel("Animals", shiny::tableOutput("table"))
        )
      )
    )
  )
}

#' The app's server
#'
#' @param ped \code{NULL}, or a pedigree to open as if read from a file.
#' @return A server function for \code{shiny::shinyApp()}.
#' @noRd
.pedigreeAppServer <- function(ped = NULL) {
  force(ped)
  function(input, output, session) {
    rawData <- shiny::reactiveVal(ped)
    readProblem <- shiny::reactiveVal("")
    openRows <- function(read) {
      rawData(read$data)
      readProblem(read$problem)
    }
    shiny::observeEvent(input$file,
                        openRows(.readAppFile(input$file$datapath)))
    shiny::observeEvent(input$sample, openRows(.readAppFile(.appSamplePath())))

    columnGuess <- shiny::reactive({
      shiny::req(rawData())
      .guessAppColumns(names(rawData()))
    })
    output$columns <- shiny::renderUI({
      guess <- columnGuess()
      choices <- c("(choose)" = "", names(rawData()))
      shiny::tagList(lapply(names(guess), function(field) {
        shiny::selectInput(paste0(field, "Column"),
                           sprintf("Column for %s", field), choices,
                           selected = if (is.na(guess[[field]])) {
                             ""
                           } else {
                             guess[[field]]
                           })
      }))
    })
    chosen <- shiny::reactive(c(id = input$idColumn, sire = input$sireColumn,
                                dam = input$damColumn,
                                sex = input$sexColumn))

    tableProblem <- shiny::reactive(.appTableProblem(rawData(), readProblem()))
    columnProblem <- shiny::reactive(.appColumnProblem(chosen()))
    ready <- shiny::reactive({
      columns <- chosen()
      !is.null(rawData()) && !nzchar(tableProblem()) &&
        length(columns) == 4L && !nzchar(columnProblem()) &&
        all(columns %in% names(rawData()))
    })

    pedigree <- shiny::reactive({
      shiny::req(rawData(), !nzchar(tableProblem()), length(chosen()) == 4L)
      shiny::validate(shiny::need(!nzchar(columnProblem()), columnProblem()))
      shiny::req(ready())
      .appPedigree(rawData(), chosen())
    })
    checks <- shiny::reactive(checkPedigree(pedigree()))
    drawing <- shiny::reactive({
      shiny::req(ready())
      .appDraw(pedigree())
    })

    output$sexNote <- shiny::renderText({
      shiny::req(ready())
      .sexCodeNote(rawData()[[chosen()[["sex"]]]])
    })
    output$problem <- shiny::renderText({
      for (problem in c(tableProblem(), columnProblem())) {
        if (nzchar(problem)) {
          return(problem)
        }
      }
      if (!ready() || is.null(drawing()$error)) {
        return("")
      }
      sprintf(paste0("The pedigree could not be drawn (%s). The Checks tab ",
                     "lists the records' problems."), drawing()$error)
    })
    output$drawn <- shiny::renderText({
      if (!ready() || is.null(drawing()$widget)) {
        return("")
      }
      .appDrawnCount(drawing()$widget)
    })
    output$notes <- shiny::renderText({
      if (!ready()) {
        return("")
      }
      paste(unique(drawing()$notes), collapse = "\n")
    })
    output$diagram <- visNetwork::renderVisNetwork({
      shiny::req(drawing()$widget)
    })
    output$checkSummary <- shiny::renderText({
      if (!ready()) {
        return("")
      }
      n <- nrow(checks())
      if (n == 0L) {
        return("No problems found.")
      }
      sprintf(ngettext(n, "%d problem found.", "%d problems found."), n)
    })
    output$checks <- shiny::renderTable(checks())
    output$table <- shiny::renderTable(pedigree())
  }
}
