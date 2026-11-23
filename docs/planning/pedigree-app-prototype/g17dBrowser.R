# G17d, S77: the downloads in the app, measured in Chrome before the pre-RED
# picker (Learning 17). The app (G17c's code) runs in a second R process with
# download buttons added to its page and download handlers added at the end
# of its server (its body appended, so they see drawing(), shown() and
# prepared()): SVG, PDF and PNG through savePedigreeDiagram(drawing()$widget),
# and two CSV files, the rows shown on the Animals tab (shown()) and the
# drawing's data frame (prepared()$ped). The shared headless Chrome opens the
# page; each download is fetched by the page itself (fetch() of the button's
# href, as a click asks for it). Printed: each button's state before and after
# a pedigree is drawn, each download's status, file name, size and time, the
# SVG's ids against savePedigreeDiagram() called directly on the same layout,
# and, with Chrome hidden from the app's process (chromote::find_chrome()
# replaced by a function returning NULL), what a picture download and the page
# then do. Not package code. Run from the repository root with renv's library:
#   Rscript --no-init-file docs/planning/pedigree-app-prototype/g17dBrowser.R
suppressMessages(pkgload::load_all(".", quiet = TRUE))

childApp <- function(path, noChrome) {
  pkgload::load_all(path, quiet = TRUE)
  if (noChrome) {
    ns <- asNamespace("chromote")
    unlockBinding("find_chrome", ns)
    assign("find_chrome", function() NULL, envir = ns)
  }
  ui <- htmltools::tagList(
    pedkindraw:::.pedigreeAppUi(),
    shiny::div(
      id = "saves",
      shiny::downloadButton("saveSvg", "SVG"),
      shiny::downloadButton("savePdf", "PDF"),
      shiny::downloadButton("savePng", "PNG"),
      shiny::downloadButton("saveCsv", "CSV: rows shown"),
      shiny::downloadButton("saveDrawn", "CSV: the drawing's data frame"),
      shiny::downloadButton("never", "Never defined")
    )
  )
  server <- pedkindraw:::.pedigreeAppServer()
  added <- quote({
    picture <- function(ending) shiny::downloadHandler(
      filename = function() paste0("pedigree.", ending),
      content = function(file) {
        pedkindraw::savePedigreeDiagram(drawing()$widget, file)
      }
    )
    output$saveSvg <- picture("svg")
    output$savePdf <- picture("pdf")
    output$savePng <- picture("png")
    output$saveCsv <- shiny::downloadHandler(
      filename = "animals.csv",
      content = function(file) {
        utils::write.csv(shown(), file, row.names = FALSE, na = "")
      }
    )
    output$saveDrawn <- shiny::downloadHandler(
      filename = "drawn.csv",
      content = function(file) {
        utils::write.csv(prepared()$ped, file, row.names = FALSE, na = "")
      }
    )
  })
  body(server) <- as.call(c(as.list(body(server)), as.list(added)[-1L]))
  shiny::runApp(shiny::shinyApp(ui, server), launch.browser = FALSE)
}

startApp <- function(noChrome) {
  log <- tempfile(fileext = ".txt")
  app <- callr::r_bg(childApp,
                     args = list(path = normalizePath("."), noChrome = noChrome),
                     libpath = .libPaths(), stdout = log, stderr = "2>&1",
                     supervise = TRUE)
  url <- character(0L)
  for (i in 1:600) {
    said <- readLines(log, warn = FALSE)
    url <- regmatches(said, regexpr("http://[0-9.]+:[0-9]+", said))
    if (length(url) > 0L) break
    Sys.sleep(0.1)
  }
  if (length(url) == 0L) stop(paste(readLines(log), collapse = "\n"))
  list(process = app, url = url[[1L]], log = log)
}

