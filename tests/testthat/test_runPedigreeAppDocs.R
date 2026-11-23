## Copyright(c) 2017-2026 R. Mark Sharp
## This file is part of pedkindraw
## pedkindraw's own tests, not copied from nprcgenekeepr (pedkindraw S77, plan
## Phase G17d, docs/planning/pedigree-app-plan.md section 14.7; ruling R152).
## The documents say that runPedigreeApp() draws a pedigree file in an app,
## with no code, and saves the drawing and the animals; and the drawing
## vignette gives pedkindraw's own drawing times (R152, backlog "The drawing
## times in the drawing vignette and the contract"; the times measured in S75,
## the plan's section 12.1). This file holds each statement's key words beside
## the call it is about, as test_savePedigreeDiagramDocs.R does (S72); its
## helpers are in helper-docs.R. The documents are read from the source tree,
## and each test skips without it.

## The text of an Rd file's \section{<title>}, up to the next \section.
.docsRdSection <- function(text, title) {
  parts <- strsplit(text, "\n(?=\\\\section\\{)", perl = TRUE)[[1L]]
  section <- parts[startsWith(parts, paste0("\\section{", title, "}"))]
  expect_length(section, 1L)
  section
}

test_that("the README says runPedigreeApp() draws a file in an app and saves
           the drawing and the animals, in the source and in the page made
           from it", {
  for (file in c("README.Rmd", "README.md")) {
    text <- .docsText(file)
    .docsSay(text, "runPedigreeApp(", file)
    .docsSay(.docsAfter(text, "runPedigreeApp(", 600L),
             c("SVG", "PDF", "PNG", "CSV", "shiny"), file)
  }
})

test_that("the pedkindraw vignette's 'Drawing a pedigree' names the app", {
  section <- .docsSection(.docsText("vignettes", "pedkindraw.Rmd"),
                          "Drawing a pedigree")
  .docsSay(section, "runPedigreeApp(", "'Drawing a pedigree'")
})

test_that("the drawing vignette's 'Clicks in a Shiny application' points to the
           app, where a click makes the focal animal", {
  section <- .docsSection(.docsText("vignettes", "drawing.Rmd"),
                          "Clicks in a Shiny application")
  .docsSay(section, "runPedigreeApp(", "'Clicks in a Shiny application'")
  .docsSay(.docsAfter(section, "runPedigreeApp(", 400L), "focal",
           "'Clicks in a Shiny application'")
})

test_that("the drawing vignette's 'How large a drawing can be' gives
           pedkindraw's own drawing times, not nprcgenekeepr's", {
  section <- .docsSection(.docsText("vignettes", "drawing.Rmd"),
                          "How large a drawing can be")
  .docsSay(section, c("pedkindraw", "1,001", "9.1 seconds", "2,000", "50.5"),
           "'How large a drawing can be'")
  expect_false(grepl("about 16 seconds", section, fixed = TRUE))
  expect_false(grepl("not within two minutes", section, fixed = TRUE))
})

test_that("the help of drawPedigreeDiagram() points to the app", {
  .docsSay(.docsText("man", "drawPedigreeDiagram.Rd"),
           "\\link{runPedigreeApp}", "man/drawPedigreeDiagram.Rd")
})

test_that("the package help's 'Getting started' names the app", {
  section <- .docsRdSection(.docsText("man", "pedkindraw-package.Rd"),
                            "Getting started")
  .docsSay(section, "runPedigreeApp", "'Getting started'")
})

test_that("the help of runPedigreeApp() says what the app saves and what the
           pictures need", {
  text <- .docsText("man", "runPedigreeApp.Rd")
  .docsSay(.docsAfter(text, "\\strong{Save}", 700L),
           c("SVG", "PDF", "PNG", "CSV", "Animals tab", "chromote", "Chrome"),
           "man/runPedigreeApp.Rd")
})

test_that("NEWS says the app saves the drawing and the animals", {
  .docsSay(.docsAfter(.docsText("NEWS.md"), "`runPedigreeApp()`'s app saves",
                      700L),
           c("SVG", "PDF", "PNG", "CSV", "Animals tab", "chromote"),
           "NEWS.md")
})
