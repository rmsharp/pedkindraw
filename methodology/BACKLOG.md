# Backlog

*Open, actionable work only. Completed history → `methodology/CHANGELOG.md`; feature inventory and future plans →
`methodology/ROADMAP.md`; each phase's scope and DONE criteria → `docs/planning/standalone-pedigree-package-plan.md`
section 4. Each item is tagged (READY | BLOCKED | DECISION NEEDED, Effort S | M | L). An item leaves this file in the
commit whose `methodology/CHANGELOG.md` entry records it done (plan R23: open work lives here, not in GitHub
issues).*

## Up Next

- [ ] **Phase 7: copy kinship and twins** (READY, Effort M) -- plan Phase 7 (the row "Kinship and twins"): copy
      `R/checkTwinRelations.R` and nprcgenekeepr's clean-room `R/kinship.R` and `R/mzTwinGroups.R` (C2; `kinship()`'s
      parent arguments are `fatherId` and `motherId`, C13), `Imports: Matrix`. Measured in S7 at nprcgenekeepr
      `baef1e12c` (the three files are unchanged to `3d262d628`): `kinship()` calls `mzTwinGroups()` and reads two
      constants, `sexCodes` (copied in 6b, R25) and `mzTwinIdsAbsentMessage` (in `R/mzTwinGroups.R`); 8 test files
      there match `test_kinship*.R` and not all of them test `kinship()`, plus `test_checkTwinRelations.R`. Run the
      Learning 9 survey (`CLAUDE.md`) and count the tests before the pre-RED picker.

- [ ] **Phases 8-17** (BLOCKED -- each waits for the one before, Effort L) -- the rest of the plan: the copy
      slices for the layout engine, the renderer and shrink (8-10, nprcgenekeepr's clean-room code under C2), then
      new work (11-15), documentation (16) and the CRAN submission (17, its own plan first). Scope and DONE
      criteria: the plan's section 4; summary: `methodology/ROADMAP.md`. Each phase gets its own item here when it
      is next.

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
      at the copy's commit. Phase 7 adds a second constant (`mzTwinIdsAbsentMessage`). Fix: compare every top-level
      assignment, not only functions, or list the constants by name.

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
      for an hour; re-running them passed (attempt 2). Watch whether it recurs before pinning a runner image.

- [ ] **Report a vacuous test to nprcgenekeepr** (READY, Effort S) -- the first expectation of
      `test_findPedigreeNumber.R` checks the ids containing "1", and the Lacy pedigree's ids are letters, so it
      checks nothing (0 ids match; found S3, rechecked S6). pedkindraw copied the file unchanged
      (`tests/testthat/test_findPedigreeNumber.R:26`). For an nprcgenekeepr session: a fix there is then mirrored
      here or recorded in `DIVERGENCE.md` (plan section 5).

## Later

- [ ] **`findPedigreeNumber()`'s speed** (READY, Effort M) -- 12.9 s for 100,000 animals, close to the square of the
      size (contract section 7); new work after the copy (contract section 10 item 5). A faster version here is a
      divergence from nprcgenekeepr: mirror it there or record it in `DIVERGENCE.md` (plan section 5).

- [ ] **Review argument names before the first CRAN release** (BLOCKED -- the last session before Phase 17, Effort M)
      -- contract section 6 and section 10 item 4: the copied functions keep nprcgenekeepr's names, so
      `findGeneration(id, sire, dam)` sits beside `kinship(id, fatherId, motherId)`; also whether `addIdRecords()`
      should be exported. Each change is recorded as a divergence.
