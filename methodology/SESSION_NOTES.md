# Session Notes

**Purpose:** Continuity between sessions. Each session reads this first and writes to it before closing out.

**This file is transient — it is overwritten every session** (*"what's next, what traps?"*).
The cumulative, append-only record of *what was done, ever* lives in `CHANGELOG.md`; the commit SHA is the shared key.
At close-out, distill the durable outcome into a `CHANGELOG.md` entry — do not copy this handoff into it.

---

## ACTIVE TASK
**Task:** **Phase 16b: the getting-started vignette and the example file**, the second of Phase 16's five build
sessions (`methodology/BACKLOG.md:11`; DONE criteria at `docs/planning/documentation-plan.md:232`, the design at
`:148` (5.3)). The orient picker asks Mark: this; **the legend item** (`methodology/BACKLOG.md:20`, Mark's S26 find:
the sections of a two-condition symbol are not explained; code, TDD, must come before 16c, not 16b); **the gap
document** (`methodology/BACKLOG.md:30`, Mark's S26 request); or hold. Tests for full coverage (`:40`) remains.
**Status:** READY. Phase 16a DONE (S26: claim `1e062c2`, checks `13a189d`, README `02b3a2d`, NEWS and help
`e6b20a3`, NEWS fix `cd0b787`, pushed with S24's and S25's commits, CI run `43805309511`; close-out 1 and 2 after,
not pushed). `R/` gained only `R/pedkindraw-package.R` (the help page's source); `DESCRIPTION` unchanged.
**Plan:** `DESCRIPTION` Suggests knitr and rmarkdown and `VignetteBuilder: knitr`, `renv::snapshot(dev = TRUE)`
(both are locked already; read the lock's diff, gate `renv-lock-no-latest-repository` 0); the contract's section 5
(`docs/planning/pedkindraw-api-contract.md:248`) names them; R80's two files in `inst/extdata/`, `cmp` equal to
nprcgenekeepr's `inst/extdata/examples/` at `baef1e12c`; `vignettes/pedkindraw.Rmd` per 5.3, each value its prose
states held by a hidden `stopifnot()` chunk (the README's `claims` chunk is the pattern, `README.Rmd:92`);
rendered with kinship2 and Pedixplorer absent (M7, `:106`); its drawing opened in Chrome; `?pedkindraw`'s
"Getting started" section (`R/pedkindraw-package.R:42`) names the vignette. TDD phase: none (documentation), checks
first (5.7, `:194`), as 16a ran (Mark's S26 pick).
**Session boundary:** one session. No drawing vignette (16c), no speed tables (16d), no site (16e).
**Priority:** HIGH (the plan's next session).

### What You Must Do
1. Orient; drift tool (expect 3 differ, all with rows); `git -C ../nprcgenekeepr log --oneline baef1e12c..HEAD --
   R/makePedigreeDiagramData.R R/orderRootSubtrees.R R/positionTreeApportion.R` (Learning 15; nprcgenekeepr was at
   `e2af4365b` at S26's Orient, nothing new on those files); `gh run view 43805309511` if this handoff's CI line
   says it was still running.
2. Read the documentation plan's 5.3 (`:148`), 16b's DONE (`:232`), M6 and M7 (`:105`-`:106`), D3 (`:304`); the
   contract's section 5 (`:248`); `README.Rmd` (the claims chunk and its render comment).
3. Measure before the picker (Learning 17; D3): trim R80's 375-animal pedigree around two or three candidate
   proband sets, draw each with chromote as `tools/makeReadmePicture.R` does, and look at each at its fitted view.
   Look as a reader: every mark in the picture explained by the legend or the text. Use one condition or none
   (two or more split every symbol into sections the legend does not explain: the legend item).
4. Checks first: compute every value the prose will state in a scratch run, then write the hidden `stopifnot()`
   chunks; render once failing (one value changed) before relying on them.
5. Write the files (at most 5 per commit), render, the checks of the plan's section 6 ("checking re-building of
   vignette outputs ... OK", "checking installed package size ... OK"), push, CI 5/5.

### Gotchas
- **The stale pedkindraw 0.0.1 in renv's library** (`methodology/BACKLOG.md:86`) still runs whenever
  `library(pedkindraw)` is called without installing first. S26's recipe: `git archive HEAD | tar -x -C <tree>`,
  `R CMD build --no-build-vignettes --no-manual <tree>`, `R CMD INSTALL --no-docs --library=<scratch lib>
  <tarball>`, then `env -u RENV_PROJECT R_LIBS=<scratch lib>:<renv lib> R_LIBS_USER=<renv lib> Rscript
  --no-init-file ...` from the root (`<renv lib>` from `Rscript -e 'cat(renv::paths$library())'`). Print
  `find.package("pedkindraw")` to see which copy ran (the picture tool does). `R CMD build` builds vignettes against
  a copy it installs itself, so this matters for hand renders and pictures, not for the check.
- **NEWS.md:** R reads a section only under a heading holding a version: S26's plan heading `# pedkindraw
  (development version)` gave `R CMD check` a second NOTE ("No news entries found"); it is now `# pedkindraw 0.0.1
  (development version)` (`cd0b787`). New lines go under it.
- **chromote pictures:** `selector = "html"`, not `".html-widget"` (that crops the legend and the export button);
  `Emulation$setDeviceMetricsOverride(deviceScaleFactor = 2)` before `go_to()`, or vis.js draws its canvas at 1x and
  a 2x capture is soft (`tools/makeReadmePicture.R:40`); a viewport under 1,000 px wide cut the legend's labels.
- **R CMD check reads README.md's links:** a relative link to a file outside the build (`DIVERGENCE.md`) would be
  flagged; the README uses the GitHub URL. Vignette links are checked the same way.
- **`github_document`** writes a `README.html` preview unless `html_preview: false` (set in `README.Rmd`); a
  `![alt](path)` alone in a paragraph becomes a figure whose caption repeats the alt text (the README uses `<img>`).
- **The dashboard's LOW flag** "Quality gate `user-facing-sire-dam-words` `command` changed in 13a189d": expected,
  the widening (`grep -s` reads a missing `vignettes/` as no lines).
- **Words:** sire, dam, mate, mating; the README's prose was checked by the gate and by eye.
- **Single-run times:** cite a built function's measurement, not its prototype's (S25).
- **zsh:** `echo =====` fails; keep each shell command to one check (Mark, S23). Pass environment variables on the
  `env` line.
- **Another Claude session may run R checks at the same time** (nprcgenekeepr's sessions): `ps` and `lsof -d cwd`.
- **`CLAUDE.md` is over its 28,000 B budget** (30,795 B; S23-S26 added nothing).
- **Left for Mark:** `pedkindraw.Rproj` untracked at the root (`.Rbuildignore:6` keeps it out of the build).
- **Times on this Mac (S26):** README render 1.7 s; the README picture 4.6 s; `R CMD check --as-cran` 169 s (tests
  116-120 s); the suite ~3 min; the gate run ~4 min; CI ~15 min.

### Key files
- `docs/planning/documentation-plan.md`: `:105`-`:106` M6, M7; `:120` 5.1 (files by session; `:130` R80's files);
  `:148` 5.3; `:194` 5.7; `:204` section 6; `:232` 16b's DONE; `:298` section 9 (`:304` D3).
- `docs/planning/standalone-pedigree-package-plan.md`: `:46` Next; `:736` Phase 16; `:761` "Done 16a".
- `docs/planning/pedkindraw-api-contract.md:248` (section 5, Suggests).
- `methodology/BACKLOG.md:11` (16b-16e), `:20` (legend), `:30` (gap document), `:86` (the stale copy).
- `README.Rmd` (its `claims` chunk; `tools/makeReadmePicture.R` runs its chunks `pedigree`, `check`, `drawing`);
  `R/pedkindraw-package.R:42` ("Getting started"); `DESCRIPTION:4` (Version), `:25` (Suggests);
  `methodology/.quality-gates.json:56` (the words gate).

### How You Will Be Evaluated
The user rates every session's handoff. Your handoff will be scored on:
1. Was the ACTIVE TASK block sufficient to orient the next session?
2. Were key files listed with line numbers?
3. Were gotchas and traps flagged?
4. Was the "what's next" actionable and specific?

---

## Session History

*Session history accumulates below this line. Newest session at the top.*
*S1-S25's entries were removed in S3-S26 (FM #28): their durable records are the receipts in `HANDOFFS.md` and the
entries in `CHANGELOG.md`.*

### Session 25 Handoff Evaluation (by Session 26)
**Score: 8/10.**
- **What helped:** the stale-copy gotcha (every render and picture ran against a scratch install, and the picture
  tool prints which copy it used); the scratch-tree recipe; the URL gotcha (the README links `DIVERGENCE.md` by its
  GitHub URL); the widened gate's missing-path gotcha (`grep -s`, shown able to fail); the steps in order; every
  line cited was right (`:221`, `:138`, `:194`, `:298`, `.quality-gates.json:56`).
- **What was missing:** that `selector = ".html-widget"` crops the legend and that chromote draws vis.js's canvas at
  1x (M4's method gave a cropped, soft picture; found by looking); that a two-condition candidate would show
  section lines the legend does not explain (found by Mark, not by me).
- **What was wrong:** S25's own plan text, carried into the handoff: `NEWS.md` under `# pedkindraw (development
  version)` gives `R CMD check` a NOTE (R needs a version in the heading); one extra 3-minute check and a fix
  commit.
- **ROI:** high.

### What Session 26 Did
**Deliverable:** plan Phase 16a, the README, NEWS and the package help page; TDD phase none (documentation),
checks first. DONE.
**Started:** 2026-11-15 22:14 CST · **Model:** Claude Opus 5.5 · **Mark's picks:** "16a, no TDD gates
(Recommended)" (orient); "E: 13 animals (Recommended)" and "pak (Recommended)" (D2, D1); then, on E's unexplained
section lines, "Use picture D; log the fix (Recommended)"; and, unasked by a picker, the gap-document backlog item.
**Commits:** claim `1e062c2`; checks `13a189d` (the words gate widened); README `02b3a2d` (README.Rmd, README.md,
the picture, `tools/makeReadmePicture.R`, `.Rbuildignore`); `e6b20a3` (NEWS.md, `R/pedkindraw-package.R`,
`man/pedkindraw-package.Rd`); `cd0b787` (NEWS heading with the version); pushed `bcdc1b0..cd0b787` (11 commits);
close-out 1 (plan, documentation plan, ROADMAP, BACKLOG) and close-out 2 (notes, receipt, ledger), not pushed.
**Verified:** the widened gate read 0 on clean text and 2 on a scratch tree with the words; the export check ran
failing (31 missing) before the README, then 31 of 31; two README renders the same (`985fc344`); the hidden claims
chunk stopped a render with one value changed; the picture looked at (2000 x 1160, 66,575 B); suite 52 files, 676
tests, 0 failed, 0 skipped, WARN 0, 5,929 passed; lint 0; roxygen added `man/pedkindraw-package.Rd` only and is
idempotent; `R CMD check --as-cran` on `cd0b787`'s tree R16's NOTE only, installed size OK (608 KB), README and NEWS
links not flagged (the run on `e6b20a3` had the NEWS NOTE); `?pedkindraw` opens the package page; drift tool 90
functions, 3 differ, 0 without a row; the GitHub page in headless Chrome: the README with its badge, the picture
loaded (2000 x 1160) and shown at the README's width; the dashboard's README flag gone (health 82 to 88);
`quality_ratchet.py --run` 5/5 pass, results `5ddbb5b1aeb3`, manifest `01151c525b8a` (head `cd0b787`); CI run
`43805309511`: 5/5 `Status: OK` at the first attempt, 15 min, `FAIL 0 | WARN 0` on each (macOS PASS 5929,
Windows 5928 SKIP 1, Ubuntu devel, release and oldrel-1 5918 SKIP 2: S24's counts).
**Self-assessment: 7/10.**
+ Every check written and shown failing before the text it checks; the README's statements held by a check that
  stops the build; the picture made from the README's own code; two traps found by looking (the cropped legend, the
  soft canvas) and one by the full check (the NEWS heading), each fixed before the push.
- I recommended picture E without seeing that its section lines are unexplained; Mark caught it. I should look at a
  candidate picture as a reader does, every mark explained by the legend or the text. Mark also had to ask whether
  `candE.png` existed: opening three files at once put them in one Preview window. The NEWS NOTE cost a second
  3-minute check.
**Learnings:** no `CLAUDE.md` row (over its budget); in the Gotchas above: look at a picture as a reader; R's
NEWS.md heading needs a version; chromote's selector and device scale.
**Ledger:** `CHANGELOG.md` S26 entries (the session and its push).
