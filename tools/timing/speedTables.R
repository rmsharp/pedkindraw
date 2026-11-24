## Copyright(c) 2017-2026 R. Mark Sharp
## This file is part of pedkindraw
## pedkindraw's own, not copied from nprcgenekeepr (S85, Phase 17i1,
## docs/planning/pedkindraw-timing-plan.md sections 4.5 and 5.7; R159). The
## speed vignette's tables, built from the timing records in
## tools/timing/results/, and the check that compares vignettes/speed.Rmd
## with them. The command is tools/checkSpeedTables.R; the tests are
## tests/test_checkSpeedTables.R. The design is the unmerged draft's
## (draft/speed-vignette, 612eed9): a line <!-- speed-table: <name> --> before
## each table, and every table and caption built and compared cell for cell;
## its numbers and its reading of nprcgenekeepr's results do not carry over
## (R82). Base R only, so that CI runs it with no package installed (R159).

## ---- What the tables show --------------------------------------------------

## The computation cases (tools/timing/timingCases.R) as the page groups and
## names them: the study's computations, those kinship2 or Pedixplorer also
## has, and those only pedkindraw has (timingCases.R's studyCases(),
## pairedCases() and pedkindrawOnlyCases()); within a computation pedkindraw
## first. `fn` is the function a user calls, which the case's timed call
## calls (the tests check both).
speedComputationCases <- function() {
  rows <- list(
    c("pkd_kin", "study", "`kinship()`"),
    c("k2_kin", "study", "`kinship()`"),
    c("pdx_kin", "study", "`kinship()`"),
    c("pkd_kin_sparse", "study", "`kinship(sparse = TRUE)`"),
    c("k2_makekinship", "study", "`makekinship()`"),
    c("pkd_kinX", "study", "`kinship(chrtype = \"x\")`"),
    c("k2_kinX", "study", "`kinship(chrtype = \"X\")`"),
    c("pdx_kinX", "study", "`kinship(chrtype = \"X\")`"),
    c("pkd_gen", "study", "`findGeneration()`"),
    c("k2_depth", "study", "`kindepth()`"),
    c("pdx_depth", "study", "`kindepth()`"),
    c("pkd_fam", "study", "`findPedigreeNumber()`"),
    c("k2_fam", "study", "`makefamid()`"),
    c("pdx_fam", "study", "`make_famid()`"),
    c("pkd_shrink", "study", "`shrinkPedigree()`"),
    c("k2_shrink", "study", "`pedigree.shrink()`"),
    c("pdx_shrink", "study", "`shrink()`"),
    c("pkd_unrel", "study", "`findUnrelated()`"),
    c("k2_unrel", "study", "`pedigree.unrelated()`"),
    c("pdx_unrel", "study", "`unrelated()`"),
    c("pkd_anc", "study", "`trimPedigree()`"),
    c("pdx_anc", "study", "`ancestors()`"),
    c("pkd_desc", "study", "`getDescendantPedigree()`"),
    c("pdx_desc", "study", "`descendants()`"),
    c("k2_ped", "study", "`pedigree()`"),
    c("pdx_ped", "study", "`Pedigree()`"),
    c("pkd_bits", "paired", "`bitSize()`"),
    c("k2_bits", "paired", "`bitSize()`"),
    c("pdx_bits", "paired", "`bit_size()`"),
    c("pkd_unavail", "paired", "`findUnavailable()`"),
    c("k2_unavail", "paired", "`findUnavailable()`"),
    c("pdx_unavail", "paired", "`find_unavailable()`"),
    c("pkd_noninform", "paired", "`findAvailNonInform()`"),
    c("k2_noninform", "paired", "`findAvailNonInform()`"),
    c("pdx_noninform", "paired", "`find_avail_noninform()`"),
    c("pkd_availaff", "paired", "`findAvailAffected()`"),
    c("k2_availaff", "paired", "`findAvailAffected()`"),
    c("pdx_availaff", "paired", "`find_avail_affected()`"),
    c("pkd_famcheck", "paired", "`familyCheck()`"),
    c("k2_famcheck", "paired", "`familycheck()`"),
    c("pdx_famcheck", "paired", "`family_check()`"),
    c("pkd_ibd", "paired", "`ibdMatrix()`"),
    c("k2_ibd", "paired", "`ibdMatrix()`"),
    c("pdx_ibd", "paired", "`ibd_matrix()`"),
    c("pkd_near", "paired", "`getNearRelativePedigree()`"),
    c("pdx_near", "paired", "`useful_inds(max_dist = 3)`"),
    c("pkd_remove", "paired", "`removeAnimals()`"),
    c("k2_remove", "paired", "`pedigree.trim()`"),
    c("pdx_remove", "paired", "`subset()`"),
    c("pkd_frame_k2", "paired", "`asPedFrame()`"),
    c("k2_frame", "paired", "`as.data.frame()`"),
    c("pkd_frame_pdx", "paired", "`asPedFrame()`"),
    c("pdx_frame", "paired", "`ped()`"),
    c("pkd_addparents", "paired", "`addParents()`"),
    c("k2_addparents", "paired", "`fixParents()`"),
    c("pdx_addparents", "paired", "`fix_parents()`"),
    c("pkd_offspring", "paired", "`countOffspring()`"),
    c("pdx_offspring", "paired", "`num_child()`"),
    c("pkd_recode", "paired", "`recodePedigree()`"),
    c("pdx_recode", "paired", "`norm_ped()`"),
    c("pkd_founder", "paired", "`isFounder()`"),
    c("pdx_founder", "paired", "`is_founder()`"),
    c("pkd_aligned", "paired", "`findGeneration(alignMates = TRUE)`"),
    c("k2_aligned", "paired", "`kindepth(align = TRUE)`"),
    c("pdx_aligned", "paired", "`kindepth(align_parents = TRUE)`"),
    c("pkd_check", "pedkindraw", "`checkPedigree()`"),
    c("pkd_matings", "pedkindraw", "`getMatings()`"),
    c("pkd_parentsex", "pedkindraw", "`correctParentSex()`"),
    c("pkd_addback", "pedkindraw", "`addBackSecondParents()`"),
    c("pkd_uninformative", "pedkindraw", "`removeUninformativeFounders()`"),
    c("pkd_unknown", "pedkindraw", "`removeUnknownAnimals()`"),
    c("pkd_proband", "pedkindraw", "`getProbandPedigree()`"),
    c("pkd_parents", "pedkindraw", "`getParents()`"),
    c("pkd_offspringids", "pedkindraw", "`getOffspring()`"),
    c("pkd_founders", "pedkindraw", "`getFounders()`"),
    c("pkd_bothparents", "pedkindraw", "`hasBothParents()`"),
    c("pkd_oneparent", "pedkindraw", "`getIdsWithOneParent()`"),
    c("pkd_twins", "pedkindraw", "`checkTwinRelations()`")
  )
  m <- do.call(rbind, rows)
  data.frame(case = m[, 1L], group = m[, 2L], fn = m[, 3L],
             stringsAsFactors = FALSE)
}

