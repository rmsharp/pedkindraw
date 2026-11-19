## Copyright(c) 2017-2026 R. Mark Sharp
## This file is part of pedkindraw
## pedkindraw's own tests, not copied from nprcgenekeepr (plan Phase G12,
## docs/planning/gaps-and-shared-code-plan.md section 5.1; rulings R131-R132,
## pedkindraw S53). A measured trait in a condition column is drawn by a
## cut-off, conditionThresholds, taken by both builders: each cut-off a
## comparison (>, >=, < or <=) and a number, named by its column; an animal is
## affected where its number passes, unknown where it has none. The rule goes
## into the condition's label, so the legend and the tooltip state it (>= and
## <= as the signs U+2265 and U+2264), and the tooltip gives the number.
## Pedixplorer's generate_aff_inds() decides > and < the same way (its
## threshold with sup_thres_aff TRUE and FALSE), on seeded random numbers.
library(testthat)

## A and B, founders, with offspring C (male) and D (female): the gaps
## document's case measuredTrait (tools/gapCases.R). Each named argument is
## added as a column.
.g12Ped <- function(...) {
  ped <- data.frame(id = c("A", "B", "C", "D"), sire = c(NA, NA, "A", "A"),
                    dam = c(NA, NA, "B", "B"), sex = c("M", "F", "M", "F"),
                    stringsAsFactors = FALSE)
  ped$gen <- findGeneration(ped$id, ped$sire, ped$dam)
  columns <- list(...)
  for (column in names(columns)) ped[[column]] <- columns[[column]]
  ped
}

.g12Fills <- function(nodes, ids = c("A", "B", "C", "D")) {
  nodes$color.background[match(ids, nodes$id)]
}

.g12Pink <- "#CC79A7"
.g12White <- "#FFFFFF"
.g12Grey <- "#BEBEBE"
.g12AtLeast <- "\u2265"
.g12AtMost <- "\u2264"

test_that("makePedigreeMatingLayout() draws a measured trait by its cut-off (case measuredTrait)", {
  layout <- makePedigreeMatingLayout(.g12Ped(affected = c(2.5, 0.0, 0.3, 9.0)),
                                     conditionThresholds = c(affected = "> 5"))
  expect_identical(.g12Fills(layout$nodes),
                   c(.g12White, .g12White, .g12White, .g12Pink))
  expect_identical(layout$conditions$label, "Affected (> 5)")
  legend <- drawPedigreeDiagram(layout)$x$legend$nodes
  expect_identical(legend$label[[6L]], "Affected (> 5)")
  expect_identical(legend[["color.background"]][[6L]], .g12Pink)
})

test_that("each comparison decides an animal whose number is the cut-off", {
  ped <- .g12Ped(affected = c(2.5, 0.0, 5.0, 9.0))
  expected <- list(
    "> 5" = list(fills = c(.g12White, .g12White, .g12White, .g12Pink),
                 label = "Affected (> 5)"),
    ">= 5" = list(fills = c(.g12White, .g12White, .g12Pink, .g12Pink),
                  label = paste0("Affected (", .g12AtLeast, " 5)")),
    "< 5" = list(fills = c(.g12Pink, .g12Pink, .g12White, .g12White),
                 label = "Affected (< 5)"),
    "<= 5" = list(fills = c(.g12Pink, .g12Pink, .g12Pink, .g12White),
                  label = paste0("Affected (", .g12AtMost, " 5)"))
  )
  for (rule in names(expected)) {
    layout <- makePedigreeMatingLayout(ped,
                                       conditionThresholds = c(affected = rule))
    expect_identical(.g12Fills(layout$nodes), expected[[rule]]$fills,
                     label = rule)
    expect_identical(layout$conditions$label, expected[[rule]]$label,
                     label = rule)
  }
})

