## Speed tables check (docs/planning/documentation-plan.md section 5.5 and
## 16d's DONE item 2; the standalone plan's ruling R79): every number in the
## tables of vignettes/speed.Rmd equals its source. The sources are
## nprcgenekeepr's committed timing results, read from a clone with git show
## (nprcgenekeepr need not be installed), and, for pedkindraw's own single
## runs, the plan's Done records and the ledger in this repository.
##
## Usage, from the pedkindraw root:
##   Rscript tools/checkSpeedTables.R [nprcgenekeepr clone] [--print=<name>]
## Default clone ../nprcgenekeepr. CI has no clone, so this runs on a
## developer's machine only. --print=<name> prints the table the script
## expects for <name>, as Markdown, and checks nothing.
##
## Each table in the vignette comes after a line
##   <!-- speed-table: <name> -->
## and this script builds the table that name stands for from its sources: the
## header, every label and every cell. Seconds are the study's own figure to
## three significant figures, as its summary scripts print them ("<0.001"
## below a millisecond); a size that failed shows how ("memory", "time",
## "crash", "refused"); the sizes after a failure are empty, as in the study;
## a size the record did not try is "not run". The vignette's table must equal
## it cell for cell, and every table in the vignette must have a marker.
## Prints each difference and the count of numbers matched; exit status 0 only
## when every table is present and equal.

args <- commandArgs(trailingOnly = TRUE)
printName <- sub("^--print=", "", args[startsWith(args, "--print=")])
args <- args[!startsWith(args, "--")]
clone <- if (length(args) >= 1L) args[[1L]] else file.path("..", "nprcgenekeepr")
vignetteFile <- file.path("vignettes", "speed.Rmd")
planFile <- file.path("docs", "planning", "standalone-pedigree-package-plan.md")
ledgerFile <- file.path("methodology", "CHANGELOG.md")
studyFile <- file.path("docs", "research",
                       "pedigree-package-comparison-2026-11.md")

## ---- Reading the sources -------------------------------------------------

gitShow <- function(commit, path) {
  out <- suppressWarnings(system2(
    "git", c("-C", shQuote(clone), "show", shQuote(paste0(commit, ":", path))),
    stdout = TRUE, stderr = FALSE
  ))
  if (!is.null(attr(out, "status"))) {
    stop("cannot read ", path, " at ", commit, " in ", clone, call. = FALSE)
  }
  out
}
commitExists <- function(commit) {
  status <- system2("git", c("-C", shQuote(clone), "cat-file", "-e",
                             shQuote(paste0(commit, "^{commit}"))),
                    stdout = FALSE, stderr = FALSE)
  identical(status, 0L)
}
readAt <- function(commit, path) {
  utils::read.csv(text = gitShow(commit, path), stringsAsFactors = FALSE)
}

## The three records (the documentation plan's section 2): where each one's
## results are, the nprcgenekeepr code it timed, and the document that names
## that code.
results <- "tools/pedigreeComparison/results"
records <- list(
  partA = list(
    label = "Part A", what = "Computation (session S1123)",
    commit = "2a1431f30", code = "70e0492eb",
    cells = file.path(results, "timing.csv"),
    runs = file.path(results, "timingRuns.csv")
  ),
  partB = list(
    label = "Part B", what = "Drawing (session S1125)",
    commit = "5970b1ce5", code = "fd7c3d8ce",
    cells = file.path(results, "drawingTiming.csv"),
    runs = file.path(results, "drawingTimingRuns.csv")
  ),
  rewrite = list(
    label = "Rewrite", what = "The rewrite against 3.0.0 (session S1141)",
    commit = "25ba45ecb", code = "d280dc8e8",
    cells = file.path(results, "version", "versionCells.csv"),
    runs = file.path(results, "version", "versionRuns.csv")
  )
)
for (r in names(records)) {
  records[[r]]$cellData <- readAt(records[[r]]$commit, records[[r]]$cells)
  records[[r]]$runData <- readAt(records[[r]]$commit, records[[r]]$runs)
}
## S1141's files hold both versions; its rows here are the rewrite's ("new"),
## by size like the study's.
rw <- records$rewrite$cellData
rw$size <- suppressWarnings(as.integer(sub("^synthetic_", "", rw$input)))
records$rewrite$newCells <- rw[rw$version == "new", ]

## ---- How a cell is written -----------------------------------------------

