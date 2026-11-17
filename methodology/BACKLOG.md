# Backlog

*Open, actionable work only. Completed history → `methodology/CHANGELOG.md`; feature inventory and future plans →
`methodology/ROADMAP.md`; each phase's scope and DONE criteria → `docs/planning/standalone-pedigree-package-plan.md`
section 4. Each item is tagged (READY | BLOCKED | DECISION NEEDED, Effort S | M | L). An item leaves this file in the
commit whose `methodology/CHANGELOG.md` entry records it done (plan R23: open work lives here, not in GitHub
issues).*

## Up Next

- [ ] **Phase 17c2: the pedigree argument is `ped` in four more exports** (READY, strict TDD; R88, R93;
      Effort S) -- `getParents(ped, ids)`, `getOffspring(ped, ids)`, `getIdsWithOneParent(ped)`,
      `addBackSecondParents(trimmedPed, ped)`; no caller passes the old names; four `DIVERGENCE.md` rows.

- [ ] **Phase 17c3: the pedigree first in four exports** (READY after 17c2, strict TDD; R89, R93; Effort M) --
      `getProbandPedigree(ped, probands)`, `getDescendantPedigree(ped, probands)`, `trimPedigree(ped, probands,
      ...)`, `hasBothParents(ped, id)`; the 23 calls by position that section 2.4 lists by line (the fidelity tool's
      six given names); four `DIVERGENCE.md` rows.

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

- [ ] **"Select by id" lists invisible routing points** (READY, Effort S; before the release, Phase 17d, R84)
      -- found S29 in Chrome: in the
      375-animal drawing the box has 571 entries, the 375 animals and 196 `__jog_` points that
      `.resolveEdgeNodeCollisions()` adds (`vignettes/drawing.Rmd`'s colony drawing shows it). The filter that
      leaves internal nodes out of the box, `R/drawPedigreeDiagram.R:292`, names `__union_`, `__dup_`, `__drop_`,
      `__bar_` and `__proj_` but not `__jog_`; nprcgenekeepr's `R/drawPedigreeDiagram.R:252` (at `b4abb9a0b`) has
      the same filter. The small drawings have no `__jog_` point, so their boxes list the animals only. Copied code:
      the drift-rule choice (mirror in nprcgenekeepr in a session there, or a `DIVERGENCE.md` row) at its pre-RED
      picker; a test reads `drawPedigreeDiagram(layout)$x$idselection$values` on a layout with jogs.

- [ ] **The legend cuts its "Same animal, again" label** (READY, Effort S; before the release, Phase 17e, R84)
      -- seen S31 on the website in headless
      Chrome (window 1400 px; each widget 776 px wide, its drawing's canvas 559 px, so the legend about 217 px): the
      row reads "Same animal; agai" in the drawings of both articles. The label is `R/drawPedigreeDiagram.R:119`,
      an edge row of visNetwork's legend; the vignettes' 700 px column was not measured. Copied code: the drift-rule
      choice at its pre-RED picker; measure first whether a shorter label or a wider legend column fixes it at
      both widths.

- [ ] **After nprcgenekeepr has the legend's section pictures, drop pedkindraw's records of the difference**
      (BLOCKED on nprcgenekeepr, Effort S) -- R81 (S28, Mark's "Port later"): nprcgenekeepr is to get S28's
      change in a session of its own there, which Mark starts (pedkindraw's sessions leave nprcgenekeepr unchanged,
      R8): `.conditionLegendImage()` beside `.conditionSectionsHandler()` in its `R/affectedConditions.R`, the
      `if (nConditions >= 2L)` block after `conditionRows` in its `R/drawPedigreeDiagram.R`, the tests of
      pedkindraw's `test_conditionLegendImage.R` and the 3 changed checks of `test_drawPedigreeDiagram.R`
      (pedkindraw `39bf333`, `b6a20bf`). Once it lands, a pedkindraw session deletes the two `DIVERGENCE.md` rows,
      removes `withoutConditionSymbols()` from `tools/compareResultsWithNprcgenekeepr.R` (the tool must then read
      600 of 600 identical with nothing set aside), moves the two copied files' headers to the new commit, and
      re-runs the drift tool (3 differ).

- [ ] **What kinship2 or Pedixplorer can do that pedkindraw cannot** (READY, Effort M, a guess; before the release,
      Phase 17f, R84) -- Mark (S26): "Add
      to backlog to document what pedkindraw does not do that kinship2 or pedixplorer can do. Later we will decide
      if those gaps should be addressed and removed." A document under `docs/research/` listing each gap with its
      evidence; deciding which to close is a later step, Mark's. Starting points: the gap table of kinship2's 25
      exports (`docs/research/kinship2-feature-gap-analysis-2026-09-20.md`, written for nprcgenekeepr before
      pedkindraw existed; re-check each row against pedkindraw's 31 exports); the comparison study's section 10
      (`docs/research/pedigree-package-comparison-2026-11.md`: no SVG or PDF export, no fitted view of a large
      pedigree that shows ids); Pedixplorer has no gap table yet (its exports and help, Bioconductor 1.8.0 in
      renv). Measure each claimed gap on a typed case (Learnings 18-19).

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
      own with the reason in the ledger, then run the gates again.

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
      nprcgenekeepr's workflow has the same line). Harmless; an `if:` per runner would silence it.

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
      divergence from nprcgenekeepr: mirror it there or record it in `DIVERGENCE.md` (plan section 5).
