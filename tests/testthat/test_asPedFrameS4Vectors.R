## Copyright(c) 2017-2026 R. Mark Sharp
## This file is part of pedkindraw
## pedkindraw's own tests, not copied from nprcgenekeepr (backlog :178, ruling
## R171, pedkindraw S99): asPedFrame() converts a Pedixplorer object's twin
## and spouse rows when S4Vectors' as.data.frame() method for its class
## Vector stops on them, as S4Vectors 0.52.0 (Bioconductor 3.24) does.
## Pedixplorer's Rel, the class of rel(x), extends S4Vectors' Vector, and a
## plain as.data.frame() on it goes through that method: on S4Vectors 0.50.3
## (Bioconductor 3.23, renv.lock's) it gives the rows, on 0.52.0 it stops with
## "no method for coercing this S4 class to a vector" (measured S98, S99).
## renv.lock keeps 3.23 (Mark's pick, S99), so these tests put a stand-in for
## 0.52.0's method in place for one test and the original back after it.
## Every expected value was computed with a scratch prototype before RED
## (Learning 18). The tests skip without Pedixplorer (R7); a CRAN check leaves
## this file out (slowTestFiles.txt), since the stand-in changes a method
## another package registered.

# nolint start: object_usage_linter.
## Puts a stand-in for S4Vectors 0.52.0's as.data.frame() method for Vector in
## place until the calling test (env) ends, then the original back.
.localStoppingVectorDataFrame <- function(env = parent.frame()) {
  ns <- asNamespace("S4Vectors")
  original <- utils::getS3method("as.data.frame", "Vector")
  registerS3method("as.data.frame", "Vector", function(x, ...) {
    stop("no method for coercing this S4 class to a vector", call. = FALSE)
  }, envir = ns)
  withr::defer(
    registerS3method("as.data.frame", "Vector", original, envir = ns),
    envir = env
  )
  invisible(original)
}

## Eight animals: C and D MZ twins, E and F DZ, G and H UZ, and A and B a
## declared spouse pair, as in test_asPedFramePedixplorer.R.
.s4vEight <- function() {
  Pedixplorer::Pedigree(
    data.frame(id = c("A", "B", "C", "D", "E", "F", "G", "H"),
               dadid = c(NA, NA, "A", "A", "A", "A", "A", "A"),
               momid = c(NA, NA, "B", "B", "B", "B", "B", "B"),
               sex = c(1, 2, 1, 1, 2, 2, 1, 2)),
    rel_df = data.frame(id1 = c("C", "E", "A", "G"),
                        id2 = c("D", "F", "B", "H"), code = c(1, 2, 4, 3))
  )
}
# nolint end

test_that("the stand-in stops as S4Vectors 0.52.0 does, and is put back", {
  skip_if_not_installed("Pedixplorer")
  original <- utils::getS3method("as.data.frame", "Vector")
  withStandIn <- function() {
    .localStoppingVectorDataFrame()
    expect_error(as.data.frame(Pedixplorer::rel(.s4vEight())),
                 "no method for coercing this S4 class to a vector",
                 fixed = TRUE)
    expect_false(identical(utils::getS3method("as.data.frame", "Vector"),
                           original))
  }
  withStandIn()
  expect_identical(utils::getS3method("as.data.frame", "Vector"), original)
})

test_that("twins and a spouse pair convert when as.data.frame() stops", {
  skip_if_not_installed("Pedixplorer")
  p <- .s4vEight()
  .localStoppingVectorDataFrame()
  expect_identical(
    asPedFrame(p),
    list(ped = data.frame(id = c("A", "B", "C", "D", "E", "F", "G", "H"),
                          sire = c(NA, NA, "A", "A", "A", "A", "A", "A"),
                          dam = c(NA, NA, "B", "B", "B", "B", "B", "B"),
                          sex = c("M", "F", "M", "M", "F", "F", "M", "F"),
                          stringsAsFactors = FALSE),
         twinRelations = data.frame(id1 = c("C", "E", "G"),
                                    id2 = c("D", "F", "H"),
                                    code = c("MZ twin", "DZ twin", "UZ twin"),
                                    stringsAsFactors = FALSE),
         hints = NULL,
         matings = data.frame(sire = "A", dam = "B",
                              stringsAsFactors = FALSE))
  )
})

test_that("families' ids, joined to their famid, convert the same way", {
  skip_if_not_installed("Pedixplorer")
  d <- data.frame(id = c("A", "B", "C", "D", "A", "B", "C", "D"),
                  famid = rep(c("f1", "f2"), each = 4L),
                  dadid = c(NA, NA, "A", "A", NA, NA, "A", "A"),
                  momid = c(NA, NA, "B", "B", NA, NA, "B", "B"),
                  sex = c(1, 2, 1, 1, 1, 2, 2, 2))
  rel <- data.frame(id1 = c("C", "C", "A"), id2 = c("D", "D", "B"),
                    code = c(1, 3, 4), famid = c("f1", "f2", "f2"))
  p <- Pedixplorer::Pedigree(d, rel_df = rel)
  .localStoppingVectorDataFrame()
  result <- asPedFrame(p)
  expect_identical(result$twinRelations,
                   data.frame(id1 = c("f1_C", "f2_C"), id2 = c("f1_D", "f2_D"),
                              code = c("MZ twin", "UZ twin"),
                              stringsAsFactors = FALSE))
  expect_identical(result$matings,
                   data.frame(sire = "f2_A", dam = "f2_B",
                              stringsAsFactors = FALSE))
})

test_that("an object with no twin or spouse row converts with neither", {
  skip_if_not_installed("Pedixplorer")
  p <- Pedixplorer::Pedigree(
    data.frame(id = c("A", "B", "C"), dadid = c(NA, NA, "A"),
               momid = c(NA, NA, "B"), sex = c(1, 2, 1))
  )
  .localStoppingVectorDataFrame()
  result <- asPedFrame(p)
  expect_null(result$twinRelations)
  expect_null(result$matings)
  expect_identical(result$ped$id, c("A", "B", "C"))
})
