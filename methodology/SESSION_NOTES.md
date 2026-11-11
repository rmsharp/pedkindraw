# Session Notes

**Purpose:** Continuity between sessions. Each session reads this first and writes to it before closing out.

**This file is transient — it is overwritten every session** (*"what's next, what traps?"*).
The cumulative, append-only record of *what was done, ever* lives in `CHANGELOG.md`; the commit SHA is the shared key.
At close-out, distill the durable outcome into a `CHANGELOG.md` entry — do not copy this handoff into it.

---

## ACTIVE TASK
**Task:** step H2 of `docs/planning/planning-handover-plan.md` (`:212-268`): bring this repository's copies of the plan
and the contract up to date, fill `methodology/ROADMAP.md`, create `methodology/BACKLOG.md`, and add one pointer entry
to `methodology/CHANGELOG.md` for the work done in nprcgenekeepr before this repository existed.
**Status:** READY. H1 DONE in S5: the five documents copied byte for byte from nprcgenekeepr `3d262d628` (`f2249d0`
plan and contract, `ec910a6` three studies), a provenance note under each title (`38633f1`), `CLAUDE.md`,
`DIVERGENCE.md` and the two tools pointed at the copies (`3e192e9`). Mark's S5 pick (orient picker): "H1 only".
**Session boundary:** H2 is one session; Phase 6b follows in a new session (hand-over plan `:266`).
**Priority:** HIGH (Mark's direction; Phase 6b waits until H2 is DONE).

### What You Must Do (H2; hand-over plan section 4, "H2")
1. Orient. Then **one picker** (plain words, Learning 2) confirming the rulings to add as R16 on, listed at hand-over
   plan `:221-228` (S2 allowed NOTE, S2 `LICENSE` year and `Authors@R`, S2 context-budget fix in its own session, S3
   Phase 6 split, S3 `toCharacter()` out, S3 fixtures not datasets, S3 `stringi` replaced by base R, S4 the move).
   Each needs a session and a source in this repository's `methodology/CHANGELOG.md` or `methodology/HANDOFFS.md`.
2. **Commit 1, the plan** (`docs/planning/standalone-pedigree-package-plan.md`; line numbers as of S5):
   - status block `:19-29` (the freeze sentence, "**Frozen 2026-11-11:**", is `:26-29`), replaced by the state now;
   - **the provenance note's sentence about that block, `:6-9`**, which is false once the block is rewritten; shorten
     it, then **recount the note** and fix the number it states at `:17` ("this one adds 16 lines");
   - §1.3 `:64` ("Phases 1-4 run here; Phases 5 onward run in the new repository");
   - §2: new rows after R15 `:104` (C2 is `:102`);
   - Phase 5 `:309`; Phase 6 row `:338`; Phases 7, 8 and 10 rows `:339`, `:340`, `:342` (C2's facts:
     nprcgenekeepr `docs/planning/cleanroom-rewrite-plan.md` §4.8, `:365-375` there);
   - §5 `:378` ("differs from the installed nprcgenekeepr's").
3. **Commit 2, the contract** (`docs/planning/pedkindraw-api-contract.md`): §5 `:192` (Phase 6 row `:196`), §9 rows
   `:248-250`, §10 item 2 `:262` (closed by C2; the plan says so at `:108`). Its note (`:6-7`) says "(step H2 of the
   hand-over plan first)"; leave it, or put it in the past tense and recount (`:15` states 14 lines).
4. **Commit 3**: `methodology/ROADMAP.md` (18 lines, 4 seed comments, all to answer); `methodology/BACKLOG.md` (new;
   the items at hand-over plan `:243-249`); the pointer entry (the sessions at `:250-252`).
5. DONE (hand-over plan `:254-263`): the studies unchanged since H1 (`git log --oneline -- docs/research` shows only
   `38633f1` and `ec910a6`); `R CMD check --as-cran` 0/0/allowed NOTE; tests; `quality_ratchet.py --run`; dashboard. No
   push.

