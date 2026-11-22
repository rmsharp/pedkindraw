## Copyright(c) 2017-2026 R. Mark Sharp
## This file is part of pedkindraw
## pedkindraw's own tests, not copied from nprcgenekeepr (pedkindraw S75, plan
## Phase G17b, gap A3 of docs/research/pedkindraw-gaps-2026-11-18.md; rulings
## R148 and R150, docs/planning/pedigree-app-plan.md sections 5, 7 and 12).
## Choosing the animals the app draws: everyone, one family (F6), focal
## animals with their ancestors and descendants (F7) or their near relatives
## (F8), the focal animals typed or clicked (F15), a question before a large
## drawing (F19), and a parent with no row of its own added (R150).
##
## Every value stated below was computed first with pedkindraw's functions
## (plan section 12; Learning 18). The server tests run shiny::testServer() on
## .appViewsPed()'s 14 animals (helper-pedigreeApp.R), no browser, so they run
## on CRAN; the click in Chrome is in test_pedigreeAppBrowser.R. In
## testServer() the focal box does not change when the server writes to it
## (plan finding 4), so the server tests read the animals chosen, shown().

test_that(".appFocalIds() splits typed ids at commas, semicolons, spaces,
           tabs and new lines, keeping each once, in order", {
  expect_identical(.appFocalIds("o1, s1;d1\tz1\n g1  o1\r\n"),
                   c("o1", "s1", "d1", "z1", "g1"))
  expect_identical(.appFocalIds(" a "), "a")
  expect_identical(.appFocalIds(""), character(0L))
  expect_identical(.appFocalIds(" \n ;, "), character(0L))
  expect_identical(.appFocalIds(NULL), character(0L))
})

test_that(".appFamilyChoices() lists the families of two or more animals,
           largest first, and .appAloneNote() counts the others", {
  ped <- .appViewsPed()
  family <- findPedigreeNumber(ped$id, ped$sire, ped$dam)
  expect_identical(family, c(rep(1L, 10L), 2L, 2L, 2L, 3L))
  expect_identical(.appFamilyChoices(family),
                   c("Family 1: 10 animals" = "1", "Family 2: 3 animals" = "2"))
  expect_identical(.appFamilyChoices(c(2L, 2L, 1L, 1L, 3L)),
                   c("Family 1: 2 animals" = "1", "Family 2: 2 animals" = "2"))
  expect_identical(.appFamilyChoices(c(3L, 1L, 3L, 3L, 1L)),
                   c("Family 3: 3 animals" = "3", "Family 1: 2 animals" = "1"))
  expect_length(.appFamilyChoices(c(NA, NA)), 0L)
  expect_length(.appFamilyChoices(c(1L, 2L)), 0L)
  expect_identical(.appAloneNote(family),
                   "1 animal has no relative in the file and is not listed.")
  expect_identical(.appAloneNote(c(1L, 2L, 3L, 3L)),
                   paste0("2 animals have no relative in the file and are ",
                          "not listed."))
  expect_identical(.appAloneNote(seq_len(1001L)),
                   paste0("1,001 animals have no relative in the file and are ",
                          "not listed."))
  expect_identical(.appAloneNote(c(1L, 1L, NA, NA)), "")
})

test_that(".appLineal() keeps the focal animals' ancestors and descendants
           and adds each other parent of theirs, its own parents not shown", {
  ped <- .appViewsPed()
  expected <- ped[c(1L, 2L, 4L, 9L, 10L), ]
  expected$sire[4L] <- NA
  expected$dam[4L] <- NA
  expect_identical(.appLineal(ped, "o1"), expected)
  keep <- union(trimPedigree(ped, "s1")$id,
                getDescendantPedigree(ped, "s1")$id)
  expect_identical(keep, c("s1", "o1", "o2", "o3", "g1"))
  lineal <- .appLineal(ped, "s1")
  expect_identical(lineal$id,
                   c("s1", "d1", "d2", "o1", "o2", "o3", "m1", "g1"))
  expect_identical(lineal[lineal$id %in% keep, ], ped[ped$id %in% keep, ])
  added <- lineal[!lineal$id %in% keep, ]
  expect_identical(added$id, c("d1", "d2", "m1"))
  expect_true(all(is.na(added$sire) & is.na(added$dam)))
  expect_identical(.appLineal(ped, c("o3", "f3"))$id,
                   c("s1", "d2", "o3", "f1", "f2", "f3"))
  expect_identical(.appLineal(ped, "g1"), ped[c(1L, 2L, 4L, 7L, 8L, 9L, 10L), ])
})

