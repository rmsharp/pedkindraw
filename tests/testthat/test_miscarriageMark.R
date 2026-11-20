## Copyright(c) 2017-2026 R. Mark Sharp
## This file is part of pedkindraw
## pedkindraw's own tests, not copied from nprcgenekeepr (pedkindraw S59, plan
## Phase G13, gap B3 of docs/research/pedkindraw-gaps-2026-11-18.md; rulings
## R133 and R139). Pedixplorer reads a column miscarriage of four values,
## "SAB" (a spontaneous abortion), "TOP" (a termination of pregnancy), "ECT"
## (an ectopic pregnancy) and "FALSE", and draws a miscarriage as a triangle
## in place of its symbol, a termination's and an ectopic pregnancy's with a
## line across it and an ectopic pregnancy's with "ECT" under it; it reads
## values it does not know as no miscarriage, refuses a miscarriage that is
## a parent or has a fertility mark, and has no legend row. A triangle is
## pedkindraw's symbol for the Unknown sex. Mark's picks (S59): the column
## miscarriage with Pedixplorer's values (also the right spelling
## "spontaneous abortion", which Pedixplorer reads as none; any other value
## stops, NA is not recorded and unmarked, its hover text "Miscarriage:
## Unknown"); a triangle 0.6 the size of the symbol it replaces, the line
## and "ECT" as Pedixplorer draws them, the id moved down into its row, no
## deceased slash, and invisible points that keep the drawing's fit as for a
## full-size symbol; a miscarriage that is a parent or has a fertility mark
## stops; legend rows "Miscarriage", "Termination" and "Ectopic", each its
## triangle, before "Deceased", 45 px each. The looks were measured in
## headless Chrome at 500 px before the picker, and every expected value
## here was computed on a prototype of the change first (Learning 18).
## nprcgenekeepr has no such mark; DIVERGENCE.md records it "at the switch"
## (R98).
library(testthat)

## Five animals: A (a male) and B (a female) are the parents of C (a male), D
## (a female) and E (sex unknown). Each named argument adds a column.
.miscarriagePed <- function(...) {
  ped <- data.frame(
    id = c("A", "B", "C", "D", "E"),
    sire = c(NA, NA, "A", "A", "A"),
    dam = c(NA, NA, "B", "B", "B"),
    sex = c("M", "F", "M", "F", "U"),
    gen = c(0L, 0L, 1L, 1L, 1L),
    stringsAsFactors = FALSE
  )
  extra <- list(...)
  for (name in names(extra)) ped[[name]] <- extra[[name]]
  ped
}

## A field of each of `ids`' own nodes in a layout.
.miscarriageFieldOf <- function(result, field, ids) {
  result$nodes[[field]][match(ids, result$nodes$id)]
}

## The loop pedigree of G2's tests: 8LKBV9 is drawn more than once; 9VGCCV
## and GA204Z have no offspring.
.miscarriageLoopPed <- function(...) {
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

.miscarriageAdvice <- paste0(
  "Give \"SAB\" (a spontaneous abortion), \"TOP\" (a termination of ",
  "pregnancy) or \"ECT\" (an ectopic pregnancy) for each miscarriage, ",
  "FALSE, 0 or \"no\" for an animal that is not one, as Pedixplorer reads ",
  "them, NA where it is not recorded."
)

test_that(
  ".miscarriageMark is a triangle 0.6 of the symbol's size, the id moved 12
   units down, ECT written 10 units high", {
  expect_identical(.miscarriageMark, list(scale = 0.6, idDown = 12L,
                                          textSize = 10L))
})

test_that(
  "makePedigreeMatingLayout gives each node its miscarriage mark, \"\" for
   every other node, in both edge styles, only with the column, and keeps
   each animal's sex shape", {
  ped <- .miscarriagePed(miscarriage = c("FALSE", NA, "SAB", "TOP", "ECT"))
  for (edgeStyle in c("rectilinear", "direct")) {
    result <- makePedigreeMatingLayout(ped, edgeStyle = edgeStyle)
    expect_identical(.miscarriageFieldOf(result, "miscarriage", ped$id),
                     c("", "", "SAB", "TOP", "ECT"), info = edgeStyle)
    expect_identical(.miscarriageFieldOf(result, "shape", ped$id),
                     c("square", "dot", "square", "dot", "triangle"),
                     info = edgeStyle)
    expect_identical(unique(.miscarriageFieldOf(result, "size", ped$id)),
                     25L, info = edgeStyle)
    others <- result$nodes[!result$nodes$id %in% ped$id, ]
    expect_gt(nrow(others), 0L)
    expect_identical(unique(others$miscarriage), "", info = edgeStyle)
    without <- makePedigreeMatingLayout(.miscarriagePed(),
                                        edgeStyle = edgeStyle)
    expect_false("miscarriage" %in% names(without$nodes), info = edgeStyle)
  }
})

test_that(
  "in a pedigree with repeat appearances the marked animals' nodes are
   marked and the repeat, mating-union and routing nodes are not", {
  ped <- .miscarriageLoopPed(miscarriage = c(NA, "FALSE", NA, NA, "FALSE",
                                             NA, "TOP", "SAB"))
  for (edgeStyle in c("rectilinear", "direct")) {
    result <- makePedigreeMatingLayout(ped, edgeStyle = edgeStyle)
    dupIds <- names(result$duplicateToReal)[result$duplicateToReal == "8LKBV9"]
    expect_gte(length(dupIds), 1L)
    expect_identical(.miscarriageFieldOf(result, "miscarriage", ped$id),
                     c("", "", "", "", "", "", "TOP", "SAB"),
                     info = edgeStyle)
    expect_identical(unique(.miscarriageFieldOf(result, "miscarriage",
                                                dupIds)), "",
                     info = edgeStyle)
    expect_true(all(grepl("<b>Miscarriage:</b> No",
                          .miscarriageFieldOf(result, "title", dupIds),
                          fixed = TRUE)), info = edgeStyle)
    others <- result$nodes[!(result$nodes$id %in%
                               c(ped$id, names(result$duplicateToReal))), ]
    expect_true(any(startsWith(others$id, "__union_")), info = edgeStyle)
    expect_identical(unique(others$miscarriage), "", info = edgeStyle)
  }
})

