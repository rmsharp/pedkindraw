# Backlog

*Open, actionable work only. Completed history → `methodology/CHANGELOG.md`; feature inventory and future plans →
`methodology/ROADMAP.md`; each phase's scope and DONE criteria → `docs/planning/standalone-pedigree-package-plan.md`
section 4. Each item is tagged (READY | BLOCKED | DECISION NEEDED, Effort S | M | L). An item leaves this file in the
commit whose `methodology/CHANGELOG.md` entry records it done (plan R23: open work lives here, not in GitHub
issues).*

## Up Next

- [ ] **Phase 13's second session: `findUnrelated()`** (READY, Effort M, a guess; `checkPedigree()` DONE S17,
      R49-R51) -- plan row 13 (`docs/planning/standalone-pedigree-package-plan.md:505`; R9; R49: Phase 13 takes two
      sessions, this is the second); contract section 4.4 (`docs/planning/pedkindraw-api-contract.md:173`, `:187`):
      `findUnrelated(ped, genotyped)`, character ids that are genotyped, with kinship 0 between every two, to which
      no genotyped animal can be added, the same answer every time; it stops on a `genotyped` of the wrong length
      or with an `NA`. kinship2's `pedigree.unrelated()` is a random greedy method (its help page: the row of the
      kinship matrix with the most zeros first, ties at random), so the same answer every time needs a tie rule
      (byte order, C16, as R44 and R46). It must give sets as large as kinship2's and Pedixplorer's on the
      comparison's three pedigrees: 4 and 2 on `sample.ped`'s families 1 and 2 with their own `avail`, 44 on
      `rhesus375` with 30% available drawn after `set.seed(42L)` (section 5.4,
      `docs/research/pedigree-package-comparison-2026-11.md:392`; the runs: nprcgenekeepr
      `tools/pedigreeComparison/runAgreement.R:316` `compareUnrelated()`, whose "maximal" test is the definition,
      and `:468`), and finish 10,000 animals (kinship2 6.5 s, section 7, `:424`). Open for the pre-RED picker: what
      it does with a pedigree `checkPedigree()` faults (a cycle, an own parent or a duplicate id leaves kinship
      undefined); whether relatedness comes from the copied `kinship()` (dense, 8 n^2 bytes) or from shared
      ancestors (a prediction, not measured: kinship above 0 exactly when two animals share an ancestor or one
      descends from the other; compare it with `kinship()` on every fixture pedigree before a picker states it); the
      tie rule. Every expected value computed before RED (Learning 18); kinship2 from its help page and measured
      results only (R14), each case under a time limit (Learning 19). Pedixplorer is not installed: installing it
      (Bioconductor) is a renv change under Learning 3, so a picker choice. Plan Phases 14-17 follow, each waiting
      for the one before (scope: the plan's section 4; summary: `methodology/ROADMAP.md`); each gets its own item
      here when it is next.

- [ ] **Tests for full coverage** (READY, Effort M) -- Mark's request (S13, after its close-out): add tests until
      the test suite reaches every statement in `R/`. Measured S13 with `covr::package_coverage(type = "tests")` on
      the code of `82f2ef3`: 97.16%, 45 of 1,811 statements missed, in 7 files (covr's first line of each
      statement). Re-measured S14 on `dff6509`: 97.32%, 44 of 1,872 (Phase 11's 61 statements all reached, and its
      tests reach `R/shrinkPedigree.R:97`, the `affected` length error): `R/makePedigreeDiagramData.R` 31 (570, 757,
      980, 1275, 1321, 2247, 2268, 2309, 2319, 2320, 2324, 2336, 2337, 2339, 2340, 2341, 2346, 2360, 2372, 2403,
      2404, 2405, 2406, 2407, 2411, 2428, 2445, 2546, 2714, 3043, 3044); `R/positionTreeApportion.R` 6 (388, 392,
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
      `R/checkPedigree.R` was added in `R/`, 83 of 83).

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

- [ ] **Review argument names before the first CRAN release** (BLOCKED -- the last session before Phase 17, Effort M)
      -- contract section 6 and section 10 item 4: the copied functions keep nprcgenekeepr's names, so
      `findGeneration(id, sire, dam)` sits beside `kinship(id, fatherId, motherId)`; also whether `addIdRecords()`
      should be exported. Each change is recorded as a divergence.