secondsText <- function(s) {
  if (s < 0.001) "<0.001" else format(signif(s, 3L), big.mark = ",")
}
sizeText <- function(n) formatC(n, format = "d", big.mark = ",")
gibText <- function(mb) sprintf("%.2f", mb / 1024.0)
failWord <- function(status, message) {
  if (identical(status, "error")) {
    if (grepl("segfault|bus error", message)) "crash" else "refused"
  } else {
    status
  }
}
studySizes <- c(300L, 1000L, 3000L, 10000L, 30000L, 100000L)

## One computation's rows (Part A's, or the rewrite's new rows), by size.
caseRows <- function(record, case) {
  d <- if (record == "rewrite") {
    records$rewrite$newCells
  } else {
    records[[record]]$cellData
  }
  d <- d[d$case == case, , drop = FALSE]
  if (nrow(d) == 0L) {
    stop("no rows for ", case, " in ", record, call. = FALSE)
  }
  d[order(d$size), , drop = FALSE]
}

## The seconds of one case at each of the study's sizes: a figure, how it
## failed, "" after a failure, "not run" where the record stopped trying.
secondsCells <- function(record, case) {
  d <- caseRows(record, case)
  failed <- FALSE
  vapply(studySizes, function(n) {
    r <- d[d$size == n, , drop = FALSE]
    if (failed) {
      return("")
    }
    if (nrow(r) == 0L) {
      return("not run")
    }
    if (r$status == "ok") {
      return(secondsText(r$seconds))
    }
    failed <<- TRUE
    failWord(r$status, r$message)
  }, "")
}

## The largest size that finished, what happened at the next, and the rows
## at the largest.
capacityOf <- function(d, sizes) {
  ok <- d[d$status == "ok", , drop = FALSE]
  bad <- d[d$status != "ok", , drop = FALSE]
  if (nrow(bad) > 0L) {
    first <- bad[which.min(bad$size), ]
    ok <- ok[ok$size < first$size, , drop = FALSE]
    nextText <- paste(failWord(first$status, first$message), "at",
                      sizeText(first$size))
  } else {
    later <- sizes[sizes > max(ok$size)]
    nextText <- if (length(later) == 0L) {
      paste("none up to", sizeText(max(sizes)))
    } else {
      paste(sizeText(later[[1L]]), "not run")
    }
  }
  at <- ok[which.max(ok$size), , drop = FALSE]
  list(
    capacity = if (nrow(at) == 0L) "below 300" else sizeText(at$size),
    nextText = nextText, at = at
  )
}

## The date or dates on which a record's runs of some cases were started.
runDates <- function(record, cases = NULL, version = NULL) {
  runs <- records[[record]]$runData
  if (!is.null(cases)) {
    runs <- runs[runs$case %in% cases, , drop = FALSE]
  }
  if (!is.null(version)) {
    runs <- runs[runs$version == version, , drop = FALSE]
  }
  days <- sort(unique(substr(runs$started, 1L, 10L)))
  if (length(days) == 0L) {
    stop("no runs for ", paste(cases, collapse = ", "), call. = FALSE)
  }
  paste(days, collapse = " and ")
}
## ---- Captions -------------------------------------------------------------

## Each table's caption names its records' dates, the nprcgenekeepr code they
## timed, the versions compared and the machine. The dates and commits come
## from the records; the machine and versions are checked below against the
## documents that state them.
machinePieces <- c("Apple M2 Max, 12 cores, 96 GiB", "R 4.6.2")
machine <- paste(machinePieces, collapse = ", ")
comparators <- "kinship2 1.9.6.2 and Pedixplorer 1.8.0"
release <- "fa1f2849e"
recordNote <- function(name, compared = TRUE) {
  r <- records[[name]]
  others <- if (compared) paste0(", ", comparators) else ""
  extra <- switch(name,
    partA = others,
    partB = paste0(others, ", Chrome"),
    rewrite = paste0(" against its 3.0.0 (`", release, "`)")
  )
  paste0(r$label, ": ", runDates(name), ", nprcgenekeepr `", r$code, "`",
         extra)
}
captionOf <- function(what, names, compared = TRUE) {
  paste0("Table: ", what, " ",
         paste(vapply(names, recordNote, "", compared = compared),
               collapse = "; "), ". ", machine, ".")
}

## ---- The tables ----------------------------------------------------------

