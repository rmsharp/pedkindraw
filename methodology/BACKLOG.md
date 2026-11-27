# Backlog

*Open, actionable work only. Completed history → `methodology/CHANGELOG.md`; feature inventory and future plans →
`methodology/ROADMAP.md`; each phase's scope and DONE criteria → `docs/planning/standalone-pedigree-package-plan.md`
section 4. Each item is tagged (READY | BLOCKED | DECISION NEEDED, Effort S | M | L). An item leaves this file in the
commit whose `methodology/CHANGELOG.md` entry records it done (plan R23: open work lives here, not in GitHub
issues).*

## Up Next

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

- [ ] **`makePedigreeDiagramData()` returns two nodes with one id for a repeated id** (DECISION NEEDED, Effort S;
      found S89) -- `makePedigreeDiagramData(data.frame(id = c("A", "A"), sire = NA, dam = NA, sex = "M", gen =
      0L))` returns 2 nodes, both `A`; what visNetwork then draws was not measured. R163 made
      `makePedigreeMatingLayout()` stop on a repeated id, naming it; the same stop here would change copied code (a
      `DIVERGENCE.md` row). It draws a parent with no row: S89's three typed cases each drew every animal.

## nprcgenekeepr sessions (Mark starts them there; R8, R98-R101)

*Not pedkindraw sessions: listed so they are not lost. Each runs under nprcgenekeepr's own protocol and checks;
`docs/planning/gaps-and-shared-code-plan.md` section 5.2 gives the work, DONE and order.*