test_that(
  "the hover text says Miscarriage: Spontaneous abortion (SAB), Termination
   of pregnancy (TOP), Ectopic pregnancy (ECT), No or Unknown, after the
   fertility line and before the name, and nothing without the column", {
  ped <- .miscarriagePed(affected = c(TRUE, FALSE, NA, FALSE, TRUE),
                         fertility = c("infertile", NA, "fertile", NA, NA),
                         miscarriage = c("FALSE", NA, "SAB", "TOP", "ECT"),
                         name = c("Ace", "Bea", "Cy", "Di", "Ed"))
  result <- makePedigreeMatingLayout(ped)
  titles <- .miscarriageFieldOf(result, "title", ped$id)
  shown <- c("No", "Unknown", "Spontaneous abortion (SAB)",
             "Termination of pregnancy (TOP)", "Ectopic pregnancy (ECT)")
  for (i in seq_along(titles)) {
    at <- regexpr(paste0("<br><b>Miscarriage:</b> ", shown[[i]], "<br>"),
                  titles[[i]], fixed = TRUE)
    expect_gt(at, regexpr("<b>Fertility:</b>", titles[[i]], fixed = TRUE),
              label = ped$id[[i]])
    expect_lt(at, regexpr("<b>Name:</b>", titles[[i]], fixed = TRUE),
              label = ped$id[[i]])
  }
  ped$miscarriage <- NULL
  without <- makePedigreeMatingLayout(ped)
  expect_false(any(grepl("Miscarriage", without$nodes$title, fixed = TRUE)))
})

test_that(
  "the column reads Pedixplorer's values and words without their spaces and
   in any case, FALSE, 0 and \"no\" as none, as text or a factor, NA, NaN
   and \"NA\" as not recorded", {
  forms <- list(
    logical = list(c(NA, NA, FALSE, NA, FALSE), c("", "", "", "", "")),
    double = list(c(0.0, NA, 0.0, NaN, 0.0), c("", "", "", "", "")),
    integer = list(c(0L, 0L, NA, 0L, 0L), c("", "", "", "", "")),
    codes = list(c("FALSE", NA, "SAB", "TOP", "ECT"),
                 c("", "", "SAB", "TOP", "ECT")),
    words = list(c("no", "0", "spontaneous", "termination", "ectopic"),
                 c("", "", "SAB", "TOP", "ECT")),
    phrases = list(c("NA", "false", "spontaenous abortion", "terminated",
                     "ectopic pregnancy"),
                   c("", "", "SAB", "TOP", "ECT")),
    spelled = list(c(NA, NA, "spontaneous abortion",
                     "termination of pregnancy", "Ectopic Pregnancy"),
                   c("", "", "SAB", "TOP", "ECT")),
    cases = list(c("No", "FALSE", " sab ", "T o P", "eCt"),
                 c("", "", "SAB", "TOP", "ECT")),
    factor = list(factor(c("FALSE", "FALSE", "ECT", NA, "SAB"),
                         levels = c("SAB", "TOP", "ECT", "FALSE")),
                  c("", "", "ECT", "", "SAB"))
  )
  for (form in names(forms)) {
    result <- makePedigreeMatingLayout(
      .miscarriagePed(miscarriage = forms[[form]][[1L]])
    )
    expect_identical(.miscarriageFieldOf(result, "miscarriage",
                                         c("A", "B", "C", "D", "E")),
                     forms[[form]][[2L]], info = form)
  }
  ## NA, NaN and "NA" are not recorded: the hover text says Unknown.
  for (missing in list(NA, NaN, "NA")) {
    result <- makePedigreeMatingLayout(
      .miscarriagePed(miscarriage = c(missing, 0L, NA, NA, NA))
    )
    expect_match(result$nodes$title[[1L]], "<b>Miscarriage:</b> Unknown",
                 fixed = TRUE, info = format(missing))
    expect_match(result$nodes$title[[2L]], "<b>Miscarriage:</b> No",
                 fixed = TRUE, info = format(missing))
  }
})

test_that(
  "every value both read marks as Pedixplorer's miscarriage_to_factor() reads
   it, NA unmarked as Pedixplorer's FALSE is", {
  skip_if_not_installed("Pedixplorer")
  values <- list(
    c("SAB", "TOP", "ECT"),
    c("sab", " Top ", "e c t"),
    c("spontaneous", "termination", "ectopic"),
    c("spontaenous abortion", "terminated", "ectopic pregnancy"),
    c("termination of pregnancy", "FALSE", "no"),
    c("0", "No", NA),
    c("Spontaneous", "TERMINATION OF PREGNANCY", "NA"),
    c(FALSE, NA, FALSE),
    c(0.0, NaN, 0.0)
  )
  markOf <- c(SAB = "SAB", TOP = "TOP", ECT = "ECT", "FALSE" = "")
  for (v in values) {
    theirs <- unname(markOf[as.character(
      Pedixplorer::miscarriage_to_factor(v)
    )])
    result <- makePedigreeMatingLayout(
      .miscarriagePed(miscarriage = c(NA, NA, v))
    )
    expect_identical(.miscarriageFieldOf(result, "miscarriage",
                                         c("C", "D", "E")),
                     theirs, info = toString(v))
  }
})

