# pedkindraw's own timing runs -- the plan (Phase 17g)

**Date:** 2026-11-23 · **Session:** pedkindraw S78 · **Type:** planning session (`methodology/SESSION_RUNNER.md`
"Planning Sessions"; failure mode #18: this session writes no package code; the code beside this plan is three
measuring scripts, section 3.6). **Governs:** Phases 17h and 17i of `docs/planning/cran-submission-plan.md` (section 6,
`:754` "Phase 17h. The timing runs" and `:775` "Phase 17i. The speed vignette"), under rulings R82 and R84 of
`docs/planning/standalone-pedigree-package-plan.md`. **Ruling made here:** R153 (Mark's four picks, section 2; recorded
in the standalone plan's section 2); R154 (T1, Mark's three picks at 17h1's pre-RED picker, S79; section 3.8); R155
(17h1b's three picks, S80: `record.csv` and each run's free memory, sections 4.2 and 5.4); R156 (17h1c's pick, S81:
each run's `started` is when the run launched, section 8 dragon 24); R157 (T2 and the copy's scope, Mark's four picks at
17h3's pre-RED picker, S83: sections 4.1 and 7); R158 (T4 and the two saves not timed at 3,000, Mark's two picks at
17h4's results, S84: sections 6 and 7, dragon 33); R159 (17i's scope, T5 and CI, Mark's three picks at 17i's pre-RED
picker, S85: sections 6 and 7).
**Status:** plan written (S78); 17h1 DONE (S79: the computation harness in `tools/timing/`, section 6); 17h1b DONE
(S80: each run's free memory and `record.csv`, section 6); 17h1c DONE (S81: each run's `started` its launch, section
6); 17h2 DONE (S82: the computation record, `14145a4`, section 6); 17h3 DONE (S83: the drawing harness, R157, section
6); 17h4 DONE (S84: the drawing record, `a4b41da`, R158, section 6). Next: 17i, the speed vignette (section 6).

**Versions:** kinship2 1.9.6.2, Pedixplorer 1.8.0 (Bioconductor 3.23), chromote 0.5.1, processx 3.9.0 and ps 1.9.3 from
this project's renv library (the lock's dated repository, `https://packagemanager.posit.co/cran/2026-10-31`); R 4.6.2;
this Mac (Apple M2 Max, 12 cores, 96 GiB). pedkindraw at `dd2d1c2` (S78's claim); its `R/`, `DESCRIPTION` and
`NAMESPACE` last changed at `09e8f45` (S77), `R/`'s tree `ac123b7`. nprcgenekeepr at `3e06730c5`, read from its clone
(it is installed nowhere here); its `tools/pedigreeComparison/` and `tools/perf/harness.R` last changed at `d75f07f6b`.
Every count below was measured in this session by the scripts of section 3.6 and covers the cases run, no more
(Learning 19).

---

## 1. Summary

**What 17h and 17i give a user.** A page, `vignette("speed")`, that answers "how long does this function take on a
pedigree of n animals, and how large a pedigree can it take", for each of pedkindraw's 37 functions that run on a
pedigree, beside kinship2's and Pedixplorer's functions that do the same, measured on pedkindraw's own installed code.
Today a user has the drawing vignette's times (`vignettes/drawing.Rmd:794` "How large a drawing can be", pedkindraw's,
measured in S75) and nothing else; the API contract's section 7 holds nprcgenekeepr's November numbers. R82 deferred
the page until "pedkindraw times itself"; this plan is how it does.

**The shape.** pedkindraw copies the November study's timing harness, with its tests, from nprcgenekeepr's
`tools/pedigreeComparison/` into its own `tools/timing/` (build-ignored), its cases rewritten for pedkindraw's names
and functions. It builds the study's seeded synthetic colonies itself (byte for byte the same, section 3.2). It
installs pedkindraw from a named commit into a scratch library and times it, kinship2 and Pedixplorer in the same
runs, each run a fresh R process started only when half the CPU is idle, and commits the results under
`tools/timing/results/`. The speed vignette's tables are typed from those results and checked cell for cell by
`tools/checkSpeedTables.R`, which now reads pedkindraw's own files and needs no nprcgenekeepr clone. The draft on the
branch `draft/speed-vignette` (`612eed9`) gives the design; its numbers do not carry over (R82).

