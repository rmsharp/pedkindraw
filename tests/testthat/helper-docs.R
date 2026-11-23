## Copyright(c) 2017-2026 R. Mark Sharp
## This file is part of pedkindraw
## Helpers for the tests that hold the documents' statements beside their
## calls (pedkindraw's own, not copied from nprcgenekeepr): written in S72
## (plan Phase G16c, docs/planning/picture-files-plan.md section 7, G16c) in
## test_savePedigreeDiagramDocs.R, and copied here word for word in S77 (plan
## Phase G17d, R152, docs/planning/pedigree-app-plan.md section 14.7) so that
## test_runPedigreeAppDocs.R can use them too. The documents are read from the
## source tree (README.Rmd, README.md, vignettes/, man/ and NEWS.md do not exist
## under an installed package), and a test skips without them.

.docsText <- function(...) {
  file <- test_path("..", "..", ...)
  if (!file.exists(file)) skip(paste0(file.path(...), " is not in this tree"))
  paste(readLines(file, warn = FALSE, encoding = "UTF-8"), collapse = "\n")
}

## The part of an R Markdown file from its "## <heading>" line to the next
## second-level heading.
.docsSection <- function(text, heading) {
  parts <- strsplit(text, "\n(?=## )", perl = TRUE)[[1L]]
  section <- parts[startsWith(parts, paste0("## ", heading))]
  expect_length(section, 1L)
  section
}

## The text from the first mention of `anchor` on, `width` characters: the
## words a statement needs are looked for beside the call it is about, since a
## README's badge ("badge.svg") or picture ("README-pedigree.png") and a
## vignette's other numbers hold some of them already.
.docsAfter <- function(text, anchor, width = 900L) {
  start <- regexpr(anchor, text, fixed = TRUE)
  if (start < 0L) return("")
  substr(text, start, start + width - 1L)
}

.docsSay <- function(text, words, where) {
  for (word in words) {
    expect_true(grepl(word, text, fixed = TRUE),
                label = paste0(where, " says '", word, "'"))
  }
}