test_that(
  "a miscarriage column holding anything else stops, naming the column and
   its values, before any animal is left out", {
  expect_error(
    makePedigreeMatingLayout(.miscarriagePed(
      miscarriage = c(NA, NA, TRUE, FALSE, TRUE)
    )),
    paste0("makePedigreeMatingLayout(): the column 'miscarriage' holds ",
           "values it cannot read (TRUE). ", .miscarriageAdvice),
    fixed = TRUE
  )
  expect_error(
    makePedigreeMatingLayout(.miscarriagePed(
      miscarriage = c(0.0, 1.0, 2.0, 0.5, NA)
    )),
    "the column 'miscarriage' holds values it cannot read (1, 2, 0.5)",
    fixed = TRUE
  )
  expect_error(
    makePedigreeMatingLayout(.miscarriagePed(
      miscarriage = c("yes", "TRUE", "miscarriage", "", "SAB")
    )),
    "cannot read ('yes', 'TRUE', 'miscarriage', '')",
    fixed = TRUE
  )
  six <- rbind(.miscarriagePed(miscarriage = c("a", "b", "c", "d", "e")),
               data.frame(id = "F", sire = "A", dam = "B", sex = "M",
                          gen = 1L, miscarriage = "f"))
  expect_error(makePedigreeMatingLayout(six),
               "cannot read ('a', 'b', 'c', 'd', 'e', ...)", fixed = TRUE)
  expect_error(
    makePedigreeMatingLayout(.miscarriagePed(
      miscarriage = as.Date(c("2020-01-01", NA, NA, NA, NA))
    )),
    paste0("the column 'miscarriage' holds values it cannot read (a column ",
           "of class Date)"),
    fixed = TRUE
  )
  ## F has no parent, mate or offspring, so the layout leaves it out; its
  ## value still stops the layout.
  ped <- rbind(.miscarriagePed(miscarriage = c(NA, NA, "SAB", NA, NA)),
               data.frame(id = "F", sire = NA, dam = NA, sex = "M",
                          gen = 0L, miscarriage = "nope"))
  expect_error(suppressMessages(makePedigreeMatingLayout(ped)),
               "the column 'miscarriage' holds values it cannot read ('nope')",
               fixed = TRUE)
})

test_that(
  "a miscarriage that is a sire or dam, or that the fertility column marks
   infertile or with no offspring, stops, naming up to five; fertile or not
   recorded does not", {
  expect_error(
    makePedigreeMatingLayout(.miscarriagePed(
      miscarriage = c("SAB", "ECT", NA, "FALSE", "TOP")
    )),
    paste0("makePedigreeMatingLayout(): the column 'miscarriage' marks A, B, ",
           "each a sire or dam. A miscarriage has no offspring: correct the ",
           "column or the parents."),
    fixed = TRUE
  )
  expect_error(
    makePedigreeMatingLayout(.miscarriagePed(
      fertility = c(NA, NA, "infertile", "fertile", "infertile_choice_na"),
      miscarriage = c(NA, NA, "SAB", "TOP", "ECT")
    )),
    paste0("makePedigreeMatingLayout(): the column 'miscarriage' marks C, E, ",
           "which the column 'fertility' marks infertile or with no ",
           "offspring. A miscarriage has no fertility: give it \"fertile\" ",
           "or NA there."),
    fixed = TRUE
  )
  ## A parent is named first; an infertile parent that is not a miscarriage
  ## is drawn as recorded (R138).
  expect_error(
    makePedigreeMatingLayout(.miscarriagePed(
      fertility = c(NA, NA, "infertile", NA, NA),
      miscarriage = c("TOP", NA, "SAB", NA, NA)
    )),
    "marks A, each a sire or dam", fixed = TRUE
  )
  expect_no_error(result <- makePedigreeMatingLayout(.miscarriagePed(
    fertility = c("infertile", "infertile_choice_na", "fertile", NA, TRUE),
    miscarriage = c(NA, "FALSE", "SAB", "TOP", "ECT")
  )))
  expect_identical(.miscarriageFieldOf(result, "miscarriage", c("C", "D", "E")),
                   c("SAB", "TOP", "ECT"))
  ## Up to five, then "...".
  founders <- paste0("P", 1:6)
  ped <- data.frame(id = c(founders, "K1", "K2", "K3"),
                    sire = c(rep(NA, 6), "P1", "P3", "P5"),
                    dam = c(rep(NA, 6), "P2", "P4", "P6"),
                    sex = c(rep(c("M", "F"), 3), "M", "F", "M"),
                    gen = c(rep(0L, 6), 1L, 1L, 1L),
                    miscarriage = c(rep("SAB", 6), NA, NA, NA),
                    stringsAsFactors = FALSE)
  expect_error(makePedigreeMatingLayout(ped),
               "marks P1, P2, P3, P4, P5, ..., each a sire or dam",
               fixed = TRUE)
  ped$miscarriage <- c(rep(NA, 6), "SAB", "SAB", "SAB")
  ped$fertility <- c(rep(NA, 6), "infertile", NA, "infertile_choice_na")
  expect_error(makePedigreeMatingLayout(ped), "marks K1, K3, which",
               fixed = TRUE)
  ## F has no parent, mate or offspring, so the layout leaves it out; its
  ## fertility still stops the layout.
  ped <- rbind(.miscarriagePed(fertility = NA, miscarriage = NA),
               data.frame(id = "F", sire = NA, dam = NA, sex = "M", gen = 0L,
                          fertility = "infertile", miscarriage = "ECT"))
  expect_error(suppressMessages(makePedigreeMatingLayout(ped)),
               "marks F, which the column 'fertility'", fixed = TRUE)
})

