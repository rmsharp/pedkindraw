## Copyright(c) 2017-2026 R. Mark Sharp
## This file is part of pedkindraw
## pedkindraw's own tests, not copied from nprcgenekeepr (pedkindraw S74, plan
## Phase G17a, gap A3 of docs/research/pedkindraw-gaps-2026-11-18.md; rulings
## R148 and R149, docs/planning/pedigree-app-plan.md sections 5 and 11).
## runPedigreeApp(ped = NULL, port = NULL, launch.browser = interactive())
## starts the app and waits until it is closed. These tests start no app:
## shiny::runApp() is replaced by a stand-in that returns what it was given,
## and each call runs under a time limit, so a replacement that did not take
## fails instead of waiting for ever. They need shiny, not a browser, and run
## on CRAN.

.runStandIn <- function(appDir, port, launch.browser) {
  list(app = appDir, port = port, launch.browser = launch.browser)
}

test_that("runPedigreeApp() stops, naming shiny, when shiny is not
           installed", {
  mockery::stub(runPedigreeApp, "requireNamespace", FALSE)
  mockery::stub(runPedigreeApp, "shiny::runApp", .runStandIn)
  expect_error(.appTimeLimit(runPedigreeApp(launch.browser = FALSE)),
               paste0("runPedigreeApp() needs the 'shiny' package; install ",
                      "it with install.packages(\"shiny\")."),
               fixed = TRUE)
})

test_that("runPedigreeApp() stops when 'ped' is not a data frame", {
  skip_if_not_installed("shiny")
  mockery::stub(runPedigreeApp, "shiny::runApp", .runStandIn)
  four <- .appFour()
  for (bad in list(as.list(four), as.matrix(four), "pedigree.csv", 1L)) {
    expect_error(.appTimeLimit(runPedigreeApp(bad, launch.browser = FALSE)),
                 paste0("'ped' must be a data frame with the columns id, ",
                        "sire, dam and sex."), fixed = TRUE)
  }
})

test_that("runPedigreeApp() stops, naming each column 'ped' lacks", {
  skip_if_not_installed("shiny")
  mockery::stub(runPedigreeApp, "shiny::runApp", .runStandIn)
  four <- .appFour()
  expect_error(.appTimeLimit(runPedigreeApp(four[, c("id", "sire", "dam")],
                                            launch.browser = FALSE)),
               "'ped' lacks the column(s): sex.", fixed = TRUE)
  expect_error(.appTimeLimit(runPedigreeApp(four[, "id", drop = FALSE],
                                            launch.browser = FALSE)),
               "'ped' lacks the column(s): sire, dam, sex.", fixed = TRUE)
  names(four)[1L] <- "ego"
  expect_error(.appTimeLimit(runPedigreeApp(four, launch.browser = FALSE)),
               "'ped' lacks the column(s): id.", fixed = TRUE)
})

test_that("runPedigreeApp() stops when 'ped' has no rows", {
  skip_if_not_installed("shiny")
  mockery::stub(runPedigreeApp, "shiny::runApp", .runStandIn)
  expect_error(.appTimeLimit(runPedigreeApp(.appFour()[0L, ],
                                            launch.browser = FALSE)),
               "'ped' has no rows.", fixed = TRUE)
})

test_that("runPedigreeApp() stops unless 'port' is NULL or one whole number
           from 1 to 65535", {
  skip_if_not_installed("shiny")
  mockery::stub(runPedigreeApp, "shiny::runApp", .runStandIn)
  for (bad in list("8000", 8000.5, c(8000L, 8001L), NA_integer_, NA, 0L,
                   65536L, -1L, integer(0L), TRUE)) {
    expect_error(.appTimeLimit(runPedigreeApp(port = bad,
                                              launch.browser = FALSE)),
                 "'port' must be NULL or one whole number from 1 to 65535.",
                 fixed = TRUE)
  }
})

test_that("runPedigreeApp() stops unless 'launch.browser' is TRUE or
           FALSE", {
  skip_if_not_installed("shiny")
  mockery::stub(runPedigreeApp, "shiny::runApp", .runStandIn)
  for (bad in list(NA, "yes", c(TRUE, FALSE), 1L, NULL, logical(0L))) {
    expect_error(.appTimeLimit(runPedigreeApp(launch.browser = bad)),
                 "'launch.browser' must be TRUE or FALSE.", fixed = TRUE)
  }
})

test_that("runPedigreeApp() hands shiny::runApp() the app, the port and
           launch.browser, and returns what runApp() returns, invisibly", {
  skip_if_not_installed("shiny")
  mockery::stub(runPedigreeApp, "shiny::runApp", .runStandIn)
  expect_invisible(.appTimeLimit(runPedigreeApp(port = 8123L,
                                                launch.browser = FALSE)))
  given <- .appTimeLimit(runPedigreeApp(port = 8123L, launch.browser = TRUE))
  expect_s3_class(given$app, "shiny.appobj")
  expect_identical(given$port, 8123L)
  expect_true(given$launch.browser)
  expect_identical(.appTimeLimit(runPedigreeApp(port = 8124,
                                                launch.browser = TRUE))$port,
                   8124)
})

test_that("runPedigreeApp()'s defaults: no ped, shiny's choice of port, and a
           browser opened only in an interactive session", {
  skip_if_not_installed("shiny")
  expect_identical(formals(runPedigreeApp),
                   as.pairlist(alist(ped = NULL, port = NULL,
                                     launch.browser = interactive())))
  mockery::stub(runPedigreeApp, "shiny::runApp", .runStandIn)
  given <- .appTimeLimit(runPedigreeApp())
  expect_null(given$port)
  expect_identical(given$launch.browser, interactive())
})

test_that("the app runPedigreeApp() starts opens the 'ped' it was given", {
  skip_if_not_installed("shiny")
  mockery::stub(runPedigreeApp, "shiny::runApp", .runStandIn)
  ped <- .appFour()
  ped$colour <- c("red", "blue", "red", "blue")
  app <- .appTimeLimit(runPedigreeApp(ped, launch.browser = FALSE))$app
  .appTestServer(app, {
    expect_identical(rawData(), ped)
    .setAppColumns(session)
    expect_identical(output$drawn, "4 animals drawn")
  })
})
