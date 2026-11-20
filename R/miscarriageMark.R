## Copyright(c) 2017-2026 R. Mark Sharp
## This file is part of pedkindraw
## pedkindraw's own code, not copied from nprcgenekeepr (plan Phase G13, gap
## B3 of docs/research/pedkindraw-gaps-2026-11-18.md; rulings R133 and R139,
## pedkindraw S59). The copied makePedigreeMatingLayout() reads a column
## miscarriage with .readMiscarriage(), stops on a miscarriage that is a
## parent or has a fertility mark (.checkMiscarriage()) and marks each node
## with .miscarriageNodes(); the copied drawPedigreeDiagram() draws each
## marked animal as a small triangle with its id moved into its row and adds
## the points of .miscarriageRoom(), and a "Miscarriage", a "Termination"
## and an "Ectopic" legend row (.miscarriageLegendImage()), when an animal is
## marked; the copied .diagramAfterDrawing() then runs
## .miscarriageHandler() last (DIVERGENCE.md). S59's REFACTOR:
## .readMiscarriage() reads the column with .readWordColumn() and
## .checkMiscarriage() names the animals with .idsShown() (R/markColumns.R).

#' The miscarriage values read, and what each means
#'
#' Phase G13 (R139). Pedixplorer's words and values, from its help for
#' \code{miscarriage_to_factor()}: \code{"SAB"}, a spontaneous abortion (also
#' \code{"spontaneous"}, and \code{"spontaenous abortion"} as that help
#' spells it, and \code{"spontaneous abortion"}, which Pedixplorer 1.8.0
#' reads as no miscarriage); \code{"TOP"}, a termination of pregnancy (also
#' \code{"termination"}, \code{"terminated"} and
#' \code{"termination of pregnancy"}); \code{"ECT"}, an ectopic pregnancy
#' (also \code{"ectopic"} and \code{"ectopic pregnancy"}); and
#' \code{"FALSE"}, none (also \code{FALSE}, 0 and \code{"no"}). The names are
#' the values without their spaces and in lower case, as Pedixplorer
#' ignores both; \code{"NA"} is not recorded, as \code{NA} is.
#' @noRd
.miscarriageWords <- c(
  sab = "SAB", spontaneous = "SAB", spontaenousabortion = "SAB",
  spontaneousabortion = "SAB",
  top = "TOP", termination = "TOP", terminated = "TOP",
  terminationofpregnancy = "TOP",
  ect = "ECT", ectopic = "ECT", ectopicpregnancy = "ECT",
  false = "FALSE", "0" = "FALSE", no = "FALSE",
  na = NA_character_
)

#' Read the miscarriage column of a pedigree
#'
#' Phase G13 (R139). \code{NULL} when \code{ped} has no column
#' \code{miscarriage}. Otherwise each animal's \code{"SAB"}, \code{"TOP"},
#' \code{"ECT"}, \code{"FALSE"} or \code{NA} (not recorded, as \code{NA},
#' \code{NaN} and \code{"NA"} are), named by id; the column may be logical,
#' numbers, text or a factor (\code{asPedFrame()} returns Pedixplorer's as a
#' factor). Anything else stops, naming the caller, the column and up to
#' five of its other values; Pedixplorer reads them as no miscarriage
#' without a word. S59's REFACTOR: read by \code{.readWordColumn()}, each
#' value's key its text without spaces and in lower case.
#' @param ped data frame with an \code{id} column.
#' @param caller the caller's name, without parentheses, for the message.
#' @return \code{NULL}, or a character vector named by \code{ped$id}.
#' @noRd
.readMiscarriage <- function(ped, caller) {
  .readWordColumn(
    ped, "miscarriage", .miscarriageWords,
    function(text) gsub("[[:space:]]", "", tolower(text)), caller, paste0(
      "Give \"SAB\" (a spontaneous abortion), \"TOP\" (a termination of ",
      "pregnancy) or \"ECT\" (an ectopic pregnancy) for each miscarriage, ",
      "FALSE, 0 or \"no\" for an animal that is not one, as Pedixplorer ",
      "reads them, NA where it is not recorded."
    )
  )
}

#' Stop on a miscarriage that is a parent or has a fertility mark
#'
#' Phase G13 (R139). A miscarriage has no offspring and no fertility, so an
#' animal the column marks that is some animal's sire or dam, or that the
#' column \code{fertility} marks infertile or with no offspring, stops,
#' naming up to five such animals; Pedixplorer 1.8.0 refuses both
#' (\dQuote{is-aborted-but-is-parent}, \dQuote{is-aborted-but-has-fertility}).
#' @param ped data frame with \code{id}, \code{sire} and \code{dam} columns.
#' @param miscarriage what \code{.readMiscarriage()} returns.
#' @param fertility what \code{.readFertility()} returns.
#' @param caller the caller's name, without parentheses, for the message.
#' @return \code{NULL}, invisibly.
#' @noRd
.checkMiscarriage <- function(ped, miscarriage, fertility, caller) {
  if (is.null(miscarriage)) {
    return(invisible(NULL))
  }
  ids <- names(miscarriage)[miscarriage %in% c("SAB", "TOP", "ECT")]
  parents <- ids[ids %in% c(as.character(ped$sire), as.character(ped$dam))]
  if (length(parents) > 0L) {
    stop(caller, "(): the column 'miscarriage' marks ", .idsShown(parents),
         ", each a sire or dam. A miscarriage has no offspring: correct the ",
         "column or the parents.", call. = FALSE)
  }
  if (!is.null(fertility)) {
    marked <- ids[fertility[ids] %in% c("infertile", "infertile_choice_na")]
    if (length(marked) > 0L) {
      stop(caller, "(): the column 'miscarriage' marks ", .idsShown(marked),
           ", which the column 'fertility' marks infertile or with no ",
           "offspring. A miscarriage has no fertility: give it \"fertile\" ",
           "or NA there.", call. = FALSE)
    }
  }
  invisible(NULL)
}