test_that(
  "a Pedixplorer object converted by asPedFrame() is drawn with its marks, the
   column not renamed", {
  skip_if_not_installed("Pedixplorer")
  d <- data.frame(id = c("A", "B", "C", "D", "E"),
                  dadid = c(NA, NA, "A", "A", "A"),
                  momid = c(NA, NA, "B", "B", "B"), sex = c(1, 2, 1, 2, 3),
                  miscarriage = c("FALSE", "FALSE", "SAB", "TOP", "ECT"),
                  stringsAsFactors = FALSE)
  ped <- asPedFrame(Pedixplorer::Pedigree(d))$ped
  expect_true(is.factor(ped$miscarriage))
  ped$gen <- findGeneration(ped$id, ped$sire, ped$dam)
  result <- makePedigreeMatingLayout(ped)
  expect_identical(.miscarriageFieldOf(result, "miscarriage", ped$id),
                   c("", "", "SAB", "TOP", "ECT"))
})

test_that(
  "with every animal left out the layout's empty nodes gain an empty
   miscarriage field only when the pedigree has the column", {
  ped <- data.frame(id = c("A", "B"), sire = NA, dam = NA, sex = c("M", "F"),
                    gen = 0L, stringsAsFactors = FALSE)
  without <- suppressMessages(makePedigreeMatingLayout(ped))
  expect_false("miscarriage" %in% names(without$nodes))
  ped$miscarriage <- c("SAB", NA)
  result <- suppressMessages(makePedigreeMatingLayout(ped))
  expect_identical(nrow(result$nodes), 0L)
  expect_identical(result$nodes$miscarriage, character())
})

test_that(
  "a real id starting __misc_, the prefix of the drawing's points, is
   refused, and the message names the prefix", {
  ped <- .miscarriagePed()
  for (column in c("id", "sire")) {
    ped[[column]][ped[[column]] %in% "A"] <- "__misc_l_A"
  }
  expect_error(makePedigreeMatingLayout(ped), "'__fert_'/'__misc_' prefix",
               fixed = TRUE)
  expect_identical(.reservedIdPrefixes[[length(.reservedIdPrefixes)]],
                   "__misc_")
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
  marks <- c("SAB", "TOP", "ECT", "FALSE", NA)
  compared <- 0L
  marked <- 0L
  for (seed in 1:40) {
    case <- withr::with_seed(seed, {
      ped <- checkPedigreeClean(sample(6L:40L, 1L))
      miscarriage <- sample(marks, nrow(ped), replace = TRUE)
      list(ped = ped, miscarriage = miscarriage)
    })
    ped <- case$ped
    ped$gen <- findGeneration(ped$id, ped$sire, ped$dam)
    parents <- ped$id %in% c(ped$sire, ped$dam)
    miscarriage <- case$miscarriage
    miscarriage[parents] <- "FALSE"
    without <- quietLayout(ped)
    ped$miscarriage <- miscarriage
    with <- quietLayout(ped)
    label <- paste("seed", seed)
    drawn <- with$nodes$id %in% ped$id
    at <- match(with$nodes$id[drawn], ped$id)
    want <- miscarriage[at]
    want[is.na(want) | want == "FALSE"] <- ""
    expect_identical(with$nodes$miscarriage[drawn], want, label = label)
    marked <- marked + sum(want != "")
    keep <- setdiff(names(without$nodes), "title")
    expect_identical(with$nodes[keep], without$nodes[keep], label = label)
    expect_identical(sub("<br><b>Miscarriage:</b> [A-Za-z ()]+", "",
                         with$nodes$title),
                     without$nodes$title, label = label)
    expect_identical(with[names(with) != "nodes"],
                     without[names(without) != "nodes"], label = label)
    compared <- compared + 1L
  }
  expect_identical(compared, 40L)
  expect_gte(marked, 100L)
})

test_that(
  "the lines and ECT are drawn by a handler run last, after the bars, the
   star, the arrows, the carrier's dot and the deceased slash, only when a
   termination or an ectopic pregnancy is drawn", {
  handler <- .miscarriageHandler()
  expect_match(handler, paste0("return n.miscarriage === 'TOP' || ",
                               "n.miscarriage === 'ECT'; "),
               fixed = TRUE)
  expect_match(handler, "var half = s * 1.15, top = p.y - s * 1.0117;",
               fixed = TRUE)
  expect_match(handler, "var base = p.y + s * 0.9802;", fixed = TRUE)
  expect_match(handler, "ctx.moveTo(p.x - half, base);", fixed = TRUE)
  expect_match(handler, "ctx.lineTo(p.x + half, top);", fixed = TRUE)
  expect_match(handler, "ctx.font = '10px arial';", fixed = TRUE)
  expect_match(handler, "ctx.fillText('ECT', p.x, base + 1.5);",
               fixed = TRUE)
  expect_match(handler, "ctx.lineWidth = 2;", fixed = TRUE)
  expect_false(grepl("\"", handler, fixed = TRUE))
  for (sections in c(FALSE, TRUE)) {
    for (marks in c(FALSE, TRUE)) {
      label <- paste("sections", sections, "other marks", marks)
      chained <- .diagramAfterDrawing(sections, .conditionColors, marks,
                                      marks, marks, marks, TRUE)
      slashAt <- regexpr(.deceasedSlashHandler(), chained, fixed = TRUE)
      linesAt <- regexpr(handler, chained, fixed = TRUE)
      expect_gt(slashAt, 0L, label = label)
      expect_gt(linesAt, slashAt, label = label)
      if (marks) {
        for (other in list(.carrierDotHandler(), .probandArrowHandler(),
                           .evaluatedStarHandler(),
                           .infertileBarsHandler())) {
          expect_gt(linesAt, regexpr(other, chained, fixed = TRUE),
                    label = label)
        }
      }
      expect_identical(grepl("affectedSections", chained, fixed = TRUE),
                       sections, label = label)
    }
  }
  expect_identical(.diagramAfterDrawing(FALSE, miscarriage = FALSE),
                   .deceasedSlashHandler())
  expect_false(grepl("n.miscarriage",
                     .diagramAfterDrawing(TRUE, carrier = TRUE, arrows = TRUE,
                                          evaluated = TRUE, infertile = TRUE),
                     fixed = TRUE))
})

