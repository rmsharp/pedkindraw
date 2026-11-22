## Copyright(c) 2017-2026 R. Mark Sharp
## This file is part of pedkindraw
## Helpers for the app's tests (pedkindraw S74, plan Phase G17a, gap A3 of
## docs/research/pedkindraw-gaps-2026-11-18.md; rulings R148 and R149,
## docs/planning/pedigree-app-plan.md sections 4, 7 and 11). Not copied from
## nprcgenekeepr.
##
## The server tests run shiny::testServer() on small typed pedigrees with no
## browser, so they run everywhere shiny is installed, CRAN too. The browser
## tests start the app with runPedigreeApp() in a second R process and open it
## in the shared Chrome; they skip on CRAN and where no browser is found.

#' Run shiny::testServer() quietly, leaving the search path as it was
#'
#' shiny::testServer() calls require(shiny), which attaches shiny and prints
#' "Loading required package: shiny" (plan section 11.1). This runs it with
#' that message hidden and detaches shiny afterwards when it was not attached
#' before, so the test files after this one see the search path they would
#' have seen. The code in `expr` sees the server's own objects (its reactives,
#' `input`, `output`, `session`) and the calling test's.
#'
#' @param app a server function, or an app object.
#' @param expr the test code, not evaluated before testServer() runs it.
#' @param env where the call is evaluated: the calling test.
.appTestServer <- function(app, expr, env = parent.frame()) {
  attached <- "package:shiny" %in% search()
  on.exit(if (!attached && "package:shiny" %in% search()) {
    detach("package:shiny", character.only = TRUE)
  }, add = TRUE)
  call <- substitute(shiny::testServer(app, expr))
  suppressPackageStartupMessages(eval(call, env))
}

#' The four animals most app tests read: a sire, a dam and two offspring
.appFour <- function() {
  data.frame(id = c("s1", "d1", "o1", "o2"), sire = c(NA, NA, "s1", "s1"),
             dam = c(NA, NA, "d1", "d1"), sex = c("M", "F", "F", "M"))
}

#' A pedigree written as the file a user uploads
#'
#' Writes `ped` as a CSV file (an empty cell for NA), or `lines` as they are,
#' into a temporary file removed when the calling test ends, and returns the
#' one-row data frame shiny's fileInput() gives the server.
.appCsv <- function(ped = NULL, lines = NULL, envir = parent.frame()) {
  path <- withr::local_tempfile(fileext = ".csv", .local_envir = envir)
  if (is.null(lines)) {
    utils::write.csv(ped, path, row.names = FALSE, na = "")
  } else {
    writeLines(lines, path)
  }
  data.frame(name = "pedigree.csv", size = file.size(path),
             type = "text/csv", datapath = path, stringsAsFactors = FALSE)
}

#' Choose the four columns in a testServer() session
.setAppColumns <- function(session, id = "id", sire = "sire", dam = "dam",
                           sex = "sex") {
  session$setInputs(idColumn = id, sireColumn = sire, damColumn = dam,
                    sexColumn = sex)
}

#' Run code under a time limit, so a call that never returns fails a test
#'
#' A test that replaces shiny::runApp() would block for ever if the
#' replacement did not take; the limit turns that into an error.
.appTimeLimit <- function(expr, seconds = 20) {
  setTimeLimit(elapsed = seconds, transient = TRUE)
  on.exit(setTimeLimit(elapsed = Inf), add = TRUE)
  expr
}

#' Start the app in a second R process, loading the pedkindraw under test
#'
#' The parent loaded pedkindraw from source (pkgload::load_all(), as
#' testthat::test_local() does) when no R/pedkindraw.rdb is under the
#' namespace's path, and installed (R CMD check) otherwise; the child loads it
#' the same way, never another copy on the library path, such as renv's stale
#' pedkindraw 0.0.1 (plan dragon 1, section 11.1). The child runs
#' runPedigreeApp() with port = NULL, so shiny picks a free port and prints
#' "Listening on http://127.0.0.1:<port>", which this reads from the child's
#' output. The child is killed when the calling test ends.
#'
#' @param ped passed to runPedigreeApp().
#' @return a list: `process` (the callr process) and `url`.
.startPedigreeApp <- function(ped = NULL, envir = parent.frame(),
                              seconds = 60) {
  path <- getNamespaceInfo(asNamespace("pedkindraw"), "path")
  fromSource <- !file.exists(file.path(path, "R", "pedkindraw.rdb"))
  log <- withr::local_tempfile(fileext = ".txt", .local_envir = envir)
  process <- callr::r_bg(function(path, fromSource, ped) {
    if (fromSource) {
      pkgload::load_all(path, quiet = TRUE)
    } else {
      library(pedkindraw, lib.loc = dirname(path))
    }
    pedkindraw::runPedigreeApp(ped, launch.browser = FALSE)
  }, args = list(path = path, fromSource = fromSource, ped = ped),
  libpath = .libPaths(), stdout = log, stderr = "2>&1", supervise = TRUE)
  withr::defer(process$kill(), envir = envir)
  start <- proc.time()[["elapsed"]]
  url <- character(0L)
  while (length(url) == 0L && process$is_alive() &&
         proc.time()[["elapsed"]] - start < seconds) {
    Sys.sleep(0.1)
    said <- readLines(log, warn = FALSE)
    url <- regmatches(said, regexpr("http://[0-9.]+:[0-9]+", said))
  }
  if (length(url) == 0L) {
    stop("the app did not start: ",
         paste(readLines(log, warn = FALSE), collapse = "\n"))
  }
  list(process = process, url = url[[1L]])
}

#' Evaluate JavaScript in a page and return its value
.appJs <- function(page, js) {
  page$Runtime$evaluate(js, returnByValue = TRUE,
                        awaitPromise = TRUE)$result$value
}

#' Wait until a JavaScript expression is true in the page, or stop
.appWaitFor <- function(page, js, seconds = 60) {
  start <- proc.time()[["elapsed"]]
  repeat {
    if (isTRUE(tryCatch(.appJs(page, js), error = function(e) FALSE))) {
      return(invisible(TRUE))
    }
    if (proc.time()[["elapsed"]] - start > seconds) {
      stop("timed out after ", seconds, " s waiting for: ", js)
    }
    Sys.sleep(0.1)
  }
}

#' Open the app's page in the shared Chrome and wait for Shiny to connect
#'
#' Uses the parent Chrome every browser test shares, as
#' getLiveRenderedPositions() does (helper-live-render-positions.R: its
#' timeout raised to 60 s, closed once when the suite ends). The page is
#' closed when the calling test ends.
.appPage <- function(url, envir = parent.frame(), seconds = 60) {
  chromeParent <- chromote::default_chromote_object()
  if (chromeParent$default_timeout < 60) {
    chromeParent$default_timeout <- 60
  }
  if (!isTRUE(.chromoteParentTeardownRegistered$done)) {
    withr::defer(chromeParent$close(), envir = testthat::teardown_env())
    .chromoteParentTeardownRegistered$done <- TRUE
  }
  page <- chromote::ChromoteSession$new(width = 1400L, height = 1000L)
  withr::defer(page$close(), envir = envir)
  page$go_to(url, timeout_ = seconds)
  .appWaitFor(page, paste0("!!(window.Shiny && Shiny.shinyapp && ",
                           "Shiny.shinyapp.isConnected())"), seconds)
  page
}
