## Copyright(c) 2017-2026 R. Mark Sharp
## This file is part of pedkindraw
## pedkindraw's own tests, not copied from nprcgenekeepr (pedkindraw S74, plan
## Phase G17a, gap A3 of docs/research/pedkindraw-gaps-2026-11-18.md; rulings
## R148 and R149, docs/planning/pedigree-app-plan.md sections 5, 7 and 11).
## The app's first slice: it opens a CSV or text file (F1), the sample
## pedigree (F3) or the 'ped' given to runPedigreeApp(); recognises the id,
## sire, dam and sex columns and lets the user choose them (F4, R149); reads
## the common sex codes (R149); adds 'gen'; draws everyone, showing what the
## layout says (finding 2); and shows checkPedigree()'s problems (F5) and the
## animals (F18).
##
## Every value stated below was computed first with pedkindraw's functions
## (plan section 11.4; Learning 18). The tests run the server with
## shiny::testServer(), no browser, so they run on CRAN. testServer() computes
## every output at each change, read or not (section 11.2), so these tests use
## pedigrees of a few animals and load the 375-animal sample without choosing
## its columns, which draws nothing; the sample is drawn in the browser test
## (test_pedigreeAppBrowser.R).
##
## pedkindraw S75 (G17b, R150): a parent with no row of its own is now added
## with addParents() and the pedigree drawn; the test of a sire with no row
## said "could not be drawn" before, and an animal its own sire now tests a
## pedigree that cannot be drawn (S75 GREEN, found by covr: no other test
## reached that message). G17b's own tests are in test_pedigreeAppViews.R.
##
## pedkindraw S97 (backlog item "What 17m's check of NEWS found outside NEWS",
## its first finding; Mark's pick "Read all three"): the page says "CSV or
## text", and a file whose values are separated by tabs or semicolons is read
## as the same file separated by commas, the separator the one that splits
## the file's first line into the most columns outside quotes (commas on a
## tie); a file of one column is said "1 column". Each value was computed
## first on a scratch prototype (Learning 18); the twins file is tested in
## test_pedigreeAppMarks.R.

test_that(".guessAppColumns() recognises both apps' names, ignoring case,
           spaces, dots and underscores", {
  expect_identical(.guessAppColumns(c("id", "sire", "dam", "sex")),
                   c(id = "id", sire = "sire", dam = "dam", sex = "sex"))
  expect_identical(.guessAppColumns(c("Ego", "Father", "MOTHER", "gender",
                                      "birth")),
                   c(id = "Ego", sire = "Father", dam = "MOTHER",
                     sex = "gender"))
  expect_identical(.guessAppColumns(c("ego_id", "Sire.ID", "Dam ID", "Sex")),
                   c(id = "ego_id", sire = "Sire.ID", dam = "Dam ID",
                     sex = "Sex"))
  expect_identical(.guessAppColumns(c("indId", "dadid", "momid", "GENDER")),
                   c(id = "indId", sire = "dadid", dam = "momid",
                     sex = "GENDER"))
  expect_identical(.guessAppColumns(c("sex", "motherid", "fatherid", "indid")),
                   c(id = "indid", sire = "fatherid", dam = "motherid",
                     sex = "sex"))
  expect_identical(.guessAppColumns(c("EgoID", "SireID", "DamID", "sex")),
                   c(id = "EgoID", sire = "SireID", dam = "DamID",
                     sex = "sex"))
})

test_that(".guessAppColumns() takes the earlier name in its list, the first
           of two columns with one name, and NA where no column matches", {
  expect_identical(.guessAppColumns(c("indid", "id", "father", "sire", "x")),
                   c(id = "id", sire = "sire", dam = NA_character_,
                     sex = NA_character_))
  expect_identical(.guessAppColumns(c("ID", "id", "sire", "dam", "sex")),
                   c(id = "ID", sire = "sire", dam = "dam", sex = "sex"))
  none <- c(id = NA_character_, sire = NA_character_, dam = NA_character_,
            sex = NA_character_)
  expect_identical(.guessAppColumns(character(0L)), none)
  expect_identical(.guessAppColumns(c("animal", "parent1", "parent2")), none)
})

test_that(".readSexCodes() reads the common codes as M, F, H and U and
           leaves any other value as it is", {
  expect_identical(
    .readSexCodes(c("m", "F", "male", "Female", "1", "2", "h",
                    "Hermaphrodite", "u", "UNKNOWN", "U", "M", NA, "x", "3",
                    " f ", "")),
    c("M", "F", "M", "F", "M", "F", "H", "H", "U", "U", "U", "M", NA, "x",
      "3", "F", ""))
  expect_identical(.readSexCodes(c(1, 2, 2)), c("M", "F", "F"))
  expect_identical(.readSexCodes(factor(c("male", "female"))), c("M", "F"))
  expect_identical(.readSexCodes(character(0L)), character(0L))
})

