# Session Notes

**Purpose:** Continuity between sessions. Each session reads this first and writes to it before closing out.

**This file is transient — it is overwritten every session** (*"what's next, what traps?"*).
The cumulative, append-only record of *what was done, ever* lives in `CHANGELOG.md`; the commit SHA is the shared key.
At close-out, distill the durable outcome into a `CHANGELOG.md` entry — do not copy this handoff into it.

---

## ACTIVE TASK
**Task:** Phase 17, the CRAN submission (`docs/planning/cran-submission-plan.md`). 17a-17f2 DONE (S33-S41); the gap
phases G1-G17 run before 17g (R97, `docs/planning/gaps-and-shared-code-plan.md` section 5.1). G1-G14 DONE (S42-S63).
G15 (gap B1, mates with no offspring; R141; `docs/planning/mates-without-offspring-plan.md`): plan S64; **G15a DONE
(S65)**: `makePedigreeMatingLayout(matings = NULL)`, a data frame of `sire` and `dam`, draws each pair joined at a
mating point with no line down, never left out (Mark's five S65 picks, in R141 and the plan's G15a DONE bullet).
**Next: G15b, `getMatings(ped, matings = NULL)` lists declared matings** (the plan's section 7, `:260`; strict TDD;
measure first, then the pre-RED picker at `:264`-`:265`). Then G15c (the converters), G16-G17, 17g.
**Status:** READY. No work in progress; the tree is clean but `pedkindraw.Rproj` (Mark's). S65's commits are pushed
(Mark's standing pick, a memory).
**The orient picker:** G15b (recommended: the plan's order, R97's). Also, from `methodology/BACKLOG.md`: READY, the
narrow legend (`:61`), the drawing vignette's measured trait (`:68`), the `smallPed` fixture (`:91`), rewording
`DIVERGENCE.md`'s older rows (`:43`), tests for full coverage (`:97`), `findPedigreeNumber()`'s speed (`:236`), and the
seven "Ready, small" items (`:162`, `:174`, `:181`, `:190`, `:200`, `:217`, `:223`); NEEDS DECISION, a converted
Pedixplorer object's `avail` (`:74`), long names at the edges (`:82`); "Waiting on Mark", the dashboard not seeing
`methodology/BACKLOG.md` (`:137`), copying nprcgenekeepr's colony overview (`:144`), and **new in S65**, an animal
with two or more mates drawn once between them as kinship2 draws it (`:151`). BLOCKED, and so not offered: `:11`,
`:52`, `:131`. Name every item in the picker (memory "Picker sets: name items, include all").
**Session boundary:** one session, G15b DONE; G15c is a session of its own.
**Priority:** HIGH (G15b-G15c, G16-G17, then 17g).

### What You Must Do
1. Orient; drift tool (expect **91 functions, 23 differ, 0 without a row**: S65 added `.findIsolatedIds()`'s row);
   nprcgenekeepr's log on the copied files, `git -C ../nprcgenekeepr log --oneline baef1e12c..HEAD -- $(grep -l
   'Copied from nprcgenekeepr' R/*.R tests/testthat/*.R | xargs -n1 basename | sed 's#^#*/#')`: the same 4 commits
   (`4283e3502`, `a85311021`, `392dd347e`, `471589138`). nprcgenekeepr was at `3e06730c5`, tree clean, through S65.
2. Check S65's push: `R/`, `tests/`, `man/`, `vignettes/` changed, so both workflows run. An estimate, not measured:
   CI fails on Ubuntu R-devel only (S4Vectors in "setup-r-dependencies", as S56-S64), the other four `success`, and
   Ubuntu release's tests read about FAIL 0, WARN 0, SKIP 2, PASS 14,792 (S64's 13,832 plus the new file's 960
   local expectations, if its browser and random tests run there as S63's did); the site builds.
3. **G15b** by `docs/planning/mates-without-offspring-plan.md` section 7 (`:260`-`:270`) and section 5 (`:149`-`:151`):
   `getMatings(ped, matings = NULL)` adds the declared pairs with no offspring after the offspring matings, `offspring`
   0, so R119's "the matings the drawing's layout builds" holds. Measure first on a scratch copy (Learning 17): the
   layout's mating points against `getMatings()`'s rows on the 12 typed shapes and the 100 random cases of
   `tests/testthat/helper-matesNoOffspring.R` (reuse `.matesShapes()`, `.matesPick()`); then the picker (the declared
   rows' place; `offspring` 0 or a column saying a row was declared), RED, GREEN, REFACTOR by the gates. The shared
   check is `.checkMatings()` (`R/matings.R:25`): its messages name `makePedigreeMatingLayout()`, so it needs the
   caller's name (as `.checkPositiveNumber()` takes one); and see the first gotcha.

### Gotchas
- **A `getMatings()` row naming a sire or dam without a row of its own is "left out" with a message by
  `.checkMatings()`** (found at S65's close-out, not fixed; measured): `getMatings()` lists such a parent as recorded,
  so passing its result back for a pedigree where C's sire S has no row prints "1 mating(s) in 'matings' naming an
  animal not in 'ped' left out: S and B", although S and B are drawn from their offspring anyway. The drawing is
  right; the message misleads. G15b's shared check is the place: decide (in its picker) whether a declared row whose
  pair has offspring together in `ped` is dropped silently before the absent check.
- **What G15a decided** (R141's S65 picks; don't re-ask): an animal with several matings is drawn at each; a row
  naming an animal not in `ped` is left out with a message (not a stop); a pair named twice, in either column, once;
  any sexes; the point hovered "0 offspring". Stops: not `NULL` or a data frame with `sire` and `dam`, `NA`, the same
  id as sire and dam; checked before the hints.
- **A pair in either role:** use `.layoutHintPairKey()` (`R/layoutHints.R:211`), the unordered key (the G15 plan's
  dragon 11); `getMatings()` itself keys `sire`, `dam` in order (`R/getMatings.R:48`).
- **The rectilinear style's routing points have `NA` hover text** (gaps plan dragon 82): `id[title == x]` returns
  `NA` ids; use `which()`.
- **`makePedigreeMatingLayout()`'s default style is rectilinear**: compare a default call with a rectilinear layout
  (a draft test of S65 compared it with a direct one).
- **The rectilinear style warns "could not be fully resolved" on 49 of 100 random pedigrees without matings**:
  `.matesLayout()` (the helper) muffles that warning alone; any other warning is kept (gate `test-suite-warnings-zero`).
- **Run Rscript from the root** (gaps plan dragon 83): from `tests/testthat/` renv is not loaded ("The package
  "quadprog" is required") and the `cd` stays. zsh does not split an unquoted variable (dragon 79): S65 hit it once.
- **Carried:** a unit with no offspring takes the sex rule (fixed; `R/makePedigreeDiagramData.R:1547`-`:1553`); new
  units go after the offspring units (`:689`-`:697`), or 600 of 600 breaks; vis.js outlines in screen pixels (73);
  the fidelity check compares the drawing's script (74); `NOT_CRAN=true` for the browser tests; dry-run every edit
  script on a `git archive` copy and check new lines' widths (S65's caught two long lines and a joined one); guarded
  `rm` (`"${SP:?}"`); the 5-file cap splits GREEN; the ratchet's suite gate times out at 300 s (run the suite by
  hand); `CLAUDE.md` is over its budget (learnings go to the plans' dragons); `pedkindraw.Rproj` untracked, Mark's;
  the stale pedkindraw 0.0.1 in renv's library (`BACKLOG.md:174`); a `cd` into `methodology/` persists (run the
  ratchet in a subshell).
- **Ledger sizes:** see S65's receipt (both well under the 196,608 B threshold).
- **Scratch scripts** (`/private/tmp/claude-501/-Users-rmsharp-Development-pedkindraw/249e536b-3df4-4009-abed-c09e52477510/scratchpad/g15a/`,
  may be gone): `pics.R` (typed shapes drawn in headless Chrome at 500 px), `sheet.R` (a contact sheet of PNGs),
  `coll.R` (which unresolved lines the matings add, by wrapping `.resolveEdgeNodeCollisions()`), `trim.R` (what the
  trimming functions leave in a `matings` table), `apply_proto2.py` (prototype 2, Mark's picks), `runone.R` and
  `runmany.R` (test files on a copy, from its `tests/testthat/` with `R_LIBS` set), `record.R` (every layout of the
  test file's cases, for a before/after proof), `closeout1.py`.
- **Times** (S65's): the full suite 353 s; the new test file 16 s (12 s its random cases); the fidelity tool about
  3.5 min; `R CMD check --as-cran` about 10 min (tests 173 s).

### Key files
- `docs/planning/mates-without-offspring-plan.md`: section 5 `:132` (G15b's interface `:149`), 7 `:208` (G15a
  `:224`, its DONE bullet `:247`; G15b `:260`; G15c `:272`), 8 `:293` (dragons 9-11 `:316`-`:326`).
- `R/matings.R:25` (`.checkMatings()`); `R/makePedigreeDiagramData.R:551` (`.findIsolatedIds()`), `:655`
  (`.buildMatingUnitForest()`, the declared units `:689`-`:697`), `:1547` (`childSide`), `:2095` (`@param matings`),
  `:2234` (the argument), `:2263` (the check), `:2334`, `:2385`, `:2612` ("%d offspring"); `R/layoutHints.R:32`,
  `:119`, `:153` (a declared pair together), `:211` (`.layoutHintPairKey()`), `:497` (`.layoutHintsUsedMate()`).
- G15b: `R/getMatings.R:40` (help `:6`-`:39`), `R/pedkindraw-package.R:23`, `README.Rmd:167`,
  `docs/planning/pedkindraw-api-contract.md:186`, `tests/testthat/test_getMatings.R`,
  `tests/testthat/helper-offspringAndMatings.R`.
- G15c (later): `R/asPedFrame.R:248`, `:287`, `:351`, `:404`, `:496`.
- Tests: `tests/testthat/test_matesNoOffspring.R` (14 tests), `tests/testthat/helper-matesNoOffspring.R`.
- `docs/planning/standalone-pedigree-package-plan.md:90` (Next), `:299` (R141 with the S65 picks), `:1309` (G15a's
  entry); `docs/planning/gaps-and-shared-code-plan.md:17` (status), `:380` (G15's row), `:820`-`:828` (dragons
  81-83); `docs/planning/cran-submission-plan.md:35`, `:692`; `methodology/BACKLOG.md:26`, `:151`.

### How You Will Be Evaluated
The user rates every session's handoff. Your handoff will be scored on:
1. Was the ACTIVE TASK block sufficient to orient the next session?
2. Were key files listed with line numbers?
3. Were gotchas and traps flagged?
4. Was the "what's next" actionable and specific?

---

## Session History

*Session history accumulates below this line. Newest session at the top.*
*S1-S64's entries were removed in S3-S65 (FM #28): their durable records are the receipts in `HANDOFFS.md` and the
entries in `CHANGELOG.md`.*

### What Session 66 Did
**Deliverable:** Phase G15b (IN PROGRESS; gap B1, mates with no offspring; `getMatings(ped, matings = NULL)` lists
declared matings; `docs/planning/mates-without-offspring-plan.md:260`; `methodology/BACKLOG.md:26`): strict TDD,
measure first, the pre-RED picker, then RED, GREEN, REFACTOR by the gates.
**Started:** 2026-11-21 08:18 CST · **Model:** Claude Opus 5.5 · **Mark's pick:** "G15b: list declared matings
(Recommended)" (orient)
**Status:** Session claimed. Measuring on a scratch copy first (the layout's mating points against `getMatings()`'s
rows on the test helper's 12 shapes and 100 random cases; the "left out" message for a rowless parent), then the
pre-RED picker.
**Ledger:** `CHANGELOG: pending` -- the claim commit's `CHANGELOG.md` entry says (in progress); Phase 3F records the
rest.

### Session 64 Handoff Evaluation (by Session 65)
**Score: 9/10.**
- **What helped:** item 3's measure-first list (a)-(c) was the session's plan, and the plan's picker list
  (`:232`-`:234`) became S65's two pickers. The gotchas were used: dragon 1 (`secondMate` reaches `childSide`; RED has
  a test for it), dragon 7 (units after the offspring units; the random test checks the numbers), dragon 3 (matings
  checked before the hints). S64's scratch scripts survived and were reused (`apply_proto.py`, `apply_fix.py`,
  `protorun.R`'s `pickMatings()` and `checkMatings()`). Every key-file line was right (`:540`, `:638`, `:1522`-`:1528`,
  `:2179`, `:2206`, `:2276`, `:2327`, `:2554`; `R/layoutHints.R:28`, `:148`, `:189`). The predictions held: drift
  91/22/0; nprcgenekeepr's 4 commits at `3e06730c5`; S64's CI failed on Ubuntu R-devel only (setup-r-dependencies),
  Ubuntu release FAIL 0, WARN 0, SKIP 2, PASS 13,832; the site built.
- **What was missing:** that pedkindraw already draws a two-dam sire twice when both matings have offspring (the
  hub choice's baseline, found by measuring); that "7 seeds gained a collision warning" counted layouts that warn,
  not unresolved lines (26 gained, 12 lost, by lines); that the plan's "stops on an id not in `ped`" and the
  picker's "removed animals" are one decision; that the prototype's pair key was ordered (a swapped row would make
  a second unit).
- **What was wrong:** nothing found wrong.
- **ROI:** high.

### What Session 65 Did
**Deliverable:** Phase G15a, the layout draws declared matings (gap B1; R141), strict TDD. DONE.
**Started:** 2026-11-21 00:38 CST · **Model:** Claude Opus 5.5 · **Mark's picks (each first time):** "G15a: draw
mated pairs (Recommended)" (orient); "At each mating", "Leave it out, with a message", "Accept it, drawn once",
"Accept any sexes", "Dot, hover '0 offspring'" (all Recommended); PRE-RED->RED, RED->GREEN (the NEWS bullet as
quoted), GREEN->REFACTOR ("Yes, proceed to REFACTOR (Recommended)"). No corrections from Mark.
**Commits:** claim `036875b`; RED `d8a8060`; GREEN `22a6f7b` (code), `46dce77` (help, NEWS), `eaddc77`
(`DIVERGENCE.md`, contract, vignette, gap case); REFACTOR `5a35482`; close-out 1 `c912992`, `ab3c781`; close-out 2
(these notes, the receipt, the ledger). Pushed at close.
**Measured:** pictures of 13 shapes in both styles under both anchor rules; pedkindraw's own two-dam drawing
(`[A B A' G]`, kinship2 `B A G`); the unresolved lines the matings add on 100 seeds (139 of 139 repeat-node arcs);
what 6 trimming calls leave in a `matings` table (190 of 200 rows after `trimPedigree()`); the drafts run on a
prototype of the picks (960 of 960) and 10 existing test files on it (0 failed). Verified: the new file 14 tests,
960 expectations; full suite 81 files, 1,008 tests, 0 failed, 0 skipped, 0 warnings; lint 0; roxygen unchanged;
covr 54 of 54 changed code lines and 32 of 32 of `R/matings.R` reached by the new file alone; `R CMD check
--as-cran` 1 NOTE (R16's); drift 91/23/0, exit 0; fidelity 600 of 600, exit 0; REFACTOR 224 of 224 layouts
identical before and after.
**Self-assessment: 8/10.**
+ Every expected value measured on a prototype before RED; the decisions put with pictures and counts, each
  answered at once; RED failed for the right reason only; GREEN passed on its first run; every DONE criterion
  checked, the browser test included; REFACTOR proven by machine.
- Slips, none reaching a commit: 4 draft-test bugs found on the prototype (`NA` not recycled, `NA` hover ids, a
  pedigree with a rowless sire and no `gen`, the default edge style); a zsh unquoted list and a wrong file name; a
  `cd` into `tests/testthat/` that stuck; two long lines and a joined one in the close-out script, caught by the dry
  run; `_R_CHECK_FORCE_SUGGESTS_=false` added to the check command (not `CLAUDE.md`'s; every Suggests is installed,
  so no effect). Found at close-out and left for G15b: the misleading "left out" message for a `getMatings()` row
  naming a rowless parent.
**Learnings:** the G15 plan's dragons 9-11; the gaps plan's dragons 81-83. No `CLAUDE.md` row (over budget).
**Ledger:** `CHANGELOG.md` S65 entries (the session, R141's G15a picks, push 1).
