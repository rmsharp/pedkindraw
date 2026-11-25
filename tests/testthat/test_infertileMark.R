## Copyright(c) 2017-2026 R. Mark Sharp
## This file is part of pedkindraw
## pedkindraw's own tests, not copied from nprcgenekeepr (pedkindraw S58, plan
## Phase G13, gap B3 of docs/research/pedkindraw-gaps-2026-11-18.md; rulings
## R133 and R138). Pedixplorer reads a column fertility of three values,
## "fertile", "infertile" and "infertile_choice_na" (no offspring by choice
## or for an unknown reason), and draws a line down from the symbol with two
## bars for the second and one bar for the third, where pedkindraw writes the
## id; it reads values it does not know as fertile, refuses an infertile
## parent and has no legend row. pedkindraw ignored such a column. Mark's
## picks (S58): the column fertility with Pedixplorer's words and values
## (any other value stops, NA is not recorded and unmarked, its hover text
## "Fertility: Unknown"); the mark under the symbol, Pedixplorer's picture,
## with the id moved down below it, and invisible points so a moved id in
## the bottom row is not cut off; an animal with offspring drawn as
## recorded; legend rows "Infertile" and "No offspring", each its mark
## alone, before "Deceased", 45 px each. The looks were measured in headless
## Chrome at 500 px before the picker, and every expected value here was
## computed on a prototype of the change first (Learning 18). nprcgenekeepr
## has no such mark; DIVERGENCE.md records it "at the switch" (R98). S89
## (R163): the check that each value is named once gives the repeated value
## to two more animals, where it repeated D's row, since a repeated id now
## stops makePedigreeMatingLayout() first.
library(testthat)

## Four animals: A (a male) and B (a female) are the parents of C (a male) and
## D (a female), as tools/gapCases.R's markings case. Each named argument adds
## a column.
.infertilePed <- function(...) {
  ped <- data.frame(
    id = c("A", "B", "C", "D"),
    sire = c(NA, NA, "A", "A"),
    dam = c(NA, NA, "B", "B"),
    sex = c("M", "F", "M", "F"),
    gen = c(0L, 0L, 1L, 1L),
    stringsAsFactors = FALSE
  )
  extra <- list(...)
  for (name in names(extra)) ped[[name]] <- extra[[name]]
  ped
}

## A field of each of `ids`' own nodes in a layout.
.infertileFieldOf <- function(result, field, ids) {
  result$nodes[[field]][match(ids, result$nodes$id)]
}

## The loop pedigree of G2's tests: 8LKBV9 is drawn more than once.
.infertileLoopPed <- function(...) {
  ped <- data.frame(
    id = c("5A6DFT", "8DKELJ", "G8EBU9", "8P17E3",
           "8LKBV9", "FJIB3R", "9VGCCV", "GA204Z"),
    sire = c(NA, NA, NA, NA, "5A6DFT", "8LKBV9", "8LKBV9", "8LKBV9"),
    dam = c(NA, NA, NA, NA, "8DKELJ", "G8EBU9", "8P17E3", "FJIB3R"),
    sex = c("M", "F", "F", "F", "M", "F", "F", "M"),
    gen = c(0L, 0L, 0L, 0L, 1L, 2L, 2L, 3L),
    stringsAsFactors = FALSE
  )
  extra <- list(...)
  for (name in names(extra)) ped[[name]] <- extra[[name]]
  ped
}

test_that(
  ".infertileMark is Pedixplorer's picture under the symbol, with the id
   moved 14 units down", {
  expect_identical(.infertileMark, list(line = 0.58, bar1 = 0.8, bar2 = 1.0,
                                        gap = 0.2, idDown = 14L))
})

test_that(
  "makePedigreeMatingLayout gives each node its fertility mark, \"\" for every
   other node, in both edge styles, only with the column", {
  ped <- .infertilePed(fertility = c("fertile", NA, "infertile",
                                     "infertile_choice_na"))
  for (edgeStyle in c("rectilinear", "direct")) {
    result <- makePedigreeMatingLayout(ped, edgeStyle = edgeStyle)
    expect_identical(.infertileFieldOf(result, "fertility", ped$id),
                     c("", "", "infertile", "infertile_choice_na"),
                     info = edgeStyle)
    others <- result$nodes[!result$nodes$id %in% ped$id, ]
    expect_gt(nrow(others), 0L)
    expect_identical(unique(others$fertility), "", info = edgeStyle)
    without <- makePedigreeMatingLayout(.infertilePed(), edgeStyle = edgeStyle)
    expect_false("fertility" %in% names(without$nodes), info = edgeStyle)
  }
})

