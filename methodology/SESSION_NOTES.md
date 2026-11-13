# Session Notes

**Purpose:** Continuity between sessions. Each session reads this first and writes to it before closing out.

**This file is transient — it is overwritten every session** (*"what's next, what traps?"*).
The cumulative, append-only record of *what was done, ever* lives in `CHANGELOG.md`; the commit SHA is the shared key.
At close-out, distill the durable outcome into a `CHANGELOG.md` entry — do not copy this handoff into it.

---

## ACTIVE TASK
**Task:** **Plan Phase 12, `familyCheck()` and `ibdMatrix()`** (`methodology/BACKLOG.md:11`; plan row
`docs/planning/standalone-pedigree-package-plan.md:494`; contract `docs/planning/pedkindraw-api-contract.md:158-159`).
New code written from kinship2's documentation, never its source (R11, R14); the plan estimates 2 sessions. The orient
picker asks Mark: Phase 12 (its first session), or the other READY item, **tests for full coverage**
(`methodology/BACKLOG.md:25`: 44 of 1,872 statements the tests miss, re-measured S14, by file and line), or hold.
**Status:** READY. Phase 11 DONE (S14): `bitSize()`, `findUnavailable()`, `findAvailNonInform()`,
`findAvailAffected()`; suite 537 tests, 0 failed, WARN 0; `R CMD check --as-cran` R16's NOTE only; drift tool 90
functions, 0 differ; pushed through `dff6509` (CI runs `43350752421` and `43352801040`, each 5/5 `Status: OK` at the first attempt); S14's
close-out commit is not pushed.
**Plan:** `docs/planning/standalone-pedigree-package-plan.md:36` (Next), `:494` (row 12), `:115` (R14: "Phase 12
writes `familyCheck()` and `ibdMatrix()` from kinship2's documentation, never its source"), `:141-143` (R40-R42, the
pattern S14 set for new code); contract `:158-159`, `:161-164` (shapes and errors are proposals until ruled).
**Session boundary:** the plan says 2 sessions for Phase 12; the pre-RED picker settles the split.
**Priority:** HIGH.

### What You Must Do
1. Orient, and run the drift tool (`Rscript tools/compareWithNprcgenekeepr.R ../nprcgenekeepr`); nprcgenekeepr's
   S1162 (vignettes) was active during S14.
2. Read kinship2's help, not its source (R14): `?kinship2::familycheck`, `?kinship2::ibdMatrix` (both present in
   1.9.6.2, measured S14), and the gap analysis rows 7 and 12 (`docs/research/kinship2-feature-gap-analysis-2026-09-20.md:94`,
   `:99`, and `:129-132`). Running kinship2's functions to compare results is allowed (S14 did; R42); reading their
   code is not.
3. A pre-RED picker, measured first (Learnings 17, 18): which of the two (or both) this session; the return shapes and
   errors (contract `:158-159` are proposals); the DONE criteria and what checks them (kinship2's results in tests
   that skip without it, as R42). Record the picks as rulings R43 on, in their own commit before RED.
4. RED: compute every expected value with kinship2 or by a scratch run before writing it (Learning 18). GREEN: new
   files. Checks: suite WARN 0, lint, roxygen, drift 0, `R CMD check --as-cran`, coverage of the new files; push; CI.

### Gotchas
- **Nothing to copy or call for Phase 12.** Neither function exists in pedkindraw or nprcgenekeepr (gap analysis rows
  7 and 12: ABSENT). `ibdMatrix()` returns a `Matrix` sparse matrix: `Matrix` is already imported (R27).
- **Phase 11's two loops are re-expressed from `shrinkPedigree()`**, not shared: `R/findAvailNonInform.R:73` is its
  second trim (`R/shrinkPedigree.R:251`), `R/findAvailAffected.R:109` one round of its third (`:282`). A port of an
  nprcgenekeepr change to `shrinkPedigree()` must change them too; the Phase 11 tests (each `identical()` to
  `shrinkPedigree()` on 7 fixtures) catch a mismatch the fixtures reach.
- **`shrinkPedigree()`'s couple step depends on row order** (S14): with a couple's child above the founder it makes,
  the first trim removes a second couple in the same pass; reorder the rows and the second trim does
  (`tests/testthat/test_findUnavailable.R:99`, `twoCouplesPed()`). That is the one-trim difference from kinship2 (R42).