test_that("the rule goes into a named or numbered condition's label, its number as written", {
  labelOf <- function(column, rule) {
    ped <- .g12Ped()
    ped[[column]] <- c(1.0, 140.0, 13.0, 2.0)
    makePedigreeMatingLayout(
      ped, conditionThresholds = stats::setNames(rule, column)
    )$conditions$label
  }
  expect_identical(labelOf("affected_glucose", ">= 126"),
                   paste0("Affected (glucose ", .g12AtLeast, " 126)"))
  expect_identical(labelOf("affected_glucose", "  >=126 "),
                   paste0("Affected (glucose ", .g12AtLeast, " 126)"))
  expect_identical(labelOf("affected2", "<= 13"),
                   paste0("Affected 2 (", .g12AtMost, " 13)"))
  expect_identical(labelOf("affected", "> 1e2"), "Affected (> 1e2)")
  expect_identical(labelOf("affected", "< -2.5"), "Affected (< -2.5)")
})

test_that("the tooltip gives the rule and each animal's number", {
  layout <- makePedigreeMatingLayout(
    .g12Ped(affected = c(2.5, 0.0, NA, 9.0)),
    conditionThresholds = c(affected = "> 5")
  )
  titles <- layout$nodes$title[match(c("A", "B", "C", "D"), layout$nodes$id)]
  expect_true(all(endsWith(titles, c(
    "<br><b>Affected (&gt; 5):</b> No (2.5)",
    "<br><b>Affected (&gt; 5):</b> No (0)",
    "<br><b>Affected (&gt; 5):</b> Unknown",
    "<br><b>Affected (&gt; 5):</b> Yes (9)"
  ))))
  below <- makePedigreeMatingLayout(.g12Ped(affected = c(1L, 7L, 3L, 9L)),
                                    conditionThresholds = c(affected = "< 4"))
  expect_true(endsWith(below$nodes$title[below$nodes$id == "C"],
                       "<br><b>Affected (&lt; 4):</b> Yes (3)"))
})

test_that("an animal with no number is drawn as unknown, and the legend has its row", {
  layout <- makePedigreeMatingLayout(
    .g12Ped(affected = c(2.5, NA, NaN, 9.0)),
    conditionThresholds = c(affected = "> 5")
  )
  expect_identical(.g12Fills(layout$nodes),
                   c(.g12White, .g12Grey, .g12Grey, .g12Pink))
  expect_identical(drawPedigreeDiagram(layout)$x$legend$nodes$label[6:7],
                   c("Affected (> 5)", "Affected status unknown"))
  ## A column of NA alone, as a file with no numbers gives: every animal
  ## unknown.
  none <- makePedigreeMatingLayout(.g12Ped(affected = NA),
                                   conditionThresholds = c(affected = "> 5"))
  expect_identical(.g12Fills(none$nodes), rep(.g12Grey, 4L))
})

test_that("with several conditions each cut-off decides its own sections", {
  ped <- .g12Ped(affected_glucose = c(140.0, 90.0, 126.0, NA),
                 affected_x = c(TRUE, FALSE, FALSE, TRUE),
                 affected_hb = c(14.0, 11.0, 13.0, 12.5))
  layout <- makePedigreeMatingLayout(
    ped,
    conditionThresholds = c(affected_glucose = ">= 126", affected_hb = "< 13")
  )
  labels <- c(paste0("Affected (glucose ", .g12AtLeast, " 126)"),
              "Affected (x)", "Affected (hb < 13)")
  expect_identical(layout$conditions$label, labels)
  expect_identical(
    layout$nodes$affectedSections[match(ped$id, layout$nodes$id)],
    c("110", "001", "100", "?11")
  )
  expect_identical(drawPedigreeDiagram(layout)$x$legend$nodes$label[6:9],
                   c(labels, "Affected status unknown"))
  title <- layout$nodes$title[layout$nodes$id == "C"]
  expect_true(grepl(paste0("<b>Affected (glucose ", .g12AtLeast,
                           " 126):</b> Yes (126)<br>",
                           "<b>Affected (x):</b> No<br>",
                           "<b>Affected (hb &lt; 13):</b> No (13)"),
                    title, fixed = TRUE))
})