test_that(".sexCodeNote() says which values were read as which code, in the
           order they first appear, and nothing when none changed", {
  expect_identical(.sexCodeNote(c("1", "2", "2", "1")),
                   "Sex values read as pedkindraw's codes: 1 as M, 2 as F.")
  expect_identical(.sexCodeNote(c("male", "F", "m", NA, "x", "male")),
                   "Sex values read as pedkindraw's codes: male as M, m as M.")
  expect_identical(.sexCodeNote(c("M", "F", "H", "U", NA, "x")), "")
  expect_identical(.sexCodeNote(character(0L)), "")
})

test_that("the app's page has its controls and three tabs", {
  skip_if_not_installed("shiny")
  html <- as.character(.pedigreeAppUi())
  for (id in c("file", "sample", "columns", "sexNote", "drawn", "problem",
               "notes", "diagram", "checkSummary", "checks", "table")) {
    expect_match(html, sprintf("id=\"%s\"", id), fixed = TRUE)
  }
  for (tab in c("Diagram", "Checks", "Animals")) {
    expect_match(html, sprintf("data-value=\"%s\"", tab), fixed = TRUE)
  }
  expect_match(html, "Use the sample pedigree", fixed = TRUE)
})

test_that("a file with other column names and 1/2 sex codes is read, its
           columns recognised, and its 4 animals drawn", {
  skip_if_not_installed("shiny")
  birth <- c("2001-01-01", "2001-02-01", "2005-03-01", "2006-04-01")
  file <- .appCsv(data.frame(ego = c("s1", "d1", "o1", "o2"),
                             father = c(NA, NA, "s1", "s1"),
                             mother = c(NA, NA, "d1", "d1"),
                             gender = c(1L, 2L, 2L, 1L), birth = birth))
  .appTestServer(.pedigreeAppServer(), {
    session$setInputs(file = file)
    expect_identical(nrow(rawData()), 4L)
    expect_identical(columnGuess(), c(id = "ego", sire = "father",
                                      dam = "mother", sex = "gender"))
    expect_match(output$columns$html,
                 "<option value=\"ego\" selected>ego</option>", fixed = TRUE)
    expect_match(output$columns$html,
                 "<option value=\"gender\" selected>gender</option>",
                 fixed = TRUE)
    .setAppColumns(session, "ego", "father", "mother", "gender")
    expect_identical(pedigree(),
                     data.frame(id = c("s1", "d1", "o1", "o2"),
                                sire = c(NA, NA, "s1", "s1"),
                                dam = c(NA, NA, "d1", "d1"),
                                sex = c("M", "F", "F", "M"), birth = birth))
    expect_identical(output$sexNote,
                     "Sex values read as pedkindraw's codes: 1 as M, 2 as F.")
    expect_identical(output$drawn, "4 animals drawn")
    expect_identical(output$problem, "")
    expect_identical(output$notes, "")
    expect_identical(nrow(checks()), 0L)
    expect_identical(output$checkSummary, "No problems found.")
    expect_match(output$table, "<td> o2 </td>", fixed = TRUE)
  })
})

test_that("the columns the user chooses are read as id, sire, dam and sex,
           and a column whose name one of them takes is dropped", {
  skip_if_not_installed("shiny")
  colour <- c("red", "blue", "red", "blue")
  file <- .appCsv(data.frame(id = 1:4, name = c("s1", "d1", "o1", "o2"),
                             sire = c(NA, NA, "s1", "s1"),
                             dam = c(NA, NA, "d1", "d1"),
                             sex = c("M", "F", "F", "M"), colour = colour))
  .appTestServer(.pedigreeAppServer(), {
    session$setInputs(file = file)
    expect_identical(columnGuess()[["id"]], "id")
    .setAppColumns(session, id = "name")
    expect_identical(pedigree(),
                     data.frame(id = c("s1", "d1", "o1", "o2"),
                                sire = c(NA, NA, "s1", "s1"),
                                dam = c(NA, NA, "d1", "d1"),
                                sex = c("M", "F", "F", "M"), colour = colour))
    expect_identical(output$sexNote, "")
    expect_identical(output$drawn, "4 animals drawn")
  })
})

