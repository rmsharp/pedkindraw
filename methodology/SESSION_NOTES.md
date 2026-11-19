# Session Notes

**Purpose:** Continuity between sessions. Each session reads this first and writes to it before closing out.

**This file is transient — it is overwritten every session** (*"what's next, what traps?"*).
The cumulative, append-only record of *what was done, ever* lives in `CHANGELOG.md`; the commit SHA is the shared key.
At close-out, distill the durable outcome into a `CHANGELOG.md` entry — do not copy this handoff into it.

---

## ACTIVE TASK
**Task:** Phase 17, the CRAN submission (`docs/planning/cran-submission-plan.md`). 17a-17f2 DONE (S33-S41); the gap
phases G1-G17 run before 17g (R97, `docs/planning/gaps-and-shared-code-plan.md` section 5.1). G1-G12 DONE (S42-S53).
**G13 under way (S54)**: Pedixplorer's marks, all seven, one kind a session (R133: genotyped; carrier; proband with
consultand; evaluated; infertile; miscarriage; 6 sessions, a guess). **Mark 1 of 6, genotyped, DONE (S54, R134)**:
`makePedigreeMatingLayout()` reads a column `genotyped` (TRUE, FALSE, NA, 1, 0, text `as.logical()` reads; anything
else stops); a genotyped animal's node gets `borderWidth` 4 (every other node 1), drawn by vis.js as a 4 px outline;
the hover text says "Genotyped: Yes/No/Unknown"; `drawPedigreeDiagram()`'s legend gains a row "Genotyped" (a white
square, 4 px outline) before "Deceased", and 45 px. `makePedigreeDiagramData()` unchanged.
**Next: G13's mark 2, the carrier** (`docs/planning/gaps-and-shared-code-plan.md:373`, the G13 row; R133 at
`docs/planning/standalone-pedigree-package-plan.md:277`). Pedixplorer 1.8.0 draws a carrier as a black point at the
symbol's centre (measured S54: `ped_to_plotdf()` type `points`, fill black, cex 0.28, at the box's centre) and gives
it no legend row; its help (`Ped-class`): carrier "has the genetic trait but ... is not likely to manifest the
disease", TRUE / FALSE / NA unknown. pedkindraw has no centre mark: vis.js has no inner dot, so it is a script, as
the deceased slash is (`R/deceasedSlash.R:46`), with a legend picture as "Deceased" has (`.deceasedLegendImage()`,
`R/deceasedSlash.R:84`). With 2-4 conditions the section lines meet at the centre, where the dot would sit.
**Status:** READY. No work in progress; the tree is clean but `pedkindraw.Rproj` (Mark's).
**The orient picker:** G13's carrier (recommended: R133's order). Also READY: the narrow legend (`methodology/
BACKLOG.md:54`), the drawing vignette's measured trait (`:61`), the `smallPed` fixture, rewording `DIVERGENCE.md`'s
older rows (`:36`), and the "Ready, small" items (name all seven in the last option, as S48-S54 did). NEEDS DECISION,
new: a converted Pedixplorer object's `avail` is not drawn as genotyped (`:67`).
**Session boundary:** one mark (the carrier). Close out at a clean phase boundary, never mid-phase.
**Priority:** HIGH (G13's other marks, G14-G17 and 17g follow).

### What You Must Do
1. Orient; drift tool (expect **91 functions, 21 differ, 0 without a row**: G13 changed the layout and the drawing,
   which already had rows); nprcgenekeepr's log on the copied files, `git -C ../nprcgenekeepr log --oneline
   baef1e12c..HEAD -- $(grep -l 'Copied from nprcgenekeepr' R/*.R tests/testthat/*.R | xargs -n1 basename | sed
   's#^#*/#')`: the same 4 commits (`4283e3502`, `a85311021`, `392dd347e`, `471589138`). nprcgenekeepr was at
   `3e06730c5`, tree clean, through all of S54.
2. Check S54's push: both workflows run (`R/`, `man/`, `tests/`, `NEWS.md`, `tools/` changed). Expect Ubuntu R-devel
   to fail installing Bioconductor's S4Vectors 0.50.3 again (S53's run `44632050838` did, "lazy loading failed",
   its other four jobs `success`); any other failure is real. The site build must succeed.
3. **The carrier, measure before the pre-RED picker (Learnings 17-21):** (a) the fidelity CSVs' first lines (dragon
   40): none holds `carrier` (S54 read all 13; samplePed holds `affected`, `avail`, `famid`); (b) Pedixplorer's
   carrier with `NA` and its help (help and results only, dragon 6); (c) looks, each tried in headless Chrome at
   500 px with pixel counts against the unmarked drawing, colour and greyscale, one and three conditions, as S54's
   scratch `measure_border.R` did: a black dot at the centre (its radius), and whatever else the picker offers; on a
   pink fill, on the section lines' meeting point, under the deceased slash; (d) NA (unmarked, as genotyped, or
   another look) and the hover line; (e) the legend row "Carrier": a picture, as "Deceased" has, and its 45 px; (f)
   the column reader: `.readGenotyped()` (`R/genotypedMark.R:34`) reads one column name; a carrier reader is the
   same rule, so GREEN or REFACTOR may give it the column's name as an argument (its message names the column).