### Key files
- `docs/planning/planning-handover-plan.md:212-268` (H2's steps and DONE), `:270-279` (section 5, after the move).
- `docs/planning/standalone-pedigree-package-plan.md:3-17` (its provenance note), `:19-30` (status block).
- `docs/planning/pedkindraw-api-contract.md:3-15` (its note), `:192`, `:243-250`, `:258-268` (section 10, the end).
- `methodology/ROADMAP.md:1-18` (the seed). `CLAUDE.md:21-25` (governing documents, re-pointed in S5), `:138` (what
  sessions here keep up to date), `:161` (Learning 7, new).

### Gotchas (H2)
- **Line numbers move as you edit** (Learning 7, `CLAUDE.md:161`). Every number above is as of S5's close-out; H2's own
  edits move them. Find each line by the words quoted with it, and re-measure any citation you write after your last
  edit to that file.
- **Line numbers inside the copied text are nprcgenekeepr's**: a plan line it cites is 16 lines lower here, a contract
  line 14, a study line 13 (each note says so). The hand-over plan's own H2 text was corrected in S5 (`:88` became
  `:108` of the copy; `CLAUDE.md:115` and `:138` became `:117` and `:140`).
- **The studies are not edited** (dated records); H2's DONE checks `git log -- docs/research`.
- **zsh**: an unmatched glob aborts the whole command (build the tarball in the scratchpad, as S5 did), and a bare word
  starting with `=` is read as a command path (`echo =====` fails with "==== not found"; quote it).