test_that("a column not recognised is left for the user to choose, and the
           app asks for it", {
  skip_if_not_installed("shiny")
  file <- .appCsv(data.frame(animal = c("s1", "d1", "o1", "o2"),
                             sire = c(NA, NA, "s1", "s1"),
                             dam = c(NA, NA, "d1", "d1"),
                             sex = c("M", "F", "F", "M")))
  .appTestServer(.pedigreeAppServer(), {
    session$setInputs(file = file)
    expect_identical(columnGuess()[["id"]], NA_character_)
    expect_match(output$columns$html,
                 "<option value=\"\" selected>(choose)</option>",
                 fixed = TRUE)
    .setAppColumns(session, id = "")
    expect_identical(output$problem,
                     "Choose a column for each of id, sire, dam and sex.")
    expect_identical(output$drawn, "")
    .setAppColumns(session, id = "animal")
    expect_identical(output$problem, "")
    expect_identical(output$drawn, "4 animals drawn")
  })
})

test_that("one column chosen for two of id, sire, dam and sex is refused", {
  skip_if_not_installed("shiny")
  file <- .appCsv(.appFour())
  .appTestServer(.pedigreeAppServer(), {
    session$setInputs(file = file)
    .setAppColumns(session, dam = "sire")
    expect_identical(output$problem,
                     "Choose a different column for each of id, sire, dam and sex.")
    expect_error(pedigree(), "Choose a different column", fixed = TRUE)
    expect_identical(output$drawn, "")
  })
})

test_that("a file with fewer than four columns, an empty file and a file with
           no animals are each said so", {
  skip_if_not_installed("shiny")
  threeColumns <- .appCsv(.appFour()[, c("id", "sire", "dam")])
  empty <- .appCsv(lines = character(0L))
  headerOnly <- .appCsv(lines = "id,sire,dam,sex")
  .appTestServer(.pedigreeAppServer(), {
    session$setInputs(file = threeColumns)
    expect_identical(output$problem,
                     paste0("The file has 3 columns; the app needs at least ",
                            "four: id, sire, dam and sex."))
    session$setInputs(file = empty)
    expect_identical(output$problem,
                     "The file could not be read: no lines available in input")
    expect_null(rawData())
    session$setInputs(file = headerOnly)
    expect_identical(output$problem, "The file has no animals.")
    expect_identical(output$drawn, "")
  })
})

test_that("a file separated by tabs or by semicolons is read as the same file
           separated by commas (S97)", {
  four <- .appFour()
  comma <- .readAppFile(.appCsv(four)$datapath)
  expect_identical(comma$problem, "")
  expect_identical(dim(comma$data), c(4L, 4L))
  for (sep in c("\t", ";")) {
    read <- .readAppFile(.appCsv(lines = .appSeparated(four, sep))$datapath)
    expect_identical(read, comma)
  }
})

test_that("the separator is the one that splits the first line into the most
           columns, outside quotes, commas on a tie; a file of one column is
           said '1 column' (S97)", {
  ## Five semicolons in the quoted name: counted without the quotes, the
  ## semicolons would split the line into 6 columns and the commas into 5.
  name <- "weight; kg; at; one; year; mean"
  quoted <- .appCsv(lines = c(sprintf('id,sire,dam,sex,"%s"', name),
                              's1,,,M,"10;5"', 'd1,,,F,"9\t2"'))
  read <- .readAppFile(quoted$datapath)
  expect_identical(read$problem, "")
  expect_identical(names(read$data), c("id", "sire", "dam", "sex", name))
  expect_identical(read$data[[5L]], c("10;5", "9\t2"))
  tie <- .readAppFile(.appCsv(lines = c("a,b;c", "1,2;3"))$datapath)
  expect_identical(tie$data, data.frame(a = "1", "b;c" = "2;3",
                                        check.names = FALSE))
  one <- .readAppFile(.appCsv(lines = c("id", "a", "b"))$datapath)
  expect_identical(one$data, data.frame(id = c("a", "b")))
  expect_identical(.appTableProblem(one$data, one$problem),
                   paste0("The file has 1 column; the app needs at least ",
                          "four: id, sire, dam and sex."))
})