4. RED, GREEN, REFACTOR by the gates. DONE (plan section 5.1, "Every G phase", `:338`): suite 0 failed, WARN 0; lint
   0; roxygen stable; covr on every new statement; `R CMD check --as-cran` R16's NOTE only; a NEWS bullet; the
   contract's section 4; `DIVERGENCE.md` sentences in copied code and the drift tool exit 0; fidelity 600 of 600.

### Gotchas
- **Read a legend outline from inside, a diagram outline from outside** (dragon 39, new): the legend is at 0.70
  scale and a 1 px line there is two faint pixels; `read()` has no alpha, so faint blue reads as blue. A centre dot
  in the legend is a picture (SVG), read at its middle.
- **Check a column's name against the compared pedigrees** (dragon 40, new): `avail` would have changed 10 of
  samplePed's 50 results; count with `runCases()` on one CSV and a wrapped builder (S54's scratch `count_avail.R`,
  3 s).
- **Pedixplorer's plotting writes `Rplots.pdf` where R runs** (dragon 41, new): S54's scratch script left one in
  the root; run them from the scratchpad and read `git status` after.
- **Run a single test file from the repository's root** (CLAUDE.md's fast form): from `tests/testthat` the project's
  `.Rprofile` is not read, renv does not load, and `load_all()` stops ("quadprog is required").
- **The browser test's reader throws when a legend row is missing** (`test_genotypedMark.R`, its last test): at RED
  it showed an error, not a failure; G12's reader pushes "none". Write the carrier's with "none".
