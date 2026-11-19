## Copyright(c) 2017-2026 R. Mark Sharp
## This file is part of pedkindraw
## pedkindraw's own code, not copied from nprcgenekeepr (plan Phase G3,
## docs/planning/gaps-and-shared-code-plan.md section 5.1; rulings
## R108-R110, pedkindraw S44). makePedigreeDiagramData() and
## makePedigreeMatingLayout() call this check on their maxNameChars argument
## (DIVERGENCE.md).

#' Stop on a maxNameChars that is not one whole number of 1 or more, or Inf
#'
#' Phase G3 (R108-R110). \code{maxNameChars} is the most characters of a
#' name written under an animal's id; \code{.nameLabel()} cuts a longer one.
#' \code{Inf} writes every name whole (\code{.nameLabel()} then never cuts).
#' @param x the argument.
#' @param caller the name of the function whose argument it is, for the
#'   message.
#' @return \code{NULL}, invisibly; stops otherwise.
#' @noRd
.checkMaxNameChars <- function(x, caller) {
  ok <- is.numeric(x) && length(x) == 1L && !is.na(x) &&
    (x == Inf || (x >= 1.0 && x == trunc(x)))
  if (!ok) {
    stop(caller, "() requires 'maxNameChars' to be one whole number of 1 ",
         "or more, or Inf for no limit.", call. = FALSE)
  }
  invisible(NULL)
}