**Sessions:** 17h in four (a guess, section 3.7): 17h1 the computation harness (strict TDD, a copy), 17h2 the
computation runs, 17h3 the drawing harness (strict TDD, a copy), 17h4 the drawing runs. Then 17i, the vignette, in
one. Each harness comes before its runs, so after 17h2 the computation half works end to end (failure mode #25).

**nprcgenekeepr** is not changed (R8). Its harness files are read from the clone at the commit 17h1 names; the copies'
headers name each source path and commit, as the package's copies do. The drift rule (plan section 5) covers copied
functions in `R/`, not `tools/`, so the copies get no `DIVERGENCE.md` rows.

---

## 2. The ruling: R153 (Mark's four picks)

Put to Mark in one picker after the measurements of section 3; his pick the recommended option each time.

| Question | Mark's pick | The others offered |
|---|---|---|
| Which of the 38 exports are timed | **"All 37 (Recommended)":** every export that runs on a pedigree (section 5.1's four groups); `runPedigreeApp()` is not timed (an app; its drawing is timed through the drawing functions). The picker said about 3 hours of computation runs and 1.2 hours of drawing runs, unattended; section 3.7's estimate, worked out after, is 3.5-4 and 1.2-1.5 hours (a guess) | leave out the 13 pedkindraw-only functions (each under 0.25 s at 100,000 animals in one call, section 3.4; saves about 10 minutes); only the study's 11 (saves about 1.5 hours; the page could not answer for the other 26) |
| kinship2 and Pedixplorer | **"Time them again (Recommended)":** kinship2 1.9.6.2 and Pedixplorer 1.8.0, the study's versions, in the same sessions and under the same rule as pedkindraw, so every number on the page has one date; the 13 newer pairings have no November numbers anyway | reuse the November study's numbers for them (two dates and two sets of runs on one page; the newer pairings pedkindraw only) |
| When a run may start | **"Half the CPU idle (Recommended)":** a run starts once at least half the CPU is idle, waiting at most 10 minutes; the idle share, the 1-minute load average and the free memory are recorded with it (Mark's S1123 ruling for the study, which all 587 + 84 of its runs met) | also half the memory free (the study's third record; 47% free when asked, so runs would wait); the load average below a number (the standalone plan's first wording; the study found it 3-35 with most cores idle) |
| What the speed vignette shows | **"pedkindraw's own runs only (Recommended)":** every table pedkindraw's runs beside kinship2's and Pedixplorer's; the draft's sections "Why these times stand for pedkindraw's" and "The rewrite" dropped; one sentence says the drawing code began as nprcgenekeepr's; each computation defined on the page (section 5.8) | also a section setting pedkindraw's times beside the November study's for nprcgenekeepr's code (judged premature in S30, R82); decide the outline at 17i |

---

## 3. Measured this session

### 3.1 The November study's method and harness

nprcgenekeepr timed its own code beside kinship2, Pedixplorer, BGmisc and ggpedigree in November 2026 (its S1123,
S1125 and S1141; `docs/research/pedigree-package-comparison-2026-11.md` sections 7 and 9 in this repository). Its
method (that document's section 7, `:424`, and 9.1, `:653`; the standalone plan's Phase 1 step 4, `:446`):

- **One measurement, one fresh `Rscript`** (`timeOne.R`), run under `/usr/bin/time -l` by `runLimited()`
  (`timingHarness.R`). The child loads only the measured package (and Matrix, so no timed call loads a package), builds
  the inputs (`prepare()`, not timed), prints `CALL START`, times one call with `measure()` (`tools/perf/harness.R`:
  elapsed seconds and R's heap high-water mark above the start, read at garbage collections), and prints a `TIMING`
  line. A step a user must run first is inside the call (`findGeneration()` before `kinship()`).
- **The ladder.** For each case and size, smallest first: one warm-up run, which is also the capacity test, then 3
  measured runs, whose median is the figure. A case stops at its first failing size.
- **The limits.** 120 s counted from `CALL START` (loading does not count); 32 GB, held by R's own heap cap
  (`R_MAX_VSIZE`) and by a watchdog on the process tree's resident memory (`ps`). A drawing counts only when its R part
  and its Chrome part together finish within 120 s.
- **The load.** Before each run `waitForQuiet()` waits until at least 50% of the CPU is idle (two `top` samples one
  second apart), at most 10 minutes; each run's idle share and load are recorded (Mark's S1123 ruling: macOS's own
  background work kept the load average at 3-35 with most cores free). `machineNote()` writes the busiest processes at
  the start and the end to `*Machine.txt`, which nprcgenekeepr's `.gitignore` leaves out (`:120`, `:122`).
- **The files.** `results/timing.csv` (one row per case and size: the medians, or how the size failed),
  `results/timingRuns.csv` (every run), the same pair for drawing, `results/pedigreeFiles.csv` (each pedigree file's
  rows and md5); the synthetic colonies themselves are git-ignored and rebuilt by `savePedigrees.R`.

The three records, read from nprcgenekeepr's committed run files (`timingRuns.csv`, `drawingTimingRuns.csv`,
`version/versionRuns.csv`):

| Record | Runs | Process time summed | First to last start | Load rule |
|---|---:|---:|---:|---|
| Part A, computation (S1123, 2026-11-02) | 587 (497 for kinship2, Pedixplorer and nprcgenekeepr, 51.2 min) | 56.5 min | 76.8 min | 50% CPU idle |
| Part B, drawing (S1125, 2026-11-03) | 84 | 29.5 min | 177.8 min (two batches, 2.5 hours apart) | 50% CPU idle |
| Rewrite (S1141, 2026-11-09) | 157 | 30.7 min | 356.1 min | 80% CPU idle and 50% memory free |

A run's start-up (process time less the call's time, median): kinship2 1.16 s, nprcgenekeepr 1.53 s, Pedixplorer
2.14 s. Part B's drawings by process time: nprcgenekeepr's page 3.5 min, kinship2's picture 3.3, Pedixplorer's picture
0.7 (refused at 300) and 3.8 with alignment off, its plotly page 4.7 and 6.6 with alignment off.

The harness files and their tests (lines, at `3e06730c5`): `timingHarness.R` 312, `timingCases.R` 256, `runTiming.R`
116, `timeOne.R` 38, `summarizeTiming.R` 103, `comparisonFormats.R` 111, `generateColonyPedigree.R` 141,
`savePedigrees.R` 89, `drawingTiming.R` 224, `drawingTimingCases.R` 174, `runDrawingTiming.R` 171, `drawOne.R` 39,
`summarizeDrawingTiming.R` 129, `drawingCapture.R` 317 (`drawOne.R` sources it); tests `test_timingHarness.R` 390,
`test_comparisonFormats.R` 176, `test_generateColonyPedigree.R` 176, `test_drawingTiming.R` 386,
`test_drawingCapture.R` 129, `helper-checks.R` 37, `helper-sourceScript.R` 8; and from `tools/perf/harness.R`,
`usedMb()`, `maxUsedMb()`, `mbColumnAfter()`, `measure()` and `withSeed()` (`:24`-`:72`), tested in
`tests/testthat/test_perfHarness.R:79`-`:131`.

### 3.2 pedkindraw can build the study's colonies itself

The study's synthetic colonies come from `generateColonyPedigree(n, seed = 1)`, a standalone function (no
nprcgenekeepr call), written by `writeComparisonPedigree()`. Run under pedkindraw's R and renv library, it rebuilt
**all 7 colonies byte for byte** (300, 1,000, 2,000, 3,000, 10,000, 30,000 and 100,000 animals; each md5 identical to
the study's `results/pedigreeFiles.csv`; the largest in 0.7 s), twice (`s78Colonies.R`). So pedkindraw times the very
pedigrees the study timed, built by its own copy of the generator. The 375-animal sample ships with pedkindraw
(`inst/extdata/obfuscated_rhesus_mhc_ped.csv`, the study's `rhesus375.csv`, R80).

### 3.3 The 38 exports and the functions kinship2 and Pedixplorer have for them

Read from the two namespaces (`getNamespaceExports()`; kinship2's 25 exports, Pedixplorer's 140) and each candidate's
arguments, then called once (section 3.4). "Same work" here means the functions' help describes the same result; 17h1
checks that each pair returns the same answer on typed cases before it is timed (section 6, Learning 19).

| Group (R153) | pedkindraw | kinship2 | Pedixplorer |
|---|---|---|---|
| The study's computations (7) | `kinship()` ordinary | `kinship()` | `kinship()` |
| | `kinship(sparse = TRUE)` | `makekinship()` (by family) | -- |
| | `kinship(chrtype = "x")` | `kinship(chrtype = "X")` | `kinship(chrtype = "X")` |
| | `findGeneration()` | `kindepth()` | `kindepth()` |
| | `findPedigreeNumber()` | `makefamid()` | `make_famid()` |
| | `shrinkPedigree()` | `pedigree.shrink()` | `shrink()` |
| | `findUnrelated()` | `pedigree.unrelated()` | `unrelated()` |
| | `trimPedigree()` | -- | `ancestors()` |
| | `getDescendantPedigree()` | -- | `descendants()` |
| | (none: pedkindraw takes a data frame) | `pedigree()` | `Pedigree()` |
| Drawing (4) | `makePedigreeMatingLayout()` + `drawPedigreeDiagram()` | `plot.pedigree()` | `plot()`; its app's plotly page |
| | `savePedigreeDiagram()` (SVG, PDF, PNG) | (its picture is a PNG file) | (the same) |
| | `makePedigreeDiagramData()` | -- | `ped_to_plotdf()` (inside its `plot()`) |
| With a kinship2 or Pedixplorer function (13) | `bitSize()` | `bitSize()` | `bit_size()` |
| | `findUnavailable()` | `findUnavailable()` | `find_unavailable()` |
| | `findAvailNonInform()` | `findAvailNonInform()` | `find_avail_noninform()` |
| | `findAvailAffected()` | `findAvailAffected()` | `find_avail_affected()` |
| | `familyCheck()` | `familycheck()` | `family_check()` |
| | `ibdMatrix()` | `ibdMatrix()` | `ibd_matrix()` |
| | `getNearRelativePedigree()` | -- | `useful_inds(max_dist = )` |
| | `removeAnimals()` | `pedigree.trim()` | `subset()` |
| | `asPedFrame()` (of a kinship2 and of a Pedixplorer object) | `as.data.frame()` | `as.data.frame()` |
| | `addParents()` | `fixParents()` | `fix_parents()` |
| | `countOffspring()` | -- | `num_child()` |
| | `recodePedigree()` | -- | `norm_ped()` |
| | `isFounder()` | -- | `is_founder()` |
| | and `findGeneration(alignMates = TRUE)` | `kindepth(align = TRUE)` | `kindepth(align_parents = TRUE)` |
| pedkindraw only (13) | `checkPedigree()`, `getMatings()`, `correctParentSex()`, `addBackSecondParents()`, `removeUninformativeFounders()`, `removeUnknownAnimals()`, `getProbandPedigree()`, `getParents()`, `getOffspring()`, `getFounders()`, `hasBothParents()`, `getIdsWithOneParent()`, `checkTwinRelations()` | -- | -- |
| Not timed (1) | `runPedigreeApp()` | -- | Pedixplorer's app |

7 + 4 + 13 + 13 + 1 = 38. kinship2's `fixParents()` also corrects a parent's sex, as `correctParentSex()` does; it is
paired with `addParents()`, the closer match (both add the missing parents' rows). `getProbandPedigree()` does
`trimPedigree()`'s work without its options and is timed as pedkindraw's own.

### 3.4 One call of each, to size the runs (not the timing method)

One process each, pedkindraw loaded from source (`pkgload::load_all()`), one call per function under a 60 s limit
(`setTimeLimit()`), on the seed-1 colonies, with the study's seeded inputs (30% genotyped, 10% affected, 5 probands
with a known sire). Single calls, not medians, a 60 s limit, not 120: they size 17h and are not results. Run twice
(`s78ProbePedkindraw.R`, `s78ProbeOthers.R`); the two runs agreed to within 5% on every call over 1 s that
finished (`findUnrelated()` at 100,000 the widest, 4.1%).

**pedkindraw, seconds** (first run / second run where over 1 s):

| Function | 10,000 animals | 100,000 animals |
|---|---:|---:|
| `findGeneration(alignMates = TRUE)` | **56.5 / 54.8** | past 60 |
| `getNearRelativePedigree(maxDist = 3)` | 6.2 / 6.0 | past 60 |
| `findAvailAffected()` | 0.62 | past 60 |
| `findUnrelated()` | 0.44 | 31.8 / 33.1 |
| `countOffspring()` | 0.011 | 0.20 |
| `findAvailNonInform()` | 0.023 | 0.15 |
| `checkPedigree()` | 0.047 | 0.15-0.16 |
| `getMatings()`, `familyCheck()`, `recodePedigree()`, `findUnavailable()` | 0.012 or less | 0.06-0.11 |
| the other 15 (`bitSize()`, `removeAnimals()`, `addParents()`, `isFounder()`, `correctParentSex()`, `removeUninformativeFounders()`, `getProbandPedigree()`, `getParents()`, `getOffspring()`, `getFounders()`, `hasBothParents()`, `getIdsWithOneParent()`, `removeUnknownAnimals()`, `addBackSecondParents()`, `ibdMatrix()` with 196,160 pairs) | under 0.005 | under 0.06 |

**kinship2 and Pedixplorer at 10,000 animals, seconds:** kinship2 `findAvailAffected()` and Pedixplorer
`find_avail_affected()` past 60; Pedixplorer `kindepth(align_parents = TRUE)` past 60, kinship2 `kindepth(align =
TRUE)` 7.7 and 7.9; Pedixplorer `unrelated()` 15.2, kinship2 `pedigree.unrelated()` 6.7 (the study: 15.4 and 6.53); kinship2
`findUnavailable()` 0.38, Pedixplorer `find_unavailable()` 0.39, `find_avail_noninform()` 0.35, `subset()` 0.32,
`norm_ped()` 0.22, `ibd_matrix()` 0.16, kinship2 `ibdMatrix()` 0.16; the rest under 0.07. **Three calls stopped on
the inputs the probe gave them** (kinship2 `findAvailNonInform()`, "argument is of length zero"; Pedixplorer
`useful_inds()`, which has no `informative` argument; Pedixplorer `num_child()`, whose output columns were already in
the object): building each case properly is 17h1's work.

**What this tells a user now** (a finding of the probe, not of the runs): `findGeneration(alignMates = TRUE)` (G8,
R123-R124) took 56 s at 10,000 animals, where `findGeneration()` without it takes 0.009 s (the study) and kinship2's
`kindepth(align = TRUE)` 7.7-7.9 s; nprcgenekeepr has no `alignMates` (`git grep` in its `R/`: 0 files), so the finding is
pedkindraw's alone. The drawing does not use it. It joins the backlog (S78's close-out); the runs will measure it.

### 3.5 The machine when the picker was put

`uptime` 04:52: load average 5.71, 7.39, 6.75; `top -l 2 -n 0 -s 1`: 85.2% idle; `memory_pressure -Q`: 47% free; the
busiest processes a remote-desktop agent (36.5%), a virtual machine (36.2%) and the terminal (22.0%).

### 3.6 The scripts

Under `docs/planning/timing-plan-prototype/` (build-ignored with `docs/`, `.Rbuildignore:25`), each run from the
root with renv's library and `RENV_PROJECT` unset (Learning 5), the commands in each header:
`s78Colonies.R <dir>` (section 3.2; reads nprcgenekeepr's generator, writer and `pedigreeFiles.csv` from the clone
with `git show`), `s78ProbePedkindraw.R <dir> <n>` and `s78ProbeOthers.R <dir> <n>` (section 3.4). S78 ran them twice:
first from the scratchpad, then as committed, from an empty folder.

### 3.7 What the runs will cost (a guess)

From section 3.1's records and section 3.4's calls; an estimate, not a measurement.

- **Computation (17h2).** The study's 25 cases for kinship2, Pedixplorer and nprcgenekeepr took 51.2 min of process
  time; pedkindraw's copies of them should take about the same, plus `findUnrelated()` (about 4 min: 4 runs of 32 s at
  100,000). The 39 new cases of the second group: about 31 fast ones at 1-1.5 min each (24 runs of 1.5-2.5 s) and
  about 8 slow ones at 5-8 min each (a size near the limit, 4 runs, then a 120 s failure): about 1.5 hours. The 13
  pedkindraw-only cases: about 12 min. About 2.7 hours of process time; Part A's starts spread 1.36 times its process
  time (waits and gaps), so **about 3.5-4 hours** in all.
