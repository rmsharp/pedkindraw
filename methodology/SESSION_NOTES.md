# Session Notes

**Purpose:** Continuity between sessions. Each session reads this first and writes to it before closing out.

**This file is transient — it is overwritten every session** (*"what's next, what traps?"*).
The cumulative, append-only record of *what was done, ever* lives in `CHANGELOG.md`; the commit SHA is the shared key.
At close-out, distill the durable outcome into a `CHANGELOG.md` entry — do not copy this handoff into it.

---

## ACTIVE TASK
**Task:** **Plan Phase 16: documentation**, a planning session, not an implementation (`methodology/BACKLOG.md:11`;
the plan's "Phase 16 -- Documentation" at `docs/planning/standalone-pedigree-package-plan.md:730`, one line of
scope and no DONE criteria; its "Phases 11-15" table at `:531` stops at 15). The orient picker asks Mark: this,
**tests for full coverage** (`methodology/BACKLOG.md:22`, 43 of 2,501 statements missed), or hold.
**Status:** READY. Phase 15 DONE (S24, 15c: claim `37f4381`, RED `9a0964a`, GREEN `593c9a8`, contract `6887b8b`,
REFACTOR `bcdc1b0`, close-out 1 `7f6a513`); suite 676 tests, 5,929 expectations, 0 failed, WARN 0, SKIP 0; drift
tool 3 differ, all with rows; pushed through `bcdc1b0` (with S23's two close-out commits), CI run `43781542125` 5/5
at the first attempt; S24's two close-out commits are not pushed.
**Plan:** Phase 16 is README, a getting-started vignette, a drawing vignette, a pkgdown site, NEWS, and the Phase
1-2 timing, memory and capacity tables with their dates and machine (`:732`). None exists: no `README*` in the
repository (the dashboard's one risk flag, "README is missing or insufficient"), no `vignettes/`, no `NEWS.md`;
`DESCRIPTION:25` Suggests has no knitr or rmarkdown and there is no `VignetteBuilder`.
**Session boundary:** one planning session (`methodology/SESSION_RUNNER.md` "Planning Sessions": deepest reasoning
mode, evidence inventory, per-phase DONE criteria with verification commands and surface, each build session a STOP).
The plan document is the deliverable; writing a README or vignette in the same session is FM #18.
**Priority:** HIGH (the plan's next phase).

### What You Must Do
1. Orient; drift tool (expect 3 differ, 0 without a row); `git -C ../nprcgenekeepr log --oneline baef1e12c..HEAD --
   R/makePedigreeDiagramData.R R/orderRootSubtrees.R R/positionTreeApportion.R` (Learning 15).
2. Read the plan's Phases 16 and 17 (`:730`, `:735`) and its note on nprcgenekeepr's documentation (`:272`-`:275`:
   its vignettes and `_pkgdown.yml` lines stay there, R8; "the new package writes its own"); the contract's section 5
   (`docs/planning/pedkindraw-api-contract.md:248`; Suggests "what the vignettes need (Phase 16)") and section 7
   (`:278`, the performance budget); the comparison doc's timing sections, 7 (`docs/research/
   pedigree-package-comparison-2026-11.md:424`) and 9 (`:647`); `NAMESPACE` (the exports a getting-started vignette
   walks through) and each export's help example.
3. Inventory by search, not memory (`SESSION_RUNNER.md` Evidence-Based Inventory; Learning 6): every export, which
   ones a vignette must show (the drawing path is `asPedFrame()` or a data frame, `findGeneration()`,
   `makePedigreeMatingLayout(hints = )`, `drawPedigreeDiagram()`), where each timing number lives, and nprcgenekeepr's
   own README, vignettes and `_pkgdown.yml` for their shape only (R8: nothing copied unless ruled).
4. Measure before the picker (Learning 17): a scratch vignette that draws one pedigree with `drawPedigreeDiagram()`,
   built with `rmarkdown` in a scratch tree, for its HTML size and build time (a visNetwork widget embeds its
   JavaScript; CRAN watches package size), and `R CMD check --as-cran` on a tarball with it (the CI already sets up
   pandoc, `.github/workflows/R-CMD-check.yaml:42`). Likely picker questions, a guess: where the pkgdown site lives
   (GitHub Pages or not; outward-facing, Mark's call), how many sessions, the vignettes' titles and contents, NEWS's
   first version.
5. Write the plan under `docs/planning/`, record rulings in the plan's section 2 (R77 on), update the status block,
   ROADMAP and BACKLOG; close out.

### Gotchas
- **Words:** user-facing documentation and code say sire, dam, mate, mating, never husband or wife (Mark, S23;
  gate `user-facing-sire-dam-words` counts them in `R/` and `man/`; vignettes and README are user-facing too, though
  the gate does not yet read them). kinship2's and Pedixplorer's help pages say spouse and marriage: translate.
- **`asPedFrame()`'s `ped` has no `gen` column** and `makePedigreeMatingLayout()` requires one: any example or
  vignette adds `x$ped$gen <- findGeneration(x$ped$id, x$ped$sire, x$ped$dam)` first (S24 found it in the tests).
- **Automatic hints warn:** kinship2's `autohint()` and Pedixplorer's `auto_hint()` warn "Unexpected result in
  autohint, please contact developer" on some pedigrees (29 warnings over 100 random family pedigrees, for each
  package) and still return
  hints; `autohint()` stops with "autohint bug 3" on others; `auto_hint()` refuses a Pedigree with more than one
  family. A vignette showing them must pick a pedigree where they are quiet.
- **Pedixplorer's `align()` fails quietly:** with some spouse hints its quadratic program prints "constraints are
  inconsistent, no solution!" to stderr and returns a drawing with animals missing. Count a drawing as returned
  only when every animal appears (`asPedFrameHintsAligned()` in `tests/testthat/test_asPedFrameHints.R`).
- **Pedixplorer's `Pedigree(hints = )`** takes a list (`list(horder = , spouse = )`); a `Hints()` object passed
  there failed ("got class nonstandardGenericFunction").
- **renv:** install knitr, rmarkdown or pkgdown by Learning 3's recipe (dated repository set first, `rebuild =
  TRUE`, every new dependency by name, `renv::snapshot(dev = TRUE)`), then run the gate
  `renv-lock-no-latest-repository`. That is build work, not the planning session's.
- **zsh:** `( a; b & )` runs `a` in the foreground; put `&` on each command and `wait`. Keep each shell command to
  one check (Mark rejected a compound one in S23).
- **Another Claude session may run R checks at the same time** (nprcgenekeepr's sessions run beside this one; it
  moved from `f33802236` to `c028cd16a` during S24): `ps` and `lsof -d cwd` show whose runs they are.
- **The scratch-tree recipe:** `git archive HEAD | tar -x -C <tree>`, edit there, then `env -u RENV_PROJECT
  R_LIBS=<lib> R_LIBS_USER=<lib> NOT_CRAN=true Rscript --no-init-file ...` from `<tree>`; `<lib>` from
  `Rscript -e 'cat(renv::paths$library())'`. `R CMD check --as-cran` runs from a scratch folder (from the root it
  stops at "CRAN incoming feasibility").
- **`CLAUDE.md` is over its 28,000 B budget** (30,795 B; S23 and S24 added nothing).
- **Left for Mark:** `pedkindraw.Rproj` is untracked at the root (RStudio's; `.Rbuildignore:6` keeps it out of the
  build, `.gitignore` names only `.Rproj.user`): commit it, ignore it or delete it is his call;
  `~/Library/Caches/org.R-project.R/R/renv/library/tree-86aa6c47` (S19's, harmless).
- **Times on this Mac (S24):** `test_asPedFrameHints.R` ~33 s (its two random-pedigree tests ~25 s,
  `skip_on_cran()`); suite ~3 min; fidelity tool ~4 min; `covr` ~5 min; `R CMD check --as-cran` ~5 min; CI ~15 min.

### Key files
- `docs/planning/standalone-pedigree-package-plan.md`: `:44` the status's Next, `:183`-`:185` R74-R76 (the last
  rulings; the next is R77), `:531` the "Phases 11-15" table, `:700` "Done 15c", `:725` "Done 15", `:730` Phase 16,
  `:735` Phase 17, `:746` section 5 (the drift rule), `:272`-`:275` nprcgenekeepr's documentation stays there.
- `docs/planning/pedkindraw-api-contract.md`: `:248` section 5 (dependencies, Suggests), `:278` section 7
  (performance budget, the timing tables' summary).
- `docs/research/pedigree-package-comparison-2026-11.md`: `:424` section 7 (timing, memory, capacity), `:647`
  section 9 (drawing time and readability), `:776` section 10 (what pedkindraw offers that the others do not: a
  README's first paragraph).
- `DESCRIPTION:25` (Suggests); `NAMESPACE` (the exports); `.github/workflows/R-CMD-check.yaml:42` (pandoc).
- `methodology/BACKLOG.md:11` (the Phase 16 item), `:22` (tests for full coverage).
- The drawing path's code, for a vignette: `R/asPedFrame.R:176` (`asPedFrame()`; `:416` its kinship2 hints,
  `:496` the mate-row fixes), `R/layoutHints.R:25` (`.checkLayoutHints()`; `:186`-`:216` the rules it shares with
  the converter), `R/makePedigreeDiagramData.R:1742` (`makePedigreeMatingLayout()`),
  `R/drawPedigreeDiagram.R:66` (`drawPedigreeDiagram()`).

### How You Will Be Evaluated
The user rates every session's handoff. Your handoff will be scored on:
1. Was the ACTIVE TASK block sufficient to orient the next session?
2. Were key files listed with line numbers?
3. Were gotchas and traps flagged?
4. Was the "what's next" actionable and specific?

---

## Session History

*Session history accumulates below this line. Newest session at the top.*
*S1-S23's entries were removed in S3-S24 (FM #28): their durable records are the receipts in `HANDOFFS.md` and the
entries in `CHANGELOG.md`.*

### Session 23 Handoff Evaluation (by Session 24)
**Score: 9/10.**
- **What helped:** the five ordered steps became this session's sequence, and step 3's measurements decided the
  picker; every line cited was right at `1eab72c` (`R/asPedFrame.R:137`, `:152`, `:158`, `:164`;
  `R/layoutHints.R:109`; contract `:202`); the gotchas on Pedixplorer's `horder` and ordered-factor anchor and on
  kinship2 needing an order with a spouse hint; the scratch-tree recipe and "prove GREEN equal to the prototype",
  used as written; "one check per shell command".
- **What was missing:** that `makePedigreeMatingLayout()` needs a `gen` column `asPedFrame()` does not return; how
  Pedixplorer's `align()` fails (stderr, a drawing with animals missing), which S23's own "Done 15b" touched; that
  both packages' automatic hint functions warn (not foreseeable without running them).
- **What was wrong:** the gotcha named `Hints()`: passed to `Pedigree(hints = )` it fails, the list form works
  (minor). Step 3's guessed picker questions matched two of the three asked (the third, unreadable kinship2 hints,
  came from measuring, as the step said it might).
- **ROI:** high.

### What Session 24 Did
**Deliverable:** plan Phase 15c, the converters pass hints on: `asPedFrame()` returns `list(ped, twinRelations,
hints)`, strict TDD; rulings R74-R76; Phase 15 DONE.
**Started:** 2026-11-15 17:14 CST · **Model:** Claude Opus 5.5 · **Mark's picks:** "Phase 15c: converters
(Recommended)" (orient); "Fix them, say so", "Stop, naming it", "Read as for a pedigree" (pre-RED, each the
recommended option); "Yes, proceed" at RED, GREEN and REFACTOR.
**Commits:** claim `37f4381`; RED `9a0964a`; GREEN `593c9a8`; contract `6887b8b`; REFACTOR `bcdc1b0`; pushed (with
S23's close-out commits); close-out 1 `7f6a513` and close-out 2 after, not pushed.
**Verified:** kinship2's and Pedixplorer's hints measured on 212 pedigrees before the picker (user-set and automatic;
`autohint()` on 143, 40 refused by the layout; `auto_hint()` on 119, 50 refused; with the fixes all 262 converted
and drew, 1,060 and 898 hinted sides held); drafts on the prototype (41 tests, 1,444 expectations) and against
unchanged HEAD (the 21 failing, nothing else) before RED; GREEN's code equal to the prototype (22 of 22 objects);
suite 676 tests, 0 failed, WARN 0, SKIP 0; lint 0; roxygen changed `man/asPedFrame.Rd` only; coverage
`R/asPedFrame.R` 158 of 158 statements and `R/layoutHints.R` 149 of 149; fidelity 600 of 600 identical; `R CMD
check --as-cran` R16's NOTE only; a hinted kinship2 object converted and drawn by `drawPedigreeDiagram()` (8 of 8
nodes at the layout's x; saved to HTML, not viewed in a browser); CI `43781542125` 5/5 `Status: OK` at the first
attempt, `FAIL 0 | WARN 0` on each.
**Self-assessment: 8/10.**
+ Every pre-RED option stated measured counts and all three were answered at the first try; the automatic hints
  of both packages were measured, not only hand-set ones, which found the 40 and 50 objects the layout would have
  refused; the tests check mate rows against a row-by-row derivation written apart from the code; REFACTOR put
  the converter and the layout's check on one set of rules.
- Slips, each caught before a commit: a `Hints()` object passed to `Pedigree(hints = )`; a first comparison that
  missed Pedixplorer's stderr failure and compared the founder couples with `identical()` instead of S22's
  shared-animal check (both found by printing rows); an assertion of my own tripped by a placeholder `99999L`; a
  status line citing a "row 16" the plan does not have (found by grep before commit). The GREEN suite ran before
  three lint-only edits (covr's and `R CMD check`'s runs of every test after them passed; the commit says so).
**Learnings:** no `CLAUDE.md` row (over its budget); for Learning 19's kind, measure another package's automatic
output as well as user-set input, and count its drawing as returned only when complete (in the Gotchas above).
**Ledger:** `CHANGELOG.md` S24 entries.