test_that(".appClickedAnimals() reads a click: an animal is itself, a repeat
           its animal, and a mating dot, a routing point or nothing is no
           animal", {
  repeats <- c("__dup_s1_1" = "s1", "__dup_o1_1" = "o1")
  expect_identical(.appClickedAnimals("o1", repeats), "o1")
  expect_identical(.appClickedAnimals(list("g1"), repeats), "g1")
  expect_identical(.appClickedAnimals("__dup_s1_1", repeats), "s1")
  expect_identical(.appClickedAnimals(c("o1", "__dup_o1_1"), repeats), "o1")
  for (point in c("__union_1", "__drop___union_1", "__bar_o1", "__jog_1_a")) {
    expect_identical(.appClickedAnimals(point, repeats), character(0L))
  }
  expect_identical(.appClickedAnimals(list(), repeats), character(0L))
  expect_identical(.appClickedAnimals(NULL, repeats), character(0L))
  expect_identical(.appClickedAnimals("s1", NULL), "s1")
})

test_that(".appAddParents() adds a row for each parent with no row of its
           own, with addParents(), and names them", {
  four <- .appFour()
  expect_identical(.appAddParents(four),
                   list(ped = four, added = character(0L)))
  four$sire[4L] <- "s9"
  four$dam[4L] <- "d9"
  added <- .appAddParents(four)
  expect_identical(added$ped, addParents(four))
  expect_identical(added$added, c("s9", "d9"))
  expect_identical(added$ped$sex[5:6], c("M", "F"))
})

test_that(".appDraw() gives the drawing the app's click code and returns the
           layout's repeats", {
  js <- paste0("function(n) { Shiny.setInputValue('clicked', n.nodes, ",
               "{priority: 'event'}); }")
  expect_identical(.appClickJs, js)
  drawn <- .appDraw(.appViewsPed(), onClick = js)
  expect_identical(drawn$duplicateToReal,
                   c("__dup_s1_1" = "s1", "__dup_o1_1" = "o1"))
  expect_identical(as.character(drawn$widget$x$events$click), js)
  expect_null(.appDraw(.appViewsPed())$widget$x$events$click)
})

test_that("the page has the controls for choosing the animals", {
  skip_if_not_installed("shiny")
  html <- as.character(.pedigreeAppUi())
  for (id in c("view", "familyChoice", "focal", "focalNote", "howClose",
               "added", "large")) {
    expect_match(html, sprintf("id=\"%s\"", id), fixed = TRUE)
  }
  for (text in c(
    "<input type=\"radio\" name=\"view\" value=\"all\" checked=\"checked\"/>",
    "<span>Everyone</span>", "value=\"family\"", "<span>One family</span>",
    "value=\"lineal\"",
    "<span>Focal animals with their ancestors and descendants</span>",
    "value=\"near\"", "<span>Focal animals' near relatives</span>",
    paste0("<input id=\"howClose\" type=\"number\" class=\"shiny-input-number ",
           "form-control\" value=\"3\" data-update-on=\"change\" min=\"1\" ",
           "step=\"1\"/>")
  )) {
    expect_match(html, text, fixed = TRUE)
  }
})

test_that("everyone is drawn until another choice is made, with nothing said
           about focal animals or added parents", {
  skip_if_not_installed("shiny")
  .appTestServer(.pedigreeAppServer(.appViewsPed()), {
    .setAppColumns(session)
    expect_identical(shown(), pedigree())
    expect_identical(output$drawn, "13 animals drawn")
    expect_identical(output$focalNote, "")
    expect_identical(output$added, "")
    expect_null(output$large)
  })
})