#' Each node's miscarriage mark
#'
#' Phase G13 (R139). \code{"SAB"}, \code{"TOP"} or \code{"ECT"} for the node
#' of such an animal and each of its repeat-appearance nodes; \code{""} for
#' every other node: an animal that is not a miscarriage or not recorded, a
#' mating union, a routing point.
#' @param nodeIds ids of the layout's nodes.
#' @param miscarriage what \code{.readMiscarriage()} returns.
#' @param dupIds ids of the repeat-appearance nodes.
#' @param dupRealIds the real id of each repeat-appearance node.
#' @return character vector, as long as \code{nodeIds}, never \code{NA}.
#' @noRd
.miscarriageNodes <- function(nodeIds, miscarriage, dupIds, dupRealIds) {
  kind <- unname(miscarriage[.nodeAnimals(nodeIds, dupIds, dupRealIds)])
  ifelse(kind %in% c("SAB", "TOP", "ECT"), kind, "")
}

#' The hover text's words for each miscarriage value
#'
#' Phase G13 (R139).
#' @param miscarriage \code{"SAB"}, \code{"TOP"}, \code{"ECT"},
#'   \code{"FALSE"} or \code{NA} for each animal.
#' @return character vector: \dQuote{Spontaneous abortion (SAB)},
#'   \dQuote{Termination of pregnancy (TOP)}, \dQuote{Ectopic pregnancy
#'   (ECT)}, \dQuote{No} or \dQuote{Unknown}.
#' @noRd
.miscarriageLabel <- function(miscarriage) {
  shown <- c(SAB = "Spontaneous abortion (SAB)",
             TOP = "Termination of pregnancy (TOP)",
             ECT = "Ectopic pregnancy (ECT)",
             "FALSE" = "No")[miscarriage]
  shown[is.na(shown)] <- "Unknown"
  unname(shown)
}

#' The miscarriage mark's look
#'
#' Phase G13 (R139). A miscarriage is drawn as a triangle \code{scale} the
#' size of the symbol it replaces (a triangle is also the Unknown sex's
#' symbol; this one is 0.6 of it), its id moved \code{idDown} units down
#' into its row, and \dQuote{ECT} written \code{textSize} units high under
#' an ectopic pregnancy's triangle. Measured in headless Chrome in a
#' 500-pixel drawing (S59): 29 by 25 pixels against the Unknown sex's 48 by
#' 41; in 7 pedigrees, in both edge styles, the line and \dQuote{ECT} lie on
#' nothing else, 6 to 12 pixels from the animal's own id.
#' @noRd
.miscarriageMark <- list(scale = 0.6, idDown = 12L, textSize = 10L)

#' The afterDrawing handler that draws the line of a termination or an
#' ectopic pregnancy
#'
#' Phase G13 (R139). Pedixplorer's picture: after each draw this strokes, 2
#' pixels wide and black, a line from the lower-left to the upper-right
#' corner of the triangle of every node whose \code{miscarriage} field is
#' \code{"TOP"} or \code{"ECT"} (vis.js's triangle of size \code{s} is
#' \code{2.3 s} wide, its apex \code{1.0117 s} above its centre and its base
#' \code{0.9802 s} below, the path \code{.conditionSectionsHandler()}
#' traces), and writes \dQuote{ECT} under an ectopic pregnancy's. A
#' spontaneous abortion is the triangle alone. The text uses single quotes
#' only: it travels inside a JSON string.
#' @param mark see \code{.miscarriageMark}.
#' @return A JavaScript function, as a character string.
#' @noRd
.miscarriageHandler <- function(mark = .miscarriageMark) {
  sprintf(paste0(
    "function(ctx) {\n",
    "  var net = this;\n",
    "  var marked = net.body.data.nodes.get({filter: function(n) {",
    " return n.miscarriage === 'TOP' || n.miscarriage === 'ECT'; }});\n",
    "  if (marked.length === 0) { return; }\n",
    "  ctx.save();\n",
    "  ctx.lineWidth = 2;\n",
    "  ctx.lineCap = 'butt';\n",
    "  ctx.strokeStyle = '#000000';\n",
    "  ctx.fillStyle = '#000000';\n",
    "  ctx.font = '%dpx arial';\n",
    "  ctx.textAlign = 'center';\n",
    "  ctx.textBaseline = 'top';\n",
    "  marked.forEach(function(n) {\n",
    "    var p = net.getPosition(n.id);\n",
    "    var s = n.size || 25;\n",
    "    var half = s * 1.15, top = p.y - s * 1.0117;\n",
    "    var base = p.y + s * 0.9802;\n",
    "    ctx.beginPath();\n",
    "    ctx.moveTo(p.x - half, base);\n",
    "    ctx.lineTo(p.x + half, top);\n",
    "    ctx.stroke();\n",
    "    if (n.miscarriage === 'ECT') {\n",
    "      ctx.fillText('ECT', p.x, base + 1.5);\n",
    "    }\n",
    "  });\n",
    "  ctx.restore();\n",
    "}"
  ), mark$textSize)
}

