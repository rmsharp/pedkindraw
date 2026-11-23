## Copyright(c) 2017-2026 R. Mark Sharp
## This file is part of pedkindraw
## pedkindraw's own tests, not copied from nprcgenekeepr (pedkindraw S76, plan
## Phase G17c, gap A3 of docs/research/pedkindraw-gaps-2026-11-18.md; rulings
## R148 and R151, docs/planning/pedigree-app-plan.md sections 5, 7 and 13).
## What the app draws: up to four conditions chosen from the file's columns,
## a column of numbers cut at a cut-off (F9); the file's marks and names found
## by name in any case (F11); right-angled or straight lines (F12); a twins
## file (F13). The app reads a file's values with the common words (R151:
## TRUE, T, yes, Y and 1 as yes; FALSE, F, no, N and 0 as no; any case), so a
## condition written 1/0 is no longer drawn unknown with no message, nor a
## mark written so a stop (section 13.1).
##
## Every value stated below was computed first with pedkindraw's functions
## (plan section 13; Learning 18). The server tests run shiny::testServer() on
## typed pedigrees, no browser, so they run on CRAN, and compare each drawing's
## layout with makePedigreeMatingLayout() called directly on the data frame a
## script would give it (identical()). An assignment inside testServer()'s
## code lands in the server's environment (plan dragon 14), so the tests'
## own names there (expected, withGen, fresh, script, expectedTwins) are none
## of the server's. The Chrome test gives the page its files through
## DevTools, as a file dialog does (section 13.3).

## The five animals every mark is drawn on: o3 is a miscarriage.
.appMarksFive <- function() {
  data.frame(id = c("s1", "d1", "o1", "o2", "o3"),
             sire = c(NA, NA, "s1", "s1", "s1"),
             dam = c(NA, NA, "d1", "d1", "d1"),
             sex = c("M", "F", "F", "M", "U"))
}

## The marks of the five as a file writes them, each column's name as a file
## might spell it.
.appMarksFile <- function() {
  file <- .appMarksFive()
  file$Avail <- c("Y", "N", "Y", "N", NA)
  file$Carrier <- c("0", "1", "0", "0", NA)
  file$proband <- c("no", "no", "yes", "no", NA)
  file$consultand <- c("no", "no", "no", "yes", NA)
  file$Evaluated <- c("F", "F", "T", "F", NA)
  file$FERTILITY <- c("fertile", "fertile", "fertile", "infertile", NA)
  file$mis_carriage <- c("no", "no", "no", "no", "SAB")
  file$status <- c("alive", "dead", "alive", "alive", NA)
  file$Name <- c("Sam", "Dot", "Olive", "Oscar", NA)
  file
}

## The same marks as a script gives them to makePedigreeMatingLayout().
.appMarksScript <- function() {
  script <- .appMarksFive()
  script$genotyped <- c(TRUE, FALSE, TRUE, FALSE, NA)
  script$carrier <- c(FALSE, TRUE, FALSE, FALSE, NA)
  script$proband <- c(FALSE, FALSE, TRUE, FALSE, NA)
  script$consultand <- c(FALSE, FALSE, FALSE, TRUE, NA)
  script$evaluated <- c(FALSE, FALSE, TRUE, FALSE, NA)
  script$fertility <- c("fertile", "fertile", "fertile", "infertile", NA)
  script$miscarriage <- c("no", "no", "no", "no", "SAB")
  script$status <- c(NA, "DECEASED", NA, NA, NA)
  script$name <- c("Sam", "Dot", "Olive", "Oscar", NA)
  script
}

.withAppGen <- function(ped) {
  ped$gen <- findGeneration(ped$id, ped$sire, ped$dam)
  ped
}

test_that(".appReadValues() reads the common words in any case as yes and
           no, an empty cell as unknown, and names any other value (R151)", {
  read <- .appReadValues(c("TRUE", "t", "Yes", "Y", "1", "FALSE", "f", "NO",
                           "n", "0", NA, " y ", ""))
  expect_identical(read$values,
                   c(rep(TRUE, 5L), rep(FALSE, 5L), NA, TRUE, NA))
  expect_length(read$unread, 0L)
  read <- .appReadValues(c("affected", "unaffected", "affected", "TRUE", NA))
  expect_identical(read$values, c(NA, NA, NA, TRUE, NA))
  expect_identical(read$unread, c("affected", "unaffected"))
  read <- .appReadValues(c("2.5", "0.3"))
  expect_identical(read$values, c(NA, NA))
  expect_identical(read$unread, c("2.5", "0.3"))
  expect_identical(.appReadValues(factor(c("Y", "N")))$values, c(TRUE, FALSE))
  read <- .appReadValues(character(0L))
  expect_identical(read$values, logical(0L))
  expect_length(read$unread, 0L)
})