test_that("'One family' lists the families and draws the one chosen; the
           Animals tab shows the animals chosen", {
  skip_if_not_installed("shiny")
  ped <- .appViewsPed()
  .appTestServer(.pedigreeAppServer(ped), {
    .setAppColumns(session)
    session$setInputs(view = "family")
    expect_match(output$familyChoice$html,
                 "<option value=\"1\" selected>Family 1: 10 animals</option>",
                 fixed = TRUE)
    expect_match(output$familyChoice$html,
                 "<option value=\"2\">Family 2: 3 animals</option>",
                 fixed = TRUE)
    expect_no_match(output$familyChoice$html, "Family 3", fixed = TRUE)
    expect_match(output$familyChoice$html,
                 "1 animal has no relative in the file and is not listed.",
                 fixed = TRUE)
    session$setInputs(family = "2")
    expect_identical(shown(), ped[11:13, ])
    expect_identical(output$drawn, "3 animals drawn")
    expect_match(output$table, "<td> f3 </td>", fixed = TRUE)
    expect_no_match(output$table, "<td> s1 </td>", fixed = TRUE)
    session$setInputs(family = "1")
    expect_identical(output$drawn, "10 animals drawn")
  })
})

test_that("'Focal animals with their ancestors and descendants' draws them
           with their other parents, and names ids not in the pedigree", {
  skip_if_not_installed("shiny")
  ped <- .appViewsPed()
  .appTestServer(.pedigreeAppServer(ped), {
    .setAppColumns(session)
    session$setInputs(view = "lineal")
    expect_identical(output$focalNote, paste0("Type the id of a focal animal, ",
                                              "or click one in the drawing."))
    expect_identical(output$drawn, "")
    expect_identical(output$problem, "")
    session$setInputs(focal = "zz, o1")
    expect_identical(output$focalNote, "Not in the pedigree: zz.")
    expect_identical(shown(), .appLineal(pedigree(), "o1"))
    expect_identical(shown()$id, c("s1", "d1", "o1", "m1", "g1"))
    expect_identical(output$drawn, "5 animals drawn")
    expect_match(output$table, "<td> m1 </td>", fixed = TRUE)
    expect_no_match(output$table, "<td> ms </td>", fixed = TRUE)
    session$setInputs(focal = "o3\nf3")
    expect_identical(output$focalNote, "")
    expect_identical(output$drawn, "6 animals drawn")
    session$setInputs(focal = "zz yy")
    expect_identical(output$focalNote, "Not in the pedigree: zz, yy.")
    expect_identical(output$drawn, "")
  })
})

test_that("a click makes the animal clicked the only focal animal, a repeat
           meaning its animal, and leaves the view as it was", {
  skip_if_not_installed("shiny")
  ped <- .appViewsPed()
  .appTestServer(.pedigreeAppServer(ped), {
    .setAppColumns(session)
    expect_match(drawing()$widget$x$events$click,
                 "Shiny.setInputValue('clicked', n.nodes", fixed = TRUE)
    session$setInputs(clicked = "__dup_s1_1")
    expect_identical(output$drawn, "13 animals drawn")
    session$setInputs(view = "lineal")
    expect_identical(shown()$id,
                     c("s1", "d1", "d2", "o1", "o2", "o3", "m1", "g1"))
    expect_identical(output$drawn, "8 animals drawn")
    session$setInputs(clicked = "g1")
    expect_identical(shown(), ped[c(1L, 2L, 4L, 7L, 8L, 9L, 10L), ])
    expect_identical(output$drawn, "7 animals drawn")
    session$setInputs(clicked = "__union_1")
    expect_identical(output$drawn, "7 animals drawn")
    session$setInputs(clicked = list())
    expect_identical(shown()$id, c("s1", "d1", "o1", "ms", "md", "m1", "g1"))
    session$setInputs(focal = "o3")
    expect_identical(shown()$id, c("s1", "d2", "o3"))
    expect_identical(output$drawn, "3 animals drawn")
  })
})