## The drawing cases (tools/timing/drawingTimingCases.R) as the page names
## them: what is drawn and the function that draws it.
speedDrawingCases <- function() {
  rows <- list(
    c("pkd_page", "web page, `drawPedigreeDiagram()`"),
    c("pkd_page_direct", "web page, `drawPedigreeDiagram()`, direct lines"),
    c("pkd_svg", "SVG file, `savePedigreeDiagram()`"),
    c("pkd_pdf", "PDF file, `savePedigreeDiagram()`"),
    c("pkd_png", "PNG file, `savePedigreeDiagram()`"),
    c("pkd_data", "diagram data, `makePedigreeDiagramData()`"),
    c("k2_picture", "picture, `plot.pedigree()`"),
    c("pdx_picture", "picture, `plot()`"),
    c("pdx_picture_unaligned", "picture, `plot()`, alignment off"),
    c("pdx_plotly", "plotly page, its app's call"),
    c("pdx_plotly_unaligned", "plotly page, its app's call, alignment off")
  )
  m <- do.call(rbind, rows)
  data.frame(case = m[, 1L], drawing = m[, 2L], stringsAsFactors = FALSE)
}

## The page's tables, in the order they appear on it.
speedTableNames <- function() {
  c("records", "computation-study", "computation-paired",
    "computation-pedkindraw", "computation-capacity", "drawing-seconds",
    "drawing-parts", "drawing-capacity")
}