test_that(
  "every repeat appearance of an infertile animal is marked and has its hover
   line, and the mating-union and routing nodes are not", {
  ped <- .infertileLoopPed(fertility = c("fertile", "infertile", NA,
                                         "infertile_choice_na", "infertile",
                                         "fertile", "fertile",
                                         "infertile_choice_na"))
  for (edgeStyle in c("rectilinear", "direct")) {
    result <- makePedigreeMatingLayout(ped, edgeStyle = edgeStyle)
    dupIds <- names(result$duplicateToReal)[result$duplicateToReal == "8LKBV9"]
    expect_gte(length(dupIds), 1L)
    expect_identical(.infertileFieldOf(result, "fertility",
                                       c("8LKBV9", dupIds)),
                     rep("infertile", 1L + length(dupIds)), info = edgeStyle)
    expect_true(all(grepl("<b>Fertility:</b> Infertile",
                          .infertileFieldOf(result, "title",
                                            c("8LKBV9", dupIds)),
                          fixed = TRUE)), info = edgeStyle)
    expect_identical(.infertileFieldOf(result, "fertility", ped$id),
                     c("", "infertile", "", "infertile_choice_na",
                       "infertile", "", "", "infertile_choice_na"),
                     info = edgeStyle)
    others <- result$nodes[!(result$nodes$id %in%
                               c(ped$id, names(result$duplicateToReal))), ]
    expect_true(any(startsWith(others$id, "__union_")), info = edgeStyle)
    expect_identical(unique(others$fertility), "", info = edgeStyle)
  }
})

test_that(
  "the hover text says Fertility: Fertile, Infertile, No offspring by choice
   or for an unknown reason, or Unknown, after the evaluated line and before
   the name, and nothing without the column", {
  ped <- .infertilePed(affected = c(TRUE, FALSE, NA, FALSE),
                       evaluated = c(NA, TRUE, FALSE, TRUE),
                       fertility = c("infertile", NA, "fertile",
                                     "infertile_choice_na"),
                       name = c("Ace", "Bea", "Cy", "Di"))
  result <- makePedigreeMatingLayout(ped)
  titles <- .infertileFieldOf(result, "title", ped$id)
  shown <- c("Infertile", "Unknown", "Fertile",
             "No offspring by choice or for an unknown reason")
  for (i in seq_along(titles)) {
    fertilityAt <- regexpr(paste0("<br><b>Fertility:</b> ", shown[[i]],
                                  "<br>"),
                           titles[[i]], fixed = TRUE)
    expect_gt(fertilityAt, regexpr("<b>Evaluated:</b>", titles[[i]],
                                   fixed = TRUE), label = ped$id[[i]])
    expect_lt(fertilityAt, regexpr("<b>Name:</b>", titles[[i]],
                                   fixed = TRUE), label = ped$id[[i]])
  }
  ped$fertility <- NULL
  without <- makePedigreeMatingLayout(ped)
  expect_false(any(grepl("Fertility", without$nodes$title, fixed = TRUE)))
})

test_that(
  "the column reads Pedixplorer's words in any case, TRUE and 1 as fertile,
   FALSE and 0 as infertile, as text or a factor, NA and NaN as not
   recorded", {
  forms <- list(
    logical = list(c(TRUE, FALSE, NA, FALSE),
                   c("", "infertile", "", "infertile")),
    double = list(c(1.0, 0.0, NaN, 0.0), c("", "infertile", "", "infertile")),
    integer = list(c(1L, 0L, NA, 1L), c("", "infertile", "", "")),
    words = list(c("fertile", "infertile", "infertile_choice_na", NA),
                 c("", "infertile", "infertile_choice_na", "")),
    others = list(c("TRUE", "FALSE", "steril", "infertile_choice"),
                  c("", "infertile", "infertile", "infertile_choice_na")),
    digits = list(c("1", "0", "infertile_na", "Fertile"),
                  c("", "infertile", "infertile_choice_na", "")),
    cases = list(c("INFERTILE", "Steril", "Infertile_Choice_NA", "true"),
                 c("infertile", "infertile", "infertile_choice_na", "")),
    factor = list(factor(c("infertile", "fertile", NA, "infertile_choice_na"),
                         levels = c("infertile_choice_na", "infertile",
                                    "fertile")),
                  c("infertile", "", "", "infertile_choice_na"))
  )
  for (form in names(forms)) {
    result <- makePedigreeMatingLayout(
      .infertilePed(fertility = forms[[form]][[1L]])
    )
    expect_identical(.infertileFieldOf(result, "fertility",
                                       c("A", "B", "C", "D")),
                     forms[[form]][[2L]], info = form)
  }
  ## NA and NaN are not recorded: the hover text says Unknown.
  result <- makePedigreeMatingLayout(
    .infertilePed(fertility = c(1.0, 0.0, NaN, NA))
  )
  expect_identical(
    regmatches(result$nodes$title[1:4],
               regexpr("Fertility:</b> [A-Za-z]+", result$nodes$title[1:4])),
    paste("Fertility:</b>", c("Fertile", "Infertile", "Unknown", "Unknown"))
  )
})

