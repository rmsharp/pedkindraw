## Copyright(c) 2017-2026 R. Mark Sharp
## This file is part of pedkindraw
## pedkindraw's own code, not copied from nprcgenekeepr (pedkindraw S74, plan
## Phase G17a, gap A3 of docs/research/pedkindraw-gaps-2026-11-18.md; rulings
## R148 and R149, docs/planning/pedigree-app-plan.md sections 5, 7 and 11;
## its help on choosing the animals pedkindraw S75, G17b, R150, section 12;
## on what is drawn pedkindraw S76, G17c, R151, section 13; on saving
## pedkindraw S77, G17d, R152, section 14).

#' Draw a pedigree in an app, from a file, with no code
#'
#' Starts a small app in the web browser that opens a pedigree file and draws
#' it with \code{\link{drawPedigreeDiagram}}, for someone who keeps a pedigree
#' in a spreadsheet and does not write R. The call waits until the app is
#' closed (press Escape or Ctrl-C in R, or stop the R session).
#'
#' In the app:
#' \itemize{
#'   \item \strong{Open} a CSV or text file with one row per animal, or the
#'     sample pedigree (375 rhesus macaques, with its file of 3 twin pairs),
#'     or the \code{ped} given here; and, if you have one, a twins file
#'     with the columns id1, id2 and code, one pair per row.
#'   \item \strong{Say which columns} are the animal's id, its sire, its dam
#'     and its sex. The app recognizes pedkindraw's names and common others
#'     (ego, egoid, indid; father, fatherid, dadid; mother, motherid, momid;
#'     gender), whatever their case and with or without spaces, dots or
#'     underscores; the user can change each. Sex values m, f, h and u in any
#'     case, male, female, hermaphrodite and unknown, and 1 and 2 (male and
#'     female, as kinship2 and PLINK files code them) are read as M, F, H and
#'     U, and the app says so; any other value is drawn as unknown.
#'   \item \strong{Choose what is drawn}: up to four conditions, from a list
#'     of the file's columns that starts with those whose names begin with
#'     "affected" in any case, each drawn in its own color and labeled
#'     "Affected (its name)"; a column of numbers is drawn once it has a
#'     cut-off (a comparison and a number, such as \code{>= 126}), which the
#'     legend states. The marks \code{\link{makePedigreeMatingLayout}} draws
#'     are found by their names in any case: genotyped (or avail), carrier,
#'     proband, consultand, evaluated, fertility, miscarriage, status (or
#'     deceased) and name, and the app lists those it found. A condition or a
#'     yes-or-no mark reads TRUE, T, yes, Y and 1 as yes and FALSE, F, no, N
#'     and 0 as no, in any case; deceased reads DECEASED, deceased, dead and
#'     the yes-words. A column holding any other value is not drawn, and the
#'     app names it and the values. Lines are drawn at right angles or
#'     straight. A twins file's codes may be MZ twin, DZ twin and UZ twin or
#'     1, 2 and 3, as kinship2 numbers them; the file is checked with
#'     \code{\link{checkTwinRelations}}, its problem shown and the pedigree
#'     drawn without twins until it is corrected, and a pair is drawn when
#'     both its animals are.
#'   \item \strong{See the pedigree drawn} on the Diagram tab, with
#'     \code{gen} added by \code{\link{findGeneration}}, laid out by
#'     \code{\link{makePedigreeMatingLayout}}. What the layout says (a
#'     warning, or an animal it leaves out) is shown under the count of
#'     animals drawn; when a pedigree cannot be drawn, the app says so. A
#'     sire or dam with no row of its own is added by
#'     \code{\link{addParents}}, and the app names it.
#'   \item \strong{Choose the animals to draw}: everyone; one family (from
#'     \code{\link{findPedigreeNumber}}, the families of two or more
#'     animals listed largest first); focal animals with their ancestors and
#'     descendants (\code{\link{trimPedigree}} and
#'     \code{\link{getDescendantPedigree}}), each other parent of a
#'     descendant drawn too, without its own parents; or focal animals'
#'     near relatives (\code{\link{getNearRelativePedigree}}, 3 by
#'     default). Type the focal animals' ids, or click an animal in the
#'     drawing to make it the focal animal (a repeated animal's symbol
#'     counts as the animal). With more than 1,000 animals chosen, the app
#'     asks before drawing them, which can take a minute or more.
#'   \item \strong{See the records' problems} on the Checks tab, from
#'     \code{\link{checkPedigree}} on the whole file, and the animals chosen
#'     on the Animals tab.
#'   \item \strong{Save} the drawing as an SVG, a PDF or a PNG file with the
#'     buttons above it, through \code{\link{savePedigreeDiagram}} at its own
#'     page (10 inches wide; a PNG at 300 dpi); and the animals chosen as a
#'     CSV file with the button on the Animals tab: the rows that tab shows,
#'     with every column of the file, which the app opens again to the same
#'     drawing. The pictures need the \pkg{chromote} package and Google
#'     Chrome or Chromium; without them the picture buttons are grayed and
#'     the page says what is missing.
#' }
#'
#' @param ped \code{NULL}, or a data frame with the columns \code{id},
#'   \code{sire}, \code{dam} and \code{sex} (its other columns kept), opened
#'   in the app as if read from a file.
#' @param port \code{NULL}, for a free port chosen by \pkg{shiny}, or the
#'   port, one whole number from 1 to 65535.
#' @param launch.browser \code{TRUE} to open the app in the web browser,
#'   \code{FALSE} to print its address only. By default, \code{TRUE} in an
#'   interactive R session.
#' @return What \code{shiny::runApp()} returns when the app is closed,
#'   invisibly.
#' @section Requirements:
#'   The \pkg{shiny} package (\code{install.packages("shiny")}), checked
#'   before anything else. Saving the drawing as a picture also needs the
#'   \pkg{chromote} package and Google Chrome or Chromium, as
#'   \code{\link{savePedigreeDiagram}} does; the app looks for them once,
#'   when it starts.
#' @seealso \code{\link{drawPedigreeDiagram}}, which draws the pedigree, and
#'   \code{\link{checkPedigree}}, which finds the records' problems.
#' @examples
#' # It starts an app and waits until it is closed, so it runs when typed in
#' # R, and not in R CMD check.
#' if (interactive() && requireNamespace("shiny", quietly = TRUE)) {
#'   runPedigreeApp()
#'
#'   ped <- data.frame(
#'     id = c("A", "B", "C", "D"),
#'     sire = c(NA, NA, "A", "A"),
#'     dam = c(NA, NA, "B", "B"),
#'     sex = c("M", "F", "F", "M")
#'   )
#'   runPedigreeApp(ped)
#' }
#' @export
# nolint start: object_name_linter. launch.browser is shiny's name (R149).
runPedigreeApp <- function(ped = NULL, port = NULL,
                           launch.browser = interactive()) {
  # nolint end
  if (!requireNamespace("shiny", quietly = TRUE)) {
    stop("runPedigreeApp() needs the 'shiny' package; install it with ",
         "install.packages(\"shiny\").")
  }
  if (!is.null(ped)) {
    if (!is.data.frame(ped)) {
      stop("runPedigreeApp(): 'ped' must be a data frame with the columns ",
           "id, sire, dam and sex.")
    }
    lacks <- setdiff(c("id", "sire", "dam", "sex"), names(ped))
    if (length(lacks) > 0L) {
      stop("runPedigreeApp(): 'ped' lacks the column(s): ", toString(lacks),
           ".")
    }
    if (nrow(ped) == 0L) {
      stop("runPedigreeApp(): 'ped' has no rows.")
    }
  }
  if (!is.null(port) &&
        !(is.numeric(port) && length(port) == 1L && !is.na(port) &&
            port == round(port) && port >= 1.0 && port <= 65535.0)) {
    stop("runPedigreeApp(): 'port' must be NULL or one whole number from 1 ",
         "to 65535.")
  }
  if (!isTRUE(launch.browser) && !isFALSE(launch.browser)) {
    stop("runPedigreeApp(): 'launch.browser' must be TRUE or FALSE.")
  }
  app <- shiny::shinyApp(.pedigreeAppUi(), .pedigreeAppServer(ped))
  invisible(shiny::runApp(app, port = port, launch.browser = launch.browser))
}