## Numbers the prose may give that are the method's own, not results: each
## with the reason it is on the page.
speedMethodNumbers <- function() {
  c(
    "3" = "three measured runs, after a warm-up",
    "120" = "the 120 s limit on a run",
    "32" = "the 32 GB limit on a run's memory",
    "29.8" = "32 GB in GiB",
    "50" = "the 50% of the CPU idle a run waits for",
    "10" = "the 10 minutes a run waits for it at most",
    "300" = "the 300 s allowed for loading and setup",
    "30" = "30% of the animals genotyped",
    "5" = "5 probands",
    "1,000" = "the size up to which a drawing can be read (R158)",
    "3,600" = "the canvas's width in pixels (R157)",
    "1,500" = "the canvas's height in pixels (R157)",
    "0" = "a founder's generation; the pairs a sparse matrix keeps, above 0"
  )
}

## ---- Reading the records ---------------------------------------------------

speedSources <- function(root = ".") {
  here <- file.path(root, "tools", "timing", "results")
  read <- function(name) {
    file <- file.path(here, name)
    if (!file.exists(file)) {
      stop("no ", file.path("tools", "timing", "results", name), call. = FALSE)
    }
    d <- utils::read.csv(file, stringsAsFactors = FALSE)
    if ("message" %in% names(d)) d$message[is.na(d$message)] <- ""
    d
  }
  list(
    record = read("record.csv"), computation = read("timing.csv"),
    computationRuns = read("timingRuns.csv"),
    drawing = read("drawingTiming.csv"),
    drawingRuns = read("drawingTimingRuns.csv")
  )
}

## ---- How a cell is written -------------------------------------------------

## Seconds to three significant figures, as the summaries print them; under a
## millisecond "<0.001".
speedSeconds <- function(s) {
  if (s < 0.001) "<0.001" else format(signif(s, 3L), big.mark = ",")
}
speedSize <- function(n) formatC(n, format = "d", big.mark = ",")
speedGib <- function(mb) sprintf("%.2f", mb / 1024.0)

## How a size failed, in a word: past 120 s "time", past 32 GB "memory", a
## crashed process "crash", the function stopping with an error "error";
## and "not timed" when the drawing built before the clock passed the 300 s
## allowed for setup, so the timed call never started (R158, dragon 33).
speedFailWord <- function(status, message) {
  if (identical(status, "error")) {
    if (grepl("no 'CALL START'", message, fixed = TRUE)) return("not timed")
    if (grepl("segfault|bus error", message)) return("crash")
  }
  status
}

## The largest size before a case's first failure and how the next failed,
## as timingHarness.R's capacityOf(), from rows with size, status, message.
speedCapacity <- function(rows) {
  o <- rows[order(rows$size), , drop = FALSE]
  fail <- which(o$status != "ok")
  if (length(fail) == 0L) {
    return(list(capacity = max(o$size), failedAt = NA_integer_,
                failure = NA_character_, message = ""))
  }
  f <- fail[1L]
  list(capacity = if (f > 1L) o$size[f - 1L] else NA_integer_,
       failedAt = o$size[f], failure = o$status[f], message = o$message[f])
}

## One case's cell at a size: its seconds, how it failed, or "" when the size
## was not run (after a failure).
speedCell <- function(rows, show) {
  if (nrow(rows) == 0L) return("")
  if (rows$status[1L] == "ok") show(rows[1L, ]) else
    speedFailWord(rows$status[1L], rows$message[1L])
}

## ---- Captions --------------------------------------------------------------

## A record's row of record.csv by its name.
speedRecord <- function(src, name) {
  r <- src$record[src$record$record == name, , drop = FALSE]
  if (nrow(r) != 1L) {
    stop("record.csv has ", nrow(r), " rows for '", name, "'", call. = FALSE)
  }
  r
}

speedMachine <- function(r, model = FALSE) {
  chip <- if (model) sprintf("%s (%s)", r$chip, r$model) else r$chip
  sprintf("%s, %d cores, %s GiB, R %s", chip, as.integer(r$cores),
          format(r$memoryGb), r$R)
}

