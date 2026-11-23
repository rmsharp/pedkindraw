## Copyright(c) 2017-2026 R. Mark Sharp
## This file is part of pedkindraw
## pedkindraw's own tests, not copied from nprcgenekeepr (pedkindraw S74, plan
## Phase G17a, gap A3 of docs/research/pedkindraw-gaps-2026-11-18.md; rulings
## R148 and R149, docs/planning/pedigree-app-plan.md sections 7, 8 and 11).
## The app in Chrome: runPedigreeApp() runs in a second R process that loads
## the pedkindraw under test (from source under test_local(), installed under
## R CMD check; helper-pedigreeApp.R), and the shared headless Chrome opens its
## page. They show what testServer() cannot: the page's own controls sending
## their values, and the drawing in the browser. Skipped on CRAN and where no
## browser is found. The process is killed when each test ends.
##
## The sample's numbers (375 animals, 1,460 nodes, one note on 72 same-row
## collisions) were measured with pedkindraw's functions before RED (plan
## section 11.4); the node count is compared with drawPedigreeDiagram()'s, run
## here on the same rows.
##
## pedkindraw S75 (G17b, R150): the click test sends real mouse clicks through
## Chrome's DevTools (.appClickNode(), helper-pedigreeApp.R), as a user clicks;
## testServer() cannot show the focal box the server writes to (finding 4).
##
## pedkindraw S76 (G17c, R151): "Use the sample pedigree" opens the sample's
## twins file too, so the sample test expects the sample drawn with its 3 twin
## pairs (1,466 nodes, measured; 1,460 without them) and reads the page's
## twins line. This change belonged in RED; GREEN's first run found it.

.appSkips <- function() {
  skip_on_cran()
  skip_if_not_installed("shiny")
  skip_if_not_installed("callr")
  skip_if_no_chrome()
}

test_that("the sample, opened in the app in Chrome, is drawn as
           drawPedigreeDiagram() draws it, with the layout's note shown", {
  .appSkips()
  app <- .startPedigreeApp()
  page <- .appPage(app$url)
  .appJs(page, "document.getElementById('sample').click(); true")
  .appWaitFor(page, paste0("document.getElementById('drawn').innerText === ",
                           "'375 animals drawn'"))
  expect_identical(
    .appJs(page, paste0("['idColumn', 'sireColumn', 'damColumn', 'sexColumn']",
                        ".map(i => document.getElementById(i).value).join()")),
    "id,sire,dam,sex")
  .appWaitFor(page, paste0("(function() { const w = HTMLWidgets.find(",
                           "'#diagram'); return !!(w && w.network && ",
                           "w.network.body.data.nodes.length > 0); })()"))
  shown <- .appJs(page, paste0("HTMLWidgets.find('#diagram').network.body.",
                               "data.nodes.length"))
  sample <- utils::read.csv(
    system.file("extdata", "obfuscated_rhesus_mhc_ped.csv",
                package = "pedkindraw"),
    colClasses = "character", na.strings = c("", "NA"))
  sample <- sample[, c("id", "sire", "dam", "sex")]
  sample$gen <- findGeneration(sample$id, sample$sire, sample$dam)
  twins <- utils::read.csv(
    system.file("extdata", "obfuscated_rhesus_mhc_twin_relations.csv",
                package = "pedkindraw"), colClasses = "character")
  expect_warning(layout <- makePedigreeMatingLayout(sample,
                                                    twinRelations = twins),
                 "72 same-row edge-node collision(s)", fixed = TRUE)
  expect_equal(shown, nrow(drawPedigreeDiagram(layout)$x$nodes))
  expect_identical(.appJs(page,
                          "document.getElementById('twinsNote').innerText"),
                   "3 twin pairs read from the sample's twins file.")
  expect_match(.appJs(page, "document.getElementById('notes').innerText"),
               "72 same-row edge-node collision(s) could not be fully resolved",
               fixed = TRUE)
  expect_identical(.appJs(page,
                          "document.getElementById('problem').innerText"), "")
  app$process$kill()
  expect_false(app$process$is_alive())
})

test_that("in Chrome, a click on a repeat or an animal makes it the focal
           animal, written in the focal box, and a click on a mating dot does
           nothing (G17b, R150)", {
  .appSkips()
  app <- .startPedigreeApp(.appViewsPed())
  page <- .appPage(app$url)
  animalsInPage <- paste0("HTMLWidgets.find('#diagram').network.body.data.",
                          "nodes.get().filter(n => !n.id.startsWith('__'))",
                          ".length")
  .appWaitFor(page, paste0("document.getElementById('drawn').innerText === ",
                           "'13 animals drawn'"))
  .appWaitFor(page, paste0("(function() { const w = HTMLWidgets.find(",
                           "'#diagram'); return !!(w && w.network && ",
                           "w.network.body.data.nodes.length > 0); })()"))
  .appClickNode(page, "__dup_s1_1")
  .appWaitFor(page, "document.getElementById('focal').value === 's1'")
  expect_identical(
    .appJs(page, "document.querySelector('input[name=view]:checked').value"),
    "all")
  expect_identical(.appJs(page, "document.getElementById('drawn').innerText"),
                   "13 animals drawn")
  .appJs(page, paste0("document.querySelector('input[name=view]",
                      "[value=lineal]').click(); true"))
  .appWaitFor(page, paste0("document.getElementById('drawn').innerText === ",
                           "'8 animals drawn'"))
  .appWaitFor(page, paste0(animalsInPage, " === 8"))
  .appClickNode(page, "g1")
  .appWaitFor(page, "document.getElementById('focal').value === 'g1'")
  .appWaitFor(page, paste0("document.getElementById('drawn').innerText === ",
                           "'7 animals drawn'"))
  .appWaitFor(page, paste0(animalsInPage, " === 7"))
  dot <- .appJs(page, paste0("HTMLWidgets.find('#diagram').network.body.data.",
                             "nodes.getIds().filter(i => ",
                             "i.startsWith('__union_'))[0]"))
  .appClickNode(page, dot)
  Sys.sleep(1)
  expect_identical(.appJs(page, "document.getElementById('focal').value"),
                   "g1")
  expect_identical(.appJs(page, "document.getElementById('drawn').innerText"),
                   "7 animals drawn")
})

test_that("a 'ped' given to runPedigreeApp() is drawn when the page opens", {
  .appSkips()
  ped <- .appFour()
  ped$sex <- c("male", "female", "female", "male")
  app <- .startPedigreeApp(ped)
  page <- .appPage(app$url)
  .appWaitFor(page, paste0("document.getElementById('drawn').innerText === ",
                           "'4 animals drawn'"))
  expect_identical(.appJs(page,
                          "document.getElementById('sexNote').innerText"),
                   paste0("Sex values read as pedkindraw's codes: male as M, ",
                          "female as F."))
  expect_identical(
    .appJs(page, paste0("HTMLWidgets.find('#diagram').network.body.data.",
                        "nodes.get().filter(n => !n.id.startsWith('__'))",
                        ".map(n => n.id).sort().join()")),
    "d1,o1,o2,s1")
})