## A table is a list: header (character), rows (list of character) and the
## caption line under it.
tableOf <- function(header, rows, caption) {
  list(header = header, rows = rows, caption = caption)
}

recordsTable <- function() {
  rows <- lapply(names(records), function(name) {
    r <- records[[name]]
    idle <- range(r$runData$idle)
    c(r$label, r$what, runDates(name), format(nrow(r$runData), big.mark = ","),
      sprintf("%.1f-%.1f", idle[[1L]], idle[[2L]]),
      paste0("`", r$code, "`"), paste0("`", r$commit, "`"))
  })
  tableOf(c("Record", "What it timed", "Date", "Runs",
            "CPU idle at each run's start (%)", "nprcgenekeepr code timed",
            "Results at"), rows,
          paste0("Table: The three records behind the tables, all on one ",
                 "machine: ", machine, "; compared: ", comparators, "."))
}

computationSpec <- list(
  list("Kinship, autosomal", "pedkindraw `kinship()`", "rewrite", "npg_kin"),
  list("Kinship, autosomal", "kinship2", "partA", "k2_kin"),
  list("Kinship, autosomal", "Pedixplorer", "partA", "pdx_kin"),
  list("Kinship, sparse", "pedkindraw `kinship(sparse = TRUE)`", "rewrite",
       "npg_kin_sparse"),
  list("Kinship, by family", "kinship2", "partA", "k2_makekinship"),
  list("Kinship, X chromosome", "pedkindraw `kinship()`", "rewrite",
       "npg_kinX"),
  list("Kinship, X chromosome", "kinship2", "partA", "k2_kinX"),
  list("Kinship, X chromosome", "Pedixplorer", "partA", "pdx_kinX"),
  list("Generation depth", "pedkindraw `findGeneration()`", "partA",
       "npg_gen"),
  list("Generation depth", "kinship2", "partA", "k2_depth"),
  list("Generation depth", "Pedixplorer", "partA", "pdx_depth"),
  list("Family trees", "pedkindraw `findPedigreeNumber()`", "partA",
       "npg_fam"),
  list("Family trees", "kinship2", "partA", "k2_fam"),
  list("Family trees", "Pedixplorer", "partA", "pdx_fam"),
  list("Shrink to 16 bits", "pedkindraw `shrinkPedigree()`", "rewrite",
       "npg_shrink"),
  list("Shrink to 16 bits", "kinship2", "partA", "k2_shrink"),
  list("Shrink to 16 bits", "Pedixplorer", "partA", "pdx_shrink"),
  list("Unrelated set", "kinship2", "partA", "k2_unrel"),
  list("Unrelated set", "Pedixplorer", "partA", "pdx_unrel"),
  list("Probands and their ancestors", "pedkindraw `trimPedigree()`",
       "partA", "npg_anc"),
  list("Probands and their ancestors", "Pedixplorer", "partA", "pdx_anc"),
  list("Probands and their descendants",
       "pedkindraw `getDescendantPedigree()`", "partA", "npg_desc"),
  list("Probands and their descendants", "Pedixplorer", "partA", "pdx_desc"),
  list("Build a pedigree object", "kinship2", "partA", "k2_ped"),
  list("Build a pedigree object", "Pedixplorer", "partA", "pdx_ped")
)

computationSecondsTable <- function() {
  rows <- lapply(computationSpec, function(s) {
    c(s[[1L]], s[[2L]], secondsCells(s[[3L]], s[[4L]]),
      records[[s[[3L]]]]$label)
  })
  tableOf(c("Computation", "Package", sizeText(studySizes), "Record"), rows,
          captionOf("Seconds, by the number of animals.",
                    c("partA", "rewrite")))
}

computationCapacityTable <- function() {
  rows <- lapply(computationSpec, function(s) {
    cap <- capacityOf(caseRows(s[[3L]], s[[4L]]), studySizes)
    at <- cap$at
    c(s[[1L]], s[[2L]], cap$capacity, cap$nextText,
      if (nrow(at)) gibText(at$maxRssMb) else "",
      if (nrow(at)) gibText(at$heapPeakMb) else "",
      records[[s[[3L]]]]$label)
  })
  tableOf(c("Computation", "Package", "Largest size within the limits",
            "Next size", "Process peak there (GiB)",
            "R heap peak there (GiB)", "Record"), rows,
          captionOf("The largest size and its memory.",
                    c("partA", "rewrite")))
}

