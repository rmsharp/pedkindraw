## Copyright(c) 2017-2026 R. Mark Sharp
## This file is part of pedkindraw
## Copied from nprcgenekeepr R/kinship.R at nprcgenekeepr commit
## baef1e12c, its clean-room rewrite (plan C2). Changes: help text only;
## the function's code is unchanged. The twinRelations description no
## longer points to an nprcgenekeepr planning document (the source's lines
## 40-42); the example types its own pedigree (the values of
## nprcgenekeepr's lacy1989Ped) instead of loading nprcgenekeepr (lines
## 73-78); and one roxygen line is added before @export,
## @importClassesFrom Matrix ddiMatrix dgCMatrix (Mark's pick, S8):
## kinship() builds those two classes through asNamespace("Matrix"),
## which R CMD check does not count as a use, so Imports: Matrix alone
## would give the NOTE "Namespace in Imports field not imported from".

#' Generate a kinship matrix
#'
#' The generation number of each animal (\code{pdepth}) is calculated
#' elsewhere, for example with \code{findGeneration()}, and passed in.
#'
#' The rows (cols) of founders are just 0.5 * identity matrix, no further
#'    processing is needed for them.
#' Parents must be processed before their children, and then a child's
#'    kinship is just the average of the kinship values for his or her
#'    parents.
#'
#' @param id character vector of IDs for a set of animals.
#' @param fatherId character vector or NA for the IDs of the sires for the set
#' of animals.
#' @param motherId character vector or NA for the IDs of the dams for the set
#' of animals.
#' @param pdepth integer vector indicating the generation number for each
#' animal.
#' @param sparse logical flag. If \code{TRUE}, the result is a sparse matrix
#' of the Matrix package with the same values: a \code{ddiMatrix} when no two
#' animals have a kinship, otherwise a \code{dgCMatrix}. If \code{FALSE}, the
#' result is a base matrix.
#' @param twinRelations \code{NULL} (default, no-op) or a data.frame with
#' columns \code{id1}, \code{id2}, \code{code} declaring twin pairs (see
#' \code{\link{checkTwinRelations}}). Only \code{code == "MZ twin"} rows
#' affect the computed matrix -- \code{"DZ twin"}/\code{"UZ twin"} rows are
#' accepted but get zero special treatment, matching kinship2's own
#' \code{relation} mechanism. A declared MZ-twin pair's coefficient is
#' corrected to equal their shared self-kinship (genetic identity), and the
#' correction is propagated transitively (chained MZ declarations, e.g.
#' A-B and B-C, also correct the undeclared A-C pair) and to every relative
#' computed at a later pedigree depth through either twin -- not just the
#' declared pair's own cell. \code{twinRelations} is trusted as already
#' validated by \code{\link{checkTwinRelations}} (this function has no
#' \code{sex} parameter of its own and so cannot re-run that validator's full
#' rule set itself); only a cheap self-contained check (both ids present in
#' \code{id}) is performed here.
#' @param chrtype \code{"autosome"} (default) or \code{"x"}. When
#' \code{"autosome"}, behavior is unchanged from every prior version of this
#' function -- \code{sex} is not required and is ignored if supplied. When
#' \code{"x"}, computes X-chromosome kinship instead: a male's X comes from
#' his mother only (self-kinship 1, since he carries a single copy); a
#' female's X-linked kinship follows the same average-of-parents formula as
#' the autosomal case (self-kinship 0.5, as usual). A founder of unrecognized
#' \code{sex} gets \code{NA} only on its own diagonal cell and 0 with the other
#' founders, as in kinship2; an animal of unrecognized \code{sex} that has
#' parents in the pedigree gets \code{NA} kinship with everyone, itself
#' included. The MZ-twin correction
#' (\code{twinRelations}) applies inside this branch identically to the
#' autosomal branch. The method is that of Sinnwell, Therneau and Schaid
#' (2014), cited below.
#' @param sex \code{NULL} (default) or a character vector, the same length as
#' \code{id}, using this package's own internal sex codes (\code{sexCodes}):
#' \code{"M"}/\code{"F"}; any other value, including \code{NA}, is treated as
#' unknown). Required when \code{chrtype = "x"}; ignored (may be omitted)
#' when \code{chrtype = "autosome"}.
#'
#' @return A kinship square matrix
#'
#' @references Lange K (1997). \emph{Mathematical and Statistical Methods for
#' Genetic Analysis}. Springer, pp. 71-72: the kinship matrix.
#' @references Sinnwell JP, Therneau TM, Schaid DJ (2014). "The kinship2 R
#' Package for Pedigree Data." \emph{Human Heredity}, 78(2), 91-93, and its
#' supplementary material (Table S2): the X chromosome.
#'
#' @importClassesFrom Matrix ddiMatrix dgCMatrix
#' @export
#' @examples
#' ## Seven animals: C and D are full siblings, and so are F and G, D's
#' ## offspring
#' ped <- data.frame(
#'   id = c("A", "B", "C", "D", "E", "F", "G"),
#'   sire = c(NA, NA, "A", "A", NA, "D", "D"),
#'   dam = c(NA, NA, "B", "B", NA, "E", "E"),
#'   stringsAsFactors = FALSE
#' )
#' ped$gen <- findGeneration(ped$id, ped$sire, ped$dam)
#' kmat <- kinship(ped$id, ped$sire, ped$dam, ped$gen)
#' ped
#' ## No animal is inbred, so each has 0.5 with itself; parent and child,
#' ## and full siblings, have 0.25; grandparent and grandchild 0.125
#' kmat
# Returns the n x n matrix of kinship coefficients of the animals in id
# (a base matrix, or a Matrix ddiMatrix / dgCMatrix when sparse is TRUE),
# by the recursion over generations, on the autosomes or the X chromosome,
# with declared identical twins made identical after each round.
kinship <- function(id, fatherId, motherId, pdepth, sparse = FALSE,
                    twinRelations = NULL, chrtype = "autosome", sex = NULL) {
  if (!(isTRUE(sparse) || isFALSE(sparse))) {
    stop("sparse must be TRUE or FALSE", call. = FALSE)
  }
  n <- length(id)
  if (n == 0L) {
    stop("id must hold at least one animal", call. = FALSE)
  }
  if (is.null(pdepth) || !is.atomic(pdepth)) {
    stop("pdepth must be a vector of generation numbers", call. = FALSE)
  }
  if (length(fatherId) != n || length(motherId) != n ||
        length(pdepth) != n) {
    stop("fatherId, motherId and pdepth must each be as long as id",
         call. = FALSE)
  }
  if (anyNA(pdepth)) {
    stop("pdepth must not be missing for any animal", call. = FALSE)
  }
  if (anyDuplicated(id) > 0L) {
    stop("All id values must be unique", call. = FALSE)
  }
  chrtype <- match.arg(casefold(chrtype), c("autosome", "x"))
  onX <- chrtype == "x"
  if (onX && (is.null(sex) || length(sex) != n)) {
    stop("invalid sex vector", call. = FALSE)
  }
  groups <- list()
  if (!is.null(twinRelations)) {
    mz <- which(as.character(twinRelations$code) == "MZ twin")
    first <- match(twinRelations$id1[mz], id)
    second <- match(twinRelations$id2[mz], id)
    if (anyNA(first) || anyNA(second)) {
      stop(mzTwinIdsAbsentMessage, call. = FALSE) # nolint: object_usage_linter.
    }
    if (length(mz) > 0L) {
      # nolint next: object_usage_linter. Defined in mzTwinGroups.R.
      groups <- split(seq_len(n), mzTwinGroups(first, second, n))
      groups <- unname(groups[lengths(groups) > 1L])
    }
  }

  father <- match(fatherId, id)
  mother <- match(motherId, id)
  diagonal <- seq(1.0, by = n + 1.0, length.out = n)
  kin <- matrix(0.0, n, n)
  u <- numeric(n)
  if (onX) {
    sexText <- as.character(sex)
    # nolint start: object_usage_linter. sexCodes is in helpers/sexCodes.R.
    isMale <- !is.na(sexText) & sexText == sexCodes[["male"]]
    isFemale <- !is.na(sexText) & sexText == sexCodes[["female"]]
    # nolint end
    start <- rep(NA_real_, n)
    start[isFemale] <- 0.5
    start[isMale] <- 1.0
    kin[diagonal] <- start
  } else {
    isMale <- logical(n)
    isFemale <- !isMale
    kin[diagonal] <- 0.5
  }

  for (d in 1L:max(pdepth)) {
    for (i in which(pdepth == d)) {
      f <- father[[i]]
      g <- mother[[i]]
      if (isFemale[[i]]) {
        rowF <- if (is.na(f)) u else kin[f, ]
        rowG <- if (is.na(g)) u else kin[g, ]
        value <- (rowF + rowG) / 2.0
        kin[i, ] <- value
        kin[, i] <- value
        uF <- if (is.na(f)) 0.0 else u[[f]]
        uG <- if (is.na(g)) 0.0 else u[[g]]
        u[[i]] <- (uF + uG) / 2.0
        kinFG <- if (is.na(f) && is.na(g)) {
          0.0
        } else if (is.na(f)) {
          u[[g]]
        } else if (is.na(g)) {
          u[[f]]
        } else {
          kin[f, g]
        }
        kin[i, i] <- (1.0 + kinFG) / 2.0
      } else if (isMale[[i]]) {
        value <- if (is.na(g)) u else kin[g, ]
        kin[i, ] <- value
        kin[, i] <- value
        u[[i]] <- if (is.na(g)) 0.0 else u[[g]]
        kin[i, i] <- 1.0
      } else {
        kin[i, ] <- NA_real_
        kin[, i] <- NA_real_
        u[[i]] <- NA_real_
      }
    }
    for (members in groups) {
      for (a in members) {
        kin[a, setdiff(members, a)] <- kin[a, a]
      }
    }
  }

  dimnames(kin) <- list(id, id)
  if (isFALSE(sparse)) {
    return(kin)
  }

  matrixClass <- function(name) {
    methods::getClass(name, where = asNamespace("Matrix"))
  }
  rows <- vector("list", n)
  for (j in seq_len(n)) {
    column <- kin[, j]
    rows[[j]] <- which(is.na(column) | column != 0.0)
  }
  counts <- lengths(rows)
  rowIndex <- unlist(rows, use.names = FALSE)
  offDiagonal <- any(rowIndex != rep.int(seq_len(n), counts))
  if (!offDiagonal && !anyNA(u)) {
    return(methods::new(matrixClass("ddiMatrix"), Dim = c(n, n),
                        Dimnames = dimnames(kin), diag = "N",
                        x = as.double(kin[diagonal])))
  }
  cells <- rowIndex + rep.int(seq(0.0, by = n, length.out = n), counts)
  methods::new(matrixClass("dgCMatrix"), Dim = c(n, n),
               Dimnames = dimnames(kin),
               i = rowIndex - 1L, p = c(0L, cumsum(counts)),
               x = kin[cells], factors = list())
}
