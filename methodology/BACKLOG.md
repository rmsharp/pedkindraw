# Backlog

*Open, actionable work only. Completed history → `methodology/CHANGELOG.md`; feature inventory and future plans →
`methodology/ROADMAP.md`; each phase's scope and DONE criteria → `docs/planning/standalone-pedigree-package-plan.md`
section 4. Each item is tagged (READY | BLOCKED | DECISION NEEDED, Effort S | M | L). An item leaves this file in the
commit whose `methodology/CHANGELOG.md` entry records it done (plan R23: open work lives here, not in GitHub
issues).*

## Up Next

- [ ] **A Windows job that does not end after its tests finish** (READY, Effort M, a guess; found S70, dragon 30 of
      `docs/planning/picture-files-plan.md`) -- S69's Windows job ran the tests to the end (`[ FAIL 13 | WARN 0 | SKIP
      1 | PASS 16196 ]`) and then the check step went on "running" for 77 minutes until it was cancelled; two
      orphan `Rterm` processes were killed at clean-up. S68's run, before `savePedigreeDiagram()`, ended in under 19
      minutes. Cause not known (suspects: the stuck-page tests, and the one Chrome the function starts per call left
      running at R's exit on Windows). **Read in S71 (the push that followed S70, run 44994050682):** the repaired
      tests passed on Windows (`[ FAIL 0 | WARN 0 | SKIP 1 | PASS 16211 ]`, `proc.time()` 936 s, about 06:50) and the
      step still did not end (cancelled at 07:14, about 24 minutes later; two orphan `Rterm` processes, a `cmd` and a
      `conhost` killed): the second run in a row, so not a one-off. Mark's pick (S71): go on with G16b, this stays open;
      every push will probably hang Windows until it is repaired, so cancel the Windows run at 40 minutes (`gh run
      cancel`) and read its log. **A second and a third reading, S71's two pushes (runs 45000649737 and
      45011132429):** the same hang, first with failing tests (`FAIL 4`, the two PDF word tests, repaired in S71), then with
      every test passing (`[ FAIL 0 | WARN 0 | SKIP 4 | PASS 16278 ]`, `proc.time()` 1,041 s printed, so R finished its
      script and did not exit; the log's "Running 'testthat.R'" and "Execution halted" appear only at the cancel; two
      orphan `Rterm` processes each time): it does not depend on the tests, and is probably at R's exit (an inference). **A fourth reading,
      S72's push (run 45038005488):** the hang a fifth time, now with R exiting *with an error* (`[ FAIL 1 | WARN 0 | SKIP 11 |
      PASS 16287 ]`, "Error: ! Test failures. Execution halted"), so it is not at a clean exit either; the step ran until the
      cancel at 40 minutes (2,341,479 ms), then two orphan `Rterm` processes, a `cmd` and a `conhost` were killed. **A fifth reading,
      S72's repair push (run 45046213485):** the tests passed (`[ FAIL 0 | WARN 0 | SKIP 11 | PASS 16297 ]`, `proc.time()` 1,153 s
      elapsed) and the step still did not end (cancelled at 38 minutes; two orphan `Rterm` processes): the sixth run in a row,
      with passing tests, failing tests (twice) and tests that ended R with an error all hanging. **A sixth reading, S74's push (run 45073310658, G17a):** `[ FAIL 0 | WARN 0 | SKIP 11 | PASS 16425 ]`, `proc.time()` 1,110 s, the step cancelled at 41 minutes, two orphan `Rterm` processes as before: the seventh run, and the app's browser tests (a second R process each, killed at each test's end) added no third. **A seventh reading, S75's push (run 45087949474, G17b):** `[ FAIL 0 | WARN 0 | SKIP 11 | PASS 16559 ]`, `proc.time()` 925 s, cancelled at 41 minutes, two orphan `Rterm` processes again: the eighth run. **An eighth reading, S76's push (run 45107545938, G17c):** `[ FAIL 0 | WARN 0 | SKIP 11 | PASS 16716 ]`, `proc.time()` 955 s, cancelled at 41 minutes, two orphan `Rterm` processes and one `cmd`: the ninth run; G17c's Chrome test, which uploads two files, added no third `Rterm`. **A ninth reading, S77's push (run 45125145050, G17d):** `[ FAIL 0 | WARN 0 | SKIP 19 | PASS 16776 ]`, `proc.time()` 954 s, cancelled at 41 minutes, two orphan `Rterm` processes, one `cmd` and one `conhost`: the tenth run; G17d's Chrome tests (two more apps in second processes) added no third `Rterm`. First (guesses, one change at a time, iterating on GitHub since there is no Windows
      machine here): add `timeout-minutes` to `.github/workflows/R-CMD-check.yaml` so a hang ends as a failure with a
      log; close the test Chromes explicitly at the end of the suite (the helper's `.saveChrome$parent`, chromote's
      default one) and list the processes left (`Get-Process`) in a step after the tests.

- [ ] **The speed and size-limits vignette, once pedkindraw times itself** (BLOCKED on 17h's runs, planned S78
      in `docs/planning/pedkindraw-timing-plan.md`, R153; Effort L, a guess; before the release, Phase 17i of
      `docs/planning/cran-submission-plan.md`, R84)
      -- R82 (S30): "the comparison of pedkindraw with kinship2 and Pedixplorer"
      (Mark) waits until pedkindraw has timing runs of its own installed code, under a plan of its own that
      replaces R79's summary of nprcgenekeepr's records. A draft built to R79 is on the branch
      `draft/speed-vignette` (`612eed9`, not merged): `vignettes/speed.Rmd` (nine captioned tables, a definition of
      each computation, Mark's request) and `tools/checkSpeedTables.R`, whose design (a marker before each table,
      each table and caption built from the result files and compared cell for cell, `--print=<name>`, a failure
      on any unmarked table) can check the returning vignette's numbers against pedkindraw's own results. When it
      returns: point to it from `?pedkindraw`'s "Getting started" (`R/pedkindraw-package.R:52`), the
      getting-started vignette's "Where next" and the drawing vignette's "How large a drawing can be", which states
      pedkindraw's own drawing times measured in S75 since S77 (R152; before, nprcgenekeepr's November 2026 records,
      Mark's S29 pick); the installed size has about 800 KB left for its page. S77 found that the contract's section 8
      ("Drawing past about 1,000 animals") says `drawPedigreeDiagram()`'s help "states the measured limit": no help
      page states a time. S78 (R153): the page shows pedkindraw's own runs beside kinship2's and Pedixplorer's only, to
      the timing plan's section 5.8 outline; its tables come from `tools/timing/results/`, which the rewritten
      `tools/checkSpeedTables.R` reads without a clone.

- [ ] **Reword `DIVERGENCE.md`'s older rows to R98's "at the switch"** (READY, Effort S, documentation only; R98)
      -- measured S42: of its 16 rows, only G1's say "At the switch (R98)" (`makePedigreeDiagramData()`,
      `.checkShrinkInput()`, and the G1 sentence of `makePedigreeMatingLayout()`'s row; S43 added three G2 rows and
      G2 sentences in three more, all "at the switch", 19 rows now); the 14 written before R98
      each say "Port later", "Not yet made in nprcgenekeepr: a session there makes the same change" or "Not
      mirrored", which R98 and R101 replaced (nprcgenekeepr keeps its copies unported and takes pedkindraw's at
      N3). The P1 item below already describes every row as so marked. One commit; the drift tool reads only the
      function names.

- [ ] **After nprcgenekeepr's switch to pedkindraw: retire the drift and fidelity tools (Phase P1)** (BLOCKED on
      nprcgenekeepr's N3, after CRAN accepts pedkindraw; Effort S; R98, R101) -- the ports R81 (legend section
      pictures), R94 (`__jog_` prefix) and R95 (legend lines) are no longer made in nprcgenekeepr: R98 keeps its copies
      unchanged until it imports pedkindraw, so every `DIVERGENCE.md` row is marked "at the switch". Then: retire
      `tools/compareWithNprcgenekeepr.R` and `tools/compareResultsWithNprcgenekeepr.R` (with their set-asides
      `withoutConditionSymbols()`, `withoutJogSelections()`, `withoutLegendLineStyle()` and `eachDrawing()`), empty
      `DIVERGENCE.md`'s open rows, say in README and NEWS that nprcgenekeepr uses pedkindraw, and put nprcgenekeepr's
      reverse-dependency check into every later release plan (plan section 5.3).

- [ ] **The legend's labels in a narrow drawing** (READY, Effort S-M, a guess; found S53) -- `drawPedigreeDiagram()`'s
      legend is 0.28 of the drawing's width, 140 px in a 500 px drawing (an RStudio viewer pane is about that),
      and there G2's row "Affected status unknown" runs 9 px past its canvas (measured in headless Chrome, the
      widget's width set before `saveWidget()`, the gaps plan's dragon 36), so its end is cut off; at the saved
      widget's 960 px it fits (269 px). A label wider than the widest row shrinks the whole legend instead. Choose
      by picker: a wider legend, shorter words, or a line break; measure each at 500 and 700 px.
      (S69, G16a: `savePedigreeDiagram()` records the legend as the widget draws it, so a file made at a narrow
      page shows the same cut-off; its 7 x 7 in page, 672 px, was compared with the live widget at 0.8% of the legend's
      ink differing, and the cut-off was not looked for. This item is unchanged.)

- [ ] **The drawing vignette shows a measured trait drawn by a cut-off** (READY, Effort S, documentation; G12,
      R131-R132) -- `vignettes/drawing.Rmd`'s "Conditions" (`:181`) says how true-or-false columns are drawn but not
      `conditionThresholds`; a paragraph and one drawing (such as `c(affected_glucose = ">= 126")`), with a hidden
      check of the legend's label and the fills, as that section's other checks do. Mark asked in S52 whether the
      tutorials say how conditions are drawn.

- [ ] **A twins table with no rows stops the layout, and an empty cell gets R's own words** (READY, Effort S; found
      S76, G17c; copied code, the same in nprcgenekeepr at `3e06730c5`) -- `makePedigreeMatingLayout(ped,
      twinRelations = <a data frame with id1, id2 and code and no rows>)` stops in `.buildTwinConnectorEdges()`
      (`R/makePedigreeDiagramData.R`, "arguments imply differing number of rows: 0, 1"), though
      `checkTwinRelations()` passes such a table; and `checkTwinRelations()` on a table with an empty `id2` or `code`
      stops with "missing value where TRUE/FALSE needed" (`docs/planning/pedigree-app-plan.md` section 13.2). The app
      guards both (it passes no table when no pair is drawn, and names an empty cell itself), so this reaches only a
      script. A fix changes two copied functions: the drift rule (plan section 5) needs the same change in
      nprcgenekeepr or a `DIVERGENCE.md` row each; a test of each first.

- [ ] **`savePedigreeDiagram()` takes a `CHROMOTE_CHROME` that names no file for a Chrome found** (READY, Effort S;
      found S77, G17d; pedkindraw's own code) -- `chromote::find_chrome()` (chromote 0.5.1) returns
      `CHROMOTE_CHROME` as it is, without looking for the file, so `savePedigreeDiagram()`'s check
      (`R/savePedigreeDiagram.R:113`, `is.null(find_chrome())`) passes a path with nothing there and the save
      fails later inside chromote, in chromote's words (`docs/planning/pedigree-app-plan.md` section 14.3). The
      app's `.appPictureProblem()` (`R/pedigreeApp.R`) already asks that the path be a file or a command on the
      path. A fix: the same test in `savePedigreeDiagram()`, its message unchanged; RED first (mockery's stub of
      `chromote::find_chrome` returning a path with no file, as `test_pedigreeAppSave.R` does).

- [ ] **A converted Pedixplorer object's `avail` is not drawn as genotyped** (NEEDS DECISION, Effort S; found S54, G13,
      R134) -- `asPedFrame()` returns Pedixplorer's `avail` under that name (`R/asPedFrame.R:315`), and
      `makePedigreeMatingLayout()` reads only `genotyped` (Mark's pick over `avail`, which would change 10 of
      samplePed's 50 compared results), so a converted object's genotyped animals are drawn unmarked until the user
      renames the column. Choose by picker: `asPedFrame()` also writes `genotyped` from `avail`, or says so in its
      help and the drawing vignette, or nothing. Also measured: text "1" and "0" (a CSV read with every column as
      text) stops, as R134 says; numbers 1 and 0 read.

- [ ] **Long names at the drawing's edges are cut at the default text size** (NEEDS DECISION, Effort S; found S61,
      G14, R140) -- vis.js's fit leaves out a label's overhang past its symbol (the gaps plan's dragons 57 and 63),
      and at `textSize = 1` nothing keeps room for it: measured S61 in headless Chrome at 500 px, a sibship's
      15-character names (`maxNameChars`' default) at both edges were cut by 4.1 and 6.3 px in both edge styles
      (3-letter names had 26-30 px to spare). `.textSizeRoom()` (`R/textSize.R`) keeps labels inside only above
      14 px (the same names at 1.4: 16.8 and 16.3 px inside), so that every drawing at 1 stays as before. Choose
      by picker: the same points at 14 px when a label reaches past its symbol (count first the comparison cases
      with names, whose drawings would change), or say so in the help, or nothing.

- [ ] **A colony's ids are under a point high on the page that holds it** (NEEDS DECISION, Effort M-L, a guess; found
      S72, G16c, picture plan section 15.1, dragon 41) -- the 375 animals' every id is written as text, but an id is 0.75
      pt high on 14 x 7 inches, 0.45 on letter portrait and 2.8 px in a 300 dpi PNG: the files are to zoom in on, not to
      print. Choose by picker: say so in the help (done in the vignette and NEWS), or a way to split a large drawing across
      pages or tiles at a readable size (a design of its own, not G16), or a larger default page for a large pedigree, or
      nothing.

- [ ] **Correct pedkindraw's `smallPed` fixture after nprcgenekeepr corrects its dataset** (READY since nprcgenekeepr's
      S1189 finished N1, R99: its `0e2bc137e` corrects `smallPed`'s generations, found at S44's Orient; Effort S) --
      `tests/testthat/fixtures/smallPed.rds` stores the same wrong generations as nprcgenekeepr's
      `smallPed` (8 of 17 differ from `findGeneration()`, measured S41); S35 made the one test that used them compute
      `gen` instead. Replace the fixture from nprcgenekeepr's corrected dataset (R21's provenance) and run the suite.

- [ ] **Tests for full coverage** (READY, Effort M; before the release, Phase 17j, R84)
      -- Mark's request (S13, after its close-out): add tests until
      the test suite reaches every statement in `R/`. Measured S13 with `covr::package_coverage(type = "tests")` on
      the code of `82f2ef3`: 97.16%, 45 of 1,811 statements missed, in 7 files (covr's first line of each
      statement). Re-measured S14 on `dff6509`: 97.32%, 44 of 1,872 (Phase 11's 61 statements all reached, and its
      tests reach `R/shrinkPedigree.R:97`, the `affected` length error): `R/makePedigreeDiagramData.R` 31 (at S23's
      `ffe042f`: 587, 774, 1005, 1307, 1356, 2321, 2342, 2383, 2393, 2394, 2398, 2410, 2411, 2413, 2414, 2415, 2420,
      2434, 2446, 2477, 2478, 2479, 2480, 2481, 2485, 2502, 2519, 2620, 2788, 3117, 3118; S22 measured them 12 to 42
      lower, before Phase 15b's lines, and S14-S21 5 to 32 lower than S22); `R/positionTreeApportion.R` 6 (388, 392,
      395, 427, 431, 434); `R/orderRootSubtrees.R` 2 (118, 131); `R/rbindFill.R` 2 (30, 35); `R/shrinkPedigree.R` 1
      (278); `R/comparePedigreeStructure.R` 1 (160); `R/kinship.R` 1 (135). The results tool's cases reach 3 of
      them (`kinship.R:135`, `rbindFill.R:35`, `shrinkPedigree.R:278`), but cases are not tests. All 7 files are
      copied from nprcgenekeepr and stay as copied (drift rule, plan section 5), so the new tests go in pedkindraw's
      own test files, not into the copied ones, whose headers list every change (or as a pre-RED picker rules).
      Before calling a line unreachable, work out what input reaches it (Learning 11; S10 called
      `comparePedigreeStructure.R:160` "a defensive return"). Re-measure first; split by file if one session cannot
      take all 44. S15 on `b314273`: 97.38%, 44 of 1,929, the same 44 (since `dff6509` only new files changed;
      `R/familyCheck.R` 57 of 57). S16 on `b8ade6e`: 97.46%, 44 of 2,006, the same 44 (since `b314273` only
      `R/ibdMatrix.R` changed in `R/`, 77 of 77). S17 on `60a87a7`: 97.57%, 44 of 2,089, the same 44 (since `b8ade6e` only
      `R/checkPedigree.R` was added in `R/`, 83 of 83). S18 on `4bcfe00`: 97.69%, 43 of 2,178: `R/rbindFill.R:30` (a Date
      column `addParents()` fills) is now reached by `test_findUnrelated.R`'s pedSix test, so `R/rbindFill.R` has 1
      left (35); `R/findUnrelated.R` 88 of 88, `R/checkPedigree.R` 84 of 84. S19 on `58deb0a`: 97.74%, 43 of 2,227,
      the same 43 (since `4bcfe00` only `R/asPedFrame.R` was added in `R/`, 49 of 49). S20 on `ccc12ca`: 97.79%, 43 of 2,284, the
      same 43 (since `58deb0a` only `R/asPedFrame.R` changed in `R/`, 106 of 106). S22 on `b9567bd`: 97.83%, 43 of
      2,341, the same 43 (`R/layoutHints.R` added, 52 of 52; `R/makePedigreeDiagramData.R`'s lines moved, above). S23 on `ffe042f`:
      97.91%, 43 of 2,445, the same 43 (`R/layoutHints.R` 174 of 174 lines; `R/makePedigreeDiagramData.R`'s lines
      moved, above). S24 on `bcdc1b0`: 97.96%, 43 of 2,501, the same 43 (`R/asPedFrame.R` 158 of 158 statements,
      `R/layoutHints.R` 149 of 149; `R/makePedigreeDiagramData.R` unchanged, its lines as at `ffe042f`)). S25 changed nothing in `R/` (a planning session), and S26 only added `R/pedkindraw-package.R`, the package help page's source (no function); not re-measured.

## nprcgenekeepr sessions (Mark starts them there; R8, R98-R101)

*Not pedkindraw sessions: listed so they are not lost. Each runs under nprcgenekeepr's own protocol and checks;
`docs/planning/gaps-and-shared-code-plan.md` section 5.2 gives the work, DONE and order.*

- [ ] **N3: nprcgenekeepr imports pedkindraw** (BLOCKED on CRAN accepting pedkindraw; Effort M, 2 sessions, a guess;
      R98, R100) -- `Imports: pedkindraw`; the 22 shared exports re-exported; its 82 copied definitions and 43 copied
      test files deleted (its 7 internals and `addIdRecords()` kept); NEWS for its users. Then pedkindraw's P1.

## Waiting on Mark

- [ ] **The dashboard does not see `methodology/BACKLOG.md`** (DECISION NEEDED, Effort S) -- the synced
      `methodology/methodology_dashboard.py` (v2.23.0) looks for `BACKLOG.md` only at the root, `docs/` and
      `docs/planning/` (`_BACKLOG_LOCATIONS`, and `BACKLOG.md` is not among the names it moves into `methodology/`),
      so its compliance table shows Backlog ✗ although this file exists (S6). The runner reads it here ("look beside
      this runner"), so Phase 0 is not affected. Synced files are not edited here: report it to the methodology
      repository (outward-facing, Mark's call), or leave it.

- [ ] **Whether pedkindraw copies nprcgenekeepr's colony overview** (DECISION NEEDED -- later, Effort L, a guess) --
      nprcgenekeepr is building a colony overview (its issue #138;
      `nprcgenekeepr:docs/planning/colony-overview-design.md`, ruling D8: "Whether pedkindraw copies it later is
      Mark's call"; scoping
      `nprcgenekeepr:docs/planning/colony-overview-scoping.md:117-118`). Not in the plan or the contract; it would
      need a ruling and a plan change first.

- [ ] **The app's features left for later** (DECISION NEEDED -- later, after G17; Effort S-M each, a guess; R148,
      S73) -- Mark's scope pick for G17 built 16 of the 21 things Pedixplorer's app and nprcgenekeepr's Pedigree
      Browser do (`docs/planning/pedigree-app-plan.md` section 2.3) and left five: **F2** open an Excel file (`readxl`
      in Suggests, 14 packages to whoever installs it, what R13 kept out); **F10** choose the colours (shiny has no
      colour input; `colourpicker` not measured); **F14** add matings with no offspring (`matings`, G15; a third file,
      or a code in the twins file as Pedixplorer's "Spouse"); **F20** a colony too large to draw shown as its
      maternal lines (the item above: copy nprcgenekeepr's colony overview first); **F21** the symbol, text and
      spacing sizes and the line width (G14's arguments); and (R152, S77) **a page size for the saved pictures**
      (width, height and dpi boxes beside the SVG, PDF and PNG buttons; G17d saves at `savePedigreeDiagram()`'s own
      page, 10 inches wide, where the 375-animal sample's ids are 0.5 pt high, `docs/planning/pedigree-app-plan.md`
      section 14.5). Each needs a ruling, then a session of its own.

- [ ] **An animal with two or more mates drawn once, between them, as kinship2 draws it** (DECISION NEEDED,
      Effort M-L, a guess; found S65, G15a) -- pedkindraw draws a founder sire with two dams at each mating,
      the second time as a repeat node with a dashed arc (`[A B A' G]`, measured S65, both matings with
      offspring), where kinship2 draws him once, `B A G`; the anchor rule (D2, the partner with fewer matings
      anchors) of the copied `.buildMatingUnitForest()` (`R/makePedigreeDiagramData.R:655`). Mark's G15a pick
      kept that rule for matings with no offspring and sent this here. Changing it changes today's drawings, so
      the fidelity results with nprcgenekeepr (600 of 600) and the `DIVERGENCE.md` rows; it needs a ruling and
      a plan with pictures first.

