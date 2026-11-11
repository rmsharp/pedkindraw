# Session Notes

**Purpose:** Continuity between sessions. Each session reads this first and writes to it before closing out.

**This file is transient — it is overwritten every session** (*"what's next, what traps?"*).
The cumulative, append-only record of *what was done, ever* lives in `CHANGELOG.md`; the commit SHA is the shared key.
At close-out, distill the durable outcome into a `CHANGELOG.md` entry — do not copy this handoff into it.

---

## ACTIVE TASK
**Task (Mark's direction after S3's close-out, his words):** "next session make a plan to copy information held within
nprcgenekeepr into this repository into standard methodology ledgers and other files. Update nprcgenekeepr that this
repository will work going forward following the original plan but updating it if needed."
**Status:** READY. A planning session: the plan is the deliverable (`methodology/SESSION_RUNNER.md:110-155`, Planning
Sessions: deepest reasoning mode, plan in `docs/planning/`, a grep-based inventory, each phase with DONE, verification,
surface and session boundary). Phase 6b (below) waits until after it. In Phase 1, state back how you read Mark's second
sentence (the nprcgenekeepr note written this session, or as the plan's first step) and let him confirm by picker.
**Why:** the plan, rulings, status line and backlog item for pedkindraw live only in nprcgenekeepr, and no phase there
ever hands them over (S3 read the whole plan: §1.3 `:42-44` moves sessions here, nothing moves planning; Phase 17 `:342`
says "its own plan first" without saying where; the drift rule §5 `:353-359` has no end date).
**Starting points for the inventory (S3's reading, not yet a grep inventory):** in nprcgenekeepr,
`docs/planning/standalone-pedigree-package-plan.md` (424 lines), `docs/planning/pedkindraw-api-contract.md` (254),
the item at `BACKLOG.md:40`, `docs/research/pedigree-package-comparison-2026-11.md` (Phases 1-3 evidence),
`docs/planning/cleanroom-rewrite-plan.md` (C2: Phases 7, 8, 10 copy its results), `tools/pedigreeComparison/` (the
Phase 1 pedigrees `tools/compareResultsWithNprcgenekeepr.R` reads from the clone), and its `CHANGELOG.md` entries for
S1121-S1150. Search it all: `git -C ../nprcgenekeepr grep -il -e pedkindraw -e "standalone pedigree"`. In pedkindraw:
no `BACKLOG.md` and no `docs/` yet; `methodology/ROADMAP.md` is the unfilled seed; `CLAUDE.md:133-138` (plan
constraints; `:136` says nprcgenekeepr sessions update its plan, which Mark's direction changes).
**Gotcha:** an nprcgenekeepr session (S1153) was IN PROGRESS when S3 ended (its `methodology/SESSION_NOTES.md:99-103`;
commits `0a567d619`, `40e9b52ed`, `23c82bb27` landed during S3). Before writing in nprcgenekeepr, check its ACTIVE TASK
is not IN PROGRESS and its `git status` is clean (one writer per working tree, failure mode #29), and follow its own
ledger rules for that commit (a `CHANGELOG.md` entry there).

## THEN: Phase 6b (after the plan above)
**Task:** Phase 6b, the second half of the pedigree-basics copy slice: the 11 functions that repair and trim pedigrees
**Status:** READY. Phase 6a DONE in S3 (10 relationship functions; CI run `42960032938` 5/5 `Status: OK`, PASS 122 each).
Mark split Phase 6 in S3 (picker): 6a = 10 functions now, 6b = 11 next. `toCharacter()` stays out (Mark, S3; R13).
**Plan:** `/Users/rmsharp/Development/nprcgenekeepr/docs/planning/standalone-pedigree-package-plan.md:306-326` (slice rules
and DONE), `:318` (Phase 6 row). Contract `/Users/rmsharp/Development/nprcgenekeepr/docs/planning/pedkindraw-api-contract.md:88-116`
(§4.1 rows), `:113` (`addIdRecords()` is copied but **not exported**), `:182` (§5: `data.table` only for `addIdRecords()`).
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

### What You Must Do
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

### Gotchas
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
- **The S3 close-out commit is not pushed** (as in S2); 6b's push carries it.
- **Still waiting on Mark:** `pedkindraw.Rproj` (untracked, not made by a session: commit or ignore); the context-budget
  path fix (its own short session, Mark's S2 ruling).
- nprcgenekeepr was not touched. Its plan's status line (`plan:8-9`) still says Phase 5 is next; updating it is an
  nprcgenekeepr session's job (`CLAUDE.md:136`).

### How You Will Be Evaluated
The user rates every session's handoff. Your handoff will be scored on:
1. Was the ACTIVE TASK block sufficient to orient the next session?
2. Were key files listed with line numbers?
3. Were gotchas and traps flagged?
4. Was the "what's next" actionable and specific?

---

## Session History

*Session history accumulates below this line. Newest session at the top.*
*S1's and S2's entries were removed in S3 (FM #28): their durable records are the receipts in `HANDOFFS.md` and the
entries in `CHANGELOG.md`.*

### What Session 4 Did
**Deliverable:** the plan to move pedkindraw's planning from nprcgenekeepr into this repository (`docs/planning/`), then
the hand-over note in nprcgenekeepr (its plan status line and backlog item) (IN PROGRESS)
**Started:** 2026-11-10 23:59 CST · **Model:** Claude Opus 5.5
**Status:** Session claimed. Work beginning. Mark picked "Plan, then note" (picker) after saying nprcgenekeepr is idle
(S1153 closed at `71217b296`, clean tree).
**Ledger:** `CHANGELOG: pending` — the claim commit's `CHANGELOG.md` entry says (in progress); Phase 3F records the rest.

### Session 2 Handoff Evaluation (by Session 3)
**Score: 8/10.**
- **What helped:** the exact plan and contract line numbers; the `toCharacter` conflict, flagged as Mark's call (the
  closure confirmed nothing in Phase 6 calls it); `^tools$` and `^DIVERGENCE\.md$` for `.Rbuildignore` (both needed);
  covr working once `R/` exists (it did); the two unpushed commits; reading CI's `Status:` lines (done again).
- **What was wrong:** step 4's "`DESCRIPTION` gains `Imports: data.table, stats, utils`" came from contract §5 without a
  check. None of the 21 functions uses `stats` or `utils`, and `data.table` only in `addIdRecords()`; adding them unused
  would have caused a check NOTE.
- **What was missing:** that every copied example loads nprcgenekeepr or its datasets (all 8 in 6a needed rewriting);
  that the copied tests need `mockery` and one needs `stringi`; that Learning 3's fix also applies to a cached package.
  The lint trap could not have been seen with no R code.
- **ROI:** high. Orientation and the scope research went straight to measuring instead of searching.

### What Session 3 Did
**Deliverable:** Phase 6a, the first half of the pedigree-basics copy slice, test-first (DONE)
**Started:** 2026-11-10 19:15 CST · **Model:** Claude Opus 5.5
**Mark's picks (all by picker, each my recommendation, first try):** start Phase 6; split it 10 now / 11 next; leave
`toCharacter` out; test fixtures plus typed examples (no package datasets); RED with `stringi` replaced by base R; GREEN;
REFACTOR with no changes.
**Commits:** `1274024` claim · RED `1017c25` (fixtures, `tools/makeTestFixtures.R`, `^tools$`), `518cba5`, `7c22e4b`,
`430effe` (10 test files, 48 tests; `mockery` in Suggests) · GREEN `844542d`, `7357272` (10 R files), `8d76336`, `0565f7f`
(`NAMESPACE`, 8 help pages), `b332309` (drift tool, results tool, `DIVERGENCE.md`) · close-out (CLAUDE.md Learnings 3-5,
lint command and tool rows; gate `lint-package-zero`). Pushed `32d525c..b332309` once.
**Verified:** RED failed for the right reason (42 "could not find function", 1 knock-on, 1 namespace check). GREEN: 52
tests, 122 expectations, 0 skipped; the 9 copied test files give the same expectation counts as nprcgenekeepr's
(7, 3, 24, 6, 3, 4, 24, 8, 30). Fixtures `identical()` to nprcgenekeepr's datasets. Drift tool: 10 functions, 0 differ
(control: 2 planted changes caught, exit 1; comment-only change ignored). Results tool: 120 results on 12 Phase 1
pedigrees, 120 identical (control: altered `getParents` gave 22 differences, exit 1). roxygen2 changes nothing; 0 lints
(package loaded); coverage 100%; `R CMD check --as-cran` 0 errors, 0 warnings, 1 NOTE (Maintainer plus "New submission"
only); examples ran with the expected output. CI `42960032938`: 5/5 `Status: OK`, `[ FAIL 0 | WARN 0 | SKIP 0 | PASS 122 ]`.
`quality_ratchet: 2/2 pass · 0 fail · 0 unmeasured · results 28dd5b310acd · manifest 114e971f4452`.
**Self-assessment: 8/10.**
+ Measured before asking: the call graph, the closure, each test's needs; the split and the `stats`/`utils` correction came
  from evidence. Every picker answered first time in plain words.
+ Every claim of sameness has a check that was shown to fail: expectation counts, `identical()` fixtures, and negative
  controls for both tools.
− The renv cache trap recurred despite Learning 3 (the gate caught it, not the habit); Learning 3 now covers it.
− Twice printed a piped `$?` as a tool's exit code; both caught and re-run before relying on them.
− The results tool took three tries to start its child process (renv variables, `<NA>`, `env` option order), and its first
  header reader was fragile; all fixed before the commit.
**Ledger:** `CHANGELOG.md` S3 entries (DONE; push and CI).
