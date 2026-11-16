# Session Notes

**Purpose:** Continuity between sessions. Each session reads this first and writes to it before closing out.

**This file is transient — it is overwritten every session** (*"what's next, what traps?"*).
The cumulative, append-only record of *what was done, ever* lives in `CHANGELOG.md`; the commit SHA is the shared key.
At close-out, distill the durable outcome into a `CHANGELOG.md` entry — do not copy this handoff into it.

---

## ACTIVE TASK
**Task:** **Phase 16a: README, NEWS and the package help page**, the first of Phase 16's five build sessions
(`methodology/BACKLOG.md:11`; DONE criteria at `docs/planning/documentation-plan.md:221`, the design at `:138`
(5.2) and `:120` (5.1, its files)). The orient picker asks Mark: this, **tests for full coverage**
(`methodology/BACKLOG.md:23`), or hold.
**Status:** READY. Phase 16 planned (S25: claim `3ae3737`, plan `b675df5`, close-out 1 `91df0c9`, close-out 2
after); rulings R77-R80, each Mark's pick of the recommended option. Nothing in `R/`, `man/`, `tests/` or
`DESCRIPTION` changed since `bcdc1b0`. Not pushed: S24's two close-out commits and S25's four (16a's push carries
them; CI's `paths-ignore` skips `methodology/**` and `CLAUDE.md` only, so `docs/planning/` changes start a run).
**Plan:** `README.Rmd` knitted to `README.md` (no `Sys.Date()`), with a still picture of a small typed pedigree made
by `tools/makeReadmePicture.R` (chromote, the plan's M4); `NEWS.md` under `# pedkindraw (development version)`;
`R/pedkindraw-package.R` (`"_PACKAGE"`) for `?pedkindraw`; the gate `user-facing-sire-dam-words` widened to read
`README.Rmd`, `README.md`, `NEWS.md` and `vignettes` too. No function code: the plan's section 5.7 (`:194`) says
these sessions declare "TDD phase: none (documentation)" and write their checks first, unless Mark asks for the TDD
gates (that reading is Claude's, not a ruling; put it in the orient picker's 16a option so Mark sees it).
**Session boundary:** one session. No vignette (16b), no `VignetteBuilder`, no site (16e); the README names no
site URL until 16e.
**Priority:** HIGH (the plan's next session).

### What You Must Do
1. Orient; drift tool (expect 3 differ, all with rows); `git -C ../nprcgenekeepr log --oneline baef1e12c..HEAD --
   R/makePedigreeDiagramData.R R/orderRootSubtrees.R R/positionTreeApportion.R` (Learning 15; nprcgenekeepr was at
   `61dad5d2c` at S25's Orient).
2. Read `docs/planning/documentation-plan.md` sections 2 (`:32`, the exports' six groups), 5.1-5.2, 5.7, 6's
   preamble and 16a (`:204`-`:230`) and 9 (`:298`, D1-D2); the comparison doc's section 10
   (`docs/research/pedigree-package-comparison-2026-11.md:776`) for the README's first paragraph; `DESCRIPTION`'s
   Title and Description (`:3`, `:9`-`:12`); the `drawPedigreeDiagram()` help example (`man/drawPedigreeDiagram.Rd`).
3. Measure before the picker (Learning 17): type two or three candidate pedigrees for the picture (10-20 animals; a
   twin pair, a condition, a deceased animal, a consanguineous mating), make each picture in a scratch tree with M4's
   method (`htmlwidgets::saveWidget()`, then a chromote screenshot), look at each; the picker offers them (D2) and
   the install line (D1).
4. Checks first: widen the gate's command (`methodology/.quality-gates.json:56`) and run `python3
   methodology/quality_ratchet.py --run`; a scratch script that lists `NAMESPACE`'s 31 exports and finds each named
   in `README.md`, run failing before the README exists.
5. Write the files (at most 5 per commit), render `README.Rmd` twice (the second leaves `git status` clean),
   `roxygen2::roxygenise()` (adds `man/pedkindraw-package.Rd` only), `.Rbuildignore` `^README\.Rmd$`.
6. The checks of the plan's section 6; `R CMD check --as-cran` from a scratch folder (it reads `README.md`'s and
   `NEWS.md`'s URLs); push; CI 5/5; the repository's GitHub page viewed in a browser (the picture shows); the
   dashboard's README flag gone.

### Gotchas
- **A stale pedkindraw 0.0.1 sits in renv's library** (built 2026-11-12, before `asPedFrame()`;
  `methodology/BACKLOG.md:69`). Anything that runs `library(pedkindraw)` without installing first loads it: S25's
  trial pkgdown build with `install = FALSE` stopped on "could not find function asPedFrame". Rendering `README.Rmd`
  does the same. devtools and remotes are not in renv (pkgbuild 1.4.8 is), so there is no `build_readme()`: install
  the current tree first (`R CMD INSTALL --no-docs --library=<scratch lib> <tarball>`, that library first in
  `R_LIBS`), or remove the stale copy first (the backlog item; `renv.lock` does not name pedkindraw).
- **URLs:** `R CMD check --as-cran` checks the URLs in `README.md` and `NEWS.md`; a bad one adds to the incoming
  feasibility NOTE, which R16 then fails. No CRAN badges (Phase 17), no site link (16e). The R-CMD-check badge's URL
  answers (the repository is public).
- **The widened gate:** `grep -r` on a path that does not exist yet (`vignettes`) prints to stderr and exits 2;
  check that the ratchet still reads 0 from `wc -l` before relying on it (S25 did not run it).
- **Words:** sire, dam, mate, mating, never husband or wife (Mark, S23), in the README and NEWS too.
- **Single-run times:** the plan's Done records give a prototype's time ("Measured before the pickers") and the
  built function's (in "Checks"); S25 first cited two prototype times as built ones (`checkPedigree()` 0.17 s, built
  0.14 s; `asPedFrame()` 0.022 s, built 0.04 s) and corrected them before commit. Cite the built function's.
- **Scratch-tree recipe:** `git archive HEAD | tar -x -C <tree>`, then `env -u RENV_PROJECT R_LIBS=<lib>
  R_LIBS_USER=<lib> Rscript --no-init-file ...`, `<lib>` from `Rscript -e 'cat(renv::paths$library())'`. Without
  renv active, R's own library is visible (pkgdown 2.2.1 lives there). An environment variable read inside
  `Rscript -e` must be passed on the `env` line (S25 lost a run to an unexported `$S`).
- **zsh:** `echo =====` fails ("= not found"); keep each shell command to one check (Mark, S23).
- **Another Claude session may run R checks at the same time** (nprcgenekeepr's sessions): `ps` and `lsof -d cwd`.
- **`CLAUDE.md` is over its 28,000 B budget** (30,795 B; S23-S25 added nothing).
- **Left for Mark:** `pedkindraw.Rproj` untracked at the root (`.Rbuildignore:6` keeps it out of the build).
- **Times on this Mac (S25):** `R CMD build` with three trial vignettes 8.9 s; `R CMD check --as-cran` 161 s (tests
  111 s); a pkgdown site 34.5 s; a chromote picture 8.7 s; suite ~3 min; CI ~15 min.

### Key files
- `docs/planning/documentation-plan.md`: `:32` section 2 (inventory, the six groups, where the timing numbers live),
  `:92` section 3 (M1-M8; `:102` M3 the site, `:103` M4 the picture), `:120` 5.1 (files by session), `:138` 5.2
  (README), `:194` 5.7 (TDD), `:204` section 6 (checks, surface), `:221` 16a's DONE, `:298` section 9 (D1-D4).
- `docs/planning/standalone-pedigree-package-plan.md`: `:45` the status's Next, `:187`-`:190` R77-R80, `:735` Phase
  16 (its session table), `:751` "Done 16's plan", `:760` Phase 17.
- `methodology/BACKLOG.md:11` (16a), `:18` (16b-16e), `:23` (coverage), `:69` (the stale copy);
  `methodology/.quality-gates.json:56` (the words gate).
- `DESCRIPTION:3` (Title), `:9`-`:12` (Description), `:13` (URL), `:25` (Suggests); `.Rbuildignore:16` (`CLAUDE`),
  `:23` (`^docs$`); `R/drawPedigreeDiagram.R:66`; `R/makePedigreeDiagramData.R:1742`
  (`makePedigreeMatingLayout()`); `docs/research/pedigree-package-comparison-2026-11.md:776` (section 10).

### How You Will Be Evaluated
The user rates every session's handoff. Your handoff will be scored on:
1. Was the ACTIVE TASK block sufficient to orient the next session?
2. Were key files listed with line numbers?
3. Were gotchas and traps flagged?
4. Was the "what's next" actionable and specific?

---

## Session History

*Session history accumulates below this line. Newest session at the top.*
*S1-S24's entries were removed in S3-S25 (FM #28): their durable records are the receipts in `HANDOFFS.md` and the
entries in `CHANGELOG.md`.*

### Session 24 Handoff Evaluation (by Session 25)
**Score: 9/10.**
- **What helped:** the five steps were this session's sequence; every line cited was right (plan `:730`, `:735`,
  `:272`-`:275`; contract `:248`, `:278`; comparison doc `:424`, `:647`, `:776`; `DESCRIPTION:25`;
  `.github/workflows/R-CMD-check.yaml:42`); step 4's scratch vignette, measured for size and with `R CMD check`,
  gave the numbers that decided R77; the scratch-tree recipe worked as written; the gotchas on the `gen` column and
  on both packages' automatic hints went into the plan (section 5.4, risks).
- **What was missing:** that the Phase 1-2 tables timed nprcgenekeepr's code before the clean-room rewrite, and
  that nprcgenekeepr's S1141 re-timed it (its `docs/research/cleanroom-vs-3.0.0-comparison-2026-11.md`), found by
  listing nprcgenekeepr's `tools/pedigreeComparison/results/`; the stale pedkindraw 0.0.1 in renv's library; that
  pkgdown publishes the root's `.md` files (not foreseeable without building).
- **What was wrong:** nothing found wrong. Of the guessed picker questions, one of the four asked matched (where the
  site lives); "how many sessions" became plan structure and "NEWS's first version" Phase 17's; the other three
  asked (vignette size, the timing source, example data) came from measuring.
- **ROI:** high.

### What Session 25 Did
**Deliverable:** the plan for plan Phase 16, documentation: `docs/planning/documentation-plan.md` (new), rulings
R77-R80 in the plan's section 2, the plan's status and Phase 16 section; a planning session, nothing built.
**Started:** 2026-11-15 19:56 CST · **Model:** Claude Opus 5.5 · **Mark's picks:** "Plan the documentation
(Recommended)" (orient); "Live drawings in both", "GitHub Pages", "Summarize the records", "Ship one example file"
(the plan's picker, each the recommended option).
**Commits:** claim `3ae3737`; plan `b675df5`; close-out 1 `91df0c9` (ROADMAP, BACKLOG); close-out 2 after
(notes, receipt, ledger). None pushed.
**Verified:** on scratch copies of `HEAD`, before the picker: three trial vignettes built (8.9 s) and checked with
`R CMD check --as-cran` (161 s; R16's NOTE only; installed 5.4 MB as INFO, `doc/` 5.0 MB, the package alone 468 KB;
`_R_CHECK_LOG_USE_INFO_` read in `tools:::.check_packages`); a pkgdown 2.2.1 site (stopped on the stale installed
copy, then built in 34.5 s with it installed; `CLAUDE.md` and `DIVERGENCE.md` published as pages); a chromote
picture (8.7 s, 64 KB; a 375-animal fitted view shows no ids); a vignette rendered with kinship2 and Pedixplorer
hidden; the 375-animal example clean and byte-identical to nprcgenekeepr's at `baef1e12c`; S1141's 11 measured files
identical to the copy (`git diff d280dc8e8 baef1e12c` empty). Every citation in the new text re-found by `grep`
before commit. `quality_ratchet.py --run` 5/5 pass, results `5ddbb5b1aeb3` (head `91df0c9`).
**Self-assessment: 8/10.**
+ Eight measurements before one picker, all four questions answered at the first try; two traps found by building,
  not reading (the stale installed copy, pkgdown publishing project notes); the timing question rests on a proof
  that the re-timed files are the copied files, not on a guess; each DONE criterion names a command and a surface.
- Slips, each caught before a commit: two prototype times cited as the built functions' (found by reading the Done
  records' context); a pkgdown run lost to an unexported shell variable; a zsh `echo` error. The plan's "about 4.1
  MB" for two pages with drawings is a sum of measured parts, not a measured build, and says "expected". I could not
  set the deepest reasoning mode myself (the runner's planning checklist asks for it).
**Learnings:** no `CLAUDE.md` row (over its budget); cite a built function's measurement, not its prototype's, and
render or build documentation against an installed current copy (both in the Gotchas above).
**Ledger:** `CHANGELOG.md` S25 entry.