test_that(
  "every value both read marks as Pedixplorer's fertility_to_factor() reads
   it, NA unmarked as Pedixplorer's fertile is", {
  skip_if_not_installed("Pedixplorer")
  values <- list(
    c("fertile", "infertile", "infertile_choice_na", NA),
    c("TRUE", "FALSE", "steril", "infertile_choice"),
    c("1", "0", "infertile_na", "Fertile"),
    c("INFERTILE", "Steril", "Infertile_Choice_NA", "true"),
    c(TRUE, FALSE, NA, FALSE),
    c(1.0, 0.0, NA, 1.0)
  )
  markOf <- c(fertile = "", infertile = "infertile",
              infertile_choice_na = "infertile_choice_na")
  for (v in values) {
    theirs <- unname(markOf[as.character(
      Pedixplorer::fertility_to_factor(v)
    )])
    result <- makePedigreeMatingLayout(.infertilePed(fertility = v))
    expect_identical(.infertileFieldOf(result, "fertility",
                                       c("A", "B", "C", "D")),
                     theirs, info = toString(v))
  }
})

test_that(
  "a fertility column holding anything else stops, naming the column and its
   values, before any animal is left out", {
  advice <- paste0(
    "Give \"fertile\", \"infertile\" or \"infertile_choice_na\" for each ",
    "animal (TRUE or 1 for fertile, FALSE or 0 for infertile, as ",
    "Pedixplorer reads them), NA where it is not recorded."
  )
  expect_error(
    makePedigreeMatingLayout(.infertilePed(fertility = c(2.0, 1.0, 0.0, 0.5))),
    paste0("makePedigreeMatingLayout(): the column 'fertility' holds values ",
           "it cannot read (2, 0.5). ", advice),
    fixed = TRUE
  )
  expect_error(
    makePedigreeMatingLayout(.infertilePed(fertility = c("yes", "sterile",
                                                         "T", ""))),
    "the column 'fertility' holds values it cannot read ('yes', 'sterile', 'T', '')",
    fixed = TRUE
  )
  expect_error(
    makePedigreeMatingLayout(rbind(
      .infertilePed(fertility = c("a", "b", "c", "d")),
      data.frame(id = c("E", "F"), sire = "A", dam = "B", sex = "M",
                 gen = 1L, fertility = "d")
    )),
    "cannot read ('a', 'b', 'c', 'd')",
    fixed = TRUE
  )
  six <- rbind(.infertilePed(fertility = c("a", "b", "c", "d")),
               data.frame(id = c("E", "F"), sire = "A", dam = "B",
                          sex = "M", gen = 1L, fertility = c("e", "f")))
  expect_error(makePedigreeMatingLayout(six),
               "cannot read ('a', 'b', 'c', 'd', 'e', ...)", fixed = TRUE)
  expect_error(
    makePedigreeMatingLayout(.infertilePed(
      fertility = as.Date(c("2020-01-01", NA, NA, NA))
    )),
    "the column 'fertility' holds values it cannot read (a column of class Date)",
    fixed = TRUE
  )
  ## E has no parent, mate or offspring, so the layout leaves it out; its
  ## value still stops the layout.
  ped <- rbind(.infertilePed(fertility = c("infertile", "fertile", "fertile",
                                           "fertile")),
               data.frame(id = "E", sire = NA, dam = NA, sex = "M",
                          gen = 0L, fertility = "nope"))
  expect_error(suppressMessages(makePedigreeMatingLayout(ped)),
               "the column 'fertility' holds values it cannot read ('nope')",
               fixed = TRUE)
})

test_that(
  "an infertile animal with offspring is marked as recorded, with no warning
   and no stop", {
  ped <- .infertilePed(fertility = c("infertile", "infertile_choice_na",
                                     "fertile", "fertile"))
  for (edgeStyle in c("rectilinear", "direct")) {
    expect_no_warning(
      result <- makePedigreeMatingLayout(ped, edgeStyle = edgeStyle)
    )
    expect_identical(.infertileFieldOf(result, "fertility", ped$id),
                     c("infertile", "infertile_choice_na", "", ""),
                     info = edgeStyle)
  }
})

