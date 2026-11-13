# Session Notes

**Purpose:** Continuity between sessions. Each session reads this first and writes to it before closing out.

**This file is transient — it is overwritten every session** (*"what's next, what traps?"*).
The cumulative, append-only record of *what was done, ever* lives in `CHANGELOG.md`; the commit SHA is the shared key.
At close-out, distill the durable outcome into a `CHANGELOG.md` entry — do not copy this handoff into it.

---

## ACTIVE TASK
**Task:** **Plan Phase 13's second session: `findUnrelated()`** (`methodology/BACKLOG.md:11`; plan row
`docs/planning/standalone-pedigree-package-plan.md:505`, R49: Phase 13 takes two sessions; contract
`docs/planning/pedkindraw-api-contract.md:173`, `:187`). New code (R9): the genotyped animals with kinship 0
between every two, to which no genotyped animal can be added, the same answer every time. The orient picker asks
Mark: this, or the other READY item, **tests for full coverage** (`methodology/BACKLOG.md:34`: 44 of 2,089
statements missed, the same 44 since S14), or hold.
**Status:** READY. Phase 13's first session DONE (S17: `checkPedigree()`, R49-R51, 23 tests); suite 595 tests, 0
failed, WARN 0, SKIP 0, 3682 expectations; `R CMD check --as-cran` R16's NOTE only; drift tool 90 functions, 0
differ; pushed through `60a87a7` (CI run `43507284539`: 5/5 `Status: OK` at the first attempt); S17's close-out
commits are not pushed.
**Plan:** `docs/planning/standalone-pedigree-package-plan.md:37` (Next), `:505` (row 13), `:110` (R9), `:151-153`
(R49-R51, the latest rulings' pattern); the comparison `docs/research/pedigree-package-comparison-2026-11.md:392`
(5.4: kinship2's and Pedixplorer's sets 4, 2 and 44, valid on every seed), `:424` (7: kinship2 6.53 s at 10,000,
Pedixplorer 15.4 s, both out of memory at 30,000).
**Session boundary:** one session, one function.
**Priority:** HIGH.

### What You Must Do
1. Orient, and run the drift tool (`Rscript tools/compareWithNprcgenekeepr.R ../nprcgenekeepr`).
2. Reproduce the comparison's three cases with kinship2 before anything else: `sample.ped`'s families 1 and 2 with
   their own `avail` (sizes 4 and 2), and `rhesus375` with `avail <- as.integer(stats::runif(nrow(p)) < 0.3)` right
   after `set.seed(42L)` (size 44). How the comparison built them, and its "maximal" test (no available animal
   outside the set has kinship 0 with all of it): nprcgenekeepr `tools/pedigreeComparison/runAgreement.R:316`
   (`compareUnrelated()`) and `:468` (the calls). Its `rhesus375` is
   `tools/pedigreeComparison/data/rhesus375.csv` in the nprcgenekeepr clone, read with its `readPed()`; check
   its row order against pedkindraw's fixture (`tests/testthat/fixtures/obfuscated_rhesus_mhc_ped.csv`) before
   using the seed on the fixture, since the seed picks by row.
3. Read kinship2's help for `pedigree.unrelated` (S17 read it: a greedy method on the kinship matrix, the row with
   the most zeros first, ties at random; "running this function multiple times can return different sets"). Run it
   on many cases, each under a time limit (Learning 19), and record set sizes per seed.