- **The harness refuses `rm -rf $S/$d`**: write `"${S:?}/${d:?}"`. chromote's timeout: `cp <-
  chromote::default_chromote_object(); cp$default_timeout <- 60` (assigning through the call fails). covr on a saved
  object: `covr:::as.data.frame.coverage(readRDS(...))`.
- **Text "1" and "0" in the genotyped column stop** (R134 as picked; numbers 1 and 0 read); the backlog item at
  `:67` asks about `avail` and says so.
- **The ratchet's suite gate times out** (300 s; the suite 5.3-5.4 min): name it in the receipt as `unmeasured:
  test-suite-warnings-zero -- by hand: <your suite run>`; raising the limit is the backlog's "Ready, small" item.
- **Carried:** the Write and Edit tools write the sign U+2265 as itself (dragon 35: escape with a script, grep each
  file for non-ASCII); a legend label measured at 500 px with the widget's width set (dragon 36); the fidelity tool
  from a scratch copy needs renv's library (dragon 37); copies from a commit, one per running check (dragon 38, FM
  #29); zsh stops on an unmatched glob; a random pedigree's collision warning muffled by its words; compute every
  expected value on a prototype before RED (Learning 18); run the prototype through suite, check, lint and fidelity
  before the RED gate (dragon 31); helpers load alphabetically (dragon 26); `CLAUDE.md` is over its budget (learnings
  go to the plans' dragons); `pedkindraw.Rproj` untracked, Mark's.
- **Times** (S54's measures): the suite 5.3-5.4 min (71 files, 877 tests); fidelity 3.5 min; `R CMD build` and
  `check --as-cran` about 4.5 min; covr (`type = "tests"`) about 7 min; `test_genotypedMark.R` 5.3 s; a gap case
  3.5 s; the drift tool 1 s.

### Key files
- `docs/planning/gaps-and-shared-code-plan.md`: `:373` (G13's row, S54's measures), `:338` ("Every G phase"),
  `:627`-`:641` (dragons 39-41, new).
- `docs/planning/standalone-pedigree-package-plan.md`: `:76`-`:78` (status, Next), `:277`-`:278` (R133-R134),
  `:1161` (G13 mark 1); `docs/planning/cran-submission-plan.md` (Done G13 mark 1, after Done G12).
- S54's work: `R/genotypedMark.R` (`.genotypedBorderWidth` `:18`, `.readGenotyped()` `:34`, `.genotypedOddValues()`
  `:60`, `.genotypedBorderWidths()` `:91`); the layout in `R/makePedigreeDiagramData.R` (grep `Phase G13`: `:2030`
  the read, `:2071` the empty layout, `:2232` the hover line, `:2475` the widths); `R/drawPedigreeDiagram.R:230`
  (the legend row); `tests/testthat/test_genotypedMark.R` (11 tests; its browser test at the end is the model, with
  "none" for a missing row); `tools/gapCases.R:372` (pedkindraw's genotyped probes in `markings`).
- How pedkindraw draws on a symbol: `R/deceasedSlash.R` (the slash handler `:46`, its legend picture `:84`);
  `R/affectedConditions.R` (the section painter `:124`, `.diagramAfterDrawing()` `:255`, which chains the handlers,
  `.diagramHeight()` `:280`).
- `methodology/BACKLOG.md:26` (G13-G17), `:54`, `:61`, `:67` (new, NEEDS DECISION).

### How You Will Be Evaluated
The user rates every session's handoff. Your handoff will be scored on:
1. Was the ACTIVE TASK block sufficient to orient the next session?
2. Were key files listed with line numbers?
3. Were gotchas and traps flagged?
4. Was the "what's next" actionable and specific?

---

## Session History

*Session history accumulates below this line. Newest session at the top.*
*S1-S53's entries were removed in S3-S54 (FM #28): their durable records are the receipts in `HANDOFFS.md` and the
entries in `CHANGELOG.md`.*

### Session 53 Handoff Evaluation (by Session 54)
**Score: 9/10.**
- **What helped:** the measure-first list (a)-(e) was the session's plan: the gap case printed exactly what it said
  (3.4 s); every code location was exact (`deceasedRow` `R/drawPedigreeDiagram.R:205`, the section painter `:124`,
  `.diagramAfterDrawing()` `:255`, `.conditionLegendImage()` `:217`, `.diagramHeight()` `:280`); drift 91/21/0, the
  same 4 nprcgenekeepr commits and the CI prediction (R-devel's S4Vectors only) all held. Dragons 35-38 were used as
  written: no non-ASCII slipped in, the widget's width was set before `saveWidget()`, the fidelity tool ran from a
  scratch copy first time with renv's library, and each check ran on its own `git archive` copy.
- **What was missing:** that Pedixplorer's legend shows only the border, so a legend row per mark goes beyond it;
  that samplePed among the compared pedigrees holds `avail`, which decides the column's name; that pedkindraw's
  "Unknown" sex is the triangle Pedixplorer draws for a miscarriage; that the legend is drawn at 0.70 scale; that a
  test file run from `tests/testthat` loads no renv.
- **What was wrong:** nothing. "8-9 sessions, a guess" became 6 by R133.
- **ROI:** high.

### What Session 54 Did
**Deliverable:** Phase G13's first mark DONE: a column `genotyped`, a genotyped animal's outline drawn 4 px wide, its
hover line and a legend row (R133-R134).
**Started:** 2026-11-19 16:51 CST · **Model:** Claude Opus 5.5 · **Mark's picks (each first time):** "Phase G13:
marks (Recommended)" (orient); "All 7, genotyped first (Recommended)", "Thick outline (Recommended)", "genotyped
(Recommended)", "NA drawn unmarked (Recommended)" (pre-RED); "Yes, proceed to RED"; "Yes, proceed to GREEN"; "Yes,
REFACTOR (Recommended)". No corrections.
**Commits:** claim `ce5e796`; RED `a053d43`; GREEN 1 `b4e8a5d` (code, help); GREEN 2 `e2d49de` (NEWS, DIVERGENCE.md,
contract, gap case); REFACTOR `ad50b26` (the message written once); close-out 1 (plans, roadmap, backlog, rulings,
dragons); close-out 2 (these notes, the receipt, the ledger). All pushed at close.
**Measured:** Pedixplorer 1.8.0 (help and `ped_to_plotdf()` results): each mark's elements and place, its legend
only the border. Three looks in headless Chrome at 500 px (pixels changed per animal against the unmarked drawing):
the thick outline 621-679 (one condition), 339-540 (three), 299-613 greyscale, 0 elsewhere; a black ring 441-448;
Pedixplorer's colours 0 in greyscale and every outline changed. Reading `avail` would change 10 of samplePed's 50
compared results. The prototype: the draft 242 of 242 passing, 11 of 11 failing at HEAD for the missing feature;
its suite, check, lint and fidelity clean before RED. Final: suite on `ad50b26` 71 files, 877 tests, 0 failed, 0
skipped, 0 warnings (5.3 min); lint 0; roxygen stable; covr 40 of 40 new statements at GREEN, 26 of 26 in
`R/genotypedMark.R` and 6 of 6 in the drawing's block after the REFACTOR; `R CMD check
--as-cran` on `b4e8a5d` and `ad50b26` 1 NOTE (R16's); fidelity on `b4e8a5d` and `ad50b26` 600 of 600, no
set-aside; drift 91/21/0; the REFACTOR's 103 saved results identical.
**Self-assessment: 8/10.**
+ Every pick and gate first time, each picker option with measured counts (three looks in colour and greyscale,
  the column name's 10 results); the prototype through suite, check, lint and fidelity before RED; the REFACTOR
  proved on 103 saved results; the first mark DONE in one session with all its records; a converter gap filed, not
  fixed.
- Slips that cost reruns: the reader's missing alpha (one draft failure, found on the prototype before RED); an
  `Rplots.pdf` left in the root by a scratch script (found and removed); RED's first run from `tests/testthat`
  (no renv); covr's second half lost to shell quoting (redone from the saved object); a blocked `rm -rf $S/$d`; a
  `sed` whose success a later grep misreported; the browser test errors rather than fails when its row is missing.
**Learnings:** the gaps plan's dragons 39-41; no `CLAUDE.md` row (over budget).
**Ledger:** `CHANGELOG.md` S54 entries (the session, the rulings, push 1).
