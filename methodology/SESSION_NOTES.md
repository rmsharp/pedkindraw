# Session Notes

**Purpose:** Continuity between sessions. Each session reads this first and writes to it before closing out.

**This file is transient — it is overwritten every session** (*"what's next, what traps?"*).
The cumulative, append-only record of *what was done, ever* lives in `CHANGELOG.md`; the commit SHA is the shared key.
At close-out, distill the durable outcome into a `CHANGELOG.md` entry — do not copy this handoff into it.

---

## ACTIVE TASK
**Task:** Phase 17, the CRAN submission (`docs/planning/cran-submission-plan.md`). 17a-17f2 DONE (S33-S41); the gap
phases G1-G17 run before 17g (R97, `docs/planning/gaps-and-shared-code-plan.md` section 5.1). G1-G13 DONE (S42-S59).
**G14 under way (R140, `docs/planning/standalone-pedigree-package-plan.md:294`):** four settings, each an argument
of `makePedigreeMatingLayout()` and a multiple of today's (1 = as before), one positive number with no upper limit,
one a session; **four sessions since Mark's S62 pick** (R140 said three). Session 1, the symbol size, DONE in S60;
session 2, the text size, DONE in S61; **session 3, the column and row spacing, DONE in S62:**
`makePedigreeMatingLayout(columnSpacing = 1, rowSpacing = 1)` place the animals of a row 120 times the first apart
and the rows 150 times the second, rounded to a whole unit and at least 1 (`R/spacing.R`'s constants;
`.wholeMultiple()`, `R/symbolSize.R:58`, the REFACTOR's one helper for the three settings). Mark's S62 picks: two
settings; large text does not widen the columns by itself; the line width a session of its own.
**Next: G14 session 4 of 4, the line width** (R140's last setting; gaps plan `:377`).
**Status:** READY. No work in progress; the tree is clean but `pedkindraw.Rproj` (Mark's). S62's commits are pushed
(Mark's standing pick, a memory).
**The orient picker:** G14's line width (recommended: R140's order; then G15-G17, 17g). Also READY: the narrow
legend (`methodology/BACKLOG.md:59`), the drawing vignette's measured trait (`:66`), the `smallPed` fixture (`:89`),
rewording `DIVERGENCE.md`'s older rows (`:41`), tests for full coverage (`:95`), and the "Ready, small" items
(`:151`-`:212`, seven: `:151`, `:163`, `:170`, `:179`, `:189`, `:206`, `:212`; name all seven in the last option, as
S48-S62 did). NEEDS DECISION: a converted Pedixplorer object's `avail` (`:72`); long names at the edges cut at the
default text size (`:80`).
**Session boundary:** one session, G14's last; when it is DONE, mark G14 DONE in the four plans' places, the roadmap
and the backlog (R140: 4 sessions).
**Priority:** HIGH (G14's line width, then G15-G17 and 17g).

### What You Must Do
1. Orient; drift tool (expect **91 functions, 21 differ, 0 without a row**); nprcgenekeepr's log on the copied
   files, `git -C ../nprcgenekeepr log --oneline baef1e12c..HEAD -- $(grep -l 'Copied from nprcgenekeepr' R/*.R
   tests/testthat/*.R | xargs -n1 basename | sed 's#^#*/#')`: the same 4 commits (`4283e3502`, `a85311021`,
   `392dd347e`, `471589138`). nprcgenekeepr was at `3e06730c5`, tree clean, through all of S62.
2. Check S62's push: both workflows run. Expected, not measured: CI fails on Ubuntu R-devel only (Bioconductor's
   S4Vectors in "setup-r-dependencies", before pedkindraw is checked, as on S56-S61's pushes), the other four jobs
   `success`; read Ubuntu release's testthat summary (S61's push: FAIL 0, WARN 0, SKIP 2 math-library tests, PASS
   13,391), since the new browser test reads label boxes on Linux's fonts. The site must build.
3. **The line width, measured before the pre-RED picker (Learnings 17-21; dragons 60, 61, 64):** (a) which lines
   take it. S62's inventory: the edges (vis.js's width 1, unset; `visEdges(smooth = FALSE)` at
   `R/drawPedigreeDiagram.R:417` sets none); the consanguinity mating lines' 4 (`R/makePedigreeDiagramData.R:2580`,
   carried onto the doglegs at `:2955`); the symbols' outlines (vis.js's borderWidth 1; genotyped 4,
   `R/genotypedMark.R:20`, `.genotypedBorderWidths()` `:34`, the legend's `:399`); the marks' canvas strokes
   (`ctx.lineWidth`: `R/affectedConditions.R:172` 1, `R/deceasedSlash.R:57` 3, `R/evaluatedMark.R:49` 2,
   `R/infertileMark.R:138` 2, `R/miscarriageMark.R:181` 2, `R/probandMark.R:71` 2); the legend's pictures (SVG
   `stroke-width` at `R/affectedConditions.R:242`, `:246`, `R/carrierMark.R:70`, `R/deceasedSlash.R:89`, `:91`,
   `R/evaluatedMark.R:107`, `R/infertileMark.R:206`, `R/miscarriageMark.R:271`, `:275`, `R/probandMark.R:150`)
   and its line rows (the twins' dash patterns at `R/drawPedigreeDiagram.R:237`, in pixels). Picker question:
   which follow (all lines and outlines, as Pedixplorer's `lwd`; the legend too or not; the dash patterns).
   (b) Pedixplorer's `lwd`, measured S62 (scratch `pdx/lwd.R`): it multiplies every line, 158 of
   `ped_to_plotdf()`'s 262 rows (all symbol outlines, segments, its 2.5-wide ones to 5, arrows, arcs; text and
   points unchanged). kinship2's `plot.pedigree()` has no `lwd` (its `...`: measure what it passes on). (c) the
   genotyped outline must stay told apart from an ordinary one (4 to 1 today): measure at 2 and 3. (d) whether
   whole pixels (`.wholeMultiple()`) or any width: vis.js and the canvas take fractional widths; measure 0.5.
   (e) what thick lines do to vis.js's fit and the edges' room (dragon 57), and to the marks drawn beside the
   symbols. (f) 600 of 600 at the default: no new column at 1, as `textSize`'s `font.size` (`:2742`).
   (g) `.checkPositiveNumber()` for the argument (`R/symbolSize.R:38`). Draw the candidates with S62's looks harness
   at 500 px in both styles with all seven marks on, also at symbolSize 1.6 and columnSpacing 0.75.
4. RED, GREEN, REFACTOR by the gates. DONE (plan section 5.1, "Every G phase", `:341`): suite 0 failed, WARN 0;
   lint 0; roxygen stable; covr on every new statement; `R CMD check --as-cran` R16's NOTE only; a NEWS bullet; the
   contract's section 4; `DIVERGENCE.md` sentences in copied code and the drift tool exit 0; fidelity 600 of 600.
   Then G14 DONE in the plans, the roadmap and the backlog.

### Gotchas
- **`rm` of a path built from variables is refused** unless each is guarded: write `"${SP:?}"/"${d:?}"/.Rprofile`,
  never `$SP/$d/.Rprofile` (S62 slipped once; nothing ran, the command was rewritten).
- **An unquoted heredoc rewrites a script's backslashes** (dragon 69, new): write scripts with the Write tool, or
  `<<'EOF'`. The same bit an R one-liner in single quotes holding `"\\s"`: use `[[:space:]]`.
- **A `DIVERGENCE.md` anchor at the end of a commit list matches other rows** (dragon 70, new): find a row by its
  first cell (`editRow()` in S62's `apply_green2.py`).
- **lintr refuses `par()`, even to read** (dragon 71, new): `grconvertX()`/`grconvertY()` instead.
- **A step's depth grows with the row gap** (dragon 72, new): `max(0.15 x gap, largest symbol + 1)`; a fixed
  expected depth holds only while the symbol's floor binds.
- **covr's line numbers move with every edit**: re-grep the new statements' lines on the tree measured (S62's first
  REFACTOR tally missed two).
- **A `cd` into `methodology/` persists** (to run `quality_ratchet.py --run`): run it as `(cd methodology && ...)`.
- **Carried:** a `git archive` copy runs its own renv, delete its `.Rprofile` (67); a Monitor on `pgrep -f` never
  ends (68); take a fixture's `gen` from `findGeneration()` (66); `labelModule.size.top` is not where a label is
  drawn (64); set a geometry setting in the layout (60); vis.js's fit never zooms past 1 (61); `expect_warning()`
  returns the condition (Learning 10); the Write tool writes accented letters as characters (grep new files for
  non-ASCII); a replacement ending mid-line breaks lines (check `awk 'length > 80'`); browser floors from a
  prototype and its mutant (62); Pedixplorer writes `Rplots.pdf` (41: probes from the scratchpad, `rm -f
  Rplots.pdf` after `tools/gapCases.R`); the 5-file cap splits GREEN (code; man/; records); the ratchet's suite
  gate times out at 300 s (name it unmeasured with the suite by hand); `CLAUDE.md` is over its budget (learnings go
  to the plans' dragons); `pedkindraw.Rproj` untracked, Mark's; the stale pedkindraw 0.0.1 in renv's library
  (`BACKLOG.md:163`).
- **Ledger sizes:** `CHANGELOG.md` about 137 KB of its 196,608 B threshold; `HANDOFFS.md` about 100 KB.
- **Scratch scripts** (`/private/tmp/claude-501/-Users-rmsharp-Development-pedkindraw/c6497c58-66b9-41d6-a90d-709b0403b9b7/scratchpad/g14s/`,
  may be gone): `cases.R` (S61's 7 pedigrees and `withMarks()`, shared), `looks.R` (each config at 500 px, both
  styles, all seven marks: zoom, symbol and text px, label room at the sides, id pairs overlapping and their least
  gap, ids over other ink; configs `C(s, t, cs, rs)`; add a line width there), `analyse.R`, `spacing.R` (R only:
  what a setting does to every place, waypoint, edge and arc against the default), `small.R`, `probe.R` (expected
  values for the tests), `compose.py` (the picture page, crops each drawing left of its legend), `pdx/lwd.R`,
  `pdx/k2shape.R`, `runtests.R`, `mutrun.R` (one test file on a mutant copy), `run_checks.sh` (suite, check,
  fidelity, covr side by side on `<prefix>_*` copies), `refactor_save.R`, `apply_green.py`, `apply_green2.py`,
  `apply_refactor.py`, `closeout1.py`.
- **Times** (S62's): suite about 5 min (79 files, 986 tests); `run_checks.sh` about 10 min; the looks harness 182
  drawings in about 25 min in three processes; the R-only `spacing.R` 2 min.

### Key files
- `docs/planning/gaps-and-shared-code-plan.md`: `:377` (G14's row), `:341` ("Every G phase"), `:747`-`:787`
  (dragons 63-72; 69-72 new).
- `docs/planning/standalone-pedigree-package-plan.md`: `:87` (Next), `:294` (R140), `:1270` (G14 session 3);
  `docs/planning/cran-submission-plan.md:675` (G14 session 3).
- `docs/research/pedkindraw-gaps-2026-11-18.md:219` (B5: what kinship2 and Pedixplorer take).
- S62's work: `R/spacing.R` (`.fullColumnUnits` `:18`, `.fullRowUnits` `:25`); `R/symbolSize.R` (`.checkPositiveNumber()`
  `:38`, `.wholeMultiple()` `:58`, `.symbolUnits()` `:70`); `R/makePedigreeDiagramData.R` (`:2021` `@param
  columnSpacing`, `:2033` `@param rowSpacing`, `:2162` the checks, `:2349`-`:2350` `xScale` and `yScale`, `:2580` the
  consanguinity width, `:2742` the font size); `tests/testthat/test_spacing.R` (8 tests; the browser test `:241`);
  `tools/gapCases.R` (the spacing probes at the end of the style case).
- The line width's places: listed in What You Must Do, item 3 (a).
- `methodology/BACKLOG.md:26` (G14-G17), `:41`, `:59`, `:66`, `:72`, `:80`, `:89`, `:95`, `:151`-`:212`.

### How You Will Be Evaluated
The user rates every session's handoff. Your handoff will be scored on:
1. Was the ACTIVE TASK block sufficient to orient the next session?
2. Were key files listed with line numbers?
3. Were gotchas and traps flagged?
4. Was the "what's next" actionable and specific?

---

## Session History

*Session history accumulates below this line. Newest session at the top.*
*S1-S61's entries were removed in S3-S62 (FM #28): their durable records are the receipts in `HANDOFFS.md` and the
entries in `CHANGELOG.md`.*

### What Session 63 Did
**Deliverable:** Phase G14 session 4 of 4, the line width (IN PROGRESS; R140's last setting;
`docs/planning/gaps-and-shared-code-plan.md:377`; `methodology/BACKLOG.md:26`)
**Started:** 2026-11-20 21:52 CST · **Model:** Claude Opus 5.5 · **Mark's pick:** "G14: line width (Recommended)"
(orient)
**Status:** Session claimed. Measuring before the pre-RED picker (which lines follow the setting: the edges, the
consanguinity lines, the outlines and the genotyped outline, the marks' strokes, the legend; Pedixplorer's `lwd`,
results only; the genotyped outline told apart; whole pixels or any width; thick lines and vis.js's fit; 600 of
600 at the default).
**Ledger:** `CHANGELOG: pending` -- the claim commit's `CHANGELOG.md` entry says (in progress); Phase 3F records the
rest.

### Session 61 Handoff Evaluation (by Session 62)
**Score: 9/10.**
- **What helped:** the measure-first list (a)-(f) was the session's plan: (a) one setting or two became the first
  picker question; (b) `xScale`/`yScale` at `:2315`-`:2316`, used at `:2510`-`:2511`, were exactly where the change
  went, and the repair's help ("never a hardcoded yScale") held when measured; (c) the line-width inventory (the
  consanguinity 4, the genotyped 4, the six marks' `ctx.lineWidth` lines, the legend, Pedixplorer's `lwd` through
  `ped_to_plotdf()`) was right line for line and framed the scope picker that split it off; (d) text 2 against
  columns 120 apart became the second picker question; (e) and (f) held. The scratch scripts (`looks.R`,
  `analyse.R`, `runtests.R`, `run_checks2.sh`) were there and were adapted. Drift 91/21/0, the 4 nprcgenekeepr
  commits and the CI prediction (R-devel only) held; S61's browser test was confirmed run on Linux.
- **What was missing:** that S60 had prototyped the spacing (options `g14.x`/`g14.y`, named in S61's `looks.R`
  header) and that the prototype was gone; the step depth's rule (0.15 of the gap to the nearest row of lines, or
  the symbol + 1).
- **What was wrong:** "the jog 1 unit below the symbols" holds only while the symbol's floor binds (27 units, not
  26, at row spacing 3; dragon 72).
- **ROI:** high.

### What Session 62 Did
**Deliverable:** Phase G14's third session DONE: the column and row spacing,
`makePedigreeMatingLayout(columnSpacing = 1, rowSpacing = 1)`; the REFACTOR made one whole-unit multiple for the
three settings; the line width split off as G14's fourth session (Mark's pick).
**Started:** 2026-11-20 18:13 CST · **Model:** Claude Opus 5.5 · **Mark's picks (each first time):** "G14: spacing +
line width (Recommended)" (orient); "Two: columns and rows (Recommended)", "No, the user widens them (Recommended)"
and "Spacing now, line width next (Recommended)" (pre-RED, with a picture page opened for him); "Yes, proceed to
RED"; "Yes, proceed to GREEN"; "Yes, REFACTOR (Recommended)". No corrections.
**Commits:** claim `eadf96b`; RED `83cbc71`; GREEN 1 `ed76a4a` (code, help); GREEN 1b `685374a` (man/); GREEN 2
`85c5ae9` (NEWS, DIVERGENCE.md, contract, gap case); REFACTOR `059bfbf`; close-out 1 `251e2ea` (plans, roadmap,
backlog, R140, dragons 69-72); close-out 2 (these notes, the receipt, the ledger). Pushed at close.
**Measured:** in R, every place, waypoint, edge and arc at 13 spacings against the default (7 pedigrees, smallPed,
rhesus375, both styles: 234 layouts; places exact, rectilinear steps and rhesus375's links worked out anew); small
spacings (centres 120 apart, the repair's warnings unchanged to 0.1); 182 drawings at 500 px (13 configs, 7
pedigrees, both styles, all seven marks: room at the sides, id pairs overlapping, ids over ink); one setting
against sizes 1/1.4; kinship2's distances on three page shapes; Pedixplorer's `lwd` in `ped_to_plotdf()`. The
prototype: 8 tests, 245 expectations, and the fidelity check before RED; 4 mutants each failing 2-5 tests. Final:
suite on `059bfbf` 79 files, 986 tests, 0 failed, 0 skipped, 0 warnings (also on `85c5ae9`; on the RED commit
exactly the 8 new tests failing); lint 0; roxygen stable; covr 5 of 5 new at GREEN and 7 of 7 new and changed
after the REFACTOR, the package 98.46%; `R CMD check --as-cran` on `85c5ae9` and `059bfbf` R16's NOTE only;
fidelity 600 of 600 on both; drift 91/21/0, exit 0; the REFACTOR's 102 saved parts identical.
**Self-assessment: 8/10.**
+ Every pick and gate first time, from measured counts and a picture page; the scope question asked with a line-by-
  line inventory, not a guess; the prototype applied by script and byte-identical at each step; the tests
  mutation-checked; the REFACTOR proved on 102 saved parts; every expected value computed first (a rounded literal
  that missed by 0.004 units was caught on the prototype, not in RED).
- Process slips, each caught before a commit: an unguarded `rm` refused by the safety check (the gotcha was in the
  handoff); GREEN 2's `DIVERGENCE.md` anchor matching two rows; a heredoc that broke a script's `"\n"`; a
  parenthesis slip and two `par()` lints in the gap probe; RED's failing-test listing broken by its own quoting
  (the counts were read); a coverage tally on moved line numbers.
**Learnings:** the gaps plan's dragons 69-72. No `CLAUDE.md` row (over budget).
**Ledger:** `CHANGELOG.md` S62 entries (the session, the ruling, push 1).
