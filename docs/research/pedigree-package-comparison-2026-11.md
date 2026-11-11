# Pedigree package comparison (2026-11): Part A, computation; Part B, drawing

> **Copied into pedkindraw (pedkindraw S5, 2026-11-11).** Copied unchanged from nprcgenekeepr's
> `docs/research/pedigree-package-comparison-2026-11.md` at nprcgenekeepr commit `3d262d628`,
> by step H1 of `docs/planning/planning-handover-plan.md`.
> It is a dated record: it is not edited, in pedkindraw or in nprcgenekeepr.
> **Paths in this file name nprcgenekeepr's files** (`R/`, `tests/`, `BACKLOG.md`, `methodology/`,
> `tools/pedigreeComparison/` and so on), except these five, copied into pedkindraw at the same paths:
> `docs/planning/standalone-pedigree-package-plan.md`, `docs/planning/pedkindraw-api-contract.md`,
> `docs/research/pedigree-package-comparison-2026-11.md`,
> `docs/research/kinship2-feature-gap-analysis-2026-09-20.md` and
> `docs/research/pedigree-diagram-package-split-scoping-2026-09-02.md`.
> A line number cited in one of these five is its line in nprcgenekeepr; in pedkindraw's copy, every line below
> the title sits lower by the length of that copy's note (this one adds 13 lines, counting the blank line above).

**Date:** 2026-11-02 to 2026-11-03 · **Sessions:** S1122 (sections 1-6), S1123 (section 7, findings 11-17), S1124
(section 8, findings 18-24), S1125 (sections 9-10, findings 25-29), S1126 (section 11, findings 30-35) · **Plan:**
`docs/planning/standalone-pedigree-package-plan.md`, Phases 1-3 (rulings R4-R7).
**Status:** done. Part A: the function table, input checks and agreement checks (S1122) and timing, memory and
capacity (S1123). Part B (drawing, Phase 2): the pictures, the feature table and the line checks (S1124, section
8); drawing time, memory, capacity and readability (S1125, section 9); the closing answer (section 10). Phase 3:
the four input-style prototypes and Mark's ruling R7 (S1126, section 11).

**Surface:** this Mac only: Apple M2 Max, 12 cores, 96 GiB, R 4.6.2. Sections 3-6 are about results, not speed,
so they do not depend on the machine; their few seconds are single runs, for orientation only. Section 7's
seconds and memory are this Mac's, taken while macOS's own background work kept the load average at 3-35 with
at least half the CPU idle (section 7); they cannot show another machine's speed or a smaller machine's limits.

**Versions** (`comparisonVersions()` in `tools/pedigreeComparison/setupComparison.R`):

| Package | Version | Source |
|---|---|---|
| nprcgenekeepr | 3.0.0.9000, commit `8ea447dfd` (sections 3-6); `70e0492eb` (section 7, `R/` identical) | this repository: `pkgload::load_all()`; for section 7 installed into a scratch library |
| kinship2 | 1.9.6.2 | CRAN |
| Pedixplorer | 1.8.0 | Bioconductor 3.23 |
| ggpedigree | 1.2.0 | CRAN |
| BGmisc | 1.6.0.1 | CRAN (installed with ggpedigree, its computation companion) |

