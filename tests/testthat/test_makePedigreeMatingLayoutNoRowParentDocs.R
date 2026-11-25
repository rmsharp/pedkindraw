## Copyright(c) 2017-2026 R. Mark Sharp
## This file is part of pedkindraw
## pedkindraw's own tests, not copied from nprcgenekeepr (rulings R162 and
## R163, pedkindraw S89): ?makePedigreeMatingLayout's 'ped' argument and NEWS
## say what the layout does with a sire or dam that has no row of its own and
## with a repeated id (test_makePedigreeMatingLayoutNoRowParent.R holds the
## behaviour). The documents are read from the source tree, and each test skips
## without them (helper-docs.R).

test_that("?makePedigreeMatingLayout's 'ped' says a parent with no row is not
           drawn, how its offspring are drawn, addParents(), and that a
           repeated id stops", {
  rd <- .docsFlat(.docsText("man", "makePedigreeMatingLayout.Rd"))
  ped <- .docsAfter(rd, "\\item{ped}{", 1200L)
  .docsSay(ped, c(
    "an id on more than one row stops, naming it",
    "with no row of its own is not drawn",
    "drawn as a founder is, with no line up",
    "two such siblings stand side by side, not joined",
    "\\code{\\link{addParents}} adds a row for each"
  ), "?makePedigreeMatingLayout's 'ped'")
})

test_that("NEWS says the layout draws a pedigree with a parent that has no row,
           and stops on a repeated id", {
  news <- .docsFlat(.docsText("NEWS.md"))
  anchor <- "* New: `makePedigreeMatingLayout()` draws a pedigree with a sire"
  item <- .docsAfter(news, anchor, 500L)
  .docsSay(item, c(
    "has no row of its own, without that parent",
    "drawn with no line up",
    "as nprcgenekeepr's still does",
    "`addParents()` adds the missing rows",
    "stops on an id on more than one row, naming it"
  ), "NEWS")
})
