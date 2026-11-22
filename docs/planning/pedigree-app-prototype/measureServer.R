# G17 planning (S73): how long shiny::testServer() takes on the prototype's
# server, with no browser. Run from the repository root:
#   Rscript --no-init-file <scratch>/proto/measureServer.R <scratch>/proto
args <- commandArgs(trailingOnly = TRUE)
suppressMessages(pkgload::load_all(".", quiet = TRUE))
source(file.path(args[[1L]], "app.R"))
`%||%` <- function(a, b) if (is.null(a)) b else a
t0 <- proc.time()[["elapsed"]]
lap <- function(what) {
  t1 <- proc.time()[["elapsed"]]
  cat(sprintf("%-55s %6.2f s\n", what, t1 - t0))
  t0 <<- t1
}
lap("load_all + source")
shiny::testServer(protoServer, {
  session$setInputs(sample = 1L)
  session$setInputs(colid = "id", colsire = "sire", coldam = "dam", colsex = "sex",
                    show = "all", edgeStyle = "rectilinear", focal = "", maxDist = 2L,
                    conditions = NULL)
  lap("sample loaded, columns set")
  cat("  ", output$drawn, "\n")
  lap("all: rows counted")
  w <- output$diagram
  lap(sprintf("all: widget rendered (%d chars of JSON)", nchar(w)))
  chk <- output$checks
  lap("checks table")
  fam <- families()
  big <- names(sort(table(fam), decreasing = TRUE))[[1L]]
  session$setInputs(show = "family", family = big)
  cat("  ", output$drawn, " (family", big, "of", length(unique(fam)), "families)\n")
  w <- output$diagram
  lap("family: widget rendered")
  focal <- ped()$id[200L]
  session$setInputs(show = "lineal", focal = focal)
  cat("  ", output$drawn, " (focal", focal, ")\n")
  w <- output$diagram
  lap("lineal: widget rendered")
  session$setInputs(show = "near", maxDist = 1L)
  cat("  ", output$drawn, "\n")
  w <- output$diagram
  lap("near (1 step): widget rendered")
  session$setInputs(edgeStyle = "direct")
  w <- output$diagram
  lap("near, direct: widget rendered")
  f <- output$saveCsv
  cat("   CSV download rows:", nrow(utils::read.csv(f)), "\n")
  lap("CSV download")
  session$setInputs(clicked = list(ped()$id[[5L]]))
  lap("click sent (focal box updated in the browser only)")
})
