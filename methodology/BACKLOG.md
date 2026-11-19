# Backlog

*Open, actionable work only. Completed history → `methodology/CHANGELOG.md`; feature inventory and future plans →
`methodology/ROADMAP.md`; each phase's scope and DONE criteria → `docs/planning/standalone-pedigree-package-plan.md`
section 4. Each item is tagged (READY | BLOCKED | DECISION NEEDED, Effort S | M | L). An item leaves this file in the
commit whose `methodology/CHANGELOG.md` entry records it done (plan R23: open work lives here, not in GitHub
issues).*

## Up Next

- [ ] **The speed and size-limits vignette, once pedkindraw times itself** (BLOCKED on a plan for pedkindraw's own
      timing runs, Effort L, a guess; before the release, Phases 17g-17i of
      `docs/planning/cran-submission-plan.md`, R84)
      -- R82 (S30): "the comparison of pedkindraw with kinship2 and Pedixplorer"
      (Mark) waits until pedkindraw has timing runs of its own installed code, under a plan of its own that
      replaces R79's summary of nprcgenekeepr's records. A draft built to R79 is on the branch
      `draft/speed-vignette` (`612eed9`, not merged): `vignettes/speed.Rmd` (nine captioned tables, a definition of
      each computation, Mark's request) and `tools/checkSpeedTables.R`, whose design (a marker before each table,
      each table and caption built from the result files and compared cell for cell, `--print=<name>`, a failure
      on any unmarked table) can check the returning vignette's numbers against pedkindraw's own results. When it
      returns: point to it from `?pedkindraw`'s "Getting started" (`R/pedkindraw-package.R:42`), the
      getting-started vignette's "Where next" and the drawing vignette's "How large a drawing can be", which states
      the limit from the November 2026 records (Mark's S29 pick); the installed size has about 800 KB left for its
      page.

- [ ] **Phases G13-G17: the other gaps, before the release** (READY in order, G13 under way; Effort L altogether, 20-30
      sessions, a guess, the sum of the rows with G13's 5 left by R133; R97; G1 DONE in S42, R102-R105; G2 DONE in S43, R106-R107; G3 DONE in S44, R108-R110; G4
      DONE in S45, R111-R113; G5 DONE in S46, R114-R116; G6 DONE in S47, R117-R119; G7 DONE in S48, R120-R122; G8
      DONE in S49, R123-R124; G9 DONE in S50, R125-R126, the last size-S addition; G10 DONE in S51, R127-R128; G11
      DONE in S52, R129-R130, 1 session of the row's 2-3; G12 DONE in S53, R131-R132, 1 session of the row's 2-3; G13's first mark of six, genotyped, DONE in S54, R133-R134;
      next its carrier mark, then proband with consultand, evaluated, infertile, miscarriage, one kind a session, R133) --
      `docs/planning/gaps-and-shared-code-plan.md` section 5.1, one row per phase with its case, choices, DONE,
      commands and surface: G13-G14 the M additions (B3's marks, B5's sizes); G15-G17
      the L additions (B1, A1 with A2, A3), each starting with a planning session of its own. 17g follows G17.

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

- [ ] **The drawing vignette shows a measured trait drawn by a cut-off** (READY, Effort S, documentation; G12,
      R131-R132) -- `vignettes/drawing.Rmd`'s "Conditions" (`:181`) says how true-or-false columns are drawn but not
      `conditionThresholds`; a paragraph and one drawing (such as `c(affected_glucose = ">= 126")`), with a hidden
      check of the legend's label and the fills, as that section's other checks do. Mark asked in S52 whether the
      tutorials say how conditions are drawn.

- [ ] **A converted Pedixplorer object's `avail` is not drawn as genotyped** (NEEDS DECISION, Effort S; found S54, G13,
      R134) -- `asPedFrame()` returns Pedixplorer's `avail` under that name (`R/asPedFrame.R:315`), and
      `makePedigreeMatingLayout()` reads only `genotyped` (Mark's pick over `avail`, which would change 10 of
      samplePed's 50 compared results), so a converted object's genotyped animals are drawn unmarked until the user
      renames the column. Choose by picker: `asPedFrame()` also writes `genotyped` from `avail`, or says so in its
      help and the drawing vignette, or nothing. Also measured: text "1" and "0" (a CSV read with every column as
      text) stops, as R134 says; numbers 1 and 0 read.

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

## Later

- [ ] **`findPedigreeNumber()`'s speed** (READY, Effort M) -- 12.9 s for 100,000 animals, close to the square of the
      size (contract section 7); new work after the copy (contract section 10 item 5). A faster version here is a
      divergence from nprcgenekeepr: a `DIVERGENCE.md` row marked "at the switch" (R98, R101).
