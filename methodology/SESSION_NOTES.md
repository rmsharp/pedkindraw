# Session Notes

**Purpose:** Continuity between sessions. Each session reads this first and writes to it before closing out.

**This file is transient — it is overwritten every session** (*"what's next, what traps?"*).
The cumulative, append-only record of *what was done, ever* lives in `CHANGELOG.md`; the commit SHA is the shared key.
At close-out, distill the durable outcome into a `CHANGELOG.md` entry — do not copy this handoff into it.

---

## ACTIVE TASK
**Task:** Phase 17, the CRAN submission (`docs/planning/cran-submission-plan.md`). 17a-17f2 DONE (S33-S41); the gap
phases G1-G17 run before 17g (R97, `docs/planning/gaps-and-shared-code-plan.md` section 5.1). G1-G14 DONE (S42-S63).
G15 (gap B1, mates with no offspring; R141; `docs/planning/mates-without-offspring-plan.md`): plan S64; G15a DONE
(S65, the layout draws a `matings` table); **G15b DONE (S66)**: `getMatings(ped, matings = NULL)` lists each declared
pair with no offspring together after the matings built from offspring, `offspring` 0, the drawing's matings in its
order; the shared check `.checkMatings()` sets aside, without a message, a row naming a pair with offspring together
(Mark's three S66 picks, in R141 and the plan's G15b DONE bullet).
**Next: G15c, the converters keep the matings** (the plan's section 7, `:288`; section 5, `:156`; strict TDD;
measure first, then the pre-RED picker at `:296`-`:297`). G15 is DONE after it; then G16-G17, 17g.
**Status:** READY. No work in progress; the tree is clean but `pedkindraw.Rproj` (Mark's). S66's commits are pushed
(Mark's standing pick, a memory).
**The orient picker:** G15c (recommended: the plan's order, R97's). Also, from `methodology/BACKLOG.md`: READY, the
narrow legend (`:62`), the drawing vignette's measured trait (`:69`), the `smallPed` fixture (`:92`), rewording
`DIVERGENCE.md`'s older rows (`:44`), tests for full coverage (`:98`), `findPedigreeNumber()`'s speed (`:237`), and the
seven "Ready, small" items (`:163`, `:175`, `:182`, `:191`, `:201`, `:218`, `:224`); NEEDS DECISION, a converted
Pedixplorer object's `avail` (`:75`), long names at the edges (`:83`); "Waiting on Mark", the dashboard not seeing
`methodology/BACKLOG.md` (`:138`), copying nprcgenekeepr's colony overview (`:145`), an animal with two or more mates
drawn once between them as kinship2 draws it (`:152`). BLOCKED, and so not offered: `:11`, `:53`, `:132`. Name every
item in the picker (memory "Picker sets: name items, include all"); S66's three-option picker with previews listing
the items was answered at once.
**Session boundary:** one session, G15c DONE (and so G15 DONE); G16 starts with a planning session of its own.
**Priority:** HIGH (G15c, G16-G17, then 17g).

### What You Must Do
1. Orient; drift tool (expect **91 functions, 23 differ, 0 without a row**; S66 changed `.buildMatingUnitForest()`'s
   code and row, still 23); nprcgenekeepr's log on the copied files, `git -C ../nprcgenekeepr log --oneline
   baef1e12c..HEAD -- $(grep -l 'Copied from nprcgenekeepr' R/*.R tests/testthat/*.R | xargs -n1 basename | sed
   's#^#*/#')`: the same 4 commits (`4283e3502`, `a85311021`, `392dd347e`, `471589138`). nprcgenekeepr was at
   `3e06730c5`, tree clean, through S66.
2. Check S66's push: `R/`, `tests/`, `man/`, `README.md`, `NEWS.md` changed, so both workflows run. An estimate, not
   measured: CI fails on Ubuntu R-devel only (S4Vectors in "setup-r-dependencies", as S56-S65), the other four
   `success`, and Ubuntu release's tests read FAIL 0, WARN 0, SKIP 2, PASS **15,279** (S65's 14,792 exactly, plus
   `test_getMatings.R`'s 471 new expectations and `test_matesNoOffspring.R`'s 16; locally 15,290, CI skipping 11 as
   for S65); the site builds.
3. **G15c** by `docs/planning/mates-without-offspring-plan.md` section 7 (`:288`-`:304`) and section 5 (`:156`-`:161`):
   `asPedFrame()` gains a fourth element `matings` (`NULL` or `sire`, `dam`) from kinship2's relation code 4 (number
   or text) and Pedixplorer's `"Spouse"` rows, the male as sire; mate hint rows naming a declared pair kept; R74's
   reason reworded. Measure first on a scratch copy (Learning 17, Learning 19): `asPedFrame()` then the layout on
   every typed shape of section 2 and seeded random pedigrees with code 4 or `"Spouse"` rows, against kinship2's and
   Pedixplorer's drawn matings where each returns; which hint rows `autohint()` and `auto_hint()` write for declared
   pairs; and count the existing tests each option changes (the plan measured 10 whole-list comparisons, 5 in
   `test_asPedFrame.R`, 4 in `test_asPedFramePedixplorer.R`, 1 in `test_asPedFrameHints.R`, plus the two "spouses left
   out" tests, `test_asPedFrame.R:156` and `test_asPedFramePedixplorer.R:134`). Then the picker (a declared pair with
   offspring together, kept or left out; a pair the layout refuses; a same-sex pair), RED, GREEN, REFACTOR.

### Gotchas
- **Since S66 the layout and `getMatings()` set aside a declared row naming a pair with offspring together, quietly**
  (`R/matings.R:54`): so a converter that keeps such rows changes no drawing and no `getMatings()` result; say so in
  G15c's picker (the first of its three questions) with the measure.
- **`.checkMatings(matings, ped, caller)`** (`R/matings.R:32`) starts each message with `caller`; the converters
  have their own "left out" style (R74, `R/asPedFrame.R:491`, `.asPedFrameUsableMate()` `:496`), so decide whether
  `asPedFrame()` checks its rows itself or leaves that to the layout.
- **What G15a and G15b decided** (R141's S65 and S66 picks; don't re-ask): an animal with several matings drawn at
  each; a row naming an animal not in `ped` left out with a message; a pair named twice once; any sexes; the point
  hovered "0 offspring"; `getMatings()`'s declared rows after the offspring matings, `offspring` 0, no new column;
  the quiet set-aside, after the `NA` stop and before the same-id stop (the G15 plan's dragon 13).
- **Both references fail where pedkindraw does not** (the G15 plan's dragon 5): kinship2's `plot()` on fewer than 3
  animals and on `twoChildless`, Pedixplorer's `align()` on both; count the cases compared (`expect_gte()`).
  Pedixplorer's `rel()` is S4: read it with `as.data.frame()` (dragon 6). Pedixplorer refuses a pair named twice.
- **Run a scratch copy from its root with `Rscript --no-init-file` and `R_LIBS` set to renv's library** (the gaps
  plan's dragon 84): S66 ran `source("../../renv/activate.R")` from `tests/testthat/` and renv bootstrapped
  `tests/testthat/renv/` (3.6 MB, untracked), caught by `git status` and removed before a commit. From a copy's
  `tests/testthat/`, `R_LIBS=$LIB Rscript runfiles.R ../.. <files>` works (no `.Rprofile` there).
- **Write an inline R script with a regular expression to a file**: zsh passed `"\s"` through as `\s`, and R
  stopped on "'\s' is an unrecognized escape" (S66; `[[:space:]]` avoids it).
- **Carried:** run Rscript from the root (dragon 83); the rectilinear warning on 49 of 100 random pedigrees, muffled
  alone by `.matesLayout()`; routing points' hover is `NA` (dragon 82, `which()`); the layout's default style is
  rectilinear; either role: `.layoutHintPairKey()` (`R/layoutHints.R:211`); new units after the offspring units, or
  600 of 600 breaks; `NOT_CRAN=true` for the browser tests; dry-run every edit script on a `git archive` copy and
  check new lines' widths; guarded `rm` (`"${SP:?}"`); the 5-file cap splits GREEN; the ratchet's suite gate times
  out at 300 s (run the suite by hand); `CLAUDE.md` is over its budget (learnings go to the plans' dragons);
  `pedkindraw.Rproj` untracked, Mark's; the stale pedkindraw 0.0.1 in renv's library (`BACKLOG.md:175`; README.md is
  rendered from a scratch install, S52's way); a `cd` into `methodology/` persists (run the ratchet in a subshell).
- **Ledger sizes:** see S66's receipt (both under the 196,608 B threshold).
- **Scratch scripts** (`/private/tmp/claude-501/-Users-rmsharp-Development-pedkindraw/97069250-f23a-4385-bdc8-f823b5761885/scratchpad/g15b/`,
  may be gone): `measure.R` (a prototype against the drawn mating points; the other order; the pass-back on 123
  pedigrees), `proto_p2.R` (the picks' prototype), `runfiles.R` (test files on a copy, from its `tests/testthat/`,
  each failing test named), `cover.R` (covr on the changed lines only), `record.R` (355 results before and after),
  `closeout1a.py`. S65's (`.../249e536b-3df4-4009-abed-c09e52477510/scratchpad/g15a/`) has `pics.R`, `sheet.R`,
  `refcases.R` and `pxhint.R` for drawing and converting the typed shapes.
- **Times** (S66's): the full suite 361-367 s; `test_getMatings.R` 7 s, `test_matesNoOffspring.R` 16 s; the fidelity
  tool about 3.5 min; `R CMD check --as-cran` about 10 min (tests 171 s); covr on two files about 1 min.

### Key files
- `docs/planning/mates-without-offspring-plan.md`: section 2 `:39` (what kinship2 and Pedixplorer do), 5 `:132`
  (G15c's interface `:156`), 7 `:211` (G15b `:263`, its DONE bullet `:274`; G15c `:288`), 8 `:309` (dragons 12-13
  `:343`-`:349`).
- G15c: `R/asPedFrame.R:248` (the kinship2 list), `:287` (`.asPedFrameTwins()`, code 4 left out `:285`), `:315`
  (`.asPedFramePxFields`), `:351` (the Pedixplorer list), `:404` (`.asPedFramePxTwins()`), `:491`-`:496`
  (`.asPedFrameUsableMate()`, R74's reasons); help `:39`, `:86`, `:111`; `tests/testthat/test_asPedFrame.R:156`,
  `test_asPedFramePedixplorer.R:134`, `test_asPedFrameHints.R`, `helper-asPedFrame.R`,
  `helper-asPedFramePedixplorer.R`; `docs/planning/pedkindraw-api-contract.md:214`;
  `docs/planning/standalone-pedigree-package-plan.md:233` (R74), `:300` (R141 with the S65 and S66 picks).
- `R/matings.R:32` (`.checkMatings()`, the set-aside `:54`); `R/getMatings.R:62`; `R/makePedigreeDiagramData.R:551`
  (`.findIsolatedIds()`), `:656` (`.buildMatingUnitForest()`), `:2094` (`@param matings`), `:2222` (the layout),
  `:2264` (the check); `R/layoutHints.R:32`, `:211`.
- Tests: `tests/testthat/test_getMatings.R` (16 tests), `tests/testthat/helper-offspringAndMatings.R`
  (`declaredMatingCases()`, `drawnMatings()`, `matingPairs()`), `tests/testthat/test_matesNoOffspring.R` (15 tests),
  `tests/testthat/helper-matesNoOffspring.R` (`.matesShapes()`, `.matesPick()`, `.matesLayout()`).
- `docs/planning/standalone-pedigree-package-plan.md:91` (Next), `:1319` (G15b's entry);
  `docs/planning/gaps-and-shared-code-plan.md:17` (status), `:381` (G15's row), `:830` (dragon 84);
  `docs/planning/cran-submission-plan.md:35`, `:697`; `methodology/BACKLOG.md:26`, `:152`; `tools/gapCases.R:289`.

### How You Will Be Evaluated
The user rates every session's handoff. Your handoff will be scored on:
1. Was the ACTIVE TASK block sufficient to orient the next session?
2. Were key files listed with line numbers?
3. Were gotchas and traps flagged?
4. Was the "what's next" actionable and specific?

---

## Session History

*Session history accumulates below this line. Newest session at the top.*
*S1-S65's entries were removed in S3-S66 (FM #28): their durable records are the receipts in `HANDOFFS.md` and the
entries in `CHANGELOG.md`.*

### Session 65 Handoff Evaluation (by Session 66)
**Score: 9/10.**
- **What helped:** item 3 of "What You Must Do" was the session's plan: measure the layout's mating points against
  `getMatings()`'s rows on the helper's 12 shapes and 100 random cases (`.matesShapes()`, `.matesPick()` reused as
  named), then the picker, and that `.checkMatings()` needs the caller's name. The first gotcha (the misleading "left
  out" message for a rowless parent) became the picker's third question and Mark's pick. The predictions held
  exactly: drift 91/23/0; nprcgenekeepr's 4 commits at `3e06730c5`; S65's CI failed on Ubuntu R-devel only and
  Ubuntu release read PASS 14,792, the estimate to the expectation. Every key-file line was right (`R/matings.R:25`,
  `R/getMatings.R:40`/`:48`, `:689`-`:697`, `README.Rmd:167`, contract `:186`, package `:23`, plan `:149`, `:260`).
  S65's scratch runners (`runmany.R`, `record.R`) were reused.
- **What was missing:** that `getMatings()` lists an animal recorded as both sire and dam of one offspring as
  (`X`, `X`), which the check's same-id stop refuses when passed back (1 of 123 pedigrees, found by measuring); that
  the builder's own filter (`:695`-`:696`) would become redundant once the check sets such pairs aside (the
  REFACTOR); that the plan's "one order of first appearance" needed a definition before it could be measured.
- **What was wrong:** nothing found wrong.
- **ROI:** high.

### What Session 66 Did
**Deliverable:** Phase G15b, `getMatings(ped, matings = NULL)` lists declared matings (gap B1; R141), strict TDD. DONE.
**Started:** 2026-11-21 08:18 CST · **Model:** Claude Opus 5.5 · **Mark's picks (each first time, all
Recommended):** "G15b: list declared matings" (orient); "After the others", "By offspring = 0", "Drop them quietly";
PRE-RED->RED, RED->GREEN (the NEWS bullet as quoted), GREEN->REFACTOR. No corrections from Mark.
**Commits:** claim `a417fa1`; RED `40565da`; GREEN `3a4a115` (code), `a85f129` (help, NEWS), `d94778a` (README,
contract, gap case); REFACTOR `f74627d`; close-out 1 `397a43d`, `5e3b5c3`; close-out 2 (these notes, the receipt,
the ledger). Pushed at close.
**Measured:** a prototype's rows against the drawn mating points, 112 of 112 in order (2,138 rows, 215 declared);
first appearance would differ in 84 of 112; the pass-back on 123 pedigrees (today's check 1 message, 1 stop; the
set-aside 123 of 123 unchanged); the options' test breakage (0; 1 message; 11 checks in 6 tests); the drafts on the
prototype (806 and 976 expectations, 0 failed) and on HEAD (9 failing, each for the right reason); the REFACTOR on a
scratch copy (355 of 355). Verified: full suite 81 files, 1,016 tests, 15,290 expectations, 0 failed, 0 skipped, 0
warnings; lint 0; roxygen unchanged; covr 12 of 12 and 5 of 5 changed lines; `R CMD check --as-cran` 1 NOTE (R16's);
drift 91/23/0, exit 0; fidelity 600 of 600, exit 0; the gap case "A B 2 / E F 0".
**Self-assessment: 8/10.**
+ Every picker option measured on a prototype before asking, with counts; each pick and gate answered at once; RED
  failed for the right reason only, checked per message; GREEN passed on its first run with the prototype's exact
  counts; the REFACTOR measured before its gate and proven on the tree; every DONE criterion checked.
- Slips, none reaching a commit: a stray `source("../../renv/activate.R")` from `tests/testthat/` bootstrapped an
  untracked `tests/testthat/renv/` (3.6 MB; removed after looking; the gaps plan's dragon 84); an inline R script's
  `"\s"` escape stopped R (rewritten as a file); a drift output written to `/tmp` once (removed); a `sed` range typo
  in a read-only command.
**Learnings:** the G15 plan's dragons 12-13; the gaps plan's dragon 84. No `CLAUDE.md` row (over budget).
**Ledger:** `CHANGELOG.md` S66 entries (the session, R141's G15b picks, push 1).
