# Session Notes

**Purpose:** Continuity between sessions. Each session reads this first and writes to it before closing out.

**This file is transient — it is overwritten every session** (*"what's next, what traps?"*).
The cumulative, append-only record of *what was done, ever* lives in `CHANGELOG.md`; the commit SHA is the shared key.
At close-out, distill the durable outcome into a `CHANGELOG.md` entry — do not copy this handoff into it.

---

## ACTIVE TASK
**Task:** **Phase 16d, the speed and size-limits vignette** (`docs/planning/documentation-plan.md:185`, section 5.5;
its DONE at `:269`; the plan's Next at `docs/planning/standalone-pedigree-package-plan.md:49`). The orient picker
asks Mark: 16d (recommended: the plan's next phase); the "Select by id" bug (`methodology/BACKLOG.md:24`, found
S29); the gap document (`:44`, Mark's S26 request); tests for full coverage (`:54`); or hold.
**Status:** READY. Phase 16c DONE (S29): `vignettes/drawing.Rmd`, "Drawing pedigrees", 11 drawings, `7ab93a0`,
pushed with the claim (`0910a03`); CI run `43937366764` 5/5; Mark looked at the built page. Close-out 1 and
close-out 2 after it, not pushed.
**Plan (16d):** documentation, TDD phase none with checks written first, as 16a-16c: `vignettes/speed.Rmd`, "Speed and
size limits", no drawings (R77, R79): how the numbers were measured and on what; which code each table measured
and why it stands for pedkindraw's (the documentation plan's section 2, `:67`, the four records and their commits
in nprcgenekeepr); computation, capacity and memory, drawing and readability tables; the single-run times of
pedkindraw's new functions from the plan's Done records. `tools/checkSpeedTables.R ../nprcgenekeepr` reads each
source cell from the clone (`git show <commit>:<path>`) and the vignette's tables, exits 0 only when every number
matches, prints n of n; run failing before the tables are filled (DONE item 2). The contract's section 7
(`docs/planning/pedkindraw-api-contract.md:279`) shrink row gains S1141's 3.69 s. Then point to the new vignette
from `?pedkindraw` (`R/pedkindraw-package.R:42`), the getting-started vignette's "Where next"
(`vignettes/pedkindraw.Rmd:399`) and the drawing vignette's size section (`vignettes/drawing.Rmd:681`).
**Session boundary:** one session: 16d only. 16e (the site) is a session of its own.
**Priority:** HIGH (Phase 16 is the last phase before the CRAN submission plan).

### What You Must Do
1. Orient; drift tool (expect 91 functions, 5 differ, all with rows); `git -C ../nprcgenekeepr log --oneline
   b4abb9a0b..HEAD -- R/affectedConditions.R R/drawPedigreeDiagram.R R/deceasedSlash.R R/makePedigreeDiagramData.R
   R/orderRootSubtrees.R R/positionTreeApportion.R` (Learning 15); if nprcgenekeepr has ported R81, the BLOCKED item
   (`methodology/BACKLOG.md:33`) is unblocked.
2. `git push` S29's two close-out commits with the session's first push.
3. Before the picker (Learning 17): list every number 16d's tables will state with its source file, commit and
   cell (the documentation plan's section 2 table; comparison doc sections 7 and 9; nprcgenekeepr's
   `docs/research/cleanroom-vs-3.0.0-comparison-2026-11.md`), and write `tools/checkSpeedTables.R` against them first.

### Gotchas
- **Read a widget's own canvas, not the first `canvas` in it (S29).** `el.querySelector('canvas')` returns the
  legend's (196 px wide at a 700 px column); the diagram's is `HTMLWidgets.find('#' + el.id).network.canvas.frame
  .canvas`. The legend is `.legend`, its own vis.Network (S28).
- **Judge what a reader sees from a picture (S29).** The first `.vis-tooltip` in the document gave escaped HTML,
  but a picture of the hover showed the tooltip rendered (bold labels, one per line). A screenshot clip needs page
  coordinates (`r.top + window.scrollY`) or it comes back blank; and a screenshot re-fits the legend (S28): read
  positions with JavaScript first. Scripts: the scratchpad's `proto/look.R` (nodes inside each canvas, one picture
  per drawing) and `proto/hover.R`; not committed.
- **Layout facts that broke S29's first checks:** the invisible turning points (`__bar_`, `__drop_`, size 0) sit on
  rows between the animals' rows; `y` is integer under `edgeStyle = "direct"` and double under rectilinear, so
  compare values, not `identical()`. An isolated animal gives a message, not a warning; a fifth condition column
  gives neither.