- [ ] **Tell nprcgenekeepr: its layout stops on a parent id with no row, and on a repeated id** (READY, Effort
      S-M, a guess; R163; found S88, repaired here S89) -- nprcgenekeepr's `makePedigreeMatingLayout()` (at
      `3e06730c5`) stops with R's or an internal check's message when an animal's only recorded parent has no row:
      `data.frame(id = "A", sire = "X", dam = NA, sex = "F", gen = 1L)` alone (`.orderRootSubtrees()`'s check);
      such an animal mated to a drawn one (`.penaltyMatrix()`, "NAs are not allowed in subscripted assignments");
      or beside others (`.addRectilinearWaypoints()`, "subscript out of bounds"): 676 of 1,181 random pedigrees
      with a parent that has no row. A repeated id gives "node stack overflow". pedkindraw's repair, `22fa0a4` and
      REFACTOR `89f39e7` (the `DIVERGENCE.md` rows of `makePedigreeMatingLayout()`, `.buildMatingUnitForest()` and
      `.positionMatingUnitForest()`): no line from a parent with no row, every animal with no line in a root, a
      repeated id stopped. A session there ports it (Learning 16's patch) or leaves it to the switch (R98).

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

- [ ] **Move `renv.lock` to Bioconductor 3.24** (READY, Effort S-M, a guess; Mark's pick at S99, "Stand-in test;
      keep lock (Recommended)", made it an item of its own; S100's orient pick ran 17n first, on the lock's 3.23 with
      3.24 checked beside it in a scratch library (17n's DONE paragraph); `renv.lock` is not in the tarball
      (`.Rbuildignore:4`), so the move changes no package file, but it changes every local run after the freeze,
      so it waits for Mark's word) -- the lock names
      Bioconductor 3.23 (BiocGenerics 0.58.1, BiocVersion 3.23.1, Pedixplorer 1.8.0, S4Vectors 0.50.3), so every
      local run reads a release CRAN's machines no longer install (dragon 43); 3.24 is the release for R 4.6.2.
      Pedixplorer 1.10.0 imports the same packages as 1.8.0, so the move is those 4 packages and no CRAN package
      (S99). Measured on 3.24 in a scratch library after S99's fix: the 29 test files naming Pedixplorer 367 tests,
      0 failed, 0 errors; `R CMD build` and `check --as-cran` Status 1 NOTE (R16's), CRAN-mode `PASS 2697`. Not
      measured: renv's steps for changing the Bioconductor release (`renv/settings.json` has
      `bioconductor.version: null`; Learning 3's traps: set the dated CRAN repository first, install each package by
      name with `rebuild = TRUE`, snapshot with `dev = TRUE`, then the `renv-lock-no-latest-repository` gate). S99's
      stand-in test (`tests/testthat/test_asPedFrameS4Vectors.R`) keeps working on either release.

- [ ] **The Windows CI job warns that `install-dependencies` is for Linux only** (READY, Effort S; found S11; moved
      here S95 from the CI-notices item, done) -- `browser-actions/setup-chrome@v2`'s `install-dependencies: true`
      (`.github/workflows/R-CMD-check.yaml:78`) is a Linux option, so the Windows job notes it (run 45760561429, S95).
      Harmless; `install-dependencies: ${{ runner.os == 'Linux' }}` would silence it. nprcgenekeepr's workflow has
      the same line.

- [ ] **A Chrome at a PDF or PNG save's second start hangs now and then on CI** (READY: the diagnostic, by Mark's
      pick; Effort M, a guess; found S89, S91, S92; S93 R166) -- every start failure CI has shown since S71 is at
      `.renderPicture()`'s start (`.startChrome()` with LCD text off, `R/savePedigreeDiagram.R:301`), 27 of the 109
      starts a trace of the tests counts: S89 (`:458`) and S92 (`:426`) Ubuntu release, "port not open after 10
      seconds"; S91 macOS, port open, `/json/version` unanswered for 60 s; S93 Ubuntu release twice on the REFACTOR
      push (run 45737321097, attempts 1 and 2, `:366` and `:653`), "port not open after **60** seconds", each leaving
      an `org.chromium.Chromium.*` folder (a detritus NOTE). `:653` stubs the recording, so no browser had just
      closed. 4 of the 5 on Ubuntu with R release, 0 on oldrel-1 (the same Chrome for Testing 158.0.8127.88).
      S97: the first on oldrel-1 (run 45921649070, job 140253524596, attempt 1): `test_savePedigreeDiagram.R:381`,
      a PDF save at `width = 7`, "port not open after 60 seconds" at `.renderPicture()`'s start (`:310`), an
      `org.chromium.Chromium.*` folder left (Chrome for Testing 158.0.8127.88); so 5 of 6 on Ubuntu, 1 on oldrel-1.
      S98: **the first at a save's first start**, the recording's (run 45930893462, job 140283002437, Ubuntu release,
      attempt 1): `test_savePedigreeDiagram.R:575`, `.recordDiagramSvg()` (`R/savePedigreeDiagram.R:137`) to
      `.startChrome()` (`:185`, `chromote::Chrome$new()` at `:381`), "port not open after 60 seconds", a folder left
      (the same Chrome); so 6 of 7 at `.renderPicture()`'s start, 1 at the recording's, and the title's "second
      start" no longer covers every case.
      S93 added a 60 s start wait (R166): an 11-s-slow stand-in passes, a hung Chrome does not. **Next (Mark's
      pick):** a diagnostic push, as S91's for the Windows hang (`89e28f1`; dragon 35): on the runners, many starts
      of each kind (with and without `--disable-lcd-text`, right after a close and alone), on release and oldrel-1,
      counting hangs and keeping each hung Chrome's stderr (chromote writes it to a temp file); then one fix by
      Mark's pick: one browser per save, a retry of a hung start, or the arguments the count points to.

- [ ] **A PDF or PNG can come out blank: `.renderPicture()` prints after `Page$navigate()` without waiting for
      the load** (DECISION NEEDED, Effort S, a guess; found S93) -- run 45721768010's Windows job (attempt 1)
      failed `test_savePedigreeDiagram.R:525`: the first of two PDFs of the four animals was 1,093 bytes, the
      second 83,451 (a blank page against a drawn one); the rerun passed (PASS 17031), and none of the 80 jobs
      before failed there. `.renderPicture()` calls `session$Page$navigate()`, then waits two animation frames, then
      prints or photographs; chromote 0.5.1's own vignette (`commands-and-events.Rmd:67`-`:68`) says navigate and a
      load wait "will not work 100% of the time" and to use `$go_to()`. Whether that race made this blank page is
      not shown (one reading). Choices: wait for the SVG document's `readyState` "complete" (or `go_to()`) before
      the two frames, with a test that delays the load; or leave it. Related: picture plan dragon 16. S95, a second
      Windows-only picture fault, at the SVG's comparison: run 45760561429's Windows job (attempt 1) failed
      `test_savePedigreeDiagram.R:184`, 45.4% of the `matesNoOffspring` legend's ink differing between the saved SVG
      and the live widget (bound 0.5%; the other 13 shapes and the feature pedigree within it); the rerun passed
      (PASS 17044). Not shown whether the SVG or the live widget's photograph was the one drawn short. S96, the
      same comparison on Ubuntu release: run 45888606992's attempt 1 failed `:184` with the feature pedigree's
      legend 50.2% differing (bound 1.0%), its rerun passed (PASS 17045); and S96's second local full run had 1
      error in the same test at load average 9-10 (the file alone 235 of 235; its message not kept). So it is not
      Windows-only.

- [ ] **The app's click test times out on macOS now and then** (DECISION NEEDED, Effort S, a guess; found S88,
      S93) -- `test_pedigreeAppBrowser.R:103` ("a click on a repeat or an animal makes it the focal animal"):
      `.appWaitFor()` waited 60 s for the focal box to read `g1`, on macOS only: run 45519040454 (S88) and both
      attempts of run 45737321097 (S93), attempt 1 of run 45946860858 (S99, job 140333435751; Status OK at its
      rerun, `PASS 17099`), and attempt 1 of run 46043167677 (S100, job 140655739961, 17n's push; Status OK at its
      rerun, `PASS 17099`): two pushes in a row. The browser had started; the click did not take. Not read further.

- [ ] **Tell nprcgenekeepr: its help says a re-routed marked mate line falls back** (READY, Effort S; found S96,
      checked S97) -- nprcgenekeepr's `?makePedigreeMatingLayout` (`R/makePedigreeDiagramData.R:1622` at
      `3e06730c5`) says a marked mate edge replaced by a right-angle projection "currently falls back to the generic
      routing color and width", and its comment at `:2339` says the same; its own code keeps them (its S563 fix),
      and its issues #143 and #144 left no drawing that re-routes one (R162). pedkindraw corrected its copy's help
      and comments in S97 (R169; the copy's header lists it; help text is not drift). For an nprcgenekeepr session.

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
      warning through, which pedkindraw's copy handles. S95: `tests/testthat/test_isAddedRecord.R`'s three tests that
      use mockery have no `skip_if_not_installed("mockery")`, so off CRAN without mockery they error (testthat skips
      a missing package only on CRAN); pedkindraw's copy guards them (S95, R167). For an nprcgenekeepr session, like
      the item above.

- [ ] **Trace kinship2's and Pedixplorer's label counts in `tools/gapCases.R`'s `largeIds`** (READY, Effort S; found S72)
      -- the picture plan's G16c line and section 2 quote kinship2's 517 and Pedixplorer's 472 labels at `cex` 0.5; the
      case, run in S72 on the rhesus pedigree without its twins table, prints 520 (375 distinct) and 473 (357). Find which
      input or version gives each, and correct the plan's figure or the case.

- [ ] **Bring the gaps plan's stale cells up to date** (READY, Effort S, documentation only; Mark's request, S87) --
      `docs/planning/gaps-and-shared-code-plan.md` section 5.1's table still reads as if G15-G17 were open, though
      each is DONE (that plan's own status block, the cran plan's status block and section 6's Done notes; close-out
      commits `2066715` S67, `fc73f5b` S72, `4f93a52` S77): the G15 row's sessions cell (`:388`) ends at "(S64 the
      plan)", with no G15a-c (S65-S67); the G16 row's (`:389`) names "S69 G16a DONE, S71 G16b DONE" but not G16a's CI
      repair (S70) or G16c (S72); the G17 row's (`:390`) ends at "(S73 the plan)", with no G17a-d (S74-S77). And the
      status block (`:15`) says "G14 under way (...), so G14 DONE". Record each as the G13 row does ("DONE in 6 (S54
      the first, ...)"), each with its phase "DONE" in its row; find each cell by its words, since edits move lines
      (Learning 7). No package file changes.