#' The miscarriages' look and the invisible points beside them
#'
#' Phase G13 (R139). Each node whose \code{miscarriage} field is
#' \code{"SAB"}, \code{"TOP"} or \code{"ECT"} becomes a triangle
#' \code{mark$scale} of its size, with no deceased slash (on the small
#' triangle it would lie along a termination's line), and its id moves
#' \code{mark$idDown} units down (vis.js's \code{font.vadjust}; the other
#' nodes keep theirs, 0 when they have none). vis.js fits its view to the
#' nodes' boxes without their labels' overhang or the move, so a long id at
#' an edge of the drawing, or a moved one in its bottom row, would be cut
#' off; two invisible points per marked node (built by \code{.markRoom()},
#' their ids \code{__misc_l_} and \code{__misc_r_} and the node's id, under
#' a prefix the layout reserves) stand where a full-size triangle's corners
#' are, left and right, 2 units below the moved id's box, so the fit is as
#' for a full-size symbol.
#' @param nodes the nodes to draw.
#' @param mark see \code{.miscarriageMark}.
#' @return \code{nodes} with a \code{font.vadjust} field and two more rows
#'   per marked node.
#' @noRd
.miscarriageRoom <- function(nodes, mark = .miscarriageMark) {
  marked <- nodes[["miscarriage"]] %in% c("SAB", "TOP", "ECT")
  if (!"font.vadjust" %in% names(nodes)) nodes$font.vadjust <- 0L
  nodes$font.vadjust[marked] <- mark$idDown
  shift <- c(0.0, 25.0 + mark$idDown + 2.0)
  out <- .markRoom(nodes, marked, "__misc_l_", c(-1.15, mark$scale), shift)
  out <- .markRoom(out, c(marked, logical(nrow(out) - nrow(nodes))),
                   "__misc_r_", c(1.15, mark$scale), shift)
  at <- which(marked)
  out$shape[at] <- "triangle"
  out$size[at] <- as.integer(round(out$size[at] * mark$scale))
  out$deceased[at] <- FALSE
  out
}

#' The legend's picture of a miscarriage
#'
#' Phase G13 (R139). The legend is its own vis.Network and cannot run the
#' diagram's handler, so its \dQuote{Miscarriage}, \dQuote{Termination} and
#' \dQuote{Ectopic} rows are inline SVG images, as the \dQuote{Deceased} row
#' is: the small triangle, 0.6 of the \dQuote{Unknown} row's (a triangle of
#' size 14, drawn 2.3 times that wide, against an image of size 14, whose 50
#' pixels are drawn 28 wide: 15 of the picture's units), white with the
#' symbols' blue outline; a termination's and an ectopic pregnancy's with
#' the line, and an ectopic pregnancy's with \dQuote{ECT} under it.
#' @param kind \code{"SAB"}, \code{"TOP"} or \code{"ECT"}.
#' @return A \code{data:} URI, as a character string.
#' @noRd
.miscarriageLegendImage <- function(kind) {
  s <- 15.0
  cy <- if (kind == "ECT") 19.0 else 25.0
  top <- cy - 1.0117 * s
  base <- cy + 0.9802 * s
  left <- 25.0 - 1.15 * s
  right <- 25.0 + 1.15 * s
  svg <- paste0(
    "<svg xmlns='http://www.w3.org/2000/svg' width='50' height='50'>",
    sprintf(paste0("<path d='M25 %.1f L%.1f %.1f L%.1f %.1f Z' ",
                   "fill='white' stroke='#2B7CE9' stroke-width='2'/>"),
            top, right, base, left, base),
    if (kind != "SAB") {
      sprintf(paste0("<line x1='%.1f' y1='%.1f' x2='%.1f' y2='%.1f' ",
                     "stroke='black' stroke-width='2'/>"),
              left, base, right, top)
    },
    if (kind == "ECT") {
      paste0("<text x='25' y='49' font-family='Arial' font-size='12' ",
             "text-anchor='middle'>ECT</text>")
    },
    "</svg>"
  )
  paste0("data:image/svg+xml;charset=utf-8,",
         utils::URLencode(svg, reserved = TRUE))
}
