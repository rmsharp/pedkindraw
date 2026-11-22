# Phase G17: a ready-made app (gap A3) -- the plan

**Date:** 2026-11-22 · **Session:** pedkindraw S73 · **Type:** planning session (`methodology/SESSION_RUNNER.md`
"Planning Sessions"; failure mode #18: this session writes no package code; the code it adds is a measured prototype
beside this plan, section 3). **Governs:** Phase G17 of `docs/planning/gaps-and-shared-code-plan.md` (section 5.1,
G17's row, `:386`), gap A3 of `docs/research/pedkindraw-gaps-2026-11-18.md` (`:144`). **Ruling made here:** R148
(Mark's picks, `docs/planning/standalone-pedigree-package-plan.md` section 2). **Status:** draft; the evidence
(sections 1-3) and the inventory (section 6) are written; the decisions are put to Mark next.

**Versions:** shiny 1.14.0, Pedixplorer 1.8.0, visNetwork 2.1.4, chromote 0.5.1 and callr 3.8.0 from this project's
renv library (the lock's dated repository, `https://packagemanager.posit.co/cran/2026-10-31`); Google Chrome 157;
pedkindraw at `b1c317e` (its `R/` unchanged since S72); nprcgenekeepr at `3e06730c5`, read from its clone (it is
installed nowhere here, so its app was read, not run); R 4.6.2; this Mac (Apple M2 Max). Every count below was
measured in this session by the scripts of section 3 and covers the cases run, no more (Learning 19).

---

## 1. What G17 closes, and for whom

Every pedkindraw function is called from R. **What it means for users (A3):** someone who keeps a pedigree in a
spreadsheet cannot see it drawn without writing R. The way round it today is four calls, for someone who can write
them: `utils::read.csv()`, `findGeneration()` for the `gen` column, `makePedigreeMatingLayout()` and
`drawPedigreeDiagram()`. Choosing a family, a focal animal's relatives or a condition column, and saving a picture,
are more calls. Pedixplorer, the maintained continuation of kinship2, ships an app that does all of this from a
file (section 2.1); kinship2 has none.

**nprcgenekeepr does not share the gap.** Its `runGeneKeepR(port = 6013L, launch.browser = TRUE)`
(`R/runGenekeepr.R:51`) starts its whole colony application, and its Pedigree Browser draws with the same
`drawPedigreeDiagram()` pedkindraw copied (section 2.2; the research record's section 10, `:446`). That app is
nprcgenekeepr's, built on its studbook and its colony concepts (living animals, a population, maternal lines); it is
not available to someone who installs pedkindraw.

**What G17 changes in copied code: nothing.** The app is new code in new files. It calls the exports as a script
does, so no copied function changes, the drift tool reads 91 / 23 / 0 throughout, and no `DIVERGENCE.md` row is
owed (R101: pedkindraw leads; nprcgenekeepr gains the app only if it later imports pedkindraw, N3, and only the
parts pedkindraw exports, section 4).

---

## 2. What the two other apps do (read, and Pedixplorer's started)

### 2.1 Pedixplorer's `ped_shiny()`

`ped_shiny(port, host, precision, ind_max_warning = 300, ind_max_error = 500)` returns `shiny::shinyApp(ped_ui,
ped_server(...))`. Read from its code (`ped_ui()`, and `ped_server()`, 270 lines deparsed) and started here in a
background R process and headless Chrome: it answers in 1.82 s, Shiny connects 0.11 s later, and the page binds
102 inputs, 2 file inputs and 4 buttons. One page, top to bottom:

1. **Data:** a pedigree file and a relationship file (twins and "Spouse" pairs), each csv, txt, tsv, tab, xls, xlsx
   or PLINK ped/fam; a column picker for each, which guesses common other names (`indid` for `id`, `fatherid` for
   `dadid`, `gender` for `sex`) and maps 17 optional columns (family, fertility, miscarriage, deceased, avail,
   evaluated, consultand, proband, carrier, asymptomatic, adopted, birth and death dates); rows with errors listed and
   downloadable; a sample pedigree to try.
2. **Health and family:** a condition column (a threshold when it is a number), colour pickers for affected,
   unaffected and available, one family chosen from a list, a table of counts.
3. **Informative animals:** which animals are informative (all, affected, available, or a custom list), the largest
   kinship distance kept, "keep informative parents"; then a subfamily chosen from what is left.
4. **The drawing:** R graphics or, ticked, an interactive plotly picture; sliders for symbol size and line width;
   tooltip columns; a best-alignment search with a time limit; a warning at 300 animals and a refusal at 500 (an
   override box); a legend; a download of PNG, PDF or SVG (HTML for the interactive one).

It imports shiny and 9 other packages for the app alone (DT, shinycssloaders, shinyhelper, shinyjs, shinyjqui,
shinyWidgets, colourpicker, shinytoastr, plotly): its `DESCRIPTION`, read from the installed package. It has 21
app exports (the research record, `:413`): `ped_shiny()`, `ped_ui()`, `ped_server()` and its modules and demos, so
another app can reuse a part.

### 2.2 nprcgenekeepr's Pedigree Browser (read, not run)

`R/modPedigree.R` at `3e06730c5`, 970 lines: `modPedigreeUI()` (`:28`-`:195`) and `modPedigreeServer(id,
studbook)` (`:262`-`:970`), one tab of a 16-tab application. It takes the studbook that nprcgenekeepr's Input tab
read and checked (`R/modInput.R`: csv, txt, xlsx or xls files, `:122`-`:148`, or LabKey EHR, `:392`). It offers:
focal animals typed, pasted or read from a CSV file (`:290`-`:359`); the pedigree trimmed to their ancestors and
descendants (`:390`-`:408`, `trimPedigree()` and `getDescendantPedigree()`); "Display Unknown IDs"; a searchable
table (DT); a Diagram tab with rectilinear or direct lines, names on or off, a twin file's connectors, a limit of
400 animals (rectilinear) or 750 (direct) (`:455`, `:467`), and above it the colony's maternal lines as circles, a
click drawing one line (`:585`-`:668`, `:833`-`:851`); a click on an animal makes it the focal animal (`:907`-
`:917`); the shown animals saved as CSV (`:926`-`:933`).

It calls 12 helpers pedkindraw does not have, in 10 nprcgenekeepr files of about 970 lines (what they call in
turn was not followed): `setPopulation()`,
`isLivingAnimal()`, `isGeneratedUnknownId()`, `readWithFinalNewline()` and `readTwinRelations()` (two of R13's
readers), `makeColonyOverview()`, `drawColonyOverview()` and `getMaternalLinePedigree()` (the colony overview:
backlog `methodology/BACKLOG.md:183`, "Waiting on Mark"), `signalDataReady()`, `dataReadyContainer()`, `.countOf()`,
`.twinPairsWithin()`; a thirteenth, `.diagramHeight()`, pedkindraw has copied. Its tests: 9
`test_modPedigree*.R` files with 171 tests through `shiny::testServer()`, and 4 end-to-end files through
`shinytest2::AppDriver`.

### 2.3 What a user can do in each, and what pedkindraw has for it

Labels F1-F21 name the features in the rest of this plan and in its pickers. "Has it" names where; "the function
behind it" is pedkindraw's export an app would call today.

| | A user can | Pedixplorer's app | nprcgenekeepr's Browser | pedkindraw's function behind it | Cost to the app |
|---|---|---|---|---|---|
| F1 | open a CSV or text file of the pedigree | yes | yes (Input tab) | none exported (R13); `utils::read.csv()` | none new |
| F2 | open an Excel file | yes | yes | none | `readxl` in Suggests: 14 packages to whoever installs it (section 3.1), what R13 kept out |
| F3 | try the app on a sample pedigree | yes | no | `inst/extdata/obfuscated_rhesus_mhc_ped.csv` (375 animals, 5 families) | none new |
| F4 | say which columns are id, sire, dam and sex | yes, guesses other names | no (fixed names) | fixed names (`id`, `sire`, `dam`, `sex`) | a column picker |
| F5 | see the records' problems | yes | yes (Input tab) | `checkPedigree()` | a tab |
| F6 | choose one family | yes | no | `findPedigreeNumber()` | a list |
| F7 | draw focal animals with their ancestors and descendants | no | yes | `trimPedigree()`, `getDescendantPedigree()` | a text box |
| F8 | draw focal animals' relatives within k steps | yes (informative animals) | no | `getNearRelativePedigree()` (G11: Pedixplorer's animals in 1,980 of 1,980 runs) | a number |
| F9 | draw up to four condition columns, a measured trait cut at a threshold | one condition, threshold | its affected columns, no threshold | `affected*` columns, `conditionThresholds` (G12) | a list, a number |
| F10 | choose the colours | yes | no | `conditionColors` | colour inputs (shiny has none; `colourpicker` not measured) |
| F11 | see the file's marks and names: genotyped, carrier, proband, consultand, evaluated, fertility, miscarriage, deceased (`status`), name | yes, each a mapped column | names only | read by column name (G2, G13) | the columns passed through, or mapped as F4 |
| F12 | draw rectilinear or direct lines | no | yes | `edgeStyle` | two buttons |
| F13 | add a twins file | yes (relationship file) | yes | `twinRelations`, `checkTwinRelations()` | a second file |
| F14 | add matings with no offspring | yes ("Spouse" pairs) | no | `matings` (G15) | a third file, or a code in the second |
| F15 | click an animal to make it the focal animal | no | yes | `onClick` | a click handler |
| F16 | save the drawing as SVG, PDF or PNG | yes | PNG button, web page | `savePedigreeDiagram()` (needs Chrome on the computer); the widget's PNG button | download buttons |
| F17 | save the animals drawn as a CSV file | yes | yes | `utils::write.csv()` | a download button |
| F18 | read the animals as a table | counts only | yes (DT, searchable) | none | shiny's own table (no new package) or DT (3 more) |
| F19 | be stopped before a drawing too large to use | warns at 300, refuses at 500 | 400 or 750 | none (`drawPedigreeDiagram()` has no limit; past 120 s at 2,000 animals, the contract's section 7) | a number, and words |
| F20 | see a colony too large to draw as its maternal lines | no | yes | none | copy 3 functions, 526 lines (backlog `:183`) |
| F21 | change symbol, text and spacing sizes and line width | symbol size, line width | no | `symbolSize`, `textSize`, `columnSpacing`, `rowSpacing`, `lineWidth` (G14) | four or five numbers |

Pedixplorer's app has 17 of the 21 (all but F7, F12, F15 and F20; F18 and F21 in part); nprcgenekeepr's Browser
14 (F1, F2, F5, F7, F9, F11-F13, F15-F20; F11 and F16 in part). pedkindraw has the function behind every one but
F1-F2 (no reader, R13; F1 needs only `utils::read.csv()`), F18, F19 and F20.

---

## 3. What the prototype showed

Scratch prototype, kept beside this plan in `docs/planning/pedigree-app-prototype/` (not package code; `docs/` is
in `.Rbuildignore`): `app.R` is a small app made only of pedkindraw's exports, 135 lines of code, that does F1, F3,
F4, F5, F6, F7, F8, F9 (no threshold), F12, F15, F16, F17 and F18 (shiny's own table); `measureServer.R` drives its
server with `shiny::testServer()`, no browser; `measureBrowser.R` starts it in a background R process (`callr`) and
drives it with headless Chrome (`chromote`); `countDependencies.R` counts packages. Each runs from the repository
root with renv's library (`Rscript --no-init-file -e 'source("renv/activate.R")' -e 'source(<script>)'`, the
prototype's folder as its argument).

### 3.1 What each choice adds to an install

Hard dependencies (Depends, Imports, LinkingTo), all the way down, base packages left out, read from the installed
packages (the comparison study's section 11 way, which gave R13's 32):

| Added | Packages it adds | Which |
|---|---:|---|
| pedkindraw today (`Imports`) | 32 | -- |
| `shiny` | 11 | commonmark, glue, httpuv, later, otel, promises, Rcpp, shiny, sourcetools, withr, xtable (`bslib` comes with it) |
| `shiny` and `DT` | 14 | the 11, and crosstalk, DT, lazyeval |
| `readxl` | 14 | cellranger, cpp11, crayon, glue, hms, pillar, pkgconfig, prettyunits, progress, readxl, rematch, tibble, utf8, vctrs |
| `shinytest2` (not installed; from the dated repository's index) | 6 new to renv's library | backports, checkmate, globals, httr2, pingr, shinytest2 (21 beyond pedkindraw, shiny and chromote) |

In Imports, a package is installed for every user of pedkindraw; in Suggests, only for someone who asks for it, and
CRAN requires the code to use it "conditionally" (the gaps plan's dragon 5, `:468`; its section 3.5). `shiny`,
`callr`, `DT` and `readxl` are already in `renv.lock` (Pedixplorer's dependencies), so naming them in `DESCRIPTION`
needs no install.

### 3.2 The server with no browser (`measureServer.R`)

`shiny::testServer()` ran the prototype's server through five drawings of the 375-animal sample and a download in
**4.7 s** (the whole script 6.2 s with R's start and `load_all()`): the sample read and everyone drawn (375
animals) 2.6 s, the largest family (343 of 5 families) 2.0 s, a focal animal's ancestors and descendants (11 animals) 0.04 s, its relatives within 1 step (3)
0.05 s, the same with direct lines 0.02 s, the CSV download 0.00 s. **A view of a few animals takes 0.02-0.05 s**;
the whole sample about 2 s, nearly all of it the layout.

### 3.3 The app in a browser (`measureBrowser.R`)

| Step | Time |
|---|---:|
| the app's process answers (R start, `load_all()`, shiny) | 1.23 s |
| Chrome loads the page, Shiny connects | 1.57 s |
| "Use the sample pedigree" clicked until "375 animals drawn"; the page's network holds 1,460 nodes | 2.61 s |
| the CSV download fetched by the page | 0.01 s |
| **the SVG download: `savePedigreeDiagram()` starts its own Chrome inside the app's process** and returns 843,620 characters | 1.82 s |
| a focal animal typed, its near relatives drawn (2 animals) | 0.41 s |
| the whole run | 8.5 s |

### 3.4 What the prototype found

1. **`makePedigreeMatingLayout()` needs a `gen` column**: the first run stopped, "requires 'ped' to have columns: id,
   sire, dam, sex, gen. Missing: gen". The app adds it with `findGeneration()`, as a script must.
2. **The layout's warnings reach only the app's console**: on the sample, "72 same-row edge-node collision(s) could
   not be fully resolved" went to the process's standard error, unseen by the user. The app must show a warning or
   decide not to (and a test that draws the sample must expect it: edition 3 counts it as WARN, Learning 10).
3. **`savePedigreeDiagram()` works inside a running app** (3.3): its own Chrome session did not stall the app's
   event loop. The app's server and the second Chrome share the computer, so a download of the whole sample takes
   about 2 s.
4. **A click's effect on the page is not visible to `testServer()`**: the prototype's click handler writes the
   focal box with `updateTextAreaInput()`, a message to the browser; `testServer()` has no browser, so only a browser
   test can see it. The same holds for any `update*Input()`.
5. **The app re-renders the whole widget when the animals change**, which can log visNetwork's "[shiny] Duplicate
   input IDs were found" console warning from the second render on (`R/drawPedigreeDiagram.R:513`-`:520`, a known,
   accepted trade-off copied from nprcgenekeepr): a browser test that reads the console must allow it.
6. **`%||%` is in base R only from 4.4.0**; pedkindraw `Depends: R (>= 4.1.0)`, so package code cannot use it
   without defining it (the prototype ran on R 4.6.2).
7. **Starting an app from a test** needs a second R process: `callr::r_bg()` with renv's library passed as
   `libpath`. A test script's `on.exit()` at its top level runs at once when the file is `source()`d (it killed
   the first run's app): the steps go inside a function.

---

## 4. The decisions (R148)

To be put to Mark by picker in this session (Learning 1), each option measured above: what the app does (which of
F1-F21), `shiny` in Suggests or Imports, the tests and CRAN's check time, and what pedkindraw exports for the app.

---

## 6. Inventory (grep, at `b1c317e`)

Searched: `shiny`, `Shiny`, `runApp`, `onClick`, `Shiny.setInputValue`, `application`, `Pedigree Browser`, `callr`,
`shinytest2` and `testServer` over `R/`, `tests/`, `tools/`, `vignettes/`, `README.Rmd`, `NEWS.md`, `_pkgdown.yml`,
`DESCRIPTION`, `.github/`, `inst/`, `.Rbuildignore`, `.lintr` and the contract: 0 for `runApp`, `callr` and
`testServer`; the other matches are listed by file below.

| File | Lines (text) | Change | Phase |
|---|---|---|---|
| new `R/` file(s) for the app (names at G17a's picker) | -- | the function that starts the app, its user interface and server; help and a guarded example (`if (interactive())`) | G17a-c |
| `DESCRIPTION` | `:27`-`:36` (Suggests) | `shiny` (Suggests or Imports, section 4), `callr` for the browser tests; any package a picked feature needs | G17a |
| `NAMESPACE`, `man/` | -- | `roxygen2::roxygenise()` | G17a-c |
| `_pkgdown.yml` | `:18`-`:23` (the "Drawing" group) | a group or a line for the app (pkgdown stops on a topic missing from the index) | G17a |
| `R/drawPedigreeDiagram.R` (copied) | `:166`-`:177` (help: "a Shiny application can pass one"), `:513`-`:520` (the duplicate-ids comment) | none in code; a `@seealso` line is help text only (the drift tool compares arguments and code: run it) | G17c |
| `R/pedkindraw-package.R` | `:59` ("clicks in a Shiny application") | a sentence naming the app | G17c |
| `vignettes/drawing.Rmd` | `:675`-`:713` ("Clicks in a Shiny application", its chunk `:682` and hidden check `:703`) | a sentence pointing to the app | G17c |
| `vignettes/pedkindraw.Rmd` | `:167` ("Drawing a pedigree") | a sentence | G17c |
| `README.Rmd`, README.md | the drawing section | a sentence; README.md rendered from a scratch install (S72's way) | G17c |
| `NEWS.md` | the "New" items | a bullet each build session | G17a-c |
| `docs/planning/pedkindraw-api-contract.md` | section 4 (`:91`), a new group; section 5 dependencies (`:261`) | the app's row(s); the Suggests line | G17a-c |
| `tools/gapCases.R` | `:344`-`:352` (`cases$app`) | probes that pedkindraw's app builds and starts | G17a |
| new `tests/testthat/test_*app*.R` and a helper | -- | `testServer()` tests (typed pedigrees), browser tests (`callr` + `chromote`) | G17a-c |
| `tests/testthat/helper-live-render-positions.R` | `:136` (`ChromoteSession$new()`), `:190` (`skip_if_no_chrome()`) | reused for the browser tests | G17a |
| `.github/workflows/R-CMD-check.yaml` | `:50` (`setup-r-dependencies`, which installs Suggests), `:73` (Chrome on Ubuntu and Windows) | none; read each job's result for the new tests | G17a-c |
| `inst/extdata/obfuscated_rhesus_mhc_ped.csv` | -- | the sample pedigree (F3), unchanged | -- |
| `tests/testthat/test_resolveEdgeNodeCollisions.R`, `test_drawPedigreeDiagram.R` | `:769`-`:825`, `:18` (comments naming nprcgenekeepr's app and shinytest2) | none | -- |
| `docs/research/pedkindraw-gaps-2026-11-18.md` | A3 (`:144`), `:413`, `:446` | none: a dated record | -- |