rewriteTable <- function() {
  d <- records$rewrite$cellData
  one <- function(case, input, version) {
    r <- d[d$case == case & d$input == input & d$version == version, ]
    if (nrow(r) != 1L) {
      stop("no single row for ", case, " ", input, " ", version, call. = FALSE)
    }
    r
  }
  callMb <- function(r) {
    if (r$status == "ok") {
      formatC(r$maxRssMb - r$preRssMb, format = "f", digits = 0L,
              big.mark = ",")
    } else {
      ""
    }
  }
  seconds <- function(r) {
    if (r$status == "ok") secondsText(r$seconds) else failWord(r$status, "")
  }
  spec <- list(
    list("Shrink to 16 bits", "npg_shrink", "synthetic_300", "300"),
    list("Shrink to 16 bits", "npg_shrink", "synthetic_1000", "1,000"),
    list("Shrink to 16 bits", "npg_shrink", "synthetic_3000", "3,000"),
    list("Layout, direct edges", "npg_layout", "exampleTrim",
         "708 (a trimmed example)")
  )
  rows <- lapply(spec, function(s) {
    old <- one(s[[2L]], s[[3L]], "3.0.0")
    new <- one(s[[2L]], s[[3L]], "new")
    c(s[[1L]], s[[4L]], seconds(old), seconds(new), callMb(old), callMb(new))
  })
  tableOf(c("Computation", "Animals", "Before the rewrite (s)",
            "The rewrite (s)", "Before (MiB)", "The rewrite (MiB)"), rows,
          captionOf("Seconds and memory, before and after the rewrite.",
                    "rewrite"))
}

## The nprcgenekeepr path and commit a copied file's header names, or NULL
## (the drift tool's rule, tools/compareWithNprcgenekeepr.R).
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
## For each record, the copied files whose nprcgenekeepr source at the code
## the record timed differs from the source at the commit pedkindraw copied.
codeTable <- function() {
  copied <- Filter(Negate(is.null), lapply(
    sort(list.files("R", pattern = "[.]R$", full.names = TRUE)), copiedFrom
  ))
  differing <- function(code) {
    out <- vapply(copied, function(f) {
      status <- system2("git", c("-C", shQuote(clone), "diff", "--quiet",
                                 code, f$commit, "--", shQuote(f$path)),
                        stdout = FALSE, stderr = FALSE)
      if (!status %in% c(0L, 1L)) {
        stop("git diff failed on ", f$path, call. = FALSE)
      }
      if (status == 1L) basename(f$path) else ""
    }, "")
    out <- sort(out[nzchar(out)])
    if (length(out) == 0L) "none" else paste0("`", out, "`", collapse = ", ")
  }
  rows <- lapply(names(records), function(name) {
    c(records[[name]]$label, paste0("`", records[[name]]$code, "`"),
      differing(records[[name]]$code))
  })
  tableOf(c("Record", "nprcgenekeepr code timed",
            sprintf("Of the %d copied files, those that differ", length(copied))),
          rows,
          paste("Table: Each copied file's nprcgenekeepr source at the code a",
                "record timed, compared by git with its source at the commit",
                "pedkindraw copied."))
}

drawingPedigrees <- c("synthetic_300", "synthetic_1000", "synthetic_2000",
                      "rhesus375")
drawingSpec <- list(
  list("nprcgenekeepr (copied by pedkindraw)",
       "web page, `drawPedigreeDiagram()`", "npg_widget"),
  list("kinship2", "picture, `plot.pedigree()`", "k2_static"),
  list("Pedixplorer", "picture, `plot()`", "pdx_static"),
  list("Pedixplorer", "picture, `plot()`, alignment off",
       "pdx_static_unaligned"),
  list("Pedixplorer", "plotly page, its app's call", "pdx_plotly"),
  list("Pedixplorer", "plotly page, its app's call, alignment off",
       "pdx_plotly_unaligned")
)
drawingRows <- function(case) {
  d <- records$partB$cellData
  d <- d[d$case == case, , drop = FALSE]
  if (nrow(d) == 0L) {
    stop("no drawing rows for ", case, call. = FALSE)
  }
  d
}
## Each drawing's cell for each pedigree, totalSeconds or another column.
drawingCells <- function(case, value = "totalSeconds") {
  d <- drawingRows(case)
  synthetic <- d[d$pedigree != "rhesus375", , drop = FALSE]
  synthetic <- synthetic[order(synthetic$size), , drop = FALSE]
  failedAt <- synthetic$size[synthetic$status != "ok"]
  failedAt <- if (length(failedAt)) min(failedAt) else Inf
  vapply(drawingPedigrees, function(p) {
    r <- d[d$pedigree == p, , drop = FALSE]
    if (nrow(r) == 0L) {
      return("")
    }
    if (p != "rhesus375" && r$size > failedAt) {
      return("")
    }
    if (r$status != "ok") {
      return(failWord(r$status, r$message))
    }
    secondsText(r[[value]])
  }, "")
}

