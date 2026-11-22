# G17a measure (c), S74: the server tests time with NOT_CRAN unset, and whether
# testServer() computes outputs nobody reads. Run from the repository root with
# renv's library: Rscript --no-init-file <this file>. Not package code.

## ---- part 1: the prototype server on a 4-animal file ----
# S74 measure (c): the prototype's server under testServer() on a small typed
# pedigree, NOT_CRAN unset, as a G17a server test would run it.
t0 <- proc.time()[["elapsed"]]
suppressMessages(pkgload::load_all(".", quiet = TRUE))
source("docs/planning/pedigree-app-prototype/app.R")
`%||%` <- function(a, b) if (is.null(a)) b else a
t1 <- proc.time()[["elapsed"]]
csv <- tempfile(fileext = ".csv")
utils::write.csv(data.frame(ego = c("s1", "d1", "o1", "o2"), father = c(NA, NA, "s1", "s1"),
                            mother = c(NA, NA, "d1", "d1"), gender = c("M", "F", "F", "M")),
                 csv, row.names = FALSE, na = "")
one <- function() suppressPackageStartupMessages(shiny::testServer(protoServer, {
  session$setInputs(file = data.frame(name = "p.csv", size = 1, type = "text/csv", datapath = csv))
  session$setInputs(colid = "ego", colsire = "father", coldam = "mother", colsex = "gender",
                    show = "all", edgeStyle = "rectilinear", focal = "", maxDist = 2L, conditions = NULL)
  stopifnot(identical(output$drawn, "4 animals drawn"))
  w <- output$diagram; ch <- output$checks; tb <- output$table
}))
t2 <- proc.time()[["elapsed"]]; one(); t3 <- proc.time()[["elapsed"]]
for (i in 1:10) one(); t4 <- proc.time()[["elapsed"]]
cat(sprintf("NOT_CRAN=%s load_all+source %.2f s; first testServer (shiny loads) %.2f s; next 10 %.2f s (%.3f each)\n",
            Sys.getenv("NOT_CRAN"), t1 - t0, t3 - t2, t4 - t3, (t4 - t3) / 10))

## ---- part 2: eager outputs (run as its own script) ----
suppressMessages(pkgload::load_all(".", quiet = TRUE))
source("docs/planning/pedigree-app-prototype/app.R")
`%||%` <- function(a, b) if (is.null(a)) b else a
calls <- 0L
real <- makePedigreeMatingLayout
makePedigreeMatingLayout <- function(...) { calls <<- calls + 1L; suppressWarnings(real(...)) }
environment(protoServer) <- environment()
suppressPackageStartupMessages(shiny::testServer(protoServer, {
  t0 <- proc.time()[[3]]
  session$setInputs(sample = 1L)
  session$setInputs(colid = "id", colsire = "sire", coldam = "dam", colsex = "sex",
                    show = "all", edgeStyle = "rectilinear", focal = "", maxDist = 2L, conditions = NULL)
  t1 <- proc.time()[[3]]
  cat(sprintf("after setInputs, nothing read: %.2f s, layout calls %d\n", t1 - t0, calls))
  n <- nrow(raw())
  t2 <- proc.time()[[3]]
  cat(sprintf("raw() read (%d rows): %.2f s, layout calls %d\n", n, t2 - t1, calls))
  x <- output$drawn
  t3 <- proc.time()[[3]]
  cat(sprintf("output$drawn read: %.2f s, layout calls %d\n", t3 - t2, calls))
  w <- output$diagram
  t4 <- proc.time()[[3]]
  cat(sprintf("output$diagram read: %.2f s, layout calls %d\n", t4 - t3, calls))
}))