test_that("makePedigreeDiagramData() draws the affected column by its cut-off", {
  ped <- .g12Ped(affected = c(2.5, 0.0, 0.3, 9.0))
  above <- makePedigreeDiagramData(ped,
                                   conditionThresholds = c(affected = "> 5"))
  expect_identical(.g12Fills(above$nodes),
                   c(.g12White, .g12White, .g12White, .g12Pink))
  below <- makePedigreeDiagramData(ped,
                                   conditionThresholds = c(affected = "< 1"))
  expect_identical(.g12Fills(below$nodes),
                   c(.g12White, .g12Pink, .g12Pink, .g12White))
  expect_true(all(endsWith(below$nodes$title, c(
    "<br><b>Affected (&lt; 1):</b> No (2.5)",
    "<br><b>Affected (&lt; 1):</b> Yes (0)",
    "<br><b>Affected (&lt; 1):</b> Yes (0.3)",
    "<br><b>Affected (&lt; 1):</b> No (9)"
  ))))
  unknown <- makePedigreeDiagramData(.g12Ped(affected = c(NA, 1.0, 9.0, NaN)),
                                     conditionThresholds = c(affected = "> 5"))
  expect_identical(.g12Fills(unknown$nodes),
                   c(.g12Grey, .g12White, .g12Pink, .g12Grey))
})

test_that("without a cut-off a measured trait still stops, the message naming conditionThresholds", {
  ped <- .g12Ped(affected = c(2.5, 0.0, 0.3, 9.0))
  advice <- paste0(
    "Give TRUE or FALSE (or 1 or 0) for each animal; for a measured trait, ",
    "give its cut-off in conditionThresholds, such as c(affected = \"> 5\")."
  )
  expect_error(
    makePedigreeMatingLayout(ped),
    paste0("makePedigreeMatingLayout(): the condition column 'affected' ",
           "holds numbers other than 0 and 1 (2.5, 0.3, 9). ", advice),
    fixed = TRUE
  )
  expect_error(
    makePedigreeDiagramData(ped),
    paste0("makePedigreeDiagramData(): the condition column 'affected' ",
           "holds numbers other than 0 and 1 (2.5, 0.3, 9). ", advice),
    fixed = TRUE
  )
  ## The advice names the column: a cut-off for one column leaves another's
  ## numbers to stop.
  two <- .g12Ped(affected = c(2.5, 0.0, 0.3, 9.0), affected2 = c(0, 4, 1, 0))
  expect_error(
    makePedigreeMatingLayout(two, conditionThresholds = c(affected = "> 5")),
    "such as c(affected2 = \"> 5\").", fixed = TRUE
  )
})

test_that("conditionThresholds = NULL, the default, draws as before", {
  expect_null(formals(makePedigreeMatingLayout)$conditionThresholds)
  expect_null(formals(makePedigreeDiagramData)$conditionThresholds)
  for (ped in list(.g12Ped(), .g12Ped(affected = c(TRUE, NA, FALSE, TRUE)),
                   .g12Ped(affected_x = c(1, 0, NA, 1),
                           affected_y = c(FALSE, TRUE, TRUE, NA)))) {
    expect_identical(makePedigreeMatingLayout(ped, conditionThresholds = NULL),
                     makePedigreeMatingLayout(ped))
    expect_identical(makePedigreeDiagramData(ped, conditionThresholds = NULL),
                     makePedigreeDiagramData(ped))
  }
})

test_that("a cut-off on a column a builder does not draw changes nothing", {
  ## The fifth condition column is not drawn (conditionsNotDrawn), so its
  ## cut-off is read and checked but decides nothing.
  ped <- .g12Ped(affected_a = c(TRUE, FALSE, FALSE, TRUE),
                 affected_b = FALSE, affected_c = FALSE, affected_d = FALSE,
                 affected_e = c(2.5, 0.0, 0.3, 9.0))
  layout <- makePedigreeMatingLayout(ped,
                                     conditionThresholds = c(affected_e = "> 5"))
  expect_identical(layout, makePedigreeMatingLayout(ped))
  expect_identical(layout$conditionsNotDrawn, "affected_e")
  ## makePedigreeDiagramData() draws the column affected alone.
  expect_identical(
    makePedigreeDiagramData(ped, conditionThresholds = c(affected_e = "> 5")),
    makePedigreeDiagramData(ped)
  )
})