drawingSecondsTable <- function() {
  ## No drawing reached 3,000 animals, so the table has no 3,000 column.
  reached <- records$partB$cellData$pedigree == "synthetic_3000" &
    records$partB$cellData$status == "ok"
  if (any(reached)) {
    stop("a drawing reached 3,000 animals: add the column", call. = FALSE)
  }
  rows <- lapply(drawingSpec, function(s) {
    c(s[[1L]], s[[2L]], drawingCells(s[[3L]]))
  })
  tableOf(c("Package", "Drawing", "300", "1,000", "2,000",
            "The 375-animal example"), rows,
          captionOf("Seconds, by the number of animals.", "partB"))
}

drawingPartsTable <- function() {
  inR <- drawingCells("npg_widget", "rSeconds")
  inChrome <- drawingCells("npg_widget", "browserSeconds")
  keep <- c(1L, 2L, 4L)
  tableOf(
    c("Part", "300", "1,000", "The 375-animal example"),
    list(
      c(paste("In R: generations, layout and drawing,",
              "saved as a web page"), inR[keep]),
      c("In Chrome: from opening the page to its first drawn frame",
        inChrome[keep])
    ),
    captionOf("Seconds of nprcgenekeepr's drawing, in two parts.", "partB",
              compared = FALSE)
  )
}

drawingCapacityTable <- function() {
  sizes <- c(300L, 1000L, 2000L, 3000L)
  rows <- lapply(drawingSpec, function(s) {
    d <- drawingRows(s[[3L]])
    d <- d[d$pedigree != "rhesus375", , drop = FALSE]
    cap <- capacityOf(d, sizes)
    at <- cap$at
    c(s[[1L]], s[[2L]], cap$capacity, cap$nextText,
      if (nrow(at)) gibText(at$maxRssMb) else "",
      if (nrow(at) && !is.na(at$jsHeapMb)) sprintf("%.1f", at$jsHeapMb) else "")
  })
  tableOf(c("Package", "Drawing", "Largest size drawn within 120 s",
            "Next size", "Process peak there (GiB)",
            "JavaScript heap there (MiB)"), rows,
          captionOf("The largest size drawn and its memory.", "partB"))
}

## pedkindraw's own single runs: each number read from its Done record in the
## plan, each date from the session's ledger entry.
doneParagraph <- function(start) {
  plan <- readLines(planFile, warn = FALSE)
  first <- which(startsWith(plan, start))
  if (length(first) != 1L) {
    stop("no single Done record starting ", start, call. = FALSE)
  }
  last <- first
  while (last < length(plan) && nzchar(plan[[last + 1L]])) {
    last <- last + 1L
  }
  paste(plan[first:last], collapse = " ")
}
numberIn <- function(text, pattern) {
  m <- regmatches(text, regexec(pattern, text, perl = TRUE))[[1L]]
  if (length(m) < 2L) {
    stop("pattern not found in its Done record: ", pattern, call. = FALSE)
  }
  m[[2L]]
}
sessionDate <- function(session) {
  ledger <- readLines(ledgerFile, warn = FALSE)
  pattern <- paste0("^### (2026-[0-9]{2}-[0-9]{2}) .* ", session, ": ")
  hits <- regmatches(ledger, regexec(pattern, ledger))
  days <- unique(vapply(Filter(length, hits), `[[`, "", 2L))
  if (length(days) != 1L) {
    stop("no single ledger date for ", session, call. = FALSE)
  }
  days
}

