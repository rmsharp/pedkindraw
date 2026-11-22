# G17a measure (a) and (b), S74: how a second R process loads the pedkindraw under
# test, and whether an app object and an app.R file serve. Not package code. The
# pieces below were placed in a scratch copy (git archive HEAD), every other test
# removed, shiny and callr added to Suggests, and run twice: test_file() after
# pkgload::load_all() of the copy, and R CMD build --no-build-vignettes + R CMD
# check --no-manual --ignore-vignettes with NOT_CRAN unset (S74_PROBE_OUT names the
# file each run wrote). Results: docs/planning/pedigree-app-plan.md section 11.

## ---- R/zzzProbeApp.R (in the scratch copy) ----
# S74 measure (a): a probe app; the marker exists only in this copy.
.probeMarker <- function() "S74-probe-marker"
.probeApp <- function() {
  shiny::shinyApp(
    ui = shiny::fluidPage(shiny::p(paste("marker", .probeMarker(),
                                         "save", exists("savePedigreeDiagram")))),
    server = function(input, output, session) {
      output$gen <- shiny::renderText(paste(findGeneration(
        c("A", "B", "C"), c(NA, NA, "A"), c(NA, NA, "B")), collapse = ","))
    })
}

## ---- tests/testthat/helper-probeApp.R ----
# S74 measure (a): start the probe app in a second R process loading the
# pedkindraw under test: from source under load_all(), installed under check.
.appProcess <- function(out) {
  path <- getNamespaceInfo(asNamespace("pedkindraw"), "path")
  dev <- !file.exists(file.path(path, "R", "pedkindraw.rdb"))
  child <- callr::r_bg(function(path, dev) {
    if (dev) {
      pkgload::load_all(path, quiet = TRUE)
      if (FALSE) fakepkgxyz::foo()
    } else {
      library(pedkindraw, lib.loc = dirname(path))
    }
    shiny::runApp(pedkindraw:::.probeApp(), port = NULL, launch.browser = FALSE)
  }, args = list(path = path, dev = dev), libpath = .libPaths(),
  supervise = TRUE)
  start <- proc.time()[["elapsed"]]
  url <- NULL
  err <- character(0L)
  while (is.null(url) && proc.time()[["elapsed"]] - start < 60) {
    child$poll_io(200L)
    err <- c(err, child$read_error_lines())
    hit <- regmatches(err, regexpr("http://[0-9.]+:[0-9]+", err))
    if (length(hit) > 0L) url <- hit[[1L]]
    if (!child$is_alive()) break
  }
  cat(sprintf("path=%s dev=%s url=%s alive=%s secs=%.2f\nstderr: %s\n",
              path, dev, format(url), child$is_alive(),
              proc.time()[["elapsed"]] - start, paste(err, collapse = " | ")),
      file = out, append = TRUE)
  list(child = child, url = url)
}

## ---- tests/testthat/test_probeApp.R ----
out <- Sys.getenv("S74_PROBE_OUT", file.path(tempdir(), "probe.txt"))
test_that("the second process runs the pedkindraw under test", {
  skip_if_not_installed("shiny")
  skip_if_not_installed("callr")
  a <- .appProcess(out)
  withr::defer(a$child$kill())
  expect_false(is.null(a$url))
  page <- paste(readLines(a$url, warn = FALSE), collapse = "\n")
  cat("page has marker:", grepl("S74-probe-marker", page), " save TRUE:",
      grepl("save TRUE", page), "\n", file = out, append = TRUE)
  expect_match(page, "marker S74-probe-marker save TRUE", fixed = TRUE)
  a$child$kill()
  Sys.sleep(0.5)
  cat("killed, alive:", a$child$is_alive(), "\n", file = out, append = TRUE)
  expect_false(a$child$is_alive())
})
test_that("testServer() runs the app object's server", {
  skip_if_not_installed("shiny")
  t0 <- proc.time()[["elapsed"]]
  shiny::testServer(.probeApp(), {
    cat("gen output:", output$gen, "\n", file = out, append = TRUE)
    expect_true(nzchar(output$gen))
  })
  cat(sprintf("testServer on the app object: %.2f s\n",
              proc.time()[["elapsed"]] - t0), file = out, append = TRUE)
})

## ---- host.R, run beside the checked copy: hostObj/app.R holds
## ---- pedkindraw:::.probeApp(), hostRun/app.R holds shiny::runApp(pedkindraw:::.probeApp(), launch.browser = FALSE)
lib <- normalizePath("pedkindraw.Rcheck")
try1 <- function(dir) {
  ch <- callr::r_bg(function(lib, dir) { library(pedkindraw, lib.loc = lib); shiny::runApp(dir, port = NULL, launch.browser = FALSE) },
                    args = list(lib = lib, dir = normalizePath(dir)), libpath = c(lib, .libPaths()), supervise = TRUE)
  on.exit(ch$kill())
  err <- character(0); url <- NULL; t0 <- proc.time()[[3]]
  while (is.null(url) && proc.time()[[3]] - t0 < 20) { ch$poll_io(200L); err <- c(err, ch$read_error_lines())
    h <- regmatches(err, regexpr("http://[0-9.]+:[0-9]+", err)); if (length(h)) url <- h[[1]] }
  if (!is.null(url)) { page <- tryCatch(paste(readLines(url, warn = FALSE), collapse = ""), error = function(e) paste("fetch error:", conditionMessage(e)))
    Sys.sleep(1); err <- c(err, ch$read_error_lines())
    cat(dir, ": served; marker in page:", grepl("S74-probe-marker", page), "; stderr:", paste(tail(err, 3), collapse = " | "), "\n")
  } else cat(dir, ": no url; stderr:", paste(err, collapse = " | "), "\n")
}
try1("hostObj"); try1("hostRun")