test_that(
  "a Pedixplorer object converted by asPedFrame() is drawn with its marks, the
   column not renamed", {
  skip_if_not_installed("Pedixplorer")
  d <- data.frame(id = c("A", "B", "C", "D"), dadid = c(NA, NA, "A", "A"),
                  momid = c(NA, NA, "B", "B"), sex = c(1, 2, 1, 2),
                  fertility = c("fertile", "fertile", "infertile",
                                "infertile_choice_na"),
                  stringsAsFactors = FALSE)
  ped <- asPedFrame(Pedixplorer::Pedigree(d))$ped
  ped$gen <- findGeneration(ped$id, ped$sire, ped$dam)
  result <- makePedigreeMatingLayout(ped)
  expect_identical(.infertileFieldOf(result, "fertility", ped$id),
                   c("", "", "infertile", "infertile_choice_na"))
})

test_that(
  "with every animal left out the layout's empty nodes gain an empty
   fertility field only when the pedigree has the column", {
  ped <- data.frame(id = c("A", "B"), sire = NA, dam = NA, sex = c("M", "F"),
                    gen = 0L, stringsAsFactors = FALSE)
  without <- suppressMessages(makePedigreeMatingLayout(ped))
  expect_false("fertility" %in% names(without$nodes))
  ped$fertility <- c("infertile", "fertile")
  result <- suppressMessages(makePedigreeMatingLayout(ped))
  expect_identical(nrow(result$nodes), 0L)
  expect_identical(result$nodes$fertility, character())
})

test_that(
  "a real id starting __fert_, the prefix of the drawing's points, is
   refused, and the message names the prefix", {
  ped <- .infertilePed()
  for (column in c("id", "sire")) {
    ped[[column]][ped[[column]] %in% "A"] <- "__fert_A"
  }
  ## S59: __misc_ (the miscarriage mark's points) follows __fert_ in the list.
  expect_error(makePedigreeMatingLayout(ped), "'__eval_'/'__fert_'",
               fixed = TRUE)
  expect_true("__fert_" %in% .reservedIdPrefixes)
})

test_that(
  "on seeded random pedigrees the column adds the field and the hover line
   and changes nothing else", {
  skip_if_not_installed("withr")
  quietLayout <- function(ped) {
    withCallingHandlers(
      suppressMessages(makePedigreeMatingLayout(ped)),
      warning = function(w) {
        if (grepl("same-row edge-node collision", conditionMessage(w),
                  fixed = TRUE)) {
          invokeRestart("muffleWarning")
        }
      }
    )
  }
  marks <- c("fertile", "infertile", "infertile_choice_na", NA)
  compared <- 0L
  for (seed in 1:40) {
    case <- withr::with_seed(seed, {
      ped <- checkPedigreeClean(sample(6L:40L, 1L))
      fertility <- sample(marks, nrow(ped), replace = TRUE)
      list(ped = ped, fertility = fertility)
    })
    ped <- case$ped
    ped$gen <- findGeneration(ped$id, ped$sire, ped$dam)
    without <- quietLayout(ped)
    ped$fertility <- case$fertility
    with <- quietLayout(ped)
    label <- paste("seed", seed)
    drawn <- with$nodes$id %in% ped$id
    at <- match(with$nodes$id[drawn], ped$id)
    want <- case$fertility[at]
    want[is.na(want) | want == "fertile"] <- ""
    expect_identical(with$nodes$fertility[drawn], want, label = label)
    keep <- setdiff(names(without$nodes), "title")
    expect_identical(with$nodes[keep], without$nodes[keep], label = label)
    expect_identical(sub("<br><b>Fertility:</b> [A-Za-z ]+", "",
                         with$nodes$title),
                     without$nodes$title, label = label)
    expect_identical(with[names(with) != "nodes"],
                     without[names(without) != "nodes"], label = label)
    compared <- compared + 1L
  }
  expect_identical(compared, 40L)
})

test_that(
  "the bars are drawn by a handler run last, after the star, the arrows, the
   carrier's dot and the deceased slash, only when some node is marked", {
  handler <- .infertileBarsHandler()
  expect_match(handler, paste0("return n.fertility === 'infertile' || ",
                               "n.fertility === 'infertile_choice_na'; "),
               fixed = TRUE)
  expect_match(handler, "var top = p.y + s, end = top + s * 0.58;",
               fixed = TRUE)
  expect_match(handler, "var bars = [[end, s * 0.8]];", fixed = TRUE)
  expect_match(handler, paste0("if (n.fertility === 'infertile') { ",
                               "bars.push([end + s * 0.2, s * 1]); }"),
               fixed = TRUE)
  expect_match(handler, "ctx.lineWidth = 2;", fixed = TRUE)
  expect_false(grepl("\"", handler, fixed = TRUE))
  for (sections in c(FALSE, TRUE)) {
    for (marks in c(FALSE, TRUE)) {
      label <- paste("sections", sections, "other marks", marks)
      chained <- .diagramAfterDrawing(sections, .conditionColors, marks,
                                      marks, marks, TRUE)
      slashAt <- regexpr(.deceasedSlashHandler(), chained, fixed = TRUE)
      barsAt <- regexpr(handler, chained, fixed = TRUE)
      expect_gt(slashAt, 0L, label = label)
      expect_gt(barsAt, slashAt, label = label)
      if (marks) {
        for (other in list(.carrierDotHandler(), .probandArrowHandler(),
                           .evaluatedStarHandler())) {
          expect_gt(barsAt, regexpr(other, chained, fixed = TRUE),
                    label = label)
        }
      }
      expect_identical(grepl("affectedSections", chained, fixed = TRUE),
                       sections, label = label)
    }
  }
  expect_identical(.diagramAfterDrawing(FALSE, infertile = FALSE),
                   .deceasedSlashHandler())
  expect_false(grepl("n.fertility",
                     .diagramAfterDrawing(TRUE, carrier = TRUE, arrows = TRUE,
                                          evaluated = TRUE),
                     fixed = TRUE))
})

