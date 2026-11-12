# Backlog

*Open, actionable work only. Completed history → `methodology/CHANGELOG.md`; feature inventory and future plans →
`methodology/ROADMAP.md`; each phase's scope and DONE criteria → `docs/planning/standalone-pedigree-package-plan.md`
section 4. Each item is tagged (READY | BLOCKED | DECISION NEEDED, Effort S | M | L). An item leaves this file in the
commit whose `methodology/CHANGELOG.md` entry records it done (plan R23: open work lives here, not in GitHub
issues).*

## Up Next

- [ ] **Phase 11: the shrink helpers and `bitSize()` as exports** (READY, Effort M) -- plan row 11 (R3, R11);
      contract section 4.3 (`docs/planning/pedkindraw-api-contract.md:154-157`): `bitSize(ped)`,
      `findUnavailable(ped, genotyped)`, `findAvailNonInform(ped, genotyped, affected = NULL)` and
      `findAvailAffected(ped, genotyped, affected, affstatus)`, ids in a data frame, return shapes and errors settled
      in RED (contract `:160-162`). New code, not a copy: nprcgenekeepr's clean-room rewrite (its S1139, `e2bba9fb2`)
      dropped the old seven helpers (`.bitSizeOf()` to `.findAvailAffected()`, ports of the kinship2 functions these
      exports are named after; contract `:70`), and the copy (S13) holds only `.bitSize(sireIdx, damIdx, present)`, `.isParent()`, `.removalPass()` and
      `.checkShrinkInput()`, which take row positions, not ids. `R/shrinkPedigree.R` is copied code: changing it makes
      a drift row (plan section 5), so the exports go in a file of their own. A pre-RED picker first: whether they
      call the copied internals or are written apart (R11 governs anything written from kinship2's behaviour), and
      whether each must give `shrinkPedigree()`'s answer for its tier on the Phase 1 pedigrees.

- [ ] **Phases 12-17** (BLOCKED -- each waits for the one before, Effort L) -- the rest of the plan: new work
      (12-15), documentation (16) and the CRAN submission (17, its own plan first). Scope and DONE criteria: the
      plan's section 4; summary: `methodology/ROADMAP.md`. Each phase gets its own item here when it is next.

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
