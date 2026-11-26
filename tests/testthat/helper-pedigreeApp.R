## Copyright(c) 2017-2026 R. Mark Sharp
## This file is part of pedkindraw
## Helpers for the app's tests (pedkindraw S74, plan Phase G17a, gap A3 of
## docs/research/pedkindraw-gaps-2026-11-18.md; rulings R148 and R149,
## docs/planning/pedigree-app-plan.md sections 4, 7 and 11; .appViewsPed() and
## .appClickNode() pedkindraw S75, Phase G17b, R150, section 12; .appCsv()'s
## name and .appSetFile() pedkindraw S76, Phase G17c, R151, section 13;
## .startPedigreeApp()'s childEnv pedkindraw S77, Phase G17d, R152, section 14;
## .appSeparated() pedkindraw S97, backlog item "What 17m's check of NEWS found
## outside NEWS").
## Not copied from nprcgenekeepr.
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

#' Fourteen animals in three families, for choosing animals (G17b, S75)
#'
#' s1 has offspring by two dams, d1 (o1, o2) and d2 (o3), so the whole
#' drawing holds a repeat of s1 (`__dup_s1_1`) and of o1 (`__dup_o1_1`);
#' o1 and m1 (whose parents are ms and md) have g1. f1 and f2 have f3. z1
#' has no parent and no offspring. findPedigreeNumber() numbers the
#' families 1 (the first ten animals), 2 (f1, f2, f3) and 3 (z1).
.appViewsPed <- function() {
  data.frame(
    id = c("s1", "d1", "d2", "o1", "o2", "o3", "ms", "md", "m1", "g1", "f1",
           "f2", "f3", "z1"),
    sire = c(NA, NA, NA, "s1", "s1", "s1", NA, NA, "ms", "m1", NA, NA, "f1",
             NA),
    dam = c(NA, NA, NA, "d1", "d1", "d2", NA, NA, "md", "o1", NA, NA, "f2",
            NA),
    sex = c("M", "F", "F", "F", "M", "M", "M", "F", "M", "F", "M", "F", "M",
            "F")
  )
}

#' A pedigree written as the file a user uploads
#'
#' Writes `ped` as a CSV file (an empty cell for NA), or `lines` as they are,
#' into a temporary file removed when the calling test ends, and returns the
#' one-row data frame shiny's fileInput() gives the server, the file's name
#' `name` (G17c, S76: a twins file has its own).
.appCsv <- function(ped = NULL, lines = NULL, envir = parent.frame(),
                    name = "pedigree.csv") {
  path <- withr::local_tempfile(fileext = ".csv", .local_envir = envir)
  if (is.null(lines)) {
    utils::write.csv(ped, path, row.names = FALSE, na = "")
  } else {
    writeLines(lines, path)
  }
  data.frame(name = name, size = file.size(path),
             type = "text/csv", datapath = path, stringsAsFactors = FALSE)
}

#' A pedigree's lines with its values separated by `sep`, an empty cell for
#' NA, for .appCsv()'s `lines` (pedkindraw S97: a file separated by tabs or
#' semicolons)
.appSeparated <- function(ped, sep) {
  cells <- as.matrix(ped)
  cells[is.na(cells)] <- ""
  c(paste(names(ped), collapse = sep), apply(cells, 1L, paste, collapse = sep))
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
#' G17d (pedkindraw S77, R152): `childEnv`, environment variables the child
#' sets before it starts the app, so a test can give the app's process a
#' CHROMOTE_CHROME that names no file (plan section 14.3) while the tests'
#' own Chrome is untouched.
#'
#' @param ped passed to runPedigreeApp().
#' @param childEnv `NULL`, or a named character vector of environment
#'   variables for the child.
#' @return a list: `process` (the callr process) and `url`.
.startPedigreeApp <- function(ped = NULL, envir = parent.frame(),
                              seconds = 60, childEnv = NULL) {
  path <- getNamespaceInfo(asNamespace("pedkindraw"), "path")
  fromSource <- !file.exists(file.path(path, "R", "pedkindraw.rdb"))
  log <- withr::local_tempfile(fileext = ".txt", .local_envir = envir)
  process <- callr::r_bg(function(path, fromSource, ped, childEnv) {
    if (length(childEnv) > 0L) {
      do.call(Sys.setenv, as.list(childEnv))
    }
    if (fromSource) {
      pkgload::load_all(path, quiet = TRUE)
    } else {
      library(pedkindraw, lib.loc = dirname(path))
    }
    pedkindraw::runPedigreeApp(ped, launch.browser = FALSE)
  }, args = list(path = path, fromSource = fromSource, ped = ped,
                 childEnv = childEnv),
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

#' Click a node of the app's drawing with the mouse, as a user does
#'
#' Finds the node's place on the drawing's own canvas (the first canvas in
#' the widget is the legend's) and sends a left button press and release
#' there through Chrome's DevTools, so vis.js's click event and the
#' drawing's onClick code run as for a user's click (measured before RED,
#' S75: o1, a repeat node, a mating dot and g1 each reached Shiny).
#'
#' @param page the page, from .appPage().
#' @param id the node's id.
.appClickNode <- function(page, id) {
  where <- .appJs(page, sprintf(paste0(
    "(function() { const n = HTMLWidgets.find('#diagram').network; ",
    "const d = n.canvasToDOM(n.getPositions(['%1$s'])['%1$s']); ",
    "const r = n.canvas.frame.canvas.getBoundingClientRect(); ",
    "return [r.left + d.x, r.top + d.y]; })()"), id))
  for (type in c("mousePressed", "mouseReleased")) {
    page$Input$dispatchMouseEvent(type = type, x = where[[1L]],
                                  y = where[[2L]], button = "left",
                                  clickCount = 1L)
  }
  invisible(where)
}

#' Give a file box of the app's page a file, as a user's file dialog does
#'
#' Sets the file on the page's file input through Chrome's DevTools
#' (DOM.setFileInputFiles), so Shiny uploads and reads it as it reads a
#' user's file (measured before RED, G17c, S76: plan section 13.3).
#'
#' @param page the page, from .appPage().
#' @param id the file input's id.
#' @param path the file.
.appSetFile <- function(page, id, path) {
  root <- page$DOM$getDocument()$root$nodeId
  node <- page$DOM$querySelector(root, paste0("#", id))$nodeId
  page$DOM$setFileInputFiles(files = list(normalizePath(path)), nodeId = node)
  invisible(path)
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
