## Copyright(c) 2017-2026 R. Mark Sharp
## This file is part of pedkindraw
## Copied from nprcgenekeepr tests/testthat/test_diagramSolverEquivalence.R at
## nprcgenekeepr commit baef1e12c. Changes: each read of a rhesus file through
## system.file(..., package = "nprcgenekeepr") reads test_path("fixtures", ...)
## instead (1; the source's lines 86-87). The 2 tests that read nprcgenekeepr's
## saved clean-room results, cleanroom/spec/C (the source's lines 137-142 and
## 144-153), stay in nprcgenekeepr (plan R31). diagramSolverCalls() and
## penaltyMatrixOf() are in helper-diagramSolver.R. The comments below name
## nprcgenekeepr's documents, sessions and files.

## BACKLOG.md "Performance and memory campaign: Phase 7, the diagram's solver"
## (owner pick S1060; plan docs/planning/performance-memory-campaign-plan.md,
## Phase 7 and section 5.1). .solveJointQP() handed quadprog::solve.QP() one
## dense column per separation constraint, n entries long with two of them
## nonzero, so the solver's sums ran over every node for every constraint:
## 11.3 s of the 13.2 s the example's diagram took (S1060; 708 animals, one
## solve over 1,489 nodes). It now hands quadprog::solve.QP.compact() each
## constraint's two entries, listed in the order of their rows. The two
## routines differ only in those sums, and the dense one adds a column's
## nonzero entries in row order, so the compact one adds the same numbers in
## the same order: 3.0 s with identical positions (a prototype, S1060).
##
## The owner's rulings: every result stays exactly today's (D1), and an input
## the new code was not built for runs today's code unchanged (owner ruling
## S1059, as in Phases 1-6). Here that is a quadratic or a floor with a
## missing or infinite number: today's solve.QP() stops on it with an error
## that names the argument by its position ("arg 1", "arg 9"), and the compact
## routine numbers its arguments differently. The owner also kept today's
## t(pmat) %*% pmat (S1060): crossprod() was slower on this Mac and would run
## a different BLAS routine on CI's Ubuntu runners. So each block compared the
## new code with the frozen copy (helper-perfReference.R) using identical().
##
## The clean-room rewrite (docs/planning/cleanroom-rewrite-plan.md Phase 14)
## replaced .solveJointQP() with code written from a specification, and the
## frozen copy goes. Mark's ruling C3: the positions are compared with today's
## results saved as data instead (cleanroom/spec/C, the grid's 17 solves),
## and C18: within 1e-4 raw units, with id and gen identical. cleanroom/ is
## not in the built package, so those blocks skip without it. C20: inputs the
## diagram never makes (spec D leaves them out) are no longer compared. The
## grid below is still built from the package's data, with the package's own
## solver, so that the blocks on the solver route and the penalty product run
## on CI too.

## A seeded pedigree of n animals in birth order for the diagram: a fifth are
## founders, each later animal draws a sire from the males and a dam from the
## females before it, so parents mate more than once and the layout makes
## duplicate nodes; one parent in ten is left unknown and one animal in twenty
## has an unknown sex. The random-number kinds are pinned: set_seed() leaves
## sample.kind = "Rounding" behind for the rest of a test run
## (test_obfuscatePed.R), and with_seed() alone keeps the session's kind, so
## the pedigrees would depend on which test files ran first (S1060).
seededDiagramPed <- function(n, seed) {
  withr::with_seed(seed, .rng_kind = "Mersenne-Twister",
                   .rng_normal_kind = "Inversion",
                   .rng_sample_kind = "Rejection", code = {
    founders <- max(2L, n %/% 5L)
    id <- sprintf("A%03d", seq_len(n))
    sex <- rep(c("M", "F"), length.out = n)
    sex[sample.int(n, max(1L, n %/% 20L))] <- "U"
    sex[1L:2L] <- c("M", "F")
    sire <- rep(NA_character_, n)
    dam <- rep(NA_character_, n)
    for (i in seq.int(founders + 1L, n)) {
      males <- which(sex[seq_len(i - 1L)] == "M")
      females <- which(sex[seq_len(i - 1L)] == "F")
      if (stats::runif(1L) >= 0.1) {
        sire[i] <- id[males[sample.int(length(males), 1L)]]
      }
      if (stats::runif(1L) >= 0.1) {
        dam[i] <- id[females[sample.int(length(females), 1L)]]
      }
    }
    ped <- data.frame(id = id, sire = sire, dam = dam, sex = sex,
                      stringsAsFactors = FALSE)
    ped$gen <- findGeneration(ped$id, ped$sire, ped$dam)
    ped
  })
}