test_that(".appReadValues() reads a column of numbers as numbers when asked,
           and keeps a logical or number column given in R", {
  read <- .appReadValues(c("1", "0", NA), numbers = TRUE)
  expect_identical(read$values, c(1, 0, NA))
  expect_length(read$unread, 0L)
  expect_identical(.appReadValues(c("90", NA, " 130", "126", "1e3"),
                                  numbers = TRUE)$values,
                   c(90, NA, 130, 126, 1000))
  expect_identical(.appReadValues(c("1", "yes", "0"), numbers = TRUE)$values,
                   c(TRUE, TRUE, FALSE))
  expect_identical(.appReadValues(c(TRUE, NA, FALSE))$values,
                   c(TRUE, NA, FALSE))
  expect_identical(.appReadValues(c(1, 2.5), numbers = TRUE)$values, c(1, 2.5))
  read <- .appReadValues(c(1, 0, NA))
  expect_identical(read$values, c(TRUE, FALSE, NA))
  expect_length(read$unread, 0L)
  read <- .appReadValues(c(1, 2, 0, 2))
  expect_identical(read$values, c(TRUE, NA, FALSE, NA))
  expect_identical(read$unread, 2)
})

test_that(".appNeedsCutoff() finds a column of numbers other than 0 and 1,
           and .appCutoff() writes a cut-off from a comparison and a number", {
  expect_true(.appNeedsCutoff(c("90", NA, "130")))
  expect_true(.appNeedsCutoff(c(2.5, 0.3)))
  expect_false(.appNeedsCutoff(c("1", "0", NA)))
  expect_false(.appNeedsCutoff(c("yes", "no")))
  expect_false(.appNeedsCutoff(c("affected", "2")))
  expect_false(.appNeedsCutoff(c(TRUE, FALSE)))
  expect_false(.appNeedsCutoff(c(NA, NA)))
  expect_identical(.appCutoff(">=", 126), ">= 126")
  expect_identical(.appCutoff("<=", 0.5), "<= 0.5")
  expect_identical(.appCutoff(NULL, 5), "> 5")
  expect_identical(.appCutoff(">", NA), NA_character_)
  expect_identical(.appCutoff("<", NULL), NA_character_)
})

test_that(".guessAppConditions() takes the first four columns whose names
           begin with 'affected' in any case, and .appConditionNames() names
           each so the layout draws it 'Affected (its name)' (R151)", {
  expect_identical(
    .guessAppConditions(c("id", "affected", "Affected_2", "glucose",
                          "AFFECTED.diabetes", "Affected Status", "affected5",
                          "unaffected")),
    c("affected", "Affected_2", "AFFECTED.diabetes", "Affected Status"))
  expect_identical(.guessAppConditions(c("id", "sire", "glucose")),
                   character(0L))
  expect_identical(.guessAppConditions(character(0L)), character(0L))
  drawnNames <- .appConditionNames(c("glucose", "Affected Status", "affected2",
                                     "Affected", "affected"))
  expect_identical(drawnNames, c("affected_glucose", "affected Status",
                                 "affected2", "affected", "affected_1"))
  expect_identical(.conditionLabels(drawnNames),
                   c("Affected (glucose)", "Affected (Status)", "Affected 2",
                     "Affected", "Affected 1"))
})

