# Backlog

*Open, actionable work only. Completed history → `methodology/CHANGELOG.md`; feature inventory and future plans →
`methodology/ROADMAP.md`; each phase's scope and DONE criteria → `docs/planning/standalone-pedigree-package-plan.md`
section 4. Each item is tagged (READY | BLOCKED | DECISION NEEDED, Effort S | M | L). An item leaves this file in the
commit whose `methodology/CHANGELOG.md` entry records it done (plan R23: open work lives here, not in GitHub
issues).*

## Up Next

- [ ] **Phase 8, second session: the kinship2 comparison, fidelity cases, push and CI** (READY, Effort M-L) -- plan
      R30. The first session (S9) copied all the layout code and its 295 tests. Left: (1) RED/GREEN for
      `R/comparePedigreeStructure.R` (374 lines at nprcgenekeepr `baef1e12c`, 4 internal functions, reached by no
      export; calls `utils::capture.output()`, imported since S9) with `test_comparePedigreeStructure.R` (38 tests, 1,240
      lines; 9 `skip_if_not_installed("kinship2")`) and `helper-comparePedigreeStructure.R` (131): their 16
      `nprcgenekeepr:::` calls (helper `:113-118`, test `:505-1020`) become plain calls, and 2 `system.file()` rhesus
      reads (test `:662`, `:1036`) become `test_path("fixtures", ...)`; S9's survey found nothing else they need
      from nprcgenekeepr. (2) The layout's cases in `tools/compareResultsWithNprcgenekeepr.R`'s `runCases()` (both
      exports, both edge styles, twins, a `kinshipMatrix`, the error stops), sized far below kinship's 2,000 (measured
      S9: 1.0 s direct and 1.9 s rectilinear on the 375-animal rhesus pedigree, 180 s direct on the 3,694-animal
      `examplePedigree`; nprcgenekeepr's app draws rectilinear only up to 400 animals), each checked to reach its branch (Learning 11): 65 lines of the
      new code no copied test reaches (`R/makePedigreeDiagramData.R` 570, 757, 980, 1275, 1321, 2247-2449 in parts,
      2546, 2714, 3043-3047; `R/orderRootSubtrees.R` 118, 131; `R/positionTreeApportion.R` 388-435 in parts).
      (3) Push once (S8's 2 close-out commits and all of S9's), read each CI job's `Status:` line; then Phase 8's
      DONE close-out (plan status block and row 8, `methodology/ROADMAP.md`).

- [ ] **Phases 9-17** (BLOCKED -- each waits for the one before, Effort L) -- the rest of the plan: the copy
      slices for the renderer and shrink (9-10; 10 is nprcgenekeepr's clean-room code under C2), then
      new work (11-15), documentation (16) and the CRAN submission (17, its own plan first). Scope and DONE
      criteria: the plan's section 4; summary: `methodology/ROADMAP.md`. Each phase gets its own item here when it
      is next. Phase 9 also takes `deceasedSlash.R`, `affectedConditions.R`'s lines 77-201 (then deletes
      `DIVERGENCE.md`'s three rows) and the 3 Chrome tests of `test_positionMatingUnitForest.R` (R31, R32); Phase 10
      deletes `tests/testthat/helper-shrinkPedigreeStandIn.R`, so the three Track B tests call the real
      `shrinkPedigree()`.

## Waiting on Mark

- [ ] **`pedkindraw.Rproj`: commit it or ignore it** (DECISION NEEDED, Effort S) -- an RStudio project file,
      untracked since pedkindraw S2 and made by no session. `.Rbuildignore` already keeps `*.Rproj` out of the built
      package and `.gitignore` ignores only `.Rproj.user`, so either choice is one small commit: `git add` it, or add
      `pedkindraw.Rproj` to `.gitignore`.

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
      `CLAUDE.md`; the seed's own note says to delete the entry then).

- [ ] **CI notices: `actions/checkout@v5` and Ubuntu 26** (READY, Effort S) -- warnings, not failures, on run
      `42960032938`: Node 20 is deprecated under `actions/checkout@v4`, and `ubuntu-latest` moves to Ubuntu 26
      (from 2026-10-19). `.github/workflows/R-CMD-check.yaml:39` (`actions/checkout@v4`) and `:30-32` (the three
      `ubuntu-latest` jobs). S7: the move has happened (the runners are Ubuntu 26.04, "resolute"), and in run
      `43052891573` attempt 1 all three Ubuntu jobs failed installing R, unable to resolve Ubuntu's package servers
      for an hour; re-running them passed (attempt 2). Watch whether it recurs before pinning a runner image. S8: run
      `43106941979` passed on all five jobs at the first attempt, Ubuntu 26.04 included (the same two notices).

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

- [ ] **Review argument names before the first CRAN release** (BLOCKED -- the last session before Phase 17, Effort M)
      -- contract section 6 and section 10 item 4: the copied functions keep nprcgenekeepr's names, so
      `findGeneration(id, sire, dam)` sits beside `kinship(id, fatherId, motherId)`; also whether `addIdRecords()`
      should be exported. Each change is recorded as a divergence.