openPage <- function(url) {
  page <- chromote::ChromoteSession$new(width = 1400L, height = 1000L)
  page$go_to(url)
  page
}
js <- function(page, code) {
  page$Runtime$evaluate(code, returnByValue = TRUE, awaitPromise = TRUE,
                        timeout_ = 120)$result$value
}
waitFor <- function(page, code, seconds = 60) {
  start <- proc.time()[["elapsed"]]
  while (!isTRUE(tryCatch(js(page, code), error = function(e) FALSE))) {
    if (proc.time()[["elapsed"]] - start > seconds) return(FALSE)
    Sys.sleep(0.1)
  }
  TRUE
}
buttonState <- function(page, id) {
  js(page, sprintf(paste0(
    "(function() { const b = document.getElementById('%s'); ",
    "return [b.className, String(b.getAttribute('aria-disabled')), ",
    "b.getAttribute('href') || '(none)'].join(' | '); })()"), id))
}
## Fetch a download as the page asks for it: status, the file name the server
## gives, the size in bytes, and the body (text, or base64 for a picture).
fetchDownload <- function(page, id, binary) {
  start <- proc.time()[["elapsed"]]
  answer <- js(page, sprintf(paste0(
    "(async function() { const r = await fetch(document.getElementById('%s')",
    ".href); const d = r.headers.get('content-disposition') || ''; ",
    "const b = new Uint8Array(await r.arrayBuffer()); let body = ''; ",
    "if (%s) { let s = ''; for (let i = 0; i < b.length; i += 8192) ",
    "{ s += String.fromCharCode.apply(null, b.subarray(i, i + 8192)); } ",
    "body = btoa(s); } else { body = new TextDecoder().decode(b); } ",
    "return [String(r.status), d, String(b.length), body]; })()"),
    id, if (binary) "true" else "false"))
  list(status = answer[[1L]], disposition = answer[[2L]],
       bytes = as.numeric(answer[[3L]]), body = answer[[4L]],
       seconds = proc.time()[["elapsed"]] - start)
}
svgTexts <- function(svg) {
  m <- regmatches(svg, gregexpr("<text[^>]*>[^<]*</text>", svg))[[1L]]
  sub("^<text[^>]*>([^<]*)</text>$", "\\1", m)
}

cat("== With Chrome ==\n")
app <- startApp(noChrome = FALSE)
page <- openPage(app$url)
cat("Shiny connected:", waitFor(page, paste0(
  "!!(window.Shiny && Shiny.shinyapp && Shiny.shinyapp.isConnected())")), "\n")
Sys.sleep(1)
cat("before a pedigree is opened:\n")
for (id in c("saveSvg", "saveCsv", "never")) {
  cat(sprintf("  %-9s %s\n", id, buttonState(page, id)))
}
early <- fetchDownload(page, "saveSvg", binary = FALSE)
cat(sprintf("  SVG fetched before any pedigree: status %s, %s bytes, body '%s'\n",
            early$status, early$bytes, substr(early$body, 1L, 200L)))
js(page, "document.getElementById('sample').click(); true")
cat("sample drawn:", waitFor(page, paste0(
  "document.getElementById('drawn').innerText === '375 animals drawn'")), "\n")
waitFor(page, paste0("(function() { const w = HTMLWidgets.find('#diagram'); ",
                     "return !!(w && w.network && ",
                     "w.network.body.data.nodes.length > 0); })()"))
cat("after the sample is drawn:\n")
for (id in c("saveSvg", "saveCsv", "never")) {
  cat(sprintf("  %-9s %s\n", id, buttonState(page, id)))
}
got <- list()
for (id in c("saveSvg", "savePdf", "savePng", "saveCsv", "saveDrawn")) {
  got[[id]] <- fetchDownload(page, id, binary = id %in% c("savePdf", "savePng"))
  cat(sprintf("  %-9s status %s, '%s', %s bytes, %.2f s\n", id,
              got[[id]]$status, got[[id]]$disposition, got[[id]]$bytes,
              got[[id]]$seconds))
}
cat("app still answers after the downloads:",
    js(page, "document.getElementById('drawn').innerText"), "\n")