test_that(".appFindMarks() finds each mark's column by its name in any case,
           and by Pedixplorer's avail and deceased; .appMarkNote() lists them
           (R151)", {
  marks <- .appFindMarks(c("id", "Avail", "Carrier", "pro band", "consultand",
                           "Evaluated", "FERTILITY", "mis_carriage", "status",
                           "Name", "weight"))
  expect_identical(marks, c(genotyped = "Avail", carrier = "Carrier",
                            proband = "pro band", consultand = "consultand",
                            evaluated = "Evaluated", fertility = "FERTILITY",
                            miscarriage = "mis_carriage", status = "status",
                            name = "Name"))
  expect_identical(.appMarkNote(marks), paste0(
    "Marks from the file: genotyped (column 'Avail'), carrier (column ",
    "'Carrier'), proband (column 'pro band'), consultand, evaluated (column ",
    "'Evaluated'), fertility (column 'FERTILITY'), miscarriage (column ",
    "'mis_carriage'), deceased (column 'status'), name (column 'Name')."))
  expect_identical(.appFindMarks(c("avail", "genotyped", "Deceased", "status")),
                   c(genotyped = "genotyped", status = "status"))
  expect_identical(.appFindMarks(c("Deceased", "carrier")),
                   c(carrier = "carrier", status = "Deceased"))
  none <- .appFindMarks(c("id", "weight"))
  expect_length(none, 0L)
  expect_identical(.appMarkNote(none), "")
})

test_that(".appDeceased() reads DECEASED, deceased, dead and the yes-words as
           DECEASED and anything else as not deceased (R151)", {
  expect_identical(
    .appDeceased(c("DECEASED", "Deceased", "dead", "TRUE", "1", "y", " yes ",
                   "ALIVE", "alive", "0", "SHIPPED", NA, "")),
    c(rep("DECEASED", 7L), rep(NA_character_, 6L)))
  expect_identical(.appDeceased(c(TRUE, FALSE, NA)),
                   c("DECEASED", NA_character_, NA_character_))
  expect_identical(.appDeceased(c(1, 0)), c("DECEASED", NA_character_))
})

test_that(".appReadTwins() finds id1, id2 and code in any case, reads
           Pedixplorer's codes, and says what is missing or empty (R151)", {
  rows <- data.frame(ID_1 = c("a", "b", "c", "d", "e", "f", "g", "h"),
                     id2 = c("A", "B", "C", "D", "E", "F", "G", "H"),
                     Code = c("1", "2", "3", "MZ twin", "dz twin", " UZTwin ",
                              "4", "MZ"),
                     note = "x")
  expect_identical(
    .appReadTwins(rows),
    list(twins = data.frame(id1 = rows$ID_1, id2 = rows$id2,
                            code = c("MZ twin", "DZ twin", "UZ twin",
                                     "MZ twin", "DZ twin", "UZ twin", "Spouse",
                                     "MZ")),
         problem = ""))
  expect_identical(.appReadTwins(NULL), list(twins = NULL, problem = ""))
  expect_identical(
    .appReadTwins(data.frame(id1 = "a", id2 = "b")),
    list(twins = NULL, problem = paste0("The twins file needs the columns ",
                                        "id1, id2 and code; missing: code.")))
  expect_identical(
    .appReadTwins(data.frame(ego1 = "a", ego2 = "b", code = "1"))$problem,
    "The twins file needs the columns id1, id2 and code; missing: id1, id2.")
  expect_identical(
    .appReadTwins(data.frame(id1 = c("a", "c", "e"), id2 = c("b", NA, "f"),
                             code = c("1", "2", NA))),
    list(twins = NULL, problem = "The twins file has empty cells in rows 2, 3."))
  expect_identical(
    .appReadTwins(data.frame(id1 = "a", id2 = NA, code = "1"))$problem,
    "The twins file has an empty cell in row 1.")
  expect_identical(
    .appReadTwins(data.frame(id1 = character(0L), id2 = character(0L),
                             code = character(0L))),
    list(twins = NULL, problem = "The twins file has no pairs."))
})

test_that(".appUnreadWords() names the fertility or miscarriage values
           pedkindraw cannot read, as text when the column is a factor (GREEN
           3, found by covr)", {
  expect_identical(.appUnreadWords(factor(c("fertile", "x", NA, "x", "Steril")),
                                   "fertility"), "x")
  expect_identical(.appUnreadWords(c("S A B", "maybe", NA, "top"),
                                   "miscarriage"), "maybe")
  expect_identical(.appUnreadWords(c(1, 0, 2, NaN), "fertility"), 2)
  fertility <- data.frame(id = c("s1", "d1"), sire = NA, dam = NA,
                          sex = c("M", "F"),
                          fertility = factor(c("x", "fertile")))
  expect_identical(
    .appDrawnPedigree(fertility, character(0L), character(0L),
                      c(fertility = "fertility"))$notes,
    "The column 'fertility' is not drawn: the app cannot read 'x'.")
})