test_that(
  ".miscarriageRoom draws each marked node as a triangle 0.6 its size with no
   slash, moves its id 12 units down, and adds two invisible points where a
   full-size triangle's corners are, below the moved id", {
  ped <- .miscarriagePed(affected = c(TRUE, FALSE, FALSE, TRUE, FALSE),
                         affected2 = c(FALSE, TRUE, FALSE, FALSE, TRUE),
                         status = c("DECEASED", "ALIVE", "DECEASED", "ALIVE",
                                    "DECEASED"),
                         genotyped = c(TRUE, FALSE, TRUE, FALSE, FALSE),
                         carrier = c(TRUE, FALSE, FALSE, TRUE, FALSE),
                         proband = c(FALSE, FALSE, TRUE, FALSE, FALSE),
                         evaluated = c(FALSE, TRUE, FALSE, FALSE, TRUE),
                         fertility = c("infertile", NA, NA, "fertile", NA),
                         miscarriage = c(NA, "FALSE", "SAB", NA, "ECT"))
  for (edgeStyle in c("rectilinear", "direct")) {
    nodes <- makePedigreeMatingLayout(ped, edgeStyle = edgeStyle)$nodes
    out <- .miscarriageRoom(nodes)
    n <- nrow(nodes)
    expect_identical(nrow(out), n + 4L, info = edgeStyle)
    expect_identical(out$id[seq_len(n)], nodes$id, info = edgeStyle)
    marked <- nodes$id %in% c("C", "E")
    expect_identical(out$shape[seq_len(n)],
                     ifelse(marked, "triangle", nodes$shape),
                     info = edgeStyle)
    expect_identical(out$size[seq_len(n)], ifelse(marked, 15L, nodes$size),
                     info = edgeStyle)
    expect_identical(out$deceased[seq_len(n)], nodes$deceased & !marked,
                     info = edgeStyle)
    expect_identical(out$font.vadjust[seq_len(n)], ifelse(marked, 12L, 0L),
                     info = edgeStyle)
    room <- out[-seq_len(n), ]
    expect_identical(room$id, c("__misc_l_C", "__misc_l_E", "__misc_r_C",
                                "__misc_r_E"), info = edgeStyle)
    owner <- nodes[match(c("C", "E", "C", "E"), nodes$id), ]
    expect_equal(room$x, owner$x + c(-28.75, -28.75, 28.75, 28.75),
                 info = edgeStyle)
    expect_equal(room$y, owner$y + 15 + 25 + 12 + 2, info = edgeStyle)
    expect_identical(room$size, rep(0L, 4L), info = edgeStyle)
    expect_identical(room$label, rep("", 4L), info = edgeStyle)
    expect_identical(room$shape, rep("dot", 4L), info = edgeStyle)
    expect_identical(room$title, rep(NA_character_, 4L), info = edgeStyle)
    expect_identical(room$miscarriage, rep("", 4L), info = edgeStyle)
    expect_identical(room$fertility, rep("", 4L), info = edgeStyle)
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
    ## The other fields of the nodes are kept.
    kept <- out[seq_len(n), setdiff(names(nodes),
                                   c("shape", "size", "deceased"))]
    rownames(kept) <- NULL
    expect_equal(kept, nodes[setdiff(names(nodes),
                                     c("shape", "size", "deceased"))],
                 info = edgeStyle)
    ## After the arrows', the stars' and the moved ids' points, an infertile
    ## animal's moved id kept: none of theirs is a miscarriage's.
    all <- .miscarriageRoom(.infertileRoom(.evaluatedStarRoom(
      .probandArrowRoom(nodes)
    )))
    expect_identical(all$id[-seq_len(n)],
                     c("__mark_C", "__eval_B", "__eval_E", "__fert_A",
                       "__misc_l_C", "__misc_l_E", "__misc_r_C",
                       "__misc_r_E"),
                     info = edgeStyle)
    expect_identical(all$font.vadjust[seq_len(n)],
                     ifelse(marked, 12L, ifelse(nodes$id == "A", 14L, 0L)),
                     info = edgeStyle)
    expect_identical(unique(all$miscarriage[-seq_len(n)]), "",
                     info = edgeStyle)
  }
})