singleRunsTable <- function() {
  checkRecord <- doneParagraph("**Done 13 (`checkPedigree()`")
  unrelRecord <- doneParagraph("**Done 13 (`findUnrelated()`")
  k2Record <- doneParagraph("**Done 14 (kinship2;")
  pxRecord <- doneParagraph("**Done 14 (Pedixplorer;")
  k2Unrel <- caseRows("partA", "k2_unrel")
  k2Unrel <- secondsText(k2Unrel$seconds[k2Unrel$size == 10000L])
  rows <- list(
    c("`checkPedigree()`", "100,000 (the study's colony)",
      numberIn(checkRecord, "([0-9.]+) s on 100,000 animals, [0-9.]+ s with"),
      "", paste("S17,", sessionDate("S17"))),
    c("`checkPedigree()`", "the same, with 5 cycles put in",
      numberIn(checkRecord, "100,000 animals, ([0-9.]+) s with 5 cycles"),
      "", paste("S17,", sessionDate("S17"))),
    c("`findUnrelated()`", "10,000 (the study's colony), 30% genotyped",
      numberIn(unrelRecord, "chosen in ([0-9.]+) s"),
      paste0("kinship2 in the study's Part A: ", k2Unrel, " s"),
      paste("S18,", sessionDate("S18"))),
    c("`asPedFrame()` of a kinship2 `pedigree`", "100,000",
      numberIn(k2Record, "; ([0-9.]+) s for 100,000 animals"),
      "", paste("S19,", sessionDate("S19"))),
    c("`asPedFrame()` of a Pedixplorer `Pedigree`", "100,000",
      numberIn(pxRecord, "silently \\(made a stop\\); ([0-9.]+) s for 100,000"),
      "a prototype's run, before the method was written",
      paste("S20,", sessionDate("S20")))
  )
  tableOf(c("Function", "Animals", "Seconds", "Note", "Session"), rows,
          paste0("Table: Single figures from the Done 13 and Done 14 ",
                 "records of pedkindraw's plan, each timing pedkindraw's ",
                 "code as that session wrote it. ", machine, "."))
}

builders <- list(
  records = recordsTable,
  code = codeTable,
  "computation-seconds" = computationSecondsTable,
  "computation-capacity" = computationCapacityTable,
  rewrite = rewriteTable,
  "drawing-seconds" = drawingSecondsTable,
  "drawing-parts" = drawingPartsTable,
  "drawing-capacity" = drawingCapacityTable,
  "single-runs" = singleRunsTable
)

asMarkdown <- function(tab) {
  line <- function(x) paste0("| ", paste(x, collapse = " | "), " |")
  c(line(tab$header), paste0("|", strrep("---|", length(tab$header))),
    vapply(tab$rows, line, ""), "", tab$caption)
}

if (length(printName) == 1L) {
  if (!printName %in% names(builders)) {
    stop("no table named ", printName, call. = FALSE)
  }
  writeLines(asMarkdown(builders[[printName]]()))
  quit(save = "no", status = 0L)
}

## ---- The names each record's code commit is found under -------------------

problems <- character()
for (r in records) {
  if (!commitExists(r$code)) {
    problems <- c(problems, paste("code commit not in the clone:", r$code))
  }
}
study <- paste(readLines(studyFile, warn = FALSE), collapse = " ")
for (code in c(records$partA$code, records$partB$code)) {
  if (!grepl(code, study, fixed = TRUE)) {
    problems <- c(problems, paste("the study does not name", code))
  }
}
rewriteDoc <- paste(gitShow(records$rewrite$commit,
  "docs/research/cleanroom-vs-3.0.0-comparison-2026-11.md"), collapse = " ")
for (said in c(records$rewrite$code, release, "Apple M2 Max, 12 cores",
               "R 4.6.2")) {
  if (!grepl(said, rewriteDoc, fixed = TRUE)) {
    problems <- c(problems, paste("S1141's study does not say", said))
  }
}
for (said in c("kinship2 1.9.6.2", "Pedixplorer 1.8.0", "Chrome")) {
  if (!grepl(said, study, fixed = TRUE)) {
    problems <- c(problems, paste("the study does not say", said))
  }
}
## The machine of every measurement in the plan's Phases 1-2 (its section
## 3.5), the machine pedkindraw's own sessions run on.
plan <- readLines(planFile, warn = FALSE)
machineLine <- plan[which(startsWith(plan, "### 3.5 Machine")) + 2L]
for (said in machinePieces) {
  if (length(machineLine) != 1L || !grepl(said, machineLine, fixed = TRUE)) {
    problems <- c(problems, paste("the plan's section 3.5 does not say", said))
  }
}

## ---- The vignette's tables -----------------------------------------------

