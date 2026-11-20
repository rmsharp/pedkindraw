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
evaluated; infertile; miscarriage). **Marks 1-4 of 6 DONE**: genotyped (S54, R134: a 4 px outline), carrier (S55,
R135: a black dot), proband with consultand (S56, R136: an arrow at the lower left) and **evaluated (S57, R137)**:
`makePedigreeMatingLayout()` reads a column `evaluated` with R134's values and stop; the nodes get an `evaluated`
field only with the column; the drawing strokes a black star (three strokes through one centre) to the right of the
upper-right corner of each such symbol (`.evaluatedStarHandler()`, passed in only when some node is evaluated,
`evaluated = TRUE`, run last), adds an invisible size-0 point `__eval_<id>` per evaluated node so vis.js's fit takes
the stars in (`__eval_` is now a reserved prefix), and the legend gains a row "Evaluated" (the star alone), 45 px.
The hover text says "Evaluated:" "Yes/No/Unknown"; `NA` is unmarked. The REFACTOR built the invisible points of the
arrows and the star with `.markRoom()` and `.markField()` (`R/markColumns.R`).
**Next: G13's mark 5, infertile** (`docs/planning/gaps-and-shared-code-plan.md:374`, the G13 row; R133 at
`docs/planning/standalone-pedigree-package-plan.md:280`, R137 at `:284`). R133: Pedixplorer draws an infertile animal
with a line down from the symbol and bars, "where pedkindraw writes the id, so they need another place". **The column
is not true/false**: Pedixplorer's `fertility` is a factor of three levels (`fertility_to_factor()`'s help, read
S57): "fertile" (also `TRUE`, 1, `NA`), "infertile" (also `FALSE`, 0, "steril"), "infertile_choice_na" (also
"infertile_choice", "infertile_na"). Its name, its values and whether the two kinds look different are picker
questions.
**Status:** READY. No work in progress; the tree is clean but `pedkindraw.Rproj` (Mark's).
**The orient picker:** G13's infertile mark (recommended: R133's order). Also READY: the narrow legend
(`methodology/BACKLOG.md:55`), the drawing vignette's measured trait (`:62`), the `smallPed` fixture (`:76`),
rewording `DIVERGENCE.md`'s older rows (`:37`), tests for full coverage (`:82`), and the "Ready, small" items (name
all seven in the last option, as S48-S57 did). NEEDS DECISION: a converted Pedixplorer object's `avail` (`:68`).
**Session boundary:** one kind of mark (infertile). Close out at a clean phase boundary.
**Priority:** HIGH (G13's last two marks, G14-G17 and 17g follow).

### What You Must Do
1. Orient; drift tool (expect **91 functions, 21 differ, 0 without a row**: G13 changes only functions that
   already have rows; the drift tool does not watch constants such as `.reservedIdPrefixes`); nprcgenekeepr's log
   on the copied files, `git -C ../nprcgenekeepr log --oneline baef1e12c..HEAD -- $(grep -l 'Copied from
   nprcgenekeepr' R/*.R tests/testthat/*.R | xargs -n1 basename | sed 's#^#*/#')`: the same 4 commits
   (`4283e3502`, `a85311021`, `392dd347e`, `471589138`). nprcgenekeepr was at `3e06730c5`, tree clean, through all
   of S57.
2. Check S57's push: both workflows run (`R/`, `man/`, `tests/`, `NEWS.md`, `tools/` changed). S56's run
   `44668565648` failed on Ubuntu R-devel only (Bioconductor's S4Vectors 0.50.3 "lazy loading failed", before
   pedkindraw was checked), the other four jobs `success`; expect the same. Any other failure is real. The site
   build must succeed.
3. **Infertile, measure before the pre-RED picker (Learnings 17-21):** (a) the column: Pedixplorer's name is
   `fertility` (its `Pedigree()` also takes "sterilisation" and "steril", `Pedigree-class`'s help); the 13 compared
   CSVs' first lines (dragon 40; none held S54-S57's columns); `asPedFrame()` keeps `fertility` when it holds
   anything besides "fertile" (`R/asPedFrame.R:315`); `.readMarkColumn()` (`R/markColumns.R:34`) reads only
   true/false, so a three-level column needs a reader of its own, or a logical column `infertile` (a picker
   option, with counts: what each reading does with `NA`, 0, "steril"). (b) Pedixplorer's help and
   `ped_to_plotdf()` results for "infertile" and "infertile_choice_na" (S54 saw "three segments under the
   symbol"): each element's place against the box (S57's `px_evaluated.R` prints every element a column adds), on
   an animal with and without offspring (does Pedixplorer warn on an infertile parent?), with the other marks.
   (c) **The id label is below the symbol**, so the bars need another place: measure candidates (beside the
   symbol, the label moved down, above) in headless Chrome at 500 px with S57's red-mark counter
   (`looks2.R`: the mark drawn red, red pixels over ink and the gap to the nearest ink, dragon 49), in both edge
   styles (dragon 50: the direct style's lines arrive from above), with 1- and 10-character ids, deceased and
   twins, and the sibship drop and bar of a child below. (d) The canvas edge (dragon 46): a mark below the label
   at the bottom row can be cut; `.markRoom()` (`R/markColumns.R:154`) builds the points, under a new reserved
   prefix (dragon 51). (e) The legend row via `.markLegendRow()` (`R/markColumns.R:112`) and its 45 px; two kinds
   may need two rows. (f) The hover line. (g) `.diagramAfterDrawing()` (`R/affectedConditions.R:271`) would gain a
   fifth argument; a list of handlers is the REFACTOR candidate (dragon 44), but tests call `carrier = TRUE`,
   `arrows = TRUE` and `evaluated = TRUE` by name.
4. RED, GREEN, REFACTOR by the gates. DONE (plan section 5.1, "Every G phase", `:339`): suite 0 failed, WARN 0; lint
   0; roxygen stable; covr on every new statement; `R CMD check --as-cran` R16's NOTE only; a NEWS bullet; the
   contract's section 4; `DIVERGENCE.md` sentences in copied code and the drift tool exit 0; fidelity 600 of 600.

### Gotchas
- **roxygen's markdown reads two asterisks in one paragraph as emphasis** (dragon 48, new): S57's
  `\dQuote{*}` became `\dQuote{\emph{}` in the Rd, which no check reads; write a symbol as a code span, and after
  every roxygen run that adds one, `grep -n '\\emph{' man/<page>.Rd` and read the page with `R CMD Rd2txt`. In
  `NEWS.md` write `\*`. Read the prototype's Rd before RED, not only its check.
- **Measure overlap with the mark drawn red** (dragon 49, new): a whole-box difference between page loads counted
  the deceased slash's anti-aliasing as overlap; S57's `looks2.R` draws the mark `#FF0000` and counts red pixels
  over the unmarked drawing's ink, with the gap to the nearest ink.
- **The direct style's lines come from above** (dragon 50, new) and a mark's invisible points need a **reserved
  prefix of their own** (dragon 51, new): `__mark_` (arrows) and `__eval_` (star) are taken.
- **`methodology_trim.py` refuses to archive while commits since the ledger's frontier are unrecorded**: write the
  session's `CHANGELOG.md` entries in a commit first, then trim in a commit of its own (`--cut <day>` for a clean
  day seam). S57 archived 69 records; `CHANGELOG.md` is 114,810 B before S57's close-out 2 entry, `HANDOFFS.md`
  181,225 B after S57's receipt (its archive threshold is near 196,608 B: a few sessions' room).
- **The shared pixel reader cannot tell black from nothing** (dragon 45); **vis.js fits its view to the nodes
  only** (dragon 46); **locate a changed pixel before calling it an overlap** (dragon 47).
- **Mutation-check a browser test** (S57's `mutate.R` replaced `.evaluatedStarRoom()` and
  `.evaluatedStarHandler()` with `assignInNamespace()`: 1 and 4 expectations failed); **RED needs every test
  failing** (run the draft at HEAD; S57's 15 of 15 failed); **lint on new code** (`0L:2L`, `2.0`; S57's
  prototype read 0 first time).
- **`rm` with a bare shell variable is refused** by Claude Code's safety check: write `rm -rf "${G:?}/${d:?}"`.
- **Carried:** a mark drawn by a script is passed in only when some node has it (dragon 44); hold the canvas height
  when counting a mark's pixels (dragon 43); delete a scratch copy's `.Rprofile` for the fidelity tool, not
  `--no-init-file` (dragon 42); give a look harness an absolute output path (`normalizePath()`; a relative
  `file://` page has no HTMLWidgets); `Rscript -e '...'` loses backslashes (put such R code in a script); the
  5-file cap splits GREEN (code; man/; records); read a legend outline from inside (dragon 39); check a new
  column's name against the compared CSVs (dragon 40); Pedixplorer's plotting writes `Rplots.pdf` (dragon 41); run
  a single test file from the repository's root; the ratchet's suite gate times out (300 s; name it unmeasured with
  the suite by hand); the Write and Edit tools write U+2265 as itself (dragon 35); a legend label measured at 500 px
  with the widget's width set (dragon 36); copies from a commit, one per running check (dragon 38, FM #29); compute
  every expected value on a prototype before RED (Learning 18); run the prototype through suite, check, lint and
  fidelity before the RED gate (dragon 31); `CLAUDE.md` is over its budget (learnings go to the plans' dragons);
  `pedkindraw.Rproj` untracked, Mark's.
- **Scratch scripts** (`/private/tmp/claude-501/-Users-rmsharp-Development-pedkindraw/f3ff742b-72a4-4ca4-8502-1bc15875807f/scratchpad/g13e/`,
  may be gone): `px_evaluated.R` (Pedixplorer's elements a column adds), `looks2.R` (looks, red-mark overlap,
  gaps and canvas room), `clip.R` (the canvas edge with and without points), `legend.R` (legend pictures),
  `mutate.R`, `run_one.R`, `run_fail.R` (a file's failing count), `run_checks.sh` and `run_g.sh` (suite, check,
  fidelity and covr side by side on copies `<prefix>_suite` etc.), `covr_new.R`, `refactor_save.R`,
  `apply_green.py` (the prototype as one edit script), `apply_green2.py`, `closeout1.py`.
- **Times** (S57's measures, runs side by side): the suite about 5 min (74 files, 921 tests); fidelity 3.5 min;
  `R CMD build` and `check --as-cran` about 5 min; covr (`type = "tests"`) about 7 min; `test_evaluatedMark.R`
  5.6 s; the look harness about 2 min; the drift tool 1 s.

### Key files
- `docs/planning/gaps-and-shared-code-plan.md`: `:374` (G13's row, S54-S57's measures), `:339` ("Every G phase"),
  `:674`-`:694` (dragons 48-51, new).
- `docs/planning/standalone-pedigree-package-plan.md`: `:74`-`:81` (status, Next), `:280`-`:284` (R133-R137),
  `:1196` (G13 mark 4); `docs/planning/cran-submission-plan.md:640` (Done G13 mark 4).
- S57's work: `R/evaluatedMark.R` (`.evaluatedStar` `:27`, `.evaluatedStarHandler()` `:39`,
  `.evaluatedStarRoom()` `:86`, `.evaluatedLegendImage()` `:101`); `R/markColumns.R` (`.markLegendRow()` `:112`,
  `.markField()` `:127`, `.markRoom()` `:154`); `R/probandMark.R:116` (`.probandArrowRoom()`, now two lines); the
  layout in `R/makePedigreeDiagramData.R` (`:532` the reserved prefixes, `:2089` the read, `:2310` the hover line);
  `R/drawPedigreeDiagram.R:295` (`hasEvaluated`, the points at `:300`); `R/affectedConditions.R:271`
  (`.diagramAfterDrawing()`'s `evaluated`); `tests/testthat/test_evaluatedMark.R` (15 tests; the browser test
  `:431`); `tools/gapCases.R:424` (the evaluated probes in `markings`).
- How pedkindraw draws on a symbol: `R/deceasedSlash.R` (the slash handler `:46`); `R/carrierMark.R` (the dot
  `:35`); `R/probandMark.R` (the arrow `:56`); `R/affectedConditions.R` (the section painter `:131`).
- `methodology/BACKLOG.md:26` (G13-G17), `:37`, `:55`, `:62`, `:68`, `:76`, `:82`, `:136`-`:208` (Ready, small).

### How You Will Be Evaluated
The user rates every session's handoff. Your handoff will be scored on:
1. Was the ACTIVE TASK block sufficient to orient the next session?
2. Were key files listed with line numbers?
3. Were gotchas and traps flagged?
4. Was the "what's next" actionable and specific?

---

## Session History

*Session history accumulates below this line. Newest session at the top.*
*S1-S56's entries were removed in S3-S57 (FM #28): their durable records are the receipts in `HANDOFFS.md` and the
entries in `CHANGELOG.md`.*

### Session 56 Handoff Evaluation (by Session 57)
**Score: 9/10.**
- **What helped:** the measure-first list (a)-(g) was the session's plan item for item: the 13 compared CSVs held
  no `evaluated`, `asPedFrame()` kept it as stated, Pedixplorer's "*" place was measured from `ped_to_plotdf()`,
  and the warning that the upper right is where the deceased slash overhangs was exactly what the looks found
  (Pedixplorer's place 4-7 px on every deceased square's slash end). Dragon 46's prediction held (the rightmost
  star 2 px outside the canvas) and `.probandArrowRoom()` was the model for the points; dragon 45 (count with the
  alpha) and 47 (locate a changed pixel) were both needed again. The scratch scripts (`px_proband.R`, `looks.R`,
  `clip.R`, `legend.R`, `mutate.R`, `covr_new.R`, `refactor_save.R`, `run_one.R`, `run_checks.sh`) were still
  there and were adapted. The CI prediction (R-devel's S4Vectors only), drift 91/21/0, the 4 nprcgenekeepr commits,
  every cited line and the CHANGELOG budget warning all held.
- **What was missing:** that `methodology_trim.py` refuses to archive until the session's ledger entries are
  committed (the order cost a commit); that roxygen's markdown turns paired asterisks into emphasis (no earlier
  mark put a symbol in the help); that the direct edge style's lines reach a child from the upper right.
- **What was wrong:** nothing.
- **ROI:** high.

### What Session 57 Did
**Deliverable:** Phase G13's fourth mark DONE: a column `evaluated`, a black star of three strokes to the right of
the upper-right corner of each such symbol, invisible points that keep it in the view, the hover line and an
"Evaluated" legend row (R137); the invisible points of the arrows and the star built by one helper, `.markRoom()`.
**Started:** 2026-11-19 21:46 CST · **Model:** Claude Opus 5.5 · **Mark's picks (each first time):** "G13: evaluated
mark (Recommended)" (orient); "Right of the corner (Recommended)", "Widen the view (Recommended)", "A row with the
'*' (Recommended)" (pre-RED); "Yes, proceed to RED"; "Yes, proceed to GREEN"; "Yes, REFACTOR (Recommended)". No
corrections.
**Commits:** claim `f2de655`; RED `dd498cc`; GREEN 1 `6b23b04` (code, help); GREEN 1b `90b7b52` (man/); GREEN 1c
`565256e` (the help's star as a code span); GREEN 2 `e17e41f` (NEWS, DIVERGENCE.md, contract, gap case); REFACTOR
`66584e0` (`.markRoom()`); close-out 1 `0cf5459` (plans, roadmap, backlog, R137, dragons 48-51); ledger `239f679`
(the session's entries before the archive); archive `3c12aac` (69 records into
`methodology/archive/CHANGELOG-through-2026-11-15.md`); close-out 2 (these notes, the receipt, the push entry). All
pushed at close.
**Measured:** Pedixplorer 1.8.0 (help and `ped_to_plotdf()` results): a text "*" (cex 1.5) at the box centre's
x + 0.11, 0.0062 above its top, just right of its own slash's end; `NA` and 2 read `FALSE`, unreadable text warned;
no legend row. Looks in headless Chrome at 500 px on 8 pedigrees in both edge styles, the star drawn red (red pixels
over ink, gap to the nearest ink): the chosen place (1.6, -0.8; radius 0.28) 0 over ink in the rectilinear style, 2
on a direct-style line to a far-left twin; Pedixplorer's (1.41, -1.2) 4-7 on every deceased square's slash end, 10 on
a direct-style line; a higher place (1.55, -1.0) 1-8. The canvas edge: the six-animal drawing's rightmost star 2 px
outside, 17 px inside with the points (zoom 0.800 to 0.756). Legend pictures: the star alone 32 dark pixels, a small
circle with it 11. `asPedFrame()` keeps the column (C). The prototype: the draft 310 of 310 passing, 15 of 15
failing at HEAD; its suite (74 files, 921 tests), check (R16's NOTE), lint (0) and fidelity (600 of 600) clean
before RED; the browser test failing without the points (1) and without the star script (4). Final: suite on
`66584e0` 74 files, 921 tests, 0 failed, 0 skipped, 0 warnings; lint 0; roxygen stable; covr 50 of 50 new
statements at GREEN, 55 of 55 new and moved after the REFACTOR, the package 98.36%; `R CMD check --as-cran` on
`90b7b52` and `66584e0` 1 NOTE (R16's); fidelity on both 600 of 600, no new set-aside; drift 91/21/0; the
REFACTOR's 12 saved parts byte-identical.
**Self-assessment: 8/10.**
+ Every pick and gate first time, each option with measured counts (three places with red-mark overlap counts in
  both edge styles, the canvas edge with and without the points, two legend pictures); the prototype through suite,
  check, lint and fidelity before RED, applied to the repository by one script and proved identical by `cmp`; the
  browser test mutation-checked; the REFACTOR proved on 12 saved parts; the ledger archived losslessly (its verify
  script OK).
- The help's paired-asterisk emphasis reached GREEN 1 and 1b (the prototype had it; its Rd was not read) and took a
  third GREEN commit; the first look harness used a relative path (a rerun), and its whole-box overlap counts read
  the slash's anti-aliasing until the star was redrawn red (a second harness); one `rm` with bare variables was
  refused; one nonsense expectation in the draft drawing test was caught before it ran; the trim's order cost a
  ledger commit of its own.
**Learnings:** the gaps plan's dragons 48-51; no `CLAUDE.md` row (over budget).
**Ledger:** `CHANGELOG.md` S57 entries (the session, the ruling, the trim, push 1).
