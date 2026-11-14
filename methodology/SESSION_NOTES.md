# Session Notes

**Purpose:** Continuity between sessions. Each session reads this first and writes to it before closing out.

**This file is transient — it is overwritten every session** (*"what's next, what traps?"*).
The cumulative, append-only record of *what was done, ever* lives in `CHANGELOG.md`; the commit SHA is the shared key.
At close-out, distill the durable outcome into a `CHANGELOG.md` entry — do not copy this handoff into it.

---

## ACTIVE TASK
**Task:** **Plan Phase 14's second session: `asPedFrame()` for Pedixplorer `Pedigree` objects**, with Pedixplorer
installed into renv first (`methodology/BACKLOG.md:11`; rulings R55-R57 at
`docs/planning/standalone-pedigree-package-plan.md:159-161`; contract 4.5 at `docs/planning/pedkindraw-api-contract.md:197`,
its row `:201`). It completes Phase 14. The orient picker asks Mark: this, **tests for full coverage**
(`methodology/BACKLOG.md:37`, 43 of 2,227 statements missed), or hold.
**Status:** READY. Phase 14's kinship2 half DONE (S19: `asPedFrame()` generic, the `pedigree` and `pedigreeList`
methods, 15 tests, R55-R57); suite 629 tests, 0 failed, WARN 0, SKIP 0, 4750 expectations; `R CMD check --as-cran`
R16's NOTE only; drift tool 90 functions, 0 differ; pushed through `58deb0a` (CI run `43626771667`: 5/5 `Status: OK`
at the first attempt); S19's close-out commits are not pushed.
**Plan:** `docs/planning/standalone-pedigree-package-plan.md:39` (Next), `:514` (row 14), `:159-161` (R55-R57);
the comparison `docs/research/pedigree-package-comparison-2026-11.md:844` (11.2: what Pedixplorer's method reads,
and its required case: an all-`NA` `affection` column is not a condition).
**Session boundary:** one session: the install, then Pedixplorer's method test-first; Phase 14 DONE.
**Priority:** HIGH.

### What You Must Do
1. Orient, and run the drift tool (`Rscript tools/compareWithNprcgenekeepr.R ../nprcgenekeepr`).
2. Read the backlog item whole (`methodology/BACKLOG.md:11`): it holds every fact S19 measured about Pedixplorer
   1.8.0's objects and its install. Re-measure what a picker will state (Learnings 17-19): S19's scratch scripts are
   gone with its scratchpad.
3. The install is a renv change under Learning 3 (now with S19's sentence: count against renv's library alone).
   Set the dated repository (`https://packagemanager.posit.co/cran/2026-10-31`) before anything; install
   BiocManager and Pedixplorer (Bioconductor 3.23) with `rebuild = TRUE`; reinstall by name any CRAN dependency renv
   linked from its cache; `renv::snapshot(dev = TRUE)`; run the gate (`grep -c
   'packagemanager.posit.co/cran/latest' renv.lock` must print 0). Add Pedixplorer to `Suggests` in the same commit.
   Measure first whether this needs its own picker (it is ruled, R55: Mark picked it for this session).
4. A measured pre-RED picker: which of Pedixplorer's own slots become columns (the comparison's table says only the
   user's extra columns; `mcols(x)` also holds Pedixplorer's `error`, `avail_mods`, `<condition>_mods`); what
   `famid` does (ids are already `<famid>_<id>`); conditions from `fill(x)` (the all-`NA` case); the default
   method's message, which names only kinship2's classes (`tests/testthat/test_asPedFrame.R:21` changes); the stop
   when Pedixplorer is not installed (R55). Rulings R58 on.
5. Drafts against a prototype in a scratch tree (Gotchas), with a round trip data frame -> `Pedigree()` ->
   `asPedFrame()` as the slow check, shown able to fail by planting the all-`NA` defect; RED, GREEN, REFACTOR;
   checks; push; CI (its first install of a Bioconductor package: pak should resolve it, a prediction); "Done 14" in
   the plan, contract 4.5, ROADMAP, BACKLOG.

### Gotchas
- **Never start R inside a scratch tree without `--no-init-file`**: its `.Rprofile` turns on renv for that folder
  and bootstraps a library in renv's shared folder. S19 did it once:
  `~/Library/Caches/org.R-project.R/R/renv/library/tree-86aa6c47` (renv only, 77 files, harmless, left for Mark to
  delete).
