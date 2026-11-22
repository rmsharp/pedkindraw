# Phase G17: a ready-made app (gap A3) -- the plan

**Date:** 2026-11-22 · **Session:** pedkindraw S73 · **Type:** planning session (`methodology/SESSION_RUNNER.md`
"Planning Sessions"; failure mode #18: this session writes no package code; the code it adds is a measured prototype
beside this plan, section 3). **Governs:** Phase G17 of `docs/planning/gaps-and-shared-code-plan.md` (section 5.1,
G17's row, `:386`), gap A3 of `docs/research/pedkindraw-gaps-2026-11-18.md` (`:144`). **Ruling made here:** R148
(Mark's four picks, `docs/planning/standalone-pedigree-package-plan.md` section 2). **Status:** plan written (S73);
G17a-G17d not started (section 7), G17a next.

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
backlog `methodology/BACKLOG.md:184`, "Waiting on Mark"), `signalDataReady()`, `dataReadyContainer()`, `.countOf()`,
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
| F20 | see a colony too large to draw as its maternal lines | no | yes | none | copy 3 functions, 526 lines (backlog `:184`) |
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
root with renv's library: `Rscript --no-init-file -e 'source("renv/activate.R")' -e
'source("docs/planning/pedigree-app-prototype/measureServer.R")' docs/planning/pedigree-app-prototype` (the folder as
the last word; an explicit `--args` before it reaches the script as its first argument and breaks it). A second run of
`measureServer.R` read the same times within 0.03 s.

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
animals) 2.6 s, the largest family (343 of 5 families) 2.0 s, a focal animal's ancestors and descendants (11
animals) 0.04 s, its relatives within 1 step (3) 0.05 s, the same with direct lines 0.02 s, the CSV download 0.00 s.
**A view of a few animals takes 0.02-0.05 s**; the whole sample about 2 s, nearly all of it the layout.

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

Four questions were put to Mark in one picker (S73), each option measured or costed first (sections 2-3). **R148**,
Mark's picks, each first time, each the recommended option:

1. **What the app does: "Both apps' core".** It builds 16 of the 21: F1, F3-F9, F11-F13 and F15-F18, and F19 as a
   warning on a very large drawing (the option's preview headed its list "15" and listed these 16, F19 marked "+").
   **Waiting, in one backlog item** (`methodology/BACKLOG.md:191`, "The app's features left for later"): F2 (Excel
   files: `readxl`, 14 packages, what R13 kept out), F10 (colour pickers), F14 (a matings file), F20 (the colony
   overview, `methodology/BACKLOG.md:184`, waiting on Mark) and F21 (the size settings). Not picked: "All 21" (6-8 build sessions, a guess; Excel reverses R13; the colony overview is
   waiting on Mark), "Smallest: open, draw, save" (8 of 21; no family, no informative animals, so Pedixplorer's app
   would still do more) and "Copy nprcgenekeepr's Browser" (about 1,940 copied lines under the drift rule, DT and
   two of R13's readers, and without Pedixplorer's column picker, family choice and informative animals).
2. **`shiny`: "Suggests".** Only someone who wants the app installs it (11 packages beyond pedkindraw's 32). The
   function that starts the app stops with a message naming `shiny` when it is missing, as `savePedigreeDiagram()`
   does for `chromote` (R143); every app test skips without it, so 17l's check without suggested packages passes.
   Not picked: "Imports" (32 becomes 43 for every user).
3. **Tests: "Server tests on CRAN".** `shiny::testServer()` tests on small typed pedigrees, with no browser, run
   everywhere `shiny` is installed, CRAN included (0.02-0.05 s a view, measured; about 1-3 s in all, a guess, read in
   the check at each build session and by 17k's win-builder reading). Tests that open the app in Chrome skip on CRAN,
   as every browser test does now; they start the app in a second R process with `callr` (Suggests; 3.8.0 already in
   `renv.lock`) and drive it with `chromote`. Not picked: "Every app test skips on CRAN" and "Add shinytest2" (6
   packages new to renv's library).
4. **Exports: "One function".** pedkindraw exports one function that starts the app; its name and arguments are
   settled at G17a's pre-RED picker (section 5). The app's parts stay internal, so they can change; exporting a
   module later is a new ruling. Not picked: "The function and its parts" (a Shiny module another app embeds, as
   Pedixplorer's 21 app exports and nprcgenekeepr's `modPedigreeUI()` and `modPedigreeServer()`).

What this means for nprcgenekeepr: nothing now. Its app keeps its own Pedigree Browser; it can call pedkindraw's app
function once it imports pedkindraw (N3), but cannot embed its parts unless a later ruling exports them.

---

## 5. The interface (R148, with what each build session decides)

A proposal; each name and default is settled by its build session's pre-RED picker (Learning 1), measured first
(Learning 17):

```r
runPedigreeApp(ped = NULL, port = NULL, launch.browser = interactive())   # working name
```

- **The name:** G17a's picker. Candidates: `runPedigreeApp()` (it runs; nprcgenekeepr's `runGeneKeepR()` is the
  model), `pedigreeApp()` returning the app object, which runs when printed (Pedixplorer's `ped_shiny()` does this,
  and a test can hand the object to a second process), or another Mark names.
- **`ped`:** optional; a pedigree data frame from the user's R session, opened in the app as if read from a file
  (neither other app has this; it lets a script user explore what they already hold). Whether it is offered, and
  whether a twins table comes with it, is G17a's choice.
- **`port`, `launch.browser`:** passed to `shiny::runApp()`; defaults G17a's.
- **Return:** what `shiny::runApp()` returns, invisibly; the call blocks until the app stops (as `runGeneKeepR()`).
- **Stops, each with a test:** `shiny` not installed (a message naming it and `install.packages("shiny")`); `ped` not
  a data frame with the columns the app needs; `port` not one whole number; `launch.browser` not `TRUE` or `FALSE`.
- **Where the app lives:** internal functions in `R/` that build the user interface and the server, every `shiny`
  call written `shiny::` (Suggests: no `importFrom`), not a folder in `inst/` (G17a may measure the other way). The
  prototype's 135 lines are the starting shape, not code to copy blind: each build session writes its piece by
  strict TDD.
- **What the app reads:** a CSV or text file through `utils::read.csv()` (F1; no reader is exported, R13), ids as
  character; the columns `id`, `sire`, `dam`, `sex` chosen by the user (F4), with common other names guessed
  (Pedixplorer's `indid`, `fatherid`, `motherid`, `gender`; the guesses G17a's); `gen` added by `findGeneration()`
  (finding 1); every other column passed through, so a column pedkindraw reads by name (F11: `genotyped`, `carrier`,
  `proband`, `consultand`, `evaluated`, `fertility`, `miscarriage`, `status`, `name`) is drawn as a script draws it.
- **What the app draws:** `makePedigreeMatingLayout()` and `drawPedigreeDiagram()` with `onClick` sending the clicked
  animal to the server (F15); a mating dot or a routing point (`__union_`, `__drop_`, `__bar_`, `__proj_`) does
  nothing, a repeat node (`__dup_`) means its animal (`duplicateToReal`), as nprcgenekeepr's Browser does
  (`R/modPedigree.R:907`-`:917`). The layout's warnings shown to the user (finding 2).
- **What the app saves:** the drawing through `savePedigreeDiagram()` (F16; Chrome on the user's computer, so the
  buttons say so when it is missing) and the animals drawn through `utils::write.csv()` (F17).

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
| `tools/gapCases.R` | `:344`-`:354` (`cases$app`) | probes that pedkindraw's app builds and starts | G17a |
| new `tests/testthat/test_*app*.R` and a helper | -- | `testServer()` tests (typed pedigrees), browser tests (`callr` + `chromote`) | G17a-c |
| `tests/testthat/helper-live-render-positions.R` | `:136` (`ChromoteSession$new()`), `:190` (`skip_if_no_chrome()`) | reused for the browser tests | G17a |
| `.github/workflows/R-CMD-check.yaml` | `:50` (`setup-r-dependencies`, which installs Suggests), `:73` (Chrome on Ubuntu and Windows) | none; read each job's result for the new tests | G17a-c |
| `inst/extdata/obfuscated_rhesus_mhc_ped.csv` | -- | the sample pedigree (F3), unchanged | -- |
| `tests/testthat/test_resolveEdgeNodeCollisions.R`, `test_drawPedigreeDiagram.R` | `:769`-`:825`, `:18` (comments naming nprcgenekeepr's app and shinytest2) | none | -- |
| `docs/research/pedkindraw-gaps-2026-11-18.md` | A3 (`:144`), `:413`, `:446` | none: a dated record | -- |

---

## 7. Phases

**Common to each** (the gaps plan's "Every G phase", `docs/planning/gaps-and-shared-code-plan.md:347`): strict TDD,
its three gates and a pre-RED picker by `AskUserQuestion` in plain words, each option measured on a scratch copy first
(Learning 17); every expected value computed before RED (Learnings 18-21; the prototype's numbers in section 3 are
predictions until the real code runs). **The order is a vertical slice each** (failure mode #25): after G17a the app
starts and draws a file; each later phase adds what a user can do, end to end, with its tests.
**DONE, every phase:** the full suite 0 failed, WARN 0 (`NOT_CRAN=true`, by hand: the ratchet's suite gate times out
at 300 s); `lintr::lint_package()` 0; `roxygen2::roxygenise()` leaves `NAMESPACE` and `man/` unchanged; `covr` reaches
every new statement or names what reaches it; `R CMD check --as-cran` from a scratch folder, R16's NOTE only, and its
test line read for the app tests' time on the CRAN path (`NOT_CRAN` unset); `bash tools/checkExamples.sh`; a NEWS
bullet; the contract's row; the drift tool 91 / 23 / 0 (no copied function changes); the fidelity tool 600 of 600
identical (nothing it compares changes); `Rscript tools/gapCases.R app`. **Commands:** `CLAUDE.md`'s Build / Test /
Verify table; `Rscript tools/compareWithNprcgenekeepr.R ../nprcgenekeepr`; `Rscript
tools/compareResultsWithNprcgenekeepr.R ../nprcgenekeepr`.
**Surface:** this Mac, headless Chrome 157 for the browser tests; GitHub Actions after the push, read job by job: Chrome
is set up by the workflow on Ubuntu and Windows, not macOS (`.github/workflows/R-CMD-check.yaml:73`), so the browser
tests skip on macOS there and run on Ubuntu and Windows; the Windows job's check step hangs after its tests (backlog
`:11`, six runs), so its tests are read from the log after a cancel at 40 minutes; Ubuntu R-devel stops before
pedkindraw (S4Vectors), enforcing nothing. CRAN's machines run the server tests and skip the browser ones, so the app
in a browser is checked only here and on GitHub. **What no surface here enforces:** another browser (Safari, Firefox,
Edge), a real file dialog (the tests set a file by `testServer()`'s input or Chrome's DevTools), a phone-width
window, a user's own Chrome when they save a file, and a hosted server (shinyapps.io, Shiny Server): each is named in
the phase's notes as not run.

### G17a -- the app starts, opens a file and draws everyone (one session)

- **Builds:** the exported function (name, arguments and defaults at its picker, section 5); `shiny` and `callr` in
  Suggests (R148); the stop when `shiny` is missing; F1 (a CSV or text file), F3 (the sample pedigree,
  `inst/extdata/obfuscated_rhesus_mhc_ped.csv`), F4 (the four columns, with guesses), `gen` added, everyone drawn
  with `drawPedigreeDiagram()`, the layout's warnings shown (finding 2), F5 (the checker's table), F18 (the animals
  as shiny's own table); the help page and a guarded example (`if (interactive())`); `_pkgdown.yml`; the contract's
  row and its Suggests line; NEWS; `tools/gapCases.R`'s `app` case starting pedkindraw's app.
- **Tests:** a test helper for `testServer()` on typed pedigrees (`skip_if_not_installed("shiny")`, no
  `skip_on_cran()`); a test helper that starts the app in a second process (`callr::r_bg()`, a free port) and opens
  it in the shared Chrome (`helper-live-render-positions.R:136`), `skip_on_cran()`, `skip_if_no_chrome()`, the process
  killed at teardown; at least: each stop; the columns guessed and chosen; a file with a problem shows it on the
  Checks tab; the sample drawn in Chrome (375 animals, 1,460 nodes in the prototype).
- **Measure first (pre-RED):** how the second process loads the code under test, under `testthat::test_local()`
  (pedkindraw from source) and under `R CMD check` (installed), not renv's stale pedkindraw 0.0.1 (backlog `:223`;
  dragon 1); the name candidates (section 5); the server tests' time on CRAN's path.
- **DONE:** as "every phase"; `Rscript tools/gapCases.R app` prints that pedkindraw's app builds and starts (the
  gap row's `app` case). **Session boundary:** this phase is one session; close out when done.

### G17b -- choosing the animals (one session)

- **Builds:** F6 (one family, `findPedigreeNumber()`, each listed with its size), F7 (focal animals' ancestors and
  descendants, `trimPedigree()` and `getDescendantPedigree()`), F8 (their relatives within k steps,
  `getNearRelativePedigree()`), the focal animals typed or pasted; F15 (a click makes an animal the focal one, section
  5's rules for mating dots, routing points and repeats); F19 (a warning above a number of animals).
- **Measure first:** the app's drawing time at about 500, 1,000 and 2,000 animals (the contract's section 7: past 120
  s at 2,000), for F19's number and wording (Pedixplorer: warn 300, refuse 500; nprcgenekeepr: 400 or 750, then its
  overview); whether a click adds to the focal animals or replaces them (nprcgenekeepr replaces).
- **Tests:** each view's animals against the function called directly (`identical()` on the ids); the click in
  Chrome (finding 4: `testServer()` cannot see `update*Input()`).
- **DONE:** as "every phase". **Session boundary:** one session; close out when done.

### G17c -- what is drawn (one session)

- **Builds:** F9 (up to four condition columns, chosen from the file's columns, each a logical column or a number
  cut at a threshold, `conditionThresholds`, G12; how a CSV's "1", "TRUE", "Y" or a number becomes a condition is
  this phase's picker), F11 (the marks and names passed through by name, F4's picker extended to them if the picker
  says so), F12 (rectilinear or direct lines), F13 (a twins file read with `utils::read.csv()` and checked by
  `checkTwinRelations()`, its problems shown).
- **Tests:** each choice's layout against `makePedigreeMatingLayout()` called directly on the same data frame
  (`identical()`), the twins file's problems, one drawing in Chrome with every mark.
- **DONE:** as "every phase". **Session boundary:** one session; close out when done.

### G17d -- saving, and the documents (one session)

- **Builds:** F16 (SVG, PDF and PNG downloads through `savePedigreeDiagram()`; without Chrome the buttons say so),
  F17 (the animals drawn as CSV); the documents: README.Rmd and README.md (rendered from a scratch install, S72's
  way), `vignettes/pedkindraw.Rmd` (`:167`), `vignettes/drawing.Rmd`'s "Clicks in a Shiny application" (`:675`)
  pointing to the app, `R/pedkindraw-package.R:59`, a `@seealso` on `drawPedigreeDiagram()` (help only: run the drift
  tool), NEWS; the backlog items for F2, F10, F14, F20 and F21 re-read.
- **Tests:** each download's file in Chrome (the SVG's ids counted as G16's tests count them; the CSV's rows); the
  documents' statements beside their calls (`test_savePedigreeDiagramDocs.R`'s way, S72).
- **DONE:** as "every phase"; G17 DONE, so the gaps plan's G1-G17 are done and 17g is next. **Session boundary:** one
  session; close out when done.

**Sessions:** 1 + 4 (S73 this plan, then G17a-G17d), a guess from the prototype and G16's pace (1 + 3, one session
each); the gaps plan guessed 1 + 4-8.

---

## 8. Here be dragons (found this session)

1. **The app's second process must load the code under test.** Under `test_local()` pedkindraw is loaded from source
   by `pkgload`; under `R CMD check` it is installed; renv's library holds a stale pedkindraw 0.0.1 (backlog `:223`)
   that a plain `library(pedkindraw)` in the child would load. The prototype's child ran `pkgload::load_all()` on the
   repository; a test needs both ways, and any package a test names (`callr`, `pkgload`) must be in Suggests (R CMD
   check's "unstated dependencies in tests"). G17a measures it first.
2. **Windows and second processes.** The Windows job's check step already hangs after its tests (backlog `:11`), and
   S71's cancel found two orphan `Rterm` processes. Every browser test kills its app process at teardown; the first
   push after G17a is read job by job for a change in the hang.
3. **`testServer()` has no browser** (finding 4): a click, an `update*Input()` and what the page shows are tested in
   Chrome only, so they are not tested on CRAN.
4. **Warnings count** (finding 2; Learning 10): a test that draws a pedigree the layout warns on must expect the
   warning, or the suite's WARN is not 0. The sample warns ("72 same-row edge-node collision(s)").
5. **`%||%` is base R only from 4.4.0** (finding 6); pedkindraw depends on R 4.1.0.
6. **`shiny` in Suggests** (R148; the gaps plan's dragon 5): every use conditional, the function stops first, the
   example guarded, every test `skip_if_not_installed("shiny")`; 17l's check without suggested packages must pass.
7. **A fixed port collides** when two runs overlap: a test asks for a free port (`httpuv::randomPort()`, httpuv comes
   with shiny) and waits for the app to answer, with a time limit, before Chrome opens it.
8. **Do not run two Chrome-starting jobs at once** on the Mac (S72's gotcha): the suite, the ratchet, a check, a
   prototype run. A `source()`d script's top-level `on.exit()` runs at once (finding 7).
9. **The visNetwork "Duplicate input IDs" console warning** on a second render (finding 5,
   `R/drawPedigreeDiagram.R:513`): a browser test that reads the console allows it.
10. **A download of the drawing starts a second Chrome in the app's process** (finding 3): on GitHub the app's
    process needs the workflow's `CHROMOTE_CHROME`. A `callr::r_bg()` child inherits the parent's environment
    (measured: a variable set when R started and one set by `Sys.setenv()` both reached the child), so it comes
    with it; a test that starts the child with its own `env =` must keep it.
11. **The sample is large for a test**: 2-2.6 s to draw 375 animals; the server tests use typed pedigrees of a few
    animals, and one browser test uses the sample.
12. **The counts and sizes here are guesses or one machine's** (picture-files plan dragons 42-43): the session count,
    the server tests' CRAN time and the Chrome timings are this Mac's; a test states an order, a presence or an exact
    count, not a time.

---

## 9. Out of scope

- **F2, F10, F14, F20, F21** (R148, pick 1): Excel files, colour pickers, a matings file, the colony overview and the
  size settings, in one backlog item (`methodology/BACKLOG.md:191`), each a later ruling.
- **Exporting the app's parts** as a module (R148, pick 4).
- **shinytest2 and DT** (R148, picks 1 and 3).
- **Other sources of data:** LabKey EHR (nprcgenekeepr's), PLINK ped/fam files (Pedixplorer's; R13), a database.
- **Hosting:** the app runs on the user's computer; shinyapps.io and Shiny Server are not tried.
- **nprcgenekeepr:** no change (R8); its Pedigree Browser stays its own.

---

## 10. Sources

- The gap: `docs/research/pedkindraw-gaps-2026-11-18.md` A3 (`:144`), its app group (`:413`) and nprcgenekeepr's
  column (`:446`); the G17 row, `docs/planning/gaps-and-shared-code-plan.md:386`, its dragon 5 (`:468`), CRAN's rules
  (its section 3.5).
- Pedixplorer 1.8.0 in renv's library: `ped_shiny()`, `ped_ui()`, `ped_server()`, `plot_all_ui()`,
  `plot_all_server()`, `inf_sel_ui()`, `inf_sel_server()`, `read_data()`, its `DESCRIPTION` (read by `deparse()` and
  `packageDescription()`); its app started in headless Chrome.
- nprcgenekeepr at `3e06730c5`: `R/runGenekeepr.R`, `R/modPedigree.R`, `R/modInput.R`, its `DESCRIPTION`, and the
  helper files named in section 2.2; its tests' file names.
- The rulings: R7, R8, R13 (`docs/planning/pedkindraw-api-contract.md:54`), R86 (the 540 s limit), R101, R143
  (`chromote` in Suggests), `docs/planning/standalone-pedigree-package-plan.md` section 2.
- The prototype and its measures: `docs/planning/pedigree-app-prototype/` (section 3).
- The precedent plan: `docs/planning/picture-files-plan.md` (S68).
