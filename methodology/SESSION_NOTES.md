# Session Notes

**Purpose:** Continuity between sessions. Each session reads this first and writes to it before closing out.

**This file is transient — it is overwritten every session** (*"what's next, what traps?"*).
The cumulative, append-only record of *what was done, ever* lives in `CHANGELOG.md`; the commit SHA is the shared key.
At close-out, distill the durable outcome into a `CHANGELOG.md` entry — do not copy this handoff into it.

---

## ACTIVE TASK
**Task:** Phase 17, the CRAN submission (`docs/planning/cran-submission-plan.md`). 17a-17f2 DONE (S33-S41); the gap
phases G1-G17 run before 17g (R97, `docs/planning/gaps-and-shared-code-plan.md` section 5.1). G1-G13 DONE (S42-S59).
**G14 under way (R140, `docs/planning/standalone-pedigree-package-plan.md:292`):** Mark's S60 picks: four settings,
each an argument of `makePedigreeMatingLayout()` and a multiple of today's (1 = as before), one positive number with
no upper limit: the symbol size, the text size, the column and row spacing, and the line width; none of B5's other
arguments (hatching, the legend's sizes, kinship2's layout settings); one setting a session. **Session 1 of 3, the
symbol size, DONE in S60:** `makePedigreeMatingLayout(symbolSize = 1)` gives each animal's and repeat node's `size`
25 times it (rounded, at least 1; the mating points keep 6), the rectilinear detours worked out from it;
`drawPedigreeDiagram()` moves the infertile and miscarriage ids in proportion (`.sizedIdDown()`) and, below full
size, adds two invisible points per animal at a full-size triangle's lower corners (`.symbolSizeRoom()`, prefix
`__size_`).
**Next: G14 session 2, the text size** (`textSize = 1`, a multiple of vis.js's 14 px, on the animals' ids and names).
**Status:** READY. No work in progress; the tree is clean but `pedkindraw.Rproj` (Mark's). S60's commits are pushed
(Mark's standing pick, a memory).
**The orient picker:** G14's text size (recommended: R140's order; then the spacing with the line width, G15-G17,
17g). Also READY: the narrow legend (`methodology/BACKLOG.md:58`), the drawing vignette's measured trait (`:65`), the
`smallPed` fixture (`:79`), rewording `DIVERGENCE.md`'s older rows (`:40`), tests for full coverage (`:85`), and the
"Ready, small" items (`:141`-`:202`; name all seven in the last option, as S48-S60 did). NEEDS DECISION: a converted
Pedixplorer object's `avail` (`:71`).
**Session boundary:** one setting a session (R140); close out at a clean phase boundary.
**Priority:** HIGH (G14's text size, then its spacing and line width, then G15-G17 and 17g).

### What You Must Do
1. Orient; drift tool (expect **91 functions, 21 differ, 0 without a row**); nprcgenekeepr's log on the copied
   files, `git -C ../nprcgenekeepr log --oneline baef1e12c..HEAD -- $(grep -l 'Copied from nprcgenekeepr' R/*.R
   tests/testthat/*.R | xargs -n1 basename | sed 's#^#*/#')`: the same 4 commits (`4283e3502`, `a85311021`,
   `392dd347e`, `471589138`). nprcgenekeepr was at `3e06730c5`, tree clean, through all of S60.
2. Check S60's push: both workflows run. S56-S59's CI runs failed on Ubuntu R-devel only (Bioconductor's S4Vectors
   "unable to load R code" while installing dependencies, before pedkindraw is checked; S59's run `44789024082`:
   the other four jobs `success`); expect the same. Any other failure is real. The site must build.
3. **The text size, measure before the pre-RED picker (Learnings 17-21; dragons 57, 61, 63):** (a) where the size
   goes: a `font.size` column on the animals' and repeat nodes only when `textSize` is not 1 (S60's looks harness
   set it that way and vis.js drew it; at 1 no column, so 600 of 600); the names' lines share the label. (b) vis.js's
   label box at text 10/14/20 (`labelModule.size`: its top below the symbol and its height), to replace the 25-unit
   id allowance in `.infertileRoom()` (`R/infertileMark.R:182`), `.miscarriageRoom()` (`R/miscarriageMark.R:226`)
   and the 25 below the centre in `.symbolSizeRoom()` (`R/symbolSize.R:82`) with one rule (S60's prototype used
   11 plus the text size). (c) room for each label's ends: at text 20 the 10-character ids at the edges were cut
   8-10 px (`labels.R` read `labelModule.size` against the canvas): measure invisible points at estimated label
   ends (a width per character from vis.js's own label widths of 1-10 characters at several sizes) against
   other ways, and the cost in nodes on rhesus375. (d) whether the marks' own text follows it: the proband's "P"
   (`ctx.font = '12px arial'`, `R/probandMark.R:72`) and "ECT" (`.miscarriageMark$textSize`,
   `R/miscarriageMark.R:154`). (e) long ids meeting their neighbours at larger text (S60: sixLong 21 px over ink
   at 20 against 16 at 14, direct style). (f) kinship2's and Pedixplorer's `cex`, results only (R11): their symbol
   grows with `cex` (kinship2's `boxw` 0.239 / 0.365 / 0.529 of a neighbour's distance at 0.7 / 1 / 1.4), so say
   in the picker that pedkindraw's text size leaves the symbol alone. Draw each candidate in headless Chrome at 500
   px in both edge styles with all seven marks on and at `symbolSize` 0.6 and 1.6 too (the two settings meet).
4. RED, GREEN, REFACTOR by the gates. DONE (plan section 5.1, "Every G phase", `:340`): suite 0 failed, WARN 0;
   lint 0; roxygen stable; covr on every new statement; `R CMD check --as-cran` R16's NOTE only; a NEWS bullet; the
   contract's section 4; `DIVERGENCE.md` sentences in copied code and the drift tool exit 0; fidelity 600 of 600.

### Gotchas
- **Set a size in the layout, not after it** (dragon 60, new): the rectilinear detours read each node's `size`.
  Text size probably does not change the layout's geometry (labels are not in the detours); measure it both ways.
- **vis.js's fit never zooms past 1** (dragon 61, new): a small drawing shows a size setting whole, a wide one only
  its proportions; read the zoom beside each measure.
- **Give a moved label's browser check a floor** (dragon 62, new): S60's first "id below the bar" passed a mutant
  0.34 units below; the floor is 4 units.
- **The 25-unit id allowance is the text's** (dragon 63, new): see What You Must Do 3(b).
- **`expect_warning()` returns the condition** (Learning 10, again): S60's draft `result <- if (...)
  expect_warning(make(), ...)` would have kept the warning, not the layout; write `expect_warning(result <- make())`.
  The gate `tests-no-saved-expect-condition` greps only the `<- expect_` form.
- **`.markRoom()` copies its node's fields onto the point** (S60's drafts): the points carry the node's
  `font.vadjust`, add `color.border` when the nodes have none, and make `y` a double; compare the original rows
  with `expect_equal()` on `names(nodes)`, not `identical()` on the whole table.
- **`rm` with a bare variable is refused, and the whole command with it** (a fourth time in S60, though named):
  the refused command also held a heredoc writing a script, so neither ran. Write `rm -f "${SP:?}/${d:?}/x"` from
  the first try, and keep file writes out of commands that remove.
- **A replacement that ends mid-line leaves the rest of the line** (S60's help edits): two lint passes found lines
  of 83-104 characters; replace whole lines in an edit script.
- **Carried:** a background check's processes are named `R` (56); a smaller node tightens vis.js's fit (57); read
  an id's row from the side a mark's text is not on (58); count legend ink below 200 (59); the canvas reaches 5.5 px
  below the widget's box (52); `.markRoom()` empties `fertility` and `miscarriage` (53); `font.vadjust` moves a label
  but not its box (54); RED with 0 warnings; roxygen pairs asterisks (48); Pedixplorer writes `Rplots.pdf` (41: run
  probes from the scratchpad); the 5-file cap splits GREEN (code; man/; records); the ratchet's suite gate times
  out at 300 s (name it unmeasured with the suite by hand); `CLAUDE.md` is over its budget (learnings go to the
  plans' dragons); `pedkindraw.Rproj` untracked, Mark's.
- **Ledger sizes:** `HANDOFFS.md` was archived in S60's close-out (`methodology_trim.py`); `CHANGELOG.md` about 128
  KB of its 196,608 B threshold.
- **Scratch scripts** (`/private/tmp/claude-501/-Users-rmsharp-Development-pedkindraw/f51f1cfe-3827-4a0f-bdf5-7b4a4c760c27/scratchpad/g14/`,
  may be gone): `looks.R` (each setting drawn at 500 px, 7 pedigrees, both styles, all seven marks; ids green
  against a drawing with them transparent; zoom, on-screen symbol and text px, room; options `g14.s`, `g14.f`,
  `g14.x`, `g14.y` read by the `proto` copy), `labels.R` (label boxes against the canvas edges), `compose.R` (a
  picture page of the settings for Mark), `collide.R` (a size set in the layout or after it), `refs.R` (kinship2's
  and Pedixplorer's symbol and text at each value), `jogs.R`, `sanity.R`, `mutate.py` and `run_browser.R`
  (mutants), `run_checks.sh` (suite, check, fidelity and covr, each on its own copy), `covr_new.R` /
  `covr_new2.R`, `refactor_save.R`, `apply_red.py`, `apply_green.py`, `apply_refactor.py`, `closeout1.py`.
- **Times** (S60's): suite about 5 min (77 files, 968 tests); `run_checks.sh` (suite, check, fidelity, covr side
  by side) about 9 min; the looks harness about 6 s per setting, pedigree and style (154 in 16 min);
  `test_symbolSize.R` about 20 s.

### Key files
- `docs/planning/gaps-and-shared-code-plan.md`: `:376` (G14's row), `:340` ("Every G phase"), `:732`-`:751`
  (dragons 60-63, new).
- `docs/planning/standalone-pedigree-package-plan.md`: `:74`-`:90` (status; Next `:84`), `:292` (R140), `:1240`
  (G14 session 1); `docs/planning/cran-submission-plan.md:661` (G14 session 1).
- `docs/research/pedkindraw-gaps-2026-11-18.md:219` (B5: what kinship2 and Pedixplorer take).
- S60's work: `R/symbolSize.R` (`.fullSymbolSize` `:18`, `.checkSymbolSize()` `:30`, `.symbolUnits()` `:47`,
  `.sizedIdDown()` `:62`, `.symbolSizeRoom()` `:82`); `R/markColumns.R:253` (`.markRoom(down = )`);
  `R/infertileMark.R:182`, `R/miscarriageMark.R:226`; the layout in `R/makePedigreeDiagramData.R` (`:557` the
  reserved prefixes, `:1979` `@param symbolSize`, `:2096` the argument, `:2107` the check, `:2290` `xScale` and
  `yScale`, the spacing session's, `:2424` and `:2443` the sizes); `R/drawPedigreeDiagram.R` (`:140` the help,
  `:375` the size points, `:381` the last room, `:386` the legend's size 14, `:458` `width = 0.28`, `:470`
  `stepY = 60L`); `R/affectedConditions.R:329` (`.diagramHeight()`); `tests/testthat/test_symbolSize.R` (11 tests;
  the browser test `:289`); `tools/gapCases.R:520` (`style`; the size probes `:594`).
- `methodology/BACKLOG.md:26` (G14-G17), `:40`, `:58`, `:65`, `:71`, `:79`, `:85`, `:141`-`:202` (Ready, small).

### How You Will Be Evaluated
The user rates every session's handoff. Your handoff will be scored on:
1. Was the ACTIVE TASK block sufficient to orient the next session?
2. Were key files listed with line numbers?
3. Were gotchas and traps flagged?
4. Was the "what's next" actionable and specific?

---

## Session History

*Session history accumulates below this line. Newest session at the top.*
*S1-S59's entries were removed in S3-S60 (FM #28): their durable records are the receipts in `HANDOFFS.md` and the
entries in `CHANGELOG.md`.*

### Session 59 Handoff Evaluation (by Session 60)
**Score: 9/10.**
- **What helped:** the measure-first list (a)-(f) was the session's plan item for item: the gap case `style`, every
  fixed value with its line (`size = 25L` at `:2399` and `:2418`, `xScale`/`yScale` at `:2265`, the legend's 14,
  0.28 and 60, `.diagramHeight()` at `:329`, all held); "which function takes each setting, its default leaving
  600 of 600" framed the layout-or-drawing question that S60 measured; the room builders' fixed 25-unit allowance
  and dragon 57 predicted exactly what S60 found at symbol size 0.6 (long ids at the edges cut 4-5 px); hatching
  raised as an open question, which became a picker question; the split guidance (one setting a session) was
  Mark's pick. The scratch scripts were still there and were adapted (`mlooks.R` into `looks.R`, `finalpics.R` into
  `compose.R`, `covr_new2.R`, `run_checks.sh`, `refactor_save.R`, the mutation idea). Drift 91/21/0, the 4
  nprcgenekeepr commits, the CI prediction (R-devel's S4Vectors only), the times and the ledger sizes held.
- **What was missing:** that a size must be known when the layout is made (the rectilinear detours read it); that
  vis.js's fit never zooms past 1. Neither was knowable before measuring.
- **What was wrong:** nothing.
- **ROI:** high.

### What Session 60 Did
**Deliverable:** Phase G14's first session DONE: four settings picked (R140), and the first, the symbols' size,
built: `makePedigreeMatingLayout(symbolSize = 1)`, the drawing's moved ids in proportion and a full-size symbol's
room below full size; the REFACTOR shared the scaled id move.
**Started:** 2026-11-20 12:25 CST · **Model:** Claude Opus 5.5 · **Mark's picks (each first time):** "G14: sizes and
spacing (Recommended)" (orient); "Symbol size, Text size, Column and row spacing, Line width", "None of these
(Recommended)", "Multiples, in the layout (Recommended)", "Symbol size now (Recommended)" (pre-RED, with two
pictures of the settings opened for him); "Yes, proceed to RED"; "Yes, proceed to GREEN"; "Yes, REFACTOR
(Recommended)". No corrections.
**Commits:** claim `3859c06`; RED `0c1c72e`; GREEN 1 `79c632c` (code, help); GREEN 1b `8646ba3` (man/); GREEN 2
`10af87a` (NEWS, DIVERGENCE.md, contract, gap case); REFACTOR `5a88e6b`; close-out 1 `7d7744e` (plans, roadmap,
backlog, R140, dragons 60-63); close-out 2 (these notes, the receipt, the ledger); the `HANDOFFS.md` archive.
Pushed at close.
**Measured:** in headless Chrome at 500 px on 7 pedigrees in both edge styles with all seven marks on, 11 settings
then 4 more (symbol 0.6/1.6/2.0/2.4, text 10/20, columns 0.67/1.5, rows 0.67/1.33, and two combined): only
proportions matter (zoom capped at 1); ids over other ink and room at the edges per setting; the moved ids fixed
against scaled (8-85 px against as today); label boxes against the canvas (cut 4-5 px at symbol 0.6, 8-10 at text
20); the symbol size set in the layout or after it on 5 fixture pedigrees (rectilinear differs, direct does not);
kinship2's and Pedixplorer's symbol and text at each value; greyscale of the colours. The prototype: 11 tests, 201
expectations, every check clean before RED; 11 of 11 failing at HEAD with 0 warnings; the browser test failing on
3 mutants (after a floor was added). Final: suite on `5a88e6b` 77 files, 968 tests, 0 failed, 0 skipped, 0
warnings (also on `10af87a`); lint 0; roxygen stable; covr 25 of 25 new at GREEN and 25 of 25 new and moved after
the REFACTOR, the package 98.45%; `R CMD check --as-cran` on `10af87a` and `5a88e6b` R16's NOTE only; fidelity 600
of 600 on both; drift 91/21/0; the REFACTOR's 25 saved parts byte-identical.
**Self-assessment: 8/10.**
+ Every pick and gate first time, the settings picked from two pictures and measured counts; the prototype through
  every check before RED, applied by script and proved byte-identical at each step; the browser test
  mutation-checked, which found a check too weak and gave it a floor; the REFACTOR proved on 25 saved parts.
- Three draft test expectations were wrong until run on the prototype (the points' `font.vadjust`, the column types,
  and an `expect_warning()` result kept, Learning 10's trap); an `rm` with bare variables refused a fourth time,
  taking a script write with it; two help edits split lines and needed a second and third lint; R140 was first
  inserted above R139.
**Learnings:** the gaps plan's dragons 60-63. No `CLAUDE.md` row (over budget).
**Ledger:** `CHANGELOG.md` S60 entries (the session, the ruling, the archive, push 1).