speedCaption <- function(src, name, what) {
  r <- speedRecord(src, name)
  versions <- sprintf("kinship2 %s, Pedixplorer %s", r$kinship2,
                      r$Pedixplorer)
  if (name == "drawing") versions <- paste0(versions, ", Chrome ", r$chrome)
  sprintf("Table: %s The %s record, %s: pedkindraw `%s`, %s; %s.", what,
          name, substr(r$started, 1L, 10L), substr(r$commit, 1L, 7L),
          versions, speedMachine(r))
}

## ---- The tables ------------------------------------------------------------

## A table: its header, its rows (each a character vector, one per column),
## the alignment of each column and the caption line under it.
speedTable <- function(header, rows, align, caption) {
  list(header = header, rows = rows, align = align, caption = caption)
}

speedRecordsTable <- function(src) {
  rec <- src$record
  same <- c("chip", "cores", "memoryGb", "R", "rTree")
  for (column in same) {
    if (length(unique(rec[[column]])) != 1L) {
      stop("the records differ in '", column, "': the caption names one",
           call. = FALSE)
    }
  }
  runsOf <- list(computation = src$computationRuns,
                 drawing = src$drawingRuns)
  rows <- lapply(seq_len(nrow(rec)), function(i) {
    runs <- runsOf[[rec$record[i]]]
    if (is.null(runs)) {
      stop("no runs file for the record '", rec$record[i], "'", call. = FALSE)
    }
    c(rec$record[i], substr(rec$started[i], 1L, 16L),
      sprintf("%s (%s)", speedSize(nrow(runs)),
              speedSize(sum(runs$kind == "measured"))),
      sprintf("%.1f-%.1f", min(runs$idle), max(runs$idle)),
      sprintf("`%s`", substr(rec$commit[i], 1L, 7L)), rec$kinship2[i],
      rec$Pedixplorer[i], rec$chrome[i])
  })
  r <- rec[1L, ]
  speedTable(
    c("Record", "Started", "Runs (measured)",
      "CPU idle at each run's start (%)", "pedkindraw commit timed",
      "kinship2", "Pedixplorer", "Chrome"),
    rows, c("l", "l", "r", "r", "l", "l", "l", "l"),
    sprintf(paste0("Table: The two records, on one machine: %s. Both ",
                   "timed the same pedkindraw R code, git tree `%s`."),
            speedMachine(r, model = TRUE), substr(r$rTree, 1L, 7L))
  )
}

speedComputationSizes <- function(src) sort(unique(src$computation$size))

speedComputationRow <- function(src, case, fn) {
  rows <- src$computation[src$computation$case == case, , drop = FALSE]
  if (nrow(rows) == 0L) {
    stop("timing.csv has no rows for '", case, "'", call. = FALSE)
  }
  c(rows$computation[1L], rows$package[1L], fn)
}

speedComputationTable <- function(src, group) {
  cases <- speedComputationCases()
  cases <- cases[cases$group == group, , drop = FALSE]
  sizes <- speedComputationSizes(src)
  rows <- lapply(seq_len(nrow(cases)), function(i) {
    k <- src$computation[src$computation$case == cases$case[i], ,
                         drop = FALSE]
    cells <- vapply(sizes, function(n) {
      speedCell(k[k$size == n, , drop = FALSE],
                function(r) speedSeconds(r$seconds))
    }, "")
    c(speedComputationRow(src, cases$case[i], cases$fn[i]), cells)
  })
  speedTable(
    c("Computation", "Package", "Function", speedSize(sizes)), rows,
    c("l", "l", "l", rep("r", length(sizes))),
    speedCaption(src, "computation", paste(
      "Seconds, the median of 3 measured runs, by the number of animals."
    ))
  )
}

speedComputationCapacityTable <- function(src) {
  cases <- speedComputationCases()
  sizes <- speedComputationSizes(src)
  rows <- list()
  for (i in seq_len(nrow(cases))) {
    k <- src$computation[src$computation$case == cases$case[i], ,
                         drop = FALSE]
    cap <- speedCapacity(k)
    if (is.na(cap$failedAt)) next
    at <- k[!is.na(cap$capacity) & k$size == cap$capacity, , drop = FALSE]
    rows[[length(rows) + 1L]] <- c(
      speedComputationRow(src, cases$case[i], cases$fn[i]),
      if (is.na(cap$capacity)) paste("below", speedSize(min(sizes))) else
        speedSize(cap$capacity),
      paste(speedFailWord(cap$failure, cap$message), "at",
            speedSize(cap$failedAt)),
      if (nrow(at)) speedGib(at$maxRssMb) else "",
      if (nrow(at)) speedGib(at$heapPeakMb) else ""
    )
  }
  speedTable(
    c("Computation", "Package", "Function", "Largest size within the limits",
      "Next size", "Process peak there (GiB)", "R heap peak there (GiB)"),
    rows, c("l", "l", "l", "r", "l", "r", "r"),
    speedCaption(src, "computation", paste(
      "Where each computation stopped, and its memory at the largest size it",
      "finished."
    ))
  )
}

