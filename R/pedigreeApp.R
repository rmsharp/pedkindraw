## Copyright(c) 2017-2026 R. Mark Sharp
## This file is part of pedkindraw
## pedkindraw's own code, not copied from nprcgenekeepr (pedkindraw S74, plan
## Phase G17a, gap A3 of docs/research/pedkindraw-gaps-2026-11-18.md; rulings
## R148 and R149, docs/planning/pedigree-app-plan.md sections 5, 7 and 11;
## choosing the animals pedkindraw S75, Phase G17b, R150, section 12).
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

#' Add a row for each parent with no row of its own (R150)
#'
#' @param ped the pedigree.
#' @return A list: \code{ped}, the pedigree with \code{addParents()}'s rows
#'   (unchanged when every parent has a row), and \code{added}, the ids
#'   added.
#' @noRd
.appAddParents <- function(ped) {
  parents <- c(ped$sire, ped$dam)
  if (!any(!is.na(parents) & !parents %in% ped$id)) {
    return(list(ped = ped, added = character(0L)))
  }
  ped <- addParents(ped)
  list(ped = ped, added = ped$id[ped$recordStatus == "added"])
}

#' The ids typed in the focal box
#'
#' @param text what was typed, or \code{NULL}.
#' @return The ids, split at commas, semicolons, spaces, tabs and new lines,
#'   each once, in the order typed.
#' @noRd
.appFocalIds <- function(text) {
  ids <- as.character(unlist(strsplit(as.character(text), "[,;[:space:]]+")))
  unique(ids[nzchar(ids)])
}

#' The families the app lists, for a select input
#'
#' @param family each animal's family, from \code{findPedigreeNumber()}.
#' @return The families of two or more animals, largest first (the lower
#'   number first among equals), each named "Family n: k animals".
#' @noRd
.appFamilyChoices <- function(family) {
  sizes <- table(family)
  sizes <- sizes[sizes >= 2L]
  numbers <- as.character(names(sizes))
  numbers <- numbers[order(-as.integer(sizes), as.numeric(numbers))]
  stats::setNames(numbers, sprintf("Family %s: %d animals", numbers,
                                   as.integer(sizes[numbers])))
}

#' Say how many animals the family list leaves out
#'
#' @param family each animal's family, from \code{findPedigreeNumber()}.
#' @return A sentence counting the families of one animal, or \code{""}.
#' @noRd
.appAloneNote <- function(family) {
  n <- sum(table(family) == 1L)
  if (n == 0L) {
    return("")
  }
  sprintf(ngettext(n,
                   "%s animal has no relative in the file and is not listed.",
                   paste("%s animals have no relative in the file and are not",
                         "listed.")),
          format(n, big.mark = ","))
}

#' Focal animals with their ancestors and descendants (F7, R150)
#'
#' @param ped the pedigree.
#' @param focal the focal animals' ids, each with a row.
#' @return The rows of \code{ped} that are the focal animals, their
#'   ancestors and their descendants, with each other parent of theirs added,
#'   its \code{sire} and \code{dam} set to \code{NA}; in \code{ped}'s order.
#' @noRd
.appLineal <- function(ped, focal) {
  keep <- union(trimPedigree(ped, focal)$id,
                getDescendantPedigree(ped, focal)$id)
  kept <- ped[ped$id %in% keep, ]
  parents <- c(kept$sire, kept$dam)
  outside <- parents[!is.na(parents) & !parents %in% keep]
  lineal <- ped[ped$id %in% c(keep, outside), ]
  added <- lineal$id %in% outside
  lineal$sire[added] <- NA
  lineal$dam[added] <- NA
  lineal
}

