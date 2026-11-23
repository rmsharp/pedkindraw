## Copyright(c) 2017-2026 R. Mark Sharp
## This file is part of pedkindraw
## Copied from nprcgenekeepr tools/perf/harness.R at nprcgenekeepr commit
## 3e06730c5, lines 19-72 only (docs/planning/pedkindraw-timing-plan.md section
## 4.1, Phase 17h1): usedMb(), maxUsedMb(), mbColumnAfter(), measure() and
## withSeed(), which the timing child and the cases use; the rest of that file
## measures nprcgenekeepr's own scenarios. Changes: none to those lines. The
## tests are in tests/test_measure.R.

## ---- Measuring one call ----------------------------------------------------

## The memory in use, and the peak since the last gc(reset = TRUE), in Mb, from
## a gc() result. R 4.6 adds a "limit (Mb)" column before "max used", so both
## columns are found by name, and the Mb figure is the column after each.
usedMb <- function(g) {
  sum(g[, mbColumnAfter(g, "used")])
}

maxUsedMb <- function(g) {
  sum(g[, mbColumnAfter(g, "max used")])
}

mbColumnAfter <- function(g, name) {
  col <- which(colnames(g) == name)
  if (length(col) != 1L) {
    stop("the gc() result has no '", name, "' column", call. = FALSE)
  }
  col + 1L
}

## The elapsed seconds, the peak memory above the starting point (Mb) and the
## size of the result (Mb) of one expression, plus its value. The expression is
## forced inside the timed window, once. The peak is a high-water mark sampled
## at garbage collections: a lower bound, and noisy (plan section 2).
measure <- function(expr) {
  base <- usedMb(gc(reset = TRUE))
  started <- proc.time()[["elapsed"]]
  value <- expr
  seconds <- proc.time()[["elapsed"]] - started
  peakMb <- maxUsedMb(gc()) - base
  list(seconds = seconds, peakMb = peakMb,
       resultMb = as.numeric(utils::object.size(value)) / 2L^20L,
       value = value)
}

## Run `code` after set.seed(seed), then put the caller's random-number state
## back as it was (or remove it, when there was none).
withSeed <- function(seed, code) {
  hadSeed <- exists(".Random.seed", envir = globalenv(), inherits = FALSE)
  if (hadSeed) {
    oldSeed <- get(".Random.seed", envir = globalenv(), inherits = FALSE)
  }
  on.exit({
    if (hadSeed) {
      # nolint next: object_name_linter. R fixes the name.
      assign(".Random.seed", oldSeed, envir = globalenv())
    } else if (exists(".Random.seed", envir = globalenv(), inherits = FALSE)) {
      rm(".Random.seed", envir = globalenv())
    }
  }, add = TRUE)
  set.seed(seed)
  code
}
