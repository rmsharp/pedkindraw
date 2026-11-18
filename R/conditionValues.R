## Copyright(c) 2017-2026 R. Mark Sharp
## This file is part of pedkindraw
## pedkindraw's own code, not copied from nprcgenekeepr (plan Phase G1,
## docs/planning/gaps-and-shared-code-plan.md section 5.1; rulings
## R102-R104, pedkindraw S42). The copied functions that read a condition
## column call this check before their as.logical() read (DIVERGENCE.md).

#' Stop on a condition column holding numbers other than 0 and 1
#'
#' Phase G1 (R102-R104). A condition is read with \code{as.logical()}, which
#' reads every number but 0 as \code{TRUE}, so a measured trait (2.5, 0.3, 9)
#' would be drawn affected with no message. The numbers 0 and 1 are
#' kinship2's codes, which \code{asPedFrame()} writes from kinship2 and
#' Pedixplorer, and stay accepted, as do \code{NA} and \code{NaN}; text is
#' not checked (nprcgenekeepr issue #133).
#' @param x the column, or the \code{affected} argument.
#' @param what the start of the message: what holds the numbers.
#' @return \code{NULL}, invisibly; stops naming up to five of the numbers.
#' @noRd
.checkConditionNumbers <- function(x, what) {
  if (is.numeric(x)) {
    numbers <- unique(x[!is.na(x) & x != 0.0 & x != 1.0])
    if (length(numbers) > 0L) {
      shown <- toString(utils::head(numbers, 5L))
      if (length(numbers) > 5L) shown <- paste0(shown, ", ...")
      stop(what, " holds numbers other than 0 and 1 (", shown, "). ",
           "Give TRUE or FALSE (or 1 or 0) for each animal; for a measured ",
           "trait, compare it with a threshold first.", call. = FALSE)
    }
  }
  invisible(NULL)
}