#' Choose the animals to draw (F6-F8, R150)
#'
#' @param ped the pedigree, every parent with a row of its own.
#' @param view \code{"all"}, \code{"family"}, \code{"lineal"} or
#'   \code{"near"}.
#' @param focal the focal animals' ids as typed; an id with no row is left
#'   out.
#' @param close how close, for \code{"near"}.
#' @param family the family chosen, or \code{NULL}.
#' @param families each animal's family, for \code{"family"}.
#' @return A list: \code{rows}, the animals chosen (\code{NULL} when none can
#'   be chosen yet or they could not be chosen), and \code{problem}, what the
#'   page says, or \code{""}.
#' @noRd
.appChooseAnimals <- function(ped, view, focal, close, family, families) {
  focal <- intersect(focal, ped$id)
  if (view %in% c("lineal", "near") && length(focal) == 0L) {
    return(list(rows = NULL, problem = ""))
  }
  if (view == "near" && !(is.numeric(close) && length(close) == 1L &&
                            is.finite(close) && close >= 1.0)) {
    return(list(rows = NULL,
                problem = "Choose how close: a number, 1 or more."))
  }
  rows <- tryCatch(switch(
    view,
    family = if (is.null(family)) {
      NULL
    } else {
      ped[as.character(families) %in% family, ]
    },
    lineal = .appLineal(ped, focal),
    near = getNearRelativePedigree(ped, focal, close),
    ped
  ), error = function(e) e)
  if (inherits(rows, "error")) {
    return(list(rows = NULL, problem = sprintf(paste0(
      "The animals could not be chosen (%s). The Checks tab lists the ",
      "records' problems."), conditionMessage(rows))))
  }
  list(rows = rows, problem = "")
}

#' The JavaScript a drawing runs when clicked: it sends the clicked nodes'
#' ids to the server's input "clicked", even when they are the same as last
#' time
#' @noRd
.appClickJs <- paste0("function(n) { Shiny.setInputValue('clicked', n.nodes, ",
                      "{priority: 'event'}); }")

#' The animals a click landed on
#'
#' @param nodes the clicked nodes' ids, as the drawing sends them.
#' @param duplicateToReal the drawing's repeat nodes, named by their ids, or
#'   \code{NULL}.
#' @return The animals' ids: a repeat node is its animal, a mating dot or a
#'   routing point is none.
#' @noRd
.appClickedAnimals <- function(nodes, duplicateToReal) {
  ids <- as.character(unlist(nodes))
  repeats <- ids %in% names(duplicateToReal)
  ids[repeats] <- unname(duplicateToReal[ids[repeats]])
  unique(ids[repeats | !grepl(.reservedIdPattern, ids)])
}