test_that(
  ".infertileRoom moves each marked animal's id 14 units down and adds one
   invisible point per marked node, 2 units below the moved id", {
  ped <- .infertilePed(affected = c(TRUE, FALSE, FALSE, TRUE),
                       affected2 = c(FALSE, TRUE, FALSE, FALSE),
                       status = c("DECEASED", "ALIVE", "ALIVE", "ALIVE"),
                       genotyped = c(TRUE, FALSE, FALSE, FALSE),
                       carrier = c(TRUE, FALSE, FALSE, FALSE),
                       proband = c(FALSE, FALSE, TRUE, FALSE),
                       evaluated = c(FALSE, TRUE, FALSE, FALSE),
                       fertility = c("infertile", NA, "infertile_choice_na",
                                     "fertile"))
  for (edgeStyle in c("rectilinear", "direct")) {
    nodes <- makePedigreeMatingLayout(ped, edgeStyle = edgeStyle)$nodes
    out <- .infertileRoom(nodes)
    expect_identical(nrow(out), nrow(nodes) + 2L, info = edgeStyle)
    expect_identical(out$id[seq_len(nrow(nodes))], nodes$id, info = edgeStyle)
    expect_identical(out$font.vadjust[seq_len(nrow(nodes))],
                     ifelse(nodes$id %in% c("A", "C"), 14L, 0L),
                     info = edgeStyle)
    room <- out[-seq_len(nrow(nodes)), ]
    expect_identical(room$id, c("__fert_A", "__fert_C"), info = edgeStyle)
    owner <- nodes[match(c("A", "C"), nodes$id), ]
    expect_equal(room$x, owner$x, info = edgeStyle)
    expect_equal(room$y, owner$y + 25 + 25 + 14 + 2, info = edgeStyle)
    expect_identical(room$size, c(0L, 0L), info = edgeStyle)
    expect_identical(room$label, c("", ""), info = edgeStyle)
    expect_identical(room$shape, c("dot", "dot"), info = edgeStyle)
    expect_identical(room$title, c(NA_character_, NA_character_),
                     info = edgeStyle)
    expect_identical(room$fertility, c("", ""), info = edgeStyle)
    expect_identical(unique(room$color.background), "rgba(0,0,0,0)",
                     info = edgeStyle)
    expect_identical(unique(room$color.border), "rgba(0,0,0,0)",
                     info = edgeStyle)
    expect_identical(unique(room$affectedSections), "", info = edgeStyle)
    expect_identical(unique(room$borderWidth), 1L, info = edgeStyle)
    for (field in c("deceased", "carrier", "proband", "evaluated")) {
      expect_identical(unique(room[[field]]), FALSE,
                       info = paste(edgeStyle, field))
    }
    ## The nodes are kept; rbind() makes the direct style's integer y double.
    kept <- out[seq_len(nrow(nodes)), names(nodes)]
    rownames(kept) <- NULL
    expect_equal(kept, nodes, info = edgeStyle)
    ## After the arrows' and the stars' points: none for a point.
    all <- .infertileRoom(.evaluatedStarRoom(.probandArrowRoom(nodes)))
    expect_identical(all$id[-seq_len(nrow(nodes))],
                     c("__mark_C", "__eval_B", "__fert_A", "__fert_C"),
                     info = edgeStyle)
  }
})

test_that("the legend's pictures are the mark alone, two bars or one", {
  svgOf <- function(twoBars) {
    utils::URLdecode(sub("data:image/svg+xml;charset=utf-8,", "",
                         .infertileLegendImage(twoBars), fixed = TRUE))
  }
  stroke <- "stroke='black' stroke-width='3'/>"
  open <- "<svg xmlns='http://www.w3.org/2000/svg' width='50' height='50'>"
  line <- paste0("<line x1='25' y1='8' x2='25' y2='26' ", stroke,
                 "<line x1='9' y1='26' x2='41' y2='26' ", stroke)
  expect_identical(svgOf(TRUE), paste0(
    open, line, "<line x1='5' y1='33' x2='45' y2='33' ", stroke, "</svg>"
  ))
  expect_identical(svgOf(FALSE), paste0(open, line, "</svg>"))
})

