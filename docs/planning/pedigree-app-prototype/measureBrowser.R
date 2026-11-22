# G17 planning (S73): the prototype app in a background R process, driven by
# headless Chrome (chromote): time to start, to draw the sample pedigree, and
# whether an SVG download (savePedigreeDiagram(), which starts its own Chrome
# inside the app's process) and a CSV download work. Run from the repository
# root with renv's library:  Rscript --no-init-file measureBrowser.R <proto dir>
main <- function() {
args <- commandArgs(trailingOnly = TRUE)
proto <- normalizePath(args[[1L]])
root <- normalizePath(".")
port <- 8765L
t0 <- proc.time()[["elapsed"]]
lap <- function(what) {
  t1 <- proc.time()[["elapsed"]]
  cat(sprintf("%-60s %6.2f s\n", what, t1 - t0))
  t0 <<- t1
}
bg <- callr::r_bg(function(root, proto, port) {
  setwd(root)
  suppressMessages(pkgload::load_all(".", quiet = TRUE))
  `%||%` <- function(a, b) if (is.null(a)) b else a
  source(file.path(proto, "app.R"), local = TRUE)
  environment(protoServer) <- environment()
  shiny::runApp(shiny::shinyApp(protoUI(), protoServer), port = port,
                launch.browser = FALSE)
}, args = list(root = root, proto = proto, port = port),
  libpath = .libPaths(), stdout = file.path(proto, "app.out"),
  stderr = file.path(proto, "app.err"))
on.exit(bg$kill(), add = TRUE)
url <- sprintf("http://127.0.0.1:%d", port)
repeat {
  ok <- tryCatch({ readLines(url, warn = FALSE); TRUE }, error = function(e) FALSE)
  if (ok || !bg$is_alive()) break
  Sys.sleep(0.1)
}
if (!bg$is_alive()) stop("the app stopped: ", paste(readLines(file.path(proto, "app.err")), collapse = "\n"))
lap("app process answers HTTP")
b <- chromote::ChromoteSession$new(width = 1400L, height = 1000L)
on.exit(b$close(), add = TRUE)
js <- function(expr) b$Runtime$evaluate(expr, returnByValue = TRUE, awaitPromise = TRUE)$result$value
waitFor <- function(expr, limit = 120) {
  start <- proc.time()[["elapsed"]]
  repeat {
    v <- tryCatch(js(expr), error = function(e) FALSE)
    if (isTRUE(v)) return(invisible(TRUE))
    if (proc.time()[["elapsed"]] - start > limit) stop("timed out waiting for: ", expr)
    Sys.sleep(0.1)
  }
}
b$Page$navigate(url)
waitFor("!!(window.Shiny && Shiny.shinyapp && Shiny.shinyapp.isConnected())")
lap("Chrome: page loaded, Shiny connected")
js("document.getElementById('sample').click(); true")
waitFor("document.getElementById('drawn').innerText.indexOf('375 animals drawn') >= 0")
lap("sample clicked: '375 animals drawn' shown")
waitFor(paste0("(function(){var w = HTMLWidgets.find('#diagram');",
               "return !!(w && w.network && w.network.body && ",
               "Object.keys(w.network.body.nodes).length > 700);})()"))
lap("the 375 animals' network built in the page")
n <- js("Object.keys(HTMLWidgets.find('#diagram').network.body.nodes).length")
cat("   nodes in the page's network:", n, "\n")
fetchLen <- function(id) js(sprintf(paste0(
  "fetch(document.getElementById('%s').href).then(r => r.text())",
  ".then(t => t.length + ' chars, starts ' + t.slice(0, 40))"), id))
cat("   CSV:", fetchLen("saveCsv"), "\n")
lap("CSV download fetched")
cat("   SVG:", fetchLen("saveSvg"), "\n")
lap("SVG download fetched (savePedigreeDiagram in the app's process)")
# A smaller view, as most tests would use: one family of the sample.
js(paste0("Shiny.setInputValue('focal', document.querySelector('#table') ? '' : ''); ",
          "Shiny.setInputValue('show', 'near'); true"))
first <- js("HTMLWidgets.find('#diagram').network.body.data.nodes.getIds().filter(i => !i.startsWith('__'))[0]")
js(sprintf("Shiny.setInputValue('focal', '%s'); true", first))
waitFor("/^[0-9]+ animals drawn/.test(document.getElementById('drawn').innerText) && document.getElementById('drawn').innerText.indexOf('375') < 0")
lap(sprintf("near relatives of %s drawn: %s", first, js("document.getElementById('drawn').innerText")))
cat("app stderr lines:", length(readLines(file.path(proto, "app.err"))), "\n")
}
main()