test_that(
  "the legend's pictures are the small triangle, with the line, and with the
   line and ECT", {
  svgOf <- function(kind) {
    utils::URLdecode(sub("data:image/svg+xml;charset=utf-8,", "",
                         .miscarriageLegendImage(kind), fixed = TRUE))
  }
  open <- "<svg xmlns='http://www.w3.org/2000/svg' width='50' height='50'>"
  triangle <- function(top, base) {
    sprintf(paste0("<path d='M25 %s L42.2 %s L7.8 %s Z' fill='white' ",
                   "stroke='#2B7CE9' stroke-width='2'/>"), top, base, base)
  }
  line <- function(top, base) {
    sprintf(paste0("<line x1='7.8' y1='%s' x2='42.2' y2='%s' ",
                   "stroke='black' stroke-width='2'/>"), base, top)
  }
  expect_identical(svgOf("SAB"),
                   paste0(open, triangle("9.8", "39.7"), "</svg>"))
  expect_identical(svgOf("TOP"),
                   paste0(open, triangle("9.8", "39.7"),
                          line("9.8", "39.7"), "</svg>"))
  expect_identical(svgOf("ECT"),
                   paste0(open, triangle("3.8", "33.7"),
                          line("3.8", "33.7"),
                          "<text x='25' y='49' font-family='Arial' ",
                          "font-size='12' text-anchor='middle'>ECT</text>",
                          "</svg>"))
})

test_that(
  "drawPedigreeDiagram adds Miscarriage, Termination and Ectopic rows before
   Deceased, 45 px each, the small triangles, the moved ids and the points,
   and the handler when a termination or an ectopic pregnancy is drawn", {
  skip_if_not_installed("visNetwork")
  rowsOf <- function(w) w$x$legend$nodes
  sexRows <- c("Female", "Male", "Hermaphrodite", "Unknown",
               "Other / Unrecorded")
  layout <- makePedigreeMatingLayout(
    .miscarriagePed(miscarriage = c("FALSE", NA, "SAB", "TOP", "ECT"))
  )
  w <- drawPedigreeDiagram(layout)
  rows <- rowsOf(w)
  expect_identical(rows$label, c(sexRows, "Affected", "Miscarriage",
                                 "Termination", "Ectopic", "Deceased"))
  three <- rows$label %in% c("Miscarriage", "Termination", "Ectopic")
  expect_identical(rows$shape[three], rep("image", 3L))
  expect_identical(rows$image[three],
                   c(.miscarriageLegendImage("SAB"),
                     .miscarriageLegendImage("TOP"),
                     .miscarriageLegendImage("ECT")))
  expect_identical(w$height, "635px")
  expect_identical(as.character(w$x$events$afterDrawing),
                   .diagramAfterDrawing(FALSE, miscarriage = TRUE))
  expect_identical(w$x$nodes, .miscarriageRoom(layout$nodes))
  expect_identical(w$x$idselection$values, c("A", "B", "C", "D", "E"))
  ## One kind only: its row alone, 545 px; a spontaneous abortion's triangle
  ## has no line, so no handler.
  label <- c(SAB = "Miscarriage", TOP = "Termination", ECT = "Ectopic")
  for (kind in names(label)) {
    one <- drawPedigreeDiagram(makePedigreeMatingLayout(
      .miscarriagePed(miscarriage = c(NA, NA, NA, kind, NA))
    ))
    expect_identical(setdiff(rowsOf(one)$label, c(sexRows, "Affected",
                                                  "Deceased")),
                     label[[kind]], info = kind)
    expect_identical(one$height, "545px", info = kind)
    expect_identical(as.character(one$x$events$afterDrawing),
                     .diagramAfterDrawing(FALSE,
                                          miscarriage = kind != "SAB"),
                     info = kind)
  }
  ## Every row: three conditions, an unknown status, a genotyped animal, a
  ## carrier, a proband, a consultand, an evaluated animal and the two
  ## fertility marks, the three rows after No offspring; the miscarriages'
  ## points come after the others'.
  every <- makePedigreeMatingLayout(
    .miscarriagePed(affected = c(TRUE, FALSE, NA, TRUE, FALSE),
                    affected2 = c(FALSE, TRUE, TRUE, FALSE, FALSE),
                    affected3 = c(TRUE, TRUE, FALSE, FALSE, TRUE),
                    genotyped = c(FALSE, TRUE, FALSE, FALSE, TRUE),
                    carrier = c(FALSE, FALSE, TRUE, FALSE, FALSE),
                    proband = c(FALSE, FALSE, FALSE, TRUE, FALSE),
                    consultand = c(TRUE, FALSE, FALSE, FALSE, FALSE),
                    evaluated = c(TRUE, TRUE, FALSE, FALSE, TRUE),
                    fertility = c("infertile", "infertile_choice_na",
                                  "fertile", NA, NA),
                    miscarriage = c(NA, NA, "SAB", "TOP", "ECT"))
  )
  drawn <- drawPedigreeDiagram(every)
  rows <- rowsOf(drawn)
  expect_identical(rows$label,
                   c(sexRows, "Affected", "Affected 2", "Affected 3",
                     "Affected status unknown", "Genotyped", "Carrier",
                     "Proband", "Consultand", "Evaluated", "Infertile",
                     "No offspring", "Miscarriage", "Termination", "Ectopic",
                     "Deceased"))
  expect_identical(rows$borderWidth[rows$label == "Miscarriage"], 1L)
  expect_identical(drawn$height, "1085px")
  expect_identical(drawn$x$nodes, .miscarriageRoom(.infertileRoom(
    .evaluatedStarRoom(.probandArrowRoom(every$nodes))
  )))
  afterDrawing <- as.character(drawn$x$events$afterDrawing)
  expect_gt(regexpr("n.miscarriage === 'TOP'", afterDrawing, fixed = TRUE),
            regexpr("n.fertility === 'infertile'", afterDrawing,
                    fixed = TRUE))
  expect_match(afterDrawing, "n.evaluated === true", fixed = TRUE)
  expect_match(afterDrawing, "n.proband === true", fixed = TRUE)
  expect_match(afterDrawing, "n.carrier === true", fixed = TRUE)
  expect_match(afterDrawing, "affectedSections", fixed = TRUE)
})

