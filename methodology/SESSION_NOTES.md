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
evaluated; infertile; miscarriage). **Marks 1-3 of 6 DONE**: genotyped (S54, R134: a 4 px outline), carrier (S55,
R135: a black dot) and **proband with consultand (S56, R136)**: `makePedigreeMatingLayout()` reads the columns
`proband` and `consultand` with R134's values and stop, and stops on an animal marked both (as Pedixplorer does);
the nodes get `proband` and `consultand` fields (each only with its column); the drawing draws a black arrow rising
at 30 degrees to just outside the lower-left corner of each such symbol, "P" left of a proband's tail
(`.probandArrowHandler()`, passed in only when some node is marked, `arrows = TRUE`), adds an invisible size-0
point `__mark_<id>` per marked node so vis.js's fit takes the arrows in (`.probandArrowRoom()`; `__mark_` is now a
reserved prefix), and the legend gains rows "Proband" and "Consultand" (the arrow pictures), 45 px each. The hover
text says "Proband:" and "Consultand:" "Yes/No/Unknown"; `NA` is unmarked. The REFACTOR added `.markLegendRow()`
(`R/markColumns.R`), the legend's picture row for any mark a script draws.
**Next: G13's mark 4, evaluated** (`docs/planning/gaps-and-shared-code-plan.md:374`, the G13 row; R133 at
`docs/planning/standalone-pedigree-package-plan.md:279`, R136 at `:282`). Measured S54 from Pedixplorer 1.8.0's
`ped_to_plotdf()` results: evaluated is "*" at the upper right of the symbol. pedkindraw has nothing for it: a "*"
is a script, as the slash, the dot and the arrow are, added only when some node has the mark (dragon 44).
**Status:** READY. No work in progress; the tree is clean but `pedkindraw.Rproj` (Mark's).
**The orient picker:** G13's evaluated mark (recommended: R133's order). Also READY: the narrow legend
(`methodology/BACKLOG.md:55`), the drawing vignette's measured trait (`:62`), the `smallPed` fixture (`:76`),
rewording `DIVERGENCE.md`'s older rows (`:37`), tests for full coverage (`:82`), and the "Ready, small" items (name
all seven in the last option, as S48-S56 did). NEEDS DECISION: a converted Pedixplorer object's `avail` (`:68`).
**Session boundary:** one kind of mark (evaluated). Close out at a clean phase boundary.
**Priority:** HIGH (G13's last three marks, G14-G17 and 17g follow).

### What You Must Do
1. Orient; drift tool (expect **91 functions, 21 differ, 0 without a row**: G13 changes only functions that
   already have rows; the drift tool does not watch constants such as `.reservedIdPrefixes`); nprcgenekeepr's log
   on the copied files, `git -C ../nprcgenekeepr log --oneline baef1e12c..HEAD -- $(grep -l 'Copied from
   nprcgenekeepr' R/*.R tests/testthat/*.R | xargs -n1 basename | sed 's#^#*/#')`: the same 4 commits
   (`4283e3502`, `a85311021`, `392dd347e`, `471589138`). nprcgenekeepr was at `3e06730c5`, tree clean, through all
   of S56.
2. Check S56's push: both workflows run (`R/`, `man/`, `tests/`, `NEWS.md`, `tools/` changed). S55's run
   `44657424903` failed on Ubuntu R-devel only (Bioconductor's S4Vectors 0.50.3 not building, before pedkindraw
   was checked), the other four jobs `success`; expect the same. Any other failure is real. The site build must
   succeed.
3. **Evaluated, measure before the pre-RED picker (Learnings 17-21):** (a) the column: Pedixplorer's name is
   `evaluated` ("documented evaluation available", `Ped-class`); read the 13 compared CSVs' first lines (dragon 40;
   S56 found neither proband nor consultand); `asPedFrame()` keeps it when it holds anything besides `FALSE`
   (`R/asPedFrame.R:315`, `.asPedFramePxFields`). (b) Pedixplorer's help and `ped_to_plotdf()` results: the "*"'s
   place against the box (S56's `px_proband.R` prints every element a column adds; its box is 0.1565 wide and
   0.0616 tall, x0/y0 the top centre), its size (`cex`), `NA`, 1/0 and "TRUE" (Pedixplorer warned "NAs introduced
   by coercion" for text proband), with proband/consultand on the same animal. (c) Looks in headless Chrome at
   500 px (S56's `looks.R`, with the picture wait): **the upper right is where the deceased slash overhangs** (its
   top end at 0.86 of the size per axis times the shape's outline factor, `R/deceasedSlash.R:32`), and where a
   mating line from the right side and a sibship drop meet some symbols; count pixels drawn over ink with the
   alpha (dragon 45) and locate any (dragon 47); 1- and 10-character ids; a triangle and a star. (d) **The canvas
   edge**: a "*" outside the node's box at the top row or the rightmost animal can be cut off (dragon 46); measure
   it as S56's `clip.R` did, and reuse or generalize `.probandArrowRoom()` (`R/probandMark.R:113`) for another
   corner. (e) The legend row via `.markLegendRow()` (`R/markColumns.R:109`) and its 45 px. (f) The hover line.
   (g) `.diagramAfterDrawing()` (`R/affectedConditions.R:266`) would gain a third mark argument; with three, a
   REFACTOR to a list of handlers is the candidate (dragon 44's suggestion), but tests call `carrier = TRUE` and
   `arrows = TRUE` by name.
4. RED, GREEN, REFACTOR by the gates. DONE (plan section 5.1, "Every G phase", `:339`): suite 0 failed, WARN 0; lint
   0; roxygen stable; covr on every new statement; `R CMD check --as-cran` R16's NOTE only; a NEWS bullet; the
   contract's section 4; `DIVERGENCE.md` sentences in copied code and the drift tool exit 0; fidelity 600 of 600.

### Gotchas
- **The shared pixel reader cannot tell black from nothing** (dragon 45, new): `read()` drops the alpha and an empty
  canvas spot reads `0,0,0`, the same as a black mark. S56's draft passed "no arrow" by accident. Count near-black
  pixels with the alpha in a small box (`tests/testthat/test_probandMark.R:521`, the `dark()` helper in its JS).
- **vis.js fits its view to the nodes only** (dragon 46, new): a mark drawn outside a node's box is cut off at the
  edge of a small drawing (the proband's "P" 10 px outside a six-animal drawing); `.probandArrowRoom()` adds an
  invisible size-0 node at the mark's far end. An evaluated "*" at the upper right may need the same at the top or
  right edge.
- **Locate a changed pixel before calling it an overlap** (dragon 47, new): 6-14 "overlap" pixels on deceased
  animals were the slash's anti-aliasing changing between page loads, not the arrow.
- **Mutation-check a browser test**: S56's `mutate.R` replaced `.probandArrowRoom()` and `.probandArrowHandler()`
  in the namespace (`assignInNamespace()`) and the browser test failed 2 and 8 expectations; do the same for the
  next mark's reading.
- **RED needs every test failing**: S56's "as before without the mark" test passed at HEAD until it also required
  the new fields to be all `FALSE`; run the draft at HEAD before the gate.
- **Lint on new code**: `scalar_in_linter` flags `x %in% TRUE` (write `!is.na(x) & x`), `implicit_integer_linter`
  flags `30` and `180` (write `30.0`); a test of `rbind()`-ed nodes meets new row names and the direct style's
  integer `y` turned double (`expect_equal()` after `rownames(x) <- NULL`).
- **`methodology/CHANGELOG.md` is at 196,371 B of its 196,608 B budget** after S56's entries: S57's will cross it.
  Run `python3 methodology/methodology_trim.py --file methodology/CHANGELOG.md --check` at close-out and archive as
  it says, in a commit of its own (`HANDOFFS.md` is at 175,386 B).
- **The NSGC nomenclature paper** (Bennett et al. 1995, PMC1801187) sits behind a bot check for the web-fetch
  agent; S56 stated only what Pedixplorer was measured to do.
- **Carried:** a mark drawn by a script is passed in only when some node has it (dragon 44); hold the canvas height
  when counting a mark's pixels (dragon 43); delete a scratch copy's `.Rprofile` for the fidelity tool, not
  `--no-init-file` (dragon 42); `Rscript -e '...'` loses backslashes (put such R code in a script); lint after
  every header reflow; the 5-file cap splits GREEN (code; man/; records); read a legend outline from inside
  (dragon 39); check a new column's name against the compared CSVs (dragon 40); Pedixplorer's plotting writes
  `Rplots.pdf` (dragon 41); run a single test file from the repository's root; `rm -rf "${S:?}/${d:?}"`; the
  ratchet's suite gate times out (300 s; name it unmeasured with the suite by hand); the Write and Edit tools write
  U+2265 as itself (dragon 35); a legend label measured at 500 px with the widget's width set (dragon 36); copies
  from a commit, one per running check (dragon 38, FM #29); compute every expected value on a prototype before RED
  (Learning 18); run the prototype through suite, check, lint and fidelity before the RED gate (dragon 31);
  `CLAUDE.md` is over its budget (learnings go to the plans' dragons); `pedkindraw.Rproj` untracked, Mark's.
- **Scratch scripts** (`/private/tmp/claude-501/-Users-rmsharp-Development-pedkindraw/118e43e7-9ef6-490a-9ab2-0528264dad42/scratchpad/g13p/`,
  may be gone): `px_proband.R` (Pedixplorer's elements), `looks.R` (looks and overlap counts), `clip.R` (the canvas
  edge), `legend.R` (legend pictures), `apply_green.py` (the prototype as one edit script), `run_one.R`,
  `run_checks.sh` (suite, check, fidelity side by side; `run_g.sh` adds covr), `covr_new.R`, `refactor_save.R`.
- **Times** (S56's measures, runs side by side): the suite about 5 min (73 files, 906 tests); fidelity 3.4 min;
  `R CMD build` and `check --as-cran` about 5 min; covr (`type = "tests"`) about 8 min; `test_probandMark.R` 5 s;
  the gap case 3.9 s; the look harness about 30 s; the drift tool 1 s.

### Key files
- `docs/planning/gaps-and-shared-code-plan.md`: `:374` (G13's row, S54-S56's measures), `:339` ("Every G phase"),
  `:657`-`:673` (dragons 45-47, new).
- `docs/planning/standalone-pedigree-package-plan.md`: `:74`-`:80` (status, Next), `:279`-`:282` (R133-R136),
  `:1183` (G13 mark 3); `docs/planning/cran-submission-plan.md:633` (Done G13 mark 3).
- S56's work: `R/probandMark.R` (`.probandArrow` `:27`, `.probandArrowTail()` `:37`, `.probandArrowHandler()` `:54`,
  `.probandArrowRoom()` `:113`, `.probandLegendImage()` `:160`, `.checkProbandConsultand()` `:200`);
  `R/markColumns.R:109` (`.markLegendRow()`); the layout in `R/makePedigreeDiagramData.R` (`:526` the reserved
  prefixes, `:2071` the reads and the both-stop, `:2114` the empty layout, `:2285` the hover lines, `:2540` the node
  fields); `R/drawPedigreeDiagram.R:274` (`hasProband`, the rows, `hasArrow`, the points at `:281`);
  `R/affectedConditions.R:266` (`.diagramAfterDrawing()`'s `arrows`); `tests/testthat/test_probandMark.R` (16 tests;
  the points `:368`, the browser test `:521`); `tools/gapCases.R:398` (the proband probes in `markings`).
- How pedkindraw draws on a symbol: `R/deceasedSlash.R` (the slash handler `:46`, its legend picture `:84`);
  `R/carrierMark.R` (the dot `:35`); `R/affectedConditions.R` (the section painter `:129`).
- `methodology/BACKLOG.md:26` (G13-G17), `:37`, `:55`, `:62`, `:68`, `:76`, `:82`, `:136`-`:209` (Ready, small).

### How You Will Be Evaluated
The user rates every session's handoff. Your handoff will be scored on:
1. Was the ACTIVE TASK block sufficient to orient the next session?
2. Were key files listed with line numbers?
3. Were gotchas and traps flagged?
4. Was the "what's next" actionable and specific?

---

## Session History

*Session history accumulates below this line. Newest session at the top.*
*S1-S55's entries were removed in S3-S56 (FM #28): their durable records are the receipts in `HANDOFFS.md` and the
entries in `CHANGELOG.md`.*

### What Session 57 Did
**Deliverable:** Phase G13, mark 4 of 6: evaluated (IN PROGRESS)
**Started:** 2026-11-19 21:46 CST · **Model:** Claude Opus 5.5 · **Mark's pick:** "G13: evaluated mark (Recommended)"
(orient)
**Status:** Session claimed. Measuring before the pre-RED picker (the column's name against the compared CSVs and
`asPedFrame()`, Pedixplorer's "*" place and size, NA and text, the looks in headless Chrome against the deceased
slash, a mating line and a sibship drop, the canvas edge, the legend row, the hover line).
**Ledger:** `CHANGELOG: pending` -- the claim commit's `CHANGELOG.md` entry says (in progress); Phase 3F records the
rest.

### Session 55 Handoff Evaluation (by Session 56)
**Score: 9/10.**
- **What helped:** the measure-first list (a)-(e) was the session's plan item for item: the 13 compared CSVs held
  neither column, `asPedFrame()` kept both as stated, Pedixplorer's arrow, the "P", `NA`, both marks on one animal
  and several probands were each measured, and the legend question became a picker option. Dragon 44 (a script
  only when some node has the mark) shaped `arrows = FALSE`; dragon 42 (delete the `.Rprofile`) and the 5-file cap
  split were followed and held. S55's scratch scripts (`px_carrier.R`, `proto_carrier.R`, `apply_green.py`,
  `covr_new.R`, `refactor_save.R`, `run_one.R`) were still there and were adapted for this session. Every location
  was right, as was the CI prediction (R-devel's S4Vectors only), drift 91/21/0 and the 4 nprcgenekeepr commits.
- **What was missing:** that a mark drawn outside the symbol can be cut off at the canvas edge (vis.js fits to the
  nodes only); that the shared pixel reader reads an empty spot as black (dragon 39 warned only of blurred
  outlines); that the deceased slash's overhang is exactly where a 45-degree arrow would lie.
- **What was wrong:** nothing.
- **ROI:** high.

### What Session 56 Did
**Deliverable:** Phase G13's third mark DONE: columns `proband` and `consultand`, a black arrow at the lower left of
each such symbol with "P" beside a proband's, invisible points that keep the arrows in the view, the hover lines,
two legend rows and the stop on an animal marked both (R136); the legend's picture row shared as `.markLegendRow()`.
**Started:** 2026-11-19 20:02 CST · **Model:** Claude Opus 5.5 · **Mark's picks (each first time):** "G13: proband
mark (Recommended)" (orient); "Flatter arrow (Recommended)", "Widen the view (Recommended)", "Stop, as Pedixplorer
(Recommended)", "Two rows, arrow pictures (Recommended)" (pre-RED); "Yes, proceed to RED"; "Yes, proceed to GREEN";
"Yes, REFACTOR (Recommended)". No corrections.
**Commits:** claim `da7e079`; RED `31faecd`; GREEN 1 `646255e` (code, help); GREEN 1b `1100d4e` (man/); GREEN 2
`3931583` (NEWS, DIVERGENCE.md, contract, gap case); REFACTOR `ff7913f` (`.markLegendRow()`); close-out 1 `3b223bd`
(plans, roadmap, backlog, R136, dragons 45-47); close-out 2 (these notes, the receipt, the ledger). All pushed at
close.
**Measured:** Pedixplorer 1.8.0 (help and `ped_to_plotdf()` results): an arrow to the box's lower-left corner from
0.8 of its width left and 0.4 of its height below, "P" (cex 0.8) left of the tail, `NA` read as `FALSE`, an animal
both proband and consultand refused, an unaffected proband warned, four probands drawn, no legend row, 2 read as
`FALSE`, text warned. Looks in headless Chrome at 500 px on six animals (ids of 1 and 10 characters): the 30-degree
arrow 46-92 pixels per animal and 0 over ink; Pedixplorer's 45 degrees 47-82, 4-5 px over a slash end and 2-12 px
over 10-character labels on 5 of 6; the leftmost "P" 10 px outside the canvas, 19 px inside with the points (zoom
0.800 to 0.734; a three-animal drawing keeps 1.0 and moves 13-18 px); legend pictures 23 and 16 dark pixels, a
small circle with the arrow 3 and 4. `asPedFrame()` keeps both columns (C and D; all `FALSE` leaves none). The
prototype: the draft 392 of 392 passing, 16 of 16 failing at HEAD; its suite (73 files, 906 tests), check (R16's
NOTE), lint (0 after a fix of 7) and fidelity (600 of 600) clean before RED; the browser test failing without the
points (2) and without the arrow script (8). Final: suite on `ff7913f` 73 files, 906 tests, 0 failed, 0 skipped,
0 warnings; lint 0; roxygen stable; covr 82 of 82 new statements at GREEN, 84 of 84 new and moved after the
REFACTOR (`R/markColumns.R` 27 of 27), the package 98.33%; `R CMD check --as-cran` on `1100d4e` and `ff7913f` 1
NOTE (R16's); fidelity on both 600 of 600, no new set-aside; drift 91/21/0; the REFACTOR's 88 saved results
byte-identical.
**Self-assessment: 8/10.**
+ Every pick and gate first time, each option with measured counts (two looks with overlap counts, the canvas edge
  with and without the points, two legend pictures); the prototype through suite, check, lint and fidelity before
  RED, applied to the repository by one script and proved identical by `cmp`; the browser test mutation-checked;
  the REFACTOR proved on 88 saved results; the whole mark, records and REFACTOR in one session.
- Slips that cost reruns: the first prototype had 7 lints, found after the background checks had started (stopped
  and restarted, about 2 min); two draft-test bugs found on the prototype (row names and the reader's missing
  alpha); one draft test passed at HEAD until strengthened before RED; 6-14 "overlap" pixels took a debug run to
  show they were the slash's anti-aliasing; the NSGC paper could not be read (a bot check), so no claim about the
  human nomenclature was made.
**Learnings:** the gaps plan's dragons 45-47; no `CLAUDE.md` row (over budget).
**Ledger:** `CHANGELOG.md` S56 entries (the session, the ruling, push 1).