test_that(
  "drawPedigreeDiagram adds Infertile and No offspring rows before Deceased,
   45 px each, the handler, the moved ids and the points, when an animal is
   marked", {
  skip_if_not_installed("visNetwork")
  rowsOf <- function(w) w$x$legend$nodes
  sexRows <- c("Female", "Male", "Hermaphrodite", "Unknown",
               "Other / Unrecorded")
  layout <- makePedigreeMatingLayout(
    .infertilePed(fertility = c("fertile", NA, "infertile",
                                "infertile_choice_na"))
  )
  w <- drawPedigreeDiagram(layout)
  rows <- rowsOf(w)
  expect_identical(rows$label, c(sexRows, "Affected", "Infertile",
                                 "No offspring", "Deceased"))
  expect_identical(rows$shape[rows$label %in% c("Infertile", "No offspring")],
                   c("image", "image"))
  expect_identical(rows$image[rows$label == "Infertile"],
                   .infertileLegendImage(TRUE))
  expect_identical(rows$image[rows$label == "No offspring"],
                   .infertileLegendImage(FALSE))
  expect_identical(w$height, "590px")
  expect_identical(as.character(w$x$events$afterDrawing),
                   .diagramAfterDrawing(FALSE, infertile = TRUE))
  expect_identical(w$x$nodes, .infertileRoom(layout$nodes))
  expect_identical(w$x$idselection$values, c("A", "B", "C", "D"))
  ## One kind only: its row alone, 545 px.
  for (kind in c("infertile", "infertile_choice_na")) {
    one <- drawPedigreeDiagram(makePedigreeMatingLayout(
      .infertilePed(fertility = c("fertile", "fertile", kind, "fertile"))
    ))
    expect_identical(setdiff(rowsOf(one)$label, c(sexRows, "Affected",
                                                  "Deceased")),
                     if (kind == "infertile") "Infertile" else "No offspring",
                     info = kind)
    expect_identical(one$height, "545px", info = kind)
  }
  ## Every row: three conditions, an unknown status, a genotyped animal, a
  ## carrier, a proband, a consultand and an evaluated animal, the two rows
  ## after Evaluated; the arrows' and the stars' points come before the
  ## moved ids'.
  every <- makePedigreeMatingLayout(
    .infertilePed(affected = c(TRUE, FALSE, NA, TRUE),
                  affected2 = c(FALSE, TRUE, TRUE, FALSE),
                  affected3 = c(TRUE, TRUE, FALSE, FALSE),
                  genotyped = c(FALSE, TRUE, FALSE, FALSE),
                  carrier = c(FALSE, FALSE, TRUE, FALSE),
                  proband = c(FALSE, FALSE, FALSE, TRUE),
                  consultand = c(TRUE, FALSE, FALSE, FALSE),
                  evaluated = c(TRUE, TRUE, FALSE, FALSE),
                  fertility = c("infertile", "fertile", "infertile_choice_na",
                                "infertile"))
  )
  drawn <- drawPedigreeDiagram(every)
  rows <- rowsOf(drawn)
  expect_identical(rows$label,
                   c(sexRows, "Affected", "Affected 2", "Affected 3",
                     "Affected status unknown", "Genotyped", "Carrier",
                     "Proband", "Consultand", "Evaluated", "Infertile",
                     "No offspring", "Deceased"))
  expect_identical(rows$borderWidth[rows$label == "Infertile"], 1L)
  expect_identical(drawn$height, "950px")
  expect_identical(drawn$x$nodes, .infertileRoom(
    .evaluatedStarRoom(.probandArrowRoom(every$nodes))
  ))
  afterDrawing <- as.character(drawn$x$events$afterDrawing)
  expect_gt(regexpr("n.fertility === 'infertile'", afterDrawing,
                    fixed = TRUE),
            regexpr("n.evaluated === true", afterDrawing, fixed = TRUE))
  expect_match(afterDrawing, "n.proband === true", fixed = TRUE)
  expect_match(afterDrawing, "n.carrier === true", fixed = TRUE)
  expect_match(afterDrawing, "affectedSections", fixed = TRUE)
})