## The same drawing saved directly, as G17a's Chrome test builds it.
sample <- utils::read.csv(.appSamplePath(), colClasses = "character",
                          na.strings = c("", "NA"))
sample <- sample[, c("id", "sire", "dam", "sex")]
sample$gen <- findGeneration(sample$id, sample$sire, sample$dam)
twins <- utils::read.csv(.appSampleTwinsPath(), colClasses = "character")
layout <- suppressWarnings(makePedigreeMatingLayout(sample,
                                                    twinRelations = twins))
direct <- tempfile(fileext = ".svg")
start <- proc.time()[["elapsed"]]
savePedigreeDiagram(drawPedigreeDiagram(layout), direct)
cat(sprintf("the same drawing saved directly: %.2f s, %s bytes\n",
            proc.time()[["elapsed"]] - start, file.size(direct)))
directSvg <- paste(readLines(direct, warn = FALSE), collapse = "\n")
appSvg <- sub("\n$", "", got$saveSvg$body)
cat("app's SVG identical to the direct one:", identical(appSvg, directSvg), "\n")
appTexts <- svgTexts(appSvg)
directTexts <- svgTexts(directSvg)
cat(sprintf("id texts: app %d (%d distinct), direct %d (%d distinct); other texts app %d, direct %d\n",
            sum(appTexts %in% sample$id),
            length(unique(appTexts[appTexts %in% sample$id])),
            sum(directTexts %in% sample$id),
            length(unique(directTexts[directTexts %in% sample$id])),
            sum(!appTexts %in% sample$id), sum(!directTexts %in% sample$id)))
cat("same texts in the same order:", identical(appTexts, directTexts), "\n")
pdf <- tempfile(fileext = ".pdf")
writeBin(jsonlite::base64_dec(got$savePdf$body), pdf)
png <- tempfile(fileext = ".png")
writeBin(jsonlite::base64_dec(got$savePng$body), png)
cat("PDF starts '%PDF':", identical(readBin(pdf, "raw", 4L),
                                    charToRaw("%PDF")), "\n")
pngHead <- readBin(png, "raw", 24L)
cat("PNG size (pixels):", readBin(pngHead[17:20], "integer", size = 4L,
                                  endian = "big"), "x",
    readBin(pngHead[21:24], "integer", size = 4L, endian = "big"), "\n")
for (id in c("saveCsv", "saveDrawn")) {
  rows <- utils::read.csv(text = got[[id]]$body, colClasses = "character",
                          check.names = FALSE)
  cat(sprintf("%s: %d rows, columns %s\n", id, nrow(rows),
              toString(names(rows))))
}
page$close()
app$process$kill()

cat("\n== With Chrome hidden from the app's process ==\n")
app <- startApp(noChrome = TRUE)
page <- openPage(app$url)
waitFor(page, paste0(
  "!!(window.Shiny && Shiny.shinyapp && Shiny.shinyapp.isConnected())"))
js(page, "document.getElementById('sample').click(); true")
cat("sample drawn:", waitFor(page, paste0(
  "document.getElementById('drawn').innerText === '375 animals drawn'")), "\n")
for (id in c("saveSvg", "saveCsv")) {
  answer <- fetchDownload(page, id, binary = FALSE)
  cat(sprintf("  %-9s status %s, '%s', %s bytes, body starts '%s'\n", id,
              answer$status, answer$disposition, answer$bytes,
              substr(answer$body, 1L, 160L)))
}
cat("the page's problem line:",
    sprintf("'%s'", js(page, "document.getElementById('problem').innerText")),
    "\n")
cat("the app still answers:",
    js(page, "document.getElementById('drawn').innerText"), "\n")
cat("the app's process said:\n")
said <- readLines(app$log, warn = FALSE)
cat(paste0("  ", utils::tail(said[nzchar(said)], 6L)), sep = "\n")
page$close()
app$process$kill()