test_that(".appTwinsInView() keeps the pairs both of whose animals are drawn,
           and gives NULL when none is", {
  twins <- data.frame(id1 = c("o1", "s1", "f1"), id2 = c("o2", "d1", "z9"),
                      code = c("DZ twin", "UZ twin", "UZ twin"))
  expect_identical(.appTwinsInView(twins, c("s1", "d1", "o1", "o2")),
                   twins[1:2, ])
  expect_identical(.appTwinsInView(twins, c("d1", "f1", "z9")),
                   data.frame(id1 = "f1", id2 = "z9", code = "UZ twin"))
  expect_null(.appTwinsInView(twins, c("o1", "f1")))
  expect_null(.appTwinsInView(NULL, "o1"))
})

test_that(".appDrawnPedigree() makes the drawing's data frame: the four
           columns, the conditions renamed, the marks under pedkindraw's names,
           and a note for each column not drawn (R151)", {
  rows <- data.frame(id = c("s1", "d1", "o1", "o2"),
                     sire = c(NA, NA, "s1", "s1"), dam = c(NA, NA, "d1", "d1"),
                     sex = c("M", "F", "F", "M"), birth = "2001",
                     Diagnosis = c("affected", "unaffected", NA, NA),
                     glucose = c("90", NA, "130", "126"),
                     sick = c("0", NA, "1", "0"), Avail = c("Y", "N", "Y", "N"),
                     Carrier = c("maybe", "0", "1", "0"),
                     Fert = c("fertile", "x", NA, NA),
                     status = c("alive", "dead", NA, "alive"),
                     Name = c("Sam", "Dot", "Olive", NA))
  marks <- c(genotyped = "Avail", carrier = "Carrier", fertility = "Fert",
             status = "status", name = "Name")
  drawn <- .appDrawnPedigree(rows, c("sick", "Diagnosis", "glucose"),
                             c(sick = NA, Diagnosis = NA, glucose = NA), marks)
  expect_identical(drawn$ped,
                   data.frame(id = rows$id, sire = rows$sire, dam = rows$dam,
                              sex = rows$sex, affected_sick = c(0, NA, 1, 0),
                              genotyped = c(TRUE, FALSE, TRUE, FALSE),
                              status = c(NA, "DECEASED", NA, NA),
                              name = c("Sam", "Dot", "Olive", NA)))
  expect_null(drawn$thresholds)
  expect_identical(drawn$notes, c(
    paste0("The column 'Diagnosis' is not drawn: the app cannot read ",
           "'affected', 'unaffected' as yes or no."),
    paste0("The column 'glucose' is not drawn until it has a cut-off: it ",
           "holds numbers other than 0 and 1."),
    "The column 'Carrier' is not drawn: the app cannot read 'maybe' as yes or no.",
    "The column 'Fert' is not drawn: the app cannot read 'x'."))
  drawn <- .appDrawnPedigree(rows, c("glucose", "sick"),
                             c(glucose = ">= 126", sick = NA), character(0L))
  expect_identical(drawn$ped,
                   data.frame(id = rows$id, sire = rows$sire, dam = rows$dam,
                              sex = rows$sex,
                              affected_glucose = c(90, NA, 130, 126),
                              affected_sick = c(0, NA, 1, 0)))
  expect_identical(drawn$thresholds, c(affected_glucose = ">= 126"))
  expect_identical(drawn$notes, character(0L))
})

test_that(".appDraw() passes the lines, the twins and the cut-offs on, and
           returns the layout", {
  ped <- .appViewsPed()[1:13, ]
  twins <- data.frame(id1 = "o1", id2 = "o2", code = "DZ twin")
  drawn <- .appDraw(ped, edgeStyle = "direct", twinRelations = twins)
  layout <- makePedigreeMatingLayout(.withAppGen(ped), edgeStyle = "direct",
                                     twinRelations = twins)
  expect_identical(drawn$layout, layout)
  expect_identical(drawn$widget,
                   drawPedigreeDiagram(layout, edgeStyle = "direct"))
  expect_identical(drawn$notes, character(0L))
  glucose <- .appFour()
  glucose$affected_glucose <- c(90, NA, 130, 126)
  drawn <- .appDraw(glucose,
                    conditionThresholds = c(affected_glucose = ">= 126"))
  expect_identical(drawn$layout$conditions$label,
                   "Affected (glucose \u2265 126)")
  ownSire <- .appFour()
  ownSire$sire[3L] <- "o1"
  failed <- .appDraw(ownSire)
  expect_identical(names(failed), c("widget", "notes", "error",
                                    "duplicateToReal", "layout"))
  expect_null(failed$layout)
})