- **The drawing vignette's hidden checks** (`vignettes/drawing.Rmd`, the `*Claims` chunks) call
  `makePedigreeMatingLayout()` on the 375 animals twice (the shown chunk and `colonyClaims`, which catches the
  warning); the page renders in 8 s.
- **Scratch install recipe** (stale pedkindraw 0.0.1 in renv's library, `methodology/BACKLOG.md:109`): `git
  archive HEAD | tar -x -C <tree>`; `env -u RENV_PROJECT R_LIBS=<scratch lib>:<renv lib> R_LIBS_USER=<renv lib> R CMD
  build --no-manual <tree>` (13 s with the vignettes) and `R CMD INSTALL --library=<scratch lib> <tarball>`. For a
  render without kinship2 and Pedixplorer, a folder of links to renv's packages less those two and pedkindraw (123
  of 126), with `Rscript --no-init-file`. `pkgload::load_all(".")` is enough for a trial page.
- **Installed size:** 4,284 KB with the two vignettes of drawings (S29's check folder; R77's limit 5,120 KB).
- **nprcgenekeepr moves during a session:** its S1176 committed 6 times during S29 (none on the copied files).
- **`.lintr` excludes `vignettes`** (and `tests`, `inst/extdata`): `lint_package()` reads `R/` only. The words gate
  reads `vignettes`; "spouse" is allowed only as kinship2's and Pedixplorer's own element (R73).
- **Run single test files from the root** (renv activates only there); save a suite run's output to a file.
- **zsh:** `echo =====` fails; one check per shell command (Mark, S23). To find code text holding `^` or `|`
  (a regex inside R code), use `grep -F`: macOS grep found nothing for `'__union_|^__dup_'` without it (S29).
- **The suite gate times out (S29):** `test-suite-warnings-zero` has `timeout_seconds: 300` and the suite takes
  261-271 s alone, so `quality_ratchet.py --run` read it UNMEASURED once (`methodology/BACKLOG.md:100`, the item to
  raise it). Until then, if it times out, cite the run with the suite's WARN count by hand, as S29's receipt does.
- **`CLAUDE.md` is over its 28,000 B budget** (30,795 B; S23-S29 added nothing; learnings go in these Gotchas).
- **Left for Mark:** `pedkindraw.Rproj` untracked at the root (`.Rbuildignore:6` keeps it out of the build).
- **Times on this Mac (S29):** the suite 4.3 min; the gate run about 5 min; `R CMD check --as-cran` 3.0 min (tests
  119 s); a vignette page render 5-8 s; CI 16-19 min. Mark's look at a built page can take an hour: push first.

### Key files
- `docs/planning/documentation-plan.md:67` (the timing records and their commits), `:185` (5.5, the speed
  vignette), `:269` (16d's DONE); `docs/planning/pedkindraw-api-contract.md:279` (section 7).
- `vignettes/drawing.Rmd:681` (the size section, to point at 16d's vignette), `:626` (the colony drawing);
  `vignettes/pedkindraw.Rmd:399` (Where next); `R/pedkindraw-package.R:42` (Getting started).
- `R/drawPedigreeDiagram.R:292` (the "Select by id" filter missing `__jog_`); `methodology/BACKLOG.md:11` (16d-16e),
  `:24` (the "Select by id" bug), `:33` (after nprcgenekeepr's port, BLOCKED), `:100` (the suite gate's time limit), `:109` (the stale copy).

### How You Will Be Evaluated
The user rates every session's handoff. Your handoff will be scored on:
1. Was the ACTIVE TASK block sufficient to orient the next session?
2. Were key files listed with line numbers?
3. Were gotchas and traps flagged?
4. Was the "what's next" actionable and specific?

---

## Session History

*Session history accumulates below this line. Newest session at the top.*
*S1-S28's entries were removed in S3-S29 (FM #28): their durable records are the receipts in `HANDOFFS.md` and the
entries in `CHANGELOG.md`.*

### What Session 30 Did
**Deliverable:** plan Phase 16d, the speed and size-limits vignette (`docs/planning/documentation-plan.md:185`,
section 5.5; DONE at `:269`; `methodology/workstreams/DEVELOPMENT_WORKSTREAM.md`): `vignettes/speed.Rmd`, "Speed and
size limits", no drawings; `tools/checkSpeedTables.R`, which checks every number in its tables against
nprcgenekeepr's timing records, written and run failing first; the contract's section 7 shrink row; `?pedkindraw`,
the getting-started vignette and the drawing vignette pointing to it; TDD phase none (documentation), checks written
first; no function code (IN PROGRESS)
**Started:** 2026-11-16 15:15 CST · **Model:** Claude Opus 5.5 · **Mark's pick:** "Speed vignette (Recommended)"
(orient)
**Status:** Session claimed. Work beginning.
**Ledger:** `CHANGELOG: pending` — the claim commit's `CHANGELOG.md` entry says (in progress); Phase 3F records the
rest. Until close-out, this line is the crash breadcrumb for the next session's reconcile.

### Session 28 Handoff Evaluation (by Session 29)
**Score: 9/10.**
- **What helped:** the steps in order (drift tool; nprcgenekeepr's log; push with the first push; trial pages and
  computed values before the picker, which made every picker line a measurement); the gotchas I used: a screenshot
  re-fits the legend (it explained a legend row missing from my first picture), the widget's `.network` and
  `.legend`, the scratch-install recipe (the render without kinship2 and the installed size), `out.width`, the
  375-animal collision warning (it became a picker question), the times (the suite 4.3 min against 4.5). Every line
  it cited was right (20 checked at `ee5aa38`).
- **What was missing:** that the first `canvas` in a widget is the legend's (I measured the wrong canvas once,
  though the `.network` gotcha pointed the right way); that the layout's notice for an isolated animal is a message.
  Neither cost more than one run.
- **What was wrong:** nothing found.
- **ROI:** high.

### What Session 29 Did
**Deliverable:** plan Phase 16c, the drawing vignette (`docs/planning/documentation-plan.md` section 5.4 and 16c's
DONE). TDD phase none (documentation), checks written first. DONE.
**Started:** 2026-11-16 11:29 CST · **Model:** Claude Opus 5.5 · **Mark's picks:** "Drawing vignette (Recommended)"
(orient); "As drafted (Recommended)", "Show and explain (Recommended)", "Numbers now (Recommended)" (the trial page);
"Looks right (Recommended)" (the built page). Each first try.
**Commits:** claim `0910a03` (pushed with S28's two close-out commits, CI `43918919966` 5/5); vignette `7ab93a0`
(`vignettes/drawing.Rmd`; `?pedkindraw` and the getting-started vignette name it; `man/pedkindraw-package.Rd`),
pushed, CI `43937366764` 5/5; close-out 1 `5c1eb1c` (the plan's status and "Done 16c", the documentation plan's S29 note,
ROADMAP, BACKLOG: 16c out, the "Select by id" bug in, 16d's pointers); close-out 2 (these notes, the receipt, the
ledger), not pushed.
**Verified:** before the picker, a trial page at the vignette's width: every node of all 11 drawings inside its
canvas in headless Chrome, the page 2,040,883 B, a scratch build installed at 4,316 KB, the colony layout's warning
and the direct style's (none, 1.2 s against 2.3 s); a click's ids and the "Select by id" box measured in Chrome.
After: six changed values each stopped a render; rendered with kinship2 and Pedixplorer absent; on the built page
all nodes inside (the check failing when zoomed: 2 of 17), the hover greying and tooltip seen in a picture; suite 53
files, 684 tests, 0 failed, 0 skipped, WARN 0, 6,109 passed; lint 0; roxygen only `man/pedkindraw-package.Rd`, then
nothing; words gate 0; `R CMD check --as-cran` 1 NOTE (Maintainer, New submission), vignettes re-built OK,
installed 4,284 KB; drift tool 91 functions, 5 differ, 0 without a row; `quality_ratchet.py --run` 4/5 pass, 0
fail, 1 unmeasured (`test-suite-warnings-zero`, "timeout (300 s)"; by hand the suite on the same files WARN 0),
results `42b564bc4c70`, manifest `01151c525b8a`, head `7ab93a0`;
CI `43937366764` 5/5 at the first attempt (19 min; on each job vignettes re-built OK, installed size OK, `FAIL 0 |
WARN 0`: macOS PASS 6,109 SKIP 0, Windows 6,108 SKIP 1, Ubuntu devel, release and oldrel-1 6,098 SKIP 2).
**Self-assessment: 8/10.**
+ Every picker line was measured (the installed size from a scratch build, the warning, the direct style's time);
  the statements S29 could not hold in R (a click's ids, the box, the hover) were measured in Chrome before the text
  stated them; a bug in copied code found and put on the backlog, not fixed mid-session; an alarming reading (the
  escaped tooltip) checked against a picture before anything was said or changed.
- Slips: two drafted checks were wrong (caught by the render, as checks should be, but they were predictions); the
  first Chrome count read the legend's canvas; one blank screenshot (clip coordinates); I told Mark the tooltip
  might show raw tags before the picture showed it did not.
**Learnings:** no `CLAUDE.md` row (over its budget); in the Gotchas above: a widget's own canvas; judge from a
picture, with page coordinates for a clip; the layout facts that broke the first checks.
**Ledger:** `CHANGELOG.md` S29 entries (the session and its two pushes).