test_that(
  "with no miscarriage the drawing has no row, handler, triangle, moved id,
   point or height for it; without the column the drawing is as before", {
  skip_if_not_installed("visNetwork")
  base <- drawPedigreeDiagram(makePedigreeMatingLayout(.miscarriagePed()))
  for (values in list(c("FALSE", "no", NA, 0, FALSE),
                      c(NA, NA, NA, NA, NA))) {
    layout <- makePedigreeMatingLayout(.miscarriagePed(miscarriage = values))
    w <- drawPedigreeDiagram(layout)
    expect_identical(w$x$legend, base$x$legend)
    expect_identical(w$height, "500px")
    expect_identical(w$x$events, base$x$events)
    expect_identical(w$x$nodes, layout$nodes)
    expect_false("font.vadjust" %in% names(w$x$nodes))
    expect_identical(unique(w$x$nodes$miscarriage), "")
  }
  expect_false(any(c("Miscarriage", "Termination", "Ectopic") %in%
                     base$x$legend$nodes$label))
  expect_identical(as.character(base$x$events$afterDrawing),
                   .diagramAfterDrawing(FALSE))
})

test_that(
  "in a browser, vis.js draws each miscarriage as a small triangle, a deceased
   one without the slash, the line and ECT, each id in its row, long ids
   inside both edges, and the legend rows' triangles", {
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

  ## A sibship, as measured before the picker: CQ01234567 (left, a deceased
  ## spontaneous abortion), D (a termination), E (sex unknown, not a
  ## miscarriage: the full-size triangle), G (a female) and FQ01234567
  ## (right, an ectopic pregnancy), their ids 10 characters long at the
  ## edges, where a small triangle's fit cut them by 6 pixels.
  ids <- c("A", "B", "CQ01234567", "D", "E", "G", "FQ01234567")
  ped <- data.frame(
    id = ids, sire = c(NA, NA, rep("A", 5)), dam = c(NA, NA, rep("B", 5)),
    sex = c("M", "F", "M", "F", "U", "F", "M"),
    gen = c(0L, 0L, rep(1L, 5)),
    status = c("ALIVE", "ALIVE", "DECEASED", "ALIVE", "ALIVE", "ALIVE",
               "ALIVE"),
    miscarriage = c(NA, NA, "SAB", "TOP", "FALSE", NA, "ECT"),
    stringsAsFactors = FALSE
  )
  widget <- drawPedigreeDiagram(makePedigreeMatingLayout(ped))
  widget$width <- "500px"
  html <- withr::local_tempfile(fileext = ".html")
  htmlwidgets::saveWidget(widget, html, selfcontained = TRUE)
  session$go_to(paste0("file://", html), timeout_ = 30, delay = 0.5)
  expect_true(.waitForLegendPictures(session))
  ## For each animal, in units of its drawn size s from its centre: the
  ## width in pixels of its symbol's ink (any drawn pixel, the band from 5
  ## units above its centre to 0.9 s below, so not the line from above);
  ## near-black pixels (the alpha counted, as read() does not, dragon 45)
  ## inside it, where a line or a slash crosses (x within 0.8 s, y from
  ## -0.6 s to 0.8 s); dark pixels in the band under its triangle where
  ## "ECT" is written (x within 10, y from base + 1 to base + 11, base
  ## 0.9802 s below the centre); and the bottom row of its id's ink (below
  ## luminance 128, x within 6, from 1 unit under its symbol to 70 units:
  ## the id is under "ECT", and the long ids' middle characters are digits,
  ## which reach no lower than "D" and "G" do, dragon 54).
  ## Then, in CSS pixels, the room left of the leftmost ink and right of the
  ## rightmost, and below the lowest to the widget's bottom (the canvas
  ## reaches 5.5 pixels below the widget's box). Then the legend's Unknown,
  ## Miscarriage, Termination and Ectopic rows: their pictures' ink widths
  ## and ink (any drawn pixel below luminance 200: the thin blue outline is
  ## lighter than 128 at the legend's zoom), and whether each label ends
  ## inside the canvas.
  js <- .pixelReaderJs(paste0(
    "const out = []; const cv = net.canvas.frame.canvas; ",
    "const r = cv.width / cv.clientWidth; const ctx = cv.getContext('2d'); ",
    "const box = (nw, c, x0, y0, x1, y1) => { const a = nw.canvasToDOM({x: x0, y: y0}); ",
    "const b = nw.canvasToDOM({x: x1, y: y1}); const rr = c.width / c.clientWidth; ",
    "const w = Math.max(1, Math.round((b.x - a.x) * rr)), h = Math.max(1, Math.round((b.y - a.y) * rr)); ",
    "const d = c.getContext('2d').getImageData(Math.round(a.x * rr), Math.round(a.y * rr), w, h).data; ",
    "const px = []; for (let i = 0; i < d.length; i += 4) { const al = d[i + 3] / 255; ",
    "px.push({drawn: d[i + 3] > 60, lum: (0.299 * d[i] + 0.587 * d[i + 1] + 0.114 * d[i + 2]) * al + 255 * (1 - al)}); } ",
    "return {w: w, h: h, px: px}; }; ",
    "const width = q => { let lo = 1e9, hi = -1; q.px.forEach((v, i) => { if (v.drawn && v.lum < 200) { ",
    "const x = i % q.w; lo = Math.min(lo, x); hi = Math.max(hi, x); } }); return hi < 0 ? 0 : hi - lo + 1; }; ",
    "const dark = (q, below) => q.px.filter(v => v.lum < below).length; ",
    "const bottomRow = q => { let last = -1; q.px.forEach((v, i) => { if (v.lum < 128) last = i; }); ",
    "return last < 0 ? -1 : Math.floor(last / q.w); }; ",
    "[", paste0("'", ids, "'", collapse = ", "), "].forEach(id => { ",
    "const p = net.getPosition(id); const s = net.body.nodes[id].options.size; ",
    "const base = p.y + 0.9802 * s; ",
    "out.push(String(width(box(net, cv, p.x - 40, p.y - 5, p.x + 40, p.y + 0.9 * s)))); ",
    "out.push(String(dark(box(net, cv, p.x - 0.8 * s, p.y - 0.6 * s, p.x + 0.8 * s, p.y + 0.8 * s), 60))); ",
    "out.push(String(dark(box(net, cv, p.x - 10, base + 1, p.x + 10, base + 11), 128))); ",
    "const t = net.canvasToDOM({x: p.x, y: p.y + s + 1}); ",
    "out.push(String(t.y * r + bottomRow(box(net, cv, p.x - 6, p.y + s + 1, p.x + 6, p.y + 70)))); }); ",
    "const all = ctx.getImageData(0, 0, cv.width, cv.height).data; let lo = 1e9, hi = -1, low = -1; ",
    "for (let y = 0; y < cv.height; y++) { for (let x = 0; x < cv.width; x++) { ",
    "if (all[4 * (y * cv.width + x) + 3] > 60) { lo = Math.min(lo, x); hi = Math.max(hi, x); low = y; } } } ",
    "out.push((lo / r).toFixed(1), (cv.clientWidth - (hi + 1) / r).toFixed(1)); ",
    "out.push((el.getBoundingClientRect().bottom - ",
    "(cv.getBoundingClientRect().top + (low + 1) / r)).toFixed(1)); ",
    "const lc = L.canvas.frame.canvas; ",
    "['Unknown', 'Miscarriage', 'Termination', 'Ectopic'].forEach(lab => { ",
    "const id = L.body.nodeIndices.find(i => L.body.nodes[i].options.label === lab); ",
    "if (id === undefined) { out.push('0', '0', 'false'); return; } ",
    "const n = L.body.nodes[id]; const s = n.options.size; ",
    "const q = box(L, lc, n.x - 1.3 * s, n.y - s, n.x + 1.3 * s, n.y + s); ",
    "out.push(String(width(q)), String(dark(q, 200))); const t = n.labelModule.size; ",
    "out.push(String(L.canvasToDOM({x: t.left + t.width, y: t.top}).x <= lc.clientWidth)); }); ",
    "return out.join('|');"
  ))
  got <- strsplit(session$Runtime$evaluate(js)$result$value, "|",
                  fixed = TRUE)[[1L]]
  expect_length(got, 4L * 7L + 3L + 12L)
  per <- matrix(as.numeric(got[seq_len(28L)]), nrow = 4L,
                dimnames = list(c("width", "inside", "ect", "idLow"), ids))
  ## A miscarriage's triangle is about 0.6 as wide as the Unknown sex's.
  for (id in c("CQ01234567", "D", "FQ01234567")) {
    expect_gt(per["width", id] / per["width", "E"], 0.5, label = id)
    expect_lt(per["width", id] / per["width", "E"], 0.7, label = id)
  }
  ## A termination's and an ectopic pregnancy's line; nothing across a
  ## spontaneous abortion's, deceased as it is, or E's or G's.
  expect_gt(per["inside", "D"], 0)
  expect_gt(per["inside", "FQ01234567"], 0)
  for (id in c("CQ01234567", "E", "G")) {
    expect_identical(per["inside", id], 0, label = paste(id, "inside"))
  }
  ## ECT under the ectopic pregnancy's triangle only.
  expect_gt(per["ect", "FQ01234567"], 0)
  for (id in c("CQ01234567", "D")) {
    expect_identical(per["ect", id], 0, label = paste(id, "no ECT"))
  }
  ## Each miscarriage's id in the row of G's, within 3 pixels; unmoved it is
  ## about 8 above.
  for (id in c("CQ01234567", "D", "FQ01234567")) {
    expect_lte(abs(per["idLow", id] - per["idLow", "G"]), 3,
               label = paste(id, "id row"))
  }
  room <- as.numeric(got[29:31])
  expect_gt(room[[1L]], 2)
  expect_gt(room[[2L]], 2)
  expect_gt(room[[3L]], 10)
  legend <- matrix(got[32:43], nrow = 3L,
                   dimnames = list(c("width", "ink", "inside"),
                                   c("Unknown", "Miscarriage", "Termination",
                                     "Ectopic")))
  for (lab in c("Miscarriage", "Termination", "Ectopic")) {
    ratio <- as.numeric(legend["width", lab]) /
      as.numeric(legend["width", "Unknown"])
    expect_gt(ratio, 0.5, label = lab)
    expect_lt(ratio, 0.75, label = lab)
    expect_gt(as.integer(legend["ink", lab]), 0L, label = lab)
    expect_identical(legend["inside", lab], "true", label = lab)
  }
  expect_gt(as.integer(legend["ink", "Termination"]),
            as.integer(legend["ink", "Miscarriage"]))
  expect_gt(as.integer(legend["ink", "Ectopic"]),
            as.integer(legend["ink", "Termination"]))
})