test_that("'Focal animals' near relatives' draws getNearRelativePedigree()'s
           animals, 3 steps unless another number is chosen", {
  skip_if_not_installed("shiny")
  .appTestServer(.pedigreeAppServer(.appViewsPed()), {
    .setAppColumns(session)
    session$setInputs(view = "near", focal = "o1")
    expect_identical(shown(), getNearRelativePedigree(pedigree(), "o1", 3))
    expect_identical(output$drawn, "7 animals drawn")
    session$setInputs(howClose = 2)
    expect_identical(shown()$id, c("s1", "d1", "o1", "o2", "g1"))
    expect_identical(output$drawn, "5 animals drawn")
    session$setInputs(howClose = 1)
    expect_identical(output$drawn, "3 animals drawn")
    session$setInputs(howClose = NA)
    expect_identical(output$problem, "Choose how close: a number, 1 or more.")
    expect_identical(output$drawn, "")
    session$setInputs(howClose = 0)
    expect_identical(output$problem, "Choose how close: a number, 1 or more.")
    expect_identical(output$drawn, "")
  })
})

test_that("animals that cannot be chosen are said so", {
  skip_if_not_installed("shiny")
  ped <- .appViewsPed()[c(1:6, 6L), ]
  .appTestServer(.pedigreeAppServer(ped), {
    session$setInputs(view = "near", focal = "o1", howClose = 2)
    .setAppColumns(session)
    expect_identical(output$problem,
                     paste0("The animals could not be chosen ",
                            "(getNearRelativePedigree: relatedness cannot be ",
                            "read from ped, checkPedigree() reports ",
                            "duplicateIds: o3). The Checks tab lists the ",
                            "records' problems."))
    expect_identical(output$drawn, "")
  })
})

test_that("over the limit the app asks before drawing, and 'Draw anyway'
           draws those animals", {
  skip_if_not_installed("shiny")
  ped <- .appViewsPed()
  .appTestServer(.pedigreeAppServer(ped, drawLimit = 12L), {
    .setAppColumns(session)
    expect_match(output$large$html,
                 paste0("14 animals are chosen. Drawing more than 12 can take ",
                        "a minute or more, and the app waits until it is ",
                        "done. Choose one family or focal animals, or draw ",
                        "them all."), fixed = TRUE)
    expect_match(output$large$html, "<button id=\"drawAnyway\"", fixed = TRUE)
    expect_identical(output$drawn, "")
    expect_identical(output$problem, "")
    session$setInputs(drawAnyway = 1L)
    expect_null(output$large)
    expect_identical(output$drawn, "13 animals drawn")
    session$setInputs(view = "family", family = "2")
    expect_identical(output$drawn, "3 animals drawn")
    session$setInputs(view = "all")
    expect_null(output$large)
    expect_identical(output$drawn, "13 animals drawn")
  })
  .appTestServer(.pedigreeAppServer(ped, drawLimit = 14L), {
    .setAppColumns(session)
    expect_null(output$large)
    expect_identical(output$drawn, "13 animals drawn")
  })
})

test_that("the limit is 1,000 animals", {
  skip_if_not_installed("shiny")
  expect_identical(formals(.pedigreeAppServer)$drawLimit, 1000L)
  big <- data.frame(id = sprintf("a%04d", 1:1001), sire = NA, dam = NA,
                    sex = rep(c("M", "F"), length.out = 1001L))
  .appTestServer(.pedigreeAppServer(big), {
    .setAppColumns(session)
    expect_match(output$large$html,
                 paste0("1,001 animals are chosen. Drawing more than 1,000 ",
                        "can take a minute or more"), fixed = TRUE)
    expect_identical(output$drawn, "")
    expect_match(output$familyChoice$html,
                 paste0("1,001 animals have no relative in the file and are ",
                        "not listed."), fixed = TRUE)
  })
})