## The sizes of the synthetic colonies the drawing record drew.
speedDrawingSizes <- function(src) {
  sort(unique(src$drawing$size[
    startsWith(src$drawing$pedigree, "synthetic_")]))
}

## The drawing record's columns: the synthetic colonies by size, then the
## 375-animal example pedigree.
speedDrawingColumns <- function(src) {
  synthetic <- speedDrawingSizes(src)
  list(pedigree = c(sprintf("synthetic_%d", synthetic), "rhesus375"),
       head = c(speedSize(synthetic), "The 375-animal example"))
}

speedDrawingRow <- function(src, case, drawing, part = NULL) {
  rows <- src$drawing[src$drawing$case == case, , drop = FALSE]
  if (nrow(rows) == 0L) {
    stop("drawingTiming.csv has no rows for '", case, "'", call. = FALSE)
  }
  c(rows$package[1L], drawing, part)
}

speedDrawingSecondsTable <- function(src) {
  cases <- speedDrawingCases()
  columns <- speedDrawingColumns(src)
  rows <- lapply(seq_len(nrow(cases)), function(i) {
    k <- src$drawing[src$drawing$case == cases$case[i], , drop = FALSE]
    cells <- vapply(columns$pedigree, function(p) {
      speedCell(k[k$pedigree == p, , drop = FALSE],
                function(r) speedSeconds(r$totalSeconds))
    }, "")
    c(speedDrawingRow(src, cases$case[i], cases$drawing[i]), cells)
  })
  speedTable(
    c("Package", "Drawing", columns$head), rows,
    c("l", "l", rep("r", length(columns$head))),
    speedCaption(src, "drawing", paste(
      "Seconds to a drawing, the median of 3 measured runs, by the number of",
      "animals."
    ))
  )
}

speedDrawingPartsTable <- function(src) {
  cases <- speedDrawingCases()
  pages <- unique(src$drawing$case[src$drawing$form == "browser"])
  cases <- cases[cases$case %in% pages, , drop = FALSE]
  columns <- speedDrawingColumns(src)
  rows <- list()
  for (i in seq_len(nrow(cases))) {
    k <- src$drawing[src$drawing$case == cases$case[i], , drop = FALSE]
    for (part in c("in R", "in Chrome")) {
      field <- if (part == "in R") "rSeconds" else "browserSeconds"
      cells <- vapply(columns$pedigree, function(p) {
        speedCell(k[k$pedigree == p, , drop = FALSE],
                  function(r) speedSeconds(r[[field]]))
      }, "")
      rows[[length(rows) + 1L]] <- c(
        speedDrawingRow(src, cases$case[i], cases$drawing[i], part), cells
      )
    }
  }
  speedTable(
    c("Package", "Drawing", "Part", columns$head), rows,
    c("l", "l", "l", rep("r", length(columns$head))),
    speedCaption(src, "drawing", paste(
      "Seconds of each web page, in R and in Chrome, the median of 3 measured",
      "runs."
    ))
  )
}

