# G17b, S75: what each way of choosing the animals (F6, F7, F8) gives on the
# 375-animal sample, and whether the app can draw it. Not package code. Run
# from the repository root with renv's library:
#   Rscript --no-init-file docs/planning/pedigree-app-prototype/g17bViews.R
# Every animal of the sample is taken as the one focal animal in turn.
suppressMessages(pkgload::load_all(".", quiet = TRUE))
ped <- utils::read.csv(.appSamplePath(), colClasses = "character",
                       na.strings = c("", "NA"))[, c("id", "sire", "dam",
                                                     "sex")]
quietDraw <- function(p) {
  t0 <- proc.time()[["elapsed"]]
  d <- .appDraw(p)
  list(ok = is.null(d$error), error = d$error,
       seconds = proc.time()[["elapsed"]] - t0,
       drawn = if (is.null(d$widget)) 0L else
         sum(!startsWith(as.character(d$widget$x$nodes$id), "__")),
       notes = d$notes)
}
rowless <- function(p) {
  parents <- stats::na.omit(c(p$sire, p$dam))
  unique(parents[!parents %in% p$id])
}

## ---- F6: one family ----
fam <- findPedigreeNumber(ped$id, ped$sire, ped$dam)
sizes <- sort(table(fam), decreasing = TRUE)
cat("F6 families:", length(sizes), "| sizes:", paste(sizes, collapse = ", "),
    "| names:", paste(names(sizes), collapse = ", "), "\n")
for (f in names(sizes)) {
  r <- quietDraw(ped[fam == f, ])
  cat(sprintf("  family %s: %d animals, rowless parents %d, drawn %s (%d), %.2f s\n",
              f, sizes[[f]], length(rowless(ped[fam == f, ])), r$ok, r$drawn,
              r$seconds))
}

## ---- F7: ancestors and descendants of one focal animal ----
## (a) the union, drawn as the app draws (gen from the rows kept); (d) the
## union with gen from the whole pedigree, as nprcgenekeepr's Browser draws it
## (its gen comes before the trim); (b) the union with each parent outside the
## view set to NA (removeAnimals()); (c) the union with each parent outside
## the view added as a row of its own, its parents unknown.
whole <- ped
whole$gen <- findGeneration(ped$id, ped$sire, ped$dam)
drawWithGen <- function(p) {
  r <- tryCatch({
    suppressMessages(suppressWarnings(
      drawPedigreeDiagram(makePedigreeMatingLayout(p))))
  }, error = function(e) e)
  if (inherits(r, "error")) conditionMessage(r) else "ok"
}
f7 <- lapply(ped$id, function(id) {
  keep <- union(trimPedigree(ped, id)$id, getDescendantPedigree(ped, id)$id)
  a <- ped[ped$id %in% keep, ]
  b <- removeAnimals(ped, setdiff(ped$id, keep))
  c <- rbind(a, transform(ped[ped$id %in% rowless(a), ], sire = NA, dam = NA))
  rd <- drawWithGen(whole[whole$id %in% keep, ])
  ra <- quietDraw(a)
  rb <- quietDraw(b)
  rc <- quietDraw(c)
  data.frame(id = id, n = nrow(a), rowless = length(rowless(a)),
             aOk = ra$ok, aErr = format(ra$error), dErr = rd, bOk = rb$ok,
             bDrawn = rb$drawn, cOk = rc$ok, cN = nrow(c), cDrawn = rc$drawn,
             secA = ra$seconds, secC = rc$seconds)
})
f7 <- do.call(rbind, f7)
cat("F7 views:", nrow(f7), "| animals per view: min", min(f7$n), "median",
    stats::median(f7$n), "max", max(f7$n), "\n")
cat("  views with a parent outside the view:", sum(f7$rowless > 0L),
    "| (a) as kept, drawn:", sum(f7$aOk), "| errors:",
    paste(names(table(f7$aErr[!f7$aOk])), table(f7$aErr[!f7$aOk]),
          collapse = "; "), "\n")
cat("  (d) gen from the whole pedigree (nprcgenekeepr's way):",
    paste(names(table(f7$dErr)), table(f7$dErr), collapse = "; "), "\n")
cat("  (b) outside parents NA, drawn:", sum(f7$bOk),
    "| animals drawn < kept in", sum(f7$bDrawn < f7$n), "views\n")
cat("  (c) outside parents added, drawn:", sum(f7$cOk), "| rows added: max",
    max(f7$cN - f7$n), "| animals drawn < rows in", sum(f7$cDrawn < f7$cN),
    "views\n")
cat("  time per view (c): median", round(stats::median(f7$secC), 3),
    "s, max", round(max(f7$secC), 2), "s\n")
one <- f7[f7$rowless > 0L, ][1L, ]
cat("  e.g. focal", one$id, ":", one$n, "kept,", one$rowless,
    "parents outside\n")

## ---- F8: relatives within distance k of one focal animal ----
for (k in 1:4) {
  r <- lapply(ped$id, function(id) {
    near <- getNearRelativePedigree(ped, id, k)
    d <- quietDraw(near)
    c(n = nrow(near), rowless = length(rowless(near)), ok = d$ok,
      drawn = d$drawn, seconds = d$seconds)
  })
  r <- do.call(rbind, r)
  cat(sprintf(paste0("F8 k=%d: animals min %d median %g max %d | rowless %d ",
                     "| drawn %d of %d | fewer drawn than kept %d | ",
                     "max %.2f s\n"),
              k, min(r[, "n"]), stats::median(r[, "n"]), max(r[, "n"]),
              sum(r[, "rowless"] > 0), sum(r[, "ok"]), nrow(r),
              sum(r[, "drawn"] < r[, "n"]), max(r[, "seconds"])))
}
