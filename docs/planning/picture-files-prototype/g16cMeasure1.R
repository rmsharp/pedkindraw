## A measuring prototype, not package code (pedkindraw S72, G16c's pre-RED measures, docs/planning/picture-files-plan.md section 15): measure1. Run from the repository root with G16C_OUT set to an output folder (measure2.R also G16C_LIB, a library holding pdftools).
## G16c pre-RED measure 1 (scratch, not package code): the 375 animals' picture on
## three pages, read by pdftotext -bbox: ids written, distinct, overlapped, id height
## in points, and the time of each file. Run from the repo root.
Sys.setenv(NOT_CRAN = "true")
suppressMessages(pkgload::load_all(".", quiet = TRUE))
out <- file.path(Sys.getenv("G16C_OUT"))
dir.create(out, showWarnings = FALSE, recursive = TRUE)

ped <- utils::read.csv("tests/testthat/fixtures/obfuscated_rhesus_mhc_ped.csv",
                       stringsAsFactors = FALSE)
ped$gen <- findGeneration(ped$id, ped$sire, ped$dam)
twins <- utils::read.csv("tests/testthat/fixtures/obfuscated_rhesus_mhc_twin_relations.csv",
                         stringsAsFactors = FALSE)
muffle <- function(expr) withCallingHandlers(expr,
  warning = function(w) invokeRestart("muffleWarning"),
  message = function(m) invokeRestart("muffleMessage"))
layout <- muffle(makePedigreeMatingLayout(ped, twinRelations = twins))
widget <- drawPedigreeDiagram(layout)

timeit <- function(expr) {
  t0 <- proc.time()[["elapsed"]]; force(expr); proc.time()[["elapsed"]] - t0
}

wordsOf <- function(pdf) {
  xml <- system2(Sys.which("pdftotext"), c("-bbox", shQuote(pdf), "-"),
                 stdout = TRUE, stderr = FALSE)
  w <- regmatches(xml, regexpr('<word [^>]*>[^<]+</word>', xml))
  num <- function(a) as.numeric(sub(paste0('.*', a, '="([-0-9.]+)".*'), "\\1", w))
  txt <- sub("^<word [^>]*>([^<]+)</word>$", "\\1", w)
  txt <- gsub("&lt;", "<", txt, fixed = TRUE); txt <- gsub("&gt;", ">", txt, fixed = TRUE)
  txt <- gsub("&amp;", "&", txt, fixed = TRUE)
  data.frame(text = txt, x0 = num("xMin"), y0 = num("yMin"), x1 = num("xMax"),
             y1 = num("yMax"), stringsAsFactors = FALSE)
}

## Number of boxes in `b` that overlap another box of `b` by a positive area,
## and the same with a tolerance: an overlap smaller than `tol` of the smaller box.
overlapped <- function(b, tol = 0) {
  n <- nrow(b); hit <- logical(n)
  for (i in seq_len(n - 1L)) {
    j <- (i + 1L):n
    w <- pmin(b$x1[i], b$x1[j]) - pmax(b$x0[i], b$x0[j])
    h <- pmin(b$y1[i], b$y1[j]) - pmax(b$y0[i], b$y0[j])
    a <- ifelse(w > 0 & h > 0, w * h, 0)
    small <- pmin((b$x1[i] - b$x0[i]) * (b$y1[i] - b$y0[i]),
                  (b$x1[j] - b$x0[j]) * (b$y1[j] - b$y0[j]))
    bad <- a > tol * small & a > 0
    if (any(bad)) { hit[i] <- TRUE; hit[j[bad]] <- TRUE }
  }
  sum(hit)
}

pages <- list(`14x7 in` = c(14, 7), `letter landscape 11x8.5` = c(11, 8.5),
              `letter portrait 8.5x11` = c(8.5, 11), `7x5 in` = c(7, 5))
for (nm in names(pages)) {
  p <- pages[[nm]]
  f <- file.path(out, paste0("rhesus-", gsub("[^0-9a-z]", "_", nm), ".pdf"))
  t <- timeit(savePedigreeDiagram(widget, f, width = p[[1]], height = p[[2]]))
  b <- wordsOf(f)
  ids <- b[b$text %in% ped$id, ]
  cat(sprintf(paste0("%-24s pdf %.1fs %7d B | words %d, id words %d, distinct %d | ",
                     "id box height pt: median %.2f min %.2f max %.2f | ",
                     "id words overlapping another word: %d (strict), %d (>1%% of smaller box), ",
                     "id-vs-id %d\n"),
              nm, t, file.size(f), nrow(b), nrow(ids), length(unique(ids$text)),
              median(ids$y1 - ids$y0), min(ids$y1 - ids$y0), max(ids$y1 - ids$y0),
              { all <- b; hit <- 0L
                for (k in seq_len(nrow(ids))) {
                  o <- all[all$text != ids$text[k] | all$x0 != ids$x0[k] | all$y0 != ids$y0[k], ]
                  w <- pmin(ids$x1[k], o$x1) - pmax(ids$x0[k], o$x0)
                  h <- pmin(ids$y1[k], o$y1) - pmax(ids$y0[k], o$y0)
                  if (any(w > 0 & h > 0)) hit <- hit + 1L
                }; hit },
              { all <- b; hit <- 0L
                for (k in seq_len(nrow(ids))) {
                  o <- all[all$text != ids$text[k] | all$x0 != ids$x0[k] | all$y0 != ids$y0[k], ]
                  w <- pmin(ids$x1[k], o$x1) - pmax(ids$x0[k], o$x0)
                  h <- pmin(ids$y1[k], o$y1) - pmax(ids$y0[k], o$y0)
                  s <- pmin((ids$x1[k]-ids$x0[k])*(ids$y1[k]-ids$y0[k]),
                            (o$x1-o$x0)*(o$y1-o$y0))
                  if (any(w > 0 & h > 0 & w*h > 0.01*s)) hit <- hit + 1L
                }; hit },
              overlapped(ids)))
}

## the SVG and the PNG of the same drawing, timed
t <- timeit(savePedigreeDiagram(widget, file.path(out, "rhesus.svg"), width = 14, height = 7))
cat(sprintf("svg 14x7: %.1fs %d B\n", t, file.size(file.path(out, "rhesus.svg"))))
t <- timeit(savePedigreeDiagram(widget, file.path(out, "rhesus.png"), width = 14, height = 7))
cat(sprintf("png 14x7 (300 dpi): %.1fs %d B\n", t, file.size(file.path(out, "rhesus.png"))))
