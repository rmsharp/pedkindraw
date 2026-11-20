# Session Notes

**Purpose:** Continuity between sessions. Each session reads this first and writes to it before closing out.

**This file is transient — it is overwritten every session** (*"what's next, what traps?"*).
The cumulative, append-only record of *what was done, ever* lives in `CHANGELOG.md`; the commit SHA is the shared key.
At close-out, distill the durable outcome into a `CHANGELOG.md` entry — do not copy this handoff into it.

---

## ACTIVE TASK
**Task:** Phase 17, the CRAN submission (`docs/planning/cran-submission-plan.md`). 17a-17f2 DONE (S33-S41); the gap
phases G1-G17 run before 17g (R97, `docs/planning/gaps-and-shared-code-plan.md` section 5.1). G1-G13 DONE (S42-S59).
**G13 DONE in S59**: Pedixplorer's seven marks in six sessions (R133): genotyped (S54, R134), carrier (S55, R135),
proband with consultand (S56, R136), evaluated (S57, R137), infertile (S58, R138) and **miscarriage (S59, R139)**:
`makePedigreeMatingLayout()` reads a column `miscarriage` in Pedixplorer's values (SAB, TOP, ECT, none; without
spaces, any case; NA unmarked; anything else stops), stops on a miscarriage that is a sire or dam or has a fertility
mark, and gives the nodes a text field `miscarriage`; `drawPedigreeDiagram()` draws each as a triangle 0.6 the size
of its symbol (the full-size triangle is the Unknown sex), Pedixplorer's line across a termination's and an ectopic
pregnancy's and "ECT" under the latter's, the id moved 12 units into its row, no deceased slash, two invisible
points `__misc_l_<id>` / `__misc_r_<id>` at a full-size triangle's corners, and legend rows "Miscarriage",
"Termination" and "Ectopic". The REFACTOR shared `.readWordColumn()` and `.idsShown()` (`R/markColumns.R`).
**Next: Phase G14, B5's sizes and spacing** (`docs/planning/gaps-and-shared-code-plan.md:375`: "Symbol and text
sizes, and spacing, as arguments | `style`: each setting measured in headless Chrome; defaults unchanged (600 of
600) | which settings | 2-3" sessions). The gap: `docs/research/pedkindraw-gaps-2026-11-18.md:219` (B5): kinship2's
`plot.pedigree()` takes `cex`, `symbolsize`, `branch`, `packed`, `align`, `width`, `density`, `angle`;
Pedixplorer's `plot()` takes `cex`, `symbolsize`, `branch`, `packed`, `align`, `width`, `leg_cex`, `lwd`,
`label_cex`; G4 (S45, R111-R113) already closed B5's colours. **Not settled by any row:** hatching (`density`,
`angle`, for black-and-white printing) is in B5's title but not in G14's row; the pre-RED picker should say whether
it is in G14, later, or out.
**Status:** READY. No work in progress; the tree is clean but `pedkindraw.Rproj` (Mark's). S59's commits are pushed
(Mark's standing pick, a memory).
**The orient picker:** G14 (recommended: R97's order, the last M addition; then the three L additions, each with a
planning session first, then 17g). Also READY: the narrow legend (`methodology/BACKLOG.md:56`), the drawing
vignette's measured trait (`:63`), the `smallPed` fixture (`:77`), rewording `DIVERGENCE.md`'s older rows (`:38`),
tests for full coverage (`:83`), and the "Ready, small" items (`:139`-`:200`; name all seven in the last option, as
S48-S59 did). NEEDS DECISION: a converted Pedixplorer object's `avail` (`:69`).
**Session boundary:** G14 may be 2-3 sessions: its pre-RED picker should split it (one setting or one kind of
setting a session), and the session close out at a clean phase boundary.
**Priority:** HIGH (G14, then G15-G17 and 17g).

### What You Must Do
1. Orient; drift tool (expect **91 functions, 21 differ, 0 without a row**); nprcgenekeepr's log on the copied
   files, `git -C ../nprcgenekeepr log --oneline baef1e12c..HEAD -- $(grep -l 'Copied from nprcgenekeepr' R/*.R
   tests/testthat/*.R | xargs -n1 basename | sed 's#^#*/#')`: the same 4 commits (`4283e3502`, `a85311021`,
   `392dd347e`, `471589138`). nprcgenekeepr was at `3e06730c5`, tree clean, through all of S59.
2. Check S59's push: both workflows run. S56-S58's CI runs failed on Ubuntu R-devel only (Bioconductor's S4Vectors
   0.50.3 "lazy loading failed" while installing dependencies, before pedkindraw is checked; S58's run
   `44770828371`: the other four jobs `success`); expect the same. Any other failure is real. The site must build.
3. **G14, measure before the pre-RED picker (Learnings 17-21):** (a) run the gap case `style`
   (`Rscript tools/gapCases.R style`, `tools/gapCases.R:520`) for both packages' argument lists, and list what is
   fixed in pedkindraw today: the symbol size (`size = 25L`, `R/makePedigreeDiagramData.R:2399` and `:2418`), the
   label font (vis.js's default, 14), the columns and rows (`xScale <- 120L`, `yScale <- 150L`, `:2265`), the
   line widths, the legend (`legendNodes$size <- 14L`, `R/drawPedigreeDiagram.R:375`; `width = 0.28` `:447`,
   `stepY = 60L` `:459`; the canvas height, `.diagramHeight()`, `R/affectedConditions.R:329`). (b) Which function
   would take each setting (the layout's node table, which the fidelity tool compares, or the drawing), and that
   each default leaves all 600 results identical (dragon 44). (c) Each candidate setting drawn in headless Chrome
   at 500 px in both edge styles at a few values (a symbol size of 15/25/40, a text size of 10/14/20, spacing),
   with **all seven marks** on (dragons 49, 50): the marks scale with `n.size`, but `.infertileRoom()` and
   `.miscarriageRoom()` add a fixed 25 units for the id's box below a symbol (`R/infertileMark.R:175`,
   `R/miscarriageMark.R:220`), and a smaller symbol tightens vis.js's fit and cuts long ids at the edges (dragon 57,
   measured 6 px at 0.6). (d) Room to the widget's box (dragon 52). (e) What kinship2 and Pedixplorer do at each
   value, results only (R11). (f) The session split for the picker.
4. RED, GREEN, REFACTOR by the gates. DONE (plan section 5.1, "Every G phase", `:339`): suite 0 failed, WARN 0;
   lint 0; roxygen stable; covr on every new statement; `R CMD check --as-cran` R16's NOTE only; a NEWS bullet; the
   contract's section 4; `DIVERGENCE.md` sentences in copied code and the drift tool exit 0; fidelity 600 of 600.

### Gotchas
- **A background check's processes are named `R`, not `Rscript`** (dragon 56, new): `ps | grep Rscript` read 0
  while covr ran; S59 took it for dead and reran into the same copies and logs (one suite result lost, two covr runs
  in one copy). Wait for the task's notification; give every run its own copy (`git archive <commit>` into the
  scratchpad, `.Rprofile` deleted, dragon 42) and its own background task; never rerun into a log a run may hold.
- **A smaller node tightens vis.js's fit** (dragon 57, new): a size setting below 25 will cut long ids at the edges
  unless points keep the room, as `.miscarriageRoom()` does.
- **Read an id's row from the side a mark's text is not on** (dragon 58), **and count legend ink below luminance
  200** (dragon 59: the thin outline is lighter than 128 at the legend's zoom).
- **`rm` with a bare shell variable is refused** (a third time in S59, though the handoff named it): write
  `rm -rf "${G:?}/${d:?}"` from the first try.
- **A harness that calls a room builder on nodes without its field errors** (`.infertileRoom()` on nodes with no
  `fertility`): the drawing never does that; build the harness the way `drawPedigreeDiagram()` calls them.
- **Carried:** the canvas reaches 5.5 px below the widget's box (52); `.markRoom()` empties `fertility` and
  `miscarriage`, so a new text field needs the same (53); `font.vadjust` moves a label but not its box (54); check
  a harness's geometry against the reference's numbers (55); a control drawing keeps the fit with transparent, not
  blank, labels; mutation-check a browser test (S59: 7 mutants, `mutate.py`); RED with 0 warnings; roxygen's
  markdown pairs asterisks (48); measure overlap with the mark drawn red (49); the direct style's lines arrive from
  above (50); a mark's points need a reserved prefix (51); Pedixplorer's plotting writes `Rplots.pdf` (41: run
  probes from the scratchpad); `Rscript -e '...'` loses backslashes (put such R code in a script); the 5-file cap
  splits GREEN (code; man/; records); the ratchet's suite gate times out at 300 s (name it unmeasured with the
  suite by hand); `CLAUDE.md` is over its budget (learnings go to the plans' dragons); `pedkindraw.Rproj`
  untracked, Mark's.
- **Ledger sizes after S59's close-out 2:** `HANDOFFS.md` about 192.6 KB of its 196,608 B archive threshold, so
  S60's receipt (S59's was about 5 KB) crosses it: archive in S60's close-out with `methodology_trim.py`, as S57 did
  (it refuses while commits since the ledger's frontier are unrecorded; a ledger entry of its own); `CHANGELOG.md`
  about 125 KB.
- **Scratch scripts** (`/private/tmp/claude-501/-Users-rmsharp-Development-pedkindraw/b94ea4c9-674a-468b-bfb0-ec7811cf5b32/scratchpad/g13m/`,
  may be gone): `mlooks.R` (looks harness: mark red, ids green, a control with transparent ids; per-animal overlap,
  gaps, room to the widget's box and both edges), `finalpics.R` (a side-by-side picture of looks for Mark),
  `zoom.R` (zoomed crops), `tsize.R` (ink sizes without edges), `legendm.R` (legend rows and label ends),
  `px_misc.R`, `px_misc2.R` (Pedixplorer's elements, values and checks), `mutate.py` (mutants of a prototype, each
  test file run), `refactor_save.R` (19 parts, all seven mark columns and every stop), `covr_new.R` /
  `covr_new2.R` (new statements against a HEAD copy `head`), `apply_red.py`, `apply_green.py`, `apply_green2.py`,
  `apply_refactor.py`, `closeout1.py`; S58's in `old/`.
- **Times** (S59's): suite about 5 min (76 files, 957 tests); `R CMD build` and `check --as-cran` about 5 min;
  fidelity about 4 min; covr about 7 min; `test_miscarriageMark.R` 6.5 s; a look harness 4.5 min for 4 looks.

### Key files
- `docs/planning/gaps-and-shared-code-plan.md`: `:374` (G13's row, DONE), `:375` (G14's row), `:339` ("Every G
  phase"), `:714`-`:730` (dragons 56-59, new).
- `docs/planning/standalone-pedigree-package-plan.md`: `:74`-`:88` (status; Next: G14 at `:83`), `:283`-`:289` (R133-R139),
  `:1223` (G13 mark 6); `docs/planning/cran-submission-plan.md:652` (Done G13 mark 6).
- `docs/research/pedkindraw-gaps-2026-11-18.md:219` (B5: what kinship2 and Pedixplorer take).
- S59's work: `R/miscarriageMark.R` (`.miscarriageWords` `:31`, `.readMiscarriage()` `:56`, `.checkMiscarriage()`
  `:81`, `.miscarriageNodes()` `:116`, `.miscarriageLabel()` `:130`, `.miscarriageMark` `:150`,
  `.miscarriageHandler()` `:167`, `.miscarriageRoom()` `:220`, `.miscarriageLegendImage()` `:248`);
  `R/markColumns.R` (`.readMarkColumn()` `:46`, `.oddValuesShown()` `:93`, `.readWordColumn()` `:123`,
  `.idsShown()` `:151`, `.markRoom()` `:247`); the layout in `R/makePedigreeDiagramData.R` (`:545` the reserved
  prefixes, `:2151` the read, `:2333` `.shapeForVec()`, `:2385` the hover line); `R/drawPedigreeDiagram.R:355`
  (`hasSab`, the room at `:370`); `R/affectedConditions.R:283` (`.diagramAfterDrawing()`, `miscarriage` `:287`);
  `tests/testthat/test_miscarriageMark.R` (18 tests; the browser test `:692`); `tools/gapCases.R:461` (the
  miscarriage probe).
- `methodology/BACKLOG.md:26` (G14-G17), `:38`, `:56`, `:63`, `:69`, `:77`, `:83`, `:139`-`:200` (Ready, small).

### How You Will Be Evaluated
The user rates every session's handoff. Your handoff will be scored on:
1. Was the ACTIVE TASK block sufficient to orient the next session?
2. Were key files listed with line numbers?
3. Were gotchas and traps flagged?
4. Was the "what's next" actionable and specific?

---

## Session History

*Session history accumulates below this line. Newest session at the top.*
*S1-S58's entries were removed in S3-S59 (FM #28): their durable records are the receipts in `HANDOFFS.md` and the
entries in `CHANGELOG.md`.*

### Session 58 Handoff Evaluation (by Session 59)
**Score: 9/10.**
- **What helped:** the measure-first list (a)-(f) was the session's plan item for item: Pedixplorer's four levels,
  their spellings and `TRUE` and 1 reading `FALSE` (all re-measured and held); `asPedFrame()` keeping the column
  (`R/asPedFrame.R:315`); the gap case's miscarriage field (`tools/gapCases.R:349`); "a change of shape changes the
  layout's `shape` column ... so only with the column" (S59 left the layout's shape alone and shrank the triangle in
  the drawing); dragon 52 (room read to the widget's box) and dragon 53 (`.markRoom()` and a text field: S59's
  `miscarriage` field needed exactly that line); the scratch scripts were still there and were adapted
  (`looks4.R`, `legend3.R`, `run_one.R`, `covr_new.R`, `refactor_save.R`, `run_checks.sh`). The CI prediction
  (R-devel's S4Vectors only), drift 91/21/0, the 4 nprcgenekeepr commits, the times, the ledger sizes and every cited
  line held.
- **What was missing:** that a smaller node tightens vis.js's fit and cuts long ids at the edges (dragon 57; not
  knowable before S59 shrank a node); that a background check runs as `exec/R`, so a `ps | grep Rscript` check
  misreads it (dragon 56).
- **What was wrong:** nothing.
- **ROI:** high.

### What Session 59 Did
**Deliverable:** Phase G13's sixth and last mark DONE, so Phase G13 DONE: a column `miscarriage` in Pedixplorer's
values, each miscarriage drawn as a triangle 0.6 the size of its symbol with Pedixplorer's line and "ECT", its id
in its row, no slash, invisible points that keep a full-size symbol's room, a stop on a miscarriage that is a parent
or has a fertility mark, the hover line and "Miscarriage", "Termination" and "Ectopic" legend rows (R139); the
REFACTOR shared the reader of a column of words and the naming of up to five animals.
**Started:** 2026-11-20 10:28 CST · **Model:** Claude Opus 5.5 · **Mark's picks (each first time):** "G13:
miscarriage mark (Recommended)" (orient); "miscarriage, Pedixplorer's (Recommended)", "Small triangle, id in row
(Recommended)", "Stop, as Pedixplorer (Recommended)", "Three rows, short words (Recommended)" (pre-RED, with a
picture of four looks opened for him); "Yes, proceed to RED"; "Yes, proceed to GREEN"; "Yes, REFACTOR
(Recommended)". Mark asked mid-GREEN what the small triangle means (answered: the standard notation's pregnancy
loss; the size only keeps it apart from the Unknown sex), then "continue, no change requested". No corrections.
**Commits:** claim `e19d8cc`; RED `035f011`; GREEN 1 `0ed3a6f` (code, help); GREEN 1b `db1af5e` (man/); GREEN 2
`fb85720` (NEWS, DIVERGENCE.md, contract, gap case); REFACTOR `328f865`; close-out 1 `98cf926` (plans, roadmap,
backlog, R139, dragons 56-59); close-out 2 (these notes, the receipt, the ledger). Pushed at close.
**Measured:** Pedixplorer 1.8.0 (help and `ped_to_plotdf()` results): every kind a triangle the box's size in place
of the symbol, TOP and ECT a line corner to corner, ECT "ECT" under it; a parent refused, a fertility mark refused;
proband, consultand, evaluated, carrier, avail, deceased and twins drawn; spaces and case ignored, every other value
none. Looks in headless Chrome at 500 px on 7 pedigrees (31 marked animals) in both edge styles: the small triangle
29 by 25 px against the Unknown's 48 by 41; the line and "ECT" 0 px on anything else; the id kept in its row 8-24 px
from other ink; long ids at the edges cut by 6 px without points, 7 px inside with; the bottom moved id cut by 5,
16 inside; "ECT" right of the triangle cut by the legend; a badge beside the kept symbol 2 px on a twins' line.
Legend labels end at 121, 121, 111 px of 140. The prototype: 18 tests, 406 expectations; 18 of 18 failing at HEAD
with 0 warnings; its suite, check, lint, drift, covr and fidelity clean before RED; the browser test failing on 7
mutants. Final: suite on `328f865` 76 files, 957 tests, 0 failed, 0 skipped, 0 warnings (also on `fb85720`); lint
0; roxygen stable; covr 81 of 81 new at GREEN, 83 of 83 new and moved after the REFACTOR, the package 98.44%;
`R CMD check --as-cran` on `fb85720` and `328f865` R16's NOTE only; fidelity 600 of 600 on both; drift 91/21/0;
the REFACTOR's 19 saved parts byte-identical.
**Self-assessment: 8/10.**
+ Every pick and gate first time, the look picked from a picture of four measured candidates opened for Mark; the
  prototype through every check before RED, applied by script and proved byte-identical at each step; the browser
  test mutation-checked on 7 mutants; the REFACTOR proved on 19 saved parts; the triangle's clash with the Unknown
  sex and the slash's clash with the TOP line both found and settled before RED.
- Took a live coverage run for dead (`ps` read the wrong process name) and reran into the same copies and logs,
  losing one suite result and overlapping two coverage runs (FM #29; the results were rerun cleanly); an `rm` with
  bare variables refused a third time, though the handoff named it; the first comparison picture was cropped at the
  viewport (two reruns); the help text needed a rewording and two lints (a long line each in the help and the
  REFACTOR) before their commits; the browser test's first id measure read "ECT".
**Learnings:** the gaps plan's dragons 56-59. No `CLAUDE.md` row (over budget).
**Ledger:** `CHANGELOG.md` S59 entries (the session, the ruling, push 1).
