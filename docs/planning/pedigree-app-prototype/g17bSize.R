# G17b, S75: how long the app's drawing takes at about 375, 500, 1,000 and
# 2,000 animals (F19's number and words). Not package code. Run from the
# repository root with renv's library, one size per process under a time
# limit, the size as the last argument:
#   timeout 300 Rscript --no-init-file docs/planning/pedigree-app-prototype/g17bSize.R 1000
# The pedigrees: the sample (375), and from nprcgenekeepr's examplePedigree
# (3,694; read from the clone's data/, which is only read) the ancestors of
# animals with a parent recorded, taken in a seeded random order one at a
# time until at least n animals are kept (trimPedigree(), so every parent
# kept has its row); id, sire, dam and sex, nothing else. The time is what
# the app's .appDraw() takes: findGeneration(), makePedigreeMatingLayout()
# and drawPedigreeDiagram(); the browser's part is g17bBrowser.R's.
suppressMessages(pkgload::load_all(".", quiet = TRUE))
n <- as.integer(commandArgs(trailingOnly = TRUE)[[1L]])
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
  kept <- ped[0L, ]
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
stopifnot(all(stats::na.omit(c(ped$sire, ped$dam)) %in% ped$id))
gc()
t0 <- proc.time()[["elapsed"]]
drawn <- .appDraw(ped)
t1 <- proc.time()[["elapsed"]]
nodes <- if (is.null(drawn$widget)) NA else nrow(drawn$widget$x$nodes)
cat(sprintf(paste0("n=%d animals | .appDraw %.1f s | error=%s | nodes=%s | ",
                   "animals drawn=%s | notes=%d: %s\n"),
            nrow(ped), t1 - t0, format(drawn$error), nodes,
            if (is.null(drawn$widget)) NA else
              sum(!startsWith(as.character(drawn$widget$x$nodes$id), "__")),
            length(drawn$notes), substr(paste(drawn$notes, collapse = " / "),
                                        1L, 160L)))