## Later

- [ ] **The CI guard test cannot see R-hub's install step** (READY after the release, Effort S; found S101, R173,
      the CRAN plan's dragon 46) -- `tests/testthat/test_ciWorkflows.R`'s `.jobsStartingRenv()` looks for
      `r-lib/actions/setup-r-dependencies` in a workflow's text, and `.github/workflows/rhub.yaml` (S101) reaches
      that action only inside `r-hub/actions/setup-deps`, so the guard flags 0 of its jobs (measured S101 on R-hub's
      published file, whose jobs run that action in the checked-out folder, where `.Rprofile` starts renv; read from
      R-hub's actions, not run). S101 turned renv off in both of its check jobs by hand. Extend the guard,
      test-first, to every action known to call r-lib's (R-hub's `setup-deps` at least). After 17q: `tests/` is in
      the tarball, so a change before then reopens 17n.

- [ ] **Copy nprcgenekeepr's README badges that fit pedkindraw** (READY at 17q, after acceptance, Effort S; Mark's
      request, S101; the CRAN plan's D10) -- **Hold off: make no change to `README.Rmd`, `README.md` or any badge until
      CRAN has accepted pedkindraw (Mark, S101).** nprcgenekeepr's `README.Rmd:16`-`:25` shows 10 badges; pedkindraw's
      `README.Rmd:18` shows 1 of them, R-CMD-check. The other 9, read S101: **after acceptance only** (dragon 10: a CRAN
      link before then is a 404 the incoming check reports): CRAN version (r-pkg.org), CRAN downloads per month and in
      total (cranlogs), and the DOI CRAN gives a published package (`10.32614/CRAN.package.pedkindraw`); **usable as
      they are:** Project Status "Active" (repostatus.org), lifecycle "stable", License MIT (it links `LICENSE`, which
      ships in the tarball); **need setup first:** REUSE status (nprcgenekeepr has `LICENSES/` and `REUSE.toml`;
      pedkindraw has neither) and Codecov (nprcgenekeepr's `test-coverage.yaml` uploads covr's results with a
      `CODECOV_TOKEN` secret; pedkindraw has no such workflow, and covr takes about 13 min here). `README.Rmd` and the
      `README.md` rendered from it ship in the tarball, so a badge added before acceptance reopens 17n and needs a new
      tarball and new uploads; 17q re-renders the README with D10's badges anyway. Whether to set up REUSE and Codecov
      is Mark's call at 17q.