- **kinship2's quirks met in S14:** `pedigree.shrink()` returns each `idList` element as one space-joined string
  (`splitKinship2Ids()`, `tests/testthat/helper-shrinkSteps.R:88`); `findUnavailable()` stops with an error when no
  animal is genotyped; `pedigree()` refuses an animal with one known parent and warns when over 25% of sexes are
  unknown (`asKinship2Pedigree()` at `:75` gives sex from each animal's role, so it never warns).
- **Times on this Mac:** full suite ~90 s; `covr::package_coverage(type = "tests")` ~115 s; `R CMD check --as-cran`
  ~5 min. Run `R CMD check` from a scratch folder with `R_LIBS` and `R_LIBS_USER` set to the renv library (worked
  first time again).
- **A one-line `Rscript -e` with a regex escape** (`"\\s+"`) failed to parse inside a zsh `for` loop in S14 (cause not
  found); put such code in a scratch script file.
- **zsh:** `echo ======` fails (`=` expansion); `$?` after a pipe is its last stage's.

### Key files
- `methodology/BACKLOG.md:11` (the Phase 12 item), `:25` (coverage); `docs/planning/pedkindraw-api-contract.md:158-159`.
- `R/bitSize.R:47` (`bitSize()`), `:61` (`.parentPositions()`, used by all four); `R/findUnavailable.R:60`;
  `R/findAvailNonInform.R:65`; `R/findAvailAffected.R:80` (`:83` the `affstatus` error).
- `tests/testthat/helper-shrinkSteps.R:11` (`shrinkStepPedigrees()`), `:45` (`walkThirdTrim()`), `:75`
  (`asKinship2Pedigree()`): a pattern for Phase 12's kinship2 comparisons.
- `CLAUDE.md:173` (Learning 18).

### How You Will Be Evaluated
The user rates every session's handoff. Your handoff will be scored on:
1. Was the ACTIVE TASK block sufficient to orient the next session?
2. Were key files listed with line numbers?
3. Were gotchas and traps flagged?
4. Was the "what's next" actionable and specific?

---

## Session History

*Session history accumulates below this line. Newest session at the top.*
*S1-S13's entries were removed in S3-S14 (FM #28): their durable records are the receipts in `HANDOFFS.md` and the
entries in `CHANGELOG.md`.*

### What Session 15 Did
**Deliverable:** plan Phase 12, first session: `familyCheck()` and `ibdMatrix()` from kinship2's documentation (R14);
kinship2's help read and its results measured, then a pre-RED picker (which function this session, shapes, errors,
checks), rulings, RED, GREEN, REFACTOR, checks, push, CI (IN PROGRESS)
**Started:** 2026-11-12 20:47 CST · **Model:** Claude Opus 5.5 · Mark picked "Phase 12, first session" at the orient
picker.
**Status:** Session claimed. Work beginning.
**Ledger:** `CHANGELOG: pending` — the claim commit's `CHANGELOG.md` entry says (in progress); Phase 3F records the rest.

### Session 13 Handoff Evaluation (by Session 14)
**Score: 9/10.**
- **What helped:** the gotcha that the four exports did not exist and the copy's internals take row positions, which
  framed the first picker question; the internals' line numbers (`R/shrinkPedigree.R:16`, `:22`, `:33`, `:79`,
  `:240-241`), all right; "put the exports in a file of their own"; "no DONE criteria for Phases 11-15", which became
  R42; "kinship2 forbids one known parent" (smallPed left out of the kinship2 comparisons); the drift-tool step and
  the out-of-folder `R CMD check` recipe (both worked first time); kinship2 installed and exporting all four.
- **What was missing:** that kinship2's `pedigree.shrink()` returns `idList` as joined strings (cost one false
  mismatch table); that kinship2's single-step functions differ from its `pedigree.shrink()` steps (only measurable).
- **What was wrong:** nothing found; every cited line checked.
- **ROI:** high.

### What Session 14 Did
**Deliverable:** plan Phase 11, the shrink steps as exports: `bitSize()`, `findUnavailable()`,
`findAvailNonInform()`, `findAvailAffected()`, new code test-first; push, CI (DONE).
**Started:** 2026-11-12 18:11 CST · **Model:** Claude Opus 5.5 · **Mark's picks:** "Phase 11: four new functions" and
"Leave it untracked" (orient); "Same as shrinkPedigree()", "kinship2's shapes", "shrinkPedigree + kinship2" (pre-RED,
R40-R42); the PRE-RED, RED, GREEN and REFACTOR gates "Yes".
**Commits:** claim `a49f91d`; rulings `f14fde6`; R42 corrected `702d3b5`; RED `e854169`; GREEN `0bc4b7e`, help fix
`3ef609d`, GREEN `9b6eed1`; REFACTOR `dff6509`; pushed twice (`d437228..9b6eed1`, 10 commits; `..dff6509`);
close-out (this commit), not pushed.
**Verified:** before the picker, kinship2 against `shrinkPedigree()`'s steps on 6 fixtures (bit sizes 30 of 30; first
two steps together 24 of 24; kinship2's one-pass `findAvailNonInform()` differs in 19 of 24) and a scratch prototype of
the third-trim walk (24 of 24 identical); every RED value computed by `shrinkPedigree()` or kinship2 first; RED 537
tests, 32 errors, each first on the missing function, WARN 0, SKIP 0; GREEN and REFACTOR: suite 537, 0 failed,
WARN 0, 2453 expectations; lint 0; roxygen idempotent; drift 90, 0 differ; `R CMD check --as-cran` 1 NOTE (R16's),
PASS 2446 SKIP 3, twice; coverage 97.32%, the new files 61 of 61 statements; CI `43350752421` 5/5 `Status: OK`
(macOS PASS 2453; Windows 2452, SKIP 1; Ubuntu 2442, SKIP 2), first attempt; CI `43352801040` (REFACTOR) the same, 5/5, first attempt;
`quality_ratchet` 4/4.
**Self-assessment: 8/10.**
+ Every picker option stated a measured count (Learning 17); every expected value machine-checked before RED; RED
  clean (32 of 32 on the missing function); the new files fully covered; CI green at the first attempt.
- Slips, each caught before it shipped wrong but costing commits: R42 recorded a kinship2 difference I had described
  from reading ids, disproved by a 7-animal reproduction (`702d3b5`); one hand-derived test value wrong (caught by the
  scratch run); GREEN 1's help stated a measured agreement as a general fact (`3ef609d`); the REFACTOR option said it
  would save about 8 lines, and it added 8 (said so in the commit); the orient report said `pedkindraw.Rproj` was
  "created at 17:11 today", which was its modification time (the backlog had it untracked since S2); a first
  comparison table was wrong because kinship2 joins ids into one string.
**Ledger:** `CHANGELOG.md` S14 entries (the session, two pushes, the `pedkindraw.Rproj` decision).
