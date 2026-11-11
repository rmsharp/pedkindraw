## Drift check (nprcgenekeepr's standalone-pedigree-package-plan.md section 5,
## the drift rule): lists every function copied from nprcgenekeepr whose
## arguments or code differ from nprcgenekeepr's, and fails when a difference
## has no row in DIVERGENCE.md.
##
## Usage, from the pedkindraw root:
##   Rscript tools/compareWithNprcgenekeepr.R [nprcgenekeepr clone] [ref]
## Defaults: ../nprcgenekeepr and HEAD, the clone's current commit, so a
## change made in nprcgenekeepr after the copy shows up.
##
## A copied file is an R/ file whose header says "Copied from nprcgenekeepr
## R/<file> at nprcgenekeepr commit <sha>". nprcgenekeepr's file is read from
## the clone at <ref> with git show, so nprcgenekeepr need not be installed.
## Every function assigned at the top level of either file is compared by its
## arguments and its code, parsed without source references: comments, help
## text and layout do not count.
##
## Exit status 0 when every difference has a DIVERGENCE.md row, 1 otherwise.

args <- commandArgs(trailingOnly = TRUE)
clone <- if (length(args) >= 1L) {
  args[[1L]]
} else {
  file.path("..", "nprcgenekeepr")
}
ref <- if (length(args) >= 2L) args[[2L]] else "HEAD"

## The nprcgenekeepr path and commit a file's header names, or NULL.
copiedFrom <- function(path) {
  lines <- readLines(path, n = 12L, warn = FALSE)
  comments <- sub("^## ?", "", lines[startsWith(lines, "##")])
  header <- paste(comments, collapse = " ")
  pattern <- paste0(
    "Copied from nprcgenekeepr ([^ ]+) at nprcgenekeepr commit ",
    "([0-9a-f]{7,40})"
  )
  found <- regmatches(header, regexec(pattern, header))[[1L]]
  if (length(found) == 0L) {
    return(NULL)
  }
  list(path = found[[2L]], commit = found[[3L]])
}

## The functions assigned at the top level of some R code, by name, each as
## its "function" expression, not evaluated.
topLevelFunctions <- function(text) {
  exprs <- parse(text = text, keep.source = FALSE)
  fns <- list()
  for (e in exprs) {
    isAssign <- is.call(e) && length(e) == 3L &&
      as.character(e[[1L]]) %in% c("<-", "=")
    if (isAssign && is.name(e[[2L]]) && is.call(e[[3L]]) &&
      identical(e[[3L]][[1L]], as.name("function"))) {
      fns[[as.character(e[[2L]])]] <- e[[3L]]
    }
  }
  fns
}

## How two "function" expressions differ: "" when they do not.
howTheyDiffer <- function(ours, theirs) {
  parts <- c(
    arguments = !identical(ours[[2L]], theirs[[2L]]),
    code = !identical(ours[[3L]], theirs[[3L]])
  )
  paste(names(parts)[parts], collapse = " and ")
}

## Function names with a row in DIVERGENCE.md: the first cell of each table
## row, without backticks or "()".
recordedDivergences <- function(path = "DIVERGENCE.md") {
  if (!file.exists(path)) {
    return(character(0L))
  }
  rows <- grep("^\\|", readLines(path, warn = FALSE), value = TRUE)
  cells <- trimws(vapply(strsplit(rows, "|", fixed = TRUE), `[`, "", 2L))
  cells <- gsub("`|\\(\\)", "", cells)
  setdiff(cells, c("Function", "", grep("^-+$", cells, value = TRUE)))
}

gitShow <- function(path) {
  out <- suppressWarnings(system2(
    "git", c("-C", shQuote(clone), "show", shQuote(paste0(ref, ":", path))),
    stdout = TRUE, stderr = FALSE
  ))
  if (!is.null(attr(out, "status"))) {
    return(NULL)
  }
  out
}

resolved <- system2(
  "git", c("-C", shQuote(clone), "rev-parse", "--short=9", shQuote(ref)),
  stdout = TRUE
)
cat("nprcgenekeepr clone:", clone, " ref:", ref, "=", resolved, "\n")

recorded <- recordedDivergences()
report <- data.frame(
  file = character(0L), fn = character(0L), copiedAt = character(0L),
  difference = character(0L), stringsAsFactors = FALSE
)
for (path in list.files("R", pattern = "\\.R$", full.names = TRUE)) {
  origin <- copiedFrom(path)
  if (is.null(origin)) {
    next
  }
  ours <- topLevelFunctions(readLines(path, warn = FALSE))
  theirsText <- gitShow(origin$path)
  theirs <- if (is.null(theirsText)) list() else topLevelFunctions(theirsText)
  for (fn in union(names(ours), names(theirs))) {
    difference <- if (is.null(theirsText)) {
      paste("no", origin$path, "at", ref)
    } else if (!fn %in% names(theirs)) {
      "only in pedkindraw"
    } else if (fn %in% names(ours)) {
      howTheyDiffer(ours[[fn]], theirs[[fn]])
    } else {
      "only in nprcgenekeepr"
    }
    report[nrow(report) + 1L, ] <- list(
      basename(path), fn, origin$commit, difference
    )
  }
}

differ <- report[nzchar(report$difference), ]
unrecorded <- differ[!differ$fn %in% recorded, ]
for (i in seq_len(nrow(report))) {
  r <- report[i, ]
  status <- if (!nzchar(r$difference)) {
    "same"
  } else if (r$fn %in% recorded) {
    paste("differs in", r$difference, "(recorded in DIVERGENCE.md)")
  } else {
    paste("DIFFERS in", r$difference, "-- NO DIVERGENCE.md ROW")
  }
  cat(sprintf("  %-28s %-28s copied at %s: %s\n", r$file, r$fn, r$copiedAt,
    status))
}
cat(sprintf(
  paste(
    "%d copied functions in %d files; %d differ;",
    "%d without a DIVERGENCE.md row\n"
  ),
  nrow(report), length(unique(report$file)), nrow(differ), nrow(unrecorded)
))
quit(status = if (nrow(unrecorded) > 0L) 1L else 0L)
