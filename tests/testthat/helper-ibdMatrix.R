## Copyright(c) 2017-2026 R. Mark Sharp
## This file is part of pedkindraw
## pedkindraw's own test helper, not copied from nprcgenekeepr (plan Phase 12,
## rulings R46-R48, pedkindraw S16). It serves test_ibdMatrix.R: the matrix
## ibdMatrix() should return, seeded random inputs, and the comparison with
## kinship2's ibdMatrix(), which runs only where kinship2 is installed (R7,
## R28).

## The dsCMatrix ibdMatrix() returns for a symmetric base matrix m whose
## dimnames are the ids in order: the upper triangle stored, zeros not stored.
ibdExpected <- function(m) {
  methods::as(Matrix::Matrix(m, sparse = TRUE, doDiag = FALSE),
              "CsparseMatrix")
}

## A base matrix with the ids as both dimnames, filled by column.
ibdBase <- function(values, ids) {
  matrix(values, nrow = length(ids), dimnames = list(ids, ids))
}

## A random ibdMatrix() input from a fixed seed: 2 to 9 ids (letters of both
## cases, small numbers or three-digit numbers), each pair kept with
## probability 0.4 (at least one), given in either order, with a value from
## 0.125 to 1, and the rows shuffled. kind "fullDiag" gives every id its
## diagonal entry (1); kind "withDiagonal" gives some ids none (at least one)
## and sets diagonal = 1.
ibdRandomCase <- function(seed, kind) {
  withr::with_seed(seed, {
    n <- sample(2:9, 1L)
    idType <- sample(c("char", "numSmall", "numLarge"), 1L)
    ids <- switch(idType,
                  char = sample(c(letters, LETTERS), n),
                  numSmall = sample(seq_len(2L * n), n),
                  numLarge = sample(100:999, n))
    pairs <- utils::combn(n, 2L)
    chosen <- stats::runif(ncol(pairs)) < 0.4
    chosen[sample(ncol(pairs), 1L)] <- TRUE
    i <- pairs[1L, chosen]
    j <- pairs[2L, chosen]
    swap <- stats::runif(length(i)) < 0.5
    a <- ifelse(swap, j, i)
    b <- ifelse(swap, i, j)
    values <- sample(c(0.125, 0.25, 0.5, 0.75, 1), length(a), replace = TRUE)
    hasDiagonal <- rep(TRUE, n)
    if (kind == "withDiagonal") {
      hasDiagonal <- stats::runif(n) < 0.5
      hasDiagonal[sample(n, 1L)] <- FALSE
    }
    d <- which(hasDiagonal)
    id1 <- c(ids[d], ids[a])
    id2 <- c(ids[d], ids[b])
    x <- c(rep(1, length(d)), values)
    rows <- sample(length(id1))
    list(id1 = id1[rows], id2 = id2[rows], x = x[rows],
         diagonal = if (kind == "withDiagonal") 1 else NULL)
  })
}

## ibdMatrix() on a random case.
ibdOnCase <- function(case) {
  if (is.null(case$diagonal)) {
    ibdMatrix(case$id1, case$id2, case$x)
  } else {
    ibdMatrix(case$id1, case$id2, case$x, diagonal = case$diagonal)
  }
}

## kinship2's ibdMatrix() on a random case as a base matrix, or NULL when
## kinship2 stops or runs past 10 seconds. It never returned on some inputs
## without a diagonal value, which these cases do not give it; the limit only
## keeps a hang from stopping the suite. Its warnings are muffled: it warns on
## character ids.
kinship2IbdOnCase <- function(case) {
  setTimeLimit(elapsed = 10, transient = TRUE)
  on.exit(setTimeLimit(elapsed = Inf), add = TRUE)
  result <- tryCatch(suppressWarnings(
    if (is.null(case$diagonal)) {
      kinship2::ibdMatrix(case$id1, case$id2, case$x)
    } else {
      kinship2::ibdMatrix(case$id1, case$id2, case$x,
                          diagonal = case$diagonal)
    }
  ), error = function(e) NULL)
  if (is.null(result)) NULL else as.matrix(result)
}