## The pedigrees of the grid: the shipped ones (lacy1989Ped has no sex column,
## so its sires are given "M", its dams "F" and the rest "U"), the bundled
## 375-animal rhesus fixture the diagram tests pin, the issue #154 orphan unit,
## and seeded pedigrees.
diagramGridPeds <- function() {
  lacy <- lacy1989Ped
  lacy$sex <- ifelse(lacy$id %in% lacy$sire, "M",
                     ifelse(lacy$id %in% lacy$dam, "F", "U"))
  peds <- list(
    `lacy1989Ped, sexes added` = lacy,
    qcPed = qcPed,
    pedWithGenotype = pedWithGenotype,
    `the rhesus fixture` = read.csv(
      test_path("fixtures", "obfuscated_rhesus_mhc_ped.csv"),
      stringsAsFactors = FALSE
    ),
    `an orphan mating unit` = data.frame(
      id = "CHILD", sire = "DANGLING_SIRE", dam = "DANGLING_DAM", sex = "F",
      gen = 0L, stringsAsFactors = FALSE
    )
  )
  for (seed in c(1L, 7L, 2026L)) {
    peds[[sprintf("seeded, 40 animals, seed %d", seed)]] <-
      seededDiagramPed(40L, seed)
  }
  peds[["seeded, 12 animals, seed 1"]] <- seededDiagramPed(12L, 1L)
  peds[["seeded, 150 animals, seed 7"]] <- seededDiagramPed(150L, 7L)
  peds
}

## Every .solveJointQP() call the grid's diagrams make (17, from 2 to 733
## nodes, S1060), each answered by the package's own solver. Built once.
diagramSolverGrid <- local({
  peds <- diagramGridPeds()
  grid <- list()
  for (name in names(peds)) {
    calls <- diagramSolverCalls(peds[[name]])
    for (i in seq_along(calls)) {
      grid[[sprintf("%s, call %d", name, i)]] <- calls[[i]]
    }
  }
  grid
})

## Which of quadprog's two solvers .solveJointQP() reached for `args`: each is
## replaced by a stub that records its name and stops. Warnings are muted
## here; the position tests check that there are none.
solversReached <- function(args) {
  reached <- character(0L)
  stopAt <- function(name) {
    function(...) {
      reached <<- c(reached, name)
      stop("stopped at the solver")
    }
  }
  testthat::with_mocked_bindings(
    try(suppressWarnings(do.call(.solveJointQP, args)), silent = TRUE),
    solve.QP = stopAt("dense"), solve.QP.compact = stopAt("compact"),
    .package = "quadprog"
  )
  reached
}

test_that("on the grid .solveJointQP() solves once, with the compact solver", {
  for (name in names(diagramSolverGrid)) {
    expect_identical(solversReached(diagramSolverGrid[[name]]), "compact",
                     info = name)
  }
})

## BACKLOG.md "Pedigree Diagram: about 1.7 s of the 708-animal layout is
## outside its solver" (owner pick S1073). Before the solve, .solveJointQP()
## multiplies its penalty table by itself, t(pmat) %*% pmat: 1,480 rows by
## 1,489 columns on the example, 1.07 s of its 4.6 s with R's own math
## library, though each row holds only 2 or 3 numbers. The product is now
## worked out block by block (.penaltyCrossprod()): each pair of 32-column
## blocks is multiplied over only the rows with a number in both, in row
## order. Every term it leaves out is an exact zero and the library adds the
## rest in the same order, so with R's own library the result is today's to
## the last bit (0.04 s on the example; a prototype matched 18 of 18 grid
## solves, S1073). A library that adds a long product in chunks (OpenBLAS, on
## CI's Ubuntu runs) can round the block sums differently, so the owner ruled
## "only where exact" (S1073): a check made once a session
## (.blockProductIsExact()) multiplies a probe table whole and by blocks, and
## wherever the two differ the table is multiplied whole, as today.

## The penalty table of every grid solve, as the solver hands it to
## .penaltyCrossprod().
gridPenaltyMatrices <- lapply(diagramSolverGrid, penaltyMatrixOf)

## A stand-in for a math library that adds a long product in chunks of
## `chunk` rows, as OpenBLAS does: each chunk's sums are worked out on their
## own and then added together.
chunkedProduct <- function(chunk) {
  force(chunk)
  function(x, y) {
    out <- matrix(0.0, nrow(x), ncol(y))
    for (start in seq(1L, ncol(x), by = chunk)) {
      rows <- start:min(ncol(x), start + chunk - 1L)
      out <- out + x[, rows, drop = FALSE] %*% y[rows, , drop = FALSE]
    }
    out
  }
}

## Forget the check's answer, so the next check is made afresh.
forgetBlockCheck <- function() {
  rm(list = ls(.blockProductCache), envir = .blockProductCache)
}

## Forget the check's answer now and again when the calling test ends, so a
## stand-in library's answer never reaches another test.
localFreshBlockCheck <- function(env = parent.frame()) {
  forgetBlockCheck()
  withr::defer(forgetBlockCheck(), envir = env)
}