4. A measured pre-RED picker (Learning 17): what to do with a pedigree `checkPedigree()` faults; how relatedness is
   computed (the copied `kinship()`, dense, or shared ancestors: check the equivalence on every fixture first,
   BACKLOG item's note); the tie rule (byte order, C16); the time target. Rulings R52 on, in their own commit.
5. Draft tests in the scratchpad, run them against a prototype in a scratch tree (Gotchas), RED, GREEN, REFACTOR;
   checks; push; CI; "Done 13" in the plan (Phase 13 DONE), contract 4.4, ROADMAP, BACKLOG.

### Gotchas
- **Check a detector against an independent slow version, not against what a generator meant to inject**
  (Learning 20, S17): 17 cycle injections did nothing (a leaf has no descendant), and read as misses until a
  brute-force check agreed 1,200 of 1,200. For `findUnrelated()`, the slow version is the definition itself:
  every pair in the set has kinship 0, and no genotyped animal outside it has kinship 0 with every member.
- **Hand-derived expected values were wrong again** (S17: a male dam's detail lists all its offspring). Run the
  drafts against the prototype before RED (Learning 18); S17's draft run caught it.
- **kinship2's `pedigree()` refuses** one known parent, a parent with no row, a wrong-sex or unknown-sex parent (an
  `H` parent included), duplicate or blank ids, and `"0"` codes with character ids (its `missid` is `""`), so
  `pedigree.unrelated()` needs a pedigree kinship2 accepts; `checkPedigree()` (R50) names each of these. Its sex
  codes are 1 male, 2 female, 3 unknown.
- **Pedixplorer is not installed** in pedkindraw's renv (kinship2 1.9.6.2 is). Its 4, 2 and 44 are the comparison's
  measurements; installing it (Bioconductor) is a renv change under Learning 3, so a picker choice.
- **`setTimeLimit(elapsed = 10, transient = TRUE)`** guards an in-process kinship2 call
  (`tests/testthat/helper-checkPedigree.R:214`, `helper-ibdMatrix.R:73`). S17 ran kinship2's `pedigree()` in
  process under it, not one process per case (it is plain R and returned on every case); `pedigree.unrelated()`
  computes a kinship matrix, so time it per case before choosing.
- **The scratch-tree recipe** worked first time: `git archive HEAD | tar -x -C <tree>`, the prototype as
  `<tree>/R/<name>.R`, the drafts in `<tree>/tests/testthat/`, then `cd <tree>` and `R_LIBS=<lib> R_LIBS_USER=<lib>
  NOT_CRAN=true Rscript --no-init-file -e 'pkgload::load_all("."); testthat::test_file(...)'`, `<lib>` from
  `Rscript -e 'cat(renv::paths$library())'` in the project. Clear the tree with `find <tree> -type f -delete`
  (zsh's empty glob).
- **Save suite results to an rds** (`saveRDS(as.data.frame(testthat::test_local(...)), <file>)`), then read it.
- **Lint on test files measures nothing** (`.lintr` excludes `tests`, Learning 4); report `lint_package()`.
- **Times on this Mac (S17):** suite ~90 s; coverage ~2 min; `R CMD check --as-cran` ~5 min, its tests 83 s, run
  from a scratch folder with `R_LIBS` and `R_LIBS_USER` set to the renv library; CI ~8 min.
- **nprcgenekeepr's S1164 was mid-session during S17** (one uncommitted test file, not copied here).

### Key files
- `methodology/BACKLOG.md:11` (the `findUnrelated()` item), `:34` (coverage).
- `docs/planning/pedkindraw-api-contract.md:173` (`findUnrelated()`'s row), `:187` (its sizes and time target).
- `R/checkPedigree.R:79` (`checkPedigree()`), `:139` (`.checkNames`), `:147` (`.checkSexRows()`), `:168`
  (`.checkRows()`), `:181` (`.checkListed()`), `:191` (`.checkOffspring()`), `:210` (`.checkCycles()`, whose
  ancestor walk is a pattern for shared-ancestor relatedness).
- `tests/testthat/helper-checkPedigree.R:121` (`checkPedigreeRandomCase()`, seeded cases with `withr::with_seed()`),
  `:139` (`checkPedigreeSlow()`), `:214` (`kinship2CheckAnswer()`); `tests/testthat/test_checkPedigree.R:270`,
  `:279` (the slow-checker and kinship2 comparisons, the second with its floor).
- `CLAUDE.md:174` (Learning 19), `:175` (Learning 20).

### How You Will Be Evaluated
The user rates every session's handoff. Your handoff will be scored on:
1. Was the ACTIVE TASK block sufficient to orient the next session?
2. Were key files listed with line numbers?
3. Were gotchas and traps flagged?
4. Was the "what's next" actionable and specific?

---

## Session History

*Session history accumulates below this line. Newest session at the top.*
*S1-S16's entries were removed in S3-S17 (FM #28): their durable records are the receipts in `HANDOFFS.md` and the
entries in `CHANGELOG.md`.*

### What Session 18 Did
**Deliverable:** plan Phase 13's second session, `findUnrelated()`, new code test-first (R9): the comparison's three
cases reproduced with kinship2 under a time limit (Learning 19), its `pedigree.unrelated` help read (R14), a scratch
prototype, a measured pre-RED picker, rulings R52 on, RED, GREEN, REFACTOR, checks, push, CI; Phase 13 DONE (IN PROGRESS)
**Started:** 2026-11-13 17:03 CST · **Model:** Claude Opus 5.5 · Mark picked "findUnrelated() (Recommended)" at the
orient picker.
**Status:** Session claimed. Work beginning.
**Ledger:** `CHANGELOG: pending` — the claim commit's `CHANGELOG.md` entry says (in progress); Phase 3F records the rest.

### Session 16 Handoff Evaluation (by Session 17)
**Score: 9/10.**
- **What helped:** the ordered steps (drift tool; contract 4.4 and the comparison's sections 4, 5.4 and 7; kinship2's
  help only; a scope picker, then a measured pre-RED picker; rulings from R49), which became this session's
  sequence; the scratch-tree recipe, which ran the drafts first time; saving suite results to an rds; the zsh glob
  warning (no trap this time); the `setTimeLimit()` guard, reused in `kinship2CheckAnswer()`; times that held
  (suite ~90 s, `R CMD check` ~5 min); every cited line number right at Orient (BACKLOG `:11`, `:26`; contract
  `:167`; plan `:37`, `:502`, `:110`, `:116`, `:148-150`; `R/ibdMatrix.R:64`, `:121`, `:150`, `:169`, `:185`;
  `helper-ibdMatrix.R:27`, `:73`; `CLAUDE.md:159`, `:174`).
- **What was missing:** that kinship2 has no checker and its `pedigree()` help documents none of its refusals, so
  the checks had to be measured; where the comparison's three unrelated-set cases come from (`sample.ped`'s two
  families with their own `avail`, `rhesus375` after `set.seed(42L)`), found in nprcgenekeepr's `runAgreement.R`
  and now in the BACKLOG item for S18.
- **What was wrong:** nothing found wrong.
- **ROI:** high; no rediscovery of any recipe it gave.

### What Session 17 Did
**Deliverable:** plan Phase 13's first session, `checkPedigree()`, new code test-first; push, CI (DONE).
**Started:** 2026-11-13 13:23 CST · **Model:** Claude Opus 5.5 · **Mark's picks:** "Phase 13" (orient);
"checkPedigree() now" (scope, R49); "One row per problem id", "Add two checks", "\"0\", blank and \"NA\"", "Tests,
slow version, kinship2" (pre-RED, R50-R51); the PRE-RED, RED, GREEN and REFACTOR gates "Yes".
**Commits:** claim `ac644bf`; rulings `fc1f244`; RED `5f399d9`; GREEN `300107d`; REFACTOR `60a87a7`; pushed
(`b8ade6e..60a87a7`, 7 commits with S16's two close-out commits); close-out commits not pushed.
**Verified:** before the pickers, a scratch prototype on 300 seeded random pedigrees: equal to a slow checker in
300 of 300 (check, id, order), every check in at least 10 cases; kinship2 1.9.6.2's `pedigree()` in agreement on
224 of 224 compared (154 refusals, 70 acceptances; 76 set aside: one known parent, an `H` parent or an odd sex
code); its refusals tabulated on 195 single-problem cases; 0.17 s on 100,000 animals. The 23-test draft run
against the prototype in a scratch tree (562 expectations, 0 failed after one hand value corrected); RED 595 tests,
23 errors, each first on the missing function, WARN 0, SKIP 0; GREEN and REFACTOR: suite 595, 0 failed, WARN 0,
SKIP 0, 3682 expectations; `lint_package()` 0; roxygen idempotent; drift 90, 0 differ; `R CMD check --as-cran` 1
NOTE (R16's), PASS 3675 SKIP 3, twice; coverage 97.57%, `R/checkPedigree.R` 83 of 83; 0.14 s on 100,000 animals;
CI `43507284539` 5/5 `Status: OK`, first attempt (macOS PASS 3682; Windows 3681, SKIP 1; Ubuntu 3671, SKIP 2).
**Self-assessment: 8/10.**
+ Every picker stated measured counts (300 cases, 224 kinship2 comparisons, 1,200 brute-force checks); the apparent
  misses were checked against an independent slow version before being believed, and that version became a test;
  a wrong hand-derived value caught before RED; RED clean; GREEN's first draft had 2 lints only; the new file fully
  covered; R50 written from measured behaviour, H and one-parent differences from kinship2 stated as measured.
- Slips: the first recall tally counted no-op injections as misses (one extra run to disprove); a hand-derived
  value wrong again (Learning 18); three formatting runs to read kinship2's message table; kinship2 run in process
  under `setTimeLimit()` rather than one process per case (it returned on every case, but Learning 19 asks for
  processes); the first `R CMD check` run set `_R_CHECK_FORCE_SUGGESTS_=false` (the rerun without it gave the same
  result).
**Ledger:** `CHANGELOG.md` S17 entries (the session and the push).