The comparators were installed into a scratch library, not renv or the personal library
(`tools/pedigreeComparison/installComparators.R`; afterward the personal library still held the same 2
packages and nothing in R's own library was newer than the install).

---

## 1. Findings

1. **Autosomal kinship: kinship2, Pedixplorer and nprcgenekeepr agree exactly** (largest difference 0) on all
   seven pedigrees checked, 7 to 10,000 animals, and all three match a hand-computed case.
2. **BGmisc's `ped2add()` gets some self-kinship values wrong.** In the hand case, X has an inbred sire and an
   unrelated dam, so X is not inbred: K(X,X) is 0.5. BGmisc gives 0.53125, while its K(C,C) and K(X,Y) are
   right. On the real and synthetic pedigrees it differs from the other three by up to 0.0977
   (`synthetic_1000`); on `rhesus375`, 107 of 140,625 cells differ, 33 of them diagonal. It agrees on the three
   small pedigrees. Measured with `ped2add()`'s default arguments (`max_gen = 25`) except `sparse = FALSE`;
   why it differs was not diagnosed.
3. **BGmisc returns wrong numbers without an error** for a cycle, an animal that is its own parent, a parent
   with no row, and `"0"` or `""` as the missing-parent code (section 4). Its `checkIDs()`,
   `checkParentIDs()` and `checkPedigreeNetwork()` do flag these, but only when called separately.
4. **X-chromosome kinship: kinship2, Pedixplorer and nprcgenekeepr agree exactly**, including which cells are
   unknown (an animal of unknown sex: 33 cells in `lacy1989Ped`, 671,265 in `examplePedigree`). kinship2 and
   Pedixplorer refuse an animal with one known parent here ("subscript out of bounds"), though they accept it
   for autosomal kinship; with a placeholder parent added they agree. BGmisc has no X-chromosome export.
5. **Generation depth and families agree everywhere**: all four packages, all nine pedigrees, up to 100,000
   animals. BGmisc's `ped2gen()` counts founders as generation 1, not 0; compared after subtracting 1.
6. **MZ twins:** K(MZ pair) = 0.5 in every package that accepts the twins. Pedixplorer refuses the whole twins
   file because one UZ pair are founders (no recorded parents); without that pair it agrees exactly.
7. **Shrinking differs, for two reasons.** kinship2 breaks ties at random (2 different kept sets over seeds 1-5
   on `sample.ped` family 1; 5 different sets over 5 seeds on `rhesus375`). nprcgenekeepr breaks them
   deterministically, and its set is one of kinship2's on family 1 and identical on family 2. Pedixplorer
   reproduces kinship2's seed-1 result on family 1, but on family 2 it keeps two available animals (203, 211)
   that kinship2 and nprcgenekeepr remove as uninformative (11 kept against 9), so its rule for available but
   uninformative animals differs from kinship2's.
8. **Unrelated sets:** kinship2's and Pedixplorer's are valid on all three pedigrees (mutually unrelated,
   maximal, all available) and the same size on every seed. nprcgenekeepr's copy set has no such function
   (`groupAddAssign()` stays here, R9).
9. **Input checks:** nprcgenekeepr's computation functions check almost nothing; a bad pedigree gives a raw R
   error ("NAs are not allowed in subscripted assignments") or an NA generation with a warning.
   `qcStudbook()`, which stays here (R9), reports each problem by name. Pedixplorer silently changes the sex
   of a parent coded with the wrong sex, and refuses most bad input by returning a data frame of problems
   with a warning rather than stopping. kinship2's `pedigree()` is strict; its vector `kinship()` is lenient.
   This sizes R9's "short pedigree checker": section 4 is its list of cases.
10. **Loading ggpedigree replaces four of kinship2's S3 methods** (`[.pedigree`, `[.pedigreeList`,
    `print.pedigree`, `print.pedigreeList`; R's own load message). Its `pedigree()` is its own copy of
    kinship2's, with one more argument (`max_message_n`).
11. **Dense kinship: nprcgenekeepr is as fast as kinship2 and needs the least memory** (section 7). At 30,000
    animals nprcgenekeepr takes 29.2 s with a process peak of 12.96 GiB, kinship2 30.5 s and 19.49 GiB, BGmisc
    19.0 s and 17.36 GiB; Pedixplorer stops at 10,000 (5.09 s and 5.47 GiB, against 2.90 s and 1.71 GiB for
    nprcgenekeepr there). X-chromosome kinship gives the same picture. None reaches 100,000 animals, where one
    dense matrix alone is 74.5 GiB.
12. **The sparse options do not raise capacity.** nprcgenekeepr's `kinship(sparse = TRUE)` fills a dense matrix
    and then converts it (`sparseKinship()`, `R/kinship.R:286`), so at 10,000 animals it peaks at 5.77 GiB
    against 1.71 GiB for the dense call, and stops there. kinship2's `makekinship()` (blocks by family) stops at
    10,000 too; the colony is one large family plus families of one (section 5.2), so blocks save little.
    BGmisc's sparse `ped2add()` reaches 30,000 (10.65 GiB).
13. **BGmisc's `ped2add()` crashes R at 100,000 animals**, dense and sparse alike: a segfault (sparse) or a bus
    error (dense) inside Matrix 1.7.6's sparse product (`R_sparse_matmult`). That ends the R process, so a
    script cannot catch it. The cause was not diagnosed.
14. **Shrinking is the limit in all three packages, and nprcgenekeepr's is the fastest**: at 300 animals 0.70 s
    against kinship2's 2.56 s and Pedixplorer's 89.4 s; at 1,000 animals 21.0 s against 101 s (Pedixplorer over
    the 120 s limit); at 3,000 all three run past 120 s.
15. **Depth, families, ancestors, descendants and building a pedigree object reach 100,000 animals in every
    package that has them**, all but two in under a second. nprcgenekeepr's `findPedigreeNumber()` takes about 9
    times as long for 3 times the animals, close to the square (0.15 s at 10,000, 1.35 s at 30,000, 12.9 s at
    100,000, against 0.30-0.66 s for the other three at 100,000); Pedixplorer's `Pedigree()` takes 8.1 s at
    100,000 against 0.019 s for kinship2's `pedigree()`.
16. **Unrelated sets** reach 10,000 animals in both packages (kinship2 6.5 s, Pedixplorer 15.4 s) and run out of
    memory at 30,000.
17. **Pedixplorer's `shrink()` refuses when an animal marked available has unknown sex** ("Invalid values for
    'sex'"); an unavailable animal of unknown sex is fine (section 4).

Part B (drawing, section 8; every drawn line read back and compared with the pedigree):

18. **nprcgenekeepr's drawings show every animal's true parents**, on all five pedigrees: no drawn child lacks a
    true parent. On rhesus375 (251 animals with parents) 248 are exact and 3 reach their true parents plus two more
    animals, where one sire's lines to two mates leave his symbol along the same short stretch (section 8.3).
19. **kinship2, Pedixplorer and ggpedigree draw a sire with three mates so that one child reads as the offspring of
    the wrong pair.** In smallPed, A's marriage line to N runs through J, and the drop to M meets it between J and
    N; all three draw it so (ggpedigree uses kinship2's layout). On rhesus375 the same thing makes 19 of
    kinship2's and 30 of Pedixplorer's children read wrong; each was checked: a third animal sits on the true
    parents' row between them.
20. **ggpedigree 1.2.0 draws 177 extra lines from one founder** (NPYENA, drawn twice) across the whole rhesus375
    drawing, from its spouse layer; 124 of its 133 wrong readings come from them. NPYENA is an ordinary founder
    (two mates, two offspring); the cause was not diagnosed.
21. **Pedixplorer leaves 18 of rhesus375's 375 animals out of its drawing** ("won't be plotted"), so 9 animals are
    not drawn and 16 children have no line to a parent. Its `Pedigree()` refuses any id containing "_", and its
    alignment refuses the made-up feature pedigree ("You found a bug in kindepth's alignment code!") unless
    `force = TRUE`, which then warns.
22. **Only nprcgenekeepr draws a hermaphrodite symbol**; kinship2 and Pedixplorer draw H as unknown, and
    ggpedigree drew no symbol at all for an animal of unknown sex (U1, H1 in the feature pedigree).
23. **ggpedigree has no deceased mark and no consanguinity mark**, and did not mark the DZ pair; kinship2 and
    Pedixplorer draw the slash, twin lines and double marriage line; nprcgenekeepr draws them its own way
    (slash, labelled MZ and DZ lines, a thick vermillion marriage line) and is the only one with a legend by
    default (section 8.1).
24. **Pedixplorer's default prints each condition's value as text ("TRUE", "FALSE") over every symbol** (`aff_mark
    = TRUE`); its Shiny app has size limits in its arguments (`ped_shiny(ind_max_warning = 300, ind_max_error =
    500)`; read, not run), as nprcgenekeepr's Diagram tab stops at 750.

Part B, drawing time, memory, capacity and readability (section 9; Mark's rulings S1125):

25. **No package draws 2,000 animals within 120 s; the best reach 1,000.** kinship2's picture, ggpedigree's
    picture and plotly page, nprcgenekeepr's page and Pedixplorer's picture with its parent alignment off all draw
    1,000 and all go past 120 s at 2,000, in the R part alone. At its defaults Pedixplorer draws none of the
    synthetic colonies: its parent alignment refuses every one from 300 animals on ("subscript out of bounds"),
    picture and plotly page alike, with `force = TRUE` too. With `align_parents = FALSE`, which its own warning
    suggests, its picture draws 1,000 in 16.0 s and its plotly page 300 in 29.3 s (past 120 s at 1,000).
26. **The time is the layout in R; the browser takes under a second.** At 1,000 animals nprcgenekeepr's page takes
    16.3 s (15.5 in R, 0.84 in Chrome) against 12.9 s for kinship2's picture and 15.0 and 14.9 s for ggpedigree's
    picture and plotly page (14.0 in R, 0.93 in Chrome). nprcgenekeepr was drawn without the Diagram tab's cap.
27. **Pedixplorer's plotly page is the slowest drawing**: 34.4 s for rhesus375 (34.0 in R; 34.9 with alignment off),
    against 1.49 to 3.68 s for every other drawing of it, and 29.3 s at 300 animals against 1.14 to 1.27 s for the
    other two pages.
28. **Mark judged only nprcgenekeepr's drawing readable** (an animal can be found by its id and its lines followed
    to its parents): up to 1,000 animals once zoomed in, the largest size any package drew. kinship2 and ggpedigree
    were readable at none of the sizes, 300 animals included, and Pedixplorer at none, with its alignment on
    (rhesus375, its only drawing then) or off (300, rhesus375, 1,000). nprcgenekeepr's fitted view of those
    pedigrees shows no ids (section 8.1).
29. **Memory: nprcgenekeepr needs more in R than kinship2 and ggpedigree, and less in the browser.** At 1,000 animals
    its R process peaks at 0.95 GiB against 0.53 (kinship2), 0.64-0.67 (ggpedigree) and 1.05 (Pedixplorer's picture,
    alignment off); in Chrome its page held 26.5-43.1 MiB of JavaScript heap against 70.8-72.4 for ggpedigree's
    plotly page.

Phase 3, input style (section 11; Mark's ruling S1126):

30. **Only data frames take every case of the test pedigree as it is.** kinship2's `pedigree()` and Pedixplorer's
    `Pedigree()` refuse P1, which has a sire and no dam, until the user adds a made-up dam (both packages' own
    fix-parents functions name it `addin-1`); it is then drawn as an extra animal, A's second mate. Both turn the
    hermaphrodite H1 into an animal of unknown sex, drawn as a triangle, not a star.
31. **kinship2's object keeps no column beyond id, parents, sex, conditions, deceased and twins**, so the names
    (Ace, Tia, Hal) are lost; Pedixplorer's keeps them.
32. **Pedixplorer refuses two more cases**: an id with "_" (the user renames it; Q_1 is drawn as Q.1) and a twin pair
    whose parents are unknown (rhesus375's UZ pair: a raw "missing value where TRUE/FALSE needed" from its own
    check; its MZ and DZ pairs build). kinship2 and data frames take both.
33. **Converted back, the same pedigree draws the same.** rhesus375 with its twins file, through a kinship2 object, a
    Pedixplorer object (less the refused pair) or the converters, gives the same nodes (position, symbol, hover
    text) and edges as data frames; kinship is equal everywhere (largest difference 0), on the test pedigree too.
34. **Cost** (these prototypes; data frames / kinship2 / Pedixplorer / data frames plus converters): converter code
    0 / 35 / 28 / 69 lines; the user's script from the two CSV files 5 / 12 / 14 / 5 lines; packages every user
    installs 0 / 1 / 49 (3 only on Bioconductor) / 0. Each of the two converters had a defect that only the
    comparison with data frames found.
35. **Mark's ruling R7: data frames, plus converters from kinship2 and Pedixplorer objects**, those two packages
    optional (Suggests).

---

## 2. Method and files

All under `tools/pedigreeComparison/` (build-ignored, `.Rbuildignore:57`). Run from the project root with
`CMP_LIB` naming the scratch library: `CMP_LIB=<scratch>/rlib Rscript tools/pedigreeComparison/<script>.R`. The
timing scripts also need `NPG_LIB`, a scratch library holding nprcgenekeepr installed from a `git archive HEAD`
copy with `R CMD INSTALL --no-docs --library=<scratch>/nlib`, so that it is byte-compiled like the comparators.

| File | What it does | Tested |
|---|---|---|
| `installComparators.R` | installs the four comparators into `CMP_LIB`; stops unless `CMP_LIB` is first on the library path and neither renv nor the personal library is on it | -- |
| `setupComparison.R` | loads nprcgenekeepr and finds the comparators after renv's library | -- |
| `comparisonFormats.R` | reads and writes the comparison CSV; converts it to kinship2's, Pedixplorer's and BGmisc's coding; adds placeholder parents; derives sex | `tests/test_comparisonFormats.R`, 18 tests |
| `generateColonyPedigree.R` | the seeded synthetic colony | `tests/test_generateColonyPedigree.R`, 18 tests |
| `probeInputs.R` | section 4 | -- |
| `savePedigrees.R` | writes the test pedigrees, `results/pedigreeFiles.csv` | -- |
| `runAgreement.R` | section 5, `results/agreement.csv` | -- |
| `timingHarness.R` | reads `/usr/bin/time -l`'s report, the child's TIMING line and `uptime`; the median of 3 runs; capacity; `runLimited()`, one child run stopped past 120 s from the call's start or past 32 GB | `tests/test_timingHarness.R`, 23 tests |
| `timingCases.R` | the 29 timed calls, one per computation and package, each naming only its own package | the same file |
| `timeOne.R` | one measurement in a fresh process | the same file (2 end-to-end tests) |
| `runTiming.R` | section 7's runs: `results/timingRuns.csv` (every run), `results/timing.csv` (one row per case and size) | -- |
| `summarizeTiming.R` | prints section 7's two tables from those files | -- |
| `drawingTrace.R` | section 8's line reader (`drawnParentLinks()`), the comparison with the pedigree (`compareDrawnLinks()`) and the made-up feature pedigree (`featurePedigree()`) | `tests/test_drawingTrace.R`, 37 tests |
| `drawingCapture.R` | draws one pedigree with one package and hands back what it drew: `drawKinship2()`, `drawPedixplorer()`, `drawGgpedigree()`, `drawNprcgenekeepr()` | `tests/test_drawingCapture.R`, 25 tests (skip without `CMP_LIB`) |
| `runDrawing.R` | section 8's pictures and line checks: `results/drawingLinks.csv`, `results/drawingSummary.csv` | -- |

The tests live beside the scripts, not in the package suite (Mark's ruling, S1122):
`Rscript -e 'testthat::test_file("tools/pedigreeComparison/tests/test_generateColonyPedigree.R")'` and the same
for `test_comparisonFormats.R` and `test_timingHarness.R` (3 of its 23 tests need `CMP_LIB` and `NPG_LIB` and skip
without them).

### 2.1 Test pedigrees

One CSV each under `data/`: id, sire, dam, sex (M, F, U or H), optional birth; empty cell = unknown parent.
The five real pedigrees are committed; the synthetic ones are rebuilt by `savePedigrees.R` and ignored by git
(Mark's ruling, S1122); 300 and 3,000 were added for timing (Mark's ruling, S1123). md5 from
`results/pedigreeFiles.csv`.

| File | Animals | md5 | Source |
|---|---:|---|---|
| `samplePed.csv` | 55 | `0a0d87d1` | kinship2 `sample.ped` (2 families; affected, avail) |
| `smallPed.csv` | 17 | `2e754b21` | nprcgenekeepr `smallPed` (1 animal with one known parent) |
| `lacy1989Ped.csv` | 7 | `e780e67a` | nprcgenekeepr `lacy1989Ped`; no sex column, so sires M, dams F, the rest U |
| `rhesus375.csv` | 375 | `d045f56b` | `inst/extdata/examples/obfuscated_rhesus_mhc_ped.csv` |
| `rhesus375_twinRelations.csv` | 3 pairs | `d07d76f2` | the same pedigree's twin file: 1 MZ, 1 DZ, 1 UZ pair |
| `examplePedigree.csv` | 3,694 | `e7454c6c` | nprcgenekeepr `examplePedigree` (125 of unknown sex) |
| `synthetic_300.csv` | 300 | `60816f40` | `generateColonyPedigree(300, seed = 1)` |
| `synthetic_1000.csv` | 1,000 | `cc654ad1` | `generateColonyPedigree(1000, seed = 1)` |
| `synthetic_3000.csv` | 3,000 | `8c00af86` | seed 1 |
| `synthetic_10000.csv` | 10,000 | `1799ecd0` | seed 1 |
| `synthetic_30000.csv` | 30,000 | `36944e72` | seed 1 |
| `synthetic_100000.csv` | 100,000 | `b1d45f93` | seed 1 (the six synthetic files total 5.3 MB) |

### 2.2 The synthetic colony

`generateColonyPedigree(n, seed, importRate = 0.02)` simulates a colony a year at a time. Founders of
breeding age start it; females join the breeding pool at 4 and males at 5 if there is room under caps that
grow with n (the rest never breed); each pool female gives birth with probability 0.7, to a sire drawn by an
uneven per-male weight; imports with unknown parents arrive at `importRate` of each year's births; births
fall in a 90-day season. Every animal has both parents or neither, so all four packages accept it. Measured
with seed 1:

| Animals | Build time | Female | Unknown parents | Offspring per sire | Offspring per dam | Deepest generation | Most generations born in one year |
|---:|---:|---:|---:|---:|---:|---:|---:|
| 1,000 | 0.05 s | 51% | 4.3% | 50 | 6.3 | 7 | 5 |
| 10,000 | 0.07 s | 50% | 3.8% | 42 | 6.7 | 8 | 7 |
| 30,000 | 0.20 s | 50% | 4.0% | 43 | 6.7 | 8 | 8 |
| 100,000 | 0.68 s | 50% | 3.8% | 42 | 6.6 | 8 | 8 |

The 300- and 3,000-animal colonies (S1123) come from the same generator and seed; their rows of this table
were not measured.

BGmisc has a pedigree simulator too (`simulatePedigree()`), but it models human families (couples, discrete
generations), not a colony with a few sires and overlapping generations.

---

## 3. Function table

One row per computation; arguments as `formals()` reports them (Pedixplorer's S4 methods read through
their internal `.local` functions). ggpedigree's only computations are drawing helpers, so its column is
merged with BGmisc's, which it uses for its pedigree work. Layout rows are listed for completeness;
comparing layouts is Phase 2.

| Computation | kinship2 1.9.6.2 | Pedixplorer 1.8.0 | ggpedigree 1.2.0 / BGmisc 1.6.0.1 | nprcgenekeepr copy set |
|---|---|---|---|---|
| Build a pedigree object | `pedigree(id, dadid, momid, sex, affected, status, relation, famid, missid)`, S3 `pedigree` / `pedigreeList` | `Pedigree(obj, dadid, momid, sex, famid, fertility, miscarriage, deceased, avail, evaluated, consultand, proband, affections, carrier, asymptomatic, adopted, dateofbirth, dateofdeath, rel_df, missid = c(NA, "0"), col_aff, normalize = TRUE, ...)`, S4 `Pedigree` (`ped`, `rel`, `scales`, `hints`); also `Ped()`, `Rel()`, `norm_ped()`, `norm_rel()` | ggpedigree `pedigree()` (kinship2's, plus `max_message_n`); BGmisc uses plain data frames (`ID`, `momID`, `dadID`, `sex`) | none: plain data frames (`id`, `sire`, `dam`, `sex`) |
| Check a pedigree | inside `pedigree()` | inside `Pedigree()` (`normalize`); `is_disconnected(id, dadid, momid)` | BGmisc `checkIDs(ped, verbose, repair)`, `checkParentIDs(ped, ..., repair, repairsex, addphantoms, ...)`, `checkSex()`, `checkPedigreeNetwork()`, `repairIDs()`, `repairSex()`, `recodeSex()` | none; `qcStudbook()` stays here (R9) |
| Repair parentage | `fixParents(id, dadid, momid, sex, missid)` | `fix_parents(obj, dadid, momid, sex, famid, missid)`; data-frame method `(obj, del_parents, filter, missid)` | BGmisc `checkParentIDs(repair = TRUE, addphantoms = TRUE)`, `addPersonToPed()` | `addParents(ped)`, `addBackSecondParents(uPed, ped)`, `correctParentSex(id, sire, dam, sex, recordStatus, reportErrors)`, `getIdsWithOneParent(uPed)` |
| Generation depth | `kindepth(id, dad.id, mom.id, align)`, founders 0 | `kindepth(obj, dadid, momid, align_parents, force)`, founders 0 | BGmisc `ped2gen(ped, max_gen, ...)`, founders 1 | `findGeneration(id, sire, dam)`, founders 0 |
| Family (connected component) | `makefamid(id, father.id, mother.id)` (an unconnected animal gets 0); `familycheck(famid, id, father.id, mother.id, newfam)` | `make_famid(obj, dadid, momid)` (unconnected: NA); `get_famid()`, `upd_famid()`, `family_check()` | BGmisc `ped2fam(ped, personID, momID, dadID, famID, twinID)` (warns that character ids "became NA"; give it numbers), `ped2graph()` | `findPedigreeNumber(id, sire, dam)` |
| Kinship, autosomal | `kinship(id, dadid, momid, sex, chrtype = "autosome")` and pedigree / pedigreeList methods; `makekinship(famid, id, father.id, mother.id, unrelated)` (block-sparse by family) | `kinship(obj, dadid, momid, sex, chrtype = "autosome")` and `Ped` / `Pedigree` methods | BGmisc `ped2add(ped, max_gen = 25, sparse = TRUE, ..., mz_twins, mz_method)`: the additive relationship, twice kinship, sparse by default; also `ped2mit()`, `ped2cn()`, `ped2ce()`, `ped2com()`. ggpedigree `ggRelatednessMatrix()` draws a matrix, computes none | `kinship(id, father.id, mother.id, pdepth, sparse = FALSE, twinRelations, chrtype = "autosome", sex)`; `pdepth` from `findGeneration()` |
| Kinship, X chromosome | `chrtype = "X"`, needs sex | `chrtype = "X"`, needs sex | none | `chrtype = "x"`, `sex` |
| Twins | `pedigree(relation = )`: id1, id2, code 1 MZ, 2 DZ, 3 UZ, 4 spouse | `Rel` / `rel_df`: id1, id2, code "MZ twin", "DZ twin", "UZ twin", "Spouse" | BGmisc `twinID` and `zygosity` columns, `ped2add(mz_twins = TRUE)`, `makeTwins()` | `readTwinRelations(fileName, sep)`, `checkTwinRelations(ped, twinRelations)`, `kinship(twinRelations = )` |
| Shrink to a bit-size budget | `pedigree.shrink(ped, avail, affected, maxBits)`, `bitSize(ped)`, `findAvailAffected()`, `findAvailNonInform()`, `findUnavailable()` | `shrink(obj, avail, affected, max_bits = 16)`, `bit_size()`, `find_avail_affected()`, `find_avail_noninform()`, `find_unavailable()` | none | `shrinkPedigree(ped, genotyped, affected, maxBits = 16L)`; its helpers are internal (`R/shrinkPedigree.R:203-339`; R3 exports them) |
| Trim | `pedigree.trim(removeID, ped)` (remove listed animals) | `subset()`, `useful_inds(obj, keep_infos, reset, max_dist)`, `is_informative(obj, col_aff, informative = "AvAf")`, `min_dist_inf()` | none | `trimPedigree(probands, ped, removeUninformative, addBackParents)`, `getProbandPedigree(probands, ped)`, `getDescendantPedigree(probands, ped)`, `removeUnknownAnimals(ped)`, `removeUninformativeFounders(ped)` |
| Unrelated set | `pedigree.unrelated(ped, avail)` | `unrelated(obj, avail)` | none | none; `groupAddAssign()` stays here (R9) |
| IBD matrix from outside estimates | `ibdMatrix(id1, id2, x, idmap, diagonal)` | `ibd_matrix(id1, id2, ibd, idmap, diagonal)` | none | none |
| Relatives and lookups | none exported | `ancestors(idx, momx, dadx)` (row numbers), `descendants(idlist, obj, ...)`, `parent_of()`, `num_child()`, `is_founder(momid, dadid, missid)`, `is_parent()`, `spouse()` | ggpedigree `countOffspring()`, `countSiblings()`, `generateSpouseList()`; BGmisc `ped2maternal()`, `ped2paternal()`, `summarizePedigrees()` | `getParents(pedSourceDf, ids)`, `getOffspring(pedSourceDf, ids)`, `getFounders(ped)`, `isFounder(ped)`, `hasBothParents(id, ped)`, `addIdRecords(ids, fullPed, partialPed)`, `toCharacter(df, headers)` |
| Read files | none | `plink_to_pedigree(path, sep, quote, header, na_values)` | BGmisc `readGedcom()`, `readWikifamilytree()` | `readTwinRelations()` (with a `readxl` / `stringi` chain) |
| Simulate a pedigree | none | none | BGmisc `simulatePedigree(kpc, Ngen, sexR, marR, ...)` | none (section 2.2's generator is a tool here, not package code) |
| Layout (Phase 2) | `align.pedigree(ped, packed, width, align, hints)`, `autohint()` | `align(obj, packed, width, align, hints, ...)`, `auto_hint()`, `best_hint()`, `compute_stress()` | ggpedigree `calculateCoordinates()`, `calculateConnections()` | `makePedigreeMatingLayout(ped, edgeStyle, twinRelations, kinshipMatrix)`, `makePedigreeDiagramData(ped, twinRelations)`, `drawPedigreeDiagram(layout, edgeStyle, onClick)` |

Exports outside these rows: of Pedixplorer's 247 exported names, 140 are functions (the rest are S4 class
and method-table objects; it defines 103 S4 generics and 11 classes). Of those functions, 60 are slot
accessors (30 getter-setter pairs such as `affected()` and `affected<-`); the rest outside the table are colour and fill
helpers (`generate_colors()`, `generate_fill()`, `generate_border()`) and its Shiny app (`ped_shiny()` and
the module demos), which are Phase 2. BGmisc's 58 exports include behavior-genetics model tools
(`buildPedigreeModelCovariance()`, `fitPedigreeModel()`, `fitComponentModel()`, `identifyComponentModel()`,
`calculateCIs()`, `inferRelatedness()`, `related_coef()`, `com2links()`, `sliceFamilies()`) with no
counterpart in the other three packages.

---

## 4. What each package accepts and refuses

`probeInputs.R` feeds one 7-animal pedigree (G inbred: its parents are full sibs) and 12 variants to each
entry point; full text in `results/probeInputs.csv` (13 cases x 14 entry points). The right answer where it is
defined: K(D,E) 0.25 and K(G,G) 0.625; with one parent of D unknown, 0.125 and 0.5625.

| Case | kinship2 `pedigree()` | kinship2 `kinship()` on vectors | Pedixplorer `Pedigree()` | BGmisc `ped2add()` | BGmisc checks | nprcgenekeepr `kinship()` | `qcStudbook()` (stays, R9) |
|---|---|---|---|---|---|---|---|
| One known parent | refuses | right | refuses (data frame + warning) | right | `single_parents` | right (legal here) | no error |
| Parent with no row | refuses | right (as unknown) | refuses | **wrong**, K(G,G) 0.5312 | `rowless_parents` | raw error | no error |
| Dam coded male | refuses | right | **changes her sex to female, no warning** | right | `wrong_sex_moms` | right | `maleDams` |
| Sire of unknown sex | refuses | right | changes it to male, no warning | right | `wrong_sex_dads` | right | no error |
| Duplicate id | refuses | refuses | refuses (data frame) | raw error | `non_unique_ids` | refuses ("All id values must be unique") | `duplicateIds` |
| Cycle | accepts | refuses ("own ancestor") | accepts | **wrong** | `cyclic_relationships` | raw error | `suspiciousParents` |
| Own parent | accepts | refuses | refuses (data frame) | **wrong** | `is_own_father_ids`, `cyclic_relationships` | raw error | `suspiciousParents` |
| Missing parent as `"0"` | refuses | right | accepts | **wrong** | `rowless_parents` | raw error | `sireAndDam` |
| Missing parent as `""` | accepts | right | refuses (data frame) | **wrong** | `rowless_parents` | raw error | `sireAndDam` |
| Unknown sex (a non-parent) | accepts, sex 3 | right | accepts, "unknown" | right | none | right | no error |
| Hermaphrodite `"H"` | accepts as unknown, no warning | right | accepts as unknown | right | none | right (H is a code here) | no error |
| Integer ids | accepts | right | accepts | right | none | right | no error |

kinship2's own refusal messages read "Impossible pedegree: someone is their own ancestor" (its spelling);
Pedixplorer's read "Impossible Pedigree: no progress made at iteration3". nprcgenekeepr's raw errors come from
`kinship()` after `findGeneration()` leaves NA generations, with the warning "findGeneration: 2 id(s) could not
be assigned a generation; the pedigree may contain a cycle or a parent ID absent as an ego ID".

Found while timing (S1123): Pedixplorer's `shrink()` refuses with "Invalid values for 'sex'" when an animal
marked available has unknown sex, and accepts the same pedigree when that animal is unavailable or has a sex.
On `samplePed` with one or two available animals: one of unknown sex, refused; one of known sex, kept 3; two
with one or both unknown, refused; one unknown-sex animal not available (with 30% of the others available),
shrinks. On `lacy1989Ped`, whose one available animal under section 7's seeded availability is C, of unknown
sex: refused; with C coded male, or with only D (male) available, it shrinks. Its `Pedigree()` builds all of
these, so the refusal comes only at the shrink. kinship2 and nprcgenekeepr shrink the three that Pedixplorer
refuses (one available of unknown sex, two available with one unknown, and `lacy1989Ped` with C).

---

## 5. Agreement

`runAgreement.R`; full rows in `results/agreement.csv` (160 rows). "=" agrees with nprcgenekeepr exactly
(largest difference below 1e-12); a number is the largest difference; "refuses" gives the error; "--" no such
export.

### 5.1 Kinship

| Pedigree | Animals | kinship2 | Pedixplorer | BGmisc | X: kinship2 | X: Pedixplorer |
|---|---:|---|---|---|---|---|
| hand case | 9 | right | right | K(X,X) 0.53125, should be 0.5 | -- | -- |
| samplePed | 55 | = | = | = | = | = |
| smallPed | 17 | = | = | = (5.6e-17) | refuses; = with a placeholder parent | refuses; = with a placeholder parent |
| lacy1989Ped | 7 | = | = | = | = (33 unknown cells, as nprcgenekeepr) | = |
| rhesus375 | 375 | = | = | 0.0312 | = | = |
| examplePedigree | 3,694 | = | = | 0.0156 | = (671,265 unknown cells, as nprcgenekeepr) | = |
| synthetic_1000 | 1,000 | = | = | 0.0977 | = | = |
| synthetic_10000 | 10,000 | = | = | 0.0625 | = | = |

MZ twins (`rhesus375` with its twin file): kinship2 =, BGmisc 0.0312 (its plain difference on this pedigree;
the MZ pair is 0.5 in all), Pedixplorer refuses the file ("missing value where TRUE/FALSE needed", caused by
the UZ pair of founders) and = without that pair. Dense kinship was not compared above 10,000 animals;
section 7 times it up to the size each package can hold.

### 5.2 Generation depth and families

Every cell agrees exactly with nprcgenekeepr. Families are compared as groupings, not labels; kinship2 gives an
unconnected animal family 0 and Pedixplorer gives it NA, and both are read as a family of one. BGmisc counts
founders as generation 1, so its numbers are compared after subtracting 1.

| Pedigree | Animals | Generations | Families | Depth: kinship2, Pedixplorer, BGmisc | Families: kinship2, Pedixplorer, BGmisc |
|---|---:|---:|---:|---|---|
| samplePed | 55 | 4 | 3 | = = = | = = = |
| smallPed | 17 | 4 | 1 | = = = | = = = |
| lacy1989Ped | 7 | 3 | 1 | = = = | = = = |
| rhesus375 | 375 | 9 | 5 | = = = | = = = |
| examplePedigree | 3,694 | 9 | 271 | = = = | = = = |
| synthetic_1000 | 1,000 | 8 | 22 | = = = | = = = |
| synthetic_10000 | 10,000 | 9 | 197 | = = = | = = = |
| synthetic_30000 | 30,000 | 9 | 670 | = = = | = = = |
| synthetic_100000 | 100,000 | 9 | 1,981 | = = = | = = = |

The synthetic colonies' many families are mostly imports that never bred, each a family of one.

### 5.3 Shrink to 16 bits

| Pedigree | kinship2 (seed 1) | Pedixplorer (seed 1) | nprcgenekeepr | Kept sets over seeds 1-5 |
|---|---|---|---|---|
| samplePed family 1 (avail, affected as given) | 18 kept, bit sizes 46 to 15 in 7 steps | the same 18 as kinship2 | 18 kept, a different 18, same bit sizes | kinship2 2, Pedixplorer 2; nprcgenekeepr's set is one of them |
| samplePed family 2 | 9 kept, 16 to 9 | **11 kept**, 16 to 10 | the same 9 as kinship2 | 1 each |
| rhesus375 (seed 42: 30% available, 10% affected) | 56 kept, 378 to 16 in 48 steps | 56 kept, 378 to 16 in 52 steps | 56 kept, 378 to 16 in 47 steps | kinship2 5, Pedixplorer 5; nprcgenekeepr's set is none of them |

On `rhesus375`, Pedixplorer differs from the first step: once the unavailable and the uninformative animals
are removed its bit size is 247, against 237 for kinship2 and nprcgenekeepr, the same rule difference as on
family 2. kinship2 and nprcgenekeepr part later, at step 11 (140 against 147), where kinship2's random
tie-break picks another animal. Single-run seconds on `rhesus375`: Pedixplorer 62.6, kinship2 3.7,
nprcgenekeepr 2.1.

### 5.4 Unrelated sets and subsets

kinship2's and Pedixplorer's unrelated sets are valid on all three pedigrees and the same size on every seed:
4 on family 1, 2 on family 2, 44 on `rhesus375`. nprcgenekeepr's `trimPedigree()` (5 probands and their
ancestors) and `getDescendantPedigree()` give exactly the animals Pedixplorer's `ancestors()` and
`descendants()` give, on `rhesus375` (74, 17), `examplePedigree` (80, 5) and `synthetic_10000` (62, 5).

---

## 6. What this means for the new package (input to Phases 2-4, not a decision)

- The kinship, generation and family code to copy agrees exactly with kinship2 and Pedixplorer; nothing found
  here argues for changing it before the copy.
- R9's short pedigree checker has a measured case list (section 4). Where it should stop and where it should
  repair is open; the three comparators make three different choices.
- `shrinkPedigree()`'s deterministic tie-break is a real difference from both comparators, as S741 recorded,
  and Pedixplorer differs from kinship2 too, so "matches kinship2" and "matches Pedixplorer" are different
  claims.
- BGmisc's kinship should not be used as a reference.
- Timing adds nothing against copying the dense kinship code as it is: it matches kinship2's speed and needs
  the least memory of the dense methods (section 7).
- `findPedigreeNumber()` is the one copy-set function whose time grows close to the square of the pedigree
  (12.9 s at 100,000 animals against 0.3-0.7 s elsewhere); worth a look before or during the copy (Phase 4's
  contract), not decided here.
- `kinship(sparse = TRUE)` returns a sparse matrix but needs more memory to compute it than the dense call.
  Past about 30,000 animals (a dense matrix within 32 GB) only a kinship computed sparse from the start could
  help, and none of the four packages offered one that worked here (BGmisc's crashed at 100,000). That is an
  inference from these runs, not a design.
- Shrinking to 16 bits finishes within 120 s only up to about 1,000 animals in any of the three packages.

---

## 7. Timing, memory and capacity (Phase 1 steps 4-5, S1123)

`runTiming.R`; tables printed by `summarizeTiming.R` from `results/timing.csv` (one row per case and size) and
`results/timingRuns.csv` (every run). Each run is a fresh `Rscript` (`timeOne.R`) under `/usr/bin/time -l`: it
loads only the measured package, plus Matrix (the other three load it with their own namespace, nprcgenekeepr
on first use, so no timed call includes loading a package), builds the inputs, and times one call with
`measure()` from `tools/perf/harness.R`. For each case and size, smallest first: one warm-up run, which is
also the capacity test, then 3 measured runs, whose median is the figure. The limits are 120 s counted from the
call's start (loading does not count) and 32 GB (29.8 GiB), held by R's own heap cap (`R_MAX_VSIZE`, which
refuses a matrix too large at once) and by a watchdog on the process's resident memory. A case stops at its
first failing size.

A step a user must run first is inside the timed call (nprcgenekeepr's `findGeneration()` before `kinship()`,
kinship2's `makefamid()` before `makekinship()`); the pedigree object that shrinking and unrelated sets take is
built before the clock, because building it is its own row. Shrinking and unrelated sets use a seeded 30%
available and 10% affected, ancestors and descendants 5 seeded probands (`timingInputs()` in `timingCases.R`).

**Load.** Mark's ruling (S1123): each run started only when at least half the CPU was idle, because macOS's own
background work (Spotlight indexing, Photos analysis, iCloud file sync) and Docker's virtual machine kept the
load average high with most cores free. Every run met it: 587 runs (429 measured), 16:44 to 18:01 on
2026-11-02, started with 54.6-88.8% of the CPU idle (median 64.7%); the 1-minute load average was 3.3-35.0
(median 7.7). Of the 37 cells of 0.5 s or more, none varied by more than 7.9% across its 3 runs (largest minus
smallest, over the median). Before this run, an hour of a CPU stress test another session had left running
(36 busy loops, a load average above 300) was stopped; none of these runs overlaps it.

### 7.1 Seconds

Median of the 3 measured runs; a size that failed shows how ("memory": R's heap cap or the watchdog; "time":
past 120 s; "crash": the R process died); the sizes after a failure were not run.

| Computation | Package |     300 |   1,000 |   3,000 |  10,000 |  30,000 | 100,000 |
|---|---|---:|---:|---:|---:|---:|---:|
| Kinship, autosomal | kinship2 | 0.002 | 0.018 | 0.267 | 3.12 | 30.5 | memory |
| Kinship, autosomal | Pedixplorer | 0.003 | 0.143 | 0.8 | 5.09 | memory |  |
| Kinship, autosomal | BGmisc | 0.015 | 0.037 | 0.4 | 2.45 | 19 | crash |
| Kinship, autosomal | nprcgenekeepr | 0.002 | 0.016 | 0.234 | 2.9 | 29.2 | memory |
| Kinship, autosomal, sparse or by family | BGmisc | 0.014 | 0.036 | 0.346 | 2.17 | 17 | crash |
| Kinship, autosomal, sparse or by family | nprcgenekeepr | 0.007 | 0.117 | 0.818 | 6.51 | memory |  |
| Kinship, autosomal, sparse or by family | kinship2 | 0.011 | 0.17 | 0.793 | 5.94 | memory |  |
| Kinship, X chromosome | kinship2 | 0.002 | 0.013 | 0.24 | 2.49 | 23.5 | memory |
| Kinship, X chromosome | Pedixplorer | 0.003 | 0.128 | 0.749 | 4.27 | memory |  |
| Kinship, X chromosome | nprcgenekeepr | 0.002 | 0.015 | 0.213 | 2.39 | 23.6 | memory |
| Generation depth | kinship2 | <0.001 | 0.001 | 0.001 | 0.003 | 0.014 | 0.082 |
| Generation depth | Pedixplorer | <0.001 | 0.001 | 0.001 | 0.003 | 0.014 | 0.082 |
| Generation depth | BGmisc | 0.012 | 0.015 | 0.023 | 0.045 | 0.13 | 0.71 |
| Generation depth | nprcgenekeepr | <0.001 | 0.001 | 0.003 | 0.009 | 0.03 | 0.101 |
| Family (connected component) | kinship2 | 0.003 | 0.005 | 0.015 | 0.048 | 0.203 | 0.663 |
| Family (connected component) | Pedixplorer | 0.001 | 0.005 | 0.015 | 0.047 | 0.142 | 0.564 |
| Family (connected component) | BGmisc | 0.069 | 0.079 | 0.074 | 0.086 | 0.133 | 0.301 |
| Family (connected component) | nprcgenekeepr | 0.002 | 0.004 | 0.016 | 0.147 | 1.35 | 12.9 |
| Shrink to 16 bits | kinship2 | 2.56 | 101 | time |  |  |  |
| Shrink to 16 bits | Pedixplorer | 89.4 | time |  |  |  |  |
| Shrink to 16 bits | nprcgenekeepr | 0.701 | 21 | time |  |  |  |
| Unrelated set | kinship2 | 0.003 | 0.028 | 0.512 | 6.53 | memory |  |
| Unrelated set | Pedixplorer | 0.022 | 0.29 | 1.38 | 15.4 | memory |  |
| Probands and their ancestors | nprcgenekeepr | <0.001 | <0.001 | 0.001 | 0.002 | 0.008 | 0.028 |
| Probands and their ancestors | Pedixplorer | 0.001 | 0.001 | 0.001 | 0.001 | 0.001 | <0.001 |
| Probands and their descendants | nprcgenekeepr | <0.001 | 0.001 | <0.001 | 0.001 | 0.003 | 0.005 |
| Probands and their descendants | Pedixplorer | 0.001 | 0.001 | 0.001 | <0.001 | 0.002 | 0.005 |
| Build a pedigree object | kinship2 | 0.001 | 0.001 | 0.001 | 0.002 | 0.006 | 0.019 |
| Build a pedigree object | Pedixplorer | 0.096 | 0.126 | 0.204 | 0.638 | 3.18 | 8.14 |

### 7.2 Capacity and memory

Capacity is the largest size that finished within both limits. "Process peak" is `/usr/bin/time`'s maximum
resident set size; "R heap peak" the high-water mark of R's heap above the starting point (`gc()`'s "max used",
a lower bound); "Before the call" the process's resident memory after loading and building the inputs.

| Computation | Package | Capacity | Next size failed on | Process peak (GiB) | R heap peak (GiB) | Before the call (GiB) |
|---|---|---:|---|---:|---:|---:|
| Kinship, autosomal | kinship2 | 30,000 | memory at 100,000 | 19.49 | 13.42 | 0.24 |
| Kinship, autosomal | Pedixplorer | 10,000 | memory at 30,000 | 5.47 | 4.50 | 0.40 |
| Kinship, autosomal | BGmisc | 30,000 | crash at 100,000 | 17.36 | 9.34 | 0.23 |
| Kinship, autosomal | nprcgenekeepr | 30,000 | memory at 100,000 | 12.96 | 9.69 | 0.25 |
| Kinship, autosomal, sparse or by family | BGmisc | 30,000 | crash at 100,000 | 10.65 | 2.64 | 0.24 |
| Kinship, autosomal, sparse or by family | nprcgenekeepr | 10,000 | memory at 30,000 | 5.77 | 3.37 | 0.25 |
| Kinship, autosomal, sparse or by family | kinship2 | 10,000 | memory at 30,000 | 7.33 | 4.30 | 0.24 |
| Kinship, X chromosome | kinship2 | 30,000 | memory at 100,000 | 19.54 | 13.42 | 0.24 |
| Kinship, X chromosome | Pedixplorer | 10,000 | memory at 30,000 | 5.62 | 4.48 | 0.40 |
| Kinship, X chromosome | nprcgenekeepr | 30,000 | memory at 100,000 | 12.81 | 9.70 | 0.25 |
| Generation depth | kinship2 | 100,000 | none up to 100,000 | 0.29 | 0.03 | 0.26 |
| Generation depth | Pedixplorer | 100,000 | none up to 100,000 | 0.48 | 0.04 | 0.44 |
| Generation depth | BGmisc | 100,000 | none up to 100,000 | 0.60 | 0.23 | 0.26 |
| Generation depth | nprcgenekeepr | 100,000 | none up to 100,000 | 0.31 | 0.04 | 0.28 |
| Family (connected component) | kinship2 | 100,000 | none up to 100,000 | 0.30 | 0.07 | 0.26 |
| Family (connected component) | Pedixplorer | 100,000 | none up to 100,000 | 0.47 | 0.07 | 0.44 |
| Family (connected component) | BGmisc | 100,000 | none up to 100,000 | 0.32 | 0.09 | 0.26 |
| Family (connected component) | nprcgenekeepr | 100,000 | none up to 100,000 | 0.35 | 0.04 | 0.28 |
| Shrink to 16 bits | kinship2 | 1,000 | time at 3,000 | 0.33 | 0.07 | 0.24 |
| Shrink to 16 bits | Pedixplorer | 300 | time at 1,000 | 0.42 | 0.09 | 0.40 |
| Shrink to 16 bits | nprcgenekeepr | 1,000 | time at 3,000 | 0.54 | 0.15 | 0.26 |
| Unrelated set | kinship2 | 10,000 | memory at 30,000 | 4.62 | 2.86 | 0.24 |
| Unrelated set | Pedixplorer | 10,000 | memory at 30,000 | 8.01 | 4.52 | 0.48 |
| Probands and their ancestors | nprcgenekeepr | 100,000 | none up to 100,000 | 0.30 | 0.04 | 0.28 |
| Probands and their ancestors | Pedixplorer | 100,000 | none up to 100,000 | 0.45 | 0.00 | 0.45 |
| Probands and their descendants | nprcgenekeepr | 100,000 | none up to 100,000 | 0.28 | 0.01 | 0.28 |
| Probands and their descendants | Pedixplorer | 100,000 | none up to 100,000 | 0.44 | 0.01 | 0.44 |
| Build a pedigree object | kinship2 | 100,000 | none up to 100,000 | 0.27 | 0.02 | 0.26 |
| Build a pedigree object | Pedixplorer | 100,000 | none up to 100,000 | 2.04 | 1.11 | 0.44 |

R's heap cap stopped the dense kinship of kinship2 and nprcgenekeepr (autosomal and X, at 100,000) and
Pedixplorer's autosomal kinship (at 30,000); the watchdog stopped Pedixplorer's X kinship, the two sparse
options and both unrelated sets (at 30,000); the two crashes are BGmisc's `ped2add()` at 100,000 (finding 13). At 10,000 animals
the dense methods' process peaks are 1.71 GiB (nprcgenekeepr), 2.36 (kinship2), 2.59 (BGmisc) and 5.47
(Pedixplorer).

---

## 8. Drawing: pictures, features and line checks (Phase 2, first session, S1124)

Same versions and machine as Part A (comparators reinstalled from the same sources into a new scratch library;
the versions printed by `runDrawing.R` match the table at the top). Results at `f87cd5055`.

### 8.1 Method

`runDrawing.R` draws five pedigrees with each package's default drawing call, on one canvas size per pedigree
for all four: `lacy1989Ped` (900 x 600 pixels), `smallPed` and the made-up feature pedigree (1,200 x 800),
`samplePed` (1,600 x 900) and `rhesus375` (3,600 x 1,500). kinship2 draws with `plot.pedigree()`, Pedixplorer
with `ped_to_plotdf()` drawn by `plot_fromdf()` (what its `plot()` does), ggpedigree with `ggPedigree()`, and
nprcgenekeepr with `makePedigreeMatingLayout()` and `drawPedigreeDiagram()`, saved as a web page and
photographed in Chrome. kinship2, Pedixplorer and ggpedigree get a placeholder for the missing parent of
smallPed's one animal with a single known parent (they refuse it otherwise); nprcgenekeepr gets the pedigree as
it is. Each package is compared with the pedigree it was given.

The made-up feature pedigree (`featurePedigree()`, 16 animals) has all four sex codes (U and H children), two
conditions (each alone and both together), two deceased animals, an MZ and a DZ pair, two matings of half
siblings and a sire with three mates.

**Pictures.** Under `docs/research/pedigree-package-comparison-2026-11/` (git-ignored, Mark's ruling: none in
git), one per pedigree and package (`<pedigree>_<package>.png`) and a 2 x 2 side-by-side per pedigree
(`<pedigree>_sideBySide.png`). Remake all 25 with
`CMP_LIB=<scratch>/rlib Rscript tools/pedigreeComparison/runDrawing.R` (about a minute).

**Line checks.** Each capture hands back every symbol it drew (with its position and size) and every straight
line, taken from what was drawn: kinship2's recorded graphics calls, Pedixplorer's plot data, ggpedigree's built
plot layers, and the nprcgenekeepr widget's own nodes and edges. `drawnParentLinks()` then reads the lines as a
reader does:

- a line is cut where it passes through an animal (for a drawn box, within a quarter of its smaller side of the
  centre; a line across a corner does not count), and lines that meet at an animal are not joined through it;
- dashed lines (links between two drawings of one animal) and marks across a symbol (the deceased slash) are
  not read as family lines;
- a child is an animal a line rises from; its parents are the animals the same connected line leaves sideways
  or downward.

`compareDrawnLinks()` then gives each animal with parents one status: **right** (every drawing of it reaches
exactly its parents), **plus others** (its parents and other animals too, joined by shared lines), **wrong**
(some drawing of it lacks a true parent), **missing** (drawn, but its line reaches no parent), **not drawn**;
and a founder drawn with parents is **extra**.

Checked by hand against the pictures: smallPed's M in kinship2's picture, ggpedigree's smallPed, feature and
rhesus375 pictures, and the rhesus375 rows (all 19 kinship2 and all 30 Pedixplorer "wrong" rows have a third
animal on the true parents' row between them). Two misreads of the first version (Pedixplorer's rounded branch
lines across a parent's box corner; an unplaced animal emptying ggpedigree's lines) were fixed before these
figures (fix cycles in `CHANGELOG.md`).

**Surface:** this Mac, these canvas sizes, Chrome via chromote for nprcgenekeepr. ggpedigree and nprcgenekeepr
symbols are read as points: a line crossing their drawn dot away from its centre is not counted as touching it.
The interactive parts (plotly, Pedixplorer's app) were checked from arguments and code, not used.
nprcgenekeepr's rhesus375 picture shows no ids: vis.js does not draw a label that would be under 5 pixels on screen
(`scaling.label.drawThreshold`), and fitted into 3,600 pixels the diagram is drawn at zoom 0.171, so its 14-pixel
labels would be 2.4 pixels (smallPed: zoom 0.884, 12.4 pixels, ids shown; measured in Chrome). Zooming in the app or
the saved page shows them. The other three draw text at a fixed size however small, so their ids show but overlap.

### 8.2 Feature table

From the feature pedigree's pictures unless the cell says otherwise.

| Feature | kinship2 1.9.6.2 | Pedixplorer 1.8.0 | ggpedigree 1.2.0 | nprcgenekeepr |
|---|---|---|---|---|
| Sex symbols | square, circle, diamond for unknown; H drawn as unknown | the same | square, circle; unknown sex drew **no symbol** (label only); no H | square, circle, triangle (unknown), star (H), diamond (unrecorded) |
| Conditions | several: symbol split into sections | several: red sections, each value also printed as "TRUE"/"FALSE" over the symbol (`aff_mark`) | one (`status_column`, an X over the symbol); the second (`overlay_column`) not visible | up to four: coloured sections |
| Deceased | slash | slash | none (no setting in `getDefaultPlotConfig()`) | slash |
| MZ / DZ twins | slanted lines to one point; MZ bar | the same | MZ bar; DZ pair not marked | labelled lines, MZ solid, DZ dashed |
| Mating of relatives | double marriage line | double marriage line | none | thick vermillion marriage line |
| Same animal drawn twice | dashed arc | dashed arc | dot-dash curve | dashed curve |
| Legend | none in `plot.pedigree()` (separate `legendPlot()`, `pedigree.legend()`) | `plot(legend = TRUE)`, off by default | none in the default picture | always: sexes, conditions, deceased, line kinds |
| Hover text | none (static) | a `tips` column of hover text in its plot data, for its plotly plot (not run) | `ggPedigreeInteractive()` (plotly), `tooltip_columns` | each animal's details on hover, and a highlight of its lines (its documentation) |
| Search, select | none | its app: not checked | none among its arguments | "Select by id" box |
| Click to re-center | none | its app: not checked | none among its arguments | in the Shiny app |
| Export | any R device (PNG, SVG, PDF) | any R device; ggplot; plotly web page; its app has a download module (formats not checked) | `ggsave()` (PNG, SVG, PDF); plotly web page | PNG button; stand-alone web page (`htmlwidgets::saveWidget()`); no SVG or PDF |
| Script / app | script | script and a Shiny app (`ped_shiny()`; arguments `ind_max_warning = 300`, `ind_max_error = 500`; not run) | script | script and the app's Diagram tab (750 animals, 400 with rectilinear lines) |
| Refusals and changes at defaults | none; warns when over 25% of sexes are unknown | ids with "_"; the feature pedigree's alignment (`force = TRUE` needed); leaves out 18 rhesus375 animals | warns when over 25% of sexes are unknown | none |
| An animal with no parents, mates or offspring (samplePed's 113) | left out ("Did not plot") | left out ("won't be plotted") | given no position | left out, with a message |

### 8.3 Line checks

Animals with parents in each drawing (`results/drawingSummary.csv`; per animal: `results/drawingLinks.csv`).

| Pedigree (with parents) | Package | Right | Plus others | Wrong | Missing | Not drawn | Extra founders |
|---|---|---:|---:|---:|---:|---:|---:|
| lacy1989Ped (4) | all four | 4 | 0 | 0 | 0 | 0 | 0 |
| smallPed (10) | kinship2, Pedixplorer, ggpedigree | 9 | 0 | 1 | 0 | 0 | 0 |
| smallPed (10) | nprcgenekeepr | 10 | 0 | 0 | 0 | 0 | 0 |
| feature (11) | kinship2, Pedixplorer, nprcgenekeepr | 11 | 0 | 0 | 0 | 0 | 0 |
| feature (11) | ggpedigree | 6 | 3 | 0 | 2 | 0 | 0 |
| samplePed (39) | all four | 39 | 0 | 0 | 0 | 0 | 0 |
| rhesus375 (251) | kinship2 | 232 | 0 | 19 | 0 | 0 | 0 |
| rhesus375 (251) | Pedixplorer | 196 | 0 | 30 | 16 | 9 | 0 |
| rhesus375 (251) | ggpedigree | 112 | 1 | 133 | 5 | 0 | 14 |
| rhesus375 (251) | nprcgenekeepr | 248 | 3 | 0 | 0 | 0 | 0 |

What the readings are:

- **smallPed's one wrong (M):** A has three mates; kinship2's layout puts A between B and J and runs A's marriage
  line to N through J, so the drop to M meets it between J and N. Pedixplorer and ggpedigree draw the same.
  nprcgenekeepr places A's matings so that each has its own line.
- **kinship2 and Pedixplorer on rhesus375:** every wrong reading is that pattern: the true parents' marriage line
  runs through a third animal on their row (19 and 30, checked one by one). Pedixplorer's 16 missing and 9 not
  drawn come from the 18 animals it leaves out.
- **ggpedigree on rhesus375:** 177 lines of its spouse layer run from founder NPYENA's two drawings to points all
  over the pedigree (visible in the picture as two fans); they make 124 of the 133 wrong readings and 13 of the 14
  extra founders. The feature pedigree's 3 "plus others" (T4, X, H1 reach A, D2, H and S2) come from a long line
  from S2 x D2 to T4's second drawing that crosses the A x H family; its 2 missing (T3, U1) have no line reaching
  a parent.
- **nprcgenekeepr on rhesus375:** the 3 "plus others" (CSZ177, 6PQJV5, 30YDZU) are children of WCPXHD, whose lines
  to two mates leave his symbol along the same short downward stretch before turning, so his families' lines
  join; each child still reaches both true parents.

Drawing time, memory, capacity and readability are section 9; the closing answer is section 10.

---

## 9. Drawing time, memory, capacity and readability (Phase 2, second session, S1125)

Same versions and machine as Part A (comparators reinstalled from the same sources into a new scratch library:
kinship2 1.9.6.2, Pedixplorer 1.8.0, ggpedigree 1.2.0, BGmisc 1.6.0.1). nprcgenekeepr installed from `fd7c3d8ce`
into a scratch library; `R/` is identical to `f87cd5055`, where section 8 was measured. Runner at `fcb8f0371`.

### 9.1 Method

**Mark's rulings (S1125):** synthetic colonies of 300, 1,000, 2,000 and 3,000 animals (2,000 added to Part A's
sizes in `savePedigrees.R`, same generator and seed) plus rhesus375; a drawing counts as drawn only when R and the
browser together finish within 120 s; the plotly versions of Pedixplorer and ggpedigree are timed in Chrome beside
nprcgenekeepr's page; and, as Pedixplorer refuses the synthetic colonies, its two drawings are also timed with its
parent alignment off (`align_parents = FALSE`, which its own warning suggests: "You may want to try with
`align_parents = FALSE`").

Eight drawings (`tools/pedigreeComparison/drawingTimingCases.R`), each from the comparison pedigree to a file a user
can open, on a canvas of 3,600 x 1,500 pixels:

| Drawing | Timed in R | Then in Chrome |
|---|---|---|
| kinship2 picture | `pedigree()` and `plot.pedigree()` to a PNG file | no |
| Pedixplorer picture | `Pedigree()`, `ped_to_plotdf()` and `plot_fromdf()` (what its `plot()` does) to a PNG file | no |
| Pedixplorer plotly page | `Pedigree()` and its Shiny app's own plotting function (`app_plot_fct(interactive = TRUE)`, which calls `ggplotly()`), saved as a web page | yes |
| ggpedigree picture | `ggPedigree()` and `ggsave()` | no |
| ggpedigree plotly page | `ggPedigreeInteractive()`, saved as a web page | yes |
| nprcgenekeepr page | `findGeneration()`, `makePedigreeMatingLayout()` and `drawPedigreeDiagram()`, saved as a web page | yes |
| Pedixplorer picture, alignment off | as its picture, with `align_parents = FALSE` | no |
| Pedixplorer plotly page, alignment off | as its plotly page, with `align_parents = FALSE` | yes |

nprcgenekeepr is called directly, without the Diagram tab's cap (750 animals, 400 with rectilinear lines,
`R/modPedigree.R:454,466`). kinship2, Pedixplorer and ggpedigree get placeholder parents as in section 8. Converting
the pedigree to each package's coding is not timed, and neither is finding Pedixplorer's label size: it checks
the labels' room against the open device, so both its drawings use a device of the canvas size (on it,
rhesus375 takes full-size labels; on R's default 7-inch device its app's call refuses them, "reduce cex"). The two
alignment-off drawings use the default label size without that search: it would take as long as the drawing, and at
2,000 animals would outlast `drawOne.R`'s 300 s limit for reaching the clock.
Writing a page counts as R time (plotly builds its figure while the page is written).

**R part:** one fresh `Rscript` per run (`drawOne.R`), as in Part A: only the drawing's packages are loaded before
the clock; R heap peak from `measure()`, process peak from `/usr/bin/time -l`; limit 32 GB. **Browser part:** the
saved page in a new Chrome tab (chromote), from navigation to the first painted frame after the widget's own draw
event (vis.js `afterDrawing`; plotly `plotly_afterplot`, the last one), recorded in the page by a hook the harness
adds (`drawingTiming.R`), allowed what is left of the 120 s; the JavaScript heap in use then
(`Performance.getMetrics`, `JSHeapUsedSize`). For each drawing and size, smallest first: one warm-up run, which is
also the capacity test and gives the pictures, then 3 measured runs, whose median is the figure. A drawing stops at
its first failing size; rhesus375 is drawn by every one.

**Load.** Each run started only when at least half the CPU was idle (Mark's ruling, S1123). 84 runs (57 measured)
on 2026-11-03: the six drawings 10:21 to 10:43, the two alignment-off ones 13:08 to 13:19 (`--append`, which keeps
the other rows); started with 57.7-85.8% of the CPU idle (median 73.5%); the 1-minute load average was 3.0-10.7
(median 5.8). Of the 18 cells of 0.5 s or more, none varied by more than 8.8% across its 3 runs. A single probe run
before the ruling, with no idle gate, had taken 61 s for the alignment-off picture at 1,000 animals; its four gated
runs took 16.03-16.08 s (why the probe was slower was not checked).
Re-run from a fresh shell: nprcgenekeepr at 1,000 animals 16.77 s (median 16.30), kinship2 on rhesus375 1.438 s
(median 1.494).

**Files.** `results/drawingTiming.csv` (one row per drawing and pedigree) and `results/drawingTimingRuns.csv` (every
run); the tables below are printed by `summarizeDrawingTiming.R`. Pictures under
`docs/research/pedigree-package-comparison-2026-11/timing/` (git-ignored, as section 8's): each warm-up's PNG or web
page, a Chrome picture of each page, and nprcgenekeepr's page at zoom 1 (`*_zoom1.png`). Remake them all with
`NPG_LIB=<scratch>/nlib CMP_LIB=<scratch>/rlib Rscript tools/pedigreeComparison/runDrawingTiming.R` (all eight
drawings; here 22 minutes for the first six and 11 for the other two).

### 9.2 Seconds

Median of the 3 measured runs, R and browser together; "time": past 120 s (each time in the R part); "refused":
the package stopped with an error; the sizes after a failure were not run.

| Package | Drawing | 300 | 1,000 | 2,000 | 3,000 | rhesus375 (375) |
|---|---|---:|---:|---:|---:|---:|
| kinship2 | picture, `plot.pedigree()` | 0.464 | 12.9 | time |  | 1.49 |
| Pedixplorer | picture, `plot()` | refused |  |  |  | 3.68 |
| Pedixplorer | plotly page, its app's call | refused |  |  |  | 34.4 |
| Pedixplorer | picture, `plot()`, alignment off | 1.2 | 16 | time |  | 3.46 |
| Pedixplorer | plotly page, its app's call, alignment off | 29.3 | time |  |  | 34.9 |
| ggpedigree | picture, `ggPedigree()` | 1.17 | 15 | time |  | 2 |
| ggpedigree | plotly page, `ggPedigreeInteractive()` | 1.14 | 14.9 | time |  | 1.96 |
| nprcgenekeepr | vis.js page, `drawPedigreeDiagram()` | 1.27 | 16.3 | time |  | 2.1 |

The pages' two parts, R seconds + browser seconds:

| Package | Drawing | 300 | 1,000 | 2,000 | 3,000 | rhesus375 (375) |
|---|---|---:|---:|---:|---:|---:|
| Pedixplorer | plotly page, its app's call | refused |  |  |  | 34 + 0.359 |
| Pedixplorer | plotly page, its app's call, alignment off | 29 + 0.34 | time |  |  | 34.5 + 0.372 |
| ggpedigree | plotly page, `ggPedigreeInteractive()` | 0.845 + 0.295 | 14 + 0.933 | time |  | 1.75 + 0.212 |
| nprcgenekeepr | vis.js page, `drawPedigreeDiagram()` | 1.11 + 0.16 | 15.5 + 0.838 | time |  | 1.95 + 0.15 |

### 9.3 Capacity and memory

Capacity is the largest synthetic size drawn within 120 s. "Process peak" is `/usr/bin/time`'s maximum resident set
size of the R part; "R heap peak" the high-water mark of R's heap above the start (a lower bound); "JavaScript heap"
the page's heap in use when it had drawn.

| Package | Drawing | Capacity | Next size failed on | Process peak (GiB) | R heap peak (MiB) | JavaScript heap (MiB) |
|---|---|---:|---|---:|---:|---:|
| kinship2 | picture, `plot.pedigree()` | 1,000 | time at 2,000 | 0.53 | 213 |  |
| Pedixplorer | picture, `plot()` | below 300 | refused at 300 |  |  |  |
| Pedixplorer | plotly page, its app's call | below 300 | refused at 300 |  |  |  |
| Pedixplorer | picture, `plot()`, alignment off | 1,000 | time at 2,000 | 1.05 | 307 |  |
| Pedixplorer | plotly page, its app's call, alignment off | 300 | time at 1,000 | 0.76 | 254 | 13.4 |
| ggpedigree | picture, `ggPedigree()` | 1,000 | time at 2,000 | 0.64 | 255 |  |
| ggpedigree | plotly page, `ggPedigreeInteractive()` | 1,000 | time at 2,000 | 0.67 | 267 | 71.5 |
| nprcgenekeepr | vis.js page, `drawPedigreeDiagram()` | 1,000 | time at 2,000 | 0.95 | 298 | 42.9 |

The JavaScript heap is a reading at one moment, not a peak: for nprcgenekeepr at 1,000 animals the 3 measured runs
read 26.5, 42.9 and 43.1 MiB and the fresh-shell re-run 27.1 (probably whether a garbage collection had run; not
checked); every other page's readings agree within 1.6 MiB.

### 9.4 Readability (Mark's judgment)

Mark judged from one sheet per size drawn (300, rhesus375, 1,000), and a second set for Pedixplorer's alignment-off
drawings: each drawing whole, scaled down, and a crop of its centre at actual pixels; nprcgenekeepr's crop is its
page at zoom 1, since its fitted view hides labels (section 8.1). The plotly crops are not zoomed; the saved pages
were open for zooming. The question: at which largest size can an animal still be found by its id and its lines
followed to its parents?

| Package | Largest readable size |
|---|---|
| kinship2 | none (not at 300) |
| Pedixplorer | none: alignment on, not at rhesus375 (its only drawing then); alignment off, not at 300, rhesus375 or 1,000 |
| ggpedigree | none (not at 300), picture and plotly page |
| nprcgenekeepr | 1,000 once zoomed in, the largest any package drew; its fitted view shows no ids |

The sheets were made in the session's scratch folder from the warm-up pictures (whole drawing fitted to 900 x 375
pixels, centre crop 900 x 600) and not kept; the pictures they came from are remade by the runner.

---

## 10. What the new package would offer that none of the three does

On this evidence what is left to offer is the drawing, not the computation. kinship2 and Pedixplorer already compute
what nprcgenekeepr's copy set computes and agree with it exactly (findings 1 and 4-6), so the new package's
computations would be a third implementation of the same numbers: as fast as kinship2 at dense kinship with the
least memory, and the fastest at shrinking (findings 11 and 14), but not new. Its drawing is new on three counts. It
is right: of the four packages only nprcgenekeepr drew every child to its true parents on all five pedigrees, while
the other three run a sire's marriage line through a third animal; ggpedigree adds 177 stray lines, and Pedixplorer
leaves animals out and, at its defaults, refuses every synthetic colony (findings 18-21 and 25). It is readable:
Mark judged only nprcgenekeepr's drawing readable at any size tested, up to 1,000 animals once zoomed in (finding
28). And it is annotated and interactive from a script, at about the speed of the static pictures: a legend by
default, a hermaphrodite symbol, up to four conditions, labelled twin lines, hover text and an id search box
(section 8.2), drawn at 1,000 animals in 16.3 s against 12.9 s for kinship2's picture and 15.0 s for ggpedigree's
(finding 26). It does not change the size limit: no package draws 2,000 animals within 120 s and the best stop at
1,000, because the layout in R takes the time (finding 25), so drawing a whole colony (issue #138) needs a different
design, not this package. Also missing beside the others: SVG and PDF export, and a fitted view of a large pedigree
that shows ids without zooming. This answers the plan's question; it does not decide anything: whether to go on to
Phase 3 is Mark's call (plan section 6). Mark went on: he picked Phase 3 at S1126.

---

## 11. Input style: four prototypes and Mark's ruling (Phase 3, S1126)

Which input the new package's functions take (ruling R7). Four throwaway prototypes, written in the session's
scratchpad and not kept (plan Phase 3), each draw one pedigree and compute its kinship. All four end in the same
nprcgenekeepr calls (commit `aee51f260`, `pkgload::load_all()`): `findGeneration()`, `makePedigreeMatingLayout()`,
`drawPedigreeDiagram()` and `kinship()`. Only the way in differs:

- (a) the data frames themselves: the pedigree (`id`, `sire`, `dam`, `sex`, condition columns `affected*`, `status`
  and any other column, such as `name`) and the twins table (`id1`, `id2`, `code`);
- (b) a kinship2 `pedigree` object, turned back into those data frames by a converter;
- (c) a Pedixplorer `Pedigree` object, turned back the same way;
- (d) the data frames, plus one generic converter whose two methods are those of (b) and (c).

For each style a user's script reads the pedigree CSV and the twins CSV and makes the drawing and the kinship
matrix, with whatever steps that style needs. **Pedigrees:** the test pedigree is section 8's feature pedigree (16
animals) plus the two cases it left out on purpose, P1 (sire A, no dam) and Q_1 (an id with "_"), with names for
A, T1 and H1 (18 animals); and rhesus375 with its twins file (one MZ, one DZ and one UZ pair). Each style's result
is compared with (a)'s: each animal's symbol, hover text, deceased mark, condition sections and position; the twin
lines; kinship among the real animals. **Lines** leave out blank and comment lines: a converter's whole definition,
and a user's script without its function line, closing brace and the line handing results to the measuring
script. **Packages** are the hard dependencies (Depends, Imports, LinkingTo, all the way down, base packages left
out) of the copy set's outside packages (plan section 3.1), alone and with kinship2 or Pedixplorer added, read from
the installed packages. Pictures of the test pedigree through (a), (b) and (c) were shown to Mark and not kept.

### 11.1 Results

| | (a) Data frames | (b) kinship2 `pedigree` | (c) Pedixplorer `Pedigree` | (d) Data frames plus converters |
|---|---|---|---|---|
| Converter code in the package | 0 lines | 35 | 28 | 69 (both, plus 6 for the generic) |
| User's script, two CSV files to drawing and kinship | 5 lines | 12 | 14 | 5 |
| Packages every user installs, beyond the copy set's 47 | none | 1 (kinship2, CRAN) | 49, 3 only on Bioconductor (Pedixplorer, S4Vectors, BiocGenerics) | none; kinship2 and Pedixplorer optional |
| P1, one known parent | drawn from its sire | refused; drawn with a made-up dam once the user adds one | as (b) | drawn from its sire |
| H1, hermaphrodite | star | unknown (triangle) | unknown (triangle) | star |
| Names and other columns | kept | dropped | kept | kept |
| Q_1, id with "_" | kept | kept | refused; drawn as Q.1 once the user renames it | kept |
| rhesus375's twin pair with unknown parents | drawn | drawn | refused (raw error) | drawn |
| Hover texts that differ from (a), test pedigree | 0 | 4 (A, T1, H1: name; P1: dam; H1: sex) | 3 (P1: dam; H1: sex; Q_1: id) | 0 |
| rhesus375: nodes, edges and kinship against (a) | | identical | identical, less the refused pair | identical |

(d) from a kinship2 or Pedixplorer object gives exactly (b)'s or (c)'s result: what an object loses is lost when
it is built. Conditions, deceased marks and twin lines were kept by every style. The extra steps in (b)'s and (c)'s
scripts: each package's fix-parents function, merging its result back with the other columns, and for Pedixplorer
renaming ids with "_" and dropping the all-`NA` family column its `fix_parents()` adds, which otherwise makes
`Pedigree()` put a family number before every id. Pedixplorer also renames columns by default (`status` to
`deceased`, `birth` to `dateofbirth`, `affected` to `affection`). Building the object took Pedixplorer 8.1 s at
100,000 animals against 0.019 s for kinship2 (finding 15).

### 11.2 What the converters read (input to Phases 4 and 14)

| Data frame column | From a kinship2 `pedigree` | From a Pedixplorer `Pedigree` |
|---|---|---|
| `id` | `id` | `id` of `ped(x)`, with a family number in front when the object has families |
| `sire`, `dam` | `id[findex]`, `id[mindex]`; index 0 is unknown | `dadid`, `momid` |
| `sex` (M, F, U) | `sex`: male, female, unknown, terminated (H is already unknown) | `sex`: male, female, unknown (H is already unknown) |
| `affected_<name>` | each column of `affected` (0, 1, NA) | each condition of `fill(x)` with a known value, from its `<name>_mods` column (0, 1) |
| `status` (`DECEASED`) | `status == 1` | `deceased` |
| other columns | none: `pedigree()` keeps none | the object's extra columns |
| twins (`id1`, `id2`, `code`) | `relation` codes 1-3 (MZ, DZ, UZ); 4, spouse, left out; the code is a whole number when `pedigree()` got text codes, a factor when it got numbers | `rel(x)`, without `Spouse` |

The prototypes' first converters had one defect each, found only by comparing with (a); both are test cases for
the real ones. An unknown parent (index 0) dropped out of `id[index]` and moved every later parent onto the wrong
animal. A Pedixplorer object built with no condition still has an all-`NA` `affection` column, which became a
condition with every animal "Unknown".

### 11.3 Ruling

**R7 (Mark, S1126): data frames, plus converters from kinship2 and Pedixplorer objects** (style (d), Claude's
recommendation), with kinship2 and Pedixplorer optional (Suggests), never required. From a CSV file a user loses
nothing and installs nothing more; a user who holds a kinship2 or Pedixplorer object can hand it in, with what that
object has already lost. Phase 4 sets the converters' names and contract; Phase 14 builds them.