## The column counts of the tables .penaltyCrossprod() multiplies by blocks
## while `code` runs.
blockProducts <- function(code) {
  counts <- integer(0L)
  real <- .blockCrossprod
  testthat::with_mocked_bindings(
    code,
    .blockCrossprod = function(pmat, ...) {
      counts <<- c(counts, ncol(pmat))
      real(pmat, ...)
    }
  )
  counts
}

test_that("the penalty product is today's whole multiplication on the grid", {
  for (name in names(gridPenaltyMatrices)) {
    pmat <- gridPenaltyMatrices[[name]]
    expect_identical(.penaltyCrossprod(pmat), t(pmat) %*% pmat, info = name)
  }
})

test_that("where the check passes, a table over 32 columns is built by blocks", {
  skip_if_not(.blockProductIsExact(),
              "this R's math library adds a long product in another order")
  widths <- vapply(gridPenaltyMatrices, ncol, integer(1L))
  wide <- names(gridPenaltyMatrices)[widths > 32L]
  expect_length(wide, 7L)
  for (name in wide) {
    pmat <- gridPenaltyMatrices[[name]]
    expect_identical(blockProducts(.penaltyCrossprod(pmat)), ncol(pmat),
                     info = name)
  }
  pmat <- gridPenaltyMatrices[["seeded, 40 animals, seed 7, call 1"]]
  pmat <- pmat[, 1L:33L]
  expect_identical(blockProducts(.penaltyCrossprod(pmat)), 33L)
  expect_identical(.penaltyCrossprod(pmat), t(pmat) %*% pmat)
})

test_that(".solveJointQP() hands its penalty table over once per solve", {
  for (name in names(diagramSolverGrid)) {
    handed <- list()
    real <- .penaltyCrossprod
    with_mocked_bindings(
      do.call(.solveJointQP, diagramSolverGrid[[name]]),
      .penaltyCrossprod = function(pmat, ...) {
        handed[[length(handed) + 1L]] <<- pmat
        real(pmat, ...)
      }
    )
    expect_identical(handed, list(gridPenaltyMatrices[[name]]), info = name)
  }
})

test_that("the check refuses a math library that adds in chunks", {
  localFreshBlockCheck()
  local_mocked_bindings(.matrixProduct = chunkedProduct(256L))
  expect_false(.blockProductIsExact())
})

test_that("chunks longer than the probe table change nothing the check sees", {
  localFreshBlockCheck()
  own <- .blockProductIsExact()
  forgetBlockCheck()
  local_mocked_bindings(.matrixProduct = chunkedProduct(100000L))
  expect_identical(.blockProductIsExact(), own)
})

test_that("where the check fails, the penalty table is multiplied whole", {
  localFreshBlockCheck()
  chunked <- chunkedProduct(256L)
  local_mocked_bindings(.matrixProduct = chunked)
  pmat <- gridPenaltyMatrices[["the rhesus fixture, call 5"]]
  ## The check first: it multiplies its own probe table by blocks, which
  ## blockProducts() would count.
  expect_false(.blockProductIsExact())
  expect_identical(blockProducts(.penaltyCrossprod(pmat)), integer(0L))
  expect_identical(.penaltyCrossprod(pmat), chunked(t(pmat), pmat))
})

test_that("a missing or infinite number, or 32 columns or fewer, is multiplied whole", {
  wide <- gridPenaltyMatrices[["seeded, 40 animals, seed 7, call 1"]]
  cases <- list(
    `a missing number` = replace(wide, 5L, NA),
    `a NaN` = replace(wide, 5L, NaN),
    `an infinite number` = replace(wide, 5L, Inf),
    `a negative infinite number` = replace(wide, 5L, -Inf),
    `32 columns` = wide[, 1L:32L],
    `22 columns` = gridPenaltyMatrices[["seeded, 12 animals, seed 1, call 1"]],
    `one column` = wide[, 1L, drop = FALSE]
  )
  for (name in names(cases)) {
    pmat <- cases[[name]]
    expect_identical(blockProducts(.penaltyCrossprod(pmat)), integer(0L),
                     info = name)
    expect_identical(.penaltyCrossprod(pmat), t(pmat) %*% pmat, info = name)
  }
})

test_that("the check is made once a session and draws no random numbers", {
  localFreshBlockCheck()
  products <- 0L
  local_mocked_bindings(.matrixProduct = function(x, y) {
    products <<- products + 1L
    x %*% y
  })
  withr::local_seed(11L)
  before <- .Random.seed
  first <- .blockProductIsExact()
  made <- products
  expect_gt(made, 0L)
  expect_identical(.blockProductIsExact(), first)
  expect_identical(products, made)
  expect_identical(.Random.seed, before)
  withr::local_options(matprod = "internal")
  .blockProductIsExact()
  expect_gt(products, made)
})

test_that("with R's own math library the check passes", {
  skip_if_not(grepl("Rblas", extSoftVersion()[["BLAS"]], fixed = TRUE),
              "this R does not use its own math library (Rblas)")
  localFreshBlockCheck()
  expect_true(.blockProductIsExact())
})
