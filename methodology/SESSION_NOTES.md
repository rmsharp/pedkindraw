# Session Notes

**Purpose:** Continuity between sessions. Each session reads this first and writes to it before closing out.

**This file is transient — it is overwritten every session** (*"what's next, what traps?"*).
The cumulative, append-only record of *what was done, ever* lives in `CHANGELOG.md`; the commit SHA is the shared key.
At close-out, distill the durable outcome into a `CHANGELOG.md` entry — do not copy this handoff into it.

---

## ACTIVE TASK
**Task:** **the legend item**, then Phase 16c. The legend does not explain the sections of a symbol with two or more
conditions (`methodology/BACKLOG.md:26`, Mark's S26 find); 16c's drawing vignette shows two to four conditions, so
the item comes first (`methodology/BACKLOG.md:11`, the plan's Next at
`docs/planning/standalone-pedigree-package-plan.md:47`). The orient picker asks Mark: the legend item
(recommended); 16c without it; **the gap document** (`methodology/BACKLOG.md:36`, Mark's S26 request); tests for
full coverage (`:46`); or hold.
**Status:** READY. Phase 16b DONE (S27: claim `6397dc4`, dependencies and example file `2da3cb3`, vignette and help
page `d0068a7`, pushed with S26's two close-out commits, CI run `43810961086` (5/5); close-out 1 and 2 after,
not pushed). `R/` gained no code: only `R/pedkindraw-package.R`'s help text changed.
**Plan (the legend item):** code copied from nprcgenekeepr, so TDD with the three gates, and the drift rule: the
session's first picker asks whether nprcgenekeepr gets the same fix in a session of its own there or pedkindraw
records the difference in `DIVERGENCE.md` (plan section 5). With two or more conditions `drawPedigreeDiagram()`
splits each symbol into equal sections (`.conditionSectionsHandler()`, `R/affectedConditions.R:98`, drawn by
`.diagramAfterDrawing()`, `R/drawPedigreeDiagram.R:172`) and draws the dividers on unaffected animals too; the
legend's condition rows (`conditionRows`, `R/drawPedigreeDiagram.R:134`, joined at `:152`) show each condition as a
whole filled hexagon, so nothing says which section is which.
**Session boundary:** one session: the legend item only. 16c is a session of its own.
**Priority:** HIGH (16c waits on it).

### What You Must Do
1. Orient; drift tool (expect 3 differ, all with rows); `git -C ../nprcgenekeepr log --oneline baef1e12c..HEAD --
   R/makePedigreeDiagramData.R R/orderRootSubtrees.R R/positionTreeApportion.R R/affectedConditions.R
   R/drawPedigreeDiagram.R` (Learning 15). At S27's close nprcgenekeepr was at `21a4221d5`: nothing new on the three
   layout files; its three commits on the legend's two files since `baef1e12c` (S1153 `471589138`, S1159
   `a85311021` and `4283e3502`) are already in pedkindraw's copy (the drift tool reads them the same).
2. `git push` S27's two close-out commits with the session's first push (CI ran on `d0068a7`; the close-out
   commits change only `docs/` and `methodology/`).
3. Measure before the picker (Learning 17): draw typed pedigrees with two, three and four conditions as
   `tools/makeReadmePicture.R` does, look at each legend as a reader, and draw each candidate fix in a scratch copy
   before offering it. Read the legend's own limits first: its canvas is 500 px tall and its rows are spaced 60
   (`stepY`, `R/drawPedigreeDiagram.R`, the long comment above `stepY = 60L`); new rows may not fit.
4. Pre-RED picker (the fix's shape and the drift choice), then RED, GREEN, REFACTOR, each gate an `AskUserQuestion`
   (`CLAUDE.md` "Phase-gate format").

### Gotchas
- **The stale pedkindraw 0.0.1 in renv's library** (`methodology/BACKLOG.md:92`) still runs whenever
  `library(pedkindraw)` is called without installing first. Recipe: `git archive HEAD | tar -x -C <tree>`; then,
  each with `env -u RENV_PROJECT R_LIBS=<scratch lib>:<renv lib> R_LIBS_USER=<renv lib>` in front (S26's recipe
  left it off `R CMD INSTALL`, which then stops: "install.packages('quadprog')"), `R CMD build --no-build-vignettes
  --no-manual <tree>`, `R CMD INSTALL --no-docs --library=<scratch lib> <tarball>`, and `Rscript --no-init-file
  ...` (`<renv lib>` from `Rscript -e 'cat(renv::paths$library())'`). Print `find.package("pedkindraw")`.
- **A drawing in a vignette needs `out.width = "100%"`** on its chunk: html_vignette's `fig.width = 3` drew the
  widget 288 px wide, the legend's labels cut and no ids shown. At 700 px about 22 animals still read; 36-37 do
  not (S27's trial pages). 16c has several drawings.
- **chromote:** `selector = "html"` for a whole page, not `".html-widget"` or `".visNetwork"`: both crop at the
  widget's 500 px box, and the id box plus the 475 px canvas overflow it, so the bottom row's labels and the export
  button are cut. For a part of a long page use `cliprect` around the widget's bounding box. Set
  `Emulation$setDeviceMetricsOverride(deviceScaleFactor = 2)` before `go_to()` (`tools/makeReadmePicture.R:40`).
- **The drawing's live network** is `document.getElementById('graph' + w.id).chart` for a `.visNetwork` element
  `w` (`tests/testthat/helper-live-render-positions.R:166`); the nodes R passed are in the page's
  `script[data-for=<w.id>]` JSON (`x.nodes.id`). S27's check of "every node shown": each passed node placed and,
  through `canvasToDOM()`, inside the canvas; it failed when `moveTo({scale: 4})` zoomed in.
- **The legend's last row** ("?", UZ twins) touches the "Export Diagram (PNG)" button on S27's page; the copied
  drawing's own layout, seen, not changed. The legend item's new rows will make this worse unless measured.
- **`makePedigreeMatingLayout()` on all 375 animals** warns "72 same-row edge-node collision(s) could not be fully
  resolved" (1.8 s); 16c's colony-size drawing would print it (`methodology/BACKLOG.md:11`).
- **`.lintr` excludes `vignettes`** (and `tests`, `inst/extdata`): `lint_package()` reads `R/` only; vignette
  code is checked by its render and its claims chunks.
- **Words:** sire, dam, mate, mating; kinship2's `father` and `mother` appear only as its column names in code.
- **zsh:** `echo =====` fails (S27 hit it again); keep each shell command to one check (Mark, S23). An `echo
  "exit $?"` after a pipe prints the last command's status, not the script's: run the script alone for its status.
- **Another Claude session may run R checks at the same time** (nprcgenekeepr's sessions; its S1174 was running at
  S27's close): `ps` and `lsof -d cwd`.
- **`CLAUDE.md` is over its 28,000 B budget** (30,795 B; S23-S27 added nothing).
- **Left for Mark:** `pedkindraw.Rproj` untracked at the root (`.Rbuildignore:6` keeps it out of the build).
- **Times on this Mac (S27):** the vignette renders in 1.6 s; `R CMD build` 7 s; `R CMD check --as-cran` 178 s
  (tests 122 s); the suite 4.6 min; the gate run 4.8 min; CI ~15 min.

### Key files
- `R/affectedConditions.R:98` (`.conditionSectionsHandler()`); `R/drawPedigreeDiagram.R:134` (`conditionRows`),
  `:152` (`legendNodes`), `:172` (`afterDrawing`).
- `methodology/BACKLOG.md:11` (16c-16e, with S27's notes), `:26` (legend), `:36` (gap document), `:46` (coverage),
  `:92` (the stale copy).
- `docs/planning/standalone-pedigree-package-plan.md:47` (Next), `:737` (Phase 16), `:774` ("Done 16b").
- `docs/planning/documentation-plan.md:158` (S27's notes under 5.3), `:162` (5.4, the drawing vignette), `:248`
  (16c's DONE), `:304` (D3 answered).
- `vignettes/pedkindraw.Rmd`: `:174` (the drawing chunk, `out.width`), `:238` (the claims chunk), `:399` (Where
  next, for 16c and 16d to add their vignettes).

### How You Will Be Evaluated
The user rates every session's handoff. Your handoff will be scored on:
1. Was the ACTIVE TASK block sufficient to orient the next session?
2. Were key files listed with line numbers?
3. Were gotchas and traps flagged?
4. Was the "what's next" actionable and specific?

---

## Session History

*Session history accumulates below this line. Newest session at the top.*
*S1-S26's entries were removed in S3-S27 (FM #28): their durable records are the receipts in `HANDOFFS.md` and the
entries in `CHANGELOG.md`.*

### What Session 28 Did
**Deliverable:** the legend item (`methodology/BACKLOG.md:26`): the drawing's legend explains the sections of a
symbol with two or more conditions (`R/drawPedigreeDiagram.R`, `R/affectedConditions.R`, copied from nprcgenekeepr;
`methodology/workstreams/DEVELOPMENT_WORKSTREAM.md`); TDD with the three gates, the drift-rule choice at the pre-RED
picker (IN PROGRESS)
**Started:** 2026-11-16 02:51 CST · **Model:** Claude Opus 5.5 · **Mark's pick:** "Legend fix (Recommended)"
(orient)
**Status:** Session claimed. Work beginning.
**Ledger:** `CHANGELOG: pending` — the claim commit's `CHANGELOG.md` entry says (in progress); Phase 3F records the
rest. Until close-out, this line is the crash breadcrumb for the next session's reconcile.

### Session 26 Handoff Evaluation (by Session 27)
**Score: 9/10.**
- **What helped:** the steps in order (measure candidates before the picker, look as a reader, one condition or
  none, checks computed first and shown failing); the stale-copy gotcha and the scratch-install recipe (every render
  and picture ran against the current tree); chromote's device scale; the M7 method; the zsh gotcha; every line
  cited was right (re-checked at `455d452`: `documentation-plan.md:105`, `:106`, `:148`, `:232`, `:304`; the
  contract's `:248`; `README.Rmd:92`; `R/pedkindraw-package.R:42`; `BACKLOG.md:11`, `:20`, `:30`, `:40`, `:86`).
- **What was missing:** that html_vignette's `fig.width = 3` draws a widget 288 px wide (found on the first trial
  page); that `".visNetwork"` crops like `".html-widget"`.
- **What was wrong:** the recipe put the `env` line only on `Rscript`; `R CMD INSTALL` without it stopped
  ("install.packages('quadprog')"). One minute.
- **ROI:** high.

### What Session 27 Did
**Deliverable:** plan Phase 16b, the getting-started vignette and the example file; TDD phase none
(documentation), checks first. DONE.
**Started:** 2026-11-15 23:05 CST · **Model:** Claude Opus 5.5 · **Mark's picks:** "Vignette 16b (Recommended)"
(orient); "C: ED5PDV, 16 animals (Recommended)" (D3).
**Commits:** claim `6397dc4`; `2da3cb3` (DESCRIPTION Suggests knitr and rmarkdown and `VignetteBuilder: knitr`, the
contract's section 5, R80's two files in `inst/extdata/`, `.gitignore`); `d0068a7` (`vignettes/pedkindraw.Rmd`,
`R/pedkindraw-package.R`, `man/pedkindraw-package.Rd`); pushed `cd0b787..d0068a7` (5 commits); close-out 1 (plan,
documentation plan, ROADMAP, BACKLOG) and close-out 2 (notes, receipt, ledger), not pushed.
**Verified:** five candidate trims drawn on trial html_vignette pages in headless Chrome at the page's width
(16-37 animals; 36-37 unreadable), three shown to Mark; `renv::snapshot(dev = TRUE)` "already up to date", the lock
unchanged, gate 0; both CSVs `cmp` equal to nprcgenekeepr's at `baef1e12c`; every stated value computed in a scratch
run before the text (it corrected two shrink sentences: 3 of the 4 "non-informative" animals had offspring, and the
last step's 214 removals include 143 ungenotyped animals); the claims chunks stopped a render with one value
changed (29 to 30; 14 to 15); rendered in 1.6 s, and with kinship2 and Pedixplorer absent (their chunks ran
nothing); on the scratch page and on the built page from `R CMD build`, all 51 layout nodes placed and inside the
canvas (exit 0; exit 1 when zoomed to 4x); the page looked at, every mark explained by the legend or the text;
suite 52 files, 676 tests, 0 failed, 0 skipped, WARN 0, 5,929 passed; lint 0; roxygen changed only
`man/pedkindraw-package.Rd`, then idempotent; words gate 0; `R CMD check --as-cran` on `d0068a7`: 1 NOTE (R16's
Maintainer and New submission only), "re-building of vignette outputs ... OK", "installed package size ... OK"
(2,236 KB); drift tool 90 functions, 3 differ, 0 without a row; `quality_ratchet.py --run` 5/5 pass, results
`5ddbb5b1aeb3`, manifest `01151c525b8a` (head `d0068a7`); CI run `43810961086`: 5/5 `Status: OK` at the first
attempt, 14 min, "re-building of vignette outputs ... OK" and "installed package size ... OK" on each, `FAIL 0 |
WARN 0` (macOS PASS 5929, Windows 5928 SKIP 1, Ubuntu devel, release and oldrel-1 5918 SKIP 2: S26's counts).
**Self-assessment: 8/10.**
+ The drawing chosen by measuring candidates at the page's real width, which found the 288 px trap before any
  vignette text existed; every stated value held by a check shown able to fail, and the shrink text corrected by
  measuring what each step removed rather than paraphrasing the help page; DONE item 4's "every node shown"
  measured, not eyeballed, with a negative control.
- Two slips: a scratch script wrote `x.rds` one folder above the repository through a bad relative path (removed
  at once, my own file); and `echo =====` in zsh again despite the gotcha. The first claims draft had a muddled
  `||` check, rewritten before the commit.
**Learnings:** no `CLAUDE.md` row (over its budget); in the Gotchas above: `out.width = "100%"` for a vignette
drawing; chromote's widget selectors crop; reading the live vis.js network; the recipe's `env` on every step.
**Ledger:** `CHANGELOG.md` S27 entries (the session and its push).