## Ready, small

- [ ] **The suite gate's time limit is below the suite's time** (READY, Effort S; Phase 17l)
      -- `test-suite-warnings-zero`
      in `methodology/.quality-gates.json` sets `timeout_seconds: 300`, and the suite took 261 s alone in S29
      (`test_local()`, 684 tests), 268-271 s in S28; S29's `quality_ratchet.py --run` read the gate UNMEASURED,
      "timeout (300 s)", 4/5 pass (results `42b564bc4c70`), so its receipt names it unmeasured with the suite run by
      hand (WARN 0). The manifest's own note says to set the limit above the slowest honest run; the tool's default
      is 600 s. Raising it is not a loosening (the threshold stays 0); the ratchet prints a changed
      `timeout_seconds` as a warning and the dashboard notes a changed gate, so make the change in a commit of its
      own with the reason in the ledger, then run the gates again. S50: the suite took 304-317 s (67 files, 820
      tests), so the gate timed out again (4/5, results `42b564bc4c70`) and S50's receipt names it with the suite
      run by hand (WARN 0); S49's run had just passed. Every later session will meet this until the limit moves.

- [ ] **A stale pedkindraw 0.0.1 in renv's library** (READY, Effort S; Phase 17l) -- renv's library
      (`Rscript -e 'cat(renv::paths$library())'`) holds a pedkindraw 0.0.1 built 2026-11-12, before `asPedFrame()`
      existed (S25). Anything that calls `library(pedkindraw)` without installing first runs it: a trial pkgdown
      build with `install = FALSE` stopped on "could not find function asPedFrame" (the documentation plan's M3).
      Remove it (`remove.packages("pedkindraw", lib = renv::paths$library())`; `renv.lock` does not name it, S25)
      or reinstall it at each use; the site session builds with the package installed either way.

- [ ] **The drift tool does not watch copied constants** (READY, Effort S) -- `tools/compareWithNprcgenekeepr.R`
      compares only functions assigned at the top level, so `R/sexCodes.R` (a named character vector, R25) is
      copied but unwatched: it reports "21 copied functions in 21 files" with 22 copied files (S7). The results
      tool still refuses a clone whose `R/sexCodes.R` changed, and its `sexCodes` case compares the value, but only
      at the copy's commit. S8: Phase 7 added a second, `mzTwinIdsAbsentMessage` (in `R/mzTwinGroups.R`, beside a
      function), and the drift tool now reports "24 copied functions in 24 files" with 25 copied files; the results
      tool's `mzTwinIdsAbsentMessage` case compares its value. Fix: compare every top-level assignment, not only
      functions, or list the constants by name.

