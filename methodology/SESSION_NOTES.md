# Session Notes

**Purpose:** Continuity between sessions. Each session reads this first and writes to it before closing out.

**This file is transient — it is overwritten every session** (*"what's next, what traps?"*).
The cumulative, append-only record of *what was done, ever* lives in `CHANGELOG.md`; the commit SHA is the shared key.
At close-out, distill the durable outcome into a `CHANGELOG.md` entry — do not copy this handoff into it.

---

## ACTIVE TASK
**Task:** **Plan Phase 14: `asPedFrame()`, the converters from kinship2 `pedigree` and Pedixplorer `Pedigree`
objects** (`methodology/BACKLOG.md:11`; plan row `docs/planning/standalone-pedigree-package-plan.md:510`, R7 at
`:109`; contract `docs/planning/pedkindraw-api-contract.md:196` (section 4.5), the row at `:200`). New code: an S3
generic with two methods returning a list `ped` and `twinRelations`; kinship2 and Pedixplorer stay in Suggests (R7).
The orient picker asks Mark: this, the other READY item, **tests for full coverage** (`methodology/BACKLOG.md:28`,
43 of 2,178 statements missed), or hold.
**Status:** READY. Phase 13 DONE (S17 `checkPedigree()`; S18 `findUnrelated()`, R52-R54, 19 tests); suite 614
tests, 0 failed, WARN 0, SKIP 0, 4332 expectations; `R CMD check --as-cran` R16's NOTE only; drift tool 90 functions,
0 differ; pushed through `4bcfe00` (CI run `43533292116`: 5/5 `Status: OK` at the first attempt); S18's close-out
commits are not pushed.
**Plan:** `docs/planning/standalone-pedigree-package-plan.md:38` (Next), `:510` (row 14), `:109` (R7), `:155-157`
(R52-R54, the latest rulings' pattern); the comparison `docs/research/pedigree-package-comparison-2026-11.md:797`
(section 11: the four input-style prototypes, written in a scratchpad and **not kept**), `:844` (11.2: what each
converter reads, and its two required test cases), `:861` (11.3: R7).
**Session boundary:** one session, one generic and its two methods (a scope picker may split them, as R49 did).
**Priority:** HIGH.

### What You Must Do
1. Orient, and run the drift tool (`Rscript tools/compareWithNprcgenekeepr.R ../nprcgenekeepr`).
2. Read contract 4.5 and the comparison's section 11.2 whole (Learning 8): the table gives each column's source in
   each object (kinship2's `findex`/`mindex` with index 0 unknown; `sex` levels; `affected` columns; `status`;
   `relation` codes 1-3, 4 left out; Pedixplorer's `ped(x)`, `fill(x)`, `rel(x)`), and the two defects the first
   prototypes had, each a required test case.
3. Decide Pedixplorer first, in a scope picker with measured facts: it is not installed here (kinship2 1.9.6.2 is);
   installing it is a renv change under Learning 3 (Bioconductor, not the dated CRAN repository: find how renv
   records it before the picker, and run the `renv-lock-no-latest-repository` gate after the snapshot). Without it
   the Pedixplorer method's tests skip (Learning 14: read RED's SKIP count).
4. Read kinship2's help pages (`pedigree`, `pedigreeList`) and, if installed, Pedixplorer's (`Pedigree`, `ped`,
   `rel`, `fill`), help and measured results only (R14); build objects from `sample.ped` and the fixtures, print
   their slots, and measure what each holds before a picker states it (Learnings 17-19).
5. A measured pre-RED picker (return shape for each column, `pedigreeList`, ids never renamed, errors); rulings R55
   on, in their own commit; drafts run against a prototype in a scratch tree (Gotchas); RED, GREEN, REFACTOR;
   checks; push; CI; "Done 14" in the plan, contract 4.5, ROADMAP, BACKLOG.

### Gotchas
- **A heuristic or a converter is judged against an independent answer** (Learnings 20-21): for converters, the
  round trip data frame -> object -> `asPedFrame()` on every fixture, compared column by column, is the slow
  check; build it before the picker.
- **Hand-derived expected values were wrong again** (S18: number ids 10, 2 and 3 tie and "10" wins, since "10"
  comes before "2" in byte order). Run the drafts against the prototype before RED (Learning 18).
- **kinship2's `sample.ped`** codes unknown parents as `0` (numbers); `kinship2SampleFamily(f)` in
  `tests/testthat/helper-findUnrelated.R:68` turns a family into the package's data frame. Its `pedigree()` refuses
  one known parent (`smallPed` has one), parents with no row, wrong-sex parents and duplicate ids (R49).
- **The scratch-tree recipe** worked first time again: `git archive HEAD | tar -x -C <tree>`, the prototype as
  `<tree>/R/<name>.R`, the drafts in `<tree>/tests/testthat/`, then from `<tree>`: `R_LIBS=<lib> R_LIBS_USER=<lib>
  NOT_CRAN=true Rscript --no-init-file -e 'pkgload::load_all("."); testthat::test_file(...)'`. `<lib>` from
  `Rscript -e 'cat(renv::paths$library())'` in the project (S18 kept it in a file in the scratchpad). Run a helper
  that calls `test_path()` from the tree root, not from `tests/testthat`.
- **Claude Code refuses `rm` on a path built from a shell variable** (its own safety check, not Mark): use a fresh
  output folder instead of clearing one, and leave deletions to Mark.
- **`example(f)` finds no help under `pkgload::load_all()`**: run the example's code directly; `R CMD check` runs
  the examples. **`covr::zero_coverage()` needs `rstudioapi`** (not installed): use `as.data.frame(cv)` and keep
  the rows with `value == 0`.
- **`CLAUDE.md` is over its 28,000 B context budget** (30,063 B after S18's Learning 21; `context_budget.py --check`
  exits 2). Any new Learning grows it; the reduction is the context-budget item's own session
  (`methodology/BACKLOG.md:76`, R18).
- **Times on this Mac (S18):** suite ~100 s; coverage ~2.2 min; `R CMD check --as-cran` ~2.2 min, run from a scratch
  folder with `R_LIBS` and `R_LIBS_USER` set to the renv library; CI ~7 min. One `git push` timed out on the network
  and the retry went through.
- **nprcgenekeepr's S1165 was mid-session during S18** (tutorial tests and `vignettes/a2interactive.Rmd`, nothing
  copied here).

