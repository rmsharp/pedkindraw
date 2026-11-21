# Session Notes

**Purpose:** Continuity between sessions. Each session reads this first and writes to it before closing out.

**This file is transient — it is overwritten every session** (*"what's next, what traps?"*).
The cumulative, append-only record of *what was done, ever* lives in `CHANGELOG.md`; the commit SHA is the shared key.
At close-out, distill the durable outcome into a `CHANGELOG.md` entry — do not copy this handoff into it.

---

## ACTIVE TASK
**Task:** Phase 17, the CRAN submission (`docs/planning/cran-submission-plan.md`). 17a-17f2 DONE (S33-S41); the gap
phases G1-G17 run before 17g (R97, `docs/planning/gaps-and-shared-code-plan.md` section 5.1). G1-G13 DONE (S42-S59).
**G14 DONE (S60-S63, R140, `docs/planning/standalone-pedigree-package-plan.md:295`):** four settings of
`makePedigreeMatingLayout()`, each a multiple of today's: `symbolSize` (S60), `textSize` (S61), `columnSpacing` and
`rowSpacing` (S62), and **`lineWidth` (S63):** every line between animals that many units wide and the related
parents' mating line 4 times it, the dashes and gaps times it, each outline that many pixels and a genotyped one
plus 3, each mark's strokes that many times as wide, the legend kept, not rounded (`R/lineWidth.R`).
**Next: G15 (gap B1, mates with no offspring), its planning session first** (gaps plan `:378`: "A planning session
first ... then its build sessions", 1 + 3-5 sessions, a guess). The plan is that session's deliverable, no code
(`methodology/SESSION_RUNNER.md` "Planning Sessions"; failure mode #18).
**Status:** READY. No work in progress; the tree is clean but `pedkindraw.Rproj` (Mark's). S63's commits are pushed
(Mark's standing pick, a memory).
**The orient picker:** G15's planning session (recommended: R97's order; then G16-G17, each planned first, then
17g). Also READY: the narrow legend (`methodology/BACKLOG.md:60`), the drawing vignette's measured trait (`:67`), the
`smallPed` fixture (`:90`), rewording `DIVERGENCE.md`'s older rows (`:42`), tests for full coverage (`:96`), and the
"Ready, small" items (seven: `:152`, `:164`, `:171`, `:180`, `:190`, `:207`, `:213`; name all seven in the last
option, as S48-S63 did). NEEDS DECISION: a converted Pedixplorer object's `avail` (`:73`); long names at the edges
cut at the default text size (`:81`).
**Session boundary:** one session, G15's plan written to `docs/planning/` and committed; its build sessions follow.
**Priority:** HIGH (G15-G17, then 17g).

### What You Must Do
1. Orient; drift tool (expect **91 functions, 22 differ, 0 without a row**: S63 added `.deceasedSlashHandler()`'s
   row); nprcgenekeepr's log on the copied files, `git -C ../nprcgenekeepr log --oneline baef1e12c..HEAD -- $(grep
   -l 'Copied from nprcgenekeepr' R/*.R tests/testthat/*.R | xargs -n1 basename | sed 's#^#*/#')`: the same 4
   commits (`4283e3502`, `a85311021`, `392dd347e`, `471589138`). nprcgenekeepr was at `3e06730c5`, tree clean,
   through all of S63.
2. Check S63's push: both workflows run. Expected, not measured: CI fails on Ubuntu R-devel only (Bioconductor's
   S4Vectors in "setup-r-dependencies", before pedkindraw is checked, as on S56-S62's pushes), the other four jobs
   `success`; read Ubuntu release's testthat summary (S62's push: FAIL 0, WARN 0, SKIP 2, PASS 13,636), since the new
   browser test records every canvas stroke on Linux's Chrome. The site must build.
3. **G15's plan (a planning session; set the deepest reasoning mode; Learning 6, 7, 8):** gap B1
   (`docs/research/pedkindraw-gaps-2026-11-18.md:159`): kinship2's `pedigree(relation = )` code 4 and Pedixplorer's
   `"Spouse"` join two animals with no offspring as a mating; pedkindraw has no input that declares one, so E and F
   are left out (`isolatedIds`, `.findIsolatedIds()` at `R/makePedigreeDiagramData.R:540`, called at `:2276`), a
   mate hint naming them stops (R70; `R/layoutHints.R:151`), and the converters drop such pairs with one message
   (`R/asPedFrame.R:491`-`:508`). The layout builds every mating from shared offspring:
   `.buildMatingUnitForest()` is at `R/makePedigreeDiagramData.R:638` (G15's row still cites `:454`, stale). The
   plan needs, at least: the input (a matings table, a code in the twins table as kinship2 does, or a column), what
   the converters then keep (kinship2's relation code 4, Pedixplorer's Spouse), where the layout places a mating
   with no offspring (both edge styles; the mating point and its line with nothing below), what `isolatedIds`, the
   hints (R70) and `drawPedigreeDiagram()`'s legend and hover do, and the fidelity cost (600 of 600 at the default:
   the new input absent, nothing changes). Grep-based inventory of every caller of `.buildMatingUnitForest()`,
   `.findIsolatedIds()`, `isolatedIds`, the hints' mate checks and the converters' left-out pairs; per-phase DONE
   criteria, verification commands and the surface (headless Chrome for anything drawn); each build phase a session.
   Measure kinship2's and Pedixplorer's drawings of the `matesNoOffspring` case first (`tools/gapCases.R:289`;
   Learnings 18-19) and put the input choice to Mark in a picker with what each option does, measured.

### Gotchas
- **vis.js draws an outline in screen pixels, a line and a mark in units** (dragon 73, new): `borderWidth` is pixels at
  any zoom; edges' `width` and handlers' `ctx.lineWidth` shrink with the zoom. S63's first fill figures were in units.
- **The fidelity check compares the drawing's script** (dragon 74, new): any change to a handler's text at the default
  breaks 600 of 600 though the drawing looks the same; S63's first prototype read 540. Run fidelity on a prototype
  before RED.
- **A `pkg::` call in a test passes the suite and warns in `R CMD check`** (dragon 75, new): grep new tests' `::`
  against `DESCRIPTION`'s Suggests in RED (S63's `jsonlite::` needed a picker and a GREEN fix).
- **A number from one prototype option is stale once another is picked; read every check you start** (dragon 76,
  new): S63's help said 7 of 16 from the 4-times run (4 of 16 at the pick), and a 120-character line reached RED
  because the line check went to an unread log.
- **`\s` in an R one-liner inside shell quotes fails** (`'\s' is an unrecognized escape`; it bit S63 twice despite
  this handoff's gotcha): use `[[:space:]]` or `fixed = TRUE`, or write the script with the Write tool.
- **Dry-run an edit script on a copy first** (S63): a script that fails on its third anchor has already written the
  first two (S63 restored `R/probandMark.R` with `git checkout`); copy the files to the scratchpad, run, then run on
  the tree.
- **A quick test run without `NOT_CRAN=true` skips the browser tests** and reads fewer expectations (S63: 171 of
  196); set it, as `CLAUDE.md`'s fast single-file command does.
- **Carried:** guarded `rm` (`"${SP:?}"/"${d:?}"`); an unquoted heredoc rewrites backslashes (69); a `DIVERGENCE.md`
  row by its first cell (70); lintr refuses `par()` (71; S63 read kinship2's lwd from `recordPlot()`, dragon 77); a
  step's depth (72); covr's line numbers move with each edit (S63's `covr_new.R` finds statements by text); a `cd`
  into `methodology/` persists (run the ratchet as `(cd methodology && ...)`); a `git archive` copy's `.Rprofile`
  (67); Monitors on `pgrep` (68); `gen` from `findGeneration()` (66); `tools/gapCases.R` runs from the root and
  Pedixplorer leaves `Rplots.pdf` there (41: `rm -f Rplots.pdf`); the 5-file cap splits GREEN; the ratchet's suite
  gate times out at 300 s; `CLAUDE.md` is over its budget (learnings go to the plans' dragons);
  `pedkindraw.Rproj` untracked, Mark's; the stale pedkindraw 0.0.1 in renv's library (`BACKLOG.md:164`).
- **Ledger sizes:** `CHANGELOG.md` 141,955 B of its 196,608 B threshold; `HANDOFFS.md` 111,058 B.
- **Scratch scripts** (`/private/tmp/claude-501/-Users-rmsharp-Development-pedkindraw/5ca3a558-9d5c-4754-89c4-cc8755220a34/scratchpad/g14l/`,
  may be gone): `cases.R` (8 pedigrees, the loop added; `withMarks()`), `looksL.R` (configs at 500 px, both styles,
  all marks: zoom, ids over ink, room, dash runs), `analyseL.R`, `composeL.py` (the picture page), `strokeprobe.R`
  (every canvas stroke of one redraw), `dashprobe.R`, `run_checks.sh` (suite, check, fidelity, covr on `<prefix>_*`
  copies), `covr_new.R`, `mutants.py`/`mutrunL.R`, `refactor_saveL.R`, `apply_green*.py`, `closeout1.py`.
- **Times** (S63's): suite about 5 min (80 files, 994 tests); `run_checks.sh` about 10 min; the looks harness 208
  drawings in about 9 min in three processes.

### Key files
- `docs/planning/gaps-and-shared-code-plan.md`: `:378` (G15's row), `:341` ("Every G phase"), `:377` (G14's row,
  DONE), `:788`-`:809` (dragons 73-77, new).
- `docs/research/pedkindraw-gaps-2026-11-18.md:159` (B1, mates with no offspring); `:43` and `:70` (its rows).
- `docs/planning/standalone-pedigree-package-plan.md`: `:87` (Next), `:225` (R70), `:295` (R140), `:1284` (G14
  session 4); `docs/planning/cran-submission-plan.md:682` (G14 session 4); `docs/planning/layout-hints-design.md`
  (the mate hint, R70).
- G15's code: `R/makePedigreeDiagramData.R:540` (`.findIsolatedIds()`), `:638` (`.buildMatingUnitForest()`),
  `:2276` (the call); `R/layoutHints.R:151` (the mate hint's stop); `R/asPedFrame.R:491`-`:508` (pairs left out);
  `tools/gapCases.R:289` (`matesNoOffspring`).
- S63's work: `R/lineWidth.R` (`.visDashes` `:21`, `.lineWidthLayout()` `:38`, `.outlineAt()` `:67`,
  `.strokeWidthJs()` `:82`, `.layoutLineWidth()` `:93`); `R/makePedigreeDiagramData.R` (`:2045` `@param lineWidth`,
  `:2179` the argument, `:2196` the check, `:2778` the call); `R/drawPedigreeDiagram.R:333` (the width read, the
  Genotyped row), `:443` (passed on); the six handlers' `.strokeWidthJs()` lines (`R/affectedConditions.R:180`,
  `R/deceasedSlash.R:63`, `R/probandMark.R:75`, `R/evaluatedMark.R:53`, `R/infertileMark.R:143`,
  `R/miscarriageMark.R:187`); `tests/testthat/test_lineWidth.R` (8 tests; the browser test `:258`).
- `methodology/BACKLOG.md:26` (G15-G17), `:42`, `:60`, `:67`, `:73`, `:81`, `:90`, `:96`, `:152`-`:213`.

### How You Will Be Evaluated
The user rates every session's handoff. Your handoff will be scored on:
1. Was the ACTIVE TASK block sufficient to orient the next session?
2. Were key files listed with line numbers?
3. Were gotchas and traps flagged?
4. Was the "what's next" actionable and specific?

---

## Session History

*Session history accumulates below this line. Newest session at the top.*
*S1-S62's entries were removed in S3-S63 (FM #28): their durable records are the receipts in `HANDOFFS.md` and the
entries in `CHANGELOG.md`.*

### Session 62 Handoff Evaluation (by Session 63)
**Score: 9/10.**
- **What helped:** the measure-first list (a)-(g) was the session's plan and became the scope picker's four
  questions; the line-width inventory was right line for line (the six `ctx.lineWidth` lines, the consanguinity 4 at
  `:2580` carried to the doglegs at `:2955`, the genotyped 4 at `R/genotypedMark.R:20`, the legend's `:399`, the
  dash patterns at `:237`); Pedixplorer's `lwd` (158 of 262 rows) was reused as measured; the scratch scripts were
  there and were adapted (`looks.R`, `cases.R`, `compose.py`, `run_checks.sh`, `mutrun.R`, `runtests.R`,
  `refactor_save.R`); the guarded-`rm`, dragon 69-71 and ratchet gotchas held; drift 91/21/0, nprcgenekeepr's 4
  commits and the CI prediction (R-devel only; Ubuntu release FAIL 0, WARN 0, PASS 13,636) held.
- **What was missing:** that vis.js draws outlines in screen pixels (dragon 73; the drawing's help already said "4
  pixels wide", but no handoff said what that means for a width multiple); that the fidelity check compares the
  drawing's script text, so a handler's text must not change at the default (dragon 74; G13's sessions added
  handlers only when a mark was present, but the rule was not written); that `drawPedigreeDiagram()` finds the
  Genotyped row by an outline exactly 4 wide (`R/drawPedigreeDiagram.R:320` then), which any width setting breaks.
- **What was wrong:** nothing found wrong.
- **ROI:** high.

### What Session 63 Did
**Deliverable:** Phase G14's fourth and last session DONE, so G14 DONE: the line width,
`makePedigreeMatingLayout(lineWidth = 1)`; the REFACTOR made one outline rule and one stroke-width line.
**Started:** 2026-11-20 21:52 CST · **Model:** Claude Opus 5.5 · **Mark's picks (each first time):** "G14: line width
(Recommended)" (orient); "Lines, outlines, marks (Recommended)", "Grow with the line (Recommended)", "The line width
plus 3 (Recommended)" and "Keep the legend as is (Recommended)" (pre-RED, with a picture page opened for him); "Yes,
proceed to RED"; "Yes, proceed to GREEN"; "Fix the test's reading (Recommended)" (the jsonlite WARNING); "Yes,
REFACTOR (Recommended)". No corrections from Mark; two of mine told to him (the fill figures, before RED).
**Commits:** claim `0a3c565`; RED `8f23975`; GREEN 1 `8f0739e` (R/lineWidth.R, the four own marks); GREEN 2
`11a6398` (the copied layout, drawing, sections' and slash's handlers); GREEN 3 `686b377` (man/, a help count
corrected); GREEN 4 `3b6b58c` (NEWS, DIVERGENCE.md, contract, gap case); GREEN 5 `9e057a9` (the RED test's reading,
no jsonlite); REFACTOR 1 `b1c58b3` (the helpers, the copied files, DIVERGENCE.md); REFACTOR 2 `4b31671` (the four
own marks); close-out 1 `4352bea`;
close-out 2 (these notes, the receipt, the ledger). Pushed at close.
**Measured:** 208 drawings at 500 px (13 configs, 8 pedigrees, both styles, all seven marks): the zoom the same at
every width; ink 0.85-0.92 at 0.5, 1.06-1.15 at 1.5; ids under other ink in 4 of 16 drawings at 3 with the picked
outline (7 with 4 times; 2 at 1); kept dashes closing (the DZ gaps 1.2 units at 3, none at 5); every canvas stroke
of one redraw at 1 and 3; kinship2's `plot(lwd =)` through `par()`; Pedixplorer's `lwd` and its legend. The
prototype: fidelity 540 of 600 in its first form, 600 of 600 in its final; 8 tests, 196 expectations; 6 mutants
each failing 1-4 tests. Final, on `4b31671`: suite 80 files, 994 tests, 0 failed, 0 skipped, 0 warnings; lint 0;
roxygen stable; covr 41 of 41 new and changed statements, the package 98.47%; `R CMD check --as-cran` R16's NOTE
only; fidelity 600 of 600; drift 91/22/0, exit 0; the REFACTOR's 151 saved parts identical.
**Self-assessment: 7/10.**
+ Every pick and gate first time, from measured counts and a picture page; the prototype's fidelity failure (540 of
  600) caught and fixed before RED; the tests mutation-checked on 6 mutants; a browser test that records every
  canvas stroke; the REFACTOR proved on 151 saved parts; every DONE check run.
- Three of my errors reached Mark or a commit: the picker's genotyped-fill figures were in layout units (corrected
  and told before RED); GREEN 2's help said 7 of 16 from the wrong option's run (corrected in GREEN 3); RED's test
  called `jsonlite::` (an `R CMD check` WARNING, a picker and a GREEN fix), with a 120-character line from an unread
  check. Process slips caught before a commit: the prototype's legend artefact, an edit script that stopped halfway,
  two `\s` one-liners, a probe's `par()` lint, a line rewrapped into another.
**Learnings:** the gaps plan's dragons 73-77. No `CLAUDE.md` row (over budget).
**Ledger:** `CHANGELOG.md` S63 entries (the session, the ruling, push 1).
