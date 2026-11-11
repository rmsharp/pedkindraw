# Session Notes

**Purpose:** Continuity between sessions. Each session reads this first and writes to it before closing out.

**This file is transient — it is overwritten every session** (*"what's next, what traps?"*).
The cumulative, append-only record of *what was done, ever* lives in `CHANGELOG.md`; the commit SHA is the shared key.
At close-out, distill the durable outcome into a `CHANGELOG.md` entry — do not copy this handoff into it.

---

## ACTIVE TASK
**Task:** Phase 6b, the second half of the pedigree-basics copy slice: the 11 functions that repair and trim pedigrees
**Status:** IN PROGRESS (S7, claimed 2026-11-11 09:26 CST; Mark's orient pick "Start Phase 6b"). The planning move
is complete (S4-S6): H2 DONE in S6, so the plan and contract here are current
(`abb8548`, `86b4126`), with Mark's S2-S4 picks as rulings R16-R23, and open work is in `methodology/BACKLOG.md`
(`96f9e4b`). Phase 6a DONE in S3 (10 relationship functions; CI run `42960032938` 5/5 `Status: OK`, PASS 122 each).
**Plan:** `docs/planning/standalone-pedigree-package-plan.md`, "Phases 6-10 -- Copy slices" (`:344`; the 6b row
`:357`, "Pedigree basics, second half"; "Done 6a" `:363`); rulings R19-R22 (`:111-114`: the split, `toCharacter()`
out, fixtures not datasets, `stringi` replaced). Contract: `docs/planning/pedkindraw-api-contract.md` §4.1
(`:107`), the `addIdRecords()` paragraph (`:132`, "copied but **not exported**"), §5 (`:201`; the Phase 6 row
`:205`, `data.table` only for `addIdRecords()`).
**Session boundary:** one session; Phase 7 (kinship and twins) follows in a new one.
**Priority:** HIGH (finishes plan Phase 6; Phase 7 waits on it).

### The 6b set (measured in S3 with codetools at nprcgenekeepr `baef1e12c`)
- **Functions (11):** `addParents`, `rbindFill` (internal), `correctParentSex`, `isAddedRecord` (internal),
  `removeUnknownAnimals`, `hasBothParents`, `getIdsWithOneParent`, `addIdRecords` (internal here, exported there),
  `addBackSecondParents`, `removeUninformativeFounders`, `trimPedigree`. They call only each other and 6a's functions
  (`getFounders`, `isEmpty`, `getProbandPedigree`). Only `addIdRecords()` uses `data.table` (`rbindlist`, via
  `@importFrom`); none uses `stats` or `utils`.
- **Tests (8 files, 56 tests):** `test_addParents.R` 2, `test_correctParentSex.R` 24, `test_isAddedRecord.R` 14,
  `test_removeUnknownAnimals.R` 11, `test_addIdRecords.R` 2, `test_addBackSecondParents.R` 1,
  `test_removeUninformativeFounders.R` 1, `test_trimPedigree.R` 1. `hasBothParents` and `getIdsWithOneParent` have no
  test file of their own; `test_addBackSecondParents.R` reaches them.
- **10 of the 56 test nprcgenekeepr-only functions** (blocks by line at `baef1e12c`): `test_correctParentSex.R:122-137`,
  `:285-303`, `:323-327`, `:328-334`, `:335-341`, `:344-348`, `:356-361` (`qcStudbook()`), `:349-355`
  (`runQcStudbook()`); `test_isAddedRecord.R:113-127` (`convertDate()`), `:129-141` (`removeDuplicates()`). They test
  the colony QC pipeline, not the copied functions, so saved fixtures can't stand in for them. **Ask Mark** (pre-RED
  picker, plain words): leave them out and list them in each file's header (my recommendation), or another way.
- **Fixtures:** `pedOne`, `pedSix`, `qcPed` (all `.RData` in nprcgenekeepr `data/`) plus `smallPed` (already saved):
  `Rscript tools/makeTestFixtures.R ../nprcgenekeepr <commit> pedOne pedSix qcPed`, then add them to
  `tests/testthat/helper-fixtures.R:5-6` (the two `readRDS()` lines).
- **Help pages:** every example needs rewriting as in 6a (R21). `addBackSecondParents`, `getIdsWithOneParent`,
  `removeUninformativeFounders`, `trimPedigree` use `examplePedigree` through `qcStudbook()`; `correctParentSex`,
  `addIdRecords`, `hasBothParents` use `pedOne`; `removeUnknownAnimals` uses `smallPed`. nprcgenekeepr's
  `R/addIdRecords.R:17` `@export` is dropped here (contract `:132`); keep its `@importFrom data.table rbindlist`
  (`:16`).
  Once `trimPedigree` exists, `R/getProbandPedigree.R:21-23` (the `@param ped` text) may go back to
  `@inheritParams trimPedigree` (closer to nprcgenekeepr; say so in its header).

