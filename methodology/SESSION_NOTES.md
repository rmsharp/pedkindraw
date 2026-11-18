# Session Notes

**Purpose:** Continuity between sessions. Each session reads this first and writes to it before closing out.

**This file is transient — it is overwritten every session** (*"what's next, what traps?"*).
The cumulative, append-only record of *what was done, ever* lives in `CHANGELOG.md`; the commit SHA is the shared key.
At close-out, distill the durable outcome into a `CHANGELOG.md` entry — do not copy this handoff into it.

---

## ACTIVE TASK
**Task:** Phase 17, the CRAN submission, is under way (`docs/planning/cran-submission-plan.md`). 17a-17c DONE
(S33-S37); **17d DONE (S38)**: the "Select by id" box lists the animals only, `.buildMatingUnitForest()` refuses a
real id starting `__jog_`, and the six reserved prefixes are written once (R94). Next: **Phase 17e, the legend's
"Same animal, again" label fits, strict TDD** (plan `:471`; `methodology/BACKLOG.md:26`). After it, 17f (the gaps
document).
**Status:** READY. No work in progress; the tree is clean but `pedkindraw.Rproj` (Mark's).
**The orient picker** (4 options at most, "Other" for hold): 17e (recommended: the plan's next phase), or the
measurement alone if Mark wants to see it before any change.
**Session boundary:** one deliverable. **Priority:** HIGH (the plan's next phase).

### What You Must Do
1. Orient; drift tool (expect 91 functions, **14** differ, 0 without a row: S38 changed two functions that already
   differed); nprcgenekeepr's log on every copied file, `git -C ../nprcgenekeepr log --oneline baef1e12c..HEAD --
   $(grep -l 'Copied from nprcgenekeepr' R/*.R tests/testthat/*.R)`: exactly 4 commits at S38's close
   (`4283e3502`, `a85311021`, `392dd347e`, `471589138`, all already in the copy). nprcgenekeepr moved 4 times during
   S38 (`8659b02ce`, `ae826ccb5`, `110709b65`, `83c50c611`, its S1185 on `getPotentialParents()`), none on a copied
   file.
2. Push S38's close-out commits (`18e4e8a` and close-out 2) with the session's first push: they touch
   `docs/planning/`, so both workflows run. First read `gh run view 44227398574` (on `48e4c92`): at S38's close its
   ubuntu-devel job was still in `setup-r-dependencies` (installing packages, from 03:12 UTC, over 20 min), the
   other 4 `success`; the later run on `7c9e306`, the same code refactored, was 5/5 `success`. If it failed in that
   step, it is CI's setup, not the package; say so in the ledger.
3. **For 17e, measure first** (plan `:471`; Learning 17): the label is `R/drawPedigreeDiagram.R:121`; the legend's
   width is `width = 0.28` (`:236`), with `stepY = 60L` (`:248`). Measure at the website's 776 px widget (S31: its
   legend about 217 px) and the vignette's 700 px column, for both candidates (a shorter label; a wider legend) and
   both edge styles. **An estimate, not measured:** visNetwork draws the legend on a canvas, so the cut text is not
   in the DOM; a check that fails on the cut label likely needs the canvas (the legend network's positions and
   `measureText()` with its font) or a screenshot. Read the vignette as shipped (plan dragon 24); for the website,
   S31's notes (`CHANGELOG.md` S31 entry) say how it read the pkgdown site.
4. The drift choice D3 (plan `:600`) at the pre-RED picker: R81 and R94 both chose "Port later" (a `DIVERGENCE.md`
   row, `:17`, gains a third reason; the fidelity tool would need an allowance only if the label's text or the
   legend's width changes a compared drawing: every drawing has a legend, so measure how many of the 600 results
   change, dragon 23).

### Gotchas
- **The suite now takes 305-312 s here** (S38: 309 s GREEN 1, 311 s REFACTOR, alone and with the fidelity tool
  beside it), over the suite gate's 300 s limit, so `quality_ratchet.py --run` reads it unmeasured: tally WARN by
  hand (`methodology/BACKLOG.md:113` is the item to raise the limit).
- **`Rscript -e` with a backslash** stopped S38's RED tally after it printed (the gotcha S37 left): put any tally in
  a script file. S38's are in the scratchpad, but the pattern is short: `as.data.frame(testthat::test_local(".",
  reporter = "silent", stop_on_failure = FALSE))`, then count `failed > 0`, `error`, `skipped`, `warning`.
- **Shell traps on this Mac:** zsh's `time` prints `total`, not `real` (a wait loop that grepped for `real` never
  ended); `tail -3 a b` with two files fails ("option used in invalid context").
- **A "Select by id" box has one option more than its values:** visNetwork's "Select by id" placeholder (dragon
  24); 375 animals show as 376 options.
- **The fidelity tool now sets aside two things** and prints both: R81's 36 drawings with two or more condition rows,
  and R94's 33 drawings with 3,152 `__jog_` box entries (nprcgenekeepr's side only). Any other count is a change.
- **pedkindraw's half of the fidelity tool runs from a scratch copy** (dragon 23), nprcgenekeepr's does not (dragon
  22): measure a change's effect on the 600 results with `--child` on HEAD and on a draft.
- **Copied code, drift rule (plan section 5, D3):** nprcgenekeepr has the same label (`R/drawPedigreeDiagram.R:90`
  at `2eb3920b0`; unchanged since the copy). pedkindraw's sessions never change nprcgenekeepr (R8).
- **A scratch copy for the suite and the drafts:** `git archive HEAD | tar -x -C <scratch>`, then from it
  `env -u RENV_PROJECT R_LIBS=<lib> R_LIBS_USER=<lib> NOT_CRAN=true RENV_CONFIG_AUTOLOADER_ENABLED=false Rscript
  --no-init-file ...` (`<lib>` is `renv::paths$library()`). S38 wrote its drafts as a Python script of exact
  replacements (each must match once), applied it to scratch copies and then to the repository, and proved the
  files byte-identical (`cmp`).
- **`quality_ratchet.py`** runs as `python3 methodology/quality_ratchet.py --run` from the root; its results file is
  git-ignored; a gate's key is `name`, not `id`.
- **Carried:** `smallPed`'s stored `gen` is wrong in 8 of 17 animals (S38's test finds them again with
  `findGeneration()`); `kinship()` stops on generation numbers out of order, so `makePedigreeMatingLayout()` does too
  unless given a `kinshipMatrix`; render the README after `R CMD INSTALL -l <lib> .`; the sire/dam words gate reads
  `R/`, `man/`, README, NEWS and vignettes; `CLAUDE.md` is over its 28,000 B budget (S23-S38 added nothing:
  learnings go here and in the plan's dragons, 23-24 from S38); no English hunspell dictionary on this Mac; 79
  copied files; the suite gate counts warnings, not failures (tally "0 failed" by hand); `pedkindraw.Rproj`
  untracked, Mark's; a GitHub link can read 503 once in the check (dragon 10): re-run the URL check before acting.
- **`methodology/HANDOFFS.md` nears its trim trigger:** about 175 KB against 196,608 B after S38's receipt
  (`python3 methodology/methodology_trim.py --file methodology/HANDOFFS.md --check`: no trigger at S38's close);
  receipts add about 5-6 KB, so about 3-4 more sessions before it fires (an estimate).
- **Times on this Mac (S38):** suite 309-311 s; `R CMD build` plus `check --as-cran` about 227 s; the fidelity tool
  about 255 s (123 s each package); pedkindraw's `--child` alone 125 s; CI 14-20 min (S37); the site workflow 3 min.

### Key files
- `docs/planning/cran-submission-plan.md:6` (status), `:452` (17d; its Done `:459`), `:471` (17e), `:600` (D3),
  `:643` (9, dragons; 22 `:701`, 23 `:705`, 24 `:710`).
- `docs/planning/standalone-pedigree-package-plan.md:57` (Next), `:216` (R94), `:948` (Done 17d).
- `R/drawPedigreeDiagram.R:121` (the label), `:224` (its comment), `:236` (the legend's `width = 0.28`), `:248`
  (`stepY`), `:298` (the box filter, now `.reservedIdPattern`); `R/makePedigreeDiagramData.R:389`-`:391`
  (`.reservedIdPrefixes`, `.reservedIdPattern`), `:466` (the input check).
- `tests/testthat/test_drawPedigreeDiagram.R:210`-`:225` (S38's box test), `test_buildMatingUnitForest.R:82`-`:102`
  (S38's check test).
- `tools/compareResultsWithNprcgenekeepr.R:453` (the drawing case), `:726` (`withoutConditionSymbols()`, R81), `:766`
  (`withoutJogSelections()`, R94); `DIVERGENCE.md:16`-`:17` (the two rows); `vignettes/drawing.Rmd:626` (the colony
  drawing); `methodology/BACKLOG.md:26` (17e), `:45` (R94's port item).

### How You Will Be Evaluated
The user rates every session's handoff. Your handoff will be scored on:
1. Was the ACTIVE TASK block sufficient to orient the next session?
2. Were key files listed with line numbers?
3. Were gotchas and traps flagged?
4. Was the "what's next" actionable and specific?

---

## Session History

*Session history accumulates below this line. Newest session at the top.*
*S1-S37's entries were removed in S3-S38 (FM #28): their durable records are the receipts in `HANDOFFS.md` and the
entries in `CHANGELOG.md`.*

### What Session 39 Did
**Deliverable:** Phase 17e, the legend's "Same animal, again" label fits (`docs/planning/cran-submission-plan.md:471`;
R84; `methodology/BACKLOG.md:26`): the label `R/drawPedigreeDiagram.R:121`, the legend's `width = 0.28` `:236`;
measure first; the drift choice D3; strict TDD (IN PROGRESS)
**Started:** 2026-11-17 21:42 CST · **Model:** Claude Opus 5.5 · **Mark's pick:** "Fix the legend label
(Recommended)" (orient picker)
**Status:** Session claimed. Work beginning.
**Ledger:** `CHANGELOG: pending` -- the claim commit's `CHANGELOG.md` entry says (in progress); Phase 3F records the
rest. Until close-out, this line is the crash breadcrumb for the next session's reconcile.

### Session 37 Handoff Evaluation (by Session 38)
**Score: 9/10.**
- **What helped:** every count and citation held: the drift tool (91/14/0), nprcgenekeepr's log (the same 4
  commits), the select box's 571/196 for the vignette's colony and 565/190 with the defaults, smallPed's 2 jogs,
  "11 of 12 pedigrees" (S38's runs: 33 results, 11 pedigrees by 3 drawing cases), and every cited line
  (`R/drawPedigreeDiagram.R:119`, `:290`, `:292`; the tool's `:450`, `:723`; `vignettes/drawing.Rmd:626`;
  `DIVERGENCE.md:17`; `BACKLOG.md:26`, `:36`). Naming the allowance before the picker, the scratch-copy recipe, and
  dragon 22 (I ran the tool from the repository) each saved a detour.
- **What was missing:** the input check at `R/makePedigreeDiagramData.R:452` lists the same prefixes without
  `__jog_` (found by grepping the prefix list; it became half of the deliverable by Mark's pick); and how to do the
  DONE line's Chrome check (S38 built it: dragon 24).
- **What was wrong:** nothing found. The suite's "250-258 s" was S37's time; S38 measured 309-311 s.
- **ROI:** high.

### What Session 38 Did
**Deliverable:** Phase 17d (R94), strict TDD: the "Select by id" box leaves out the `__jog_` routing points, and
`.buildMatingUnitForest()` refuses a real id starting `__jog_`; the six reserved prefixes written once. DONE.
**Started:** 2026-11-17 19:46 CST · **Model:** Claude Opus 5.5 · **Mark's picks**, each at the first asking:
"17d: Select by id (Recommended)" (orient); pre-RED "Box and check (Recommended)" and "Port later (Recommended)";
the gates "Yes, proceed to RED", "Yes, proceed to GREEN", and "Yes, proceed to REFACTOR" (over Claude's
recommendation to skip it).
**Commits:** claim `09a9737` (pushed with S37's close-out 1 and 2: CI `44218384987` 5/5, site `44218384997`);
ruling R94 `2ac5308`; RED `88798f0`; GREEN 1 `21a164e` (the filter and the check); GREEN 2 `e75171e` (the fidelity
tool's `withoutJogSelections()`, two `DIVERGENCE.md` rows); GREEN 3 `48e4c92` (two NEWS bullets); these five pushed
(site `44227398459` success); REFACTOR `7c9e306` pushed (site `44228850623` success); close-out 1 `18e4e8a` (the
plans, ROADMAP, BACKLOG; dragons 23-24) and close-out 2 (these notes, the receipt, the ledger, the 17e citations
`:119` to `:121`), neither pushed.
**CI:** R-CMD-check `44228850631` on `7c9e306` (REFACTOR, the final code) 5/5 `success` (15 min). R-CMD-check
`44227398574` on `48e4c92` (GREEN 3): 4/5 `success`; ubuntu-devel still in `setup-r-dependencies` at close (from
03:12 UTC, over 20 min; no package check had started). Not cancelled.
**Measured before RED** (scratch copies): smallPed's rectilinear layout 19 box entries, 2 `__jog_`; the colony 571,
196; an animal named `__jog_1_a` passes the check, and smallPed with B renamed `__jog_1_a` gives two nodes of that
id, no error; the colony box in headless Chrome 572 options; both RED variants (exactly the 2 new blocks fail); the
whole suite on the draft (705 blocks, 0 failed, WARN 0); pedkindraw's own fidelity runs on HEAD and the draft (33 of
600 differ, only by 3,152 `__jog_` entries; 600 identical without them); the draft's colony box in Chrome, 376.
**Verified:** RED 2 failed of 705, 0 errors, WARN 0; GREEN and REFACTOR suites 705 blocks, 0 failed, 0 errors, WARN
0 (309 s, 311 s); lint 0; roxygen unchanged; every changed statement reached by the tests (`covr::file_coverage`:
the filter 21 times, the check 46, 46 and 7); drift tool 91, 14 differ, 0 without a row; fidelity tool exit 0
against nprcgenekeepr at `110709b65` (GREEN 2) and `83c50c611` (REFACTOR), 600 of 600, the two allowances' counts as
measured; REFACTOR's before/after record (14 ids' check results and messages, 5 drawings serialized whole)
identical; `R CMD check --as-cran` R16's NOTE only on `48e4c92` and on `7c9e306`; the shipped vignette (from each
build's tarball) in headless Chrome, the colony box 376 options, no `__` entry.
**Self-assessment: 9/10.**
+ Found the related bug by grepping the prefix list rather than trusting the plan's one-line scope, measured it, and
  put it to Mark with counts. Every picker stated measured results; the repository's changes were the measured
  drafts, proved byte-identical; RED, GREEN and the fidelity counts came out exactly as measured. The DONE line was
  checked on the vignette as shipped, for both builds, and the check was re-run after REFACTOR changed code. My own
  edits' stale citations (`:119`) were fixed (Learning 7).
- Slips, none in a commit: RED's tally used `Rscript -e` with a backslash, the trap S37's notes named (the tally
  printed; the failing blocks were named by a second run); a wait loop grepped for zsh's missing `real`; a wrapper
  used `tail` with two files. I recommended skipping REFACTOR; Mark chose it, and it was done with a before/after
  record.
**Learnings:** no `CLAUDE.md` row (over budget); the plan's dragons 23-24; the Gotchas above.
**Ledger:** `CHANGELOG.md` S38 entries (the session, push 1, push 2, push 3).