test_that("both builders stop on a conditionThresholds they cannot use, naming themselves", {
  ped <- .g12Ped(affected = c(2.5, 0.0, 0.3, 9.0),
                 affected_flag = c(TRUE, FALSE, NA, TRUE),
                 affected_text = c("1", "2", "3", "4"))
  form <- paste0("() requires 'conditionThresholds' to be NULL or a ",
                 "character vector named by condition columns, such as ",
                 "c(affected = \"> 5\").")
  unreadable <- paste0("() requires each cut-off in 'conditionThresholds' ",
                       "to be >, >=, < or <= and a number, such as \"> 5\"; ",
                       "cannot read: ")
  cases <- list(
    list(5, form),
    list("> 5", form),
    list(c(affected = NA_character_), form),
    list(stats::setNames(character(0L), character(0L)), form),
    list(stats::setNames("> 5", ""), form),
    list(c(affected = "> 5", affected = "< 1"), form),
    list(list(affected = "> 5"), form),
    list(c(affected = "5"), paste0(unreadable, "\"5\".")),
    list(c(affected = "=> 5"), paste0(unreadable, "\"=> 5\".")),
    list(c(affected = "> five"), paste0(unreadable, "\"> five\".")),
    list(c(affected = "> Inf"), paste0(unreadable, "\"> Inf\".")),
    list(c(affected = "> NaN"), paste0(unreadable, "\"> NaN\".")),
    list(c(affected = "> 5 6"), paste0(unreadable, "\"> 5 6\".")),
    list(c(affected = ""), paste0(unreadable, "\"\".")),
    list(c(affected = "5", affected_flag = "x"),
         paste0(unreadable, "\"5\", \"x\".")),
    list(c(weight = "> 5"),
         paste0("() requires 'conditionThresholds' to name condition ",
                "columns of 'ped' (names starting with 'affected'); not ",
                "one: weight.")),
    list(c(affected_flag = "> 0.5", affected_text = "> 2"),
         paste0("() requires a column with a cut-off in ",
                "'conditionThresholds' to hold numbers; not numbers: ",
                "affected_flag, affected_text."))
  )
  for (case in cases) {
    for (builder in c("makePedigreeMatingLayout", "makePedigreeDiagramData")) {
      expect_error(
        do.call(builder, list(ped, conditionThresholds = case[[1L]])),
        paste0(builder, case[[2L]]), fixed = TRUE,
        label = paste(builder, deparse(case[[1L]]))
      )
    }
  }
})