- **Drawing (17h4).** Part B's drawings without ggpedigree took about 26 min of process time; pedkindraw's added cases
  (direct lines, the three saved files, the diagram data) about 30 min more: **about 1.2-1.5 hours** with waits.

So each record fills one session as a background job; the two records cannot run at once (section 5.4).

### 3.8 The inputs measured for T1 (S79, R154)

Before 17h1's pre-RED picker, each section 5.2 input was built on the seed-1 colony of 300 animals and the 375-animal
sample (some also at 1,000 and 3,000) and each pairing's three calls made once, their answers compared
(`docs/planning/timing-plan-prototype/s79T1Probe1.R`-`s79T1Probe3.R`, run as committed from an empty folder, with
nprcgenekeepr's harness files read by `git archive` at `3e06730c5`). The sample has no animal with one known parent and
no parent without a row (read with `NA` as unknown; an earlier read with only `""` as unknown made every sire the text
`"NA"`); the colonies have every animal with both parents or neither and every parent with a row.

- **Every pairing returns on the 300 colony and the sample**, but for two counterparts on section 5.2's inputs:
  kinship2's `pedigree.trim()` of the 5 probands stops ("A subpedigree cannot choose only one parent of a subject")
  where a proband is a parent (4 of 5 on the sample, 1 at 1,000, 3 at 3,000); and Pedixplorer's `family_check()` on the
  colony's own family numbers stops ("'dimnames' applied to non-array" at 300, 1,000 and 3,000; it returns on the
  sample). Moving every 7th animal to a family of its own makes Pedixplorer return a table different from
  pedkindraw's, and kinship2's `familycheck()` stop ("dim(X) must have a positive length"); on the sample all three
  agree either way. 5 seeded animals with a known sire and no offspring give the identical pedigree in all three at
  300, 1,000, 3,000 and on the sample.
