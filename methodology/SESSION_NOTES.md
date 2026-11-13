# Session Notes

**Purpose:** Continuity between sessions. Each session reads this first and writes to it before closing out.

**This file is transient — it is overwritten every session** (*"what's next, what traps?"*).
The cumulative, append-only record of *what was done, ever* lives in `CHANGELOG.md`; the commit SHA is the shared key.
At close-out, distill the durable outcome into a `CHANGELOG.md` entry — do not copy this handoff into it.

---

## ACTIVE TASK
**Task:** **Plan Phase 11, the shrink helpers and `bitSize()` as exports** (`methodology/BACKLOG.md:11`; plan row
`docs/planning/standalone-pedigree-package-plan.md:488`; contract section 4.3,
`docs/planning/pedkindraw-api-contract.md:150-163`). The first new-code phase (11-15): nothing to copy. The orient
picker asks Mark: Phase 11, or the other READY item, **tests for full coverage** (`methodology/BACKLOG.md:24`, added
at Mark's request after S13's close-out: 45 of 1,811 statements the tests miss, by file and line), or hold.
**Status:** READY. Phase 10 DONE (S13) and with it the copy slices, Phases 6-10: suite 505 tests, 0 failed, WARN 0;
`R CMD check --as-cran` R16's NOTE only; results tool 600 of 600 identical against nprcgenekeepr `ec56cb02e`; drift
tool 90 functions, 0 differ; **pushed through `d437228`** (CI run `43326408939` 5/5 `Status: OK`); S13's two
close-out commits are not pushed.
**Plan:** `docs/planning/standalone-pedigree-package-plan.md:34` (Next), `:484-488` (Phases 11-15, row 11), `:101`
(R3), `:109` (R11); contract `:154-157` (the four interfaces), `:161-163` (ids in a data frame; shapes and errors
settled in RED), section 3 from `:58` (what R11's rewrite means).
**Session boundary:** one session (the plan's "one session each", `:484`).
**Priority:** HIGH.

### What You Must Do
1. Orient, and run the drift tool (`Rscript tools/compareWithNprcgenekeepr.R ../nprcgenekeepr`): nprcgenekeepr's
   sessions keep running (its S1161 was active through S13), and a change there to a copied file needs a port or a
   `DIVERGENCE.md` row.
2. Read the contract's 4.3 rows and section 3, and kinship2's own help for the four (`?kinship2::bitSize`,
   `findUnavailable`, `findAvailNonInform`, `findAvailAffected`; kinship2 1.9.6.2 is installed here, Suggests, and
   exports all four, measured S13). R11: write from the published method, not kinship2's source.
3. A pre-RED picker, plain words and measured first (Learnings 1, 2, 17), on: (a) whether the four call the copied
   internals (`R/shrinkPedigree.R:16` `.bitSize()`, `:22` `.isParent()`, `:33` `.removalPass()`, `:79`
   `.checkShrinkInput()`, all on row positions; `shrinkPedigree()` makes the positions at `:240-241`) or are written
   apart; (b) their return shapes and errors; (c) **Phase 11's DONE criteria**, which the plan does not state
   (gotcha); (d) what checks them: each against `shrinkPedigree()`'s own tier (for example `findUnavailable()`
   against `$idList$unavail`), and/or against kinship2's function, skipped without kinship2 (R7). Record the picks as
   rulings R40 on (plan section 2), in their own commit before RED.
4. RED: the new tests. GREEN: a new file (not `R/shrinkPedigree.R`), roxygen exports. Checks: suite WARN 0, lint,
   roxygen, drift 0 differ, `R CMD check --as-cran`, coverage of the new file; push; CI; "Done 11" in the plan.

### Gotchas
- **The contract's four exports do not exist yet.** Plan row 11 says "Export the rewrite's shrink helpers", but
  nprcgenekeepr's clean-room rewrite (its S1139, `e2bba9fb2`) dropped the seven old helpers (`.bitSizeOf()` to
  `.findAvailAffected()`); the copy holds only the four internals above, on row positions, not ids.
- **`R/shrinkPedigree.R` is copied code.** Any edit to it shows in the drift tool and needs a `DIVERGENCE.md` row
  (plan section 5); put the exports in a file of their own.
- **No DONE criteria for Phases 11-15** in the plan (`:484-492`: the table and "strict TDD, one session each"). There is
  no nprcgenekeepr counterpart to compare results with, so the copy slices' DONE line does not carry over.
- **kinship2 forbids one known parent** ("Subjects must have both a father and mother, or have neither";
  `tests/testthat/test_shrinkPedigree.R:269`); pedkindraw allows it. A test against kinship2 needs pedigrees with
  both parents or neither.
- **zsh:** `echo ======` fails ("= not found": a word starting with `=` is a command-path lookup), stopping the
  chain; print a separator with `echo '-----'`. S12's: an empty glob stops an `&&` chain; `tail` can cut a summary
  line; `$?` after a pipe is the last stage's status (S13 re-ran the drift tool to read its own).
- **R CMD check outside the project folder** needs `R_LIBS` and `R_LIBS_USER` set to the renv library
  (`Rscript -e 'cat(.libPaths()[1])'` from the root); it worked first time in S13, in the background.
- **Coverage by the cases** (Learning 11): S13's script ran `covr::package_coverage()` with `type = "tests"` (113 s) and
  `type = "none"` with `code =` running `runCases()`, then merged per statement on filename, lines and bytes.

### Key files
- `methodology/BACKLOG.md:11` (the Phase 11 item); `docs/planning/pedkindraw-api-contract.md:70` (the old helpers'
  provenance row), `:154-157`, `:161-163`.
- `R/shrinkPedigree.R:16`, `:22`, `:33`, `:79` (the internals), `:230` (`shrinkPedigree()`), `:240-241` (ids to row
  positions).