test_that(
  "with no marked animal the drawing has no row, handler, moved id, point or
   height for it; without the column the drawing is as before", {
  skip_if_not_installed("visNetwork")
  base <- drawPedigreeDiagram(makePedigreeMatingLayout(.infertilePed()))
  for (values in list(c("fertile", "fertile", NA, TRUE),
                      c(NA, NA, NA, NA))) {
    layout <- makePedigreeMatingLayout(.infertilePed(fertility = values))
    w <- drawPedigreeDiagram(layout)
    expect_identical(w$x$legend, base$x$legend)
    expect_identical(w$height, "500px")
    expect_identical(w$x$events, base$x$events)
    expect_identical(w$x$nodes, layout$nodes)
    expect_false("font.vadjust" %in% names(w$x$nodes))
    expect_identical(unique(w$x$nodes$fertility), "")
  }
  expect_false(any(c("Infertile", "No offspring") %in%
                     base$x$legend$nodes$label))
  expect_identical(as.character(base$x$events$afterDrawing),
                   .diagramAfterDrawing(FALSE))
})

test_that(
  "in a browser, vis.js draws each marked animal's line and bars under its
   symbol with its id below them, the legend rows' marks, and a moved id in
   the bottom row stays inside the canvas", {
  skip_on_cran()
  skip_if_not_installed("visNetwork")
  skip_if_not_installed("htmlwidgets")
  skip_if_not_installed("withr")
  skip_if_no_chrome()

  ## As getLiveRenderedPositions() (helper-live-render-positions.R): a 60 s
  ## timeout on chromote's shared parent before the first session, and one
  ## graceful close of it after the suite.
  chromeParent <- chromote::default_chromote_object()
  if (chromeParent$default_timeout < 60) {
    chromeParent$default_timeout <- 60
  }
  if (!isTRUE(.chromoteParentTeardownRegistered$done)) {
    withr::defer(chromeParent$close(), envir = testthat::teardown_env())
    .chromoteParentTeardownRegistered$done <- TRUE
  }
  session <- chromote::ChromoteSession$new()
  withr::defer(session$close())

  ## A four-generation chain, as measured before the picker: each generation
  ## a male and his mate, then one male G at the bottom. G is infertile, F
  ## has no offspring by choice, C (a parent) is infertile; the rest are
  ## fertile or not recorded. One-letter ids: the strip right of the line
  ## that the id's ink is read in fell between the two letters of "M1".
  ped <- data.frame(
    id = c("A", "B", "C", "D", "E", "F", "G"),
    sire = c(NA, NA, "A", NA, "C", NA, "E"),
    dam = c(NA, NA, "B", NA, "D", NA, "F"),
    sex = c("M", "F", "M", "F", "M", "F", "M"),
    gen = c(0L, 0L, 1L, 1L, 2L, 2L, 3L),
    status = c("DECEASED", "ALIVE", "DECEASED", "ALIVE", "ALIVE", "ALIVE",
               "ALIVE"),
    fertility = c("fertile", NA, "infertile", "fertile", "fertile",
                  "infertile_choice_na", "infertile"),
    stringsAsFactors = FALSE
  )
  widget <- drawPedigreeDiagram(makePedigreeMatingLayout(ped))
  widget$width <- "500px"
  html <- withr::local_tempfile(fileext = ".html")
  htmlwidgets::saveWidget(widget, html, selfcontained = TRUE)
  session$go_to(paste0("file://", html), timeout_ = 30, delay = 0.5)
  expect_true(.waitForLegendPictures(session))
  ## For each animal, near-black pixels (the alpha counted, as read() does
  ## not, dragon 45) in three boxes, in units of its size s from its centre:
  ## the line, between the symbol and where an unmoved id begins (x within 2,
  ## y from s + 3 to s + 10); the second bar's right end, past the first
  ## bar's (x from 0.88 s to 0.96 s, y within 2 of s + 0.78 s); and the band
  ## below the second bar, where a moved id is and an unmoved one, which ends
  ## about 21 units below the symbol, is not (x within 8, y from s + 24 to
  ## s + 45; the id's grey #343434, thin at this zoom, is read below
  ## luminance 128, not 60). Then the room, in CSS pixels, between the lowest
  ## ink of G's moved id (any drawn pixel within 10 units of G's centre line)
  ## and the bottom of the widget: the canvas reaches 5.5 pixels below the
  ## widget's box, so its own bottom is not where the drawing ends (S58:
  ## 25.5 pixels with the points, -1.5 without). Then each legend row's
  ## picture's dark pixels and whether its label ends inside the canvas.
  js <- .pixelReaderJs(paste0(
    "const out = []; const cv = net.canvas.frame.canvas; ",
    "const r = cv.width / cv.clientWidth; const ctx = cv.getContext('2d'); ",
    "const pixels = (x0, y0, x1, y1, below = 60) => { const a = net.canvasToDOM({x: x0, y: y0}); ",
    "const b = net.canvasToDOM({x: x1, y: y1}); ",
    "const w = Math.max(1, Math.round((b.x - a.x) * r)), h = Math.max(1, Math.round((b.y - a.y) * r)); ",
    "const d = ctx.getImageData(Math.round(a.x * r), Math.round(a.y * r), w, h).data; ",
    "const dark = []; for (let i = 0; i < d.length; i += 4) { const al = d[i + 3] / 255; ",
    "dark.push((0.299 * d[i] + 0.587 * d[i + 1] + 0.114 * d[i + 2]) * al + 255 * (1 - al) < below); } ",
    "return {dark: dark}; }; ",
    "const count = q => q.dark.filter(v => v).length; ",
    "['A', 'B', 'C', 'D', 'E', 'F', 'G'].forEach(id => { ",
    "const p = net.getPosition(id); const s = net.body.nodes[id].options.size; ",
    "out.push(String(count(pixels(p.x - 2, p.y + s + 3, p.x + 2, p.y + s + 10)))); ",
    "const e = p.y + s + s * 0.78; ",
    "out.push(String(count(pixels(p.x + 0.88 * s, e - 2, p.x + 0.96 * s, e + 2)))); ",
    "out.push(String(count(pixels(p.x - 8, p.y + s + 24, p.x + 8, p.y + s + 45, 128)))); }); ",
    "const g = net.getPosition('G'); const ga = net.canvasToDOM({x: g.x - 10, y: 0}); ",
    "const gw = Math.max(1, Math.round(20 * net.getScale() * r)); ",
    "const gd = ctx.getImageData(Math.round(ga.x * r), 0, gw, cv.height).data; let low = -1; ",
    "for (let y = 0; y < cv.height; y++) { for (let x = 0; x < gw; x++) { ",
    "if (gd[4 * (y * gw + x) + 3] > 60) { low = y; } } } ",
    "out.push((el.getBoundingClientRect().bottom - ",
    "(cv.getBoundingClientRect().top + low / r)).toFixed(1)); ",
    "['Infertile', 'No offspring'].forEach(lab => { ",
    "const id = L.body.nodeIndices.find(i => L.body.nodes[i].options.label === lab); ",
    "if (id === undefined) { out.push('0', 'false'); return; } ",
    "const n = L.body.nodes[id]; const s = n.options.size; ",
    "const a = L.canvasToDOM({x: n.x - s, y: n.y - s}), b = L.canvasToDOM({x: n.x + s, y: n.y + s}); ",
    "const lc = L.canvas.frame.canvas; const lr = lc.width / lc.clientWidth; ",
    "const d = lc.getContext('2d').getImageData(Math.round(a.x * lr), Math.round(a.y * lr), ",
    "Math.round((b.x - a.x) * lr), Math.round((b.y - a.y) * lr)).data; ",
    "let k = 0; for (let i = 0; i < d.length; i += 4) { const al = d[i + 3] / 255; ",
    "if ((0.299 * d[i] + 0.587 * d[i + 1] + 0.114 * d[i + 2]) * al + 255 * (1 - al) < 128) k++; } ",
    "out.push(String(k)); const t = n.labelModule.size; ",
    "out.push(String(L.canvasToDOM({x: t.left + t.width, y: t.top}).x <= lc.clientWidth)); }); ",
    "return out.join('|');"
  ))
  got <- strsplit(session$Runtime$evaluate(js)$result$value, "|",
                  fixed = TRUE)[[1L]]
  expect_length(got, 26L)
  line <- as.integer(got[seq(1L, 21L, by = 3L)])
  bar2 <- as.integer(got[seq(2L, 21L, by = 3L)])
  below <- as.integer(got[seq(3L, 21L, by = 3L)])
  names(line) <- names(bar2) <- names(below) <- ped$id
  marked <- c("C", "F", "G")
  for (id in ped$id) {
    if (id %in% marked) {
      expect_gt(line[[id]], 0L, label = paste(id, "line"))
    } else {
      expect_identical(line[[id]], 0L, label = paste(id, "no line"))
    }
  }
  ## The second bar: the infertile C and G only.
  expect_gt(bar2[["C"]], 0L)
  expect_gt(bar2[["G"]], 0L)
  for (id in setdiff(ped$id, c("C", "G"))) {
    expect_identical(bar2[[id]], 0L, label = paste(id, "no second bar"))
  }
  ## A marked animal's id is below the bars; an unmarked one's is not there.
  for (id in ped$id) {
    if (id %in% marked) {
      expect_gt(below[[id]], 0L, label = paste(id, "id moved"))
    } else {
      expect_identical(below[[id]], 0L, label = paste(id, "id not moved"))
    }
  }
  ## G's moved id is well inside the widget.
  expect_gt(as.numeric(got[[22L]]), 10.0)
  expect_gt(as.integer(got[[23L]]), 0L)
  expect_identical(got[[24L]], "true")
  expect_gt(as.integer(got[[25L]]), 0L)
  expect_identical(got[[26L]], "true")
})
