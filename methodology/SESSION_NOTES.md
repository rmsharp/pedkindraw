# Session Notes

**Purpose:** Continuity between sessions. Each session reads this first and writes to it before closing out.

**This file is transient — it is overwritten every session** (*"what's next, what traps?"*).
The cumulative, append-only record of *what was done, ever* lives in `CHANGELOG.md`; the commit SHA is the shared key.
At close-out, distill the durable outcome into a `CHANGELOG.md` entry — do not copy this handoff into it.

---

## ACTIVE TASK
**Task:** Phase 17, the CRAN submission (`docs/planning/cran-submission-plan.md`). 17a-17f2 DONE (S33-S41); the gap
phases G1-G17 run before 17g (R97, `docs/planning/gaps-and-shared-code-plan.md` section 5.1). G1-G12 DONE (S42-S53).
**G13 under way**: Pedixplorer's marks, one kind a session (R133: genotyped; carrier; proband with consultand;
evaluated; infertile; miscarriage). **Marks 1 and 2 of 6 DONE**: genotyped (S54, R134: a 4 px outline) and
**carrier (S55, R135)**: `makePedigreeMatingLayout()` reads a column `carrier` with R134's values and stop; a
carrier's node gets `carrier` TRUE (every other node FALSE); the drawing paints a black dot at the symbol's centre,
radius 0.24 of the node's size, after the deceased slash (`.carrierDotHandler()`, passed in only when some node is a
carrier's); the hover text says "Carrier: Yes/No/Unknown"; the legend gains a row "Carrier" (a picture of a circle
with the dot) before "Deceased", and 45 px. `NA` is unmarked. The REFACTOR moved the column reader and the
node-to-animal lookup into `R/markColumns.R` (`.readMarkColumn(ped, column, caller)`, `.markOddValues()`,
`.markedNodes()`) for the four marks left.
**Next: G13's mark 3, proband with consultand** (`docs/planning/gaps-and-shared-code-plan.md:373`, the G13 row; R133
at `docs/planning/standalone-pedigree-package-plan.md:277`, R135 at `:279`). Measured S54 from Pedixplorer 1.8.0's
`ped_to_plotdf()` results: proband an arrow from the lower left of the symbol and the text "P" beside it; consultand
the arrow alone. pedkindraw has neither: an arrow is a script, as the slash and the carrier's dot are, added only
when some node has the mark (dragon 44).
**Status:** READY. No work in progress; the tree is clean but `pedkindraw.Rproj` (Mark's).
**The orient picker:** G13's proband with consultand (recommended: R133's order). Also READY: the narrow legend
(`methodology/BACKLOG.md:55`), the drawing vignette's measured trait (`:62`), the `smallPed` fixture (`:76`),
rewording `DIVERGENCE.md`'s older rows (`:37`), tests for full coverage (`:82`), and the "Ready, small" items (name
all seven in the last option, as S48-S55 did). NEEDS DECISION: a converted Pedixplorer object's `avail` (`:68`).
**Session boundary:** one kind of mark (proband with consultand). Close out at a clean phase boundary.
**Priority:** HIGH (G13's last three marks, G14-G17 and 17g follow).

### What You Must Do
1. Orient; drift tool (expect **91 functions, 21 differ, 0 without a row**: G13 changes only functions that
   already have rows); nprcgenekeepr's log on the copied files, `git -C ../nprcgenekeepr log --oneline
   baef1e12c..HEAD -- $(grep -l 'Copied from nprcgenekeepr' R/*.R tests/testthat/*.R | xargs -n1 basename | sed
   's#^#*/#')`: the same 4 commits (`4283e3502`, `a85311021`, `392dd347e`, `471589138`). nprcgenekeepr was at
   `3e06730c5`, tree clean, through all of S55.
2. Check S55's push: both workflows run (`R/`, `man/`, `tests/`, `NEWS.md`, `tools/` changed). S54's run
   `44642239812` failed on Ubuntu R-devel only (Bioconductor's S4Vectors 0.50.3 again), the other four jobs
   `success`; expect the same. Any other failure is real. The site build must succeed.
3. **Proband and consultand, measure before the pre-RED picker (Learnings 17-21):** (a) the columns: Pedixplorer's
   names are `proband` and `consultand`; none of the 13 compared CSVs holds either (S55 read all 13 first lines:
   samplePed holds `affected`, `avail`, `famid`); `asPedFrame()` keeps each when it holds anything besides `FALSE`
   (`R/asPedFrame.R`, `.asPedFramePxFields`). (b) Pedixplorer's help and `ped_to_plotdf()` results for both: the
   arrow's start, end, angle and length against the box, the "P"'s place and size, `NA`, an animal both proband and
   consultand, more than one proband (results only, dragon 6; run from the scratchpad, dragon 41). (c) Looks in
   headless Chrome at 500 px with pixel counts against the unmarked drawing (S55's harness: hold the height, read
   the legend in its own pass, dragon 43): where the arrow sits against the id label under the symbol, the mating
   line at the symbol's side and the sibship line above; the "P" against the label; colour and greyscale; one and
   three conditions; a triangle (unknown sex). (d) The legend: one row each ("Proband", "Consultand") or one row
   for the arrow, and their 45 px. (e) The hover lines. The readers and node lookup exist (`R/markColumns.R`).
4. RED, GREEN, REFACTOR by the gates. DONE (plan section 5.1, "Every G phase", `:338`): suite 0 failed, WARN 0; lint
   0; roxygen stable; covr on every new statement; `R CMD check --as-cran` R16's NOTE only; a NEWS bullet; the
   contract's section 4; `DIVERGENCE.md` sentences in copied code and the drift tool exit 0; fidelity 600 of 600.

### Gotchas
- **A mark drawn by a script is passed in only when some node has it** (dragon 44, new): `.diagramAfterDrawing()`'s
  text is in every drawing the fidelity tool compares; S55 gave it `carrier = FALSE`, and a proband arrow needs the
  same form (an argument per mark, or a list of marks; a REFACTOR may generalize once there are two).
- **Hold the canvas height when counting a mark's pixels** (dragon 43, new): a legend row's 45 px shifted every
  symbol and changed 150-240 anti-aliased pixels around unmarked animals; S55's
  `/private/tmp/claude-501/-Users-rmsharp-Development-pedkindraw/be895159-a5dc-4031-8178-fef7496da08c/scratchpad/g13c/proto_carrier.R`
  measures the diagram without the row and reads the legend in a second pass (the scratchpad may be gone).
- **Delete a scratch copy's `.Rprofile`; do not use `Rscript --no-init-file` for the fidelity tool** (dragon 42,
  new): S55's first prototype run stopped in nprcgenekeepr's child ("openxlsx is required"). For one test file,
  `Rscript --no-init-file` with renv's library on `R_LIBS` works.
- **`Rscript -e '...'` loses backslashes** (`"\\s"` arrived as `\s` and stopped): put R code with regular
  expressions or `\\+` in a script file.
- **Reflowing a comment block by string replace joined lines twice** in S55's REFACTOR; `lint_package()` caught it.
  Run lint after every header edit, before the commit.
- **Pedixplorer's dot is about 0.14 of its box** (read from its PNG; an SVG parse and a pixel walk both failed): its
  marks are small, so measure each look at pedkindraw's size, not Pedixplorer's.
- **The 5-file cap splits GREEN**: S55's GREEN touched 5 R files, so man/ went in GREEN 1b; records in GREEN 2.
- **Carried:** read a legend outline from inside (dragon 39); check a new column's name against the compared CSVs
  (dragon 40); Pedixplorer's plotting writes `Rplots.pdf` (dragon 41); run a single test file from the repository's
  root (from `tests/testthat` renv does not load); a browser test's reader pushes "none" for a missing legend row;
  `rm -rf "${S:?}/${d:?}"`; chromote's timeout on the object; text "1"/"0" in a mark column stop (numbers read); the
  ratchet's suite gate times out (300 s; name it unmeasured with the suite by hand); the Write and Edit tools write
  U+2265 as itself (dragon 35); a legend label measured at 500 px with the widget's width set (dragon 36); copies
  from a commit, one per running check (dragon 38, FM #29); compute every expected value on a prototype before RED
  (Learning 18); run the prototype through suite, check, lint and fidelity before the RED gate (dragon 31);
  `CLAUDE.md` is over its budget (learnings go to the plans' dragons); `pedkindraw.Rproj` untracked, Mark's.
- **Times** (S55's measures, runs side by side): the suite 5-6 min (72 files, 890 tests); fidelity 3.5 min; `R CMD
  build` and `check --as-cran` about 5 min; covr (`type = "tests"`) about 8 min; `test_carrierMark.R` 4.6 s; the gap
  case 3.7 s; the look harness 26 s; the drift tool 1 s.

### Key files
- `docs/planning/gaps-and-shared-code-plan.md`: `:373` (G13's row, S54's and S55's measures), `:338` ("Every G
  phase"), `:642`-`:655` (dragons 42-44, new).
- `docs/planning/standalone-pedigree-package-plan.md`: `:76`-`:78` (status, Next), `:277`-`:279` (R133-R135),
  `:1170` (G13 mark 2); `docs/planning/cran-submission-plan.md` (Done G13 mark 2, after mark 1).
- S55's work: `R/carrierMark.R` (`.carrierDotRatio` `:23`, `.carrierDotHandler()` `:35`, `.carrierLegendImage()`
  `:66`); `R/markColumns.R` (`.readMarkColumn()` `:28`, `.markOddValues()` `:54`, `.markedNodes()` `:85`);
  `R/genotypedMark.R` (`.genotypedBorderWidths()` `:34`, now via `.markedNodes()`); the layout in
  `R/makePedigreeDiagramData.R` (grep `Phase G13`: `:2047` the carrier read, `:2089` the empty layout, `:2254` the
  hover line, `:2501` the node field); `R/drawPedigreeDiagram.R:252` (`hasCarrier`, the row after it);
  `R/affectedConditions.R:261` (`.diagramAfterDrawing()`, its `carrier` argument); `tests/testthat/test_carrierMark.R`
  (13 tests; the browser test at `:339` reads inside and outside each dot); `tools/gapCases.R:384` (the carrier
  probes in `markings`).
- How pedkindraw draws on a symbol: `R/deceasedSlash.R` (the slash handler `:46`, its legend picture `:84`);
  `R/affectedConditions.R` (the section painter `:127`, `.diagramHeight()` `:292`).
- `methodology/BACKLOG.md:26` (G13-G17), `:37`, `:55`, `:62`, `:68`, `:76`, `:82`, `:138`-`:199` (Ready, small).

### How You Will Be Evaluated
The user rates every session's handoff. Your handoff will be scored on:
1. Was the ACTIVE TASK block sufficient to orient the next session?
2. Were key files listed with line numbers?
3. Were gotchas and traps flagged?
4. Was the "what's next" actionable and specific?

---

## Session History

*Session history accumulates below this line. Newest session at the top.*
*S1-S54's entries were removed in S3-S55 (FM #28): their durable records are the receipts in `HANDOFFS.md` and the
entries in `CHANGELOG.md`.*

### Session 54 Handoff Evaluation (by Session 55)
**Score: 9/10.**
- **What helped:** the measure-first list (a)-(f) was the session's plan item for item: the 13 compared CSVs held no
  `carrier` as stated; Pedixplorer's point at the centre, its help and `NA` behaved as described; the looks were
  measured where the list said (pink fill, the sections' meeting point, under the slash); the legend picture
  followed `.deceasedLegendImage()` (`R/deceasedSlash.R:84`); the reader took the column's name as (f) suggested.
  Every code location was exact (`R/genotypedMark.R:34`, `R/deceasedSlash.R:46`, `R/affectedConditions.R:124`,
  `:255`, `:280`). S54's scratch scripts (`measure_border.R`, `proto_border.R`) were still in its scratchpad and
  were the model for S55's harness. The CI prediction held (R-devel's S4Vectors only), as did drift 91/21/0 and the
  4 nprcgenekeepr commits. Gotchas used: run from the root, the browser reader's "none", `${S:?}`, scripts from the
  scratchpad (Pedixplorer wrote `Rplots.pdf` there, not in the root).
- **What was missing:** that a legend row's 45 px corrupts a before/after pixel count (found when two unmarked animals
  read 189 and 240); that the copied `.diagramAfterDrawing()` is in every compared drawing, so a mark's script must
  be conditional; that Pedixplorer's point is only about 0.14 of its box, so the radius needed its own measure; that
  `asPedFrame()` already keeps `carrier`.
- **What was wrong:** nothing.
- **ROI:** high.

### What Session 55 Did
**Deliverable:** Phase G13's second mark DONE: a column `carrier`, a black dot at the centre of a carrier's symbol,
its hover line and a legend row (R135); the shared reader and node lookup moved to `R/markColumns.R`.
**Started:** 2026-11-19 18:26 CST · **Model:** Claude Opus 5.5 · **Mark's picks (each first time):** "G13: carrier
mark (Recommended)" (orient); "Black dot (Recommended)", "No mark (Recommended)" (pre-RED); "Yes, proceed to RED";
"Yes, proceed to GREEN"; "Yes, REFACTOR (Recommended)". No corrections.
**Commits:** claim `b9cd22c`; RED `307d328`; GREEN 1 `e661ebd` (code, help); GREEN 1b `e3ad11b` (man/); GREEN 2
`c685da5` (NEWS, DIVERGENCE.md, contract, gap case); REFACTOR `2726c82` (`R/markColumns.R`); close-out 1 `2f34931`
(plans, roadmap, backlog, R135, dragons 42-44); close-out 2 (these notes, the receipt, the ledger). All pushed at
close.
**Measured:** Pedixplorer 1.8.0 (help and `ped_to_plotdf()` results): a black point at the centre, black on an
affected fill too, nothing for `NA` or `FALSE`, no legend row, 1/0 read and 2 read as `NA`; its point about 0.14 of
its box. Looks in headless Chrome at 500 px (pixels changed per carrier, height held): a dot of radius 0.24 67-82 on
white, pink, the meeting point of three conditions' sections and under the slash, 65-82 in greyscale; 0.14 22-29;
0.32 123-141; a white ring 80-154, cutting the slash; a grey `NA` dot 68 on white, 28 in greyscale on a grey
section. `asPedFrame()` keeps a converted object's carriers (A and D marked; an all-`NA` field leaves no column).
The prototype: the draft 260 of 260 passing, 13 of 13 failing at HEAD for the missing feature; its suite (72 files,
890 tests), check (R16's NOTE), lint (0 after three fixes) and fidelity (600 of 600) clean before RED. Final: suite
on `2726c82` 72 files, 890 tests, 0 failed, 0 skipped, 0 warnings; lint 0; roxygen stable; covr 23 of 23 new
statements at GREEN, 45 of 45 new and moved after the REFACTOR (`R/markColumns.R` 26 of 26), the package 98.27%;
`R CMD check --as-cran` on `c685da5` and `2726c82` 1 NOTE (R16's); fidelity on `e3ad11b` and `2726c82` 600 of 600,
no new set-aside; drift 91/21/0; the REFACTOR's 86 saved results byte-identical.
**Self-assessment: 8/10.**
+ Every pick and gate first time, each picker option with measured counts (five looks in colour and greyscale, the
  `NA` look on white and on a grey section); the prototype through suite, check, lint and fidelity before RED, and
  the edit script proved to reproduce it byte for byte; the REFACTOR proved on 86 saved results; the whole mark,
  records and REFACTOR in one session; the reader generalized for the four marks left.
- Slips that cost reruns: the first pixel count compared drawings of different heights (caught by two unmarked
  animals reading non-zero); the first fidelity run used `--no-init-file` instead of dragon 37's deleted
  `.Rprofile` (4 min lost); three lints on the prototype (fixed before RED); `Rscript -e` ate backslashes twice;
  Pedixplorer's dot size took three tries (an SVG parse and a pixel walk failed; read from its picture); a header
  reflow joined lines twice before lint passed.
**Learnings:** the gaps plan's dragons 42-44; no `CLAUDE.md` row (over budget).
**Ledger:** `CHANGELOG.md` S55 entries (the session, the ruling, push 1).