- **A prototype's S3 methods need `NAMESPACE` lines in the scratch tree** (`S3method(asPedFrame,pedigree)` and so
  on): without them `pkgload::load_all()` finds none and every test errors "no applicable method".
- **Hand-derived values were wrong again** (S19: kinship2 warns about unknown sex only above 25%, and "terminated"
  is not "unknown"). Run the drafts against the prototype before RED (Learning 18).
- **kinship2 warns "More than 25% of the gender values are 'unknown'"**; `asPedFrameK2()` in
  `tests/testthat/helper-asPedFrame.R:17` muffles exactly that warning (WARN 0 gate). Pedixplorer's `Pedigree()`
  warns when it returns a data frame instead of an object.
- **The scratch-tree recipe:** `git archive HEAD | tar -x -C <tree>`, the prototype as `<tree>/R/<name>.R`, the
  drafts in `<tree>/tests/testthat/`; from `<tree>`: `env -u RENV_PROJECT R_LIBS=<lib> R_LIBS_USER=<lib>
  NOT_CRAN=true Rscript --no-init-file -e 'pkgload::load_all("."); testthat::test_file(...)'`, `<lib>` from
  `Rscript -e 'cat(renv::paths$library())'` in the project. A scratch library for Pedixplorer goes first on
  `.libPaths()`, renv's library second; `.Library` is always added after them.
- **Save a long run's results to a literal path**: S19's RED suite ran twice because `saveRDS()` got an unset
  variable.