speedDrawingCapacityTable <- function(src) {
  cases <- speedDrawingCases()
  sizes <- speedDrawingSizes(src)
  rows <- lapply(seq_len(nrow(cases)), function(i) {
    k <- src$drawing[src$drawing$case == cases$case[i] &
                       startsWith(src$drawing$pedigree, "synthetic_"), ,
                     drop = FALSE]
    cap <- speedCapacity(k)
    at <- k[!is.na(cap$capacity) & k$size == cap$capacity, , drop = FALSE]
    c(
      speedDrawingRow(src, cases$case[i], cases$drawing[i]),
      if (is.na(cap$capacity)) paste("below", speedSize(min(sizes))) else
        speedSize(cap$capacity),
      if (is.na(cap$failedAt)) {
        paste("none up to", speedSize(max(sizes)))
      } else {
        paste(speedFailWord(cap$failure, cap$message), "at",
              speedSize(cap$failedAt))
      },
      if (nrow(at)) speedGib(at$maxRssMb) else "",
      if (nrow(at)) sprintf("%.0f", at$heapPeakMb) else "",
      if (nrow(at) && !is.na(at$jsHeapMb)) sprintf("%.1f", at$jsHeapMb) else ""
    )
  })
  speedTable(
    c("Package", "Drawing", "Largest size drawn within 120 s", "Next size",
      "Process peak there (GiB)", "R heap peak there (MiB)",
      "JavaScript heap there (MiB)"),
    rows, c("l", "l", "r", "l", "r", "r", "r"),
    speedCaption(src, "drawing", paste(
      "Where each drawing stopped on the synthetic colonies, and its memory at",
      "the largest size it drew."
    ))
  )
}

## Every table the page must hold, by name.
speedTables <- function(src) {
  list(
    records = speedRecordsTable(src),
    "computation-study" = speedComputationTable(src, "study"),
    "computation-paired" = speedComputationTable(src, "paired"),
    "computation-pedkindraw" = speedComputationTable(src, "pedkindraw"),
    "computation-capacity" = speedComputationCapacityTable(src),
    "drawing-seconds" = speedDrawingSecondsTable(src),
    "drawing-parts" = speedDrawingPartsTable(src),
    "drawing-capacity" = speedDrawingCapacityTable(src)
  )
}

## ---- Markdown --------------------------------------------------------------

speedRowLine <- function(cells) {
  paste0("| ", paste(cells, collapse = " | "), " |")
}

## A table as the page's lines: the marker, a blank line, the table, a blank
## line and the caption.
speedTableLines <- function(name, table) {
  rule <- ifelse(table$align == "r", "---:", "---")
  c(sprintf("<!-- speed-table: %s -->", name), "",
    speedRowLine(table$header), paste0("|", paste(rule, collapse = "|"), "|"),
    vapply(table$rows, speedRowLine, ""), "", table$caption)
}

## The cells of one Markdown table line, trimmed.
speedCells <- function(line) {
  inner <- sub("^\\|", "", sub("\\|\\s*$", "", trimws(line)))
  trimws(strsplit(inner, "|", fixed = TRUE)[[1L]])
}

## ---- Reading the page ------------------------------------------------------

## The page's tables: for each, the marker's name (NA when no marker comes
## just before it), its first line's number, its lines and the caption line.
## A marker is "just before" when only blank lines separate them.
speedPageTables <- function(lines) {
  isRow <- startsWith(trimws(lines), "|")
  starts <- which(isRow & !c(FALSE, utils::head(isRow, -1L)))
  lapply(starts, function(s) {
    e <- s
    while (e < length(lines) && isRow[e + 1L]) e <- e + 1L
    before <- s - 1L
    while (before >= 1L && !nzchar(trimws(lines[before]))) before <- before - 1L
    marker <- if (before >= 1L) {
      regmatches(lines[before],
                 regexec("^<!-- speed-table: ([a-z-]+) -->$",
                         trimws(lines[before])))[[1L]]
    } else {
      character()
    }
    after <- e + 1L
    while (after <= length(lines) && !nzchar(trimws(lines[after]))) {
      after <- after + 1L
    }
    list(name = if (length(marker) == 2L) marker[2L] else NA_character_,
         line = s, rows = lines[s:e],
         caption = if (after <= length(lines)) lines[after] else "")
  })
}

## ---- The check -------------------------------------------------------------