- **The same answer:** `bitSize()`; `ibdMatrix()` (the same values, pedkindraw's ids in byte order); near relatives
  (Pedixplorer's `useful_inds(max_dist = 3)` with the probands available and affected, `is_informative(informative =
  "AvAf")` first); `asPedFrame()` of both objects; `addParents()`, `countOffspring()`, `recodePedigree()`,
  `isFounder()`; `findUnrelated()`'s set size (7 at 300, 44 on the sample; kinship2's and Pedixplorer's sets are
  random).
- **A different answer** (R154: timed, the difference recorded): `findAvailNonInform()` 13 ids at 300 against
  kinship2's 186 and Pedixplorer's 173, 4, 98 and 96 on the sample (R40: pedkindraw's is `shrinkPedigree()`'s second
  trim with the cascade); `findAvailAffected()` the same bit size (208 at 300, 741 at 1,000, 2,252 at 3,000, 378 on
  the sample, where none is removed) but pedkindraw lists every animal removed (175 at 300) and the others the one
  chosen, kinship2's choice random among ties (S002886 in one run at 3,000, S002669 in the next); `findUnavailable()`
  the same on the colonies (173, 595, 1,800) but 104, 97 and 96 on the sample, theirs all among pedkindraw's;
  `findGeneration(alignMates = TRUE)` the same as kinship2's `kindepth(align = TRUE)` at 300 and 3 of 375 different on
  the sample, and 290 of 300 and 336 of 375 different from Pedixplorer's `kindepth(align_parents = TRUE)` (its depths
  up to 738 in a 300-animal colony; unaligned, all three agree).
- **Nothing to fix on the colonies:** `addParents()` adds 0 rows, `getIdsWithOneParent()` finds 0,
  `removeUnknownAnimals()` drops 0, `addBackSecondParents()` adds 0, at 300 and on the sample; kinship2's
  `fixParents()` and Pedixplorer's `fix_parents()` add 0. On a seeded damaged copy (5% of sires blanked, 1% of
  parents' rows removed) at 300: 14 animals with one parent, 3 parents without a row; `addParents()` adds 3 rows,
  kinship2's and Pedixplorer's 17.
- **Counts:** IBD pairs with both parents 852, 2,914, 8,792, 29,246, 87,602 and 292,320 at 300 to 100,000 (sires
  only: 576 ... 196,160); full-sibling pairs born in the same year 0 at 300, 3,000 and 100,000 (a dam bears at most
  once a year); full sibships of two or more 71 at 300, 450 at 3,000, 2,733 at 100,000.

---

## 4. Evidence inventory: what 17h and 17i read, write and change

Searched with `git grep` and `grep -n` at `dd2d1c2` (commands in section 4.6).

### 4.1 Copied from nprcgenekeepr into `tools/timing/` (17h1, 17h3)

From `tools/pedigreeComparison/` (last changed at `d75f07f6b`; read at the commit 17h1 names) and
`tools/perf/harness.R:24`-`:72`. Each copy's header names its source path and commit; every change from the source is
listed in that header.

| pedkindraw file | Source | What changes |
|---|---|---|
| `tools/timing/comparisonFormats.R` | `comparisonFormats.R` | BGmisc's converters (`toBGmisc()`, `toBGmiscNumeric()`) dropped |
| `tools/timing/generateColonyPedigree.R` | `generateColonyPedigree.R` | none (section 3.2) |
| `tools/timing/savePedigrees.R` | `savePedigrees.R` | the seven colonies and the sample from `inst/extdata`; nprcgenekeepr's datasets (`smallPed`, `lacy1989Ped`, `examplePedigree`) and kinship2's `sample.ped` dropped (no case reads them) |
| `tools/timing/measure.R` | `tools/perf/harness.R:24`-`:72` | only `usedMb()`, `maxUsedMb()`, `mbColumnAfter()`, `measure()`, `withSeed()` |
| `tools/timing/timingHarness.R` | `timingHarness.R` | `useTimingLibraries()` puts pedkindraw's scratch library first and renv's library next (no `CMP_LIB`: kinship2 and Pedixplorer are in renv's library); `reportTimedCall()` also reports where pedkindraw was loaded from (section 8, dragon 2) |
| `tools/timing/timeOne.R`, `runTiming.R`, `summarizeTiming.R` | the same names | `NPG_LIB` becomes `PKD_LIB`; paths; `summarizeTiming.R` prints the variation across each cell's 3 runs as the study's section 7 did |
| `tools/timing/timingCases.R` | `timingCases.R` | rewritten: section 5.1's computation cases, pedkindraw's names after 17c (`kinship(id, sire, dam, pdepth)`, `trimPedigree(ped, probands)`, `getDescendantPedigree(ped, probands)`); BGmisc's 4 cases dropped |
| `tools/timing/drawingTiming.R`, `drawOne.R`, `runDrawingTiming.R`, `summarizeDrawingTiming.R`, `drawingCapture.R` | the same names (17h3) | ggpedigree's helpers dropped; `drawNprcgenekeepr()` becomes pedkindraw's. **R157 (S83):** of `drawingCapture.R` only the four Pedixplorer helpers the cases call; its capture functions serve the study's parent-line comparison (`runDrawing.R`) and are not copied, nor are `drawingTrace.R`, `smallPed` and `samplePed` they would bring |
| `tools/timing/drawingTimingCases.R` | `drawingTimingCases.R` (17h3) | rewritten: section 5.1's drawing cases; ggpedigree's two dropped |
| `tools/timing/tests/` | `tools/pedigreeComparison/tests/` and `tests/testthat/test_perfHarness.R:79`-`:131` | the tests of the files above, changed with them; BGmisc's and ggpedigree's blocks dropped |

### 4.2 Written by the runs (17h2, 17h4)

Committed: `tools/timing/results/timing.csv`, `timingRuns.csv`, `drawingTiming.csv`, `drawingTimingRuns.csv`,
`pedigreeFiles.csv`, and `record.csv` (one row per record: its date, the pedkindraw commit installed, `git rev-parse
<commit>:R`, the R, kinship2, Pedixplorer, chromote and Chrome versions, the machine's model, cores and memory). R155
(S80): `runTiming.R` appends the row when a record starts, its columns `record`, `started`, `commit`, `rTree`,
`packaged`, `R`, `kinship2`, `Pedixplorer`, `chromote`, `chrome`, `model`, `chip`, `cores`, `memoryGb`.
Git-ignored (new lines in `.gitignore`, which has none for `tools/` today): `tools/timing/data/synthetic_*.csv`
(rebuilt by `savePedigrees.R`, checked by md5), `tools/timing/results/*Machine.txt` (the names of the programs running
on the machine), `tools/timing/pictures/`. `tools/` is build-ignored (`.Rbuildignore:22`), so none of it ships.

### 4.3 Every place that states a time

17i reads each. Found by `grep` for "second", "s" after a number, "minute", "GB", "GiB" and the sizes (section 4.6).

| Place | What it states | 17i |
|---|---|---|
| `vignettes/drawing.Rmd:794`-`:806` ("## How large a drawing can be") | S75's drawing times on pedigrees taken from nprcgenekeepr's `examplePedigree` (2.0 s at 501 ... 50.5 s at 2,000; 16.7 and 19.1 s for two other shapes) | keeps them (a different pedigree, as it says) and adds a pointer to the speed vignette |
| `NEWS.md:324`-`:325` (G17b's bullet) | "about 9 seconds for 1,000 animals and 50 for 2,000" | unchanged (a record of G17b); 17i's NEWS bullet names the vignette |
| `docs/planning/pedkindraw-api-contract.md:323`-`:333` (section 7) | nprcgenekeepr's November numbers, S75's drawing times | a "pedkindraw, measured" figure in each row from 17h's results |
| contract `:343` (section 8, "Drawing past about 1,000 animals") | that `drawPedigreeDiagram()`'s help "states the measured limit"; no help page states a time (S77) | made true (T5, section 7) |
| contract `:204`, `:209` (`findUnrelated()`: kinship2's 6.5 s; the prototype's 0.7 s at 10,000) and `:229`, `:238` (`asPedFrame()` 0.022 s and 0.005 s) | single runs of the phases that wrote them | unchanged (records of those phases) |
| `R/penaltyCrossprod.R:19`-`:22` | an internal function's note (1.07 s, 0.04 s), no help page | unchanged |
| `man/`, `README.Rmd`, `vignettes/pedkindraw.Rmd` | no time | -- |

### 4.4 The pointers R82 left out (17i)

`R/pedkindraw-package.R:52` ("@section Getting started:", which names the two vignettes; backlog `:36` cited `:42`
before S78 corrected it), `vignettes/pedkindraw.Rmd:407` ("## Where next"),
`vignettes/drawing.Rmd:794` ("## How large a drawing can be"; the cran plan's 17i row cited `:681` before S78
corrected it) and
`:808` ("## Where next"). `_pkgdown.yml` has no articles list: pkgdown lists every vignette, so the site's third
article comes with the file (17i checks the built site).

### 4.5 The draft (`draft/speed-vignette`, `612eed9`; not merged)

`vignettes/speed.Rmd` (372 lines; nine tables after `<!-- speed-table: <name> -->` markers: `records`, `code`,
`computation-seconds`, `computation-capacity`, `rewrite`, `drawing-seconds`, `drawing-parts`, `drawing-capacity`,
`single-runs`) and `tools/checkSpeedTables.R` (709 lines: reads nprcgenekeepr's results with `git show` at three
commits, the plan's Done records and the ledger; builds each table and caption; compares cell for cell; fails on a
table without a marker; `--print=<name>`). **Carries over:** the markers, the build-and-compare design, the caption
rule (date, code timed, versions, machine), the failure words ("memory", "time", "refused", "not run"), the
definitions of each computation (Mark's S30 request), "What these numbers cannot tell you". **Changes:** the tool reads
`tools/timing/results/` (no clone); `code`, `rewrite` and `single-runs` go (R153), `records` becomes one row per
pedkindraw record; the tables gain section 5.1's rows.

### 4.6 The searches

`git grep -n -i -E 'seconds?\b|[0-9] s[ ,.;)]|minutes?\b' -- vignettes R NEWS.md README.Rmd man`;
`grep -rn -E '(30|100|10),000|GiB|\bGB\b' R vignettes README.Rmd`; `grep -n 'How large a drawing\|^## Where next'
vignettes/*.Rmd`; `grep -n 'Getting started' R/pedkindraw-package.R`; `grep -n 'tools\|docs' .Rbuildignore`; `grep -n
'tools' .gitignore .github/workflows/*.yaml` (none in either); `grep '^export(' NAMESPACE` (38); `git -C
../nprcgenekeepr ls-files tools/pedigreeComparison`; `git -C ../nprcgenekeepr grep -l alignMates -- R/` (none);
`getNamespaceExports()` of kinship2 and Pedixplorer.

---

## 5. The design

### 5.1 The cases (R153)

**Computation** (`tools/timing/timingCases.R`; one case per function and package; `pkd_` pedkindraw, `k2_` kinship2,
`pdx_` Pedixplorer). The study's 25 cases for kinship2, Pedixplorer and nprcgenekeepr, nprcgenekeepr's eight now
pedkindraw's (`pkd_kin`, `pkd_kin_sparse`, `pkd_kinX`, `pkd_gen`, `pkd_fam`, `pkd_shrink`, `pkd_anc`, `pkd_desc`),
called as a user calls them today, plus `pkd_unrel` (`findUnrelated()`), so 26; then, for the second group, one case
each for pedkindraw's 13 functions and `alignMates`, `asPedFrame()` twice (a kinship2 and a Pedixplorer object), and
each kinship2 and Pedixplorer function of section 3.3's table: 15 + 10 + 14 = 39; then the 13 pedkindraw-only
functions. **78 cases.**

**Drawing** (`tools/timing/drawingTimingCases.R`): `pkd_page`, `findGeneration()`, `makePedigreeMatingLayout()` and
`drawPedigreeDiagram()` (rectilinear lines, the default) saved as a web page, then drawn in Chrome, as the study's
nprcgenekeepr page; `pkd_page_direct`, the same with direct lines; `pkd_svg`, `pkd_pdf`, `pkd_png`,
`savePedigreeDiagram()` of a widget built before the clock (so each says what saving adds); `pkd_data`,
`makePedigreeDiagramData()` alone; `k2_picture`, `pdx_picture`, `pdx_picture_unaligned`, `pdx_plotly`,
`pdx_plotly_unaligned`, as the study's. **11 cases**, on a canvas of 3,600 x 1,500 pixels (the study's); the three
files at `savePedigreeDiagram()`'s own page.

### 5.2 The inputs (built before the clock; R154)

The study's `timingInputs()`: 30% genotyped and 10% affected (seed 42), 5 probands with a known sire (seed 7). The
inputs the study had no case for, as R154 ruled them (S79; section 3.8 measured them): `familyCheck()` the family
numbers `findPedigreeNumber()` gives (Pedixplorer's `family_check()` stops on them on the colonies, recorded);
`ibdMatrix()` each animal's own value 1 and 0.5 for each sire and each dam pair (852 pairs at 300, 292,320 at 100,000;
S78 wrote 196,160, the sires-only count); `getNearRelativePedigree()` `maxDist = 3` (the app's default) about the 5
probands; `removeAnimals()` 5 seeded animals with a known sire and no offspring (S78 proposed the 5 probands, on which
kinship2's `pedigree.trim()` stops); `findAvailAffected()` `affstatus = TRUE`; `countOffspring()` every animal;
`removeUnknownAnimals()` `addParents()`'s result; `addBackSecondParents()` `trimPedigree()`'s result;
`checkTwinRelations()` 1 full-sibling pair per 100 animals, each from another sibship, seeded, coded `"DZ twin"` (S78
proposed pairs born in the same season, which no colony has); `hasBothParents()` the first proband. The five repair
functions run on the colonies as they are, finding nothing to fix. kinship2 and Pedixplorer get each value in their
own coding (`comparisonFormats.R`).

### 5.3 The pedigrees and sizes

Computation: the seed-1 colonies of 300, 1,000, 3,000, 10,000, 30,000 and 100,000 animals (the study's Part A).
Drawing: 300, 1,000, 2,000 and 3,000, then the 375-animal sample (the study's Part B). kinship2 and Pedixplorer get the
study's placeholder parents for an animal with one known parent (`completeParentage()`), pedkindraw the pedigree as it
is.

### 5.4 The method

The study's, section 3.1, with R153's load rule: a run starts once at least 50% of the CPU is idle, waiting at most 10
minutes and then starting anyway with `quiet = FALSE` recorded; each run's idle share, 1-minute load average and free
memory (`memory_pressure -Q`, recorded, not a gate; the `memFree` column, read after the idle wait, R155) go in its
row. Never two runs at once: the computation and drawing records run in different sessions, and nothing else runs
meanwhile (no test suite, no check, no other Chrome; app plan dragons 8 and 19).

### 5.5 The code timed

pedkindraw is built from the record's commit (`R CMD build --no-build-vignettes`) and installed into a scratch library
(`R CMD INSTALL --library=<scratch>/pkdlib`, byte-compiled, as CRAN installs it); `PKD_LIB` puts it first on the child's
library path, renv's library next. Each run records the folder pedkindraw was loaded from, and a run that loaded it from
anywhere else stops the record (renv's library holds a stale pedkindraw 0.0.1, backlog `:227`, and `DESCRIPTION` reads
0.0.1 too, so the version cannot tell them apart). `record.csv` names the commit and `R/`'s tree, and the record stops
before its first run when `R/`, `DESCRIPTION` or `NAMESPACE` has uncommitted changes or the install was packaged before
their last commit (R155); if `R/`,
`DESCRIPTION` or `NAMESPACE` changes after a record, 17n lists each change and whether it can change a time (section
6, amendments).

### 5.6 The results

Section 4.2's files, written after every run (a stopped record keeps what it ran). The summaries print each table the
vignette needs (`summarizeTiming.R`, `summarizeDrawingTiming.R`). The pictures (each warm-up's file and a Chrome
picture of each page, pedkindraw's at zoom 1) go to the git-ignored `tools/timing/pictures/`, as the study's did.

### 5.7 How the vignette and the check read them

`vignettes/speed.Rmd` runs no code: CRAN rebuilds vignettes inside its 10-minute check, and `tools/` is not in the
tarball. Each table is typed after its marker; `Rscript tools/checkSpeedTables.R` rebuilds every table and caption from
`tools/timing/results/` and compares them cell for cell, exiting 0 only when all are equal and every table has a
marker; `--print=<name>` prints the table it expects. Since it reads only this repository, CI can run it (T5). Claude's
proposal for 17i: every number in the page's prose is in a table, or the tool lists and checks it (the draft's tool
checked tables and captions only).

### 5.8 The vignette's outline (R153)

"Speed and size limits", no drawing:

1. What the page answers: one machine, one date, the pedkindraw commit timed, kinship2's and Pedixplorer's versions;
   every number checked by `tools/checkSpeedTables.R`.
2. The machine and the method; a table of the records (date, runs, CPU idle at the runs' starts, commit, versions).
3. Computation: a one-line definition of each computation (bit size, an unavailable animal, a family check, an IBD
   matrix, near relatives and the others: Mark's S30 request); seconds by number of animals, pedkindraw beside kinship2
   and Pedixplorer; what this means for a user; the largest size finished and the memory there.
4. Drawing: seconds by size (the page in R and in Chrome; the SVG, PDF and PNG files; kinship2's and Pedixplorer's
   pictures and Pedixplorer's plotly page); the largest size drawn and the memory there; how large a drawing can still
   be read (T4).
5. What these numbers cannot tell you (another machine, a smaller machine's memory, another browser, a real
   pedigree's shape: the drawing vignette's S75 times show shape matters).
6. Where next.

One sentence says the drawing code began as a copy of nprcgenekeepr's; nprcgenekeepr's November numbers are not on the
page.

---

## 6. Phases

Each is one session; close out when its DONE holds. Every session's Orient runs the drift tool and Learning 15's log of
the copied files (the cran plan's section 4.4); 17h1 and 17h3 also run `git -C ../nprcgenekeepr log --oneline
d75f07f6b..HEAD -- tools/pedigreeComparison tools/perf/harness.R` (a change there since `d75f07f6b` is read before the
copy). Commands run from the root with renv's library and `RENV_PROJECT` unset unless said (Learning 5), under `bash`
(section 8, dragon 4).

### Phase 17h1. The computation harness (strict TDD, a copy)

- **Work:** RED: copy the tests of the computation harness (section 4.1: `test_timingHarness.R`,
  `test_comparisonFormats.R`, `test_generateColonyPedigree.R`, the two helpers, `test_perfHarness.R:79`-`:131`) into
  `tools/timing/tests/`, changed as section 4.1 says, plus new tests: each section 5.1 computation case returns on the
  300-animal colony and the sample; each pairing gives the same answer as pedkindraw's on typed cases and the sample
  (or the difference is shown and recorded, Learning 19); `useTimingLibraries()` puts `PKD_LIB` first; a child that
  loads pedkindraw from another folder fails. They fail because the files are missing. GREEN: copy and change the
  files. Then the `.gitignore` lines of section 4.2. Pre-RED picker (T1): the inputs of section 5.2.
- **DONE:** `Rscript -e 'testthat::test_dir("tools/timing/tests")'` 0 failed, WARN 0 (Learning 10), SKIP 0;
  `Rscript tools/timing/savePedigrees.R` writes the 7 colonies, each md5 the study's (7 of 7) and `pedigreeFiles.csv`;
  a trial `Rscript tools/timing/runTiming.R --sizes=300 --out=<scratch>` over all 78 cases, every case `ok` at 300 (not
  committed: it is a trial, not the record); `lintr::lint_dir("tools/timing")` 0; the package checks unchanged (no
  `R/` change: `git diff --stat <claim>..HEAD -- R DESCRIPTION NAMESPACE` empty).
- **Surface:** this Mac. It shows the harness and the cases work; it cannot show a time (the trial is one size, not
  the record).
- **Done (S79):** `tools/timing/` holds the nine harness files and `tools/timing/tests/` its nine test files (RED
  `8fc668b`, `df2e102`, amendments `5b42ca0`, `d23cbbf`; GREEN `cd002dc`, `a8390fb`; REFACTOR `b9d5893`), each copy's
  header naming nprcgenekeepr's file at `3e06730c5` and every change, `diff` showing only those hunks (`measure.R`
  byte for byte `tools/perf/harness.R:19`-`:72`). `test_dir("tools/timing/tests")` with `PKD_LIB` set `[ FAIL 0 | WARN
  0 | SKIP 0 | PASS 1143 ]` (108 tests, about 3 minutes: Pedixplorer's `shrink()` takes about 90 s on each of the two
  pedigrees); `savePedigrees.R` "8 of 8 files identical to the study's" (the seven colonies and the sample, whose md5
  is the study's `rhesus375.csv`); the trial (`--sizes=300`, scratchpad): 78 cells from 309 runs, 77 `ok` and
  Pedixplorer's `pdx_famcheck` `error` ("'dimnames' applied to non-array"), which R154 recorded, so not the 78 `ok`
  this phase's DONE wrote before R154; all 148 pedkindraw runs loaded it from `PKD_LIB`; idle CPU 55.1-90.8% at the
  starts; the largest spread of a cell's 3 runs 3.2%; lint 0; no file under `R/`, `tests/`, `man/`, `vignettes/`,
  `inst/`, `DESCRIPTION` or `NAMESPACE` changed. Found after the picker and recorded by the tests under R154's rule:
  kinship2's `makekinship()` gives 1 as the self-kinship of each animal in no family (10 in the colony), and
  `makefamid()` puts those animals in family 0, Pedixplorer's `make_famid()` in none (`NA`); Pedixplorer's
  `descendants()` returns `NULL` when the probands have none (the colony's 5 have none). The typed cases of this
  phase's Work were read as the package suite's own comparisons with kinship2 and Pedixplorer: the harness's
  pairing tests run on the colony and the sample, the calls the cases make.

### Phase 17h1b. Each run's free memory, and `record.csv` (strict TDD; found at S79's close-out)

- **Work:** section 5.4's free memory and section 4.2's `record.csv`, which 17h1's copy had no code for. Pre-RED picker
  (R155): when the row is written, the build check, where the free memory is read.
- **DONE:** `test_dir("tools/timing/tests")` 0 failed, WARN 0, SKIP 0; a trial writes `memFree` in every run's row and
  one `record.csv` row; lint 0; no `R/` change.
- **Done (S80):** RED `a2def9e` (18 tests in `test_timingHarness.R`'s last section), GREEN `c458ca4` (`runRow()` and the
  record's functions in `timingHarness.R`; `runTiming.R` writes the row before its first run and reads
  `currentMemoryFree()` after each idle wait), REFACTOR `5efec3d` (`timeStamp()`). `test_dir` with `PKD_LIB` `[ FAIL 0 |
  WARN 0 | SKIP 0 ]`, 126 tests, 1,208 expectations; a trial (`pkd_gen`, `k2_kin` at 300): 8 runs `ok`, `memFree` 45-46
  in each row, and one `record.csv` row (`a2def9e`, `R/`'s tree `ac123b7`, packaged 2026-11-23 17:39:10 UTC, R 4.6.2,
  kinship2 1.9.6.2, Pedixplorer 1.8.0, chromote 0.5.1, Chrome 157.0.8103.51, Mac14,6, Apple M2 Max, 12, 96); with
  `PKD_LIB` an empty folder the record stopped before writing anything; lint 0; no file under `R/`, `DESCRIPTION` or
  `NAMESPACE` changed.
- **Surface:** this Mac. The build check's stop on uncommitted `R/` files was shown on temporary git repositories in the
  tests, not on this repository's tree.

### Phase 17h1c. Each run's `started` (strict TDD; found at S80's close-out)

- **Work:** dragon 24: the copied `runOnce()` made each run's row, and its `started`, after `runLimited()` returned.
  Pre-RED picker (R156): which moment `started` records.
- **DONE:** `test_dir("tools/timing/tests")` 0 failed, WARN 0, SKIP 0; in a trial every row's `started` plus its
  `realSeconds` at or before the next row's `started`; lint 0; no `R/` change.
- **Done (S81):** R156 `96a7f39`; RED `7c6e8e7` (2 new tests of `runLimited()`'s `launched`, the row test given its
  time through the run's figures, 1 new test of `runRow()`'s arguments), GREEN `c7cff5d` (`runLimited()` returns
  `launched`, `runRow()` writes it with `timeStamp()` and has no `started` argument), REFACTOR `df6dbca` (the copied
  inner `started`, the time of the child's "CALL START", renamed `callStarted`). `test_dir` with `PKD_LIB` `[ FAIL 0 |
  WARN 0 | SKIP 0 ]`, 129 tests, 1,219 expectations; a trial of the real script (`pkd_gen`, `k2_kin` at 300): 8 runs
  `ok`, each row's `started` plus `realSeconds` before the next row's `started` (1.8-1.9 s between back-to-back
  measured runs, the idle check's own time; 69-221 s where it waited for half the CPU idle), the last run started
  12:57:11 and ended 12:57:12.1 by its `realSeconds`, the end note 12:57:12; lint 0; no file under `R/`,
  `DESCRIPTION` or `NAMESPACE` changed.
- **Surface:** this Mac, at 300 animals only, where a run lasts about 1.2 s, so `started` moved by about a second; at
  the larger sizes it moves by each run's whole length (up to 120 s after loading).

### Phase 17h2. The computation runs (no code)

- **Work:** at Orient, `git status` clean and the commit to time chosen (HEAD); build and install it (section 5.5; S79's
  commands: from a scratch folder, `R CMD build --no-build-vignettes --no-manual <repo>`, then `R CMD INSTALL
  --library=<scratch>/pkdlib pedkindraw_*.tar.gz`, both with renv's library as `R_LIBS` and `RENV_PROJECT` unset; then
  `PKD_LIB=<scratch>/pkdlib` for every command); `Rscript tools/timing/savePedigrees.R` (the data files are
  git-ignored, so a clone has none);
  `uptime`, `top`, `memory_pressure` read; `Rscript tools/timing/runTiming.R` in the background (all 78 cases, all six
  sizes), watched until it ends; `summarizeTiming.R` printed; one cell of each kind re-run from a fresh shell and set
  beside the record's (the study's two re-runs differed by 3% and 4%); the results committed. `runTiming.R` writes
  `record.csv`'s row itself when the record starts (R155), and stops at once unless `PKD_LIB` was built after the last
  commit to `R/`, `DESCRIPTION` or `NAMESPACE` with those clean (dragon 22); build it at a short path that names no
  person (dragon 23).
- **DONE:** `timing.csv` has, for every case, a row per size up to and including its first failure, each `ok` row the
  median of 3 measured runs; every run's start met the load rule, or `timingRuns.csv` shows which did not; the
  variation across each cell's 3 runs printed for cells of 0.5 s or more (the study's largest was 7.9%); every run
  loaded pedkindraw from the scratch library; the re-runs reported. Nothing under `R/`, `tests/`, `vignettes/` changes.
- **Surface:** this Mac only (section 3.5's machine). It cannot show another machine's times or a smaller machine's
  memory limits; the page says so.
- **Session boundary:** one session (about 3.5-4 hours of runs, a guess). If the runs cannot finish in it, the session
  commits the rows it has, closes out, and 17h2b runs the rest at the same commit (`runTiming.R <case ids>`).
- **Done (S82):** results `14145a4`. `PKD_LIB` at `/Users/Shared/pkdtiming/pkdlib` (Mark's pick), pedkindraw built
  from `7f13d98`, packaged 20:41:40 UTC (`R/` tree `ac123b7`, unchanged since `09e8f45`); `savePedigrees.R` 8 of 8
  identical to the study's. The record 14:42:24-22:17:43 CST, exit 0, started with vitest workers and a remote-desktop
  agent running (Mark's pick: start, the load recorded). `timing.csv` 438 cells, 78 of 78 cases each with every size up
  to and including its first failure; 416 `ok`, each the median of its 3 measured runs (416 of 416 checked); 22 failed:
  11 `memory` (R's 29.8 GiB vector limit), 9 `time`, 2 `error` (kinship2's `findAvailNonInform()` at 1,000, dragon 27;
  Pedixplorer's `family_check()` at 300, R154). `timingRuns.csv` 1,686 runs; idle at start 48.0-77.8% (median 57.5), one
  under 50% (`pdx_desc` 10,000 warm-up, 47.98%, after the full 10-minute wait); load 5.0-82.2 (median 7.9); `memFree`
  42-51%; 852 pedkindraw runs loaded it from `PKD_LIB`, its other 6 (its failed warm-ups) stopped before reporting, no
  kinship2 or Pedixplorer run loaded it. 74 cells of 0.5 s or more: spread across 3 runs median 1.6%, largest 13.2%
  (Pedixplorer's `kinship()` at 10,000; 10.9% at 3,000). Re-runs from a fresh shell (`--sizes=10000 --out=<scratch>`,
  the autosomal kinship cell of each package): kinship2 3.272 s against the record's 3.039 (+7.7%), Pedixplorer 4.841
  against 4.970 (-2.6%), pedkindraw 2.802 against 2.745 (+2.1%). The record's wall time 7.6 h, 2.4 h of it in runs
  (dragon 26). No file under `R/`, `tests/` or `vignettes/` changed.

### Phase 17h3. The drawing harness (strict TDD, a copy)

- **Work:** as 17h1 for drawing: RED, the tests of `test_drawingTiming.R` and `test_drawingCapture.R`, changed as
  section 4.1 says, plus each section 5.1 drawing case making its file on the 300-animal colony and the sample; GREEN,
  the files. `savePedigreeDiagram()` stops at 60 s by default (`options(pedkindraw.saveTimeout = )`): the save cases set
  it above the 120 s limit, so the harness, not the function, decides a failure (section 8, dragon 7). Pre-RED picker
  (T2): the canvas and page sizes, and which pictures are kept.
- **DONE:** `test_dir("tools/timing/tests")` 0 failed, WARN 0, SKIP 0 (Chrome found; `NOT_CRAN=true`); a trial
  `runDrawingTiming.R --sizes=300 --out=<scratch>` over the 11 cases, every case `ok` at 300 and on the sample; lint 0;
  no `R/` change.
- **Surface:** this Mac's Chrome. Another browser is not timed.
- **DONE amended (S83, R157):** Pedixplorer 1.8.0 with its parent alignment on refuses the 300-animal colony
  ("subscript out of bounds", `pdx_picture` and `pdx_plotly`, here as in the study), so the trial reads 9 of 11 cases
  `ok` at 300 and 11 of 11 on the sample, the two refusals recorded by the tests.
- **Done (S83):** R157 `46d8a23` (T2 and the copy's scope); RED `4ed5c8e` (`test_drawingTiming.R` copied and changed,
  `test_drawingCapture.R` new for the four helpers, `helper-checks.R`'s Chrome, PNG, SVG and PDF checks; 40 new tests
  failing for the right reason, 35 on a missing function and 5 on the missing `drawOne.R`, the 129 before them passing,
  SKIP 0); GREEN `c7d6f89` (`drawingTiming.R` with `drawingRunRow()` and `pedigreeSize()`, `drawingCapture.R`,
  `drawingTimingCases.R`, `drawOne.R`) and `701d4f4` (`runDrawingTiming.R`, `summarizeDrawingTiming.R` with `--out=`);
  REFACTOR `7d57adc` (`pedkindrawPage()`; `colonyFile()` in `helper-caseValues.R`). Each copy's header names
  nprcgenekeepr's file at `3e06730c5` and every change, and `diff` lists only those hunks (`drawingCapture.R`'s body
  byte for byte the source's lines 103-154). `test_dir("tools/timing/tests")` with `PKD_LIB` and `NOT_CRAN=true`
  `[ FAIL 0 | WARN 0 | SKIP 0 | PASS 1468 ]`, 169 tests; the drafted tests were first run against a
  scratch draft of the code (40 of 40, 249 expectations) and without it (40 of 40 failing). The trial
  (`runDrawingTiming.R --sizes=300 --out=<scratch> --pictures=<scratch>`, 03:44-04:02 CST on 2026-11-24, 17 minutes):
  `record.csv` one `drawing` row (`c7d6f89`, `R/` tree `ac123b7`); 82 runs, 22 cells, 9 of 11 `ok` at 300 and 11 of 11
  on the sample; all 48 `ok` pedkindraw runs from `PKD_LIB`; idle 51.4-67.3% at each start; each `started` plus
  `realSeconds` at or before the next `started`; 16 cells of 0.5 s or more, spread median 2.2%, largest 6.4%; seconds
  at 300 and on the sample: `pkd_page` 1.22 and 2.05, `pkd_page_direct` 0.447 and 0.978, `pkd_svg` 1.46 and 1.45,
  `pkd_pdf` 2.59 and 2.60, `pkd_png` 2.42 and 2.45, `pkd_data` 0.001 and 0.001, `k2_picture` 0.443 and 1.43,
  `pdx_picture` refused and 3.48, `pdx_picture_unaligned` 1.24 and 3.49, `pdx_plotly` refused and 31.9,
  `pdx_plotly_unaligned` 29.7 and 35.7; 21 MB of pictures, the zoom-1 picture's ids readable; `summarizeDrawingTiming.R
  --out` printed every table. Lint 0; no file under `R/`, `DESCRIPTION` or `NAMESPACE` changed.

### Phase 17h4. The drawing runs (no code)

- **Work:** as 17h2 for drawing (`runDrawingTiming.R`, all 11 cases, 300, 1,000, 2,000, 3,000 and the sample), at a
  commit whose `R/` tree is 17h2's (else both records say which they timed, and the vignette's records table shows two
  trees); the pictures opened for Mark, who judges the largest size at which an animal can still be found by its id and
  its lines followed to its parents (T4).
- **DONE:** as 17h2's, for `drawingTiming.csv` and `drawingTimingRuns.csv`; a drawing counts only when R and Chrome
  together finish within 120 s; Mark's judgment recorded (a ruling).
- **Surface:** this Mac and its Chrome.
- **Done (S84):** results `a4b41da`; R158 (T4, and the two saves not timed at 3,000). The record 09:38:53-11:14:27 CST
  (1 h 36 min, dragon 35), exit 0, at `70d5021` (`R/` tree `ac123b7` and `PKD_LIB` packaged 20:41:40 UTC, both as
  17h2's), three vitest workers each at a full core (shown to Mark at the orient picker). `drawingTiming.csv` 43 cells:
  every case a row per size up to and including its first failure, then the sample; 33 `ok`, each the median of its 3
  measured `ok` runs after an `ok` warm-up; 10 failed: 6 `time` (over 120 s after the call started), Pedixplorer's 2
  refusals at 300 (R157), 2 saves not timed at 3,000 (R158, dragon 33). `drawingTimingRuns.csv` 142 runs (43 warm-up,
  99 measured); idle at each start 50.2-68.4% (median 61.4), none under 50; load 5.1-21.8 (median 7.5); `memFree`
  46-50%; 92 `ok` pedkindraw runs all from `PKD_LIB`, its 5 failed runs stopped before they reported, no other run
  loaded pedkindraw; each `started` plus `realSeconds` at or before the next `started` (smallest gap 0.92 s); 40 of 40
  `ok` page runs with browser seconds; no private path. All checked by a script over the files, 0 problems; the same
  script found 3 of 3 problems planted in a changed copy. Capacity within 120 s, median seconds at the largest size
  drawn: `pkd_page` 1,000 (16.0; `time` at 2,000), `pkd_page_direct` 2,000 (106; `time` at 3,000), `pkd_svg` 2,000
  (6.04), `pkd_pdf` 1,000 (5.41; `time` at 2,000), `pkd_png` 2,000 (9.66), `pkd_data` 3,000 (0.003), `k2_picture`
  1,000 (12.2), `pdx_picture` refused at 300, `pdx_picture_unaligned` 1,000 (16.2), `pdx_plotly` refused at 300,
  `pdx_plotly_unaligned` 300 (29.7; `time` at 1,000); all 11 drew the sample. 26 cells of 0.5 s or more: spread median
  1.9%; 3 over 10%, each a `savePedigreeDiagram()` save with one slow run (dragon 34). Re-runs from a fresh shell
  (`--sizes=1000 --out=<scratch> pkd_page pkd_svg`): `pkd_page` 15.92 against the record's 15.98 s (-0.4%), on the
  sample 2.01 against 1.98 (+1.1%); `pkd_svg` 2.39 against 2.35 (+1.7%), on the sample 1.44 against 1.53 (-6.3%). The
  study's nprcgenekeepr page (`npg_widget`, the same code) took 15.46 s in R at 1,000 and `time` at 2,000; pedkindraw's
  15.5 s and `time`. T4: Mark judged pedkindraw's pages readable up to 1,000 animals, zoomed in, from the pages
  (rectilinear at 300, 1,000 and the sample; direct at 2,000) and the zoom-1 pictures (R158). No file under `R/`,
  `tests/` or `vignettes/` changed.

### Phase 17i. The speed vignette (Phase 16d returns; updated by this plan)

- **Work:** `vignettes/speed.Rmd` from the draft's design, to section 5.8's outline, its tables from 17h's results;
  `tools/checkSpeedTables.R` rewritten to read `tools/timing/results/` (section 4.5); the pointers (section 4.4); the
  contract's section 7 rows and section 8's claim (section 4.3, T5); a NEWS bullet; the site's third article. Strict TDD
  for the pointers and the help: a docs test (`tests/testthat/helper-docs.R`'s helpers) reads each pointer before it is
  written.
- **DONE:** the check tool exits 0, and 1 on a changed cell, a swapped row, an unmarked table and a changed result
  file (a scratch tree); the vignette builds with kinship2 and Pedixplorer absent and runs no timing; the installed
  size under 5,120 KB (R77; 4,284 KB at S29, before G1-G17, so 17i measures it first); `R CMD check --as-cran` R16's
  NOTE only; the full suite 0 failed, WARN 0; the site shows three articles; the words of section 5.8's definitions
  each on the page.
- **Surface:** this Mac, GitHub Actions, the website.
- **Split (S85, R159):** 17i1, the check script with its tests, the page with a docs test of its words, its NEWS line
  and the CI workflow; 17i2, the pointers (section 4.4), the help sentence (T5), the contract's sections 7 and 8 and the
  site's third article. Each is one session.

### Amendments to later phases (recorded in the cran plan at S78's close-out)

- **17n** (the full local gate) adds: `git diff <17h2's commit> -- R DESCRIPTION NAMESPACE` empty, or each change listed
  with whether it can change a time on the page.
- **17j** (full coverage) and **17k** (the CRAN-mode test time) change tests only, so they do not move the timed code.

---

## 7. Decisions left for each phase's picker

| # | Question | Phase | What is known now |
|---|---|---|---|
| T1 | The inputs of the cases the study had none for (section 5.2), and what to do with a pairing whose answer differs from pedkindraw's (time it with a note, or leave it out) | 17h1 | **Decided (S79, R154):** section 5.2 with four changes; the repair functions on the colonies as they are; every pairing timed, each difference recorded by the tests (section 3.8) |
| T2 | The drawing's canvas and the saved files' page; which pictures are kept | 17h3 | **Decided (S83, R157):** the study's canvas 3,600 x 1,500; the saved files on `savePedigreeDiagram()`'s own 10-inch page; the pictures kept as the study's, git-ignored; of `drawingCapture.R` only the four Pedixplorer helpers |
| T3 | None planned. If the machine does not reach 50% idle within 10 minutes for many runs, whether to go on | 17h2, 17h4 | at the picker, 85% idle (section 3.5) |
| T4 | How large a pedkindraw drawing can still be read (Mark's judgment from 17h4's pictures), or the study's judgment of nprcgenekeepr's drawing carried with a note | 17h4 | **Decided (S84, R158):** readable up to 1,000 animals, zoomed in (Mark's judgment from 17h4's pages and zoom-1 pictures; the same as the study's of nprcgenekeepr's drawing) |
| T5 | Where the measured drawing limit is stated, so the contract's section 8 is true: a sentence in `?drawPedigreeDiagram` pointing to the vignette, or the contract changed to name the vignette; and whether CI runs `tools/checkSpeedTables.R` | 17i | **Decided (S85, R159):** a sentence in `?drawPedigreeDiagram` naming the measured size and `vignette("speed")` (17i2); a small Linux-only workflow runs the script when the page, the results or the script change |

---

## 8. Here be dragons

1. **Copied tests run on testthat edition 3 here** (Learning 10): `tools/timing/tests/` sits below pedkindraw's
   `DESCRIPTION`, which names edition 3, and the study's tests were written for nprcgenekeepr's edition 2. Read RED's
   and GREEN's WARN count, not only FAIL; `expect_warning()` and `expect_message()` return the condition.
2. **A stale pedkindraw 0.0.1 in renv's library** (backlog `:227`): a child that finds it instead of the scratch
   install times old code with no error (it lacks every function after S25, but `kinship()` and the layout run). The
   version cannot tell them apart (both 0.0.1): check the folder (section 5.5).
3. **Child processes inherit renv's variables** (Learning 5): `RENV_PROJECT`, `R_LIBS_USER` pass to `Rscript`
   children; the harness sets each child's library path itself (`useTimingLibraries()`).
4. **zsh does not split an unquoted variable** (S78: `R="env ... Rscript"; $R script.R` failed, "no such file or
   directory", and the background job exited at once). Run multi-word commands under `bash -c`.
5. **Local timings carry the machine's load** (cran plan dragon 3): the load rule and the per-run idle share are the
   guard; compare two figures only within one record.
6. **CRAN rebuilds vignettes inside its check:** nothing in `speed.Rmd` may time anything or read `tools/`.
7. **`savePedigreeDiagram()`'s own 60 s limit** (`options(pedkindraw.saveTimeout = )`) would stop a large save before
   the harness's 120 s; and it starts its own headless Chrome inside the R part, so never two Chrome-starting jobs at
   once (app plan dragons 8, 19).
8. **kinship2 and Pedixplorer functions that never return** (Learning 19): `runLimited()`'s 120 s limit stops them;
   "time" is a result, not a harness failure. Pedixplorer's `find_avail_affected()` and `kindepth(align_parents =
   TRUE)` passed 60 s at 10,000 (section 3.4).
9. **Pedixplorer writes `Rplots.pdf`** into the working folder when no device is open (cran plan dragon 28): the
   study's drawing cases open a device of the canvas size (`withCanvas()`); computation cases that draw nothing do not.
10. **Shared names** (cran plan dragon 27): kinship2, Pedixplorer and pedkindraw all export `kinship()`; each case
    names its package with `::`, and a child loads one package (and Matrix).
11. **Memory near 32 GB depends on the machine's state:** the study's sparse kinship at 30,000 passed 32 GB in Part A
    and finished in the Rewrite record (which waited for half the memory free). Free memory is recorded with every run
    (section 5.4); read a "memory" at 30,000 or 100,000 with it.
12. **The machine notes name the person's programs** (section 3.5 lists a remote-desktop agent): keep `*Machine.txt`
    git-ignored, as nprcgenekeepr does; this is a public repository.
13. **A counterpart is "the same" only when shown** (cran plan dragon 19): three of section 3.4's counterpart calls
    stopped on the probe's inputs; 17h1 checks each pairing's answer before it is timed.
14. **The draft's numbers do not carry over** (R82); only its design. Its `single-runs` table's sources (the plan's
    Done records and the ledger) are gone with it.
15. **A probe is not a result** (Learning 18): section 3.4's figures are single calls under a 60 s limit, loaded from
    source; none goes on the page.
16. **The sample file writes an unknown parent as `NA`** (S79): read with `na.strings = ""` alone, every sire is the
    text `"NA"` and every function sees a parent without a row. `savePedigrees.R` reads it with R's default and writes
    the comparison CSV, whose unknown parents are empty cells.
17. **`x[[name]] <- NULL` removes the element** (S79): a case value of `NULL` (Pedixplorer's `descendants()` with no
    descendants) vanished from a list built that way; `x[name] <- list(value)` keeps it (`helper-caseValues.R`).
18. **kinship2 chooses among ties at random** (S79): `findAvailAffected()` chose S002886 in one run at 3,000 and S002669
    in the next, with the same bit size; `pedigree.shrink()` and `pedigree.unrelated()` too (the study: 5 kept sets over
    5 seeds). `timeOne.R` sets seed 1 before each call, and the tests compare counts and bit sizes, not ids.
19. **`summarizeTiming.R` names its largest size in words** (copied): a capacity row with no failure reads "none up to
    100,000", true of a record over the six sizes and not of a trial at one.
20. **The test folder takes about 3 minutes** and starts R children: run it alone, as the suite (app plan dragons 8,
    19), and never beside a record.
21. **A scratch run of tests outside the root has no renv** (S80): run from `tools/timing/tests`, `kinship2` was not on
    the library path, and testthat's edition 3 turns a missing package into a skip, so a check of 18 drafted tests
    read "0 failed" while one test's version comparisons were skipped. Run checks from the root and read SKIP.
22. **The record's build check** (R155): `runTiming.R` stops before its first run when `R/`, `DESCRIPTION` or
    `NAMESPACE` has uncommitted changes or `PKD_LIB`'s pedkindraw was packaged before their last commit. Rebuild
    `PKD_LIB` after any commit that changes them; a commit elsewhere (docs, `tools/`) needs none.
23. **`timingRuns.csv`'s `pkdLib` is the scratch library's full path** (copied, S79): the record is committed (17h2),
    and a library in a session's scratchpad puts the home folder's name and a session id in a public file. Build
    `PKD_LIB` at a short path that names no person.
24. **`timingRuns.csv`'s `started` was when the run ended** (copied, found S80; fixed S81, R156): the copy made the
    row, and its time, after `runLimited()` returned (in S80's trial the last run's `started` equalled the end note's
    12:01:13). Since 17h1c it is the time `runLimited()` launched the child, so `started` plus `realSeconds` is the
    run's end; nprcgenekeepr's `runOnce()` still writes the end (at `3e06730c5`, R8). `record.csv`'s `started` is the
    record's start.
25. **Other work on this Mac holds the record back** (S81): at 12:35 on 2026-11-23 the Mac was 0% idle, load average
    43 (a virtual machine, vitest workers and Playwright's headless Chrome, none of them this project's), and
    `runTiming.R` waits up to 10 minutes before each run while less than half the CPU is idle (a trial of 8 runs was
    stopped after 5 minutes with none run); at 12:48, 50-74% idle, the same 8 runs took 9 minutes. Before 17h2 read
    `top -l 2 -n 0 -s 1` and `ps -Ao pcpu,etime,comm -r`, and ask Mark about any such work still running.
26. **On this Mac as it is used, a record takes about three times its process time** (S82): 17h2's record took 7.6 h,
    2.4 h of it in runs (section 3.7 guessed 2.7 h of process time and 3.5-4 h in all); about 48 min were the idle
    check's own gaps (about 1.9 s a run) and about 4.4 h waits for half the CPU idle, 283 of them, one the full 10
    minutes. The load average was low (median 7.9) but vitest workers (up to three at about 95% each, all evening) and
    macOS's photo analysis kept the idle share at the 50% line. 17h4's 1.2-1.5 h guess becomes about 3.5-4.5 h unless
    that work stops; the times themselves are sound (each run started at half idle or after the full wait, its row
    says).
27. **kinship2's `findAvailNonInform()` stops at 1,000** (S82): "argument is of length zero" in its own `if
    (avail[pedData$id == fa] & avail[pedData$id == mo])`, on the case's input as R154 prepares it; it returns at 300
    (0.005 s), the only size S79 checked. The cause was not looked for (nothing may run beside a record); 17i's page
    says kinship2 stops there, and a session that wants the cause reproduces it at 1,000 first (Learning 19).
28. **`runTiming.R` rewrites `timing.csv` and `timingRuns.csv` from its own rows** (copied): a re-run into `results/`
    replaces the record. S82's re-runs went to `--out=<scratch>`; a 17h2b as section 6 wrote it would need its own
    `--out` and a join. `runDrawingTiming.R` does the same unless given `--append` (copied), which keeps the other
    cases' rows: a 17h4 re-run of some cases uses `--append`, or `--out=<scratch>`.
29. **`pkd_data` times `makePedigreeDiagramData()` alone** (S83): 0.001 s at 300 and on the sample (0.9 ms a call,
    checked outside the harness), where the page's R part is 1.1-1.9 s: the layout, not the diagram data, is the cost.
    17i's page says what each drawing row times, so the 1 ms is not read as the drawing's time.
30. **Pedixplorer's plotly page takes about 30 s in R at 300** (S83: 29.3 s unaligned at 300, 31.6 and 35.3 s on the
    sample; the study's 29.0 and 34.0), so it is near the 120 s limit at 1,000 (the study: "time" at 1,000) and its four
    runs per size are the trial's longest. The drawing tests draw it too: the two drawing test files took 229 s in
    the draft run, so the folder takes about 7 minutes where it took 3 (an estimate from the two runs).
31. **`summarizeDrawingTiming.R`'s capacity table says "none up to 3,000"** (copied) of a case with no failure, true
    of a record over the four sizes and not of a trial at 300 (as dragon 19 for the computation summary).
32. **Chrome's websocket prints "got non-close frame while closing"** as a session closes (S83: in the tests and the
    trial, a line on the console, not a test warning or a failed run): harmless; read WARN and each run's status.
33. **`pkd_svg` and `pkd_png` were not timed at 3,000** (S84, R158): the drawing they save is built before the clock
    (`pedkindrawSave()`'s `prepare`, the rectilinear layout), and `runLimited()` allows 300 s for loading and setup
    before "CALL START" (`tools/timing/timingHarness.R:287`). At 2,000 that build took about 150 s (156 s a run, 6 s of
    it the save); at 3,000 it took more than 300, so the record reads `error`, "no 'CALL START' within 300 s", and
    `summarizeDrawingTiming.R` prints "refused". The save itself did not fail: 17i prints these two as not timed (the
    drawing before the save took over 300 s), never "refused". `pkd_pdf` reached its save at 2,000 and ran out of time
    in it (its warm-up 271.9 s in all), a time of the save.
34. **A save's three runs can differ by one slow run** (S84): of 26 cells of 0.5 s or more, the 3 over 10% are all
    `savePedigreeDiagram()` saves with one slow run (`pkd_svg` at 1,000: 4.75 against 2.35 and 2.33 s, 103%; `pkd_png`
    at 2,000: 12.4 against 9.41 and 9.66, 31%; `pkd_pdf` at 1,000: 6.48 against 5.41 and 4.97, 28%); every page and
    picture cell is within 8%. The re-run of `pkd_svg` at 1,000 had one slow run again (5.78 against 2.39 and 2.31) and
    a median within 1.7%. Cause not known (a guess: the Chrome `savePedigreeDiagram()` starts for each call). The
    median of 3 holds against one slow run; 17i's page quotes medians and says this.
35. **The drawing record took 1 h 36 min** (S84), not the 3.5-4.5 h dragon 26 guessed: every drawing case but
    `pkd_data` stopped at 3,000 or before. Its longest runs were the saves at 2,000 (about 156 s each, dragon 33).

---

## 9. Out of scope

- Any change to nprcgenekeepr (R8).
- Speeding any function up: `findPedigreeNumber()` (backlog `:294`) and `findGeneration(alignMates = TRUE)` (S78's
  close-out adds it) are backlog items; the runs measure them as they are.
- BGmisc and ggpedigree (not in renv; R82 names kinship2 and Pedixplorer).
- `runPedigreeApp()` (R153); another machine, browser or operating system.
- Changing `vignettes/drawing.Rmd`'s S75 times (section 4.3: they stay, with a pointer).

## 10. Sources

- pedkindraw: `docs/planning/cran-submission-plan.md` (sections 2.1, 4.4, 5, 6 rows 17g-17i, 9), 
  `docs/planning/standalone-pedigree-package-plan.md` (Phase 1 step 4, `:446`; R77, R79, R80, R82, R84; section 6),
  `docs/planning/pedkindraw-api-contract.md` (sections 4.4, 4.5, 7, 8), `docs/planning/pedigree-app-plan.md` (section
  12.1, dragons 8 and 19), `docs/research/pedigree-package-comparison-2026-11.md` (sections 7 and 9),
  `docs/planning/pedigree-app-prototype/g17bSize.R`, `methodology/BACKLOG.md` (`:36`, `:227`, `:294`), the branch
  `draft/speed-vignette` (`612eed9`), `CLAUDE.md` (Learnings 5, 10, 17, 18, 19).
- nprcgenekeepr at `3e06730c5`: `tools/pedigreeComparison/` (the files of section 3.1, its `results/`), `tools/perf/
  harness.R`, `tests/testthat/test_perfHarness.R`, `.gitignore:116`-`:122`.
- Measured this session: section 3, by the scripts of section 3.6.
