## Copyright(c) 2017-2026 R. Mark Sharp
## This file is part of pedkindraw
## pedkindraw's own code, not copied from nprcgenekeepr (plan Phase G4,
## docs/planning/gaps-and-shared-code-plan.md section 5.1; rulings
## R111-R113, pedkindraw S45). makePedigreeDiagramData() and
## makePedigreeMatingLayout() call this check on their conditionColors
## argument (DIVERGENCE.md).

#' Check the colours of the affected conditions; return them as "#RRGGBB"
#'
#' Phase G4 (R111-R113). Each colour is a name R knows or a code, returned as
#' its "#RRGGBB" code: measured in headless Chrome (S45), a browser reads 516
#' of R's 657 colour names as no colour and five (gray, grey, green, maroon,
#' purple) as other colours. A number stops, since it picks from R's palette,
#' which can be changed; so do a transparent colour, white and
#' \code{.unknownColor} (they mark an unaffected animal and an unknown
#' status), a colour given twice, and fewer colours than \code{drawn}.
#' @param x the argument.
#' @param caller the name of the function whose argument it is, for the
#'   message.
#' @param drawn the condition columns the caller draws, one colour needed for
#'   each.
#' @return the colours, as "#RRGGBB" codes; stops otherwise.
#' @noRd
.checkConditionColors <- function(x, caller, drawn = character()) {
  most <- length(.conditionColors)
  fail <- function(...) {
    stop(caller, "() requires 'conditionColors' ", ..., call. = FALSE)
  }
  if (!is.character(x) || length(x) < 1L || length(x) > most || anyNA(x)) {
    fail("to be 1 to ", most, " colours, each a name R knows, such as ",
         "\"orange\", or a code such as \"#E69F00\".")
  }
  quoted <- function(v) toString(dQuote(v, q = FALSE))
  numbers <- x[grepl("^[0-9]+$", x)]
  if (length(numbers) > 0L) {
    fail("to name each colour, not give a number: ", quoted(numbers),
         " (a number picks from R's palette, which can be changed).")
  }
  rgba <- lapply(x, function(colour) {
    tryCatch(grDevices::col2rgb(colour, alpha = TRUE),
             error = function(e) NULL)
  })
  unknown <- x[vapply(rgba, is.null, logical(1L))]
  if (length(unknown) > 0L) {
    fail("to be colours R knows. Not known: ", quoted(unknown), ".")
  }
  rgba <- do.call(cbind, rgba)
  seeThrough <- x[rgba[4L, ] < 255L]
  if (length(seeThrough) > 0L) {
    fail("to be opaque colours. Transparent: ", quoted(seeThrough), ".")
  }
  hex <- grDevices::rgb(rgba[1L, ], rgba[2L, ], rgba[3L, ],
                        maxColorValue = 255L)
  reserved <- x[hex %in% c("#FFFFFF", .unknownColor)]
  if (length(reserved) > 0L) {
    fail("to differ from white, which marks an unaffected animal, and from ",
         "grey ", .unknownColor, ", which marks an unknown status: ",
         quoted(reserved), ".")
  }
  if (anyDuplicated(hex) > 0L) {
    fail("to give each condition its own colour: ",
         quoted(x[hex %in% hex[duplicated(hex)]]), " are the same.")
  }
  if (length(x) < length(drawn)) {
    fail("to give a colour for each condition drawn: ", length(x),
         if (length(x) == 1L) " colour" else " colours", " for the ",
         length(drawn), " conditions ", quoted(drawn), ".")
  }
  hex
}
