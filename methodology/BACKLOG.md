# Backlog

*Open, actionable work only. Completed history → `methodology/CHANGELOG.md`; feature inventory and future plans →
`methodology/ROADMAP.md`; each phase's scope and DONE criteria → `docs/planning/standalone-pedigree-package-plan.md`
section 4. Each item is tagged (READY | BLOCKED | DECISION NEEDED, Effort S | M | L). An item leaves this file in the
commit whose `methodology/CHANGELOG.md` entry records it done (plan R23: open work lives here, not in GitHub
issues).*

## Up Next

- [ ] **Phase 6b: copy the 11 functions that repair and trim pedigrees** (READY, Effort M) -- the second half of
      plan Phase 6 (R19): `addParents`, `rbindFill`, `correctParentSex`, `isAddedRecord`, `removeUnknownAnimals`,
      `hasBothParents`, `getIdsWithOneParent`, `addIdRecords` (copied, not exported: contract section 4.1),
      `addBackSecondParents`, `removeUninformativeFounders`, `trimPedigree`. 8 test files, 56 tests; fixtures
      `pedOne`, `pedSix`, `qcPed`; `Imports: data.table`. 10 of the 56 tests exercise nprcgenekeepr-only functions
      (`qcStudbook()`, `runQcStudbook()`, `convertDate()`, `removeDuplicates()`): Mark decides at the pre-RED picker.
      The measured set and the steps: `methodology/SESSION_NOTES.md`, "THEN: Phase 6b". Its push carries every
      unpushed commit since S3.

- [ ] **Phases 7-17** (BLOCKED -- each waits for the one before, Effort L) -- the rest of the plan: the copy
      slices for kinship and twins, the layout engine, the renderer and shrink (7-10, nprcgenekeepr's clean-room
      code under C2), then new work (11-15), documentation (16) and the CRAN submission (17, its own plan first).
      Scope and DONE criteria: the plan's section 4; summary: `methodology/ROADMAP.md`. Each phase gets its own
      item here when it is next.

## Waiting on Mark

- [ ] **`pedkindraw.Rproj`: commit it or ignore it** (DECISION NEEDED, Effort S) -- an RStudio project file,
      untracked since pedkindraw S2 and made by no session. `.Rbuildignore` already keeps `*.Rproj` out of the built
      package and `.gitignore` ignores only `.Rproj.user`, so either choice is one small commit: `git add` it, or add
      `pedkindraw.Rproj` to `.gitignore`.

- [ ] **Whether pedkindraw copies nprcgenekeepr's colony overview** (DECISION NEEDED -- later, Effort L, a guess) --
      nprcgenekeepr is building a colony overview (its issue #138; `nprcgenekeepr:docs/planning/colony-overview-design.md`,
      ruling D8: "Whether pedkindraw copies it later is Mark's call"; scoping
      `nprcgenekeepr:docs/planning/colony-overview-scoping.md:117-118`). Not in the plan or the contract; it would
      need a ruling and a plan change first.

## Ready, small

- [ ] **Point the context-budget tool at `methodology/`** (READY, Effort S) -- R18: a session of its own.
      `methodology/.context-budget.json` names `SESSION_NOTES.md` at the root, but this repository keeps it in
      `methodology/`, so `python3 methodology/context_budget.py --status` reports it "file does not exist" and the
      budget is UNMEASURED (S6). Its `LEARNINGS.md` entry names a file this project does not keep (learnings are in
      `CLAUDE.md`; the seed's own note says to delete the entry then).

- [ ] **CI notices: `actions/checkout@v5` and Ubuntu 26** (READY, Effort S) -- warnings, not failures, on run
      `42960032938`: Node 20 is deprecated under `actions/checkout@v4`, and `ubuntu-latest` moves to Ubuntu 26
      (from 2026-10-19). `.github/workflows/R-CMD-check.yaml:39` (`actions/checkout@v4`) and `:30-32` (the three
      `ubuntu-latest` jobs).

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
