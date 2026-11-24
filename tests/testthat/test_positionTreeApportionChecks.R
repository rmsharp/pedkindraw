## Copyright(c) 2017-2026 R. Mark Sharp
## This file is part of pedkindraw
## pedkindraw's own tests, not copied from nprcgenekeepr (plan Phase 17j,
## rulings R84 and R161, pedkindraw S87): the argument checks of
## .positionTreeApportion() and .buildForestChildrenOf() in
## R/positionTreeApportion.R, which is copied from nprcgenekeepr and stays as
## copied. The layout always passes them good arguments, so no other test
## reached the six stops (covr, S87); a direct call with a bad argument is the
## only way to them.

leaf <- function(id) character(0L)

test_that(".positionTreeApportion() stops unless 'rootId' is one string", {
  message <- paste0(".positionTreeApportion() requires 'rootId' to be a ",
                    "single, non-NA character string.")
  for (rootId in list(NA_character_, c("a", "b"), 1L, character(0L))) {
    expect_error(.positionTreeApportion(rootId, leaf), message, fixed = TRUE)
  }
})

test_that(".positionTreeApportion() stops unless 'childrenOf' and 'nodeGap'
           are functions", {
  expect_error(.positionTreeApportion("a", "leaf"),
               paste0(".positionTreeApportion() requires 'childrenOf' to be ",
                      "a function."),
               fixed = TRUE)
  expect_error(.positionTreeApportion("a", leaf, nodeGap = 1L),
               ".positionTreeApportion() requires 'nodeGap' to be a function.",
               fixed = TRUE)
  expect_identical(.positionTreeApportion("a", leaf), c(a = 0L))
})

test_that(".buildForestChildrenOf() stops unless 'rootIds' is a character
           vector with no NA", {
  message <- paste0(".buildForestChildrenOf() requires 'rootIds' to be a ",
                    "non-empty character vector with no NA.")
  for (rootIds in list(character(0L), c("a", NA), 1L)) {
    expect_error(.buildForestChildrenOf(rootIds, leaf), message, fixed = TRUE)
  }
})

test_that(".buildForestChildrenOf() stops unless 'childrenOf' is a function
           and 'superRootId' is not a root", {
  expect_error(.buildForestChildrenOf("a", "leaf"),
               paste0(".buildForestChildrenOf() requires 'childrenOf' to be ",
                      "a function."),
               fixed = TRUE)
  message <- paste0(".buildForestChildrenOf() requires 'superRootId' to not ",
                    "collide with any 'rootIds' entry.")
  expect_error(.buildForestChildrenOf(c("a", "__super_root__"), leaf), message,
               fixed = TRUE)
  expect_error(.buildForestChildrenOf(c("a", "top"), leaf, superRootId = "top"),
               message, fixed = TRUE)
  childrenOf <- .buildForestChildrenOf(c("a", "b"), leaf)
  expect_identical(childrenOf("__super_root__"), c("a", "b"))
  expect_identical(childrenOf("a"), character(0L))
})