test_that("the page has the controls for what is drawn: a twins file,
           conditions, cut-offs, marks and lines", {
  skip_if_not_installed("shiny")
  html <- as.character(.pedigreeAppUi())
  for (id in c("twins", "twinsNote", "twinsProblem", "conditionChoice",
               "cutoffs", "marks", "columnNotes", "lines")) {
    expect_match(html, sprintf("id=\"%s\"", id), fixed = TRUE)
  }
  for (text in c(
    "Twins file (CSV or text): id1, id2, code",
    paste0("<input type=\"radio\" name=\"lines\" value=\"rectilinear\" ",
           "checked=\"checked\"/>"),
    "<span>Right angles</span>", "value=\"direct\"", "<span>Straight</span>"
  )) {
    expect_match(html, text, fixed = TRUE)
  }
})

test_that("a file's conditions written 1/0 and yes/no are guessed and drawn,
           and the user can choose others, or none (R151)", {
  skip_if_not_installed("shiny")
  ped <- .appFour()
  ped$affected <- c("0", NA, "1", "0")
  ped$Diabetes <- c("N", NA, "Y", "Y")
  ped[["Affected Eye"]] <- c("no", NA, "yes", "no")
  file <- .appCsv(ped)
  .appTestServer(.pedigreeAppServer(), {
    session$setInputs(file = file)
    .setAppColumns(session)
    expect_identical(chosenConditions(), c("affected", "Affected Eye"))
    expect_match(output$conditionChoice$html,
                 "<option value=\"affected\" selected>affected</option>",
                 fixed = TRUE)
    expect_match(output$conditionChoice$html,
                 "<option value=\"Diabetes\">Diabetes</option>", fixed = TRUE)
    expected <- .appFour()
    expected$affected <- c(0, NA, 1, 0)
    expected[["affected Eye"]] <- c(FALSE, NA, TRUE, FALSE)
    expect_identical(prepared()$ped, expected)
    expect_identical(drawing()$layout,
                     makePedigreeMatingLayout(.withAppGen(expected)))
    expect_identical(drawing()$layout$conditions$label,
                     c("Affected", "Affected (Eye)"))
    expect_identical(output$columnNotes, "")
    session$setInputs(conditions = c("Diabetes", "affected"))
    expect_identical(prepared()$ped$affected_Diabetes, c(FALSE, NA, TRUE, TRUE))
    expect_identical(drawing()$layout$conditions$label,
                     c("Affected (Diabetes)", "Affected"))
    session$setInputs(conditions = character(0L))
    expect_identical(names(prepared()$ped), c("id", "sire", "dam", "sex"))
    expect_identical(nrow(drawing()$layout$conditions), 0L)
    expect_identical(output$drawn, "4 animals drawn")
  })
})

test_that("a column of numbers chosen as a condition is drawn once it has a
           cut-off, which the legend states (R151)", {
  skip_if_not_installed("shiny")
  ped <- .appFour()
  ped$glucose <- c("90", NA, "130", "126")
  file <- .appCsv(ped)
  .appTestServer(.pedigreeAppServer(), {
    session$setInputs(file = file)
    .setAppColumns(session)
    expect_identical(chosenConditions(), character(0L))
    expect_null(output$cutoffs)
    session$setInputs(conditions = "glucose")
    expect_match(output$cutoffs$html, "Cut-off for glucose", fixed = TRUE)
    expect_match(output$cutoffs$html, "id=\"cutOp5\"", fixed = TRUE)
    expect_match(output$cutoffs$html, "id=\"cutValue5\"", fixed = TRUE)
    expect_identical(output$columnNotes,
                     paste0("The column 'glucose' is not drawn until it has a ",
                            "cut-off: it holds numbers other than 0 and 1."))
    expect_identical(nrow(drawing()$layout$conditions), 0L)
    session$setInputs(cutOp5 = ">=", cutValue5 = 126)
    expect_identical(prepared()$thresholds, c(affected_glucose = ">= 126"))
    expected <- .appFour()
    expected$affected_glucose <- c(90, NA, 130, 126)
    expect_identical(
      drawing()$layout,
      makePedigreeMatingLayout(.withAppGen(expected), conditionThresholds =
                                 c(affected_glucose = ">= 126")))
    expect_identical(drawing()$layout$conditions$label,
                     "Affected (glucose \u2265 126)")
    expect_identical(output$columnNotes, "")
  })
})

