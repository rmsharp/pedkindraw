# Session Notes

**Purpose:** Continuity between sessions. Each session reads this first and writes to it before closing out.

**This file is transient — it is overwritten every session** (*"what's next, what traps?"*).
The cumulative, append-only record of *what was done, ever* lives in `CHANGELOG.md`; the commit SHA is the shared key.
At close-out, distill the durable outcome into a `CHANGELOG.md` entry — do not copy this handoff into it.

---

## ACTIVE TASK
**Task:** Phase 17, the CRAN submission (`docs/planning/cran-submission-plan.md`). 17a-17f2 DONE (S33-S41); the gap
phases G1-G17 run before 17g (R97, `docs/planning/gaps-and-shared-code-plan.md` section 5.1). G1-G15 DONE (S42-S67).
G15 (gap B1, mates with no offspring; R141; `docs/planning/mates-without-offspring-plan.md`) is DONE in four
sessions: plan S64; G15a S65 (the layout draws a `matings` table); G15b S66 (`getMatings(matings = )`); **G15c S67**:
`asPedFrame()` returns a fourth element, `matings`, from kinship2's relation code 4 and Pedixplorer's `"Spouse"`
rows, every row as the object holds it, the male as sire (else the female as dam, else the object's order), and
keeps a mate hint row naming a declared pair (Mark's three S67 picks, in R141 and the plan's G15c DONE bullet).
**Next: G16's planning session** (gaps A1, picture files from a script, and A2, a whole large pedigree on one page
with every id written: `docs/planning/gaps-and-shared-code-plan.md:383`, the research record `:109` and `:128`).
The plan is the deliverable (failure mode #18): no package code; `SESSION_RUNNER.md` "Planning Sessions" (deepest
reasoning mode, a grep inventory, per-phase DONE criteria naming the surface); Mark's choices by picker. Then G16's
build sessions, G17 (an app), 17g.
**Status:** READY. No work in progress; the tree is clean but `pedkindraw.Rproj` (Mark's). S67's commits are
pushed (Mark's standing pick, a memory).
**The orient picker:** G16's planning session (recommended: the plan's order, R97's). Also, from
`methodology/BACKLOG.md`: READY, the narrow legend (`:62`), the drawing vignette's measured trait (`:69`), the
`smallPed` fixture (`:92`), rewording `DIVERGENCE.md`'s older rows (`:44`), tests for full coverage (`:98`),
`findPedigreeNumber()`'s speed (`:237`), and the seven "Ready, small" items (`:163`, `:175`, `:182`, `:191`, `:201`,
`:218`, `:224`); NEEDS DECISION, a converted Pedixplorer object's `avail` (`:75`), long names at the edges (`:83`);
"Waiting on Mark", the dashboard not seeing `methodology/BACKLOG.md` (`:138`), copying nprcgenekeepr's colony
overview (`:145`), an animal with two or more mates drawn once between them as kinship2 draws it (`:152`).
BLOCKED, and so not offered: `:11`, `:53`, `:132`. Name every item in the picker (memory "Picker sets: name items,
include all"); S67's orient picker named three groups with previews and was answered at once.
**Session boundary:** one session, G16's plan written (and committed), then close out; its build sessions follow.
**Priority:** HIGH (G16-G17, then 17g).

### What You Must Do
1. Orient; drift tool (expect **91 functions, 23 differ, 0 without a row**; S67 changed no copied function:
   `asPedFrame()` and `R/layoutHints.R` are pedkindraw's own); nprcgenekeepr's log on the copied files, `git -C
   ../nprcgenekeepr log --oneline baef1e12c..HEAD -- $(grep -l 'Copied from nprcgenekeepr' R/*.R
   tests/testthat/*.R | xargs -n1 basename | sed 's#^#*/#')`: the same 4 commits (`4283e3502`, `a85311021`,
   `392dd347e`, `471589138`). nprcgenekeepr was at `3e06730c5`, tree clean, through S67.
2. Check S67's push: `R/`, `tests/`, `man/`, `README.md`, `NEWS.md`, `vignettes/` and `tools/` changed, so both
   workflows run. An estimate, not measured: CI fails on Ubuntu R-devel only (S4Vectors in "setup-r-dependencies",
   S56-S67), the other four `success`, and Ubuntu release's tests read FAIL 0, WARN 0, SKIP 2, PASS about
   **16,056** (S66's 15,279 plus S67's 777 new expectations: `test_asPedFrameMatings.R` 771, `test_asPedFrame.R` 4,
   `test_asPedFramePedixplorer.R` 2; locally 16,067, CI skipping 11 as for S66); the site builds.
3. **G16's planning session**, by `SESSION_RUNNER.md` "Planning Sessions". Read, in order: the gaps plan's G16 row
   (`:383`) and A1 and A2's rows (`:122`, `:123`); the research record (`:109`-`:145`, the cases `files` and
   `largeIds`); the comparison study's section 10. Then measure before any picker (Learnings 17, 19): what the
   layout returns that a graphics renderer would read (`makePedigreeMatingLayout()`'s nodes and edges) against
   what `drawPedigreeDiagram()` draws (the symbols, condition sections, marks G13 added, slashes, twin lines,
   the legend, the repeat-node arcs), counted, so the "redraw the layout with R graphics" option's cost is a list;
   what a headless browser (chromote, already in Suggests) gives as PNG and PDF and whether it can give SVG; kinship2's
   and Pedixplorer's one-page pictures of the 375-animal rhesus pedigree (kinship2 writes 520 labels, Pedixplorer
   473 at `cex` 0.5, the research record's `largeIds`) beside either option's. Then the picker (the approach; which
   file types; whether a ggplot object comes too), then the plan with each phase's DONE, commands and surface (the
   browser tests run only here and on Ubuntu release, `skip_on_cran()`; CRAN's win-builder read 398 s at 17a, so
   each phase's test time counts). Do not write package code.

### Gotchas
- **G15 is closed; its picks are made** (don't re-ask): a spouse pair with offspring together kept as stored; a pair
  kinship2 holds twice kept twice; any sexes, the male as sire, else the female as dam, else the order the object
  holds. The earlier picks stand (the G15 plan's section 5; R141).
- **What the converters hold, measured** (the G15 plan's dragons 14-16): Pedixplorer stores each spouse pair with
  its ids sorted and reorders the rows, so the male as sire is rebuilt from the sexes; kinship2's relation `code`
  comes back a factor ("spouse") when given 4 and an integer when given text, so `as.integer()` reads both;
  kinship2 and Pedixplorer draw other pairs than pedkindraw on random pedigrees (R69), so only the typed shapes
  compare drawings.
- **Guard every variable in a removal path** (the gaps plan's dragon 85): `rm -rf "${SP:?}/$d"` was declined by
  Mark before it ran; write `"${SP:?}/${d:?}"`, and make each scratch copy under a new name.
- **Run a scratch copy from its root with `Rscript --no-init-file` and `R_LIBS` and `R_LIBS_USER` set to renv's
  library** (dragons 83-84); from `tests/testthat/` of a copy without them, R stops on "The package "quadprog" is
  required" (S67, nothing written).
- **Carried:** both references fail where pedkindraw does not (kinship2's `plot()` on fewer than 3 animals and on
  `twoChildless`, Pedixplorer's `align()` on both; count the cases compared with `expect_gte()`); Pedixplorer's
  `rel()` is S4 (`as.data.frame()`); run Rscript from the root (dragon 83); write an inline R script with a
  regular expression to a file; dry-run every edit script on a `git archive` copy and check new lines' widths; the
  5-file cap splits commits (S67: RED 1-2, GREEN 1-3); the ratchet's suite gate times out at 300 s (run the suite by
  hand, 6.5 min); `CLAUDE.md` is over its budget (learnings go to the plans' dragons); `pedkindraw.Rproj`
  untracked, Mark's; the stale pedkindraw 0.0.1 in renv's library (`BACKLOG.md:175`; README.md is rendered from a
  scratch install, S52's way, which S67 repeated: two renders identical, the diff the new words only); a `cd` into
  `methodology/` persists (run the ratchet in a subshell); the rectilinear warning on 49 of 100 random pedigrees,
  muffled alone by `.matesLayout()`; `NOT_CRAN=true` for the browser tests.
- **Ledger sizes:** see S67's receipt (both under the 196,608 B threshold).
- **Scratch scripts** (`/private/tmp/claude-501/-Users-rmsharp-Development-pedkindraw/1886a128-eeac-48de-ae2e-0b96026a4ec5/scratchpad/g15c/`,
  may be gone): `cases.R` (the 16 typed shapes), `probe1.R` and `probe2.R` (what each package stores for a declared
  pair), `apply_proto.py` (the prototype), `measure.R` (shapes and 100 random cases against both references),
  `hints.R` (the automatic hints' rows), `runfiles.R` (test files on a copy, each failing test named), `whyfail.R`
  (each failing expectation's message), `record.R` (672 results before and after), `cover.R`, `closeout1a.py`,
  `closeout1b.py`, `closeout2.py`. S65's (`.../249e536b-3df4-4009-abed-c09e52477510/scratchpad/g15a/`) has
  `pics.R` and `sheet.R` for drawing and photographing shapes in headless Chrome, which G16's measure may reuse.
- **Times** (S67's): the full suite 386 s; `test_asPedFrameMatings.R` 22 s; the fidelity tool 3.5 min; `R CMD check
  --as-cran` tests 177 s; covr on one file 1.5 min; the ratchet 5.5 min.

### Key files
- G16: `docs/planning/gaps-and-shared-code-plan.md:383` (G16's row), `:122`-`:123` (A1, A2), `:17`-`:19` (status),
  `:342` (section 5.1); `docs/research/pedkindraw-gaps-2026-11-18.md:109` (A1), `:128` (A2), `:39`-`:40`, `:67`-`:68`;
  `docs/research/pedigree-package-comparison-2026-11.md` section 10; `R/drawPedigreeDiagram.R:205` (the function;
  its "Export Diagram (PNG)" button `:450`); `R/makePedigreeDiagramData.R:2222` (`makePedigreeMatingLayout()`, whose
  nodes and edges a second renderer would read); `DESCRIPTION:27` (chromote in Suggests).
- G15c (done): `R/asPedFrame.R:332` (`.asPedFrameK2Matings()`), `:346` (`.asPedFrameMatings()`, the roles), `:476`
  (`.asPedFramePxMatings()`), `:570` (`.asPedFrameUsableMate()`); `R/layoutHints.R:121` (`.checkLayoutHintMate()`),
  `:200` (`.layoutHintMated()`); `tests/testthat/test_asPedFrameMatings.R` (7 tests), `helper-asPedFrame.R`
  (`asPedFrameHintsAuto()`); `docs/planning/mates-without-offspring-plan.md:313` (G15c's DONE), `:375`-`:390`
  (dragons 14-16); `docs/planning/standalone-pedigree-package-plan.md:91` (Next), `:233` (R74), `:300` (R141),
  `:1328` (G15c's entry); `docs/planning/pedkindraw-api-contract.md:214`; `docs/planning/gaps-and-shared-code-plan.md:835`
  (dragon 85); `docs/planning/cran-submission-plan.md:36`, `:703`; `methodology/BACKLOG.md:26`; `tools/gapCases.R:289`.

### How You Will Be Evaluated
The user rates every session's handoff. Your handoff will be scored on:
1. Was the ACTIVE TASK block sufficient to orient the next session?
2. Were key files listed with line numbers?
3. Were gotchas and traps flagged?
4. Was the "what's next" actionable and specific?

---

## Session History

*Session history accumulates below this line. Newest session at the top.*
### What Session 67 Did
**Deliverable:** Phase G15c (IN PROGRESS; gap B1, mates with no offspring; the converters keep the matings:
`asPedFrame()` returns `matings` from kinship2's relation code 4 and Pedixplorer's `"Spouse"` rows;
`docs/planning/mates-without-offspring-plan.md:288`; `methodology/BACKLOG.md:26`): strict TDD, measure first, the
pre-RED picker, then RED, GREEN, REFACTOR by the gates. G15 DONE after it.
**Started:** 2026-11-21 09:53 CST · **Model:** Claude Opus 5.5 · **Mark's pick:** "G15c: converters keep mates
(Recommended)" (orient)
**Status:** Session claimed. Measuring on a scratch copy first (`asPedFrame()` then the layout on the typed shapes and
seeded random code-4/`"Spouse"` pedigrees against kinship2 and Pedixplorer; `autohint()`/`auto_hint()` rows for
declared pairs; each option's test breakage), then the pre-RED picker.
**Ledger:** `CHANGELOG: pending` -- the claim commit's `CHANGELOG.md` entry says (in progress); Phase 3F records the
rest.

*S1-S66's entries were removed in S3-S67 (FM #28): their durable records are the receipts in `HANDOFFS.md` and the
entries in `CHANGELOG.md`.*

### Session 66 Handoff Evaluation (by Session 67)
**Score: 9/10.**
- **What helped:** item 3's measure-first list was the session's plan, and the plan's own numbers held: the 10
  whole-list comparisons (5, 4 and 1 by file) were 12 failing tests with the two spouse tests, exactly as listed;
  the first gotcha (a converter keeping such rows changes no drawing, since S66's quiet set-aside) became the
  picker's first question and its measured answer ("the drawing is the same"); `.checkMatings(caller =)` and the
  converters' own "left out" style were the second gotcha, settled by leaving the hint check to the layout's rules.
  The predictions held: drift 91/23/0; nprcgenekeepr's 4 commits at `3e06730c5`; S66's CI failed on Ubuntu R-devel
  only and Ubuntu release read FAIL 0, WARN 0, SKIP 2, PASS 15,279, the estimate exactly. Every key-file line was
  right (`R/asPedFrame.R:248`, `:287`, `:315`, `:351`, `:404`, `:491`-`:496`; the two spouse tests' lines; the
  contract `:214`; R74 `:233`, R141 `:300`; the plan's `:288`). The scratch runner `runfiles.R` was reused as named.
- **What was missing:** that Pedixplorer stores each spouse pair with its ids sorted (so "the male as sire" cannot
  be read from the object; found by a probe); that the plan's third picker item, "a pair the layout would refuse",
  was empty (both packages stop on an id not in the pedigree and on an animal mated with itself: the plan's own
  section 2 rows said so); that kinship2 returns the relation `code` as a factor or an integer by how it was given.
- **What was wrong:** nothing found wrong. The run time of the full suite was given as 361-367 s; with S67's tests it
  reads 386 s (an addition, not an error).
- **ROI:** high.

### What Session 67 Did
**Deliverable:** Phase G15c, `asPedFrame()` keeps the matings (gap B1; R141), strict TDD. DONE (and so G15 DONE).
**Started:** 2026-11-21 09:53 CST · **Model:** Claude Opus 5.5 (the claim to GREEN 3 and the REFACTOR's
measurement), Claude Sonnet 5.5 (the REFACTOR commit and the close-out; the harness changed the model mid-session) ·
**Mark's picks (each first time, all Recommended):** "G15c: converters keep mates" (orient); "Keep it", "Both rows,
as stored", "Keep them" (the pre-RED picker's three questions); PRE-RED->RED, RED->GREEN (the NEWS bullet as quoted),
GREEN->REFACTOR. One tool use declined by Mark (a scratch loop's `rm -rf "${SP:?}/$d"`, guarded on the first
variable only), after which he said "continue"; no other correction.
**Commits:** claim `416e48c`; RED `affea2e` (the new test file), `3dc9b3f` (the 5 existing files); GREEN `0e9333e`
(`R/asPedFrame.R` and its help), `0fd11a6` (NEWS, overview, contract), `3b83590` (README, two vignettes); REFACTOR
`1a6092e`; `17849ea` (the gap case's probes); close-out 1 `2066715`, `e295efa`; close-out 2 (these notes, the
receipt, the ledger). Pushed at close.
**Measured:** the converters' stored forms on 16 typed shapes in both packages; a prototype (three switches) on the
14 typed shapes (pedkindraw's drawn pairs equal kinship2's in 14 of 14 and Pedixplorer's in 11 of 11 where it aligns)
and on 100 seeded random pedigrees (243 declared rows, all drawn; the references' joined pairs equal pedkindraw's in
25 and 39 of 100); the automatic hints' rows for declared pairs (kinship2 34 rows in 26 of 99, Pedixplorer 32 in 27
of 81); the existing tests each switch changes (0); the drafts on the prototype (771, 422, 243, 785 expectations, 0
failed) and on HEAD (19 failing, each for the right reason); the REFACTOR on a scratch copy (672 of 672).
Verified: full suite 82 files, 1,023 tests, 16,067 expectations, 0 failed, 0 skipped, 0 warnings (on GREEN and on
REFACTOR); lint 0; roxygen unchanged; covr 32 of 32 changed lines; `R CMD check --as-cran` 1 NOTE (R16's); drift
91/23/0, exit 0; fidelity 600 of 600; the gap case "E F", "E F", TRUE.
**Self-assessment: 8/10.**
+ Every picker option measured on a prototype first, with counts, and the picker said where a planned item was empty;
  each pick and gate answered at once; RED failed for the right reason only (the 3 errors and 2 warnings traced to
  the missing element); GREEN passed on its first run with the prototype's exact counts; the REFACTOR measured
  (672 of 672) before its gate and proven on the tree (each file identical to the measured copy); every edit script
  dry-run on a `git archive` copy; every DONE criterion checked.
- Slips, none reaching a commit: a scratch loop's `rm -rf` guarded on one variable (declined by Mark; the gaps plan's
  dragon 85); two `scalar_in` lints in GREEN 1's first draft (fixed before its commit); Rscript from a copy's
  `tests/testthat/` without `R_LIBS` once (stopped, nothing written); the draft's floors were `0L` placeholders until
  the measured counts replaced them before RED; the picker said "13 vs Pedixplorer" where 11 align (the test and the
  commit say 11 of 13).
**Learnings:** the G15 plan's dragons 14-16; the gaps plan's dragon 85. No `CLAUDE.md` row (over budget).
**Ledger:** `CHANGELOG.md` S67 entries (the session, R141's G15c picks, push 1).