- **`CLAUDE.md` is over its 28,000 B budget** (30,352 B after S19's sentence in Learning 3); the reduction is the
  context-budget item's own session (`methodology/BACKLOG.md:86`, R18).
- **Times on this Mac (S19):** suite ~3 min; coverage ~2.5 min; `R CMD check --as-cran` ~2.5 min from a scratch
  folder; CI ~8-9 min.

### Key files
- `methodology/BACKLOG.md:11` (the Pedixplorer item), `:37` (coverage), `:86` (context budget).
- `R/asPedFrame.R:82` (generic), `:88` (default method: its message), `:97`/`:103` (kinship2's methods), `:109`
  (`.asPedFrameKinship2()`), `:147` (`.asPedFrameConditions()`), `:167` (`.asPedFrameText()`), `:179`
  (`.asPedFrameTwins()`).
- `tests/testthat/test_asPedFrame.R:21` (the refusal test), `:33` (hand-built object);
  `tests/testthat/helper-asPedFrame.R:17` (`asPedFrameK2()`), `:44` (fixtures), `:65` (`asPedFrameForKinship2()`),
  `:92` (`asPedFrameTrip()`), `:142` (`asPedFrameRandomCase()`).
- `CLAUDE.md:158` (Learning 3, with S19's sentence).

### How You Will Be Evaluated
The user rates every session's handoff. Your handoff will be scored on:
1. Was the ACTIVE TASK block sufficient to orient the next session?
2. Were key files listed with line numbers?
3. Were gotchas and traps flagged?
4. Was the "what's next" actionable and specific?

---

## Session History

*Session history accumulates below this line. Newest session at the top.*
*S1-S18's entries were removed in S3-S19 (FM #28): their durable records are the receipts in `HANDOFFS.md` and the
entries in `CHANGELOG.md`.*

### What Session 20 Did
**Deliverable:** plan Phase 14's second session: `asPedFrame()` for Pedixplorer `Pedigree` objects, new code
test-first (R9), with Pedixplorer 1.8.0 installed into renv first (R55, Learning 3) and listed in `Suggests`; a
measured pre-RED picker, rulings R58 on, drafts against a scratch prototype with a `Pedigree()` round trip as the
slow check, RED, GREEN, REFACTOR, checks, push, CI; Phase 14 DONE (IN PROGRESS)
**Started:** 2026-11-14 14:47 CST · **Model:** Claude Opus 5.5 · Mark picked "Pedixplorer converter (Recommended)"
at the orient picker.
**Status:** Session claimed. Work beginning.
**Ledger:** `CHANGELOG: pending` — the claim commit's `CHANGELOG.md` entry says (in progress); Phase 3F records the rest.

### Session 18 Handoff Evaluation (by Session 19)
**Score: 9/10.**
- **What helped:** the ordered steps, which became this session's sequence: the drift tool; contract 4.5 and the
  comparison's section 11.2 read whole; Pedixplorer decided first in a scope picker with measured facts; kinship2's
  help read and its objects measured; a measured pre-RED picker; rulings from R55; drafts against a prototype, with
  the round trip on every fixture as the slow check. Also the scratch-tree recipe, the `example()` and
  `zero_coverage()` gotchas, `sample.ped`'s `0` codes (minnbreast has them too), and the warning that hand values
  go wrong (one did). Every cited line number was right at Orient.
- **What was missing:** that `R CMD check` stops with an ERROR when a suggested package is not installed, which
  made installing Pedixplorer a condition of its half rather than an option; that a dependency count must be taken
  against renv's sandbox (S19's first count, 13, was wrong; 47 is right, and the comparison's 49 included
  BiocManager and BiocVersion).
- **What was wrong:** nothing found wrong.
- **ROI:** high; the steps and recipes saved rediscovery throughout.

### What Session 19 Did
**Deliverable:** plan Phase 14's first session: `asPedFrame()`, the generic and kinship2's `pedigree` and
`pedigreeList` methods, new code test-first; the Pedixplorer half split off to its own session (R55).
**Started:** 2026-11-14 10:42 CST · **Model:** Claude Opus 5.5 · **Mark's picks:** "Phase 14: asPedFrame()
(Recommended)" (orient); "kinship2 now, Pedixplorer next" (scope, R55); "Accept if ids unique", "ALIVE", "No, read
it directly", "Typed cases, round trip" (pre-RED, R55-R57); the PRE-RED, RED and GREEN gates "Yes"; REFACTOR "Yes,
both changes".
**Commits:** claim `d3a815f`; rulings `7b54eec`; RED `d2c5554`; GREEN `815924d`; REFACTOR `58deb0a`; pushed
(`4bcfe00..58deb0a`, 7 commits with S18's two close-out commits); close-out commits after, not pushed.
**Verified:** before the pickers: Pedixplorer 1.8.0 in a scratch library (13 packages there, 47 against renv's
library), a scratch lock file (`"Bioconductor": {"Version": "3.23"}`), `R CMD check --as-cran` on a scratch copy
with Pedixplorer suggested (ERROR at the dependencies); kinship2's and Pedixplorer's objects printed; the round trip
on a prototype, 372 of 372 identical, all 372 differing with the index-0 defect planted; `sample.ped` and
`minnbreast` as family lists. The drafts against the prototype: 15 tests, 418 expectations, 0 failed (one hand value
corrected first); with the defect planted 8 of 15 fail. RED 629 tests, 15 failing, each first on the missing
function, WARN 0, SKIP 0. GREEN and REFACTOR: suite 629, 0 failed, WARN 0, SKIP 0, 4750 expectations;
`lint_package()` 0; roxygen idempotent; drift 90, 0 differ; `R CMD check --as-cran` 1 NOTE (R16's), PASS 4743 SKIP
3, twice; coverage 97.74%, `R/asPedFrame.R` 49 of 49; `quality_ratchet --run` 4/4; CI `43626771667` 5/5 `Status:
OK`, first attempt (macOS PASS 4750; Windows 4749, SKIP 1; Ubuntu 4739, SKIP 2).
**Self-assessment: 8/10.**
+ Every picker number measured, the install measured three ways (scratch library, scratch lock, scratch check)
  before the scope picker; the round trip shown able to fail before it became a test, and the tests shown to catch
  the defect; RED clean; the new file fully covered; the factor branch found redundant by coverage and removed in
  REFACTOR.
- Slips: the first dependency count was wrong (13; the scratch snapshot exposed the hidden 34 before the picker);
  a hand value wrong again (a kinship2 warning that does not come); R started inside the scratch tree once, which
  left a renv library folder; the prototype's methods unregistered on the first draft run; the RED suite run twice
  (unset path); a Learning 3 edit duplicated a table cell (caught by counting cells before commit).
**Ledger:** `CHANGELOG.md` S19 entries (the session and the push).