splitRow <- function(line) {
  cells <- strsplit(sub("^\\|", "", sub("\\|\\s*$", "", line)), "|",
                    fixed = TRUE)[[1L]]
  trimws(cells)
}
readTables <- function(lines) {
  marker <- "^<!-- speed-table: ([a-z-]+) -->$"
  isRow <- startsWith(trimws(lines), "|")
  owned <- logical(length(lines))
  found <- list()
  for (i in grep(marker, lines)) {
    name <- sub(marker, "\\1", lines[[i]])
    j <- i + 1L
    while (j <= length(lines) && !nzchar(trimws(lines[[j]]))) {
      j <- j + 1L
    }
    k <- j
    while (k <= length(lines) && isRow[[k]]) {
      k <- k + 1L
    }
    rows <- if (k > j) lines[j:(k - 1L)] else character()
    if (k > j) owned[j:(k - 1L)] <- TRUE
    ## The caption: the first line after the rows that is not blank, when it
    ## starts "Table:".
    while (k <= length(lines) && !nzchar(trimws(lines[[k]]))) {
      k <- k + 1L
    }
    caption <- if (k <= length(lines) && startsWith(lines[[k]], "Table:")) {
      lines[[k]]
    } else {
      NA_character_
    }
    found[[name]] <- list(rows = rows, caption = caption)
  }
  list(tables = found, unmarked = which(isRow & !owned))
}

if (!file.exists(vignetteFile)) {
  stop(vignetteFile, " does not exist", call. = FALSE)
}
read <- readTables(readLines(vignetteFile, warn = FALSE))
for (i in read$unmarked) {
  problems <- c(problems, paste0("line ", i, ": a table row with no ",
                                 "speed-table marker above its table"))
}
for (name in setdiff(names(read$tables), names(builders))) {
  problems <- c(problems, paste("unknown table name:", name))
}

numbers <- 0L
numbersMatched <- 0L
cells <- 0L
cellsMatched <- 0L
for (name in names(builders)) {
  expected <- builders[[name]]()
  want <- c(list(expected$header), expected$rows)
  wantCells <- c(unlist(want), expected$caption)
  hasDigit <- grepl("[0-9]", wantCells)
  numbers <- numbers + sum(hasDigit)
  cells <- cells + length(wantCells)
  lines <- read$tables[[name]]$rows
  if (is.null(lines) || length(lines) == 0L) {
    problems <- c(problems, paste0(name, ": no table in the vignette"))
    next
  }
  caption <- read$tables[[name]]$caption
  if (!identical(caption, expected$caption)) {
    problems <- c(problems, sprintf("%s, caption: \"%s\", expected \"%s\"",
                                    name, caption, expected$caption))
  }
  got <- lapply(lines[-2L], splitRow)
  if (length(lines) < 2L || !grepl("^\\|[-:| ]+\\|?$", trimws(lines[[2L]]))) {
    problems <- c(problems, paste0(name, ": no separator line"))
  }
  if (length(got) != length(want)) {
    problems <- c(problems, sprintf("%s: %d rows, expected %d", name,
                                    length(got) - 1L, length(want) - 1L))
  }
  gotCells <- character(length(wantCells) - 1L)
  at <- 0L
  for (i in seq_along(want)) {
    g <- if (i <= length(got)) got[[i]] else character()
    w <- want[[i]]
    if (length(g) != length(w)) {
      problems <- c(problems, sprintf("%s, row %d: %d cells, expected %d",
                                      name, i - 1L, length(g), length(w)))
    }
    for (j in seq_along(w)) {
      at <- at + 1L
      gotCells[[at]] <- if (j <= length(g)) g[[j]] else NA_character_
      if (!identical(gotCells[[at]], w[[j]])) {
        problems <- c(problems, sprintf(
          "%s, row %d (%s), column %d: \"%s\", expected \"%s\"", name,
          i - 1L, w[[1L]], j, gotCells[[at]], w[[j]]
        ))
      }
    }
  }
  gotCells <- c(gotCells, caption)
  same <- !is.na(gotCells) & gotCells == wantCells
  numbersMatched <- numbersMatched + sum(same & hasDigit)
  cellsMatched <- cellsMatched + sum(same)
}

writeLines(problems)
cat(sprintf(paste(
  "%d of %d cells holding a number match; %d of %d cells, captions",
  "included; %d tables\n"
), numbersMatched, numbers, cellsMatched, cells, length(builders)))
quit(save = "no", status = if (length(problems)) 1L else 0L)