### Key files
- `methodology/BACKLOG.md:11` (the Phase 14 item), `:28` (coverage), `:76` (context budget).
- `docs/planning/pedkindraw-api-contract.md:196` (section 4.5), `:200` (`asPedFrame()`'s row).
- `R/findUnrelated.R:70` (`findUnrelated()`), `:114` (`.unrelatedStopMessage()`), `:142` (`.founderAncestors()`),
  `:178` (`.unrelatedPick()`), `:198` (`.unrelatedSwap()`); `R/checkPedigree.R:80` (`.checkPedFrame()`'s call in
  `checkPedigree()`), `:134` (`.checkPedFrame()`, the shared data-frame check a converter's output could reuse).
- `tests/testthat/helper-findUnrelated.R:12` (`findUnrelatedRandomCase()`), `:25` (`findUnrelatedSlow()`), `:55`
  (`kinship2Unrelated()`), `:68` (`kinship2SampleFamily()`); `tests/testthat/test_findUnrelated.R:241` (the kinship2
  comparison with its floor).
- `CLAUDE.md:176` (Learning 21).

### How You Will Be Evaluated
The user rates every session's handoff. Your handoff will be scored on:
1. Was the ACTIVE TASK block sufficient to orient the next session?
2. Were key files listed with line numbers?
3. Were gotchas and traps flagged?
4. Was the "what's next" actionable and specific?

---

## Session History

*Session history accumulates below this line. Newest session at the top.*
*S1-S17's entries were removed in S3-S18 (FM #28): their durable records are the receipts in `HANDOFFS.md` and the
entries in `CHANGELOG.md`.*

### What Session 19 Did
**Deliverable:** plan Phase 14, `asPedFrame()`, new code test-first (R9): an S3 generic with methods for kinship2's
`pedigree` and Pedixplorer's `Pedigree` (contract 4.5); kinship2's and Pedixplorer's help read and their objects
measured (R14, Learnings 17-19), Pedixplorer decided in a scope picker, a scratch prototype with the round trip on
every fixture as the slow check, a measured pre-RED picker, rulings R55 on, RED, GREEN, REFACTOR, checks, push, CI;
Phase 14 DONE (IN PROGRESS)
**Started:** 2026-11-14 10:42 CST · **Model:** Claude Opus 5.5 · Mark picked "Phase 14: asPedFrame() (Recommended)"
at the orient picker.
**Status:** Session claimed. Work beginning.
**Ledger:** `CHANGELOG: pending` — the claim commit's `CHANGELOG.md` entry says (in progress); Phase 3F records the rest.

### Session 17 Handoff Evaluation (by Session 18)
**Score: 9/10.**
- **What helped:** the ordered steps, which became this session's sequence (drift tool; the three comparison cases
  reproduced with kinship2 first; `rhesus375`'s row order checked before reusing its seed, and the fixture's rows
  were identical; kinship2's help read and run under a time limit; a measured pre-RED picker; rulings from R52;
  drafts against a prototype in a scratch tree); nprcgenekeepr's `runAgreement.R:316` and `:468`, which gave the
  exact draws; the shared-ancestor equivalence marked as a prediction to check (it held, 0 pairs differing in 350
  cases); the scratch-tree recipe, the rds results and the `setTimeLimit()` guard, all reused; every one of its 19
  cited line numbers right at Orient.
- **What was missing:** that the copied `kinship()` stops on a parent with no row, a cycle or an own parent
  (`findGeneration()` leaves them without a generation), which shaped the faulty-pedigree picker and had to be
  measured; that an exact search for the largest set is fast enough on these sizes to judge the rule by.
- **What was wrong:** nothing found wrong. ("CI ~8 min" was 7 min.)
- **ROI:** high; no rediscovery of any recipe it gave.

### What Session 18 Did
**Deliverable:** plan Phase 13's second session, `findUnrelated()`, new code test-first; push, CI; Phase 13 DONE.
**Started:** 2026-11-13 17:03 CST · **Model:** Claude Opus 5.5 · **Mark's picks:** "findUnrelated() (Recommended)"
(orient); "Stop, name the problems", "Shared ancestors", "Fewest relatives, then swaps", "Tests, slow check,
kinship2" (pre-RED, R52-R54); the PRE-RED, RED and GREEN gates "Yes"; REFACTOR "Yes, both changes".
**Commits:** claim `b77645c`; rulings `5377808`; RED `d97079e`; GREEN `d860336`; REFACTOR `4bcfe00`; pushed
(`60a87a7..4bcfe00`, 8 commits with S17's two close-out commits and `5631f2e`); close-out `7af4153` and the next,
not pushed.
**Verified:** before the picker: kinship2 1.9.6.2 on the comparison's three cases, seeds 1-100 under a time limit,
4, 2 and 44 every time, all valid, 18, 6 and 91 different sets; a prototype's related pairs equal to `kinship()`
above 0 in every pair of 350 cases (one process per case, six at a time) and on `synthetic_1000`/`_10000`; the rule
against an exact search on 1,292 random pedigrees (2 short with the swap pass, 6 without it, 12 counting once);
0.5 s at 10,000 animals, 10.7 s at 100,000 (kinship2 6.7-7.0 s at 10,000). The 19-test draft run against the
prototype (650 expectations, 0 failed); RED 614 tests, 19 failing, each first on the missing function, WARN 0, SKIP
0; GREEN and REFACTOR: suite 614, 0 failed, WARN 0, SKIP 0, 4332 expectations; `lint_package()` 0; roxygen
idempotent; drift 90, 0 differ; `R CMD check --as-cran` 1 NOTE (R16's), PASS 4325 SKIP 3, twice; coverage 97.69%,
`R/findUnrelated.R` 88 of 88, 43 of 2,178 missed in `R/`; 0.57 s on `synthetic_10000`; `quality_ratchet --run` 4/4;
CI `43533292116` 5/5 `Status: OK`, first attempt (macOS PASS 4332; Windows 4331, SKIP 1; Ubuntu 4321, SKIP 2).
**Self-assessment: 8/10.**
+ Every picker number was measured (kinship2 on 100 seeds, 350 equivalence cases, 1,292 exact comparisons, three
  pedigree sizes timed); the faulty-pedigree option was grounded in measured facts (`kinship()` stops; a cycle breaks
  the founder rule; `addParents()` gives the same pairs on pedSix); the typed swap case was found by shrinking a
  random case and rebuilt by hand (Learning 21); RED clean; the new file fully covered; CI green first time.
- Slips: a hand-derived value wrong again (number ids, caught while reviewing the drafts, before their run);
  `lacy1989Ped` has no sex column (one rerun); a one-animal case dropped a matrix dimension in a scratch script; the
  prototype's swap pass crashed when no animal was left free (found by the 10,000-animal timing, fixed before the
  drafts; the swap test now reaches that path); GREEN's first draft had 4 lints and then 1; an `rm` on a shell
  variable path was refused by the safety check (a fresh folder used instead); the first push timed out.
**Ledger:** `CHANGELOG.md` S18 entries (the session and the push).
