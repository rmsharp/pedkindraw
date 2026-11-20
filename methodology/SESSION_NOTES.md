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
evaluated; infertile; miscarriage). **Marks 1-5 of 6 DONE**: genotyped (S54, R134), carrier (S55, R135), proband
with consultand (S56, R136), evaluated (S57, R137) and **infertile (S58, R138)**: `makePedigreeMatingLayout()` reads
a column `fertility` in Pedixplorer's words and values (fertile/TRUE/1; infertile/steril/FALSE/0;
infertile_choice_na/infertile_choice/infertile_na; any case; NA unmarked; anything else stops); the nodes get a
text field `fertility` ("infertile", "infertile_choice_na", "" for every other node); the drawing strokes a line
down from the symbol and two bars (one for infertile_choice_na) in Pedixplorer's proportions, last, moves the
animal's id 14 units down (`font.vadjust`), adds invisible points `__fert_<id>` below each moved id (a reserved
prefix), and legend rows "Infertile" and "No offspring". An infertile parent is drawn as recorded. The REFACTOR
shared `.oddValuesShown()` and `.nodeAnimals()` (`R/markColumns.R`).
**Next: G13's mark 6, miscarriage, the last** (`docs/planning/gaps-and-shared-code-plan.md:374`, the G13 row; R133 at
`docs/planning/standalone-pedigree-package-plan.md:281`, R138 at `:286`). R133: Pedixplorer draws a miscarriage as a
triangle in place of the symbol, which is pedkindraw's symbol for the sex "Unknown", "so it needs another look".
**Facts read S58 (help only, R11):** Pedixplorer's `miscarriage_to_factor()` has four levels, "SAB" (also
"spontaneous", "spontaenous abortion" [sic]), "TOP" ("termination", "terminated", "termination of pregnancy"),
"ECT" ("ectopic", "ectopic pregnancy") and "FALSE" ("0", "FALSE", "no", NA); "space and case are ignored"; every
other value becomes FALSE; measured: `TRUE` and 1 read FALSE. Its `norm_ped()` help lists "No parents are
infertile or aborted" among its checks. `asPedFrame()` keeps `miscarriage` when it holds anything besides "FALSE"
(`R/asPedFrame.R:315`); the gap case already probes `miscarriage = c("FALSE", "FALSE", "SAB", "FALSE")`
(`tools/gapCases.R:349`).
**Status:** READY. No work in progress; the tree is clean but `pedkindraw.Rproj` (Mark's). S58's commits are pushed
(Mark's pick, S58: push at close, now a memory).
**The orient picker:** G13's miscarriage mark (recommended: R133's order, the last of G13; then G14). Also READY:
the narrow legend (`methodology/BACKLOG.md:56`), the drawing vignette's measured trait (`:63`), the `smallPed`
fixture (`:77`), rewording `DIVERGENCE.md`'s older rows (`:38`), tests for full coverage (`:83`), and the "Ready,
small" items (`:139`-`:200`; name all seven in the last option, as S48-S58 did). NEEDS DECISION: a converted
Pedixplorer object's `avail` (`:69`).
**Session boundary:** one kind of mark (miscarriage). Close out at a clean phase boundary.
**Priority:** HIGH (G13's last mark, then G14-G17 and 17g).

### What You Must Do
1. Orient; drift tool (expect **91 functions, 21 differ, 0 without a row**); nprcgenekeepr's log on the copied
   files, `git -C ../nprcgenekeepr log --oneline baef1e12c..HEAD -- $(grep -l 'Copied from nprcgenekeepr' R/*.R
   tests/testthat/*.R | xargs -n1 basename | sed 's#^#*/#')`: the same 4 commits (`4283e3502`, `a85311021`,
   `392dd347e`, `471589138`). nprcgenekeepr was at `3e06730c5`, tree clean, through all of S58.
2. Check S58's push: both workflows run (`R/`, `man/`, `tests/`, `NEWS.md`, `tools/` changed). S56's and S57's CI
   runs failed on Ubuntu R-devel only (Bioconductor's S4Vectors 0.50.3 "lazy loading failed", before pedkindraw is
   checked), the other four jobs `success`; expect the same. Any other failure is real. The site build must succeed.
3. **Miscarriage, measure before the pre-RED picker (Learnings 17-21):** (a) the column: Pedixplorer's name
   `miscarriage` (its `Pedigree()` also takes "aborted", `Pedigree-class`'s help, `cols_ren_ped`), its four levels and
   their spellings (above), the 13 compared CSVs' first lines (dragon 40; none held S54-S58's columns), and whether
   pedkindraw reads Pedixplorer's values (TRUE reading FALSE there is a trap for a true/false reader) or a column of
   its own; NA and an unreadable value (Pedixplorer: FALSE without a word). (b) Pedixplorer's `ped_to_plotdf()`
   results for each level (S54: "SAB" a triangle; does "TOP" or "ECT" differ? a label? its size against the box?),
   and with a parent (`norm_ped()`'s check) and with the other marks. (c) **The look**: the triangle is
   pedkindraw's Unknown sex (`.shapeForVec()`, `R/makePedigreeDiagramData.R:2295`), so candidates (a smaller
   triangle, a triangle with a mark, another shape, the sex symbol kept with a mark beside it) measured in headless
   Chrome at 500 px with the mark drawn in a colour of its own (dragon 49) in both edge styles (dragon 50), with 1-
   and 10-character ids, deceased, twins and a sibship; a change of shape changes the layout's `shape` column, which
   the fidelity tool compares, so only with the column (dragon 44). (d) Legend rows (the narrow legend: labels end
   by about 125 px of 140 at 500 px; S58's "No offspring by choice" reached 144). (e) The hover line. (f) Bottom and
   side room measured to the widget's box (dragon 52), and `.markRoom()` emptying any non-logical field (dragon 53).
4. RED, GREEN, REFACTOR by the gates. DONE (plan section 5.1, "Every G phase", `:339`): suite 0 failed, WARN 0; lint
   0; roxygen stable; covr on every new statement; `R CMD check --as-cran` R16's NOTE only; a NEWS bullet; the
   contract's section 4; `DIVERGENCE.md` sentences in copied code and the drift tool exit 0; fidelity 600 of 600.
   G13 then ends: update its row's sessions (R133: 6) and the plans' G13 status to DONE.

### Gotchas
- **The canvas reaches 5.5 px below the widget's box** (dragon 52, new): read bottom room against the widget's
  `getBoundingClientRect()`, not `cv.clientHeight` (S58's picker quoted canvas numbers and had to correct them).
- **`.markRoom()` sets only logical fields FALSE on its points** (dragon 53, new): it now empties `fertility`; a
  miscarriage field that is text needs the same, or other marks' points carry it (the draft tests caught this).
- **`font.vadjust` moves a label but not its box** (dragon 54, new); **read text ink below luminance 128, in a band**
  (the id's grey is not below 60 at zoom < 1; one letter's lowest row is not another's).
- **Check a harness's geometry against the reference's numbers** (dragon 55, new): S58's first harness drew the
  bars at half Pedixplorer's width (its proportions are of the box, twice the node's size).
- **A control drawing must keep the fit**: blanking labels changed vis.js's fit and the boxes' sizes; draw them
  transparent instead (`font.color` "rgba(0,0,0,0)").
- **Mutation-check a browser test** (`mutate.R`; S58: removing the points first went unnoticed until the room was
  read to the widget's bottom); **RED needs every test failing with 0 warnings** (a missing row pushed as 'none'
  gave 2 coercion warnings at HEAD; push '0'/'false').
- **`rm` with a bare shell variable is refused** (it happened again in S58): write `rm -rf "${D:?}/${d:?}"`.
- **Carried:** roxygen's markdown pairs asterisks (dragon 48); measure overlap with the mark drawn red (49); the
  direct style's lines arrive from above (50); a mark's points need a reserved prefix of their own (51); a scratch
  copy's `.Rprofile` is deleted (42); Pedixplorer's plotting writes `Rplots.pdf` (41: run probes from the
  scratchpad); `Rscript -e '...'` loses backslashes (put such R code in a script); the 5-file cap splits GREEN
  (code; man/; records); the ratchet's suite gate times out at 300 s (name it unmeasured with the suite by hand);
  `methodology_trim.py` refuses to archive while commits since the ledger's frontier are unrecorded;
  `CLAUDE.md` is over its budget (learnings go to the plans' dragons); `pedkindraw.Rproj` untracked, Mark's.
- **Ledger sizes after S58's close-out 2:** `CHANGELOG.md` about 121 KB, `HANDOFFS.md` about 186 KB of its
  196,608 B archive threshold (a guess from S58's additions: two sessions' room; check with `wc -c`).
- **Scratch scripts** (`/private/tmp/claude-501/-Users-rmsharp-Development-pedkindraw/68e2f328-942a-4d9d-bb0e-86e5d96260cc/scratchpad/g13f/`,
  may be gone): `px_infertile2.R` (Pedixplorer's elements and value reading), `looks3.R` (looks: mark red, label
  green, a control with transparent labels; per-animal overlap, gap to its own label, label over ink, canvas room),
  `clip3.R`, `dbg_rect2.R` (canvas against the widget box), `legend3.R`, `mutate.R`, `run_one.R`, `run_g.sh` and
  `run_checks.sh` (suite, check, fidelity and covr side by side on copies `<prefix>_suite` etc.), `covr_new.R`
  (new statements against a HEAD copy `head_R`), `refactor_save.R` (14 parts, all six mark columns),
  `apply_green.py`, `apply_green2.py`, `apply_refactor.py`, `closeout1.py`.
- **Times** (S58's, runs side by side): suite about 5 min (75 files, 939 tests); `R CMD build` and `check --as-cran`
  about 5 min; fidelity 3.5 min; covr about 7 min; `test_infertileMark.R` 5.7 s; a look harness 3.5 min.

### Key files
- `docs/planning/gaps-and-shared-code-plan.md`: `:374` (G13's row, S54-S58's measures), `:339` ("Every G phase"),
  `:695`-`:714` (dragons 52-55, new).
- `docs/planning/standalone-pedigree-package-plan.md`: `:74`-`:82` (G13's status, Next), `:281`-`:286` (R133-R138),
  `:1208` (G13 mark 5); `docs/planning/cran-submission-plan.md:646` (Done G13 mark 5).
- S58's work: `R/infertileMark.R` (`.fertilityWords` `:24`, `.readFertility()` `:47`, `.fertilityNodes()` `:81`,
  `.fertilityLabel()` `:95`, `.infertileMark` `:117`, `.infertileBarsHandler()` `:132`, `.infertileRoom()` `:186`,
  `.infertileLegendImage()` `:205`); `R/markColumns.R` (`.readMarkColumn()` `:39`, `.oddValuesShown()` `:86`,
  `.markedNodes()` `:109`, `.nodeAnimals()` `:125`, `.markLegendRow()` `:143`, `.markField()` `:158`, `.markRoom()`
  `:186`); the layout in `R/makePedigreeDiagramData.R` (`:538` the reserved prefixes, `:2117` the read, `:2295`
  `.shapeForVec()`, `:2343` the hover line, `:2606` the field); `R/drawPedigreeDiagram.R:319` (`hasInfertile`, the
  points at `:331`); `R/affectedConditions.R:277` (`.diagramAfterDrawing()`, `infertile` `:280`);
  `tests/testthat/test_infertileMark.R` (18 tests; the browser test `:570`); `tools/gapCases.R:339` (the markings
  case; the miscarriage field `:349`).
- `methodology/BACKLOG.md:26` (G13-G17), `:38`, `:56`, `:63`, `:69`, `:77`, `:83`, `:139`-`:200` (Ready, small).

### How You Will Be Evaluated
The user rates every session's handoff. Your handoff will be scored on:
1. Was the ACTIVE TASK block sufficient to orient the next session?
2. Were key files listed with line numbers?
3. Were gotchas and traps flagged?
4. Was the "what's next" actionable and specific?

---

## Session History

*Session history accumulates below this line. Newest session at the top.*
*S1-S57's entries were removed in S3-S58 (FM #28): their durable records are the receipts in `HANDOFFS.md` and the
entries in `CHANGELOG.md`.*

### Session 57 Handoff Evaluation (by Session 58)
**Score: 9/10.**
- **What helped:** the measure-first list (a)-(g) was the session's plan item for item, and its pointer that
  Pedixplorer's `fertility` is a three-level factor, not true/false, framed the first picker question. The facts held:
  the id label under the symbol, so the bars needed another place; `asPedFrame()` returning the column
  (`R/asPedFrame.R:315`); `.markRoom()` at `R/markColumns.R:154` building the points; dragon 46 (the bottom row's moved
  id was cut) and dragon 51 (a prefix of its own, `__fert_`). The scratch scripts were still there and were adapted
  (`px_evaluated.R`, `looks2.R`, `clip.R`, `legend.R`, `mutate.R`, `run_g.sh`, `run_one.R`, `run_fail.R`, `covr_new.R`,
  `refactor_save.R`, `apply_green.py`). The CI prediction (R-devel's S4Vectors only), drift 91/21/0, the 4
  nprcgenekeepr commits, the times and every cited line held.
- **What was missing:** that `.markRoom()` sets only logical fields `FALSE`, so a mark whose node field is text is
  copied onto other marks' points (dragon 53); that the canvas reaches 5.5 px below the widget's box, so a
  bottom-edge room read against the canvas is too generous (dragon 52; S56-S57 measured the left and right edges,
  where it does not matter); that vis.js's label box ignores `font.vadjust` (dragon 54).
- **What was wrong:** nothing. (The roadmap's current-milestone paragraph and phase list still said "the evaluated
  mark is next"; S58 fixed both. The handoff itself was right.)
- **ROI:** high.

### What Session 58 Did
**Deliverable:** Phase G13's fifth mark DONE: a column `fertility` in Pedixplorer's words and values, Pedixplorer's
line and two bars (one for no offspring by choice or for an unknown reason) under each such symbol, the id moved
below them, invisible points that keep a moved id in the view, the hover line and "Infertile" and "No offspring"
legend rows (R138); the REFACTOR shared the bad-values text and the node-to-animal lookup.
**Started:** 2026-11-20 03:22 CST · **Model:** Claude Opus 5.5 · **Mark's picks (each first time):** "G13: infertile
mark (Recommended)" (orient); "fertility, Pedixplorer's (Recommended)", "Under symbol, id moved (Recommended)", "Draw
it (Recommended)", "Infertile + No offspring (Recommended)" (pre-RED); "Yes, proceed to RED"; "Yes, proceed to
GREEN"; "Yes, REFACTOR (Recommended)"; "Push at close (Recommended)" (now a memory). No corrections.
**Commits:** claim `edb1bae`; RED `2574518`; GREEN 1 `68c46f9` (code, help); GREEN 1b `83373a7` (man/); GREEN 2
`6b1580c` (NEWS, DIVERGENCE.md, contract, gap case); REFACTOR `036d148`; close-out 1 `6e84e28` (plans, roadmap,
backlog, R138, dragons 52-55); close-out 2 (these notes, the receipt, the ledger). Pushed at close.
**Measured:** Pedixplorer 1.8.0 (help and `ped_to_plotdf()` results): "infertile" a line from the box's bottom 0.29 of
its height and bars 0.8 and 1.0 of its width, 0.1 of its height apart; "infertile_choice_na" the line and the first
bar; either kind on a parent refused ("is-infertile-but-is-parent"); values it does not know read fertile without a
word. Looks in headless Chrome at 500 px on 7 pedigrees in both edge styles, the mark drawn red, the moved id green,
a control with transparent labels: under the symbol with the id moved 14 units, 0 px on anything else for every
animal without offspring, 2-6 px from its own id (at Pedixplorer's bar width: S58's first harness had half of it,
re-measured); under the id 0 px but not touching the symbol; right of the symbol 4-8 px on twins' connectors, 7-15 on
every parent's mating line; Pedixplorer's place with the id kept 1-23 px on the id; parents in the direct style 1-6
px and the moved id up to 13. The bottom row's moved id: -1.5 px to the widget's bottom without points, 25.5 with
(the canvas reaches 5.5 px past the widget; the picker's 0.6 and 23 px were read against the canvas). Legend: the
mark alone 34 and 19 dark px, a small circle with it 16 and 10; labels end at 112 ("Infertile") and 122 ("No
offspring") of 140, "No offspring by choice" at 144. The prototype: 18 tests, 354 expectations passing, 18 of 18
failing at HEAD with 0 warnings; its suite, check, lint and fidelity clean before RED; the browser test failing
without the points (1), the move (3), the bars (5) or the second bar (2). Final: suite on `036d148` 75 files, 939
tests, 0 failed, 0 skipped, 0 warnings; lint 0; roxygen stable; covr 55 of 55 new at GREEN, 49 of 49 new and moved
after the REFACTOR, the package 98.39%; `R CMD check --as-cran` on `6b1580c` and `036d148` R16's NOTE only; fidelity
600 of 600 on both; drift 91/21/0; the REFACTOR's 14 saved parts byte-identical.
**Self-assessment: 8/10.**
+ Every pick and gate first time, each option with measured counts (four places in both edge styles, parents
  separately, the canvas room with and without points, legend pictures and label widths); the prototype through
  suite, check, lint, covr and fidelity before RED and applied by script, proved by `diff`/`cmp`; the draft tests
  found a real bug (`.markRoom()` and a text field) before any repository code; the browser test mutation-checked
  and strengthened until all four mutations failed; the REFACTOR proved on 14 saved parts.
- The first look harness drew the bars at half Pedixplorer's width, and the first control drawing blanked the labels
  and changed the fit (two reruns); the picker quoted canvas-room numbers measured against the wrong edge, corrected
  before RED with the pick unaffected; the browser test's id measure took three tries (the luminance threshold, a
  two-letter id, a glyph's shape); one `rm` with bare variables was refused, a gotcha the handoff had named; the push
  question said 9 commits where there were 7.
**Learnings:** the gaps plan's dragons 52-55; a memory (push at close). No `CLAUDE.md` row (over budget).
**Ledger:** `CHANGELOG.md` S58 entries (the session, the ruling, push 1).
