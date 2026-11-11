# Session Notes

**Purpose:** Continuity between sessions. Each session reads this first and writes to it before closing out.

**This file is transient — it is overwritten every session** (*"what's next, what traps?"*).
The cumulative, append-only record of *what was done, ever* lives in `CHANGELOG.md`; the commit SHA is the shared key.
At close-out, distill the durable outcome into a `CHANGELOG.md` entry — do not copy this handoff into it.

---

## ACTIVE TASK
**Task:** step H1 of `docs/planning/planning-handover-plan.md`: copy the five planning documents from nprcgenekeepr
into this repository and point `CLAUDE.md`, `DIVERGENCE.md` and the two tools at the copies.
**Status:** IN PROGRESS (S5, claimed 2026-11-11 00:22 CST; Mark's orient pick "H1 only"). Plan written and H0 DONE in
S4 (plan `0283214`; the hand-over note in nprcgenekeepr `3d262d628`).
Mark's S4 picks (all by picker, first try after one clarification): "Plan, then note"; open work in a
`methodology/BACKLOG.md` file; five documents copied. Then H2 (bring the plan up to date; roadmap and backlog), then
Phase 6b. **Session boundary:** H1 is one session; Mark may fold H2 into it at the orient picker (plan section 4).
**Priority:** HIGH (Mark's direction; Phase 6b waits until H2 is DONE).

### What You Must Do (H1; plan section 4, "H1")
1. Orient. Source commit `C` = nprcgenekeepr `3d262d628`. Check nothing changed since:
   `git -C ../nprcgenekeepr log --oneline 3d262d628..HEAD -- docs/planning/standalone-pedigree-package-plan.md
   docs/planning/pedkindraw-api-contract.md docs/research/pedigree-package-comparison-2026-11.md
   docs/research/kinship2-feature-gap-analysis-2026-09-20.md docs/research/pedigree-diagram-package-split-scoping-2026-09-02.md`
   prints nothing (S4 dry-ran this: 0 commits).
2. Commit 1: plan and contract; commit 2: the three studies. Each with `git -C ../nprcgenekeepr show "3d262d628:$p" > "$p"`,
   then `git -C ../nprcgenekeepr show "3d262d628:$p" | cmp - "$p"` silent (S4 dry-ran all five in its scratchpad: silent;
   428 + 254 + 853 + 202 + 491 = 2,228 lines).
3. Commit 3: the provenance note under each title (wording: plan section 4, H1 step 4). Check
   `diff <(git -C ../nprcgenekeepr show "3d262d628:$p") "$p" | grep -c '^<'` prints 0 for each.
4. Commit 4: `CLAUDE.md:22-23` and `:136`, `DIVERGENCE.md:4`, `tools/compareWithNprcgenekeepr.R:1`,
   `tools/compareResultsWithNprcgenekeepr.R:2` (plan section 3.3 has the before and after).
5. DONE (plan section 4, H1): both tools exit 0 against `../nprcgenekeepr`; test suite; `R CMD check --as-cran`
   0/0/allowed NOTE; `tar tzf` shows no `docs/`. No push.

### Key files
- `docs/planning/planning-handover-plan.md`: section 2 (the decision table and the path rule), 3.1 (the five files),
  3.3 (every pedkindraw line to change), 4 (H1 and H2 steps with DONE), 6 (risks).
- `.Rbuildignore:23` (`^docs$`, S4). `CLAUDE.md:22-23` (governing documents, absolute paths), `CLAUDE.md:136` (now
  false: S4 updated nprcgenekeepr's status from here, and pedkindraw keeps its own from H1 on).
- nprcgenekeepr `3d262d628`: `docs/planning/standalone-pedigree-package-plan.md:5-13` (the freeze sentence),
  `BACKLOG.md:40-50` (the shrunk item), `methodology/CHANGELOG.md:37` (its ledger entry, 760 B).

### Gotchas (H1)
- **Paths inside the copies are nprcgenekeepr's** (`R/kinship.R:62`, `BACKLOG.md`, `tools/pedigreeComparison/`); only
  the five copied files resolve here. The provenance note must say so (plan section 2). Do not rewrite the paths.
- **Line numbers in the copies shift** by the provenance note's length. Citations made before H1 (S1-S4 notes and
  receipts) point at nprcgenekeepr's frozen files by absolute path and stay right.
- **zsh aborts a whole command on an unmatched glob** (`rm -f pedkindraw_*.tar.gz` with no tarball killed S4's first
  build command). Use `ls` or `setopt null_glob`, or run the build in the scratchpad.
- **The nprcgenekeepr commit is not pushed** (`3d262d628`); pushing nprcgenekeepr is Mark's. Its `BACKLOG.md` items
  after the shrunk one moved up 13 lines: #138's item is now at `:70`, while S1153's receipt cites `:83` (S4 said so
  in nprcgenekeepr's ledger entry).

## THEN: H2, then Phase 6b
**H2** (plan section 4, "H2"): one session. Mark confirms by picker the rulings to add as R16 on (listed there), then
the plan, the contract, `methodology/ROADMAP.md`, a new `methodology/BACKLOG.md` and a pre-history pointer entry in
`methodology/CHANGELOG.md`. Then Phase 6b, below.

### Phase 6b
**Task:** Phase 6b, the second half of the pedigree-basics copy slice: the 11 functions that repair and trim pedigrees
**Status:** READY. Phase 6a DONE in S3 (10 relationship functions; CI run `42960032938` 5/5 `Status: OK`, PASS 122 each).
Mark split Phase 6 in S3 (picker): 6a = 10 functions now, 6b = 11 next. `toCharacter()` stays out (Mark, S3; R13).
**Plan:** after H1, this repository's `docs/planning/standalone-pedigree-package-plan.md`, section "Phases 6-10 -- Copy
slices" (slice rules and DONE; the Phase 6 row) and, after H2, its Phase 6 split. Contract: this repository's
`docs/planning/pedkindraw-api-contract.md` §4.1 rows, the `addIdRecords()` paragraph under them (copied but **not
exported**), §5 (`data.table` only for `addIdRecords()`). The line numbers S3 cited (plan `:306-326`, `:318`; contract
`:88-116`, `:113`, `:182`) are nprcgenekeepr's at `baef1e12c`; the copies here shift by their provenance notes.
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
  becomes not exported (contract `:113`; keep its `@importFrom data.table rbindlist` at `:16`). Once `trimPedigree` exists,
  `R/getProbandPedigree.R:21-23` may go back to `@inheritParams trimPedigree` (closer to nprcgenekeepr; edit its header).

### What You Must Do (6b)
1. Orient. Pick the source commit: nprcgenekeepr moved to `0a567d619` during S3 (S1153, new test files only). Run
   `git -C ../nprcgenekeepr log --oneline baef1e12c..HEAD -- R tests data DESCRIPTION` and check the 6b files are unchanged.
2. Pre-RED picker: the 10 nprcgenekeepr-only tests (above). Then the `TDD: PRE-RED→RED` gate (`CLAUDE.md:86`).
3. RED: fixtures, then the 8 test files with the copy script pattern (S3's was in its scratchpad; the edits are listed in
   each 6a test header, e.g. `tests/testthat/test_walkPedigree.R:1-6`). Every edit matched an exact line, counted.
4. GREEN: the 11 R files (code unchanged; header and help text only); `Imports: data.table` in `DESCRIPTION`; install it
   with the dated repository set **and** `rebuild = TRUE` (Learning 3, `CLAUDE.md:155`), `renv::snapshot(dev = TRUE)`, gate.
   Add the 11 functions to `runCases()` (`tools/compareResultsWithNprcgenekeepr.R:44`, the `cases` list). The drift tool
   needs no change: it finds copied files by their headers.
5. DONE: as 6a (below), then push once and read each CI job's `Status:` line.

### Gotchas (6b)
- **Lint** only works with the package loaded (Learning 4, `CLAUDE.md:156`): the command in `CLAUDE.md:118` does that,
  and so does the new gate `lint-package-zero`. A bare `lintr::lint_package()` gives false "no visible global function" lints.
- **renv cache trap** (Learning 3): `mockery` came back with Posit "latest" as its source although the dated repository was
  set; the gate failed it, and `renv::install("mockery", rebuild = TRUE)` fixed it. Expect the same for `data.table`.
- **Running R in nprcgenekeepr's folder from here** loads pedkindraw's library unless renv's variables are undone
  (Learning 5; `renvFreeEnv()` at `tools/compareResultsWithNprcgenekeepr.R:137`). nprcgenekeepr is installed in its own
  renv library, not in pedkindraw's.
- **The results tool refuses** if the clone's file for any copied function changed since that file's header commit. If
  nprcgenekeepr changes one of them, either copy the change (a new commit in the header) or check out the old commit.
- **`$?` after a pipe** is the last command's status, not the tool's. S3 printed `tail`'s status twice by mistake; capture
  the tool's exit code without a pipe.
- **A finding for nprcgenekeepr, not fixed here:** `test_findPedigreeNumber.R`'s first expectation checks ids containing
  "1", and the Lacy pedigree's ids are letters, so it passes without checking anything (0 ids match; S3). An nprcgenekeepr
  session may want a `BACKLOG.md` line. pedkindraw copied it unchanged.
- **CI notices** (not failures): Node 20 is deprecated under `actions/checkout@v4`; `ubuntu-latest` moves to Ubuntu 26
  (from 2026-10-19). `.github/workflows/R-CMD-check.yaml` may need `actions/checkout@v5` some day.
- **Not pushed:** S3's close-out and every S4 commit (H1 and H2 do not push either); 6b's push carries them.
- **Still waiting on Mark:** `pedkindraw.Rproj` (untracked, not made by a session: commit or ignore); the context-budget
  path fix (its own short session, Mark's S2 ruling).
- **nprcgenekeepr's plan is frozen** (S4, `3d262d628`): from H1 on, update this repository's copy, `methodology/ROADMAP.md`
  and `methodology/BACKLOG.md` at close-out (plan section 5), never nprcgenekeepr's.

### How You Will Be Evaluated
The user rates every session's handoff. Your handoff will be scored on:
1. Was the ACTIVE TASK block sufficient to orient the next session?
2. Were key files listed with line numbers?
3. Were gotchas and traps flagged?
4. Was the "what's next" actionable and specific?

---

## Session History

*Session history accumulates below this line. Newest session at the top.*
*S1-S3's entries were removed in S3 and S4 (FM #28): their durable records are the receipts in `HANDOFFS.md` and the
entries in `CHANGELOG.md`.*

### What Session 5 Did
**Deliverable:** step H1 of `docs/planning/planning-handover-plan.md`: copy the five planning documents from
nprcgenekeepr `3d262d628` and point `CLAUDE.md`, `DIVERGENCE.md` and the two tools at the copies (IN PROGRESS)
**Started:** 2026-11-11 00:22 CST · **Model:** Claude Opus 5.5
**Status:** Session claimed. Work beginning. Mark's orient pick (picker): "H1 only".
**Ledger:** `CHANGELOG: pending` — the claim commit's `CHANGELOG.md` entry says (in progress); Phase 3F records the rest.

### Session 3 Handoff Evaluation (by Session 4)
**Score: 9/10.**
- **What helped:** Mark's direction quoted word for word; the pointer to the Planning Sessions rules; the starting
  points (plan, contract, backlog item, comparison study, clean-room plan, `tools/pedigreeComparison/`) and the search
  command; the S1153 gotcha (check nprcgenekeepr is idle and clean before writing there), which was exactly right;
  `CLAUDE.md:136` flagged as the line Mark's direction changes; asking me to state back the second sentence by picker.
- **What was missing:** the two older studies the plan cites (the gap analysis and the split scoping study) were not
  among the starting points, and the name search cannot find them (they predate the name); that `docs/` needs
  `^docs$` in `.Rbuildignore`; nprcgenekeepr's rules for a commit there (entry limit 1,000 B, its context-budget
  pre-commit hook, the tests that read `BACKLOG.md` and the ledgers).
- **What was wrong:** nothing material. "its `CHANGELOG.md`" is `methodology/CHANGELOG.md` there; the search string
  missed the hyphenated "standalone-pedigree" in the tool headers (S4 added it).
- **ROI:** high. The inventory started from the right files, and the one trap (two writers) was named in advance.

### What Session 4 Did
**Deliverable:** the plan to move pedkindraw's planning from nprcgenekeepr into this repository, and the hand-over
note in nprcgenekeepr (DONE)
**Started:** 2026-11-10 23:59 CST · **Model:** Claude Opus 5.5
**Mark's picks (all by picker):** after one clarification ("nprcgenekeepr is idle now"), "Plan, then note"; open work in
a `methodology/BACKLOG.md` file, not GitHub issues; five documents copied, not two. Each was my recommendation.
**Commits:** pedkindraw `a262439` claim, `0283214` H0a (`docs/planning/planning-handover-plan.md`, `^docs$` in
`.Rbuildignore`), close-out (plan hashes, notes, receipt, ledger, Learning 6). nprcgenekeepr `3d262d628` H0b (plan
status block frozen, `BACKLOG.md` item shrunk to the drift watch, its ledger entry). Nothing pushed.
**Verified:** inventory by search (33 nprcgenekeepr files) and by the governing documents' citations (Appendix A);
every line citation in the plan re-read before commit (2 corrected). `R CMD build`: `docs/` left out, file list identical
to S3's checked tarball. H1's copy commands dry-run in the scratchpad: all five byte-identical at `3d262d628`.
nprcgenekeepr: 5 reader test files, 37 blocks, 0 failed; entry 760 B, 0 over the limit; its context-budget hook passed.
`quality_ratchet: 2/2 pass · 0 fail · 0 unmeasured · results 28dd5b310acd · manifest 114e971f4452`.
**Self-assessment: 8/10.**
+ The inventory follows citations as well as the name, which found the two studies the search missed; every
  pedkindraw line to change is listed with its before and after; H1's verification commands were run once before
  being handed over.
+ The nprcgenekeepr commit followed that repository's rules (idle check, entry limit, readers, hook) and says in its
  ledger which of its line citations it moved.
- My first picker was rejected for clarification: it rested on a premise (S1153 unfinished) that Mark could settle
  in a word. Ask the premise first.
- Two line citations were wrong in the first draft, and two more would have gone stale with this close-out; all four
  were caught by re-reading before commit.
- One build command aborted on zsh's unmatched-glob error.
**Ledger:** `CHANGELOG.md` S4 entries (DONE; the nprcgenekeepr commit).