- **Five-file cap per commit**: H2's commits are 1, 1 and 3 files; the close-out adds its own.
- **Not pushed:** 11 commits (S3's close-out and hand-off, S4's three, S5's six with its close-out); Phase 6b's push
  carries them. nprcgenekeepr's `3d262d628` is
  not pushed either (Mark's).
- **Still waiting on Mark** (H2 lists them in `methodology/BACKLOG.md`): `pedkindraw.Rproj` (untracked, not made by a
  session: commit or ignore); the context-budget path fix (`python3 methodology/context_budget.py --status` reports
  `SESSION_NOTES.md` "file does not exist": it looks at the root, not `methodology/`; Mark's S2 ruling, its own session).

## THEN: Phase 6b
**Task:** Phase 6b, the second half of the pedigree-basics copy slice: the 11 functions that repair and trim pedigrees
**Status:** READY after H2. Phase 6a DONE in S3 (10 relationship functions; CI run `42960032938` 5/5 `Status: OK`, PASS
122 each). Mark split Phase 6 in S3 (picker): 6a = 10 functions, 6b = 11. `toCharacter()` stays out (Mark, S3; R13).
**Plan:** `docs/planning/standalone-pedigree-package-plan.md`, section "Phases 6-10 -- Copy slices" (`:326`; the
Phase 6 row `:338`) and, after H2, its Phase 6 split. Contract: `docs/planning/pedkindraw-api-contract.md` §4.1 (`:102`),
the `addIdRecords()` paragraph (`:127`; copied but **not exported**), §5 (`:192`; `data.table` only for
`addIdRecords()`). These numbers are S5's; H2 edits both files, so find each by its text.
**Priority:** HIGH (finishes plan Phase 6; Phase 7, kinship and twins, waits on it).

### The 6b set (measured in S3 with codetools at nprcgenekeepr `baef1e12c`)
- **Functions (11):** `addParents`, `rbindFill` (internal), `correctParentSex`, `isAddedRecord` (internal), `removeUnknownAnimals`,
  `hasBothParents`, `getIdsWithOneParent`, `addIdRecords` (internal here, exported there), `addBackSecondParents`,
  `removeUninformativeFounders`, `trimPedigree`. They call only each other and 6a's functions (`getFounders`, `isEmpty`,
  `getProbandPedigree`). Only `addIdRecords()` uses `data.table` (`rbindlist`, via `@importFrom`); none uses `stats` or `utils`.
- **Tests (8 files, 56 tests):** `test_addParents.R` 2, `test_correctParentSex.R` 24, `test_isAddedRecord.R` 14,
  `test_removeUnknownAnimals.R` 11, `test_addIdRecords.R` 2, `test_addBackSecondParents.R` 1,
  `test_removeUninformativeFounders.R` 1, `test_trimPedigree.R` 1. `hasBothParents` and `getIdsWithOneParent` have no test
  file of their own; `test_addBackSecondParents.R` reaches them.
- **10 of the 56 test nprcgenekeepr-only functions** (blocks by line at `baef1e12c`): `test_correctParentSex.R:122-137`,
  `:285-303`, `:323-327`, `:328-334`, `:335-341`, `:344-348`, `:356-361` (`qcStudbook()`), `:349-355` (`runQcStudbook()`);
  `test_isAddedRecord.R:113-127` (`convertDate()`), `:129-141` (`removeDuplicates()`). They test the colony QC pipeline,
  not the copied functions, so saved fixtures can't stand in for them. **Ask Mark** (pre-RED picker, plain words): leave
  them out and list them in each file's header (my recommendation), or another way.
- **Fixtures:** `pedOne`, `pedSix`, `qcPed` (all `.RData` in nprcgenekeepr `data/`) plus `smallPed` (already saved):
  `Rscript tools/makeTestFixtures.R ../nprcgenekeepr <commit> pedOne pedSix qcPed`, then add them to
  `tests/testthat/helper-fixtures.R:5-6`.
- **Help pages:** every example needs rewriting as in 6a. `addBackSecondParents`, `getIdsWithOneParent`,
  `removeUninformativeFounders`, `trimPedigree` use `examplePedigree` through `qcStudbook()`; `correctParentSex`,
  `addIdRecords`, `hasBothParents` use `pedOne`; `removeUnknownAnimals` uses `smallPed`. `addIdRecords.R:17` `@export`
  becomes not exported (contract `:127` as of S5; keep its `@importFrom data.table rbindlist` at `:16`). Once
  `trimPedigree` exists, `R/getProbandPedigree.R:21-23` may go back to `@inheritParams trimPedigree` (closer to
  nprcgenekeepr; edit its header).

### What You Must Do (6b)
1. Orient. Pick the source commit: nprcgenekeepr moved to `0a567d619` during S3 (S1153, new test files only) and is at
   `3d262d628` now. Run `git -C ../nprcgenekeepr log --oneline baef1e12c..HEAD -- R tests data DESCRIPTION` and check the
   6b files are unchanged.
2. Pre-RED picker: the 10 nprcgenekeepr-only tests (above). Then the `TDD: PRE-RED→RED` gate (`CLAUDE.md:88`).
3. RED: fixtures, then the 8 test files with the copy script pattern (S3's was in its scratchpad; the edits are listed in
   each 6a test header, e.g. `tests/testthat/test_walkPedigree.R:1-6`). Every edit matched an exact line, counted.
4. GREEN: the 11 R files (code unchanged; header and help text only); `Imports: data.table` in `DESCRIPTION`; install it
   with the dated repository set **and** `rebuild = TRUE` (Learning 3, `CLAUDE.md:157`), `renv::snapshot(dev = TRUE)`, gate.
   Add the 11 functions to `runCases()` (`tools/compareResultsWithNprcgenekeepr.R:44`, the `cases` list). The drift tool
   needs no change: it finds copied files by their headers.
5. DONE: as 6a, then push once and read each CI job's `Status:` line.

### Gotchas (6b)
- **Lint** only works with the package loaded (Learning 4, `CLAUDE.md:158`): the command in `CLAUDE.md:120` does that,
  and so does the gate `lint-package-zero`. A bare `lintr::lint_package()` gives false "no visible global function" lints.
- **renv cache trap** (Learning 3): `mockery` came back with Posit "latest" as its source although the dated repository was
  set; the gate failed it, and `renv::install("mockery", rebuild = TRUE)` fixed it. Expect the same for `data.table`.
- **Running R in nprcgenekeepr's folder from here** loads pedkindraw's library unless renv's variables are undone
  (Learning 5; `renvFreeEnv()` at `tools/compareResultsWithNprcgenekeepr.R:137`). nprcgenekeepr is installed in its own
  renv library, not in pedkindraw's.
- **The results tool refuses** if the clone's file for any copied function changed since that file's header commit. If
  nprcgenekeepr changes one of them, either copy the change (a new commit in the header) or check out the old commit.
- **`$?` after a pipe** is the last command's status, not the tool's. Capture the tool's exit code without a pipe.
- **A finding for nprcgenekeepr, not fixed here:** `test_findPedigreeNumber.R`'s first expectation checks ids containing
  "1", and the Lacy pedigree's ids are letters, so it passes without checking anything (0 ids match; S3). H2 puts it in
  `methodology/BACKLOG.md`. pedkindraw copied it unchanged.
- **CI notices** (not failures): Node 20 is deprecated under `actions/checkout@v4`; `ubuntu-latest` moves to Ubuntu 26
  (from 2026-10-19). `.github/workflows/R-CMD-check.yaml` may need `actions/checkout@v5` some day.
- **nprcgenekeepr's plan is frozen** (S4, `3d262d628`): update this repository's copy, `methodology/ROADMAP.md` and
  `methodology/BACKLOG.md` at close-out (`CLAUDE.md:138`), never nprcgenekeepr's.

### How You Will Be Evaluated
The user rates every session's handoff. Your handoff will be scored on:
1. Was the ACTIVE TASK block sufficient to orient the next session?
2. Were key files listed with line numbers?
3. Were gotchas and traps flagged?
4. Was the "what's next" actionable and specific?

---

## Session History

*Session history accumulates below this line. Newest session at the top.*
*S1-S4's entries were removed in S3-S5 (FM #28): their durable records are the receipts in `HANDOFFS.md` and the
entries in `CHANGELOG.md`.*

### Session 4 Handoff Evaluation (by Session 5)
**Score: 9/10.**
- **What helped:** H1's commands with the source commit filled in and S4's dry-run results (all five `cmp` silent,
  2,228 lines), so the copy needed no discovery; commit 4's lines were exact (`CLAUDE.md:22-23` and `:136`,
  `DIVERGENCE.md:4`, the two tool headers); the gotchas on paths and the line shift shaped the provenance note (it
  names the five files and states its own length); the zsh glob gotcha (I built the tarball in the scratchpad).
- **What was missing:** `CLAUDE.md:21` ("they live in nprcgenekeepr, not here") also became false, and section 3.3
  did not list it; the copied plan's own status block says "This copy is not updated here again", which reads wrong in
  pedkindraw (the note now explains it); nothing on the 120-column width these documents use.
- **What was wrong:** the H2 step's "the plan says so at `:88`" was measured before S4's own H0b edit added 4 lines
  (C2 is `:92` at `3d262d628`, `:108` here); S5 corrected it. It did not touch H1.
- **ROI:** high. H1's steps ran as written; the only discovery was the three gaps above.

### What Session 5 Did
**Deliverable:** step H1 of `docs/planning/planning-handover-plan.md`: the five planning documents copied from
nprcgenekeepr `3d262d628`, and `CLAUDE.md`, `DIVERGENCE.md` and the two tools pointed at the copies (DONE)
**Started:** 2026-11-11 00:22 CST · **Model:** Claude Opus 5.5 · **Mark's pick (orient picker):** "H1 only".
**Commits:** `b8b72f7` claim; `f2249d0` plan and contract; `ec910a6` three studies; `38633f1` provenance notes
(16, 14, 13, 13, 13 lines); `3e192e9` re-pointing (`CLAUDE.md` governing documents plus an evidence line and the path
rule, the plan-constraints line; `DIVERGENCE.md:4`; tool header comments only); close-out (hand-over plan status, H1
heading and three H2 citations corrected; `CLAUDE.md` Learning 7; notes, receipt, ledger). Nothing pushed.
**Verified:** five `cmp` silent before commit 3; after it, `diff` against the source: 0 removed lines, one hunk each,
added count equal to the count each note states; `git grep "nprcgenekeepr/docs" -- CLAUDE.md DIVERGENCE.md tools`
empty; drift tool exit 0 (10 same, 0 differ); results tool exit 0 (120 of 120 identical); `testthat::test_local()`
FAIL 0, PASS 122; `R CMD check --as-cran` Status 1 NOTE, the allowed one (Maintainer, New submission); tarball has 0
`/docs/` entries; `quality_ratchet: 2/2 pass · 0 fail · 0 unmeasured · results 28dd5b310acd · manifest 114e971f4452`.
**Self-assessment: 9/10.**
+ Every H1 DONE criterion checked with its output; the note insert was byte-level, so the copies differ from their
  sources by added lines only.
+ Found a stale citation in H2's text and the two my own edit moved, fixed them before H2 relies on them, and wrote
  the pattern down (Learning 7).
+ One picker, answered first try; no corrections from Mark.
- The note script checked line width file by file, so four files were written before the fifth failed the check. I
  restored the four from their commits (my own uncommitted changes) and reran. Check every file before writing any.
- `echo =====` failed in zsh (cosmetic; now a gotcha).
- I changed three things beyond section 3.3's list (`CLAUDE.md:21`, two added lines there, the note's sentence on the
  plan's status block); each keeps a file true, and the commit messages say so.
**Ledger:** `CHANGELOG.md` S5 entry (DONE).