- [ ] **Point the context-budget tool at `methodology/`** (READY, Effort S) -- R18: a session of its own.
      `methodology/.context-budget.json` names `SESSION_NOTES.md` at the root, but this repository keeps it in
      `methodology/`, so `python3 methodology/context_budget.py --status` reports it "file does not exist" and the
      budget is UNMEASURED (S6). Its `LEARNINGS.md` entry names a file this project does not keep (learnings are in
      `CLAUDE.md`; the seed's own note says to delete the entry then). S18: `5631f2e` (run from the methodology repository, its S444)
      gave the notes row and the two synced rows their `methodology/` paths, so they read `ok`; left here: the
      `LEARNINGS.md` row, and `CLAUDE.md`, over its 28,000 B ceiling (29,371 B at S18's Orient, 30,063 B after
      S18's Learning 21; `context_budget.py --check` exits 2): move, archive or delete rows as the tool lists, or
      raise the ceiling only by plan-mode approval.

- [ ] **CI notices: `actions/checkout@v5` and Ubuntu 26** (READY, Effort S; Phase 17l, if still shown)
      -- warnings, not failures, on run
      `42960032938`: Node 20 is deprecated under `actions/checkout@v4`, and `ubuntu-latest` moves to Ubuntu 26
      (from 2026-10-19). `.github/workflows/R-CMD-check.yaml:39` (`actions/checkout@v4`) and `:30-32` (the three
      `ubuntu-latest` jobs). S7: the move has happened (the runners are Ubuntu 26.04, "resolute"), and in run
      `43052891573` attempt 1 all three Ubuntu jobs failed installing R, unable to resolve Ubuntu's package servers
      for an hour; re-running them passed (attempt 2). Watch whether it recurs before pinning a runner image. S8: run
      `43106941979` passed on all five jobs at the first attempt, Ubuntu 26.04 included (the same two notices). S10:
      run `43260600901` likewise (the same two, and a third: macOS arm64 queues may be longer). S11: run
      `43278560876` likewise, plus a warning from the Chrome step S11 copied: `browser-actions/setup-chrome`'s
      `install-dependencies` is for Linux only, so the Windows job notes it (`.github/workflows/R-CMD-check.yaml:78`;
      nprcgenekeepr's workflow has the same line). Harmless; an `if:` per runner would silence it. S49: run
      `44481480808` (S48's push) failed on its Ubuntu R-devel job only, installing dependencies before pedkindraw
      was checked: Bioconductor's S4Vectors 0.50.3, which Pedixplorer (Suggests) imports, does not build on R-devel
      r90935 of 2026-11-18 (a `transform` method's formals); S47's run passed that job a day earlier. Not
      pedkindraw's code; watch whether it clears before acting.

- [ ] **Report a vacuous test to nprcgenekeepr** (READY, Effort S) -- the first expectation of
      `test_findPedigreeNumber.R` checks the ids containing "1", and the Lacy pedigree's ids are letters, so it
      checks nothing (0 ids match; found S3, rechecked S6). pedkindraw copied the file unchanged
      (`tests/testthat/test_findPedigreeNumber.R:26`). For an nprcgenekeepr session: a fix there is then mirrored
      here or recorded in `DIVERGENCE.md` (plan section 5).

- [ ] **Tell nprcgenekeepr's edition-3 conversion about the copies' changes** (READY, Effort S) -- plan R29:
      nprcgenekeepr will move its tests to testthat edition 3 (its `DESCRIPTION` names none today). Its
      `tests/testthat/test_kinshipHasBothParentsHelp.R:159-162` will then leak a warning, as pedkindraw's copy did:
      `hasBothParents()` warns twice for 3 IDs and one `expect_warning()` catches one. pedkindraw's copy expects both
      with two `expect_warning()` calls (`tests/testthat/test_kinshipHasBothParentsHelp.R`, the last test); the
      conversion can use the same lines so the copies match again. S9: five more, the only lines in nprcgenekeepr's
      tests that save `expect_message()`'s value (`tests/testthat/test_makePedigreeMatingLayout.R:1622`, `:1644`,
      `:1662`, `:1678`, `:1950` at `baef1e12c`; edition 3 returns the message); pedkindraw's copy assigns inside
      (gate `tests-no-saved-expect-condition`). And R33: that file's tests at `:2074` and `:2365` let a collision
      warning through, which pedkindraw's copy handles. For an nprcgenekeepr session, like the item above.

- [ ] **Trace kinship2's and Pedixplorer's label counts in `tools/gapCases.R`'s `largeIds`** (READY, Effort S; found S72)
      -- the picture plan's G16c line and section 2 quote kinship2's 517 and Pedixplorer's 472 labels at `cex` 0.5; the
      case, run in S72 on the rhesus pedigree without its twins table, prints 520 (375 distinct) and 473 (357). Find which
      input or version gives each, and correct the plan's figure or the case.

## Later

- [ ] **`findPedigreeNumber()`'s speed** (READY, Effort M) -- 12.9 s for 100,000 animals, close to the square of the
      size (contract section 7); new work after the copy (contract section 10 item 5). A faster version here is a
      divergence from nprcgenekeepr: a `DIVERGENCE.md` row marked "at the switch" (R98, R101).

- [ ] **`findGeneration(alignMates = TRUE)`'s speed** (DECISION NEEDED: before or after the release; Effort M, a
      guess; found S78) -- one call took 56.5 s and 54.8 s at 10,000 animals and passed 60 s at 100,000, where
      `findGeneration()` without it takes 0.009 s at 10,000 (the November study) and kinship2's `kindepth(align = TRUE)`
      7.7-7.9 s (Pedixplorer's `kindepth(align_parents = TRUE)` passed 60 s): `docs/planning/pedkindraw-timing-plan.md`
      section 3.4, single calls by `docs/planning/timing-plan-prototype/s78ProbePedkindraw.R`, not the timing method.
      `alignMates` is pedkindraw's own (G8, R123-R124; nprcgenekeepr has none), so no drift row; the drawing does not
      use it. 17h2 measures it by the method; decide with those figures.

- [ ] **Install poppler in CI so the PDF word tests run there** (READY, Effort S; found S71, picture plan section 14.7)
      -- GitHub's Ubuntu and macOS runners have no `pdftotext` (S71's push: Ubuntu `SKIP 4 PASS 16268`, macOS `SKIP 2
      PASS 16279`, against this Mac's `SKIP 0 PASS 16283`) and Windows has Git's, which cannot read the PDF (now skipped), so
      the two tests that read a PDF's words, the guard against a PDF printed without its shapes and ids, run only on this
      Mac and in the Linux box. Add `poppler-utils` (Ubuntu) and `poppler` (macOS) to `.github/workflows/R-CMD-check.yaml`.
      S72 settled the other way (R147, picture plan section 15): `pdftools` counts the colony's 545 id words and 375
      distinct but reads whole-number boxes, so it cannot check overlap and does not replace `pdftotext`; the colony's
      SVG test (ids and overlap read in Chrome) runs on every job, and the colony's PDF test, the third that reads a PDF's
      words, again runs only where `pdftotext` reads a PDF.
