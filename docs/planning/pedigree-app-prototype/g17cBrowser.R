# G17c, S76: can a browser test give the app's file box a file, as a user's
# file dialog does? Probed before RED (S75's way for the click): the app
# (G17b's code) is started in a second R process, the shared headless Chrome
# opens it, and Chrome's DevTools sets a CSV file on the page's #file input
# (DOM.setFileInputFiles); printed: whether Shiny reads it and draws its four
# animals, and how long it takes. Not package code. Run from the repository
# root with renv's library:
#   Rscript --no-init-file docs/planning/pedigree-app-prototype/g17cBrowser.R
suppressMessages(pkgload::load_all(".", quiet = TRUE))
probe <- function() {
  log <- tempfile(fileext = ".txt")
  app <- callr::r_bg(function(path) {
    pkgload::load_all(path, quiet = TRUE)
    pedkindraw::runPedigreeApp(launch.browser = FALSE)
  }, args = list(path = normalizePath(".")), libpath = .libPaths(),
  stdout = log, stderr = "2>&1", supervise = TRUE)
  on.exit(app$kill(), add = TRUE)
  url <- character(0L)
  for (i in 1:600) {
    said <- readLines(log, warn = FALSE)
    url <- regmatches(said, regexpr("http://[0-9.]+:[0-9]+", said))
    if (length(url) > 0L) break
    Sys.sleep(0.1)
  }
  page <- chromote::ChromoteSession$new(width = 1400L, height = 1000L)
  on.exit(page$close(), add = TRUE)
  page$go_to(url[[1L]])
  js <- function(code) {
    page$Runtime$evaluate(code, returnByValue = TRUE)$result$value
  }
  waitFor <- function(code, seconds = 30) {
    start <- proc.time()[["elapsed"]]
    while (!isTRUE(tryCatch(js(code), error = function(e) FALSE))) {
      if (proc.time()[["elapsed"]] - start > seconds) return(FALSE)
      Sys.sleep(0.1)
    }
    TRUE
  }
  cat("Shiny connected:", waitFor(paste0("!!(window.Shiny && ",
                                         "Shiny.shinyapp && ",
                                         "Shiny.shinyapp.isConnected())")),
      "\n")
  csv <- tempfile(fileext = ".csv")
  utils::write.csv(data.frame(id = c("s1", "d1", "o1", "o2"),
                              sire = c(NA, NA, "s1", "s1"),
                              dam = c(NA, NA, "d1", "d1"),
                              sex = c("M", "F", "F", "M"),
                              carrier = c("N", "N", "Y", "N")),
                   csv, row.names = FALSE, na = "")
  start <- proc.time()[["elapsed"]]
  root <- page$DOM$getDocument()$root$nodeId
  node <- page$DOM$querySelector(root, "#file")$nodeId
  page$DOM$setFileInputFiles(files = list(normalizePath(csv)), nodeId = node)
  drawn <- waitFor(paste0("document.getElementById('drawn').innerText === ",
                          "'4 animals drawn'"))
  cat(sprintf("the file set by DevTools drawn: %s, after %.2f s\n", drawn,
              proc.time()[["elapsed"]] - start))
  cat("what the page says: drawn '", js("document.getElementById('drawn').innerText"),
      "', problem '", js("document.getElementById('problem').innerText"),
      "', the file box shows '",
      js("document.querySelector('#file').closest('.input-group').querySelector('input[type=text]').value"),
      "'\n", sep = "")
}
probe()
