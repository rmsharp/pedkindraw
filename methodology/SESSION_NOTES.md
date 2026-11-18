# Session Notes

**Purpose:** Continuity between sessions. Each session reads this first and writes to it before closing out.

**This file is transient — it is overwritten every session** (*"what's next, what traps?"*).
The cumulative, append-only record of *what was done, ever* lives in `CHANGELOG.md`; the commit SHA is the shared key.
At close-out, distill the durable outcome into a `CHANGELOG.md` entry — do not copy this handoff into it.

---

## ACTIVE TASK
**Task:** Phase 17, the CRAN submission, is under way (`docs/planning/cran-submission-plan.md`). 17a-17d DONE
(S33-S38); **17e DONE (S39)**: the legend's four lines have no arrowheads and each label sits on white, so "Same
animal, again" reads whole (R95). Next: **Phase 17f, the gaps document** (plan `:496`; `methodology/BACKLOG.md:58`):
a dated document under `docs/research/` listing what kinship2 or Pedixplorer can do that pedkindraw cannot, each
gap shown on a typed case; then Mark's D4 picker (plan `:617`: which gaps, if any, close before the release).
**Status:** READY. No work in progress; the tree is clean but `pedkindraw.Rproj` (Mark's).
**The orient picker** (4 options at most, "Other" for hold): 17f (recommended: the plan's next phase). It is a
research document, not package code: S31's documentation sessions declared "TDD phase none"; no RED/GREEN gates,
but the D4 picker at its end.
**Session boundary:** one deliverable (the document and D4's answer; closing a gap is a later phase each).
**Priority:** HIGH (the plan's next phase).

### What You Must Do
1. Orient; drift tool (expect 91 functions, **14** differ, 0 without a row: S39 changed a function that already
   differed); nprcgenekeepr's log on every copied file, `git -C ../nprcgenekeepr log --oneline baef1e12c..HEAD --
   $(grep -l 'Copied from nprcgenekeepr' R/*.R tests/testthat/*.R)`: exactly 4 commits at S39's close (`4283e3502`,
   `a85311021`, `392dd347e`, `471589138`, all already in the copy). nprcgenekeepr moved during S39 (`ba8e56f32`
   to `7a404df37`, its S1185-S1186 on dates), none on a copied file; its working tree had its own uncommitted work.
2. Push S39's close-out commits (`264742c` and close-out 2) with the session's first push: they touch
   `docs/planning/`, so both workflows run. S39's code push finished before its close: CI `44240187232` 5/5
   `success`, site `44240187166` `success`; nothing of S39's is left running.
3. **17f, research first** (Learnings 18-19; plan dragon 25 applies to documents too: look at a case before
   deciding what it shows): starting points in the backlog item (`methodology/BACKLOG.md:58`): the kinship2 gap
   table (`docs/research/kinship2-feature-gap-analysis-2026-09-20.md`, its 25 kinship2 exports, written for
   nprcgenekeepr before pedkindraw existed: re-check each row against pedkindraw's 31 exports); the comparison
   study's section 10 (`docs/research/pedigree-package-comparison-2026-11.md`: no SVG or PDF export, no fitted view
   of a large pedigree that shows ids); Pedixplorer has no gap table yet (its exports and help). Both are in renv:
   kinship2 1.9.6.2, Pedixplorer 1.8.0. Each case in `tryCatch()` under a time limit, one process per case
   (`timeout 15 Rscript case.R <name>`), as Learning 19 says; the document's claims cover the cases run.
4. A framing picker before filling the document (memory "framing before filling"): its outline and how a gap is
   shown; then D4 at the end, in plain words (Learning 2), one option per gap group at most four.

### Gotchas
- **The suite now takes 273-297 s here** (S39: 273 s GREEN 1, 276 s REFACTOR, 274 s RED; 294 s with the fidelity
  child beside it). `quality_ratchet.py --run` measured all 5 gates in 297 s, 3 s under the suite gate's 300 s
  limit: one slow run and it reads unmeasured again (`methodology/BACKLOG.md:116`, raise the limit in a commit of
  its own). Tally by hand with a script file (`as.data.frame(testthat::test_local(".", reporter = "silent",
  stop_on_failure = FALSE))`), never `Rscript -e` with a backslash.
- **The fidelity tool now sets aside three things** and prints each: R81's 36 drawings with two or more condition
  rows, R94's 33 drawings with 3,152 `__jog_` box entries (nprcgenekeepr's side), and R95's 120 drawings whose
  legend lines carry `arrows` `""` and `font.background` `"#FFFFFF"` (pedkindraw's side, in the 48 drawing-case
  results). Any other count is a change. Since S39's REFACTOR the three walk the results through `eachDrawing()`.
- **The drawing results are 48 of the 600** (12 pedigrees by 4 cases: `drawPedigreeDiagram`, `drawTwins`,
  `drawColumns`, `drawEmpty`), holding 120 drawings; S38's "33" counted only the drawings with `__jog_` points.
- **Browser checks** (plan dragons 24-26): read positions from vis.js (`labelModule.size`, `canvasToDOM()`), which
  agree with the canvas pixels; a chromote screenshot shifts a legend row about 30 px. Never pipe a chromote script
  into `head`. Use `chromote::default_chromote_object()` in a variable before setting `$default_timeout` (assigning
  through the call fails: "invalid (NULL) left side of assignment").
- **Shell traps on this Mac:** an `rm -rf "$S/$d"` with shell variables is refused by Claude Code's safety check
  (write `"${S:?}"/"${d:?}"`, or make fresh folders and skip the removal); zsh's `time` prints `total`, not `real`;
  `tail -3 a b` with two files fails; `tail -N` after an R run can drop the line you want behind "Loading required
  namespace: Matrix".
- **A scratch copy for the suite and the drafts:** `git archive HEAD | tar -x -C <scratch>`, then from it
  `env -u RENV_PROJECT R_LIBS=<lib> R_LIBS_USER=<lib> NOT_CRAN=true RENV_CONFIG_AUTOLOADER_ENABLED=false Rscript
  --no-init-file ...` (`<lib>` is `renv::paths$library()`). The fidelity tool's parent runs from the repository
  (dragon 22); a scratch copy of the tool run from the repository's folder changes only the parent's code (S39's
  REFACTOR proof: one raw dump, both versions' set-aside sections evaluated on it).
- **Carried:** `smallPed`'s stored `gen` is wrong in 8 of 17 animals (find it again with `findGeneration()`, or
  `makePedigreeMatingLayout()` stops); `kinship()` stops on generation numbers out of order; render the README after
  `R CMD INSTALL -l <lib> .`; the sire/dam words gate reads `R/`, `man/`, README, NEWS and vignettes; `CLAUDE.md` is
  over its 28,000 B budget (S23-S39 added nothing: learnings go here and in the plan's dragons, 25-26 from S39); no
  English hunspell dictionary on this Mac; 79 copied files; `pedkindraw.Rproj` untracked, Mark's; a GitHub link can
  read 503 once in the check (dragon 10).
- **`methodology/HANDOFFS.md` nears its trim trigger:** 180,183 B against 196,608 B after S39's receipt
  (`python3 methodology/methodology_trim.py --file methodology/HANDOFFS.md --check`); receipts add about 5-6 KB, so
  about 3 more sessions before it fires (an estimate).
- **Times on this Mac (S39):** suite 273-297 s; `R CMD build` plus `check --as-cran` 183 s; the fidelity tool
  219-225 s (about 100-105 s each package); pedkindraw's `--child` alone about 121 s; the site workflow 3 min
  before S39, 23 min on S39's code push (package setup); CI 39 min on that push (one job's package setup).

### Key files
- `docs/planning/cran-submission-plan.md:6` (status), `:471` (17e, its Done `:479`), `:496` (17f), `:616` (D3),
  `:617` (D4), `:659` (9, dragons; 25 `:730`, 26 `:737`).
- `docs/planning/standalone-pedigree-package-plan.md:58` (Next), `:217` (R95), `:957` (Done 17e).
- `R/drawPedigreeDiagram.R:122` (the legend's line table), `:133`-`:134` (R95's two columns), `:246` (the legend's
  width), `:258` (`stepY`), `:308` (the box filter).
- `tests/testthat/test_drawPedigreeDiagramLegendLines.R:42` (the columns), `:82` (the browser test; its reader
  `.legendLinesJs` `:68`).
- `tools/compareResultsWithNprcgenekeepr.R:720` (`eachDrawing()`), `:745` (R81), `:777` (R94), `:805` (R95);
  `DIVERGENCE.md:17` (the `drawPedigreeDiagram()` row); `methodology/BACKLOG.md:47` (R95's port item), `:58` (17f).
- For 17f: `docs/research/kinship2-feature-gap-analysis-2026-09-20.md`,
  `docs/research/pedigree-package-comparison-2026-11.md` (section 10), `NAMESPACE` (pedkindraw's exports).

### How You Will Be Evaluated
The user rates every session's handoff. Your handoff will be scored on:
1. Was the ACTIVE TASK block sufficient to orient the next session?
2. Were key files listed with line numbers?
3. Were gotchas and traps flagged?
4. Was the "what's next" actionable and specific?

---

## Session History

*Session history accumulates below this line. Newest session at the top.*
*S1-S38's entries were removed in S3-S39 (FM #28): their durable records are the receipts in `HANDOFFS.md` and the
entries in `CHANGELOG.md`.*

### Session 38 Handoff Evaluation (by Session 39)
**Score: 9/10.**
- **What helped:** every count and citation held: the drift tool (91/14/0), nprcgenekeepr's log (the same 4
  commits), the label `R/drawPedigreeDiagram.R:121`, the width `:236`, `stepY` `:248`, plan `:471` and `:600`, the
  widths (the website's 776 px widgets, all 12 measured live; the shipped vignettes' drawings 700 px). Its estimate
  that the legend is a canvas needing vis.js's own text measure was right (`labelModule.size`). The scratch-copy
  recipe, dragon 23's `--child` and the gotchas on `Rscript -e` and `tail` saved detours.
- **What was missing:** nothing a reader could have known; the cause (visNetwork's default arrowhead on legend
  lines) was unknown to S31, the plan and S38, all of which framed the fix as "a shorter label or a wider legend".
  S38 said "measure first", which is what found it.
- **What was wrong:** nothing in the handoff; the CI run it named finished 5/5 `success`.
- **ROI:** high.

### What Session 39 Did
**Deliverable:** Phase 17e (R95), strict TDD: the legend's four lines are drawn without arrowheads and each label on
white, so "Same animal, again" reads whole. DONE.
**Started:** 2026-11-17 21:42 CST · **Model:** Claude Opus 5.5 · **Mark's picks**, each at the first asking: "Fix
the legend label (Recommended)" (orient); pre-RED "No arrowheads, white label (Recommended)" and "Port later
(Recommended)"; the gates "Yes, proceed to RED", "Yes, proceed to GREEN", and "Yes, proceed to REFACTOR" (over
Claude's recommendation to skip it).
**Commits:** claim `fe82f69` (pushed with S38's close-out 1 and 2: CI `44232368509` and site `44232368399`
`success`; S38's CI run `44227398574` finished 5/5 `success`); ruling R95 `37c41cf`; RED `b35911a`; GREEN 1
`eb1e845` (the two columns); GREEN 2 `fab63a8` (the fidelity tool's `withoutLegendLineStyle()`, the `DIVERGENCE.md`
row); GREEN 3 `f4f5744` (a NEWS bullet); REFACTOR `9505d9d` (`eachDrawing()`); these six pushed together; close-out
1 `264742c` (the plans, ROADMAP, BACKLOG; dragons 25-26) and close-out 2 (these notes, the receipt, the ledger),
neither pushed.
**CI:** R-CMD-check `44240187232` on `9505d9d` (all of S39's code) 5/5 `success` (39 min: ubuntu oldrel-1 about 32 min
in package setup); site `44240187166` `success` (23 min, mostly package setup), Pages `44242867297` `success`.
**Measured before the picks** (scratch copies and headless Chrome): the label is not cut by the legend's width but
covered by the arrowhead `visLegend()` gives each legend line (vis.js: 18 units at the line's end), 5.5 px at 776
px and 10.1 px at 700 px for 0, 1 and 4 conditions; the live website's 12 drawings all 5.5 px; candidates at 776,
700, 600 and 500 px (no arrowheads: whole at all four; "Same animal": covered at 600 and 500; a 35% legend: 1.5 px
clear at 700, covered at 600); labels above their lines crowd "Deceased" (about 2 px at 500 px with 4 conditions),
so not offered; the whole suite on the chosen draft 705 blocks, 0 failed, WARN 0; pedkindraw's own fidelity runs,
48 of 600 results differ, 600 identical with the two columns taken out; the RED file on HEAD (2 + 20 failing
expectations) and on the draft (74 passing).
**Verified:** RED 2 failed of 707, 0 errors, WARN 0; GREEN 1 and REFACTOR suites 707 blocks, 0 failed, 0 errors,
0 skipped, WARN 0; lint 0; roxygen unchanged; `drawPedigreeDiagram()` parsed identical to the measured draft; drift
tool 91, 14 differ, 0 without a row; fidelity tool exit 0 against nprcgenekeepr at `3b8bf9374`, 600 of 600, the
three set-asides' counts as measured, largest kinship difference 0; REFACTOR's before/after record (ours, theirs
and the printed lines from one raw dump) identical; `R CMD check --as-cran` on `f4f5744` R16's NOTE only; the
shipped vignettes (from the build's tarball) in headless Chrome: 12 drawings, 700 px, 48 of 48 line labels whole,
on white, no arrowhead; the live website after the push (site run `44240187166`, Pages `44242867297`), 12 drawings
776 px wide, 48 of 48 the same (before: all 12 covered 5.5 px); `quality_ratchet` 5/5.
**Self-assessment: 9/10.**
+ Looked at the drawing when the first metric said "whole", found the real cause, and measured every candidate at
  four widths before the picker; each picker stated measured counts; the repository's code was the measured draft
  (parsed identical); RED and GREEN came out exactly as measured; the DONE line was checked on the live site before
  and on the shipped vignettes after; REFACTOR was proved on one raw dump rather than two runs.
- Slips, none in a commit: the first check (label inside the canvas) measured the wrong thing, caught by a
  screenshot before any picker (dragon 25); a detour on a screenshot's 30 px shift; an `rm -rf` with shell
  variables refused by the safety check (the folders did not exist; recreated without it); a `| head -1` hang
  (dragon 26); a `tail -2` that dropped the line wanted, run again. I recommended skipping REFACTOR; Mark chose it,
  as in S38 (a memory now records the preference).
**Learnings:** no `CLAUDE.md` row (over budget); the plan's dragons 25-26; the Gotchas above; a feedback memory
(REFACTOR gate preference).
**Ledger:** `CHANGELOG.md` S39 entries (the session, push 1, push 2).