test_that("a cut-off decides as Pedixplorer's threshold does, on seeded random numbers", {
  skip_if_not_installed("Pedixplorer")
  skip_if_not_installed("withr")
  ## Pedixplorer's generate_aff_inds(): affected strictly above its threshold
  ## (sup_thres_aff = TRUE) or strictly below it (FALSE), NA unknown. So ">"
  ## and "<" are its two, and ">=" and "<=" the opposite of "<" and ">".
  pixel <- c("#CC79A7" = "1", "#FFFFFF" = "0", "#BEBEBE" = "?")
  status <- function(x) ifelse(is.na(x), "?", ifelse(x, "1", "0"))
  compared <- 0L
  for (seed in 1:50) {
    case <- withr::with_seed(seed, {
      ped <- checkPedigreeClean(sample(6L:60L, 1L))
      values <- round(stats::rnorm(nrow(ped), 5, 3))
      values[stats::runif(nrow(ped)) < 0.1] <- NA
      list(ped = ped, values = values,
           cut = sample(values[!is.na(values)], 1L))
    })
    ped <- case$ped
    ped$gen <- findGeneration(ped$id, ped$sire, ped$dam)
    above <- Pedixplorer::generate_aff_inds(case$values, threshold = case$cut,
                                            sup_thres_aff = TRUE,
                                            is_num = TRUE)$affected
    below <- Pedixplorer::generate_aff_inds(case$values, threshold = case$cut,
                                            sup_thres_aff = FALSE,
                                            is_num = TRUE)$affected
    want <- cbind(status(above), status(!below), status(below),
                  status(!above))
    rules <- paste(c(">", ">=", "<", "<="), case$cut)
    ## The layout, one column per comparison: its sections, by animal drawn.
    ## A random pedigree can leave the layout a line it cannot route clear of
    ## a symbol: that warning, and the message naming animals left out, are
    ## the layout's own, not the cut-off's (any other warning still shows).
    for (i in 1:4) ped[[paste0("affected_", i)]] <- case$values
    layout <- withCallingHandlers(
      suppressMessages(makePedigreeMatingLayout(
        ped, conditionThresholds = stats::setNames(rules,
                                                   paste0("affected_", 1:4))
      )),
      warning = function(w) {
        if (grepl("same-row edge-node collision", conditionMessage(w),
                  fixed = TRUE)) {
          invokeRestart("muffleWarning")
        }
      }
    )
    drawn <- match(layout$nodes$id, ped$id)
    sections <- layout$nodes$affectedSections[!is.na(drawn)]
    expect_identical(sections,
                     apply(want[drawn[!is.na(drawn)], , drop = FALSE], 1L,
                           paste, collapse = ""),
                     label = paste("seed", seed, "layout"))
    ## The diagram data, one comparison at a time: its fills, every animal.
    one <- ped[c("id", "sire", "dam", "sex", "gen")]
    one$affected <- case$values
    for (j in 1:4) {
      data <- makePedigreeDiagramData(
        one, conditionThresholds = c(affected = rules[[j]])
      )
      expect_identical(unname(pixel[data$nodes$color.background]),
                       want[, j], label = paste("seed", seed, rules[[j]]))
    }
    compared <- compared + 5L
  }
  expect_identical(compared, 250L)
})

test_that("in a browser, vis.js fills each animal by the cut-off and the legend writes the rule whole", {
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

  label <- paste0("Affected (glucose ", .g12AtLeast, " 126)")
  ped <- .g12Ped(affected_glucose = c(140.0, 90.0, 126.0, NA))
  layout <- makePedigreeMatingLayout(
    ped, conditionThresholds = c(affected_glucose = ">= 126")
  )
  html <- withr::local_tempfile(fileext = ".html")
  htmlwidgets::saveWidget(drawPedigreeDiagram(layout), html,
                          selfcontained = TRUE)
  session$go_to(paste0("file://", html), timeout_ = 30, delay = 0.5)
  expect_true(.waitForLegendPictures(session))
  ## Each animal's colour at its centre; then the legend row with the rule:
  ## its colour, and whether its label ends inside the legend's canvas.
  js <- .pixelReaderJs(paste0(
    "const out = ['A', 'B', 'C', 'D'].map(id => { ",
    "const p = net.getPosition(id); return read(net, p.x, p.y); }); ",
    "const lid = L.body.nodeIndices.find(id => ",
    "L.body.nodes[id].options.label === '", label, "'); ",
    "if (lid === undefined) { out.push('none', 'none'); } else { ",
    "const n = L.body.nodes[lid]; const s = n.labelModule.size; ",
    "const right = L.canvasToDOM({x: s.left + s.width, y: s.top}).x; ",
    "out.push(read(L, n.x, n.y), ",
    "String(right <= L.canvas.frame.canvas.clientWidth)); } ",
    "return out.join('|');"
  ))
  got <- strsplit(session$Runtime$evaluate(js)$result$value, "|",
                  fixed = TRUE)[[1L]]
  expect_length(got, 6L)
  want <- c(.g12Pink, .g12White, .g12Pink, .g12Grey, .g12Pink)
  for (i in 1:5) {
    expect_false(identical(got[[i]], "none"),
                 label = paste("the legend row", label))
    rgb <- suppressWarnings(as.integer(strsplit(got[[i]], ",",
                                                fixed = TRUE)[[1L]]))
    expect_lte(max(abs(rgb - as.integer(grDevices::col2rgb(want[[i]])))),
               10L, label = paste(c("A", "B", "C", "D", "legend")[[i]],
                                  got[[i]]))
  }
  expect_identical(got[[6L]], "true")
})
