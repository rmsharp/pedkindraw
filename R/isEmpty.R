## Copyright(c) 2017-2026 R. Mark Sharp
## This file is part of pedkindraw
## Copied from nprcgenekeepr R/isEmpty.R at nprcgenekeepr commit baef1e12c.
## Changes: none below this header.

#' Check whether a vector is empty or all NA
#'
#' @param x vector of any type.
#' @return \code{TRUE} if x is a zero-length vector else \code{FALSE}.
#'
#' @noRd
isEmpty <- function(x) {
  x <- x[!is.na(x)]
  length(x) == 0L
}