test_that("a sire with no row is added and named and the pedigree drawn; the
           Checks tab still names the sire (R150)", {
  skip_if_not_installed("shiny")
  ped <- .appFour()
  ped$sire[4L] <- "s9"
  file <- .appCsv(ped)
  .appTestServer(.pedigreeAppServer(), {
    session$setInputs(file = file)
    .setAppColumns(session)
    expect_identical(output$added,
                     paste0("Parents with no row of their own, added so the ",
                            "pedigree can be drawn: s9."))
    expect_identical(output$drawn, "5 animals drawn")
    expect_identical(output$problem, "")
    expect_identical(output$notes, "")
    expect_identical(checks(),
                     data.frame(check = "rowlessParents", id = "s9",
                                detail = "sire of o2"))
    expect_identical(output$checkSummary, "1 problem found.")
    expect_match(output$checks, "<td> rowlessParents </td>", fixed = TRUE)
    expect_match(output$table, "<td> s9 </td>", fixed = TRUE)
    expect_match(output$table, "<td> added </td>", fixed = TRUE)
  })
})

test_that("an animal its own sire stops the drawing; the app says so, shows
           what findGeneration() said, and the Checks tab names it", {
  skip_if_not_installed("shiny")
  ped <- .appFour()
  ped$sire[3L] <- "o1"
  .appTestServer(.pedigreeAppServer(ped), {
    .setAppColumns(session)
    expect_identical(output$drawn, "")
    expect_identical(output$problem,
                     paste0("The pedigree could not be drawn (missing value ",
                            "where TRUE/FALSE needed). The Checks tab lists ",
                            "the records' problems."))
    expect_match(output$notes,
                 paste0("findGeneration: 1 id(s) could not be assigned a ",
                        "generation"), fixed = TRUE)
    expect_identical(output$added, "")
    expect_identical(checks()$check, c("ownParent", "femaleSires"))
    expect_identical(output$checkSummary, "2 problems found.")
  })
})

test_that("a male dam is drawn, and the Checks tab names her", {
  skip_if_not_installed("shiny")
  ped <- .appFour()
  ped$sex[2L] <- "M"
  file <- .appCsv(ped)
  .appTestServer(.pedigreeAppServer(), {
    session$setInputs(file = file)
    .setAppColumns(session)
    expect_identical(output$drawn, "4 animals drawn")
    expect_identical(output$problem, "")
    expect_identical(checks(),
                     data.frame(check = "maleDams", id = "d1",
                                detail = "dam of o1, o2"))
    expect_identical(output$checkSummary, "1 problem found.")
  })
})

test_that("an animal the layout leaves out is counted out, and the layout's
           message is shown", {
  skip_if_not_installed("shiny")
  file <- .appCsv(.appFour()[1L, ])
  .appTestServer(.pedigreeAppServer(), {
    session$setInputs(file = file)
    .setAppColumns(session)
    expect_identical(output$drawn, "0 animals drawn")
    expect_identical(output$problem, "")
    expect_identical(output$notes,
                     paste0("makePedigreeMatingLayout(): 1 individual(s) with ",
                            "no recorded parents, mates, or offspring ",
                            "suppressed from the pedigree diagram: s1"))
  })
})

test_that("the sample pedigree is opened with its four columns recognised", {
  skip_if_not_installed("shiny")
  .appTestServer(.pedigreeAppServer(), {
    session$setInputs(sample = 1L)
    expect_identical(dim(rawData()), c(375L, 8L))
    expect_identical(names(rawData()),
                     c("id", "sire", "dam", "sex", "gen", "birth", "exit",
                       "age"))
    expect_identical(columnGuess(),
                     c(id = "id", sire = "sire", dam = "dam", sex = "sex"))
    expect_identical(output$problem, "")
  })
})

test_that("a 'ped' given to the app is opened as a file is: its four columns
           read as text, its sex codes read, its other columns kept", {
  skip_if_not_installed("shiny")
  ped <- data.frame(id = 1:4, sire = c(NA, NA, 1L, 1L), dam = c(NA, NA, 2L, 2L),
                    sex = c("male", "female", "female", "male"),
                    weight = c(10.5, 8.25, 3, 3.5))
  .appTestServer(.pedigreeAppServer(ped), {
    expect_identical(rawData(), ped)
    expect_identical(columnGuess(),
                     c(id = "id", sire = "sire", dam = "dam", sex = "sex"))
    .setAppColumns(session)
    expect_identical(pedigree(),
                     data.frame(id = c("1", "2", "3", "4"),
                                sire = c(NA, NA, "1", "1"),
                                dam = c(NA, NA, "2", "2"),
                                sex = c("M", "F", "F", "M"),
                                weight = c(10.5, 8.25, 3, 3.5)))
    expect_identical(output$sexNote,
                     paste0("Sex values read as pedkindraw's codes: male as M, ",
                            "female as F."))
    expect_identical(output$drawn, "4 animals drawn")
  })
})