- [ ] **`findPedigreeNumber()`'s speed** (READY, Effort M) -- 12.9 s for 100,000 animals, close to the square of the
      size (contract section 7); new work after the copy (contract section 10 item 5). A faster version here is a
      divergence from nprcgenekeepr: a `DIVERGENCE.md` row marked "at the switch" (R98, R101). S82's record
      (`tools/timing/results/timing.csv`, case `pkd_fam`): 12.4 s at 100,000 and 1.26 s at 30,000, where kinship2's
      `makefamid()` takes 0.609 s and 0.150 s and Pedixplorer's `make_famid()` 0.644 s and 0.139 s.

- [ ] **`findGeneration(alignMates = TRUE)`'s speed** (DECISION NEEDED: before or after the release; Effort M, a
      guess; found S78) -- one call took 56.5 s and 54.8 s at 10,000 animals and passed 60 s at 100,000, where
      `findGeneration()` without it takes 0.009 s at 10,000 (the November study) and kinship2's `kindepth(align = TRUE)`
      7.7-7.9 s (Pedixplorer's `kindepth(align_parents = TRUE)` passed 60 s): `docs/planning/pedkindraw-timing-plan.md`
      section 3.4, single calls by `docs/planning/timing-plan-prototype/s78ProbePedkindraw.R`, not the timing method.
      `alignMates` is pedkindraw's own (G8, R123-R124; nprcgenekeepr has none), so no drift row; the drawing does not
      use it. 17h2 measures it by the method; decide with those figures. S82's record (`timing.csv`, the median of 3
      runs): pedkindraw 0.295 s at 1,000, 2.36 s at 3,000, 60.6 s at 10,000; kinship2 0.038, 0.818, 8.19 s;
      Pedixplorer 0.304, 3.97, 67.0 s; all three over 120 s at 30,000.

- [ ] **Install poppler in CI so the PDF word tests run there** (READY, Effort S; found S71, picture plan section 14.7)
      -- GitHub's Ubuntu and macOS runners have no `pdftotext` (S71's push: Ubuntu `SKIP 4 PASS 16268`, macOS `SKIP 2
      PASS 16279`, against this Mac's `SKIP 0 PASS 16283`) and Windows has Git's, which cannot read the PDF (now skipped), so
      the two tests that read a PDF's words, the guard against a PDF printed without its shapes and ids, run only on this
      Mac and in the Linux box. Add `poppler-utils` (Ubuntu) and `poppler` (macOS) to `.github/workflows/R-CMD-check.yaml`.
      S72 settled the other way (R147, picture plan section 15): `pdftools` counts the colony's 545 id words and 375
      distinct but reads whole-number boxes, so it cannot check overlap and does not replace `pdftotext`; the colony's
      SVG test (ids and overlap read in Chrome) runs on every job, and the colony's PDF test, the third that reads a PDF's
      words, again runs only where `pdftotext` reads a PDF.

- [ ] **`methodology/HANDOFFS.md` grows faster than its trimmer will archive** (DECISION NEEDED, Effort S; found S78)
      -- at S78's close-out `python3 methodology/methodology_trim.py --file methodology/HANDOFFS.md` fired (201,179 B
      against its 196,608 B budget) and then refused: "SRF 1.0208 (RED) against 1d571a4. The last archive has been
      entirely given back; archiving again resets the LEVEL and not the RATE", its rule for RED "do not archive again"
      (`--force` overrides it; not used). Since S60's archive the file grew from 92,002 B to 201,179 B, the 18 receipts
      S61-S78 5,630 B each on average (S78's 5,077 B), so its 262,144 B hard refusal is about 11 sessions away.
      Choices: shorter receipts (each field a pointer to `SESSION_NOTES.md` and `CHANGELOG.md`, which hold the
      detail), or a `--force` archive by Mark's ruling, or both.

- [ ] **Tell nprcgenekeepr its timing rows' `started` is each run's end** (READY, Effort S; found S80, fixed here
      S81, R156) -- its `tools/pedigreeComparison/runTiming.R`'s `runOnce()` makes each run's row after
      `runLimited()` returns, so `timingRuns.csv`'s `started` is the run's end (at `3e06730c5`); pedkindraw's copy now
      writes the time `runLimited()` launched the child (`tools/timing/timingHarness.R`, `launched`; timing plan dragon
      24). For an nprcgenekeepr session (R8), like `:270` and `:276`.