- `tests/testthat/test_shrinkPedigree.R` (24 tests, copied; S13).
- `tools/compareResultsWithNprcgenekeepr.R:205` (the shrink cases' set-up), `:497` (`shrinkPedigree`), `:533`
  (`shrinkLoop`), `:544` (`shrinkErrors`).
- `CLAUDE.md:166` (Learning 11, with S13), `:172` (Learning 17).

### How You Will Be Evaluated
The user rates every session's handoff. Your handoff will be scored on:
1. Was the ACTIVE TASK block sufficient to orient the next session?
2. Were key files listed with line numbers?
3. Were gotchas and traps flagged?
4. Was the "what's next" actionable and specific?

---

## Session History

*Session history accumulates below this line. Newest session at the top.*
*S1-S12's entries were removed in S3-S13 (FM #28): their durable records are the receipts in `HANDOFFS.md` and the
entries in `CHANGELOG.md`.*

### What Session 14 Did
**Deliverable:** plan Phase 11, the shrink helpers and `bitSize()` as exports: `bitSize()`, `findUnavailable()`,
`findAvailNonInform()`, `findAvailAffected()`, new code test-first (pre-RED picker, rulings, RED, GREEN, checks, push,
CI, "Done 11") (IN PROGRESS)
**Started:** 2026-11-12 18:11 CST · **Model:** Claude Opus 5.5 · Mark picked "Phase 11: four new functions" at the
orient picker, and "Leave it untracked" for `pedkindraw.Rproj`.
**Status:** Session claimed. Work beginning.
**Ledger:** `CHANGELOG: pending` — the claim commit's `CHANGELOG.md` entry says (in progress); Phase 3F records the rest.

### Session 12 Handoff Evaluation (by Session 13)
**Score: 9/10.**
- **What helped:** the stand-in gotcha, which shaped RED and two of the three picker questions; the nprcgenekeepr check
  commands (both shrink files unchanged, read in seconds); the stand-in's callers at `:182`, `:65`, `:2394`, all right;
  the survey steps and the `::` lines (`:121`, `:210`); the copy proofs (diff hunks, parse identical); the baseline-run
  recipe and the out-of-folder `R CMD check` (both worked first time); the results tool's commit argument (needed:
  nprcgenekeepr's S1161 was active); `runCases()` at `:41`, the cases at `:201`, `kinshipFounders` at `:302`.
- **What was missing:** that `shrinkPedigree()` takes 130 s on examplePedigree, so the cases cannot run on the whole
  pedigrees (found by timing); that the three Track B files' headers name the stand-in (found by grep).
- **What was wrong:** `test_inventoryTutorialSections.R:108`: the file names `shrinkPedigree()` at `:10` and `:137`, at
  `45e0d8bfe` and at HEAD.
- **ROI:** high.

### What Session 13 Did
**Deliverable:** plan Phase 10, shrink: nprcgenekeepr's `shrinkPedigree()` and its 24 tests copied test-first;
fidelity cases; push, CI; "Done 10" (DONE). The copy slices, Phases 6-10, are complete.
**Started:** 2026-11-12 15:23 CST · **Model:** Claude Opus 5.5 · **Mark's picks:** "Phase 10: copy shrinkPedigree()"
(orient); "Leave them out", "With the copied tests", "Delete both" (pre-RED, rulings R38-R39); the PRE-RED, RED and
GREEN gates "Yes"; REFACTOR "change nothing".
**Commits:** claim `da62dba`; rulings `c5197a3`; RED `82bc045`, `0653133`; GREEN `82f2ef3`, `d437228`; REFACTOR none;
pushed once (8 commits, `11b62cd..d437228`); close-out `f0ae6ed` and close-out 2 (these notes, the receipt, the
ledger, a backlog line number). Close-out commits not pushed.
**Verified:** the pre-RED picker's consequence measured in a scratch copy (3 Track B tests fail without the stand-in);
RED 505 tests, 27 failed, each first on the missing function (27 of 27), WARN 0; the fixture script rerun writes a
byte-identical `qcdRhesusPed.rds`; GREEN's code parses identical to nprcgenekeepr's, the diff header and example only;
the 24 tests with nprcgenekeepr's 79 expectations test for test; suite 505, 0 failed, WARN 0, SKIP 0, 2165
expectations; lint 0; roxygen idempotent; drift 90 functions, 0 differ; results tool 600 of 600 identical against
`ec56cb02e`; covr: the cases reach 127 of 127 statements of `R/shrinkPedigree.R`, the tests 125; package coverage
97.16%; `R CMD check --as-cran` 1 NOTE (the allowed one), PASS 2158 SKIP 3, the example printing 7 then 0; CI run
`43326408939` 5/5 `Status: OK`, first attempt; `quality_ratchet` 4/4.
**Self-assessment: 9/10.**
+ Every picker option stated a measured result (Learning 17); every phase proven by machine; Learning 11 pushed to
  127 of 127 by working out the input that reaches the "defensive" `break`, not by calling it unreachable; the Phase 11
  trap (the contract's four exports do not exist, no DONE criteria) found and written down for the next session.
- Slips, each caught: `echo ======` stopped two early commands (zsh); a drift-tool exit read through a pipe (re-ran);
  the REFACTOR picker said "7 commits" (6 in the session, 8 pushed; said so); close-out 1 cited the contract's note at
  `:160-162`, really `:161-163` (fixed in close-out 2); a summary script printed a dead "stopped early" line
  (disclosed, not reported).
**Ledger:** `CHANGELOG.md` S13 entries (the session and the push).
**After close-out:** Mark asked for a backlog item to add tests for full coverage; added (`methodology/BACKLOG.md:24`),
measured from S13's coverage run, with its own ledger entry.
