## Copyright(c) 2017-2026 R. Mark Sharp
## This file is part of pedkindraw
## Copied from nprcgenekeepr tests/testthat/helper-perfCampaign.R at
## nprcgenekeepr commit baef1e12c, its lines 189-231 only:
## diagramSolverCalls() and penaltyMatrixOf(), which
## test_diagramSolverEquivalence.R uses. Changes: the two stand-ins replace
## pedkindraw's functions, not nprcgenekeepr's (.package, the source's lines
## 208 and 227). Their comment names savedSolver() and cleanroom/spec/C,
## which pedkindraw does not have: the two tests that read them stay in
## nprcgenekeepr (plan R31).

## The .solveJointQP() calls makePedigreeMatingLayout() makes for `ped`, as
## lists of their arguments, each answered by the package's own solver. The
## tests that compare positions read their inputs and results from the
## results saved in cleanroom/spec/C instead (savedSolver(), below; Mark's
## rulings C3 and C18), so these calls feed only the tests that need a
## realistic input built from the package's data.
diagramSolverCalls <- function(ped) {
  calls <- list()
  solve <- .solveJointQP
  answer <- function(provisionalPos, matingUnits, duplicates, childEdges,
                     ...) {
    calls[[length(calls) + 1L]] <<- list(provisionalPos, matingUnits,
                                         duplicates, childEdges, ...)
    solve(provisionalPos, matingUnits, duplicates, childEdges, ...)
  }
  testthat::with_mocked_bindings(
    suppressMessages(suppressWarnings(
      makePedigreeMatingLayout(ped, edgeStyle = "direct")
    )),
    .solveJointQP = answer, .package = "pedkindraw"
  )
  calls
}

## The penalty table one .solveJointQP() call multiplies by itself (pmat, one
## row per penalty term): the table it hands to .penaltyCrossprod(). args is
## forced first, so that a call building it (diagramSolverCalls()) does not
## run inside the stand-in.
penaltyMatrixOf <- function(args) {
  force(args)
  handed <- list()
  multiply <- .penaltyCrossprod
  testthat::with_mocked_bindings(
    do.call(.solveJointQP, args),
    .penaltyCrossprod = function(pmat, ...) {
      handed[[length(handed) + 1L]] <<- pmat
      multiply(pmat, ...)
    },
    .package = "pedkindraw"
  )
  stopifnot(length(handed) == 1L)
  handed[[1L]]
}
