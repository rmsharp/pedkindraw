## Copyright(c) 2017-2026 R. Mark Sharp
## This file is part of pedkindraw
## Copied from nprcgenekeepr R/mzTwinGroups.R at nprcgenekeepr commit
## baef1e12c, part of its clean-room rewrite (plan C2). Changes: none below
## this header. The comment below names nprcgenekeepr's
## twinRelationsForSet() (R/kinshipForAnimals.R), which pedkindraw does not
## have; @noRd keeps it out of the help.

# The message kinship() stops with when an MZ twin id is not in id.
mzTwinIdsAbsentMessage <-
  # nolint next: nonportable_path_linter. A message, not a path.
  "All twinRelations id1/id2 values must be present in id."

#' Group chained MZ twin declarations
#'
#' Groups the animals of chained MZ twin declarations: A-B and B-C make A, B
#' and C one group. \code{kinship()} corrects each group's
#' kinship (R/kinship.R), and \code{twinRelationsForSet()} declares the
#' members of each group that a trimmed pedigree holds (R/kinshipForAnimals.R).
#'
#' @param first,second integer vectors of one length: the positions, from 1 to
#'   \code{n}, of the two animals of each declared pair.
#' @param n the number of positions.
#' @return An integer vector of length \code{n}: each position's group, named
#'   by the smallest position in it.
#' @noRd
# Returns an integer vector of length n: for each position, the smallest
# position of the group that chains of (first, second) pairs join it to.
mzTwinGroups <- function(first, second, n) {
  parent <- seq_len(n)
  findRoot <- function(p) {
    while (parent[[p]] != p) {
      p <- parent[[p]]
    }
    p
  }
  for (k in seq_along(first)) {
    a <- findRoot(as.integer(first[[k]]))
    b <- findRoot(as.integer(second[[k]]))
    if (a != b) {
      parent[[max(a, b)]] <- min(a, b)
    }
  }
  # Every parent is at or below its position, so one pass upward resolves.
  for (p in seq_len(n)) {
    parent[[p]] <- parent[[parent[[p]]]]
  }
  parent
}