#' Draw a pedigree, keeping what the functions said
#'
#' Adds \code{gen} with \code{findGeneration()} and draws with
#' \code{makePedigreeMatingLayout()} and \code{drawPedigreeDiagram()}. Their
#' warnings and messages, which would reach only the console, are kept as
#' notes, and an error is kept instead of stopping the app.
#'
#' @param ped the pedigree.
#' @param onClick passed to \code{drawPedigreeDiagram()}.
#' @return A list: \code{widget} (\code{NULL} when the drawing failed),
#'   \code{notes}, \code{error} (\code{NULL} or the error's message) and
#'   \code{duplicateToReal}, the layout's repeat nodes (\code{NULL} when the
#'   drawing failed).
#' @noRd
.appDraw <- function(ped, onClick = NULL) {
  kept <- new.env(parent = emptyenv())
  kept$notes <- character(0L)
  keep <- function(condition, restart) {
    kept$notes <- c(kept$notes, trimws(conditionMessage(condition)))
    invokeRestart(restart)
  }
  drawn <- withCallingHandlers(
    tryCatch({
      ped$gen <- findGeneration(ped$id, ped$sire, ped$dam)
      layout <- makePedigreeMatingLayout(ped)
      list(widget = drawPedigreeDiagram(layout, onClick = onClick),
           duplicateToReal = layout$duplicateToReal)
    }, error = function(e) e),
    warning = function(w) keep(w, "muffleWarning"),
    message = function(m) keep(m, "muffleMessage")
  )
  if (inherits(drawn, "error")) {
    return(list(widget = NULL, notes = kept$notes,
                error = conditionMessage(drawn), duplicateToReal = NULL))
  }
  list(widget = drawn$widget, notes = kept$notes, error = NULL,
       duplicateToReal = drawn$duplicateToReal)
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
        shiny::textOutput("sexNote"),
        shiny::hr(),
        shiny::radioButtons(
          "view", "Animals to draw",
          c(Everyone = "all", "One family" = "family",
            "Focal animals with their ancestors and descendants" = "lineal",
            "Focal animals' near relatives" = "near")
        ),
        shiny::conditionalPanel("input.view == 'family'",
                                shiny::uiOutput("familyChoice")),
        shiny::textAreaInput(
          "focal", "Focal animals: type their ids, or click one in the drawing",
          rows = 3L
        ),
        shiny::textOutput("focalNote"),
        shiny::conditionalPanel(
          "input.view == 'near'",
          shiny::numericInput("howClose", "How close", 3L, min = 1L,
                              step = 1L),
          shiny::helpText(paste(
            "2 holds the parents, offspring and full siblings; 3 adds",
            "grandparents, grandoffspring, half siblings, aunts, uncles,",
            "nephews and nieces; 4 adds first cousins."
          ))
        )
      ),
      shiny::mainPanel(
        width = 9L,
        shiny::tabsetPanel(
          id = "tabs",
          shiny::tabPanel(
            "Diagram",
            shiny::textOutput("drawn"),
            shiny::textOutput("added"),
            shiny::tagAppendAttributes(shiny::textOutput("problem"),
                                       style = "color: #b00020;"),
            shiny::tagAppendAttributes(shiny::textOutput("notes"),
                                       style = "white-space: pre-wrap;"),
            shiny::uiOutput("large"),
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
#' @param drawLimit the most animals drawn without asking first (R150).
#' @return A server function for \code{shiny::shinyApp()}.
#' @noRd
.pedigreeAppServer <- function(ped = NULL, drawLimit = 1000L) {
  force(ped)
  force(drawLimit)
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
    completed <- shiny::reactive(.appAddParents(pedigree()))
    families <- shiny::reactive({
      ped <- completed()$ped
      findPedigreeNumber(ped$id, ped$sire, ped$dam)
    })

    focalText <- shiny::reactiveVal("")
    shiny::observeEvent(input$focal, focalText(input$focal))
    focalIds <- shiny::reactive(.appFocalIds(focalText()))
    view <- shiny::reactive(if (is.null(input$view)) "all" else input$view)
    howClose <- shiny::reactive(if (is.null(input$howClose)) {
      3L
    } else {
      input$howClose
    })

    choice <- shiny::reactive({
      shiny::req(ready())
      byFamily <- view() == "family"
      .appChooseAnimals(completed()$ped, view(), focalIds(), howClose(),
                        if (byFamily) input$family, if (byFamily) families())
    })
    shown <- shiny::reactive({
      shiny::req(choice()$rows)
      choice()$rows
    })

    approved <- shiny::reactiveVal(NULL)
    shiny::observeEvent(input$drawAnyway, approved(shown()$id))
    tooLarge <- shiny::reactive({
      rows <- choice()$rows
      !is.null(rows) && nrow(rows) > drawLimit &&
        !identical(approved(), rows$id)
    })
    drawing <- shiny::reactive({
      if (is.null(choice()$rows) || tooLarge()) {
        return(NULL)
      }
      .appDraw(shown(), onClick = .appClickJs)
    })

    shiny::observeEvent(input$clicked, {
      ids <- .appClickedAnimals(input$clicked, drawing()$duplicateToReal)
      if (length(ids) > 0L) {
        text <- paste(ids, collapse = "\n")
        focalText(text)
        shiny::updateTextAreaInput(session, "focal", value = text)
      }
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
      if (!ready()) {
        return("")
      }
      if (nzchar(choice()$problem)) {
        return(choice()$problem)
      }
      if (is.null(drawing()$error)) {
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
    output$added <- shiny::renderText({
      if (!ready() || length(completed()$added) == 0L) {
        return("")
      }
      sprintf(paste0("Parents with no row of their own, added so the ",
                     "pedigree can be drawn: %s."),
              toString(completed()$added))
    })
    output$focalNote <- shiny::renderText({
      if (!ready()) {
        return("")
      }
      missing <- setdiff(focalIds(), completed()$ped$id)
      if (length(missing) > 0L) {
        return(sprintf("Not in the pedigree: %s.", toString(missing)))
      }
      if (view() %in% c("lineal", "near") && length(focalIds()) == 0L) {
        return(paste0("Type the id of a focal animal, or click one in the ",
                      "drawing."))
      }
      ""
    })
    output$familyChoice <- shiny::renderUI({
      shiny::req(ready())
      shiny::tagList(
        shiny::selectInput("family", "Family",
                           .appFamilyChoices(families())),
        shiny::helpText(.appAloneNote(families()))
      )
    })
    output$large <- shiny::renderUI({
      shiny::req(ready())
      if (!tooLarge()) {
        return(NULL)
      }
      shiny::tagList(
        shiny::p(sprintf(paste0(
          "%s animals are chosen. Drawing more than %s can take a minute or ",
          "more, and the app waits until it is done. Choose one family or ",
          "focal animals, or draw them all."),
          format(nrow(shown()), big.mark = ","),
          format(drawLimit, big.mark = ","))),
        shiny::actionButton("drawAnyway", "Draw anyway")
      )
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
    output$table <- shiny::renderTable(shown())
  }
}
