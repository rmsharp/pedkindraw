# G17d, S77: what shiny::testServer() gives for a download output, measured
# before the pre-RED picker (Learning 17): whether its content runs before the
# output is read, after inputs change, and what reading output$<id> returns
# (the file's path, named by filename(), or the content's error). Not package
# code. Run from the repository root with renv's library:
#   Rscript --no-init-file docs/planning/pedigree-app-prototype/g17dServer.R
suppressMessages(pkgload::load_all(".", quiet = TRUE))
cat("shiny", as.character(packageVersion("shiny")), "\n")
calls <- new.env()
calls$n <- 0L
server <- function(input, output, session) {
  rows <- shiny::reactive(data.frame(id = c("a", "b"), n = c(1, input$k)))
  output$txt <- shiny::renderText(paste("k is", input$k))
  output$csv <- shiny::downloadHandler(
    filename = function() paste0("animals-", input$k, ".csv"),
    content = function(file) {
      calls$n <- calls$n + 1L
      utils::write.csv(rows(), file, row.names = FALSE)
    })
  output$bad <- shiny::downloadHandler(
    filename = "x.svg",
    content = function(file) stop("no Chrome here"))
}
start <- proc.time()[["elapsed"]]
suppressPackageStartupMessages(shiny::testServer(server, {
  session$setInputs(k = 5)
  session$setInputs(k = 7)
  cat("content runs after two input changes, before output$csv is read:",
      calls$n, "\n")
  path <- output$csv
  cat("output$csv is a", class(path), "naming", basename(path),
      "; it exists:", file.exists(path), "; content runs:", calls$n, "\n")
  print(utils::read.csv(path))
  bad <- tryCatch(output$bad, error = function(e) e)
  cat("output$bad, whose content stops:",
      if (inherits(bad, "error")) paste("an error,", conditionMessage(bad))
      else bad, "\n")
  undefined <- tryCatch(output$never, error = function(e) e)
  cat("an output never defined:",
      if (inherits(undefined, "error")) {
        paste("an error,", conditionMessage(undefined))
      } else {
        format(undefined)
      }, "\n")
}))
cat(sprintf("%.2f s\n", proc.time()[["elapsed"]] - start))
