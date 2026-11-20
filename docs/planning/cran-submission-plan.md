# CRAN submission plan: pedkindraw's first release (plan Phase 17)

**Date:** 2026-11-16 · **Session:** pedkindraw S32 · **Type:** planning session (`methodology/SESSION_RUNNER.md`
"Planning Sessions"; `methodology/workstreams/ARCHITECTURE_WORKSTREAM.md`). Nothing under `R/`, `tests/`, `man/`,
`vignettes/`, `inst/` or `DESCRIPTION` changed.
**Status:** Phase 17a DONE (S33: win-builder R-devel read 398 s, section 2.1; R86). Phase 17b DONE (S34: six
name rulings and 17c in three sessions, section 2.4; R87-R93). Phase 17c1 DONE (S35: `kinship(id, sire, dam,
pdepth, ...)` and its `pdepth` check). Phase 17c2 DONE (S36: the pedigree argument is `ped` in four more exports).
Phase 17c3 DONE (S37: the pedigree first in four exports), so 17c is done. Phase 17d DONE (S38: "Select by id"
lists the animals only, and a real id starting `__jog_` is refused; R94). Phase 17e DONE (S39: the legend's lines
have no arrowheads and their labels sit on white; R95). Phase 17f DONE (S40: the gaps document; D4 goes to a
planning session, R96). Phase 17f2 DONE (S41: `docs/planning/gaps-and-shared-code-plan.md`; R97-R101: every gap
closed before the release, phases G1-G17; nprcgenekeepr switches to pedkindraw after acceptance). Phase G1 DONE
(S42: a number other than 0 and 1 in a condition column stops; R102-R105). Phase G2 DONE (S43: an unknown
affected status drawn grey, with a legend row; R106-R107). Phase G3 DONE (S44: `maxNameChars`, the most characters
of a name under an id, `Inf` for whole; R108-R110). Phase G4 DONE (S45: `conditionColors`, the colours of the
conditions in the fills, sections and legend; R111-R113). Phase G5 DONE (S46: `recodePedigree()`, other ways of
writing an unknown parent and a sex rewritten into pedkindraw's; R114-R116). Phase G6 DONE (S47: `countOffspring()`
and `getMatings()`, each animal's offspring and the matings; R117-R119). Phase G7 DONE (S48: `removeAnimals()`,
listed animals removed and their offspring's links to them cleared; R120-R122). Phase G8 DONE (S49:
`findGeneration(alignMates = TRUE)`, aligned generations; R123-R124). Phase G9 DONE (S50: `?shrinkPedigree`'s
example draws the whole pedigree with the animals removed filled; R125-R126). Phase G10 DONE (S51:
`makePedigreeMatingLayout()` returns the hints it used, passed back the same layout; R127-R128). Phase G11 DONE
(S52: `getNearRelativePedigree()`, the relatives within a distance of chosen animals, as Pedixplorer's
`useful_inds(max_dist = )` keeps them; R129-R130). Phase G12 DONE (S53: `conditionThresholds`, a measured trait
drawn by a cut-off with the rule in the legend; R131-R132). Phase G13 begun (S54: its first mark of six, a genotyped
animal's outline drawn 4 px wide from a column `genotyped`; R133-R134; S55: its second, a black dot at the centre
of a carrier's symbol from a column `carrier`; R135; S56: its third, an arrow at the lower left of a proband's and
a consultand's symbol, "P" beside a proband's; R136; S57: its fourth, a black star to the right of the upper-right
corner of an evaluated animal's symbol; R137; S58: its fifth, a line and bars under an infertile animal's symbol,
its id moved below them; R138). Next: G13's last mark, miscarriage (that plan's section 5.1; R133), then G14-G17
before 17g.
**Mark's direction (S32):** "It looks the a plan for a CRAN release should include, at least, consideration of the
other options listed, examination of possible impact of recent and ongoing changes in nprcgenekeepr on pedkindraw,
and the comparison of pedkindraw with kinship2 and Pedixplorer." The options listed were the orient picker's:
Phase 17's plan, the argument-name review, the "Select by id" and legend-label fixes, the gaps document and full
test coverage. Mark's picks: this outline; all four open items before the release; the check time measured on
win-builder first (rulings R83-R85 in `docs/planning/standalone-pedigree-package-plan.md`).
**Builds on:** nprcgenekeepr's `docs/planning/cran-3.0.0-submission-plan.md` (read from the clone at
`363137511`; its S1091, COMPLETE S1144): its phase shape (cut the test time, static hygiene, Suggests used
conditionally, NEWS, version, full gate, cover note and cross-platform runs, submission, after acceptance), its
decisions D1-D5 and its "Here be dragons". This plan repeats what applies here and adds what is pedkindraw's own.
**Measured at:** pedkindraw `ba811e7` (S32's claim; `R/`, `tests/`, `vignettes/` as at `aeaed75`), nprcgenekeepr
`363137511`, on this Mac (Apple M2 Max, R 4.6.2). Each phase below is its own session; strict TDD (`CLAUDE.md`)
applies wherever code or tests change, with the three gates put to Mark.

---

## 1. Summary

**Where things stand.** Phases 5-16 are DONE (Phase 16d, the speed vignette, deferred by R82). The package has 31
exports, 53 test files (684 tests), two vignettes and a website (<https://rmsharp.github.io/pedkindraw/>). It reads
version 0.0.1 and is not on CRAN. `R CMD check --as-cran` gives R16's NOTE only (Maintainer, "New submission");
CI passes on five jobs.

**What stands between this tree and a submission, riskiest first:**

1. **The check time** (section 2.1). CRAN's incoming check rejects a package whose check takes more than 10
   minutes on its machines (nprcgenekeepr's first 2.0.0 upload was rejected for "Overall checktime 12 min > 10
   min"). The whole check took 181 s here, 118 s of it tests. nprcgenekeepr measured win-builder at 3.4-3.8 times
   this machine, which gives 615-688 s, at or over the 600 s limit; nprcgenekeepr's own readings for nearly the
   same code spread from 284 to 617 s. Unsettled until measured where the limit applies: Phase 17a (R85).
   **Measured (17a, S33):** win-builder R-devel read 398 s, 142 s under R85's 540 s, with its tests on an idle
   machine; a busy day could read about 470-550 s. One more reading after 17j decides the cut (R86).
2. **Five pieces of work Mark put before the release** (R84; section 3): the argument-name review (17b-17c), two
   drawing fixes in copied code (17d-17e), the gaps document (17f), pedkindraw's own timing runs and the speed
   vignette (17g-17i), and tests for full coverage (17j). Each adds code, tests or pages, so the test-time cut
   (17k) and the release steps come after them.
3. **Suggests packages used in tests without a guard** (section 2.3): `mockery` and `withr`. CRAN's "noSuggests"
   check, run after publication, would fail on them. → 17l.
4. **Release housekeeping**: spelling and the `Language` field, the version number, NEWS, the README's install
   line, `cran-comments.md`, the cross-platform runs. → 17l-17o.

**nprcgenekeepr** (section 4): none of its 165 commits since the copy commit `baef1e12c` changes a copied file but
the legend change S12 already ported; its work in progress touches no copied function. It needs watching, not
work, unless it changes a copied function before the submission.

**How many sessions:** about 20 to 23 (a guess; section 8): 17a-17o and 17q are sessions, 17c is three (R93, S34;
S33's guess was 18 to 22 with 17c one or two), 17h may be several, 17k is at least one reading (R86, S33; S32's
guess was 17 to 22 with 17k possibly none), and 17p is Mark's action. The release follows the last of them.

---

## 2. Measured this session

### 2.1 The check time (this Mac, load average 5.3-12.7)

`R CMD build` then `R CMD check --as-cran --timings` on the tarball, from a scratch folder with renv's library
(`CLAUDE.md`, Build / Test / Verify), with `_R_CHECK_EXAMPLE_TIMING_CPU_TO_ELAPSED_THRESHOLD_` and
`_R_CHECK_TEST_TIMING_CPU_TO_ELAPSED_THRESHOLD_` at 2.5 (no NOTE: the tests run on one core, 118 s CPU in 118 s):

| Step | This Mac | win-builder estimate (×3.4-3.8) |
|---|---:|---:|
| build (vignettes built) | 16 s | not counted by CRAN |
| tests (`Running 'testthat.R'`) | 118 s | 401-448 s |
| examples (all 31 pages; `asPedFrame` 1.07 s) | 1.1 s | 4 s |
| vignettes re-built, PDF and HTML manual, the rest | 62 s | 211-236 s |
| **check total** | **181 s** | **615-688 s** |

`Status: 1 NOTE`, R16's. The machine was busy (another R process, two test runners and Spotlight; load average
5.28 at the start, 12.70 during), so these times are high, by an unmeasured amount. The ×3.4-3.8 ratio is
nprcgenekeepr's (its 2.0.0 cover note: examples 22 s against 80 s, tests 59 s against 200 s, vignettes 17 s
against 65 s), and its 3.0.0 readings on win-builder R-devel spread from 284 to 617 s for nearly the same code. The
estimate cannot say which side of 600 s the check falls: R85 measures it (17a).

**The tests in CRAN mode, file by file** (`testthat::test_dir()` on the installed check copy, `NOT_CRAN` unset):
684 tests, 0 failed, 8 skipped, 103.6 s summed. Eight files take 81% of it:

| File | Seconds | Cumulative share |
|---|---:|---:|
| `test_positionMatingUnitForest.R` | 16.5 | 16% |
| `test_asPedFramePedixplorer.R` | 15.8 | 31% |
| `test_makePedigreeMatingLayout.R` | 12.9 | 44% |
| `test_resolveEdgeNodeCollisions.R` | 12.5 | 56% |
| `test_asPedFrameHints.R` | 7.7 | 63% |
| `test_addRectilinearWaypoints.R` | 6.6 | 70% |
| `test_findUnrelated.R` | 6.2 | 76% |
| `test_comparePedigreeStructure.R` | 5.5 | 81% |

Six files already call `skip_on_cran()` in some tests. The Pedixplorer file runs on CRAN wherever Pedixplorer is
installed (CRAN's machines carry Bioconductor packages for Suggests).

**Measured on win-builder R-devel (Phase 17a, S33, 2026-11-17).** The tarball was built from `eaff4a7` by the
recipe above. `R/`, `tests/`, `vignettes/`, `man/`, `inst/` and `DESCRIPTION` are identical to `d00ebda`, the code
of S31's CI run. It is 1,382,525 B, SHA-256 `23386dc96ff7...`. It holds the 170 tracked files `.Rbuildignore`
keeps, less `.Rbuildignore` itself, plus the 7 the build makes, compared by machine. Claude uploaded it by FTP to
`ftp://win-builder.r-project.org/R-devel/` at 16:31 UTC (Mark's D1 pick: "I upload it via FTP (Recommended)").
The result is `https://win-builder.r-project.org/W1Ko4S0RDs2W/` (removed after about 72 hours): R-devel r90914
ucrt, Windows Server 2022, check started 16:40 UTC. Beside it is the same tarball checked on this Mac minutes
earlier (`R CMD check --as-cran --timings`, load average 13.3 at the start, 10.0 at the end):

| Step | win-builder R-devel | This Mac, same tarball | Ratio |
|---|---:|---:|---:|
| tests (`Running 'testthat.R'`), elapsed | 286 s | 136 s | 2.1 |
| tests, CPU (user + system, `proc.time()`) | 286.4 s | 124.9 s | 2.3 |
| re-building vignettes | 18 s | 10 s | 1.8 |
| R code for possible problems | 16 s | under 10 s | |
| examples (the process, elapsed) | 13 s (12.4 s) | 5.4 s | |
| PDF manual | 13 s | under 10 s | |
| **check time** | **398 s** | **208 s** (wall) | **1.9** |
| install | 11 s | not timed | |

- `Status: 1 NOTE`, R16's lines only (Maintainer, "New submission"). The incoming spelling step runs on
  win-builder (it flagged "de" in nprcgenekeepr's NOTE) and flagged no word here, as section 2.2 found.
- The tests read `[ FAIL 0 | WARN 0 | SKIP 9 | PASS 5400 ]`. Eight skips are this Mac's `skip_on_cran()` ones; the
  ninth is `test_diagramSolverEquivalence.R:318` ("this R does not use its own math library (Rblas)"), which passes
  here (5,401). The output also carries three `message()` lines from the copied
  `test_positionMatingUnitForest.R` (`:2078`, `:2178`, `:2530`); the check does not flag test output.
- **The tests ran on an idle machine:** 286.3 s elapsed for 286.4 s of CPU (264.3 user, 22.0 system).
  nprcgenekeepr's slower reading of one tarball (617 s against 520 s, its section 3.6) ran its tests at 1.54 s
  elapsed per CPU second. So 398 s is near this code's fastest reading, not its middle. The tests stretched by 1.54
  give about 550 s; the whole check scaled by 617/520 gives about 470 s.
- S32's estimate of 615-688 s, from nprcgenekeepr's ratio of 3.4-3.8, was high. For this package the ratio is 1.9
  against this Mac at load 10-13, and 2.3 for the tests' CPU time.
- **Decision (R86; Mark's pick "Decide after 17j (Recommended)"):** 17k is not needed on this reading. 17b-17j will
  add a guessed 10-40 s on win-builder: 17j's coverage tests the most, then 17i's speed vignette in the rebuild;
  17c's renames add nothing, and 17f's document is not in the package. With them the check would read about
  410-440 s on an idle machine and 480-590 s on a busy one. So 17k opens with one more win-builder reading of the
  tree after 17j (Mark approves the upload) and skips slow tests on CRAN only if that reading is over 540 s. 17o's
  reading of 540 s or less still gates the submission.

### 2.2 Static checks

- Every help page but the package's has `\value`; no page uses `\dontrun` or `\donttest`; all 31 export pages have
  examples (32 pages, `?pedkindraw` without).
- `R/` has no `options()`, `par()`, `setwd()` or `Sys.setenv()` call, no `cat()` or `print()` to the console (only
  inside `utils::capture.output()`, `R/comparePedigreeStructure.R`), no `:::` call, no `library()` or `require()`,
  and writes no file (`saveWidget()` appears in help text only).
- `inst/extdata` is 24 KB; the tarball 1,382,519 B; installed 4,284 KB of R77's 5,120 KB.
- **Spelling.** `R CMD check` here printed "No suitable spell-checker program found" when asked to spell-check
  (`_R_CHECK_CRAN_INCOMING_USE_ASPELL_=TRUE`): hunspell is installed without an English dictionary, so the
  incoming check's spelling step never runs on this Mac. `spelling::spell_check_package()` (spelling 2.3.2, R's own
  library) finds 49 words: 0 in `DESCRIPTION` (CRAN's incoming check reads only that), 12 of them in the vignettes
  or README, the others in help pages or NEWS. Among them British spellings ("colour", "grey", "labelled") under
  `Language: en-US`, and "vermillion".
- `DESCRIPTION` cites no reference; the methods' paper (Sinnwell, Therneau and Schaid 2014) is in eight help pages'
  `@references`.
- `Depends: R (>= 4.1.0)`; the oldest R that CI checks is oldrel-1 (4.5).

### 2.3 Suggests packages in the tests

The 9 Suggests are `chromote`, `htmlwidgets`, `kinship2`, `knitr`, `mockery`, `Pedixplorer`, `rmarkdown`,
`testthat`, `withr`. kinship2 and Pedixplorer are guarded inside the test blocks read (`skip_if_not_installed()`,
`test_bitSize.R:82`), and
the vignettes run their chunks only when each is installed (`eval = requireNamespace(...)`). Not guarded:
`mockery` in 4 files (`test_isAddedRecord.R` calls `mockery::mock()` with no skip) and `withr` in up to 19 files
(`test_shrinkPedigree.R:346` calls `withr::local_collate()`), counted by `grep`; which blocks fail without them is
17l's measurement. **R's own library holds 7 of the 9** (all but kinship2 and Pedixplorer; 242 non-base packages in
`.Library`), so `_R_CHECK_DEPENDS_ONLY_=true` on this Mac would hide only kinship2 and Pedixplorer (nprcgenekeepr's
dragon 9): 17l needs a library without them.

### 2.4 Names (for 17b)

- **Arguments that name the same thing differently:** `kinship(id, fatherId, motherId, ...)` beside
  `findGeneration(id, sire, dam)`, `findPedigreeNumber(id, sire, dam)`, `correctParentSex(id, sire, dam, ...)` and
  `familyCheck(famid, id, sire, dam, newfam)`; the pedigree is `ped` in 20 exports, `pedSourceDf` in
  `getOffspring()` and `getParents()`, `uPed` in `addBackSecondParents()` and `getIdsWithOneParent()`.
- **Argument order:** the pedigree comes first in most exports but after the ids in `getProbandPedigree(probands,
  ped)`, `getDescendantPedigree(probands, ped)`, `trimPedigree(probands, ped, ...)` and `hasBothParents(id, ped)`.
- **`addIdRecords()`** is copied and not exported (contract 4.1); the contract asks whether to export it.
- **Export names shared** with nprcgenekeepr 3.0.0.9000 (240 exports): 22 of pedkindraw's 31 (all but
  `asPedFrame`, `bitSize`, `checkPedigree`, `familyCheck`, `findAvailAffected`, `findAvailNonInform`,
  `findUnavailable`, `findUnrelated`, `ibdMatrix`); with kinship2 1.9.6.2: `bitSize`, `findAvailAffected`,
  `findAvailNonInform`, `findUnavailable`, `ibdMatrix`, `kinship`; with Pedixplorer 1.8.0: `kinship`. Loading
  pedkindraw with one of them masks these names (the shared kinship2 names are R3's parity by design).
- **Inventory by search** (`git grep -w` in `R/`, `tests/`, `vignettes/`, `README.Rmd`, `tools/`, `man/`):
  `fatherId` and `motherId` 14 lines each in 4 files (`R/kinship.R`, `man/kinship.Rd`, `test_kinship.R`,
  `test_kinshipMemoryEquivalence.R`); `pedSourceDf` 15 lines in 4 files (`R/getOffspring.R`, `R/getParents.R` and
  their pages); `uPed` 20 lines in 4 files (`R/addBackSecondParents.R`, `R/getIdsWithOneParent.R` and their pages);
  `addIdRecords` 12 lines in 4 files (`R/addBackSecondParents.R`, `R/addIdRecords.R`, `test_addIdRecords.R`,
  `tools/compareResultsWithNprcgenekeepr.R`). Calls by position, which an order change breaks:
  `getProbandPedigree(` 24 lines in 8 files, `getDescendantPedigree(` 20 in 7, `trimPedigree(` 8 in 8,
  `hasBothParents(` 6 in 5, `getOffspring(` 6 in 7, `getParents(` 6 in 6, `addBackSecondParents(` 5 in 6,
  `getIdsWithOneParent(` 2 in 4, `kinship(` 74 in 14 (the README and both vignettes among them). 17b repeats the
  search for each change it decides, and `tools/compareResultsWithNprcgenekeepr.R`'s `runCases()` is among the
  callers.

**Decided (17b, S34; R87-R93).** Measured at `5525edd` (`R/`, `tests/`, `vignettes/`, `man/` unchanged since
`d00ebda`), nprcgenekeepr at `366899961`. The name counts above held exactly. The call counts above are text matches
(definitions and help text among them); what a change breaks was counted by parsing instead: every call in `R/`,
the tests, `tools/`, the help examples (`tools::Rd2ex()`), the README and the vignettes (`knitr::purl()`), each
sorted by which arguments it passes by position, plus the fidelity tool's `fn("name")(...)` calls read by hand.
Outside the fidelity tool no code passes any of these functions bare (as in `lapply(ids, hasBothParents, ...)`);
the tool's one such use, `lapply(few, fn("hasBothParents"), ped = ped)` (`:268`), names `ped`.

| Ruling | Change (made in) | What the change touches, measured |
|---|---|---|
| R87 | `kinship(id, sire, dam, pdepth, ...)`, were `fatherId`, `motherId` (17c1) | 43 calls to pedkindraw's `kinship()` here (3 more are kinship2's), 42 by position; the one by name is the copied C13 test (`test_kinship.R:241`), which also checks the names with `expect_named(formals(kinship), ...)`. The error message "fatherId, motherId and pdepth must each be as long as id" (`R/kinship.R:115`) and its 3 expected copies (`test_kinshipMemoryEquivalence.R:74-76`). The fidelity tool's 8 calls pass them by position. Files: `R/kinship.R`, `man/kinship.Rd`, the two test files, `DIVERGENCE.md` |
| R88 | `getParents(ped, ids)`, `getOffspring(ped, ids)` (were `pedSourceDf`), `getIdsWithOneParent(ped)`, `addBackSecondParents(trimmedPed, ped)` (were `uPed`) (17c2) | 24 calls (19 here, 5 in the fidelity tool), none passing these arguments by name; 35 lines (`pedSourceDf` 15, `uPed` 20) in `R/getParents.R`, `R/getOffspring.R`, `R/getIdsWithOneParent.R`, `R/addBackSecondParents.R` and their 4 help pages. Tests for the new names go in `test_getParents.R`, `test_getOffspring.R`, `test_addBackSecondParents.R` (no test file calls `getIdsWithOneParent()`; `addBackSecondParents()` reaches it) |
| R89 | `getProbandPedigree(ped, probands)`, `getDescendantPedigree(ped, probands)`, `trimPedigree(ped, probands, ...)`, `hasBothParents(ped, id)` (17c3) | 65 calls: the 42 that name `probands =` or `ped =` keep working; the 23 that pass both by position are rewritten: `R/trimPedigree.R:59`, `R/addBackSecondParents.R:45` (`:49` since S36's 17c2 header, `:50` since S37's), the help examples in `R/trimPedigree.R` (2) and `R/hasBothParents.R` (2), `test_trimPedigree.R` (4), `test_kinshipHasBothParentsHelp.R` (4), `vignettes/pedkindraw.Rmd:152`, `:163`, `:302`, and `tools/compareResultsWithNprcgenekeepr.R:104`, `:124`, `:157`, `:227`, `:228`, `:291`, which then name their arguments so one call runs on both packages (`:268`'s `hasBothParents` call already names `ped`). An old-order call stops with "$ operator is invalid for atomic vectors" in each of the four (a scratch run), never a wrong answer |
| R90 | `addIdRecords()` stays internal | nothing |
| R91 | the shared export names stay; `kinship()`'s help and the README say which names kinship2 and Pedixplorer share and that their `kinship()` takes a pedigree object (17c1) | `R/kinship.R`'s help, `README.Rmd` and `README.md` |
| R92 | `kinship()` stops when a known parent's `pdepth` is not below its offspring's; its help says the 4th argument is `pdepth`, not kinship2's `sex` (17c1) | `R/kinship.R`, its help, a test file; the cases: kinship2's `sample.ped` (both families) and `minnbreast` (426 families), where the check stopped the sex-codes call in every family and passed `findGeneration()`'s numbers in every family |
| R93 | 17c is three sessions: 17c1, 17c2, 17c3 | section 6 |

Each of R87-R89 and R92 is a divergence from nprcgenekeepr (D2): 9 `DIVERGENCE.md` rows in all (`kinship()`, for
R87 and R92; the four of R88; the four of R89; `addBackSecondParents()`'s row from R88 also covers its call to
`hasBothParents()`), each until nprcgenekeepr makes the same change in a session there. Each changed copied file's
header ("Changes: help text only; the function's code is unchanged") is rewritten to say what changed.
nprcgenekeepr's own callers outside each function's file, for such a session (a text count, `git grep` at `366899961`, `R/` and `inst/application`): `kinship(`
24 lines, `trimPedigree(` 2, `getProbandPedigree(` 2, `getParents(` 2, `getOffspring(` 2, one each for the others.

### 2.5 Version, CI and the website

- The version lives in `DESCRIPTION:4` (`0.0.1`) and `NEWS.md:1` (`# pedkindraw 0.0.1 (development version)`);
  `README.Rmd:42` says "pedkindraw is not on CRAN yet". No other file outside `renv.lock`, `methodology/` and
  `docs/` names `0.0.1`.
- CI (`.github/workflows/R-CMD-check.yaml`): five jobs, macOS release, Windows release, Ubuntu devel, release and
  oldrel-1; `r-lib/actions/check-r-package@v2` with `--no-manual`; `actions/checkout@v4` (the Node 20 notice,
  a backlog item). None is win-builder, macOS on R-devel, or CRAN's incoming check.
- The site (`.github/workflows/pkgdown.yaml`) rebuilds on each push to master that touches more than `CLAUDE.md`
  and `methodology/**`, and by hand; not on a release or tag. `.Rbuildignore` has no line for `cran-comments.md`
  or `CRAN-SUBMISSION`.
- Release tools: `devtools`, `rhub`, `rcmdcheck`, `urlchecker` and `usethis` are installed neither in renv nor in R's
  own library; `spelling` and `pkgdown` are in R's own library.

---

## 3. The open work: before or after the release

Mark's picks (R84) put the first five before the release; the rest is ruled here by its effect on the release.

| Backlog item (`methodology/BACKLOG.md`) | When | Phase | Why |
|---|---|---|---|
| Review argument names | before | 17b-17c | contract section 6: after the first release a rename needs a `.Deprecated()` cycle |
| "Select by id" lists invisible routing points | before | 17d | R84; shows in the drawing vignette's colony drawing (196 of 571 entries) |
| The legend cuts its "Same animal, again" label | before | 17e | R84; shows on the website's drawings |
| What kinship2 or Pedixplorer can do that pedkindraw cannot | before | 17f | R84; Mark can then decide whether a gap is closed first |
| The speed and size-limits vignette, once pedkindraw times itself | before | 17g-17i | R84, R82's condition |
| Tests for full coverage | before | 17j | R84 |
| The suite gate's time limit is below the suite's time | before | 17l | the full gate (17n) needs the gate measured, not unmeasured |
| A stale pedkindraw 0.0.1 in renv's library | before | 17l | anything that loads pedkindraw without installing runs the stale copy |
| CI notices: `actions/checkout@v5` and Ubuntu 26 | before, if still shown | 17l | the release's CI must stay green |
| After nprcgenekeepr has the legend's section pictures (R81) | after | none | waits on nprcgenekeepr; `DIVERGENCE.md` records it until then |
| The drift tool does not watch copied constants | after | none | the release does not depend on it; both constants unchanged in nprcgenekeepr (section 4.1) |
| `findPedigreeNumber()`'s speed | after | none | new work; contract section 10 item 5 |
| Point the context-budget tool at `methodology/`; the dashboard and `BACKLOG.md` | after | none | methodology, not the package |
| Report a vacuous test; tell nprcgenekeepr's edition-3 conversion | not here | none | nprcgenekeepr sessions, which Mark starts (R8) |
| Whether pedkindraw copies nprcgenekeepr's colony overview | after | none | DECISION NEEDED later; would need a ruling and a plan change |

If 17f leads Mark to close a gap before the release, that work becomes a phase of its own by ruling, placed before
17g so the timing runs and the coverage measure the code that ships. **R97 (S41):** every gap, phases G1-G17 of
`docs/planning/gaps-and-shared-code-plan.md`.

---

## 4. nprcgenekeepr

### 4.1 Its changes since the copy (measured)

- The 79 files whose header says "Copied from nprcgenekeepr" (34 in `R/`, 45 in `tests/testthat/`) name their
  source commit: `baef1e12c` for 77, `4283e3502` for `R/drawPedigreeDiagram.R`, `392dd347e`
  for its test file. nprcgenekeepr has 165 commits after `baef1e12c` (to `363137511`); **0 change any of those
  source files after the commit each was copied at** (`git log <commit>..HEAD -- <source>` per file). The only
  earlier change to a copied file, S1159's legend, was ported in pedkindraw S12 (R37).
- `tools/compareWithNprcgenekeepr.R`: 91 copied functions in 33 files, 5 differ, 0 without a `DIVERGENCE.md` row
  (the 5 are pedkindraw's own changes: Phase 15's hints, R81's legend pictures).
- Its changes since then are elsewhere: the colony overview (#138, S1153-S1155: `makeColonyOverview()`,
  `drawColonyOverview()`, `getMaternalLinePedigree()`, three new exports, and `.checkOnClick()`, which pedkindraw
  copied with `drawPedigreeDiagram()`), the Shiny "data ready" signals (S1170-S1177), `rankCombined()`, tutorial and
  vignette tests, and S1178 in progress (living-offspring counts in `offspringCounts()` and `reportGV()`). None of
  these functions is copied.

### 4.2 What is pending between the two

- **R81, from pedkindraw to nprcgenekeepr:** the legend's section pictures, to be ported there in a session Mark
  starts (backlog item BLOCKED). Two `DIVERGENCE.md` rows until then; not a release blocker.
- **The two drawing fixes (17d, 17e):** nprcgenekeepr's `R/drawPedigreeDiagram.R` has the same `__jog_` filter and
  the same legend label, so each fix is a drift-rule choice at its pre-RED picker (D3).
- **nprcgenekeepr's `BACKLOG.md` "Not yet mirrored (S1159)" line is stale:** pedkindraw S12 ported that change. For
  an nprcgenekeepr session to remove (R8: pedkindraw's sessions leave nprcgenekeepr unchanged).
- **nprcgenekeepr's edition-3 conversion** (R29) has not started (its `DESCRIPTION` names no edition).

### 4.3 What the release changes

- **The API freezes.** After the first CRAN release an export or argument is removed only after one release with
  a `.Deprecated()` warning (contract section 6). A later port of an nprcgenekeepr change that alters a copied
  function's arguments then needs that cycle, or stays a `DIVERGENCE.md` row.
- **A port reaches users only with a pedkindraw release**, and nprcgenekeepr's next CRAN release (with the colony
  overview) does not wait for pedkindraw's, nor pedkindraw's for it (R8).
- **Two packages with the same function names on CRAN** (section 2.4): a user who loads both gets masking
  messages. The "Later, optional" step of the standalone plan (nprcgenekeepr uses pedkindraw) would end the
  duplication; it is Mark's decision and not part of this plan. **Ruled S41 (R98, R100):** after acceptance
  nprcgenekeepr imports pedkindraw and re-exports the 22 shared functions, which ends the masking messages
  (`docs/planning/gaps-and-shared-code-plan.md`).
- **NEWS names the copy:** "a copy of nprcgenekeepr's at nprcgenekeepr's commit `baef1e12c`" (`NEWS.md`), and
  points to `DIVERGENCE.md`, which `.Rbuildignore` leaves out of the package: 17m words it as a file in the
  repository, as it does now.

### 4.4 The guard

Every phase's Orient runs the drift tool and `git -C ../nprcgenekeepr log --oneline <copy commit>..HEAD --` the
copied files (Learning 15), as S12-S32 did. A change found to a copied function during Phase 17 is handled by R37:
ported in a session of its own (a phase added by ruling) or recorded in `DIVERGENCE.md`; whether it holds the
release is Mark's call at that Orient. 17n and 17o repeat both checks as DONE items, so the submitted tarball's
state against nprcgenekeepr is known and written in `cran-comments.md`'s notes for the record (not for CRAN).

---

## 5. The comparison with kinship2 and Pedixplorer

**What exists.** The comparison study (`docs/research/pedigree-package-comparison-2026-11.md`, nprcgenekeepr
S1122-S1126): agreement of results (section 5), timing, memory and capacity (7, 9), drawing (8), and what is left to
offer (10: the drawing, not the computation; missing beside the others, SVG and PDF export and a fitted view of a
large pedigree that shows ids). The kinship2 gap analysis (`docs/research/kinship2-feature-gap-analysis-2026-09-20.md`,
kinship2's 25 exports, written for nprcgenekeepr before pedkindraw existed). In the suite, the new exports are
compared with kinship2 where it returns (`bitSize()`, `findUnavailable()`, `findAvailNonInform()`,
`findAvailAffected()`, `familyCheck()`, `ibdMatrix()`, `findUnrelated()`, `kinship()`'s X chromosome, the
converters), skipped without it; `tools/compareResultsWithNprcgenekeepr.R` holds the copied code to nprcgenekeepr's
results (600 of 600 identical, S30).

**What is pending, both before the release (R84):**

- **The gaps document (17f):** each thing kinship2 1.9.6.2 or Pedixplorer 1.8.0 (both in renv) can do that
  pedkindraw cannot, shown on a typed case (Learnings 18-19), under `docs/research/`. Deciding which gaps to close
  is Mark's, afterwards.
- **The speed and size comparison (17g-17i):** R82: "the comparison of pedkindraw with kinship2 and Pedixplorer"
  waits until pedkindraw has timing runs of its own installed code, under a plan of its own that replaces R79's
  summary of nprcgenekeepr's records. Mark at S30: "Disambiguation between pedkindraw and nprcgenekeepr may need to
  wait until pedkindraw is completely separated. That is, this comparison may be premature." He then picked
  "pedkindraw times itself" over full separation. The draft built to R79 is on the branch `draft/speed-vignette`
  (`612eed9`: `vignettes/speed.Rmd`, 372 lines, nine tables; `tools/checkSpeedTables.R`, 709 lines, which checks
  every cell against committed result files). Its design carries over; its numbers do not.

**What the release needs from them:** nothing CRAN checks. The vignette adds a third page to the installed package
(R77 measured each page with drawings at 1.6-1.9 MB, the visNetwork JavaScript it carries; a page without
drawings carries none, and 17i measures its size; 836 KB are left under 5,120 KB) and must not time anything while
it builds: CRAN rebuilds vignettes inside the 10-minute check, so its tables read committed results, as the
draft's do.

---

## 6. Phases

Each phase is one session unless it says otherwise; close out when its DONE is met. Every session runs the checks
in `CLAUDE.md`'s Build / Test / Verify table that its changes touch, and at Orient the drift tool and Learning 15's
log (section 4.4). "Surface" names where DONE is shown and what that place cannot show.

### Phase 17a. The check time on win-builder (R85)

- **Work:** build today's tarball as section 2.1 did; upload it to win-builder R-devel (D1 decides who); read the
  emailed log: "Check time in seconds", each step's time, the NOTEs (the spelling step runs there). Record the
  numbers in this plan (section 2.1) and the ledger.
- **DONE:** the R-devel reading is in this plan, with the tarball's commit; the decision whether 17k is needed
  is stated against the 540 s target (R85), counting what 17b-17j will add.
- **Commands:** `R CMD build` from scratch (section 2.1); `uptime` beside any local timing.
- **Surface:** win-builder R-devel, the class of machine CRAN's limit is enforced on; not CRAN's incoming pretest
  itself, which only a submission reaches. One reading (nprcgenekeepr saw 284-617 s for nearly the same code), so a
  reading near 540 s is uploaded again before it decides anything.
- **Outward action:** an upload sends the package to win-builder and an email to the maintainer; Mark approves it
  in the session.
- **Done (S33):** 398 s on win-builder R-devel (`W1Ko4S0RDs2W`), tarball from `eaff4a7`, `Status: 1 NOTE`
  (R16's); its tests ran on an idle machine, so a busy day could read about 470-550 s. 17k is decided by one more
  reading after 17j (R86). Section 2.1 has the steps and the reasoning.

### Phase 17b. The argument-name review (a decision session)

- **Work:** for each item of section 2.4 (argument names, argument order, `addIdRecords()`, the shared export
  names), a picker states what changes, the call sites by search, what it breaks (callers by position, the copied
  tests, `runCases()`, the README and vignettes) and the drift cost (each change a `DIVERGENCE.md` row; the drift
  tool then lists the function). Mark picks; the picks become rulings; the contract's sections 4 and 6 say what
  changed.
- **DONE:** a ruling per item (change or keep), the contract updated, the inventory of each change in this plan.
  No code changed.
- **Surface:** documents only.
- **Done (S34; R87-R93):** seven rulings from seven questions in three pickers, each Mark's pick of Claude's
  recommendation: `kinship()` says `sire` and `dam` (R87); the pedigree argument is `ped` everywhere, `trimmedPed`
  beside it in `addBackSecondParents()` (R88); the pedigree comes first in every export that takes one (R89);
  `addIdRecords()` stays internal (R90); the shared export names stay, with a note in `kinship()`'s help and the README (R91);
  `kinship()` refuses a `pdepth` that puts a parent at or after its offspring (R92, a silent wrong answer found
  while measuring the shared names); 17c is three sessions (R93). The inventory: section 2.4. The contract's
  sections 4 and 6 give the new signatures.

### Phase 17c. The renames and the `pdepth` check (strict TDD; three sessions, R93)

Each session is one RED-GREEN-REFACTOR cycle, the gates put to Mark: RED adds tests that call the new names or
order (`expect_named(formals(f), ...)` among them) and fail; GREEN changes the functions, their help, every caller
from section 2.4's inventory, the `DIVERGENCE.md` rows and the copied files' headers; REFACTOR at Mark's gate. Each
session re-runs section 2.4's parse of the calls on its own tree first (the counts are `5525edd`'s), and
`git -C ../nprcgenekeepr log` on the files it changes (Learning 15).

- **17c1, `kinship()` (R87, R91, R92):** the parent arguments `sire` and `dam` (the copied C13 test and the three
  expected messages change with them); the `pdepth` check, with a plain message naming the first offending
  animal (the message's words are GREEN's to propose), tested on typed cases and on kinship2's `sample.ped` and
  `minnbreast` under `skip_if_not_installed("kinship2")`. The check goes after the existing input checks (they
  end with the MZ twins' check, `R/kinship.R:134`-`:136` at `5525edd`), so the errors the fidelity tool's
  `kinshipErrors` cases compare stay the same; every
  other `kinship()` case there passes `findGeneration()`'s numbers or founders at 0 (read at `5525edd`), which the
  check passes, so those results stay identical to nprcgenekeepr's. The help says the 4th argument is `pdepth`, not
  kinship2's `sex`, and, with the README, which names kinship2 and Pedixplorer share. About 7 files.
  **Done (S35):** RED `3faf597`, GREEN 1 `9e72121`, GREEN 2 `5adcba9`; REFACTOR skipped (Mark's pick: the
  internal names `father` and `mother` stay as nprcgenekeepr has them). 10 files: `R/kinship.R`, `man/kinship.Rd`,
  `DIVERGENCE.md`, `README.Rmd`, `README.md`, `NEWS.md`, `test_kinship.R`, `test_kinshipMemoryEquivalence.R`, the
  new `test_kinshipPdepthOrder.R` (23 expectations; kinship2's call form stopped in all 2 + 426 families in 0.19 s,
  so no CRAN skip), and `test_maleLeftDuplicateMate.R`, which no inventory named: `smallPed`'s stored `gen`
  is wrong in 8 of its 17 animals (L and M in their sire's generation), so the layout's own `kinship()` call
  stopped; the test now computes it with `findGeneration()` (Mark's pick; a port to nprcgenekeepr needs the same
  line). The message (Mark's pick): "pdepth must be greater for each animal than for its sire and dam: C has 1 and
  its dam B has 1 (pdepth is the 4th argument, generation numbers such as findGeneration() gives, not sex)". R91's
  "their `kinship()` takes a pedigree object" was half the story: kinship2's `kinship.default()` and Pedixplorer's
  method for `"character"` also take `id`, `dadid`, `momid`, `sex`, which the help and README now say. Fidelity
  tool 600 of 600 identical; `R CMD check --as-cran` R16's NOTE only.
- **17c2, the pedigree argument (R88):** `getParents()`, `getOffspring()`, `getIdsWithOneParent()`,
  `addBackSecondParents()`. No caller changes. About 12 files.
  **Done (S36):** RED `ef101e8`, GREEN 1 `91f65e5`, GREEN 2 `858cfc9`, GREEN 3 `7d4de5d` (NEWS, Mark's pick);
  REFACTOR skipped (Mark's pick: the code keeps nprcgenekeepr's line breaks, so a port is the rename alone). 14
  files: the four `R/` files and their pages, `DIVERGENCE.md` (four rows), `NEWS.md`, `test_getParents.R`,
  `test_getOffspring.R`, `test_addBackSecondParents.R` and the new `test_getIdsWithOneParent.R` (Mark's pick: a
  file of its own, the function's first direct test). The parse found R88's 24 calls, none naming the old
  arguments, and the whole suite passed on a scratch copy with the renames drafted, before RED. Under the old names
  R's partial matching let `getParents(ped = )` and `getOffspring(ped = )` reach `pedSourceDf`, so in those two
  RED blocks only the names check failed (dragon 20). Fidelity tool 600 of 600 identical; `R CMD check --as-cran`
  R16's NOTE only.
- **17c3, the pedigree first (R89):** `getProbandPedigree()`, `getDescendantPedigree()`, `trimPedigree()`,
  `hasBothParents()`, and the 23 calls section 2.4 lists, the fidelity tool's given names. About 16 files. Also
  `getParents()`'s `@param ped` (`R/getParents.R:14`-`:16`: the pedigree is first "unlike getProbandPedigree() and
  getDescendantPedigree(), which take the animal ids first"), which 17c3 makes false; `getOffspring()`'s page
  inherits it (S36's search: no other help text describes the order).
  **Done (S37):** RED `374f970`, GREEN 1 `8f921d5` (`getProbandPedigree()`, `trimPedigree()`, the vignette's three
  calls), GREEN 2 `6a2caf9` (`getDescendantPedigree()`, `hasBothParents()` and `addBackSecondParents()`'s call),
  GREEN 3 `4602b7c` (the fidelity tool's calls name `ped` and `probands`; four `DIVERGENCE.md` rows), GREEN 4
  `2b6ef7a` (`getParents()`'s order sentence dropped, a NEWS bullet; Mark's picks); REFACTOR skipped (Mark's pick).
  21 files: the five `R/` files and six pages, the vignette, the fidelity tool, `DIVERGENCE.md`, `NEWS.md`, and five
  test files, among them the new `test_hasBothParents.R` (Mark's pick). The parse at `e241cd0` found R89's 65 calls
  exactly (42 unchanged by the order, 23 to rewrite), and the whole suite passed on a scratch copy with all of them
  drafted (703 blocks), before RED. The 8 old-order test calls changed in RED (Mark's pick), so `test_trimPedigree.R`,
  whose 4 calls run outside `test_that()`, failed RED as one file error (dragon 21). Each of the four now stops on
  an old-order call ("$ operator is invalid for atomic vectors"), tested. Fidelity tool 600 of 600 identical against
  nprcgenekeepr at `8ebd33d39`; `R CMD check --as-cran` R16's NOTE only on a second run (the first also listed a
  GitHub link at 503, which answered 200 a minute later).
- **DONE (each):** suite 0 failed, WARN 0; lint 0; roxygen idempotent; `R CMD check --as-cran` R16's NOTE only; the
  drift tool lists each changed function with its row; the fidelity tool's cases run under the new names, all
  identical; `git grep` of each old name finds only history and headers; CI 5/5.
- **Surface:** this Mac and GitHub Actions.

### Phase 17d. "Select by id" leaves out the routing points (strict TDD)

- **Work:** the backlog item: `R/drawPedigreeDiagram.R:292`'s filter gains `__jog_`; a test reads
  `drawPedigreeDiagram(layout)$x$idselection$values` on a layout with jogs. The drift choice first (D3).
- **DONE:** the colony drawing's box lists its 375 animals only; the checks as 17c; the drawing vignette's
  colony drawing checked in headless Chrome.
- **Surface:** this Mac, headless Chrome, GitHub Actions.
- **Done (S38; R94):** ruling `2ac5308` (Mark's pre-RED picks: the input check too, "Box and check"; "Port
  later"); RED `88798f0` (one test per file, 2 of 705 blocks failing); GREEN 1 `21a164e` (the filter and the input
  check gain `__jog_`), GREEN 2 `e75171e` (the fidelity tool's `withoutJogSelections()`; two `DIVERGENCE.md` rows),
  GREEN 3 `48e4c92` (two NEWS bullets); REFACTOR `7c9e306` (Mark's pick over Claude's "skip": the six prefixes
  written once, `.reservedIdPrefixes` and `.reservedIdPattern`, read by the check and the filter; a before/after
  record of 14 ids' check results and 5 drawings, identical). Measured before RED on scratch copies: smallPed with
  B renamed `__jog_1_a` gave two nodes of that id and no error; the vignette's colony box drawn in headless Chrome,
  572 options (the placeholder, 375 animals, 196 `__jog_`); pedkindraw's own fidelity runs, 33 of 600 results
  differing only by 3,152 `__jog_` box entries. After: suite 705 blocks, 0 failed, WARN 0; the shipped vignette's
  colony box (read from `R CMD build`'s tarball) 376 options; fidelity 600 of 600 against nprcgenekeepr at
  `83c50c611`; `R CMD check --as-cran` R16's NOTE only.

### Phase 17e. The legend's "Same animal, again" label fits (strict TDD)

- **Work:** the backlog item: measure first whether a shorter label (`R/drawPedigreeDiagram.R:121`, `:119`
  before S38's header lines) or a wider legend column fixes it at both widths (the website's 776 px widget, the
  vignette's 700 px column); the drift choice (D3).
- **DONE:** the label whole at both widths in headless Chrome, by a check that fails on the cut label; the
  checks as 17c.
- **Surface:** headless Chrome at two widths; it cannot show every reader's font.
- **Done (S39; R95):** measured first, the label was not cut by the legend's width: `visLegend()` gives every
  legend line an arrowhead when it has no `arrows` value, and it covered the label's end (5.5 px at the website's
  776 px widgets, all 12 live drawings; 10.1 px at 700 px), while the diagram's lines have none; the dashed line
  through the comma read as a semicolon. Ruling `37c41cf` (Mark's pre-RED picks: "No arrowheads, white label" over
  no arrowheads alone, a shorter label (covered again at 600 px) and a 35% legend (1.5 px clear at 700 px, covered
  at 600 px); "Port later"); RED `b35911a` (a new file, `test_drawPedigreeDiagramLegendLines.R`: the two columns,
  and in headless Chrome at 776 and 700 px with 0 and 4 conditions no arrowhead over a label, each on white and
  inside the legend; 2 of 707 blocks failing); GREEN 1 `eb1e845` (`arrows` `""` and `font.background`
  `"#FFFFFF"` in the legend's line table), GREEN 2 `fab63a8` (the fidelity tool's `withoutLegendLineStyle()`; the
  `DIVERGENCE.md` row), GREEN 3 `f4f5744` (a NEWS bullet); REFACTOR `9505d9d` (Mark's pick over Claude's "skip":
  the tool's three set-asides walk the results through one `eachDrawing()`; a before/after record on one saved
  set of raw results, identical). Measured before RED on scratch copies: the whole suite on the draft, 705 blocks,
  0 failed; pedkindraw's own fidelity runs, 48 of 600 results differing only by the two columns. After: suite 707
  blocks, 0 failed, WARN 0; the shipped vignettes (from `R CMD build`'s tarball) in headless Chrome, 12 drawings
  700 px wide, 48 of 48 line labels whole, on white, no arrowhead; fidelity 600 of 600 against nprcgenekeepr at
  `3b8bf9374`; `R CMD check --as-cran` on `f4f5744` R16's NOTE only.

### Phase 17f. The gaps document

- **Work:** the backlog item: `docs/research/` gains a dated document listing each gap with its evidence,
  re-checking the gap analysis's rows against pedkindraw's exports (as 17b-17e leave them) and Pedixplorer's
  exports and help. Mark then decides, by picker, whether any gap is closed before the release (D4).
- **DONE:** each gap shown on a typed case, run with kinship2 and Pedixplorer from renv, each case in
  `tryCatch()` with a time limit (Learning 19); D4 answered.
- **Surface:** this Mac; the claims cover the cases run (Learning 19).
- **Done (S40; R96):** `docs/research/pedkindraw-gaps-2026-11-18.md` (claim `2626c16`, document `c267ffd`,
  sections 1.1 and 10 `210a901`): 16 open gaps, A pictures outside the browser (A1 PDF, SVG and PNG files from a
  script; A2 every id of a large pedigree in one picture; A3 an app), B what a drawing shows (B1 mates with no
  offspring; B2 an unknown affected status; B3 Pedixplorer's carrier, proband and other marks; B4 a measured trait;
  B5 colours and sizes; B6 labels over 15 characters; B7 a picture of what shrinking removed), C computing and input
  (C1 relatives within k steps; C2 aligned generations; C3 the layout's own hints; C4 parents written "0" and other
  sex codes; C5 offspring counts and mates; C6 removing a parent in one call). Each on a typed case of
  `tools/gapCases.R`: 20 cases, each in its own R process under GNU `timeout`, all exit 0 in 82 s; the run recorded
  beside the document. Section 6: R3's block kinship measured (minnbreast's 28,081 people: kinship2 0.4 s and 202 MB,
  pedkindraw 14.4 s and 8,863 MB, values identical). Section 10, at Mark's question: nprcgenekeepr at `ae3491dff`
  has 13 of the 16 too and closes 3 in whole or part (its app, `convertSexCodes()`, `offspringCounts()`), measured on
  its own code by `tools/gapCasesNprcgenekeepr.R`. D4: Mark asked to clarify at its picker, then directed a
  planning session (R96), Phase 17f2.

### Phase 17f2. The plan for closing the gaps in both repositories (a planning session; R96)

- **Work:** a plan under `docs/planning/`, answering Mark's direction (R96), in his words: "create a plan to
  eventually close the gaps, where possible, in nprcgenekeepr and pedkindraw such that (1) the first version of
  pedkindraw for submission to CRAN is as complete as we decide during the planning session; (2) we discuss
  refactoring nprcgenekeepr to use function calls as if we were dependent on pedkindraw; (3) decide if we want
  pedkindraw functions in nprcgenekeepr with the intent of replacing them with a dependency on pedkindraw once
  pedkindraw is accepted by CRAN (not a certain outcome).(4) figure out how to best coordinate work between
  nprcgenekeepr and pedkindraw repositories. (5) Acknowledging that nprcgenekeepr will not necessarily need all of
  the functionality provided by pedkindraw." And: "Pausing development of one repository while waiting on progress
  in the other is an acceptable option." Inputs: the gaps document (sections 1, 1.1 and 10), R8 and section 4's
  "Later, optional" of the standalone plan, `DIVERGENCE.md` (14 copied functions differ), the drift rule (its
  section 5), the ports waiting in nprcgenekeepr (R81, R94, R95), and nprcgenekeepr's own calls to the 91 copied
  functions (an inventory by `grep`, Learning 6: by citation as well as by name).
- **DONE:** the plan committed with its decisions put to Mark by picker and recorded as rulings: which gaps, if any,
  close before the first release (D4), each then a phase with its DONE, commands and surface; whether and how
  nprcgenekeepr calls pedkindraw's functions, or carries them until pedkindraw is on CRAN; which of pedkindraw's
  functions nprcgenekeepr needs; how work in the two repositories is ordered (pausing one is allowed). No code.
- **Surface:** documents only; nprcgenekeepr is read, not changed (R8, until Mark rules otherwise).
- **Session boundary:** one planning session; the deepest reasoning setting (`methodology/SESSION_RUNNER.md`,
  Planning Sessions).
- **Done (S41; R97-R101):** `docs/planning/gaps-and-shared-code-plan.md` (claim `f709b00`, evidence `5bebd3c`,
  decisions and phases `da69a34`). Measured first: nprcgenekeepr at `eafd54851` calls 20 copied functions 57 times
  from 24 files (13 pedkindraw exports, 7 internals; 4 calls in the order R89 changed); its whole suite on scratch
  copies with pedkindraw's functions in place of its copies, 55 of its own 467 test files failing, 31 once the 4 calls
  pass the pedigree first, each left a change pedkindraw made on purpose (R81, R88-R89, R92), a test of its own
  source, or one perf test not traced; two faults in nprcgenekeepr found by R92's check (its kinship simulation
  passes stale generations, wrong in 200 of 200 draws of its vignette's case, also in 3.0.0; `smallPed` stores 8 of
  17 generations wrong); CRAN policy revision 6985 read. Mark's picks: every gap before the release (R97); nprcgenekeepr
  names its calls now and imports pedkindraw after acceptance (R98); its two faults fixed first (R99); it re-exports
  the 22 shared exports (R100); changes to the copied functions start in pedkindraw until then (R101).

### Phases G1-G17. The gaps, closed before the release (R97)

- **Work, DONE, commands and surface:** section 5.1 of `docs/planning/gaps-and-shared-code-plan.md`, one row per
  phase: G1 N (a number in a condition column reported), G2 B2 (an unknown affected status drawn), G3-G9 the size-S
  additions, G10-G14 the M additions, G15-G17 the L additions (B1, A1 with A2, A3), each L phase planned first.
  Strict TDD; every addition leaves the fidelity tool's 600 cases identical; copied code gets a `DIVERGENCE.md` row
  marked "at the switch" (R98).
- **Sessions:** 38-53 (a guess; that plan's section 7.1).
- **Done G1 (S42; R102-R105):** a condition column holding a number other than 0 and 1 stops, naming the column and
  the numbers, at the layout's, the diagram data's and the shrink functions' reads; `bitSize()` and
  `findUnavailable()` do not read the column. Commits `17da874` (RED) to `ba01a0c` (REFACTOR); fidelity 600 of 600.
- **Done G2 (S43; R106-R107):** an unknown affected status is filled grey (`#BEBEBE`) with one condition, or its
  section is grey with two to four, and the legend has a grey row "Affected status unknown" (45 px more). Commits
  `b11d1d9` (RED) to `638b394` (REFACTOR); fidelity 600 of 600 with a counted set-aside of 66.
- **Done G3 (S44; R108-R110):** `makePedigreeDiagramData()` and `makePedigreeMatingLayout()` take `maxNameChars`
  (15 by default as before; `Inf` writes every name whole; a line break counts). Commits `c0a96a8` (RED) to `fefc4d7`
  (REFACTOR, comments only); fidelity 600 of 600 with no set-aside.
- **Done G4 (S45; R111-R113):** `makePedigreeDiagramData()` and `makePedigreeMatingLayout()` take `conditionColors`
  (the four colours as before by default; any colour R knows, written as its code); the drawing paints its sections
  and legend from the layout's colours. `grDevices` joins Imports. Commits `b978aeb` (RED) to `cc4189f` (REFACTOR,
  tests only); fidelity 600 of 600 with no set-aside.
- **Done G5 (S46; R114-R116):** the new export `recodePedigree()` rewrites other ways of writing an unknown parent
  (`"0"`, `"NA"` and blanks by default) and a sex (the words, their first letters, 1-4) into pedkindraw's codes.
  Commits `aaac3af` (RED) to `973a345` (REFACTOR, one shared rule for the codes); fidelity 600 of 600 with no
  set-aside.
- **Done G6 (S47; R117-R119):** the new exports `countOffspring()` (each animal's offspring, each once) and
  `getMatings()` (each sire and dam with an offspring together, with the number they share). Commits `8db2330`
  (RED) to `c42c9ae` (REFACTOR, tests only); fidelity 600 of 600 with no set-aside.
- **Done G7 (S48; R120-R122):** the new export `removeAnimals()` removes the listed animals and clears each sire or
  dam entry naming one of them, the offspring keeping its other parent. Commits `36c5b4a` (RED) to `c223f09`
  (REFACTOR, one ids check with `countOffspring()`); fidelity 600 of 600 with no set-aside.
- **Done G8 (S49; R123-R124):** `findGeneration()`'s new argument `alignMates = FALSE` aligns the generations when
  `TRUE`, by a rule measured from kinship2's `kindepth(align = TRUE)` that does not depend on the order of the rows;
  copied code changed, with a `DIVERGENCE.md` row. Commits `2f8751f` (RED) to `a0b6956` (REFACTOR, tidy-ups in
  `.alignGenerations()`); fidelity 600 of 600 with no set-aside.
- **Done G9 (S50; R125-R126):** `?shrinkPedigree`'s example shrinks a pedigree and draws it whole, the animals
  removed filled through a condition column made from `idTrimmed`; help text only, no `DIVERGENCE.md` row; a test
  runs the help page's own example. Commits `f541656` (RED) to `f489d7e` (REFACTOR, one `shrinkPedigree()` call in
  the gap case); fidelity 600 of 600 with no set-aside.
- **Done G10 (S51; R127-R128):** `makePedigreeMatingLayout()` returns the hints it used as `hints`, in the form its
  argument takes, so that passing them back gives the same layout and an edit can start from the layout's own;
  copied code changed at its two returns, with a `DIVERGENCE.md` sentence; the drawing vignette describes them.
  Commits `932db0c` (RED) to `aef7f7b` (REFACTOR, one `match()` for each mate's node); fidelity 600 of 600 with one
  counted set-aside (72 results, 156 layouts).
- **Done G11 (S52; R129-R130):** `getNearRelativePedigree(ped, probands, maxDist)`, a new export, keeps the animals
  within a distance of the probands read from kinship, and each parent that joins their families, as Pedixplorer's
  `useful_inds(max_dist = )` does (1,980 of 1,980 runs measured); listed in `_pkgdown.yml`, `?pedkindraw` and the
  README. Commits `a762ffb` (RED) to `ebe04e5` (REFACTOR, two shared helpers given an argument); fidelity 600 of 600
  with no new set-aside.
- **Done G12 (S53; R131-R132):** `conditionThresholds` in both builders: a measured trait drawn by a cut-off the user
  writes as a comparison and a number, the rule in the legend and the tooltip, the number in the tooltip; copied
  code changed, with `DIVERGENCE.md` sentences. Commits `0bd6ebc` (RED) to `8bfcdb6` (REFACTOR, the helpers look the
  cut-off up); fidelity 600 of 600 with no new set-aside.
- **G13, mark 1 of 6 (S54; R133-R134):** a column `genotyped` read by `makePedigreeMatingLayout()`: a genotyped
  animal's outline drawn 4 px wide, its hover line, and a "Genotyped" legend row in `drawPedigreeDiagram()`; copied
  code changed, with `DIVERGENCE.md` sentences. Commits `a053d43` (RED) to `ad50b26` (REFACTOR, the column's message
  written once); fidelity 600 of 600 with no set-aside. Five marks left (R133).
- **G13, mark 2 of 6 (S55; R135):** a column `carrier` read by `makePedigreeMatingLayout()`: a black dot at the
  centre of a carrier's symbol, its hover line, and a "Carrier" legend row in `drawPedigreeDiagram()`; copied code
  changed, with `DIVERGENCE.md` sentences. Commits `307d328` (RED) to `2726c82` (REFACTOR, the column reader and
  the node lookup shared in `R/markColumns.R`); fidelity 600 of 600 with no set-aside. Four marks left (R133).
- **G13, mark 3 of 6 (S56; R136):** columns `proband` and `consultand` read by `makePedigreeMatingLayout()`: a black
  arrow at the lower left of each such animal's symbol, "P" beside a proband's, an animal marked both stopping, the
  hover lines, invisible points so the view takes the arrows in, and "Proband" and "Consultand" legend rows in
  `drawPedigreeDiagram()`; copied code changed, with `DIVERGENCE.md` sentences. Commits `31faecd` (RED) to
  `ff7913f` (REFACTOR, the legend's picture row shared as `.markLegendRow()`); fidelity 600 of 600 with no
  set-aside. Three marks left (R133).
- **G13, mark 4 of 6 (S57; R137):** a column `evaluated` read by `makePedigreeMatingLayout()`: a black star to the
  right of the upper-right corner of each evaluated animal's symbol, its hover line, invisible points so the view
  takes the stars in, and an "Evaluated" legend row in `drawPedigreeDiagram()`; copied code changed, with
  `DIVERGENCE.md` sentences. Commits `dd498cc` (RED) to `66584e0` (REFACTOR, the invisible points of the arrows
  and the star built by `.markRoom()`); fidelity 600 of 600 with no set-aside. Two marks left (R133).
- **G13, mark 5 of 6 (S58; R138):** a column `fertility` read by `makePedigreeMatingLayout()` in Pedixplorer's words
  and values: a black line and two bars under an infertile animal's symbol, one bar for no offspring by choice or
  for an unknown reason, the id moved below them, its hover line, invisible points so the view takes the moved ids
  in, and "Infertile" and "No offspring" legend rows in `drawPedigreeDiagram()`; copied code changed, with
  `DIVERGENCE.md` sentences. Commits `2574518` (RED) to `036d148` (REFACTOR, the bad-values text and the
  node-to-animal lookup shared); fidelity 600 of 600 with no set-aside. One mark left (R133).

### Phase 17g. The timing plan (a planning session; R82)

- **Work:** a plan of its own under `docs/planning/`: what is timed (pedkindraw's exports, kinship2's and
  Pedixplorer's where they compute the same), on which pedigrees and sizes, how (fresh process, warm-up, median of
  3, `uptime`, as the standalone plan's section 6 says), where results are committed, and how the speed vignette
  and `tools/checkSpeedTables.R` read them. It sets 17h's session count.
- **DONE:** the plan committed with each phase's DONE, commands and surface. Nothing timed.
- **Surface:** documents only.

### Phase 17h. The timing runs (sessions set by 17g)

- **DONE, commands and surface:** 17g's. The machine's load is the trap (section 2.1 measured under load 5-12).

### Phase 17i. The speed vignette (Phase 16d returns)

- **Work:** `vignettes/speed.Rmd` from the draft on `draft/speed-vignette`, its tables from 17h's results,
  checked cell for cell by `tools/checkSpeedTables.R`; the pointers R82 left out (`?pedkindraw`'s "Getting
  started", the getting-started vignette's "Where next", the drawing vignette's "How large a drawing can be" at
  `vignettes/drawing.Rmd:681`); the website's third article.
- **DONE:** the check tool passes and fails on a changed cell; the vignette builds with kinship2 and Pedixplorer
  absent; nothing timed during the build; installed size under 5,120 KB; `R CMD check --as-cran` R16's NOTE only;
  the site shows three articles.
- **Surface:** this Mac, GitHub Actions, the website.

### Phase 17j. Tests for full coverage (one or two sessions)

- **Work:** the backlog item: re-measure (`covr::package_coverage(type = "tests")`; last measured S24 on `bcdc1b0`,
  97.96%, 43 of 2,501 statements missed, all in copied files; S28 and 17c-17i changed `R/` since), then tests in
  pedkindraw's own files for each statement, working out what input reaches each before calling it unreachable
  (Learning 11). Split by file if one session cannot take them all.
- **DONE:** every statement in `R/` reached by the tests, or one shown unreachable with its reason recorded; the
  new tests' CRAN-mode time recorded for 17k.
- **Surface:** this Mac (covr).

### Phase 17k. The CRAN-mode test time (a reading after 17j; a cut only if it requires one, R86)

- **Work:** first, one win-builder R-devel reading of the tree after 17j (Mark approves the upload; R86), its tests'
  elapsed time read against their CPU time (`examples_and_tests/tests/testthat.Rout`, `proc.time()`). If it reads
  540 s or less, 17k is DONE with that reading and nothing is skipped. If over, the files of section 2.1's table,
  re-measured after 17c-17j, are skipped on CRAN (D6) until the estimate meets R85's 540 s with a margin; CI and
  local runs still run every test (`NOT_CRAN=true`). Every export keeps at least one test that runs on CRAN.
- **DONE:** a win-builder R-devel reading of 540 s or less (an upload, Mark's approval); if anything was cut, the
  list of skipped files and why, and each export called by a test that runs in CRAN mode (a check that fails
  otherwise).
- **Surface:** win-builder R-devel; one reading again.

### Phase 17l. Static hygiene and noSuggests

- **Work:** spelling (`inst/WORDLIST` for names, ids and terms; British spellings to `Language`'s en-US or the field
  changed, D7); the `mockery` and `withr` uses guarded or replaced, measured by a depends-only check in a library
  without them (section 2.3); `Depends: R` checked or raised (D7); optionally the methods' reference with its DOI
  in `Description` (D7); `.Rbuildignore` lines for `cran-comments.md` and `CRAN-SUBMISSION`; the three small
  backlog items of section 3 (suite gate limit, stale renv copy, CI notices). Strict TDD where tests change.
- **DONE:** `spelling::spell_check_package()` 0 words; the depends-only check `Status: OK` with kinship2,
  Pedixplorer, `mockery` and `withr` absent; `quality_ratchet.py --run` 5/5 with the suite gate measured; the
  stale copy gone; CI 5/5 without the notices or with them explained.
- **Surface:** this Mac in a scratch library; CRAN's own noSuggests check runs only after publication.

### Phase 17m. The release text and the version

- **Work:** NEWS: the development heading becomes the release's (D8), each item checked against the code as 17b-17l
  left it, and a section on the documentation (the README, the vignettes, the website), which NEWS lacks (S31); the README's install section (CRAN first only after acceptance: a CRAN link before then is a 404 the
  incoming check reports), re-rendered; the version in `DESCRIPTION`; `?pedkindraw` if it names the version.
- **DONE:** `R CMD check --as-cran` R16's NOTE only, its NEWS step reading the release's entries; `git grep` of the
  old version finds none outside history; the README rendered twice the same.
- **Surface:** this Mac; the site after the push.

### Phase 17n. The full local gate (the tree freezes)

- **Work and DONE:** from a clean scratch copy: `R CMD check --as-cran` `Status: 1 NOTE` (R16's), its log ending in
  a `Status:` line; the CRAN-mode test time; the depends-only check; suite 0 failed, WARN 0, tallied by hand
  (the gate counts warnings only); lint 0; roxygen idempotent; coverage as 17j left it; the drift tool and the
  fidelity tool (section 4.4), nprcgenekeepr's log on the copied files; CI 5/5 and the site's run; `uptime`
  recorded. After this, only 17o's results and 17q's version move change the tree.
- **Surface:** this Mac and GitHub Actions.

### Phase 17o. `cran-comments.md` and the cross-platform runs (two sessions and Mark's runs)

- **Work:** session one writes `cran-comments.md` (a new submission; R CMD check results; test environments; no
  reverse dependencies; R16's NOTE explained; marked lines for the runs' results) and the run list: win-builder
  R-devel, R-release and R-oldrelease, the macOS builder, R-hub (its GitHub workflow, Mark's token). Mark runs them
  or approves Claude running them (D9). Session two folds in the results.
- **DONE:** every marked line filled (`grep` 0); every run 0 errors, 0 warnings and only the new-submission NOTE,
  or each other NOTE explained; win-builder R-devel at 540 s or less; the drift tool and nprcgenekeepr's log again.
  **HARD STOP before the upload.**
- **Surface:** win-builder, the macOS builder, R-hub; the macOS builder was down for a day in nprcgenekeepr's
  S1105, which dropped its line by Mark's ruling.

### Phase 17p. Submission (Mark's action)

- Mark uploads the tarball through CRAN's submission page and confirms by the link CRAN emails to the maintainer.
  A session records it in the ledger; no session uploads. If the incoming pretest fails, the work returns to the
  phase that owns the failure.

### Phase 17q. After acceptance

- **Work:** tag the release at the submitted commit and publish a GitHub release from NEWS; the development
  version (`.9000`) and a heading-only NEWS block; the README's install section with CRAN first and the badges
  (D10), re-rendered; `methodology/ROADMAP.md`; a push, which rebuilds the site (it does not build on a tag). A
  few days later, read CRAN's check page: every flavor and the additional checks, noSuggests among them.
- **DONE:** the tag and release exist; the site shows the release; the check page read and recorded.
- **Surface:** CRAN's check page, the only place its flavors and noSuggests are seen.

---

## 7. Decisions left for each phase's picker

| # | Question | Phase | What is known now |
|---|---|---|---|
| D1 | Who uploads to win-builder: Mark, or Claude with Mark's approval in the session | 17a | the result goes to the maintainer's email either way; nprcgenekeepr's D5 ruled the owner, and once let the agent |
| D2 | Each name change of section 2.4: change or keep | 17b | **Decided S34** (R87-R93): section 2.4's "Decided" table; 9 `DIVERGENCE.md` rows in 17c |
| D3 | Each drawing fix: also fixed in nprcgenekeepr (a session there, Mark starts it) or a `DIVERGENCE.md` row | 17d, 17e | nprcgenekeepr has the same filter and label. **17d decided S38** (R94): port later, `DIVERGENCE.md` rows and the fidelity tool's `withoutJogSelections()` until then. **17e decided S39** (R95): port later, the `drawPedigreeDiagram()` row and the tool's `withoutLegendLineStyle()` until then |
| D4 | Which gaps, if any, are closed before the release | 17f | **Put to a planning session S40** (R96). **Decided S41** (R97): every gap, where possible, phases G1-G17 of `docs/planning/gaps-and-shared-code-plan.md`, before 17g |
| D5 | The timing plan's scope | 17g | R82; the draft's nine tables |
| D6 | How tests are kept off CRAN: `skip_on_cran()` per file or block, or a list of slow files as nprcgenekeepr's `slowTestFiles.txt` | 17k | eight files take 81% (section 2.1) |
| D7 | `Language` and spelling; the `Depends: R` floor; a DOI reference in `Description` | 17l | British spellings under en-US; R 4.1.0 claimed, 4.5 tested |
| D8 | The version number: 0.1.0 or 1.0.0 | 17m | contract section 6: "0.x until the first CRAN release" and the deprecation rule after it |
| D9 | Who runs the cross-platform checks | 17o | R-hub needs Mark's GitHub token; the emails go to Mark |
| D10 | Which badges the README shows | 17q | none before acceptance (section 6, 17m) |

---

## 8. Session map

| Phase | Work | Needs first | Sessions (a guess) |
|---|---|---|---|
| 17a | check time on win-builder | Mark approves an upload | 1 |
| 17b | name review, decisions | 17a | 1 |
| 17c1 | `kinship()`: `sire`, `dam`, the `pdepth` check, the shared-names note | 17b | 1 |
| 17c2 | the pedigree argument's name | 17c1 | 1 |
| 17c3 | the pedigree first | 17c2 | 1 |
| 17d | "Select by id" | 17b | 1 |
| 17e | legend label | 17b | 1 |
| 17f | gaps document | 17c3-17e | 1 |
| 17f2 | the plan for the gaps in both repositories (R96) | 17f | 1 |
| G1-G17 | the gaps (R97; `docs/planning/gaps-and-shared-code-plan.md` section 5.1) | 17f2 | 38-53 |
| 17g | timing plan | G17 | 1 |
| 17h | timing runs | 17g | set by 17g |
| 17i | speed vignette | 17h | 1 |
| 17j | full coverage | the code final (17c-17i) | 1-2 |
| 17k | a reading, then the test cut if needed (R86) | 17j | 1-2 |
| 17l | hygiene, noSuggests | 17k | 1 |
| 17m | NEWS, README, version | 17l | 1 |
| 17n | full local gate | 17m | 1 |
| 17o | cover note, cross-platform runs | 17n | 2 and Mark's runs |
| 17p | submission | 17o | Mark |
| 17q | after acceptance | CRAN's email | 1 |

The order puts the code and tests that change (17b-17j) before the cut (17k), and the cut before the release text,
the version and the frozen gate, as nprcgenekeepr's plan did. 17d and 17e may swap; 17f comes after them so the gaps
it lists are the shipped package's. S34 (R93): 17d and 17e need 17b only, since none of the functions R87-R89 change
is in `R/drawPedigreeDiagram.R` (`grep -w` at `5525edd`), so they may also come before or between 17c1-17c3; 17c1-17c3
run in that order (17c3 rewrites calls in files 17c2 has just changed: `R/addBackSecondParents.R`).

---

## 9. Here be dragons

From nprcgenekeepr's plan (its section 8), as they apply here:

1. **A halted check reads as clean.** From the repository root, renv's dated repository stops `R CMD check` at
   the incoming-feasibility step (S20). Run it from a scratch folder (`CLAUDE.md`), and count a check only if
   `00check.log` ends with a `Status:` line.
2. **`devtools::check()` sets `NOT_CRAN=true`.** A CRAN-mode timing needs it unset; section 2.1 ran `R CMD check`
   and `test_dir()` with it unset.
3. **Local timings carry the machine's load.** Record `uptime` with every timing; compare two timings only under
   similar load. Section 2.1's were taken at load 5-12.
4. **A source-tree timing is not the check's timing.** Time in the installed layout, as section 2.1 did.
5. **`skip_on_cran()` hides a test from CRAN, not from CI**, which sets `NOT_CRAN=true`; keep every export tested
   on CRAN (17k).
6. **`_R_CHECK_DEPENDS_ONLY_` cannot hide R's own library:** 7 of the 9 Suggests are there (section 2.3).
7. **A copied tree runs its `.Rprofile`:** set `RENV_CONFIG_AUTOLOADER_ENABLED=false` (S31's gotcha too).
8. **win-builder's reading spreads:** 284-617 s for nearly the same code in nprcgenekeepr; upload again before
   acting on one reading near the target. A reading far from the target can mislead too: pedkindraw's 398 s (S33)
   ran its tests on an idle machine (elapsed equal to CPU), so read the tests' `proc.time()` in
   `examples_and_tests/tests/testthat.Rout` before trusting a margin.

pedkindraw's own:

9. **No spelling dictionary on this Mac**, so local checks never run the incoming spelling step (section 2.2); use
   the `spelling` package.
10. **A URL in the package that does not answer grows R16's NOTE**: the website must answer at every check and at
    submission, and CRAN's own page for pedkindraw is a 404 until acceptance, so no CRAN link or badge before 17q.
    A link can also fail for a moment (S37: README's GitHub link to `DIVERGENCE.md` read 503 in one check and 200 a
    minute later, `tools:::check_url_db()` 0 problems in 17 URLs): check the URL again before acting on it.
11. **pkgdown publishes every root `.md` but README, NEWS and LICENSE** (S31); `cran-comments.md` is the
    exception it skips. Any other new root `.md` needs the site workflow's delete line (`.github/workflows/pkgdown.yaml`).
12. **A push beyond `CLAUDE.md` and `methodology/**` starts both workflows** (15-18 min and 3 min).
13. **The suite gate counts warnings, not failures** (`methodology/.quality-gates.json`): tally "0 failed" by hand.
14. **nprcgenekeepr moves during a session** (Learning 15): its S1178 committed six times during S32.
15. **A rename is a divergence**: the drift tool lists every renamed copied function until its row exists (17c).
16. **A call count from a text search is not what a change breaks** (S34): text matches include definitions and help
    text, and say nothing about which calls pass arguments by position. Parse instead (section 2.4's method), and
    record each call's `pkg::` before stripping it: S34's first parse counted kinship2's 3 `kinship()` calls as
    pedkindraw's (its picker said "45 of the 46", the record 42 of 43). Calls through a lookup, as the fidelity
    tool's `fn("name")(...)`, are invisible to a parse for the name: read them by hand.
17. **A shared name is called the way the other package's users call it** (S34, R92): kinship2's positional
    `kinship(id, dadid, momid, sex)` gave pedkindraw's `kinship()` the sex codes as generations, a wrong matrix with
    no error. When a shared export's arguments differ, run the other package's documented call on it.
18. **A new check meets old fixtures** (S35): no inventory named `test_maleLeftDuplicateMate.R`, yet `kinship()`'s
    new check stopped it, through the layout's own `kinship()` call on `smallPed`'s stored `gen` (8 of 17 wrong).
    Run the whole suite against a scratch copy with a draft of the check before RED, and read every failure.
19. **Read the other package's methods before describing them** (S35): R91 said kinship2's and Pedixplorer's
    `kinship()` take a pedigree object; `methods(kinship2::kinship)` and `showMethods("kinship")` showed both also
    take the vectors, the form R92 is about. Count shared names on the loaded source (`pkgload::load_all()`): the
    installed copy in renv's library was older and reported 1 name shared with kinship2, not 6.
20. **R matches a shortened argument name to the old one** (S36): with `getParents(pedSourceDf, ids)`, a call
    `getParents(ped = x)` already worked, `ped` being a prefix of `pedSourceDf` (partial matching), so a RED test
    that only calls the new name passes on the old code. `expect_named(formals(f), ...)` is what fails there; put
    it in every rename's RED block. After the rename, a call that names the old argument stops ("unused argument").
21. **Code outside `test_that()` fails RED as one file error** (S37): `test_trimPedigree.R` builds its four trimmed
    pedigrees at the top of the file, so on the old code the new-order calls stopped the file before any test ran:
    one error, "(code run outside of `test_that()`)", in place of its two blocks, the new one among them. Count RED
    by file as well as by block, and say in the picker which files will fail whole (measured on a scratch copy).
22. **The fidelity tool runs from the repository, not a scratch copy** (S37): started outside renv's project, its
    nprcgenekeepr process inherited pedkindraw's library and stopped ("The package "openxlsx" is required") before
    any case, since it restores renv's saved `RENV_DEFAULT_*` values (Learning 5), which only an R started in renv's
    project has. Run it in the repository at GREEN, against nprcgenekeepr at a commit.
23. **pedkindraw's own half of the fidelity tool does run from a scratch copy** (S38): `Rscript
    tools/compareResultsWithNprcgenekeepr.R --child <copy> <clone>/tools/pedigreeComparison/data <out.rds>`, with
    the scratch environment of the session notes' gotchas, saves every case's result for that copy. Run it on HEAD
    and on a draft, then compare the two lists: S38 found the 33 results its fix changes, and that taking the
    `__jog_` entries out of HEAD's boxes made all 600 identical, before any picker named the allowance.
24. **A drawing check in the browser reads the vignette as shipped** (S38): `R CMD build` puts the rendered
    `inst/doc/drawing.html` in the tarball; extract it and read it with chromote (`select[id^=nodeSelect]`). A
    "Select by id" box has one option more than its values, the "Select by id" placeholder (visNetwork's
    `setNodeIdList()`), so the colony's 375 animals show as 376 options.
25. **Look at the drawing before choosing what to measure** (S39): S31 read "Same animal; agai" as a label cut by
    the legend's width, and S39's first check (the label's box inside the legend's canvas) passed on the broken
    drawing; one screenshot showed the arrowhead over the "n". Measure from vis.js, not from a screenshot: the
    legend's `L.body.edges[id].labelModule.size` and `L.canvasToDOM()` agreed with the canvas's own pixels, while a
    chromote screenshot drew the same row about 30 px further left. For an edge label with `font.align` other than
    `"horizontal"` that box stays where the horizontal label would be; only the drawn text moves (vis.js's
    `_setAlignment()`), so a box check cannot see it.
26. **Do not pipe a chromote script into `head`** (S39): `Rscript page.R ... | head -1` never ended (its R
    process still running after 120 s, then killed), where the same script piped into `grep -v`, which reads all
    its input, ended in each of 4 runs. Write the output to a file and read it after.
27. **Call each package through `::` when kinship2, Pedixplorer and pedkindraw are loaded together** (S40): a probe
    that attached all three called the `kinship()` attached last, not pedkindraw's, and read "pedkindraw computes
    kinship after a parent's row is dropped"; through `pedkindraw::kinship()` it stops ("pdepth must not be missing
    for any animal"), and gap C6 was written from that. A probe's "not a gap" is a prediction until the case script
    runs it: the framing picker's outline listed removing animals as not a gap.
28. **Pedixplorer writes `Rplots.pdf` into the working folder** (S40): `ped_to_plotdf()` measures text on the open
    graphics device and opens R's default one, a file, when none is open. Open `grDevices::pdf(NULL)` first (the
    same 7 by 7 inches, so the same results: S40's two runs agreed line for line).

---

## 10. Out of scope

- Any change to nprcgenekeepr (R8): the R81, R94 and R95 ports, removing its stale S1159 line, its edition-3 conversion and the
  vacuous test are for sessions Mark starts there.
- Copying the colony overview; `findPedigreeNumber()`'s speed; the drift tool's constants; the methodology tools'
  items (section 3).
- New features beyond the gaps of G1-G17 (R97).
- Reverse dependencies: none (a new package).
- nprcgenekeepr using pedkindraw (the standalone plan's "Later, optional"): ruled S41 (R98, R100): nprcgenekeepr
  names its calls now (N2) and imports pedkindraw after acceptance (N3), in sessions Mark starts there, not in Phase
  17 (`docs/planning/gaps-and-shared-code-plan.md` section 5.2).

## 11. Sources

- pedkindraw: `docs/planning/standalone-pedigree-package-plan.md` (R16, R37, R77, R79, R81, R82, Phase 16's
  records), `docs/planning/pedkindraw-api-contract.md` (sections 4, 6, 10), `docs/planning/documentation-plan.md`
  (section 7), `methodology/BACKLOG.md` (as at `ba811e7`), `DIVERGENCE.md`, `CLAUDE.md` (Build / Test / Verify,
  Learnings 11, 15, 18, 19).
- nprcgenekeepr at `363137511`: `docs/planning/cran-3.0.0-submission-plan.md` (sections 1, 3.2, 5 Phases 8-10, 6,
  7, 8), `BACKLOG.md` (the drift-watch item), `methodology/ROADMAP.md`, `NAMESPACE`, `git log baef1e12c..HEAD`.
- Measured this session, scratch only (not committed): the check log and `pedkindraw-Ex.timings` (section 2.1), the
  per-file test times, the spelling run, the name and call-site counts, the copied files' commit counts.
