# Documentation: plan (plan Phase 16)

**Date:** 2026-11-15 · **Session:** pedkindraw S25 · **Type:** planning session (`methodology/SESSION_RUNNER.md`
"Planning Sessions"; `methodology/workstreams/ARCHITECTURE_WORKSTREAM.md`) for plan Phase 16
(`docs/planning/standalone-pedigree-package-plan.md`, "### Phase 16 -- Documentation"). No package code, vignette,
README or site was written; the measurements ran on scratch copies of the package in this session's scratchpad.
**Status:** rulings R77-R80 made (Mark's picks, section 4); the build is five sessions, 16a-16e (section 6), each
its own session. **Measured at:** `3ae3737` (S25's claim; `R/`, `man/`, `tests/` and `DESCRIPTION` identical to
`bcdc1b0`), R 4.6.2, knitr 1.52 and rmarkdown 2.32 (both in renv's lock, from the dated repository), pkgdown 2.2.1
(R's own library, not renv), pandoc 3.12.1, chromote 0.5.1, this Mac (Apple M2 Max, 96 GiB).

---

## 1. What Phase 16 asks

The plan gives Phase 16 one line: "README, a getting-started vignette, a drawing vignette, pkgdown site, NEWS; the
Phase 1-2 timing, memory and capacity tables summarized with their dates and machine." Three other places set
terms for it:

- The contract's section 5 (`docs/planning/pedkindraw-api-contract.md`, "## 5. Dependencies") leaves to Phase 16
  "what the vignettes need" in Suggests.
- The plan's section 3.4 ("Documentation that names the copy set"): nprcgenekeepr's vignettes, articles and
  `_pkgdown.yml` lines stay in nprcgenekeepr (R8); "the new package writes its own".
- The comparison doc's section 10 (`docs/research/pedigree-package-comparison-2026-11.md`, "## 10. What the new
  package would offer that none of the three does") says what the package is for: the drawing is right (every
  offspring to its true parents), readable (to 1,000 animals once zoomed in, Mark's judgment) and annotated and
  interactive from a script. The README's first paragraph and the drawing vignette say this.

The plan's "Phases 11-15" table stops at 15, and Phase 16 had no DONE criteria; this document gives them
(section 6).

## 2. What exists now (inventory by search, S25)

| Item | Now | Evidence |
|---|---|---|
| README | none (the dashboard's one risk flag, "README is missing or insufficient") | `ls README*`; `methodology/dashboard.html` |
| NEWS | none | `ls NEWS*` |
| Vignettes | none; no `VignetteBuilder`; Suggests has no knitr or rmarkdown | `DESCRIPTION:25` |
| knitr, rmarkdown | in renv's library and lock, 1.52 and 2.32, from the dated repository | `renv.lock` |
| pkgdown | in R's own library (2.2.1), not in renv; installing it into renv adds 9 packages (`pkgdown`, `downlit`, `fansi`, `httr2`, `ragg`, `systemfonts`, `textshaping`, `whisker`, `xml2`) | `tools::package_dependencies()` against `renv.lock` |
| Package help page (`?pedkindraw`) | none | `ls man`; no `"_PACKAGE"` in `R/` |
| Datasets | none; the copied sample pedigrees are test fixtures (R21) | no `data/`; `tests/testthat/helper-fixtures.R:1-4` |
| `docs/` | this repository's plans and studies, in `.Rbuildignore` (`.Rbuildignore:23`); also pkgdown's default site folder | `ls docs` |
| CI | `R-CMD-check.yaml` sets up pandoc (`:42`) and builds with `--compact-vignettes=gs+qpdf` (`:107`); its `setup-r-dependencies` installs Suggests, so knitr and rmarkdown arrive when `DESCRIPTION` names them | `.github/workflows/R-CMD-check.yaml` |
| Website | no `_pkgdown.yml`, no pkgdown workflow; GitHub Pages off (`has_pages: false`); the repository is public | `gh api repos/rmsharp/pedkindraw` |
| Words gate | `user-facing-sire-dam-words` reads `R` and `man` only | `methodology/.quality-gates.json` |
| Installed copy | renv's library holds a pedkindraw 0.0.1 built 2026-11-12, before `asPedFrame()` existed | `ls <renv library>/pedkindraw`; M3 |
| `DESCRIPTION` | `Version: 0.0.1` (`:4`); `URL` the GitHub repository only (`:13`) | |

**The exports** (`NAMESPACE`: 31 functions and 4 `asPedFrame()` methods), in the six groups a README overview and
the site's reference index use:

| Group | Exports |
|---|---|
| Drawing (3) | `makePedigreeMatingLayout()`, `drawPedigreeDiagram()`, `makePedigreeDiagramData()` |
| Kinship and relatedness (3) | `kinship()`, `ibdMatrix()`, `findUnrelated()` |
| Pedigree structure (9) | `findGeneration()`, `findPedigreeNumber()`, `familyCheck()`, `getParents()`, `getOffspring()`, `getFounders()`, `isFounder()`, `hasBothParents()`, `getIdsWithOneParent()` |
| Checking and repair (5) | `checkPedigree()`, `checkTwinRelations()`, `addParents()`, `addBackSecondParents()`, `correctParentSex()` |
| Trimming and shrinking (10) | `trimPedigree()`, `getProbandPedigree()`, `getDescendantPedigree()`, `removeUnknownAnimals()`, `removeUninformativeFounders()`, `shrinkPedigree()`, `bitSize()`, `findUnavailable()`, `findAvailNonInform()`, `findAvailAffected()` |
| Converters (1) | `asPedFrame()` (kinship2 `pedigree` and `pedigreeList`, Pedixplorer `Pedigree`) |

Every help example types its own small pedigree (R21); the drawing path is the `drawPedigreeDiagram()` example:
a data frame, `findGeneration()`, `makePedigreeMatingLayout()`, `drawPedigreeDiagram()`.

**Where the timing numbers live** (all in nprcgenekeepr, read from the clone with git; R79):

| Record | Measured | Code measured | Result files (commit that holds them) |
|---|---|---|---|
| Comparison doc section 7 (Phase 1, S1123) | 2026-11-02, this Mac | nprcgenekeepr `70e0492eb` (3.0.0.9000), kinship2 1.9.6.2, Pedixplorer 1.8.0, BGmisc 1.6.0.1 | `tools/pedigreeComparison/results/timing.csv`, `timingRuns.csv` (`2a1431f30`) |
| Comparison doc section 9 (Phase 2, S1125) | 2026-11-03, this Mac and Chrome | nprcgenekeepr `fd7c3d8ce`, the same comparators and ggpedigree 1.2.0 | `results/drawingTiming.csv`, `drawingTimingRuns.csv` (`5970b1ce5`) |
| nprcgenekeepr's `docs/research/cleanroom-vs-3.0.0-comparison-2026-11.md` (S1141) | 2026-11-09, this Mac | the clean-room code at `d280dc8e8` against 3.0.0 | `results/version/versionCells.csv` (`25ba45ecb`) |
| This plan's Done records (pedkindraw S17-S20) | single runs, this Mac | pedkindraw's own functions | the plan's "Done 13" and "Done 14" records |

S1141's measured files are the ones pedkindraw copied: `git diff d280dc8e8 baef1e12c` on the 11 files of the
measured functions (`R/kinship.R`, `R/shrinkPedigree.R`, `R/makePedigreeDiagramData.R`,
`R/positionTreeApportion.R`, `R/orderRootSubtrees.R`, `R/findGeneration.R`, `R/findPedigreeNumber.R`,
`R/drawPedigreeDiagram.R`, `R/getProbandPedigree.R`, `R/getDescendantPedigree.R`, `R/trimPedigree.R`) prints
nothing, and `d280dc8e8` is an ancestor of `baef1e12c` (S25). Since the copy, pedkindraw changed three layout
functions for hints (`DIVERGENCE.md`; without hints the results are identical, speed not re-measured) and ported
nprcgenekeepr's legend change to `drawPedigreeDiagram()` (R37). The Phase 1 shrink row (1,000 animals in 21.0 s)
is the code before the rewrite; S1141 timed the rewrite at 3.69 s, and 3,000 animals in 92.0 s. The Phase 2 drawing
rows are the layout before the rewrite; S1141 timed the rewrite's layout on one pedigree (examplePedigree trimmed)
at 3.32 s against 3.40 s.

**nprcgenekeepr's documentation, for its shape only** (R8: nothing copied but R80's file): `README.Rmd` knitted
to `README.md` from child documents; `NEWS.md` from `NEWS.Rmd`, grouped by area; Rmd vignettes and Quarto
articles (website only, `vignettes/articles/`); `_pkgdown.yml` with `destination: pkgdown_site` "because
`docs/methodology/` and `docs/planning/` are git-tracked inside `docs/`"; `.github/workflows/pkgdown.yaml` builds
on push and deploys `pkgdown_site` to a `gh-pages` branch. Its published site carries `CLAUDE.html`,
`BACKLOG.html` and `PROJECT_LEARNINGS.html` (its `gh-pages` branch, read S25).

## 3. Measurements (Learning 17, before the picker)

A scratch copy of `HEAD` (`git archive`) with `VignetteBuilder: knitr`, knitr and rmarkdown in Suggests and three
trial vignettes (`rmarkdown::html_vignette`, self-contained), built and checked from a scratch folder with
renv's library and `RENV_PROJECT` unset (the `CLAUDE.md` recipe).

| # | What | Result |
|---|---|---|
| M1 | Page size of a vignette with drawings | one drawing of the `drawPedigreeDiagram()` example (4 animals): 1,625,289 B (gzip 373,549); that drawing and the 375-animal rhesus pedigree with its twins (R80): 1,928,358 B; kinship2's `sample.ped` (55 animals, 2 families) through `asPedFrame()`: 1,649,184 B. Each page carries visNetwork's JavaScript once; the 375 animals add 0.3 MB |
| M2 | `R CMD build` and `R CMD check --as-cran` with the three pages | build 8.9 s; check 161 s (tests 111 s): 0 errors, 0 warnings, 1 NOTE (R16's: Maintainer, New submission); vignettes re-built OK; "installed package size ... INFO: installed size is 5.4Mb, doc 5.0Mb". Installed 5,580 KB, `doc/` 5,112 KB, so the package without vignettes is 468 KB. R 4.6.2 prints INFO because `_R_CHECK_LOG_USE_INFO_` defaults to TRUE (`tools:::.check_packages`); with it off the same check is a NOTE, and CRAN's policy asks that documentation stay under 5 MB |
| M3 | A trial pkgdown site (2.2.1, `build_site()` into a scratch folder) | with `install = FALSE` the vignettes ran against the stale pedkindraw 0.0.1 in renv's library and stopped: "could not find function asPedFrame"; with `install = TRUE`: exit 0 in 34.5 s, 9.4 MB, 45 pages; each article with drawings has a `_files/` folder of 1.9 MB. Warnings: Bootstrap 3 deprecated (set `template: bootstrap: 5`), `url` missing, pandoc's `--mathml`/`--mathjax` deprecations (harmless). It published the root's `CLAUDE.md` and `DIVERGENCE.md` as pages although `.Rbuildignore` lists both |
| M4 | A still picture of a drawing | `htmlwidgets::saveWidget()` then a chromote screenshot at 1400 x 700: a 63,616 B PNG in 8.7 s. At the fitted view the 375-animal drawing shows no ids (comparison finding 28), so a README picture draws a small pedigree |
| M5 | The 375-animal layout in a vignette build | `makePedigreeMatingLayout()` with its 3 twin pairs: 1.94 s |
| M6 | R80's example file | `checkPedigree()` 0 rows; the 3 twin pairs (MZ, DZ, UZ) pass `checkTwinRelations()`; generations 0-8; 5 families; `obfuscated_rhesus_mhc_ped.csv` and `obfuscated_rhesus_mhc_twin_relations.csv` byte-identical (`cmp`) to nprcgenekeepr's `inst/extdata/examples/` at `baef1e12c` (as the test fixtures are); `obfuscated_rhesus_mhc_ped_twins.csv` holds the same data with dates quoted |
| M7 | A vignette with kinship2 and Pedixplorer absent | a scratch library of links to renv's packages less kinship2, Pedixplorer and pedkindraw (123 packages), the trial package installed into another: `requireNamespace("kinship2")` FALSE, and the vignette whose kinship2 chunk has `eval = requireNamespace("kinship2", quietly = TRUE)` rendered |
| M8 | The timing records against the copy | S1141's 11 measured files identical to pedkindraw's copy commit (section 2) |

## 4. Rulings (recorded in the plan's section 2)

| # | Ruling | Mark's pick |
|---|---|---|
| R77 | Three vignettes, knitr and rmarkdown (`html_vignette`), shipped on CRAN: getting started with one live drawing, drawing with several, speed and size limits with none; the installed package stays under 5 MB (M1, M2: about 4.1 MB expected); a later page with drawings goes on the website only | "Live drawings in both (Recommended)" |
| R78 | The pkgdown site on GitHub Pages, `https://rmsharp.github.io/pedkindraw/`, from a `gh-pages` branch a workflow rebuilds on each push to master; built into `pkgdown_site/`, not `docs/`; the root's `CLAUDE.md` and `DIVERGENCE.md` left off (M3); turning Pages on approved in that session | "GitHub Pages (Recommended)" |
| R79 | The speed, memory and size-limit tables summarized from the dated records (section 2), each naming date, machine, versions and code measured, every number checked by a script against the committed result files; pedkindraw's new functions' single-run times from the plan's Done records; no new timing runs; a vignette of its own, no drawings | "Summarize the records (Recommended)" |
| R80 | The colony-size example: nprcgenekeepr's obfuscated 375-animal rhesus pedigree and its 3 twin pairs as files in `inst/extdata/`, byte for byte from nprcgenekeepr's `inst/extdata/examples/` at `baef1e12c`, read with `system.file()`; no export, no help page (R21 unchanged); small typed pedigrees show each feature | "Ship one example file (Recommended)" |

## 5. The design

### 5.1 Files, by session

| File | Session | Note |
|---|---|---|
| `README.Rmd`, `README.md` | 16a | the source knitted with `rmarkdown::render("README.Rmd")` (`github_document`); no `Sys.Date()`, so a second render changes nothing; `^README\.Rmd$` in `.Rbuildignore` |
| `man/figures/README-pedigree.png`, `tools/makeReadmePicture.R` | 16a | the picture of a small typed pedigree (M4's method); the script remakes it |
| `NEWS.md` | 16a | `# pedkindraw (development version)`, then one section per group of section 2's table; Phase 17 numbers the version |
| `R/pedkindraw-package.R`, `man/pedkindraw-package.Rd` | 16a | `"_PACKAGE"`: `?pedkindraw` names the vignettes and the groups |
| `methodology/.quality-gates.json` | 16a | `user-facing-sire-dam-words` reads `R man vignettes README.Rmd README.md NEWS.md` (a tightening: no approval needed, `SAFEGUARDS.md` "Blast Radius Limits") |
| `DESCRIPTION` | 16b, 16e | 16b: `Suggests` knitr and rmarkdown, `VignetteBuilder: knitr`; 16e: the site in `URL`, only once it answers |
| `inst/extdata/obfuscated_rhesus_mhc_ped.csv`, `inst/extdata/obfuscated_rhesus_mhc_twin_relations.csv` | 16b | R80 |
| `vignettes/pedkindraw.Rmd` | 16b | "Getting started"; named after the package, so pkgdown links it as "Get started" |
| `vignettes/drawing.Rmd` | 16c | "Drawing pedigrees" |
| `vignettes/speed.Rmd`, `tools/checkSpeedTables.R` | 16d | "Speed and size limits"; the script reads the result files from the clone (`git show <commit>:<path>`) and the vignette's tables, exits 0 only when every number matches |
| `docs/planning/pedkindraw-api-contract.md` | 16b, 16d | 16b: section 5's Suggests; 16d: section 7's shrink row gains S1141's time (the copied rewrite, 1,000 animals in 3.69 s) |
| `_pkgdown.yml`, `.github/workflows/pkgdown.yaml` | 16e | R78 |
| `.Rbuildignore`, `.gitignore` | 16a, 16b, 16e | `^README\.Rmd$` (16a); built vignette debris in `vignettes/` ignored by git (16b); `^_pkgdown\.yml$`, `^pkgdown_site$`, `^pkgdown$` and `pkgdown_site/` (16e) |

### 5.2 README (16a)

The package's name and one paragraph of what it is (a sibling of kinship2 carrying nprcgenekeepr's drawing; the
comparison doc's section 10 in plain words); the R-CMD-check badge (CRAN badges wait for Phase 17); installing
from GitHub (not run); a short example run when knitted (a typed pedigree, its generations, its layout, its
drawing) and the still picture; the six groups of section 2 with every export named; converting kinship2 and
Pedixplorer objects; the relation to nprcgenekeepr (a copy, R8; `DIVERGENCE.md`); the license. The site link waits
for 16e. Every link must answer, since `R CMD check --as-cran` checks the URLs in `README.md` and `NEWS.md`, and a
bad one adds to the incoming-feasibility NOTE, which R16 then fails.

### 5.3 Getting-started vignette (16b)

The pedigree data frame (`id`, `sire`, `dam`, `sex`, conditions, `status`; contract section 4's conventions) with
R80's file read through `system.file("extdata", ..., package = "pedkindraw")`; `checkPedigree()` on it (no
problems) and on a typed pedigree with problems, repaired with `addParents()` and `correctParentSex()`;
`findGeneration()` and `findPedigreeNumber()`; `kinship()` and a few of its values; `getProbandPedigree()` and
`trimPedigree()` around probands; `shrinkPedigree()` and `bitSize()`; `findUnrelated()`; one drawing of a trimmed
pedigree small enough to read at its fitted view; `asPedFrame()` for kinship2 users (a chunk run only when kinship2
is installed); where to read next (`vignette("drawing", package = "pedkindraw")`, `vignette("speed", ...)`).

### 5.4 Drawing vignette (16c)

From a data frame to a drawing; the five sex shapes and the legend; the deceased slash (`status`); one condition,
then two to four as sections, and `conditionsNotDrawn` past four; twins (MZ, DZ, UZ) from a twins table checked
by `checkTwinRelations()`; the consanguineous mating's marked lines; an animal drawn twice and its dashed link;
the two edge styles; hover text and the id search box; animals with no relative (`isolatedIds`); layout hints,
`order` and `mate` with its anchor; kinship2 and Pedixplorer objects with their hints through `asPedFrame()` (the
`gen` column added first; chunks run only when each package is installed; hints set by hand, since both packages'
automatic hints warn on some pedigrees); saving a drawing as a web page and the PNG export button; `onClick` for
Shiny; R80's 375 animals as one colony-size drawing (zoom, search); the size limit, from the speed vignette. Words:
sire, dam, mate, mating; kinship2's `spouse` named only as kinship2's own element (R73).

### 5.5 Speed and size-limits vignette (16d)

How the numbers were measured (fresh process per run, warm-up, median of 3, 120 s and 32 GB limits, the idle-CPU
rule) and on what (Apple M2 Max, 12 cores, 96 GiB, R 4.6.2; the dates and versions of section 2); which code each
table measured and why it stands for pedkindraw's (section 2's `git diff`); the tables: computation seconds by size
(300 to 100,000 animals) for pedkindraw's computations with kinship2's and Pedixplorer's beside them, S1141's
times where it re-timed the rewrite (kinship, shrinking) and Phase 1's elsewhere; capacity and memory; drawing
seconds, capacity and readability (Phase 2; the layout before the rewrite, S1141's one-pedigree comparison
stated); the single-run times of pedkindraw's new functions, labelled as single runs, from the plan's Done
records of the built functions (`checkPedigree()` 100,000 animals 0.14 s, 0.22 s with 5 cycles; `findUnrelated()`
10,000 animals with 30% genotyped 0.57 s, kinship2 6.5 s; `asPedFrame()` 100,000 animals of a kinship2 object
0.04 s) and, marked as a prototype's, `asPedFrame()` 100,000 animals of a Pedixplorer object 0.005 s; what they
cannot show (another machine's speed, a smaller machine's limits).

### 5.6 Website (16e)

`_pkgdown.yml`: `url: https://rmsharp.github.io/pedkindraw/`, `destination: pkgdown_site`, `template: bootstrap:
5`, a reference index in section 2's six groups plus the package page (32 topics), the three vignettes as articles.
`.github/workflows/pkgdown.yaml`: on push to master (the R-CMD-check workflow's `paths-ignore`) and by hand; R and
pandoc set up as in `R-CMD-check.yaml`; the package installed for the build (M3); `CLAUDE.md` and `DIVERGENCE.md`
removed from the runner's copy before building (R78; nothing removed from the repository); `pkgdown_site/`
deployed to `gh-pages`. Pages turned on after the first deploy creates the branch (`gh api -X POST
repos/rmsharp/pedkindraw/pages`, with Mark's approval); then the `URL` field and the README link.

### 5.7 How TDD applies

Phase 16 adds no R function: the one new R file, `R/pedkindraw-package.R`, is documentation. The sessions run no
RED, GREEN and REFACTOR gates, and each declares "TDD phase: none (documentation)", as this planning session did.
Each writes its checks before the text they check and runs them where they can fail: the widened words gate (16a);
hidden `stopifnot()` chunks holding each value the prose states, computed in a scratch run first (16b-16d; Learning
18); `tools/checkSpeedTables.R` run before the tables are filled (16d); `pkgdown::check_pkgdown()` run before
`_pkgdown.yml` is complete (16e). If Mark wants the TDD gates in these sessions, the session's first picker says
so.

## 6. The build: five sessions

Every session: Orient as `methodology/SESSION_RUNNER.md` says, with the drift tool and
`git -C ../nprcgenekeepr log --oneline baef1e12c..HEAD -- R/makePedigreeDiagramData.R R/orderRootSubtrees.R
R/positionTreeApportion.R` (Learning 15); at most 5 files per commit; values the text states computed before the
text (Learning 18); close out when its DONE criteria hold.
**Checks** (`CLAUDE.md`, "Build / Test / Verify"): the suite 0 failed, WARN 0 (its count unchanged: Phase 16 adds
no test file); `lint_package()` 0; roxygen leaves `NAMESPACE` and `man/` as committed (16a adds
`man/pedkindraw-package.Rd` once); `R CMD check --as-cran` from a scratch folder: 0 errors, 0 warnings, R16's NOTE
only, and "checking installed package size ... OK" (R77: under 5 MB; INFO fails); the drift tool exit 0, the
functions it lists exactly those with rows; `quality_ratchet.py --run` all pass; CI 5/5 after the session's push.
**Surface:** this Mac for building, checking and viewing (Chrome through chromote, and Mark's eyes for how a page
reads); CI (Linux, macOS, Windows) for building the vignettes on five platforms, including those where a test
already skips because Pedixplorer or Chrome is absent; GitHub for the README's page and the site (16a, 16e). CI
cannot judge a page's readability, and it has no nprcgenekeepr clone, so `tools/checkSpeedTables.R` runs on this Mac
only.

**16a -- README, NEWS and the package help page (one session; close out when done).** DONE when:

1. `README.Rmd` and `README.md` (section 5.2): a second `rmarkdown::render("README.Rmd")` leaves `git status`
   clean; a script reading `NAMESPACE` finds every one of the 31 exports named in `README.md`; the picture is
   remade by `Rscript tools/makeReadmePicture.R`.
2. `NEWS.md` under `# pedkindraw (development version)`; `?pedkindraw` opens the package page.
3. The words gate widened, read 0, and `quality_ratchet.py --run` all pass.
4. The checks above; `R CMD check --as-cran` finds no bad URL in `README.md` or `NEWS.md`; after the push the
   repository's GitHub page shows the README with its picture (viewed in a browser); the dashboard's README flag
   is gone (`python3 methodology/methodology_dashboard.py`).

**16b -- getting-started vignette and the example file (one session; close out when done).** DONE when:

1. `DESCRIPTION` names knitr and rmarkdown in Suggests and `VignetteBuilder: knitr`; `renv::snapshot(dev =
   TRUE)` run, and the gate `renv-lock-no-latest-repository` reads 0 (both packages are locked already; expect no
   other change, and read the lock's diff); the contract's section 5 names them.
2. R80's two files in `inst/extdata/`, `cmp` equal to nprcgenekeepr's at `baef1e12c`; the vignette says where they
   come from.
3. `vignettes/pedkindraw.Rmd` (section 5.3); each value its prose states is held by a hidden `stopifnot()` chunk;
   it renders with kinship2 and Pedixplorer absent (M7's method), those chunks not run.
4. The built page opened in Chrome through chromote: its drawing shows every node of its layout.
5. The checks above, "checking re-building of vignette outputs ... OK" among them; CI 5/5 builds it.

**16c -- drawing vignette (one session; close out when done).** DONE when:

1. `vignettes/drawing.Rmd` (section 5.4); each statement of where an animal is drawn or what a drawing shows
   (left-to-right order, shapes, slashes, sections, edge colour and dashes, repeat nodes) is held by a hidden
   `stopifnot()` chunk on the layout, its values computed in a scratch run first.
2. It renders with kinship2 and Pedixplorer absent; the built page opened in Chrome: every drawing shows every
   node of its layout; Mark looks at the built page.
3. The checks above; the installed size, with two vignettes of drawings, read from the check folder (`du -sk`) and
   under 5,120 KB (about 4.1 MB expected: M1, M2).

**16d -- speed and size-limits vignette (one session; close out when done).** DONE when:

1. `vignettes/speed.Rmd` (section 5.5), each table naming its date, machine, versions and commit.
2. `Rscript tools/checkSpeedTables.R ../nprcgenekeepr` exits 0, every number of the vignette's tables equal to its
   source cell (n of n, the count printed); it was run, failing, before the tables were filled.
3. The contract's section 7 shrink row gains S1141's time (the copied rewrite).
4. The checks above.

**16e -- the website (one session; close out when done).** DONE when:

1. `pkgdown::check_pkgdown()` reports no problem (32 topics in the index); a local build into `pkgdown_site/`
   exits 0 with no `CLAUDE.html` or `DIVERGENCE.html` and the three articles.
2. `.github/workflows/pkgdown.yaml`'s first run on GitHub succeeds and creates `gh-pages`; Pages turned on (Mark
   approves); `https://rmsharp.github.io/pedkindraw/` answers 200, and its articles' drawings show every node in
   Chrome.
3. Then `DESCRIPTION`'s `URL` and the README name the site, and `R CMD check --as-cran` still gives R16's NOTE
   only (the incoming check reads the live URL).
4. The checks above; the plan's "Done 16" record; Phase 16 DONE.

## 7. Not included, and why

| Item | Why not |
|---|---|
| A logo | not asked; Mark's call later |
| Quarto articles | nprcgenekeepr uses them; `html_vignette` needs only pandoc, which CRAN and CI have |
| A coverage badge or workflow | the coverage item is `methodology/BACKLOG.md`'s own; a badge waits for it |
| CRAN badges, `cran-comments.md`, the release's version number | Phase 17 |
| Re-measured timings | R79 |
| The argument-name review | contract section 6: the last session before Phase 17 |
| Removing the stale pedkindraw 0.0.1 from renv's library | not documentation; the site build installs the package (M3); a `methodology/BACKLOG.md` item |

## 8. Risks

| Risk | Where it bites | Countermeasure |
|---|---|---|
| The installed size passes 5 MB (a later page with drawings, a larger visNetwork) | `R CMD check` INFO, a NOTE on CRAN | R77: later drawing pages on the website only; every session reads "checking installed package size ... OK" |
| A URL in `README.md`, `NEWS.md` or `DESCRIPTION` does not answer | the incoming-feasibility NOTE grows; R16 fails | the site's URL added only once it answers (16e); 16a's links checked by `R CMD check --as-cran` |
| pkgdown runs the vignettes against the stale installed copy | a site build stops or shows old code | build with the package installed (M3) |
| pkgdown publishes `CLAUDE.md` and `DIVERGENCE.md` | the site shows project notes | the workflow removes them from its copy (R78, M3) |
| kinship2's `autohint()` or Pedixplorer's `auto_hint()` warns in a vignette | a warning on the page | hints set by hand (S24's gotcha) |
| Prose drifts from the code it describes | a wrong statement ships | hidden `stopifnot()` chunks: the vignette stops building |
| nprcgenekeepr changes the copied layout during Phase 16 | a drawing's description goes stale | the drift tool and Learning 15's log at each Orient |
| kinship2's and Pedixplorer's help say spouse, marriage | husband or wife words reach a page | the widened gate (16a) |

## 9. Open details for the build sessions' pickers

| # | Question | Session |
|---|---|---|
| D1 | Install line: `remotes::install_github("rmsharp/pedkindraw")` or `pak::pak("rmsharp/pedkindraw")` | 16a |
| D2 | The README picture's pedigree (typed, 10-20 animals, showing twins, a condition and a deceased animal) | 16a |
| D3 | The getting-started drawing: which probands, and how many animals still read at the fitted view | 16b |
| D4 | pkgdown in renv by Learning 3's recipe (9 packages, section 2) or run from R's own library through the scratch recipe; the deploy step's action and its pinned version | 16e |