### What You Must Do (6b)
1. Orient. Source commit: **S6 checked** that none of 6b's R files, test files, fixture datasets or `DESCRIPTION`
   changed in nprcgenekeepr between `baef1e12c` and `3d262d628` (its HEAD then): the 7 files that did change are the
   colony overview (S1153) and `R/drawPedigreeDiagram.R` (Phase 9's, not 6b's). So copy at `baef1e12c`, as 6a did.
   If nprcgenekeepr has moved, rerun `git -C ../nprcgenekeepr diff --name-only baef1e12c HEAD -- R tests data
   DESCRIPTION` first.
2. Pre-RED picker: the 10 nprcgenekeepr-only tests (above). Then the `TDD: PRE-RED→RED` gate (`CLAUDE.md:88`,
   "Phase-gate format").
3. RED: fixtures, then the 8 test files with the copy-script pattern (S3's was in its scratchpad; the edits are listed
   in each 6a test header, e.g. `tests/testthat/test_walkPedigree.R:1-6`). Every edit matched an exact line, counted.
4. GREEN: the 11 R files (code unchanged; header and help text only); `Imports: data.table` in `DESCRIPTION`; install
   it with the dated repository set **and** `rebuild = TRUE` (Learning 3, `CLAUDE.md:157`), `renv::snapshot(dev =
   TRUE)`, then the gate. Add the 11 functions to `runCases()` (`tools/compareResultsWithNprcgenekeepr.R:44`, the
   `cases` list). The drift tool needs no change: it finds copied files by their headers.
5. DONE: as 6a (plan `:344-354`, the slice DONE line), then push once and read each CI job's `Status:` line. At
   close-out: the plan's 6b row and status block, `methodology/ROADMAP.md` (6b DONE; What's Built),
   `methodology/BACKLOG.md` (remove the 6b item; add Phase 7 as next), as `CLAUDE.md:138` says.

### Gotchas (6b)
- **Lint** only works with the package loaded (Learning 4, `CLAUDE.md:158`): the command in `CLAUDE.md:120` does that,
  and so does the gate `lint-package-zero`. A bare `lintr::lint_package()` gives false "no visible global function"
  lints.
- **renv cache trap** (Learning 3): `mockery` came back with Posit "latest" as its source although the dated
  repository was set; the gate failed it, and `renv::install("mockery", rebuild = TRUE)` fixed it. Expect the same for
  `data.table`.
- **Running R in nprcgenekeepr's folder from here** loads pedkindraw's library unless renv's variables are undone
  (Learning 5; `renvFreeEnv()` at `tools/compareResultsWithNprcgenekeepr.R:137`).
- **The results tool refuses** if the clone's file for any copied function changed since that file's header commit.
- **`$?` after a pipe** is the last command's status, not the tool's. Capture the tool's exit code without a pipe.
- **Counts in the ledgers can be loose** (Learning 8, `CLAUDE.md:162`): S3's "10 test files" was 9 and
  `helper-walkPedigree.R`. Recount from the tree before writing a number into the plan or a receipt.
