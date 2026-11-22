# G17b, S75: the app's whole drawing time in headless Chrome, from the page
# connecting to the drawing shown, at the sizes g17bSize.R builds (F19). Not
# package code. Run from the repository root with renv's library, the size as
# the last argument (375 is the sample):
#   Rscript --no-init-file docs/planning/pedigree-app-prototype/g17bBrowser.R 1000
# The app runs in a second R process (runPedigreeApp(ped), pedkindraw from
# source), as the browser tests start it.
suppressMessages(pkgload::load_all(".", quiet = TRUE))
n <- as.integer(commandArgs(trailingOnly = TRUE)[[1L]])
## the same pedigree as g17bSize.R's
if (n == 375L) {
  ped <- utils::read.csv(.appSamplePath(), colClasses = "character",
                         na.strings = c("", "NA"))
} else {
  e <- new.env()
  load("../nprcgenekeepr/data/examplePedigree.RData", e)
  ped <- e$examplePedigree
  ped$sex <- as.character(ped$sex)
  set.seed(75L)
  recent <- sample(ped$id[!is.na(ped$sire) | !is.na(ped$dam)])
  probands <- character(0L)
  for (id in recent) {
    probands <- c(probands, id)
    kept <- trimPedigree(ped, probands)
    if (nrow(kept) >= n) {
      break
    }
  }
  ped <- kept
}
ped <- ped[, c("id", "sire", "dam", "sex")]
log <- tempfile(fileext = ".txt")
run <- function() {
  process <- callr::r_bg(function(path, ped) {
    pkgload::load_all(path, quiet = TRUE)
    pedkindraw::runPedigreeApp(ped, launch.browser = FALSE)
  }, args = list(path = getwd(), ped = ped), libpath = .libPaths(),
  stdout = log, stderr = "2>&1", supervise = TRUE)
  on.exit(process$kill(), add = TRUE)
  url <- character(0L)
  while (length(url) == 0L && process$is_alive()) {
    Sys.sleep(0.1)
    said <- readLines(log, warn = FALSE)
    url <- regmatches(said, regexpr("http://[0-9.]+:[0-9]+", said))
  }
  page <- chromote::ChromoteSession$new(width = 1400L, height = 1000L)
  on.exit(page$close(), add = TRUE)
  js <- function(x) {
    page$Runtime$evaluate(x, returnByValue = TRUE,
                          awaitPromise = TRUE)$result$value
  }
  waitFor <- function(x, seconds = 600) {
    start <- proc.time()[["elapsed"]]
    while (!isTRUE(tryCatch(js(x), error = function(e) FALSE))) {
      if (proc.time()[["elapsed"]] - start > seconds) stop("timed out: ", x)
      Sys.sleep(0.05)
    }
    proc.time()[["elapsed"]] - start
  }
  t0 <- proc.time()[["elapsed"]]
  page$go_to(url[[1L]], timeout_ = 60)
  connected <- waitFor(paste0("!!(window.Shiny && Shiny.shinyapp && ",
                              "Shiny.shinyapp.isConnected())"))
  t1 <- proc.time()[["elapsed"]]
  waitFor(paste0("(function() { const w = HTMLWidgets.find('#diagram'); ",
                 "return !!(w && w.network && ",
                 "w.network.body.data.nodes.length > 0); })()"))
  t2 <- proc.time()[["elapsed"]]
  cat(sprintf(paste0("n=%d | page loaded and connected %.2f s | then drawn ",
                     "in the page %.2f s | %s | nodes in the page %d\n"),
              nrow(ped), t1 - t0, t2 - t1,
              js("document.getElementById('drawn').innerText"),
              js(paste0("HTMLWidgets.find('#diagram').network.body.data.",
                        "nodes.length"))))
}
run()