test_that("every mark is found by its name in any case, read with the common
           words, listed, and drawn as a script draws it; a mark the app
           cannot read is named and left out (R151)", {
  skip_if_not_installed("shiny")
  file <- .appCsv(.appMarksFile())
  odd <- .appMarksFile()
  odd$Carrier[1L] <- "maybe"
  oddFile <- .appCsv(odd)
  .appTestServer(.pedigreeAppServer(), {
    session$setInputs(file = file)
    .setAppColumns(session)
    expect_identical(markColumns(),
                     c(genotyped = "Avail", carrier = "Carrier",
                       proband = "proband", consultand = "consultand",
                       evaluated = "Evaluated", fertility = "FERTILITY",
                       miscarriage = "mis_carriage", status = "status",
                       name = "Name"))
    expect_identical(output$marks, paste0(
      "Marks from the file: genotyped (column 'Avail'), carrier (column ",
      "'Carrier'), proband, consultand, evaluated (column 'Evaluated'), ",
      "fertility (column 'FERTILITY'), miscarriage (column 'mis_carriage'), ",
      "deceased (column 'status'), name (column 'Name')."))
    expect_identical(prepared()$ped, .appMarksScript())
    expect_identical(drawing()$layout,
                     makePedigreeMatingLayout(.withAppGen(.appMarksScript())))
    expect_identical(output$drawn, "5 animals drawn")
    expect_identical(output$problem, "")
    expect_identical(output$columnNotes, "")
    session$setInputs(file = oddFile)
    .setAppColumns(session)
    expect_identical(output$columnNotes, paste0(
      "The column 'Carrier' is not drawn: the app cannot read 'maybe' as yes ",
      "or no."))
    expect_false("carrier" %in% names(prepared()$ped))
    expect_identical(output$drawn, "5 animals drawn")
    expect_identical(output$problem, "")
  })
})

test_that("'Straight' draws the layout and the drawing direct, as a script
           does; 'Right angles' is the default (R151)", {
  skip_if_not_installed("shiny")
  ped <- .appViewsPed()
  .appTestServer(.pedigreeAppServer(ped), {
    .setAppColumns(session)
    withGen <- .withAppGen(ped)
    expect_identical(drawing()$layout,
                     suppressMessages(makePedigreeMatingLayout(withGen)))
    session$setInputs(lines = "direct")
    direct <- suppressMessages(makePedigreeMatingLayout(withGen,
                                                        edgeStyle = "direct"))
    expect_identical(drawing()$layout, direct)
    expect_identical(drawing()$widget,
                     drawPedigreeDiagram(direct, edgeStyle = "direct",
                                         onClick = .appClickJs))
    expect_identical(output$drawn, "13 animals drawn")
  })
})

