# Session Notes

**Purpose:** Continuity between sessions. Each session reads this first and writes to it before closing out.

**This file is transient — it is overwritten every session** (*"what's next, what traps?"*).
The cumulative, append-only record of *what was done, ever* lives in `CHANGELOG.md`; the commit SHA is the shared key.
At close-out, distill the durable outcome into a `CHANGELOG.md` entry — do not copy this handoff into it.

---

## ACTIVE TASK
**Task:** Phase 17, the CRAN submission (`docs/planning/cran-submission-plan.md`). 17a-17f2 DONE (S33-S41); the gap
phases G1-G17 run before 17g (R97, `docs/planning/gaps-and-shared-code-plan.md` section 5.1). G1-G13 DONE (S42-S59).
**G14 under way (R140, `docs/planning/standalone-pedigree-package-plan.md:292`):** four settings, each an argument
of `makePedigreeMatingLayout()` and a multiple of today's (1 = as before), one positive number with no upper limit,
one a session. **Session 1, the symbol size, DONE in S60** (`symbolSize`); **session 2, the text size, DONE in S61:**
`makePedigreeMatingLayout(textSize = 1)` gives every node `font.size` 14 times it (rounded, at least 1; no column at
14 px), the places and lines unchanged; above 14 px `drawPedigreeDiagram()` adds three invisible points (`__text_l_`,
`__text_r_`, `__text_b_`) at the outermost labels' ends (widths from R's Helvetica metrics, `.labelWidths()`); the
moved ids' room is `.idLabelDepth()` = 4 + 1.5 times the text size; the marks' words ("P", "ECT") and the twins'
labels keep their sizes (Mark's S61 picks). The REFACTOR made one check, `.checkPositiveNumber(x, name, caller)`.
**Next: G14 session 3 of 3, the column and row spacing and the line width** (R140's last: "then the spacing with the
line width"; gaps plan `:376`).
**Status:** READY. No work in progress; the tree is clean but `pedkindraw.Rproj` (Mark's). S61's commits are pushed
(Mark's standing pick, a memory).
**The orient picker:** G14's spacing and line width (recommended: R140's order; then G15-G17, 17g). Also READY: the
narrow legend (`methodology/BACKLOG.md:58`), the drawing vignette's measured trait (`:65`), the `smallPed` fixture
(`:88`), rewording `DIVERGENCE.md`'s older rows (`:40`), tests for full coverage (`:94`), and the "Ready, small"
items (`:150`-`:211`; name all seven in the last option, as S48-S61 did). NEEDS DECISION: a converted Pedixplorer
object's `avail` (`:71`); long names at the edges cut at the default text size (`:79`, new in S61).
**Session boundary:** R140's third session; it may need two (spacing; line width) if the measures say so: ask.
**Priority:** HIGH (G14's spacing and line width, then G15-G17 and 17g).

### What You Must Do
1. Orient; drift tool (expect **91 functions, 21 differ, 0 without a row**); nprcgenekeepr's log on the copied
   files, `git -C ../nprcgenekeepr log --oneline baef1e12c..HEAD -- $(grep -l 'Copied from nprcgenekeepr' R/*.R
   tests/testthat/*.R | xargs -n1 basename | sed 's#^#*/#')`: the same 4 commits (`4283e3502`, `a85311021`,
   `392dd347e`, `471589138`). nprcgenekeepr was at `3e06730c5`, tree clean, through all of S61.
2. Check S61's push: both workflows run. S56-S60's CI runs failed on Ubuntu R-devel only (Bioconductor's S4Vectors,
   in "setup-r-dependencies", before pedkindraw is checked; S60's run `44815278598`: the other four jobs `success`,
   Ubuntu release among them, which ran the browser tests); expect the same. Any other failure is real (the new
   browser test reads label boxes on Linux's fonts: S61 measured only on the Mac). The site must build.
3. **Spacing and line width, measure before the pre-RED picker (Learnings 17-21; dragons 60, 61, 64, 66):**
   (a) one setting or two: R140's option was "Column and row spacing" -- ask whether columns and rows are one
   number or two (`columnSpacing`, `rowSpacing`?), with pictures. (b) where the spacing goes: `xScale <- 120L`,
   `yScale <- 150L` (`R/makePedigreeDiagramData.R:2315`-`:2316`, used at `:2510`-`:2511`); the rectilinear
   waypoints and the collision repair (`.resolveEdgeNodeCollisions()`, whose help at `:3196` says it reads the
   row geometry, "never a hardcoded yScale") must be measured at each value, both styles, rhesus375 included; grep
   the layout for other numbers in units that assume 120/150 (the jog 1 unit below the symbols, the sibship bars'
   and drops' heights, arc roundness). Measure whether the curved arcs and jogs change, as dragon 60 did for size.
   (c) the line width: which lines -- the edges (vis.js's 1, the consanguinity mating's 4 at `:2546`), the
   symbols' outlines (1; genotyped 4, `R/genotypedMark.R:20`), the marks' strokes (`ctx.lineWidth` 1-3 in
   `R/affectedConditions.R:172`, `R/deceasedSlash.R:57`, `R/evaluatedMark.R:49`, `R/infertileMark.R:138`,
   `R/miscarriageMark.R:181`, `R/probandMark.R:71`), the legend's lines; Pedixplorer's `lwd` is "the line width of
   the segments, arcs and polygons" (results only, R11: measure what it changes with `ped_to_plotdf()`). Picker
   question: which follow. (d) the text size meets the spacing: a 10-character id is 118 units wide at text 1.4
   and 165 at 2, the columns 120 apart; draw text 2 with column spacing 1.4 for the picker's pictures. (e) each
   default leaving 600 of 600 (no column or argument effect at 1). (f) `.checkPositiveNumber()` for each new
   argument (`R/symbolSize.R:36`). Draw candidates with S61's looks harness (scratch scripts below) at 500 px in both
   styles with all seven marks on, at symbolSize 0.6/1.6 and textSize 1.4 too.
4. RED, GREEN, REFACTOR by the gates. DONE (plan section 5.1, "Every G phase", `:340`): suite 0 failed, WARN 0;
   lint 0; roxygen stable; covr on every new statement; `R CMD check --as-cran` R16's NOTE only; a NEWS bullet; the
   contract's section 4; `DIVERGENCE.md` sentences in copied code and the drift tool exit 0; fidelity 600 of 600.
   When G14 is DONE, mark it so in the four plans' places, the roadmap and the backlog (R140: 3 sessions).

### Gotchas
- **A `git archive` copy runs its own renv** (dragon 67, new): delete each copy's `.Rprofile` before running in it,
  or run Rscript from outside with the copy's path (S61 lost a first check run to it).
- **A Monitor on `pgrep -f <script>` never ends** (dragon 68, new): it matches itself; wait for the background
  task's notification.
- **A hand-typed `gen` can draw another pedigree** (dragon 66, new): take a fixture's `gen` from `findGeneration()`
  and check which side sets the zoom before choosing a browser floor (S61's first deep check measured nothing).
- **vis.js's `labelModule.size.top` is not where a label is drawn** (dragon 64, new): its top is `size + 0.5 f + 4`
  below the centre, each line `f` tall; read sides and width from `labelModule.size`.
- **The Write tool writes `é` as the character**: S61's test had a literal "e acute" until the non-ASCII grep;
  write escapes through a script, and grep each new file for non-ASCII.
- **A replacement that ends mid-line leaves broken lines** (S60's gotcha, again in S61's first REFACTOR draft, caught
  by `diff` before the repository): replace whole paragraphs; check `awk 'length > 80'` on R files.
- **Browser floors** (dragon 62): S61's are 8 px at the edges (prototype 15.9-16.8, mutants -30 to 3.7) and 18 px
  under a deep drawing's moved bottom id (prototype 23, mutant 9-14): set each from a prototype and its mutant.
- **Carried:** set a size in the layout, not after it (60); vis.js's fit never zooms past 1 (61); `expect_warning()`
  returns the condition (Learning 10); `.markRoom()` copies fields onto its points (compare with `expect_equal()` on
  `names(nodes)`); `rm` with bare variables is refused (write `"${SP:?}/${d:?}"`); a background check's processes
  are named `R` (56); the canvas reaches 5.5 px below the widget's box (52); `font.vadjust` moves a label but not its
  box (54); roxygen pairs asterisks (48); Pedixplorer writes `Rplots.pdf` (41: probes from the scratchpad, and
  `rm -f Rplots.pdf` after `tools/gapCases.R`); the 5-file cap splits GREEN (code; man/; records); the ratchet's
  suite gate times out at 300 s (name it unmeasured with the suite by hand); `CLAUDE.md` is over its budget
  (learnings go to the plans' dragons); `pedkindraw.Rproj` untracked, Mark's; the stale pedkindraw 0.0.1 in renv's
  library answers `pedkindraw::` calls from outside `load_all()` (`BACKLOG.md:162`).
- **Ledger sizes:** `CHANGELOG.md` 133,229 B of its 196,608 B threshold; `HANDOFFS.md` 97,899 B.
- **Scratch scripts** (`/private/tmp/claude-501/-Users-rmsharp-Development-pedkindraw/c46a5382-eb31-448f-9928-dd101e5e1c1a/scratchpad/g14t/`,
  may be gone): `looks.R` (each setting at 500 px, 7 pedigrees, both styles, all seven marks; ids green against a
  drawing with them transparent; label sides and bottoms against the canvas and widget; options switch the
  prototype's variants), `analyse.R` (its summary), `box.R` (vis.js's label box per font size, lines, shape),
  `deep.R` (a deep pedigree, bottom row setting the zoom), `marks.R` (marks' words drawn red, counted on other
  ink), `names.R`, `refs.R`, `pics/page.html` (the picture page), `apply_red.py`, `apply_green.py`,
  `apply_green2.py`, `apply_refactor.py`, `closeout1.py`, `mutate.py`, `probe_browser.R`, `runtests.R`,
  `run_checks2.sh` (suite, check, fidelity, covr side by side; remove `.Rprofile` from the copies first),
  `covr_new4.R`, `refactor_save2.R`.
- **Times** (S61's): suite about 5 min (78 files, 978 tests); `run_checks2.sh` about 9-10 min; the looks harness
  84 drawings per process in about 35 min, three processes side by side (252 in all; one process alone ran faster).

### Key files
- `docs/planning/gaps-and-shared-code-plan.md`: `:376` (G14's row), `:340` ("Every G phase"), `:746`-`:771`
  (dragons 63-68; 64-68 new).
- `docs/planning/standalone-pedigree-package-plan.md`: `:85` (Next), `:292` (R140), `:1252` (G14 session 2);
  `docs/planning/cran-submission-plan.md:668` (G14 session 2).
- `docs/research/pedkindraw-gaps-2026-11-18.md:219` (B5: what kinship2 and Pedixplorer take).
- S61's work: `R/textSize.R` (`.fullTextSize` `:19`, `.textPixels()` `:28`, `.nodeTextPixels()` `:39`,
  `.idLabelDepth()` `:56`, `.labelCharWidths` `:68`, `.labelWidths()` `:88`, `.textSizeRoom()` `:121`);
  `R/symbolSize.R:36` (`.checkPositiveNumber()`); `R/infertileMark.R:190`, `R/miscarriageMark.R:235` (the depth);
  `R/makePedigreeDiagramData.R` (`:562` the reserved prefixes, `:1999` `@param textSize`, `:2119` the arguments,
  `:2131`-`:2132` the checks, `:2315`-`:2316` `xScale` and `yScale`, the spacing session's, `:2546` the
  consanguinity width, `:2708` the font size); `R/drawPedigreeDiagram.R` (`:148` the help, `:386` the text points,
  `:469` `width = 0.28`, `:481` `stepY = 60L`); `tests/testthat/test_textSize.R` (10 tests; the browser test
  `:330`); `tools/gapCases.R:611` (the text-size probes).
- `methodology/BACKLOG.md:26` (G14-G17), `:40`, `:58`, `:65`, `:71`, `:79` (new), `:88`, `:94`, `:150`-`:211`.

### How You Will Be Evaluated
The user rates every session's handoff. Your handoff will be scored on:
1. Was the ACTIVE TASK block sufficient to orient the next session?
2. Were key files listed with line numbers?
3. Were gotchas and traps flagged?
4. Was the "what's next" actionable and specific?

---

## Session History

*Session history accumulates below this line. Newest session at the top.*
*S1-S60's entries were removed in S3-S61 (FM #28): their durable records are the receipts in `HANDOFFS.md` and the
entries in `CHANGELOG.md`.*

### Session 60 Handoff Evaluation (by Session 61)
**Score: 9/10.**
- **What helped:** the measure-first list (a)-(f) was the session's plan item for item: (a) a `font.size` column only
  when the text is not 14 px held and kept 600 of 600; (b) the label box at several sizes gave vis.js's rule (top
  `0.5 f + 4` below the shape, `f` a line), which became `.idLabelDepth()`; (c) "points at estimated label ends
  against other ways, and the cost in nodes on rhesus375" framed the first picker question exactly (3 points, every
  animal's 1,090, a re-fit); (d) the "P" and "ECT" became the second picker question; (e) and (f) went into the
  picker's text. The scratch scripts were there and were adapted (`looks.R`, `labels.R`, `refs.R`, `compose.R`,
  `run_checks.sh`, `covr_new2.R`, `refactor_save.R`, the mutation idea). Drift 91/21/0, the 4 nprcgenekeepr
  commits, the CI prediction (R-devel's S4Vectors only, the other four `success`), the gotchas (`expect_warning()`,
  `rm` with `${SP:?}`, replacements ending mid-line, which recurred and was caught) all held.
- **What was missing:** that S60's scratch copies had no `.Rprofile` (S61's had one, and three of four checks did
  not run the first time: dragon 67).
- **What was wrong:** dragon 63 counted `.symbolSizeRoom()`'s 25 below the centre as the text's allowance; it is
  the full-size symbol's corner, and stays (noted under dragon 63).
- **ROI:** high.

### What Session 61 Did
**Deliverable:** Phase G14's second session DONE: the text size, `makePedigreeMatingLayout(textSize = 1)`, with room
kept for the outermost labels and the moved ids' room by vis.js's own label depth; the REFACTOR made one check for
each size setting.
**Started:** 2026-11-20 14:55 CST · **Model:** Claude Opus 5.5 · **Mark's picks (each first time):** "G14: text size
(Recommended)" (orient); "Points at outer label ends (Recommended)" and "Keep their sizes (Recommended)" (pre-RED,
with a picture page opened for him); "Yes, proceed to RED"; "Yes, proceed to GREEN"; "Yes, REFACTOR (Recommended)".
No corrections.
**Commits:** claim `21d4807`; RED `4026c5f`; GREEN 1 `8fac8aa` (code, help); GREEN 1b `e1e1794` (man/); GREEN 2
`10d1a45` (NEWS, DIVERGENCE.md, contract, gap case); REFACTOR `68b7bc1`; close-out 1 `5ce69fd` (plans, roadmap,
backlog, R140, dragons 64-68); close-out 2 (these notes, the receipt, the ledger). Pushed at close.
**Measured:** vis.js's label box at 7-28 px, 1-2 lines, four shapes and three sizes (its rule); 132 label widths
against Helvetica's (within 0.05 px); 252 drawings at 500 px (7 pedigrees, both styles, all seven marks, 18
settings: no room, extreme points, every animal's points, a re-fit; the moved ids' room fixed or scaled; the marks'
words following or not; symbol 0.6 and 1.6 with text 1.4); a deep pedigree whose bottom row sets the zoom (120
drawings); the marks' words drawn red and counted on other ink (98 drawings); rhesus375's layout at text 1.4 (places
and lines unchanged; 3 against 1,090 points); kinship2's and Pedixplorer's cex (results only); long names at the
edges at text 1 (cut 4.1 and 6.3 px: a backlog item). The prototype: 10 tests, 277 expectations, and every DONE
check before RED; RED 10 of 10 failing with 0 warnings; the browser test failing on 3 mutants. Final: suite on
`68b7bc1` 78 files, 978 tests, 0 failed, 0 skipped, 0 warnings (also on `10d1a45`); lint 0; roxygen stable; covr 43
of 43 new at GREEN and 41 of 41 new and changed after the REFACTOR, the package 98.46%; `R CMD check --as-cran` on
`10d1a45` and `68b7bc1` R16's NOTE only; fidelity 600 of 600 on both; drift 91/21/0; the REFACTOR's 74 saved parts
identical.
**Self-assessment: 8/10.**
+ Every pick and gate first time, from a picture page and measured counts; the prototype through every check before
  RED and applied by script, byte-identical at each step; the browser test mutation-checked, which exposed a fixture
  that measured nothing (a hand-typed `gen`); the REFACTOR proved on 74 saved parts; a defect found and recorded
  with numbers, not fixed (long names at the edges).
- Process slips, each caught before a commit but each costing time: three Monitors that could never end (`pgrep`
  matching itself); the copies' `.Rprofile` (a check run lost); the hand-typed `gen` (a browser floor first set on a
  drawing that did not test it); the Write tool's literal "e acute"; the REFACTOR's first draft splitting lines; a
  stray `git init` in a scratch copy.
**Learnings:** the gaps plan's dragons 64-68. No `CLAUDE.md` row (over budget).
**Ledger:** `CHANGELOG.md` S61 entries (the session, the ruling, push 1).
