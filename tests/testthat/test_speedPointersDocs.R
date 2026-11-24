## Copyright(c) 2017-2026 R. Mark Sharp
## This file is part of pedkindraw
## pedkindraw's own tests, not copied from nprcgenekeepr (pedkindraw S86, plan
## Phase 17i2, docs/planning/pedkindraw-timing-plan.md sections 4.3, 4.4 and
## 7, T5; R159). The other documents point to the speed vignette: the package
## help's "Getting started", the pedkindraw vignette's "Where next", the
## drawing vignette's "How large a drawing can be" and "Where next", and NEWS;
## and drawPedigreeDiagram()'s help states the measured size of a drawing
## (T5), so the API contract's section 8 holds. The help's numbers are read
## from the speed vignette's tables, which tools/checkSpeedTables.R holds to
## the timing records, so a new record that changes them fails here until the
## help says the same.
##
## The documents are read from the source tree with helper-docs.R's helpers,
## and each test skips without it.

.speedCall <- "vignette(\"speed\", package = \"pedkindraw\")"

## A text with each run of spaces and line breaks made one space, so that a
## phrase is found wherever the source wraps it.
.flat <- function(text) gsub("\\s+", " ", text)

## The text of an Rd file's \section{<title>}, up to the next \section.
.rdSection <- function(text, title) {
  parts <- strsplit(text, "\n(?=\\\\section\\{)", perl = TRUE)[[1L]]
  section <- parts[startsWith(parts, paste0("\\section{", title, "}"))]
  expect_length(section, 1L)
  section
}

## A table of the speed vignette, the one after its
## "<!-- speed-table: <name> -->" marker, as a data frame of its cells, named
## by its header.
.speedTable <- function(name) {
  lines <- strsplit(.docsText("vignettes", "speed.Rmd"), "\n",
                    fixed = TRUE)[[1L]]
  at <- which(lines == paste0("<!-- speed-table: ", name, " -->"))
  expect_length(at, 1L)
  rest <- lines[-seq_len(at[1L])]
  rest <- rest[cumsum(startsWith(rest, "|")) > 0L]
  rest <- rest[seq_len(match(FALSE, startsWith(rest, "|"),
                             nomatch = length(rest) + 1L) - 1L)]
  cells <- lapply(rest, function(line) {
    trimws(strsplit(line, "|", fixed = TRUE)[[1L]])[-1L]
  })
  table <- as.data.frame(do.call(rbind, cells[-(1:2)]),
                         stringsAsFactors = FALSE)
  names(table) <- cells[[1L]]
  table
}

## The row of pedkindraw's drawing `drawing` in a speed vignette table.
.speedRow <- function(table, drawing) {
  row <- table[table$Package == "pedkindraw" & table$Drawing == drawing, ]
  expect_equal(nrow(row), 1L)
  row
}

test_that("the package help's 'Getting started' names the speed vignette and
           what it gives", {
  section <- .flat(.rdSection(.docsText("man", "pedkindraw-package.Rd"),
                              "Getting started"))
  .docsSay(section, paste0("\\code{", .speedCall, "}"), "'Getting started'")
  .docsSay(.docsAfter(section, .speedCall, 300L),
           c("seconds", "100,000", "kinship2", "Pedixplorer", "drawing"),
           "'Getting started'")
})

test_that("the pedkindraw vignette's 'Where next' names the speed vignette and
           what it gives", {
  section <- .flat(.docsSection(.docsText("vignettes", "pedkindraw.Rmd"),
                                "Where next"))
  .docsSay(section, .speedCall, "the pedkindraw vignette's 'Where next'")
  .docsSay(.docsAfter(section, .speedCall, 300L),
           c("seconds", "100,000", "kinship2", "Pedixplorer", "drawing"),
           "the pedkindraw vignette's 'Where next'")
})

test_that("the drawing vignette's 'How large a drawing can be' keeps S75's
           times and points to the speed vignette's colonies, with pedkindraw's
           own judgment of how large a drawing can be read", {
  section <- .flat(.docsSection(.docsText("vignettes", "drawing.Rmd"),
                                "How large a drawing can be"))
  .docsSay(section, c("9.1 seconds", "50.5 seconds", .speedCall),
           "'How large a drawing can be'")
  .docsSay(.docsAfter(section, .speedCall, 500L),
           c("synthetic colonies", "3,000", "kinship2", "Pedixplorer",
             "memory", "pedkindraw's own", "1,000 animals, zoomed in"),
           "'How large a drawing can be'")
})

test_that("the drawing vignette's 'Where next' names the speed vignette", {
  section <- .flat(.docsSection(.docsText("vignettes", "drawing.Rmd"),
                                "Where next"))
  .docsSay(section, .speedCall, "the drawing vignette's 'Where next'")
})

test_that("the help of drawPedigreeDiagram() states the measured size of a
           drawing, as the speed vignette's tables give it, and names the
           vignette (T5)", {
  section <- .flat(.rdSection(.docsText("man", "drawPedigreeDiagram.Rd"),
                              "How large a drawing can be"))
  seconds <- .speedTable("drawing-seconds")
  page <- .speedRow(seconds, "web page, `drawPedigreeDiagram()`")
  direct <- .speedRow(seconds,
                      "web page, `drawPedigreeDiagram()`, direct lines")
  largest <- .speedRow(.speedTable("drawing-capacity"),
                       "web page, `drawPedigreeDiagram()`")
  ## The help's "more than 120 seconds" is the page's "time" at 2,000.
  expect_identical(page[["2,000"]], "time")
  expect_identical(largest[["Next size"]], "time at 2,000")
  .docsSay(section,
           c("Apple M2 Max", "November 2026", "synthetic colony",
             paste(largest[["Largest size drawn within 120 s"]], "animals"),
             paste(page[["1,000"]], "seconds"),
             "2,000 animals more than 120 seconds",
             paste(direct[["2,000"]], "seconds"),
             "almost all of it in R", "zoomed in",
             paste0("\\code{", .speedCall, "}")),
           "man/drawPedigreeDiagram.Rd")
})

test_that("NEWS's speed vignette bullet says drawPedigreeDiagram()'s help gives
           the measured size", {
  news <- .flat(.docsText("NEWS.md"))
  .docsSay(.docsAfter(news, paste0("New: `", .speedCall, "`"), 900L),
           "`drawPedigreeDiagram()`'s help", "NEWS.md")
})