test_that("a twins file with kinship2's code numbers is read and drawn, a
           family without the pair is drawn without it, and a problem is said
           and the pedigree drawn without twins (R151)", {
  skip_if_not_installed("shiny")
  ped <- .appViewsPed()
  pedFile <- .appCsv(ped)
  twinsFile <- .appCsv(data.frame(ID1 = "o1", id2 = "o2", code = "2"),
                       name = "twins.csv")
  unknownFile <- .appCsv(data.frame(id1 = "o1", id2 = "x9", code = "DZ twin"),
                         name = "unknown.csv")
  mzFile <- .appCsv(data.frame(id1 = "o1", id2 = "o2", code = "MZ"),
                    name = "mz.csv")
  emptyFile <- .appCsv(data.frame(id1 = "o1", id2 = NA, code = "1"),
                       name = "empty.csv")
  .appTestServer(.pedigreeAppServer(), {
    session$setInputs(file = pedFile)
    .setAppColumns(session)
    session$setInputs(twins = twinsFile)
    expectedTwins <- data.frame(id1 = "o1", id2 = "o2", code = "DZ twin")
    expect_identical(twinsChecked(),
                     list(twins = expectedTwins, problem = ""))
    expect_identical(output$twinsNote, "1 twin pair read from twins.csv.")
    expect_identical(output$twinsProblem, "")
    withGen <- .withAppGen(ped)
    expect_identical(drawing()$layout, suppressMessages(
      makePedigreeMatingLayout(withGen, twinRelations = expectedTwins)))
    session$setInputs(view = "family", family = "2")
    fresh <- data.frame(id = c("f1", "f2", "f3"), sire = c(NA, NA, "f1"),
                        dam = c(NA, NA, "f2"), sex = c("M", "F", "M"))
    expect_identical(drawing()$layout,
                     makePedigreeMatingLayout(.withAppGen(fresh)))
    expect_identical(output$problem, "")
    expect_identical(output$drawn, "3 animals drawn")
    session$setInputs(view = "all", twins = unknownFile)
    expect_identical(output$twinsProblem, paste0(
      "The twins file could not be used: Twin relation id(s) not found in the ",
      "pedigree: x9. The pedigree is drawn without twins."))
    expect_identical(output$twinsNote, "")
    expect_identical(drawing()$layout,
                     suppressMessages(makePedigreeMatingLayout(withGen)))
    session$setInputs(twins = mzFile)
    expect_identical(output$twinsProblem, paste0(
      "The twins file could not be used: Twin relations 'code' must be one of ",
      "MZ twin, DZ twin, UZ twin; invalid value(s): MZ. The pedigree is drawn ",
      "without twins."))
    session$setInputs(twins = emptyFile)
    expect_identical(output$twinsProblem,
                     "The twins file has an empty cell in row 1.")
    expect_identical(output$drawn, "13 animals drawn")
  })
})

test_that("a twins file that cannot be read is said so, and nothing is drawn
           from it (GREEN 3, found by covr)", {
  skip_if_not_installed("shiny")
  pedFile <- .appCsv(.appFour())
  emptyFile <- .appCsv(lines = character(0L), name = "twins.csv")
  .appTestServer(.pedigreeAppServer(), {
    session$setInputs(file = pedFile)
    .setAppColumns(session)
    session$setInputs(twins = emptyFile)
    expect_identical(output$twinsProblem,
                     "The twins file could not be read: no lines available in input")
    expect_identical(output$twinsNote, "")
    expect_identical(output$drawn, "4 animals drawn")
  })
})

test_that("the sample's twins file opens with the sample and is dropped when
           another pedigree file is opened; a twins file the user opened is
           kept (R151)", {
  skip_if_not_installed("shiny")
  pedFile <- .appCsv(.appFour())
  otherFile <- .appCsv(.appMarksFive())
  twinsFile <- .appCsv(data.frame(id1 = "o1", id2 = "o2", code = "3"),
                       name = "twins.csv")
  .appTestServer(.pedigreeAppServer(), {
    session$setInputs(sample = 1L)
    expect_identical(output$twinsNote,
                     "3 twin pairs read from the sample's twins file.")
    session$setInputs(file = pedFile)
    expect_identical(output$twinsNote, "")
    expect_null(twinsRead())
    session$setInputs(twins = twinsFile)
    expect_identical(output$twinsNote, "1 twin pair read from twins.csv.")
    session$setInputs(file = otherFile)
    .setAppColumns(session)
    expect_identical(output$twinsNote, "1 twin pair read from twins.csv.")
    expectedTwins <- data.frame(id1 = "o1", id2 = "o2", code = "UZ twin")
    expect_identical(drawing()$layout, makePedigreeMatingLayout(
      .withAppGen(.appMarksFive()), twinRelations = expectedTwins))
  })
})

test_that("a 'ped' given in R is drawn as a script draws it: a logical
           condition kept, a 0/1 mark read alike (R151)", {
  skip_if_not_installed("shiny")
  ped <- .appFour()
  ped$affected <- c(FALSE, NA, TRUE, FALSE)
  ped$genotyped <- c(0, 0, 1, 1)
  .appTestServer(.pedigreeAppServer(ped), {
    .setAppColumns(session)
    expect_identical(chosenConditions(), "affected")
    script <- .withAppGen(ped)
    expect_identical(drawing()$layout, makePedigreeMatingLayout(script))
    expect_identical(output$marks, "Marks from the file: genotyped.")
    expect_identical(output$columnNotes, "")
  })
})