- **Not pushed:** 17 commits (S3's close-out and hand-off, S4's three, S5's six, S6's six). 6b's push carries them;
  CI will see only 6b's code changes, the rest are documents. nprcgenekeepr's `3d262d628` is not pushed either
  (Mark's).
- **The dashboard shows Backlog ✗** although `methodology/BACKLOG.md` exists: the synced dashboard looks only at the
  root and `docs/` (a `methodology/BACKLOG.md` item, Mark's call). Not a missing file.
- **zsh**: an unmatched glob aborts the whole command (build the tarball in the scratchpad), and a bare word starting
  with `=` is read as a command path (quote it).
- **Paths in the copied plan and contract** name nprcgenekeepr's files unless the text says "pedkindraw's" (each
  note says so); write new text the same way.

### Key files
- `docs/planning/standalone-pedigree-package-plan.md:344-380` (copy slices: DONE line, rows, Done 6a, C2 paragraph),
  `:108-115` (R16-R23), `:19-29` (status block, update at close-out).
- `docs/planning/pedkindraw-api-contract.md:107-135` (§4.1 and the `addIdRecords()` paragraph), `:201-216` (§5).
- `methodology/BACKLOG.md:11` (the 6b item), `methodology/ROADMAP.md:15-24` (the slice table).
- `tests/testthat/helper-fixtures.R:5-6`, `tools/makeTestFixtures.R`, `tools/compareResultsWithNprcgenekeepr.R:44`.
- `CLAUDE.md:88` (phase gates), `:120` (lint), `:138` (what sessions here keep up to date), `:157-162` (Learnings
  3-8).

### How You Will Be Evaluated
The user rates every session's handoff. Your handoff will be scored on:
1. Was the ACTIVE TASK block sufficient to orient the next session?
2. Were key files listed with line numbers?
3. Were gotchas and traps flagged?
4. Was the "what's next" actionable and specific?

---

## Session History

*Session history accumulates below this line. Newest session at the top.*
*S1-S5's entries were removed in S3-S6 (FM #28): their durable records are the receipts in `HANDOFFS.md` and the
entries in `CHANGELOG.md`.*

### What Session 7 Did
**Deliverable:** plan Phase 6b: copy the 11 functions that repair and trim pedigrees, tests first (IN PROGRESS)
**Started:** 2026-11-11 09:26 CST · **Model:** Claude Opus 5.5
**Status:** Session claimed. Work beginning. Mark's orient pick (picker): "Start Phase 6b".
**Ledger:** `CHANGELOG: pending` — the claim commit's `CHANGELOG.md` entry says (in progress); Phase 3F records the rest.

### Session 5 Handoff Evaluation (by Session 6)
**Score: 9/10.**
- **What helped:** every H2 edit site was cited with its line and quoted words, and every one was right at S6's start
  (status block `:19-29`, note `:6-9` and `:17`, §1.3 `:64`, R15 `:104`, Phase 5-10 rows `:309-342`, §5 `:378`;
  contract `:192`, `:248-250`, `:262`, note `:15`); the warning that rewriting the status block falsifies the note and
  changes its count; the line-shift gotcha; the zsh notes; the commit-size plan (1, 1, 3 files).
- **What was missing:** R22 (`stringi`) is recorded as Mark's pick only in S3's committed notes (`82337ff`), not the
  ledger or receipts the handoff named as sources; `kinship()`'s arguments were renamed by C13 in the clean-room plan's
  section 2, so the contract's signature was stale (not on H2's list); S1127 in the pointer range was not pedkindraw
  work; the dashboard cannot see `methodology/BACKLOG.md`. The first three came from S4's hand-over plan, which S5
  carried forward.
- **What was wrong:** nothing found wrong in S5's own claims.
- **ROI:** high. Commit 1 was mostly typing; discovery went to the four gaps above.

### What Session 6 Did
**Deliverable:** step H2 of `docs/planning/planning-handover-plan.md`: the copied plan and contract brought up to date,
`methodology/ROADMAP.md` filled, `methodology/BACKLOG.md` created, the pre-repository pointer entry (DONE)
**Started:** 2026-11-11 00:35 CST · **Model:** Claude Opus 5.5 · **Mark's picks (two pickers, first try):** "Do step
H2"; "Add all eight" rulings (R16-R23).
**Commits:** `ccd6e6c` claim; `abb8548` plan (status block, §1.3, R16-R23, Phase 5 and 6a Done records, rows 6a/6b,
C2 in Phases 7, 8 and 10, §5; note now 17 lines); `86b4126` contract (§5, §9 rows 5/7/8/10, §10 item 2; beyond the
list: C13's argument names in §4 and §4.2, the clean-room differences, one line in §3; note 16 lines); `96f9e4b`
ROADMAP, BACKLOG, pointer entry; `9dc150f` close-out 1 (hand-over plan H2 DONE and `:119`; Learning 8; backlog item
for the dashboard); close-out 2 (these notes, the receipt, the ledger, a backlog line rewrapped). Nothing pushed.
**Verified:** `git log -- docs/research` shows only H1's two commits; ROADMAP 0 seed comments; BACKLOG 9 items, 9
tagged (10 after close-out); each of R16-R23 has a session and a source; no new line over 120 columns in the plan or
contract; `R CMD check --as-cran` Status 1 NOTE, the allowed one (Maintainer, New submission); tests `[ FAIL 0 | WARN
0 | SKIP 0 | PASS 122 ]`; tarball 0 `docs/` or `methodology/` entries; `quality_ratchet: 2/2 pass · 0 fail · 0
unmeasured · results 28dd5b310acd · manifest 114e971f4452`; dashboard runs (82/100). The drift and results tools were
not rerun: no R, test or tool file changed.
**Self-assessment: 8/10.**
+ Every edit anchored on exact text and asserted before writing; every DONE criterion checked with its output.
+ Two pickers, both plain, both answered first try; no corrections from Mark.
+ Re-checked the carried facts and found four gaps (R22's source, C13, S1127, "10 test files"); each fixed or recorded,
  and the pattern written down (Learning 8).
- Slips caught before commit, each costing a pass: the note-length formula off by one; R18 first named
  `LEARNINGS.md`; the first plan draft wrote pedkindraw's paths bare, against the note's own rule; one 123-column
  backlog line committed and rewrapped at close-out.
- Changed the contract beyond H2's list (C13 and C2 facts); kept small and named in the commit message.
**Ledger:** `CHANGELOG.md` S6 entry (DONE).