## Every difference between the page's lines and the tables, as text, and
## the count of cells that are equal.
speedCompare <- function(lines, tables) {
  problems <- character()
  equal <- 0L
  found <- speedPageTables(lines)
  names(found) <- vapply(found, `[[`, "", "name")
  for (f in found) {
    if (is.na(f$name)) {
      problems <- c(problems, sprintf(
        "line %d: a table with no <!-- speed-table: <name> --> line before it",
        f$line))
    } else if (!f$name %in% names(tables)) {
      problems <- c(problems, sprintf("line %d: no table is named '%s'",
                                      f$line, f$name))
    }
  }
  markers <- grep("<!-- speed-table:", lines, fixed = TRUE)
  for (name in names(tables)) {
    page <- found[names(found) %in% name]
    if (length(page) == 0L) {
      problems <- c(problems, sprintf("no table '%s' on the page", name))
      next
    }
    if (length(page) > 1L) {
      problems <- c(problems, sprintf("the table '%s' is on the page %d times",
                                      name, length(page)))
      next
    }
    page <- page[[1L]]
    want <- speedTableLines(name, tables[[name]])
    want <- want[3L:(length(want) - 2L)]
    head <- speedCells(want[1L])
    if (length(page$rows) != length(want)) {
      problems <- c(problems, sprintf(
        "table '%s' (line %d): %d lines on the page, %d in the records",
        name, page$line, length(page$rows), length(want)))
    }
    for (j in seq_len(min(length(page$rows), length(want)))) {
      got <- speedCells(page$rows[j])
      exp <- speedCells(want[j])
      if (length(got) != length(exp)) {
        problems <- c(problems, sprintf(
          "table '%s', line %d: %d cells on the page, %d in the records",
          name, page$line + j - 1L, length(got), length(exp)))
        next
      }
      for (k in seq_along(exp)) {
        if (identical(got[k], exp[k])) {
          equal <- equal + 1L
        } else {
          problems <- c(problems, sprintf(
            paste("table '%s', line %d, column '%s': the page has '%s',",
                  "the records '%s'"),
            name, page$line + j - 1L, head[k], got[k], exp[k]))
        }
      }
    }
    if (!identical(trimws(page$caption), tables[[name]]$caption)) {
      problems <- c(problems, sprintf(
        "table '%s': the caption is\n  %s\nand the records give\n  %s",
        name, trimws(page$caption), tables[[name]]$caption))
    }
  }
  if (length(markers) > length(found)) {
    problems <- c(problems, sprintf(
      "%d <!-- speed-table --> lines but %d tables follow one",
      length(markers), sum(!is.na(names(found)))))
  }
  list(problems = problems, equal = equal)
}

## The numbers in each element of `text`: digits with commas and points
## inside them, not joined to a letter (so not `S84` or `ac123b7`).
speedNumbersIn <- function(text) {
  regmatches(text, gregexpr(
    "(?<![A-Za-z0-9_.,])[0-9](?:[0-9,.]*[0-9])?(?![A-Za-z0-9_])", text,
    perl = TRUE
  ))
}

## The numbers written in the page's prose: outside its tables, captions,
## markers, the YAML header and code spans.
speedProseNumbers <- function(lines) {
  keep <- rep(TRUE, length(lines))
  fences <- which(trimws(lines) == "---")
  if (length(fences) >= 2L && fences[1L] == 1L) keep[1L:fences[2L]] <- FALSE
  keep[startsWith(trimws(lines), "|")] <- FALSE
  keep[startsWith(trimws(lines), "Table:")] <- FALSE
  keep[startsWith(trimws(lines), "<!--")] <- FALSE
  out <- list()
  for (i in which(keep)) {
    found <- speedNumbersIn(gsub("`[^`]*`", " ", lines[i]))[[1L]]
    for (n in found) out[[length(out) + 1L]] <- list(line = i, number = n)
  }
  out
}

## Each number the tables and their captions hold.
speedTableNumbers <- function(tables) {
  text <- unlist(lapply(tables, function(t) {
    c(unlist(t$rows), t$header, t$caption)
  }))
  unique(unlist(speedNumbersIn(text)))
}

## The whole check of the page's lines against the records: the tables
## cell for cell, then every number of the prose.
speedCheck <- function(lines, src) {
  tables <- speedTables(src)
  result <- speedCompare(lines, tables)
  allowed <- c(speedTableNumbers(tables), names(speedMethodNumbers()))
  prose <- speedProseNumbers(lines)
  for (p in prose) {
    if (!p$number %in% allowed) {
      result$problems <- c(result$problems, sprintf(
        "line %d: the number %s is in no table and is not one of the method's",
        p$line, p$number))
    }
  }
  result$prose <- length(prose)
  result$tables <- length(tables)
  result
}