test_that("in Chrome, a pedigree file and a twins file given to the page, two
           conditions with a cut-off and straight lines chosen with the page's
           controls, are drawn as R draws them (G17c, R151)", {
  skip_on_cran()
  skip_if_not_installed("shiny")
  skip_if_not_installed("callr")
  skip_if_no_chrome()
  folder <- withr::local_tempdir()
  file <- .appMarksFile()
  file$affected <- c("0", "0", "1", "0", NA)
  file$glucose <- c("90", NA, "130", "126", NA)
  pedPath <- file.path(folder, "pedigree.csv")
  utils::write.csv(file, pedPath, row.names = FALSE, na = "")
  twinsPath <- file.path(folder, "twins.csv")
  utils::write.csv(data.frame(id1 = "o1", id2 = "o2", code = "2"), twinsPath,
                   row.names = FALSE)
  script <- .appMarksFive()
  script$affected <- c(0, 0, 1, 0, NA)
  script$affected_glucose <- c(90, NA, 130, 126, NA)
  marks <- .appMarksScript()
  script <- cbind(script, marks[, setdiff(names(marks), names(script))])
  twins <- data.frame(id1 = "o1", id2 = "o2", code = "DZ twin")
  layout <- makePedigreeMatingLayout(
    .withAppGen(script), edgeStyle = "direct", twinRelations = twins,
    conditionThresholds = c(affected_glucose = ">= 126"))
  widget <- drawPedigreeDiagram(layout, edgeStyle = "direct")
  animals <- layout$nodes[!startsWith(layout$nodes$id, "__"), ]
  idsWhere <- function(keep) paste(sort(animals$id[keep]), collapse = ",")
  pageIdsWhere <- function(test) {
    sprintf(paste0("HTMLWidgets.find('#diagram').network.body.data.nodes.get()",
                   ".filter(n => !n.id.startsWith('__') && (%s))",
                   ".map(n => n.id).sort().join()"), test)
  }
  app <- .startPedigreeApp()
  page <- .appPage(app$url)
  .appSetFile(page, "file", pedPath)
  .appWaitFor(page, paste0("document.getElementById('drawn').innerText === ",
                           "'5 animals drawn'"))
  .appSetFile(page, "twins", twinsPath)
  .appWaitFor(page, paste0("document.getElementById('twinsNote').innerText ",
                           "=== '1 twin pair read from twins.csv.'"))
  .appJs(page, paste0("$('#conditions')[0].selectize.setValue(['affected', ",
                      "'glucose']); true"))
  cut <- match("glucose", names(file))
  .appWaitFor(page, sprintf("!!document.getElementById('cutValue%d')", cut))
  .appJs(page, sprintf(paste0("$('#cutOp%1$d')[0].selectize.setValue('>='); ",
                              "$('#cutValue%1$d').val(126).trigger('change'); ",
                              "true"), cut))
  .appJs(page, paste0("document.querySelector('input[name=lines]",
                      "[value=direct]').click(); true"))
  .appWaitFor(page, sprintf(paste0(
    "(function() { const w = HTMLWidgets.find('#diagram'); return !!(w && ",
    "w.network && w.network.body.data.nodes.length === %d && ",
    "w.network.body.data.edges.length === %d); })()"),
    nrow(widget$x$nodes), nrow(widget$x$edges)))
  .appWaitFor(page, paste0(
    "HTMLWidgets.find('#diagram').network.body.data.nodes.get(['o1'])[0]",
    ".affectedSections === '11'"))
  expect_identical(.appJs(page, pageIdsWhere("n.borderWidth === 4")),
                   idsWhere(animals$borderWidth == 4))
  expect_identical(.appJs(page, pageIdsWhere("n.carrier === true")),
                   idsWhere(animals$carrier))
  expect_identical(.appJs(page, pageIdsWhere("n.deceased === true")),
                   idsWhere(animals$deceased))
  expect_identical(.appJs(page, pageIdsWhere("n.affectedSections === '11'")),
                   idsWhere(animals$affectedSections == "11"))
  expect_equal(
    .appJs(page, paste0("HTMLWidgets.find('#diagram').network.body.data.",
                        "edges.get().filter(e => e.label === 'DZ').length")),
    sum(widget$x$edges$label == "DZ", na.rm = TRUE))
  expect_identical(.appJs(page,
                          "document.getElementById('problem').innerText"), "")
  expect_identical(.appJs(page,
                          "document.getElementById('columnNotes').innerText"),
                   "")
})
