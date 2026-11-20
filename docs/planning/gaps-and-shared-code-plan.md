# Plan: closing the gaps, and how pedkindraw and nprcgenekeepr share their code (Phase 17f2)

**Date:** 2026-11-18 · **Session:** pedkindraw S41 · **Type:** planning session (`methodology/SESSION_RUNNER.md`
"Planning Sessions"). No package code changed in either repository. nprcgenekeepr was read from an archive of its
commit in a scratch folder and run there with its own renv library; its folder was not changed (R8).
**Answers:** ruling R96 (Mark's direction, S40); Phase 17f2 of `docs/planning/cran-submission-plan.md`.
**Status:** complete. Mark decided D4, D11, D12 and D13 and the two nprcgenekeepr faults by picker (S41), rulings
R97-R101 (section 4). G1 DONE (pedkindraw S42; R102-R105 in the standalone plan). G2 DONE (pedkindraw S43;
R106-R107). G3 DONE (pedkindraw S44; R108-R110). G4 DONE (pedkindraw S45; R111-R113). G5 DONE (pedkindraw S46;
R114-R116). G6 DONE (pedkindraw S47; R117-R119). G7 DONE (pedkindraw S48; R120-R122). G8 DONE (pedkindraw S49;
R123-R124). G9 DONE (pedkindraw S50; R125-R126). G10 DONE (pedkindraw S51; R127-R128). G11 DONE (pedkindraw S52;
R129-R130). G12 DONE (pedkindraw S53; R131-R132). G13 DONE (pedkindraw S54: the genotyped mark, 1 of 6; R133-R134;
S55: the carrier mark, 2 of 6; R135; S56: the proband and consultand marks, 3 of 6; R136; S57: the evaluated mark,
4 of 6; R137; S58: the infertile mark, 5 of 6; R138; S59: the miscarriage mark, 6 of 6; R139). G14 under way
(pedkindraw S60: the symbol size, 1 of 3; R140). Next: G14's text size, then its spacing and line width, in
pedkindraw (section 5.1); in nprcgenekeepr N1 and
N2 are done (its S1189 and S1190, section
5.2).
**Measured at:** pedkindraw `f709b00` (S41's claim; `R/`, `tests/` and `NAMESPACE` as at `c5f8e84`); nprcgenekeepr
`eafd54851` (its S1188 claim; its `R/` and tests as at that commit); kinship2 1.9.6.2 from nprcgenekeepr's renv
library; R 4.6.2 on this Mac (Apple M2 Max). The scratch scripts are named where their results are quoted; they are
not committed (section 7 lists what a later session reruns).

---

## 1. Mark's direction, and what this plan decides

Mark (S40), in his words (R96): "For the next session, create a plan to eventually close the gaps, where possible, in
nprcgenekeepr and pedkindraw such that (1) the first version of pedkindraw for submission to CRAN is as complete as
we decide during the planning session; (2) we discuss refactoring nprcgenekeepr to use function calls as if we were
dependent on pedkindraw; (3) decide if we want pedkindraw functions in nprcgenekeepr with the intent of replacing
them with a dependency on pedkindraw once pedkindraw is accepted by CRAN (not a certain outcome).(4) figure out how
to best coordinate work between nprcgenekeepr and pedkindraw repositories. (5) Acknowledging that nprcgenekeepr will
not necessarily need all of the functionality provided by pedkindraw." And: "Pausing development of one repository
while waiting on progress in the other is an acceptable option."

The evidence for the gaps is `docs/research/pedkindraw-gaps-2026-11-18.md` (16 open gaps, A1-C6, each on a typed
case; its section 1.1 says what each means for a user, its section 10 which nprcgenekeepr has too). This plan adds
what closing each would touch (section 3.1) and what the two packages share and how (sections 3.2-3.6).

**What this plan decides,** each by a picker to Mark, each recorded as a ruling in section 2 of
`docs/planning/standalone-pedigree-package-plan.md`:

| # | Decision | Mark's point |
|---|---|---|
| D4 | Which gaps, if any, close before pedkindraw's first CRAN release | 1 |
| D11 | Whether nprcgenekeepr comes to call pedkindraw's functions, and whether it carries copies matched to pedkindraw's until CRAN accepts pedkindraw | 2, 3 |
| D12 | Which of pedkindraw's functions nprcgenekeepr takes, and what becomes of its own exports of them | 5 |
| D13 | The order of work between the two repositories: where a change to the shared code starts, and which repository pauses, if either | 4 |

**What it does not do:** change code; change nprcgenekeepr. Work it places in nprcgenekeepr is a session Mark starts
there, under that repository's own protocol, TDD gates and checks (R8 until Mark rules otherwise; R96: "the plan
proposes, Mark rules"). It does not plan nprcgenekeepr's own next release.

---

## 2. Terms

- **Gap:** as the gaps document defines it (its section 2): something kinship2 1.9.6.2 or Pedixplorer 1.8.0 does,
  through an export or an argument, that no pedkindraw export does. A1-C6 are its sixteen. **N** is the item that
  document found on the way (its section 9, item 1): a numeric condition column is drawn affected wherever it is not
  0, with no message.
- **Copied function:** one of the 91 functions, in 33 of pedkindraw's `R/` files, whose file header says "Copied
  from nprcgenekeepr"; `tools/compareWithNprcgenekeepr.R` lists them. 14 now differ from nprcgenekeepr's, each with a
  `DIVERGENCE.md` row.
- **Shared export:** a copied function both packages export: 22. pedkindraw exports 31, these 22 and 9 of its own
  (`asPedFrame()`, `bitSize()`, `checkPedigree()`, `familyCheck()`, `findAvailAffected()`, `findAvailNonInform()`,
  `findUnavailable()`, `findUnrelated()`, `ibdMatrix()`).
- **Internal function:** one a package does not export. Another package reaches it only through `:::`, which
  `R CMD check` reports as a NOTE ("Unexported objects imported by ':::' calls", R's
  `tools:::format.check_packages_used()`), so a CRAN package does not do it.
- **Port:** making in one repository a change the other already made to a copied function (the drift rule, section 5
  of the standalone plan). Until the port, a `DIVERGENCE.md` row records the difference.
- **Calling "as if dependent"** (Mark's point 2): nprcgenekeepr's own code calls the copied functions only as
  pedkindraw exports them (the same names, argument names and argument order), so that replacing its copies by
  pedkindraw's later changes `DESCRIPTION` and `NAMESPACE`, not its code.
- **Imports, Suggests:** fields of `DESCRIPTION`. A package in Imports is installed with the package and loaded by it;
  CRAN requires it to be on CRAN or Bioconductor (section 3.5). A package in Suggests is optional and used only
  when present.
- **Re-export:** a package imports a function from another and exports it under the same name
  (`importFrom(pedkindraw, kinship)` and `export(kinship)` in `NAMESPACE`), so its own users' calls keep working; its
  help then has one page listing the re-exported names, each linking to the other package's page.
- **Changes or adds** (section 3.1): closing a gap **changes** behaviour when an existing call, with the same
  arguments, gives a different result or drawing afterwards; it **adds** when it brings only a new function, a new
  argument whose default keeps today's result, or a new element of a returned list. After the first CRAN release, a
  change needs the deprecation rule of the contract's section 6 or at least a NEWS item that tells users their
  drawings or results differ; an addition needs neither.
- **Size:** S about one session, M two or three, L a plan of its own first. A size here is counted from the code the
  gap touches (section 3.1's third column), not measured by building it; it is still an estimate.

---

## 3. Measured

### 3.1 Each gap: the code closing it would touch

pedkindraw's `R/` at `c5f8e84`. "Copied" means the code is a copied function, so closing the gap in pedkindraw adds a
`DIVERGENCE.md` row, or a port to nprcgenekeepr, unless nprcgenekeepr takes that function from pedkindraw by then
(D11). The last column is the gaps document's section 10, measured on nprcgenekeepr's own code.

| Gap | What a user gets | Code it touches | Copied? | Changes or adds | Size | nprcgenekeepr too |
|---|---|---|---|---|---|---|
| N | A number in a condition column is reported, not drawn as affected in silence | `as.logical()` of the column in `makePedigreeDiagramData()` (`R/makePedigreeDiagramData.R:117`) and in the layout's condition reading (`:1913`, inside `makePedigreeMatingLayout()`) | yes | **changes** (a warning or a stop where a number now draws) | S | yes, the same code |
| B2 | An animal whose affected status is unknown looks different from an unaffected one | `.affectedColor()` (`R/makePedigreeDiagramData.R:215`); the sections of a several-condition symbol, `.affectedSectionsOf()` (`R/affectedConditions.R:75`) and the drawing's sections script `.conditionSectionsHandler()` (`:101`); a legend row (`R/drawPedigreeDiagram.R:107`) | yes | **changes** (`NA` is drawn white today) | S-M | yes |
| B6 | Notes under an id longer than 15 characters are written whole | `.nameLabelCharBudget` (`R/makePedigreeDiagramData.R:240`) and `.nameLabel()` (`:266`) | yes | adds (an argument, default 15) | S | yes |
| B5 | Colours (and later sizes and spacing) can be chosen | `.conditionColors` (`R/affectedConditions.R:23`), the legend (`R/drawPedigreeDiagram.R:107`), the sections script, which paints its own list (`R/affectedConditions.R:101`) | yes | adds (an argument whose default is today's colours) | S colours; M sizes and spacing | yes |
| C4 | Data written with "0" or "" for a missing parent, or sex as 1/2, male/female, m/f, are read | a new function; `checkPedigree()` (`R/checkPedigree.R:79`) already names these codes | no, new | adds | S | half: nprcgenekeepr's `convertSexCodes()` reads the sex codes |
| C5 | Each animal's offspring count and mates in one call | new functions beside `getOffspring()` | no, new | adds | S | half: nprcgenekeepr's `offspringCounts()` |
| C6 | Listed animals removed, their offspring's links to them cleared, in one call | a new function | no, new | adds | S | yes |
| C2 | Generation numbers with mates aligned | an argument of `findGeneration()` (`R/findGeneration.R:48`); the rule written from kinship2's described method, not its GPL code (R11) | yes | adds | S | yes |
| B7 | A picture of what `shrinkPedigree()` removed | documentation: an example or vignette section drawing the pedigree with a condition column made from `idTrimmed` (`R/shrinkPedigree.R:230`) | no | adds | S | yes |
| C3 | The layout's own hints returned, to edit and pass back | `makePedigreeMatingLayout()` (`R/makePedigreeDiagramData.R:1756`), its two returns (`:1836`, `:2219`); `R/layoutHints.R` (pedkindraw's own) | yes | adds (a list element) | M | wider: nprcgenekeepr's layout takes no hints |
| C1 | The relatives within k steps of chosen animals kept | a new function beside `trimPedigree()` (`R/trimPedigree.R:60`), its rule written from Pedixplorer's help and measured results, as `findUnrelated()` was (R52) | no, new | adds | M | yes |
| B4 | A measured trait drawn by a threshold, with the rule in the legend | the condition reading (`:117`, `:1913`), the legend; builds on N | yes | adds | M | yes |
| B3 | Marks for carrier, proband and others; for a colony, the genotyped border first | node columns read in `makePedigreeMatingLayout()`, a drawing script in `drawPedigreeDiagram()` (`R/drawPedigreeDiagram.R:79`), a legend row, for each mark | yes | adds | M each | yes |
| B1 | Two animals mated with no offspring drawn as a mating | `.buildMatingUnitForest()` (`R/makePedigreeDiagramData.R:454`), which builds every mating from shared offspring; `.findIsolatedIds()` (`:369`); the mate-hint check (R70, `R/layoutHints.R`) | yes, the layout engine | adds (a table of matings) | L | yes |
| A1 | A drawing as a PDF, SVG or PNG file from a script | new code: either a second renderer with R graphics reading the layout's nodes and edges and redrawing the condition sections, the deceased slash (`R/deceasedSlash.R:46`), the twin lines (`.buildTwinConnectorEdges()`, `R/makePedigreeDiagramData.R:321`) and the legend; or a screenshot by a headless browser (chromote, a Suggests; PNG or PDF, not SVG, and Chrome on the user's machine) | no, new | adds | L | yes |
| A2 | Every id of a large pedigree on one page | comes with A1 (a file); in the browser the measured limit stands | — | adds | with A1 | yes |
| A3 | An app: load a file, choose a family, draw | new code; `shiny` at least in Suggests | no, new | adds | L | no: nprcgenekeepr has `runGeneKeepR()` |

Two of the seventeen **change** behaviour, N and B2, and each is small. The other fifteen **add**, so a later release
can carry them without the deprecation rule. Nine of the seventeen touch copied functions, where the drift rule
applies (N, B1-B6, C2, C3); six are new functions or new code (A1, A3, C1, C4, C5, C6); B7 is documentation, and A2
comes with A1. Each closed before the release adds tests to the CRAN check's time (win-builder R-devel read 398 s
against R85's 540 s, S33; R86 estimated 410-440 s on an idle machine, 480-590 s on a busy one, after 17j).

### 3.2 nprcgenekeepr's own calls into the copied code

Read by parsing nprcgenekeepr's `R/` at `eafd54851` (each top-level function's body walked for calls; scratch
`callers.R` and `callsites.R`):

- nprcgenekeepr defines 575 top-level functions. 90 of pedkindraw's 91 copied functions are among them; the 91st,
  `.conditionLegendImage()`, is pedkindraw's own addition (R81).
- **Its other 485 functions make 57 calls to 20 of the copied functions, from 27 functions in 24 files.** Twelve
  more matches were a variable or a Shiny input spelled like a function (`kinship` as a column or argument,
  `input$trimPedigree`), each read and set aside.
- **13 of the 20 are pedkindraw exports.** Called with the arguments pedkindraw takes:

  | Function | Calls | Where |
  |---|---:|---|
  | `isFounder()` | 7 | `modORIPReporting.R` (4), `modSummaryStats.R` (2), `reportGV.R` |
  | `kinship()` | 6 | `gvaConvergence.R`, `kinshipForAnimals.R`, `modBreedingGroups.R`, `modSummaryStats.R`, `reportGV.R`, `simulateKinship.R`; each passes id, sire, dam and generation by position, as pedkindraw's `kinship(id, sire, dam, pdepth)` takes them (R87 renamed them, in the same places); R92's check then applies (section 3.4) |
  | `findGeneration()` | 6 | `kinshipForAnimals.R`, `modBreedingGroups.R`, `modPedigree.R`, `modSummaryStats.R`, `qcStudbook.R`, `trimToAnalysisPopulation.R` |
  | `getFounders()` | 4 | `calcFounderContributions.R`, `calcRetention.R`, `modMarkerGenetics.R`, `orderReport.R` |
  | `correctParentSex()` | 3 | `qcStudbook.R` |
  | `addParents()`, `checkTwinRelations()`, `findPedigreeNumber()`, `makePedigreeMatingLayout()`, `drawPedigreeDiagram()` | 1 each | `qcStudbook.R`; `modPedigree.R` (the other four) |

  **Called in the order pedkindraw changed (R89):** `getProbandPedigree()` in `kinshipForAnimals.R:44`,
  `getDescendantPedigree()` in `modPedigree.R:401`, `trimPedigree()` in `modPedigree.R:399` and
  `trimToAnalysisPopulation.R:24`. Each passes the ids first and the pedigree second, by position; pedkindraw takes
  the pedigree first, so with pedkindraw's functions each stops ("$ operator is invalid for atomic vectors").
- **7 of the 20 are pedkindraw internals** (section 2), so nprcgenekeepr keeps its own copies of them or pedkindraw
  exports them: `isEmpty()` (10 calls, group formation and `convertRelationships.R`), `.escapeHtml()` (5) and
  `.checkOnClick()` (1) in `drawColonyOverview.R` (the colony overview, not copied into pedkindraw),
  `isAddedRecord()` (2, `convertDate.R`, `removeDuplicates.R`), `walkPedigree()` (2, `getLkDirectAncestors.R`,
  `getPedDirectRelatives.R`), `mzTwinGroups()` (1, `kinshipForAnimals.R`) and `.diagramHeight()` (1,
  `modPedigree.R`).
- **nprcgenekeepr exports 23 of the copied functions:** the 22 shared exports and `addIdRecords()`, which pedkindraw
  keeps internal (R90). Its own code calls 13 of the 22 (above); the other 9 (`addBackSecondParents()`,
  `getIdsWithOneParent()`, `getOffspring()`, `getParents()`, `hasBothParents()`, `makePedigreeDiagramData()`,
  `removeUninformativeFounders()`, `removeUnknownAnimals()`, `shrinkPedigree()`) only its copied code and its users
  call. It uses none of pedkindraw's 9 own exports (point 5).
- **Its tests, vignettes and scripts** (parsed the same way; `.Rmd` and `.qmd` through `knitr::purl()`; scratch
  `testcalls.R`): 80 of its own test files (those pedkindraw did not copy) make 209 calls to 13 copied functions,
  mostly `kinship()` (85) and `findGeneration()` (69) setting up other tests; the 43 test files pedkindraw copied
  make 746; 5 vignettes and articles make 40; `data-raw/` 64 in 6 files; `tools/` 56 in 8 files.

### 3.3 nprcgenekeepr's own tests with pedkindraw's functions in place of its copies

**The question (the handoff's, from Learning 17):** if nprcgenekeepr took the copied functions from pedkindraw today,
what would break? Measured on scratch copies, nothing committed:

1. pedkindraw at `f709b00` installed into a scratch library (`R CMD INSTALL`, its dependencies from nprcgenekeepr's
   renv library).
2. A copy of nprcgenekeepr at `eafd54851` with the 22 shared exports and 60 copied internals reached only through
   them deleted from its `R/` files (82 definitions in 28 files), `importFrom(pedkindraw, ...)` for the 22 added to
   `NAMESPACE` (its `export()` lines kept, so they re-export), and `pedkindraw` added to Imports. It keeps 8: the 7
   internals of section 3.2 and `addIdRecords()` (scratch `substitute.R`).
3. nprcgenekeepr's whole suite run as its `CLAUDE.md`'s "Clean regression read" does (`NOT_CRAN=true`,
   `pkgload::load_all()`, `testthat::test_dir()`), from its folder with its renv, on an unchanged copy and on the
   copy of step 2 (scratch `runtests.R`), then the failing files again to keep each failure's message
   (`rerun.R`, `classify.R`).

4. The run again on a second copy, step 2's with only the four calls of section 3.2 rewritten in pedkindraw's
   order (`getProbandPedigree(ped, ...)`, `getDescendantPedigree(ped, probands)`, `trimPedigree(ped, ...)` twice)
   and `DESCRIPTION` edited as text (step 2's `write.dcf()` had re-wrapped it, which made one wording test fail).

| Run | Files | Test blocks | Failed | Errors | Skipped | Minutes |
|---|---:|---:|---:|---:|---:|---:|
| Unchanged copy | 510 | 4,827 | 0 | 0 | 230 | 8.5 |
| pedkindraw's functions in place of the copies (step 2) | 510 | 4,771 | 69 | 434 | 230 | 6.1 |
| The same with the four calls rewritten (step 4) | 510 | 4,771 | 35 | 274 | 230 | 6.8 |

(56 fewer blocks: 12 files stop at a top-level error before some of their tests run. The two copies ran side by side,
so the times are not comparable.)

**After step 4, 48 files have a failing block: 17 of the 43 test files pedkindraw copied, and 31 of nprcgenekeepr's
own 467** (55 before the four calls were rewritten). Every failing block in nprcgenekeepr's own files, read by its
message (68 blocks; a file can have more than one cause):

| Cause | Own test files | Blocks |
|---|---:|---:|
| pedkindraw's `kinship()` stops on a generation not below a parent's (R92): `smallPed`'s stored `gen`, the simulation, a `modPedigree` test fixture with every `gen` 0, a vignette's possible parents (section 3.4) | 18 | 33 |
| The old argument order (R89), in tests (`test_rankCombined.R:278`, `test_backfillColonySnapshots.R:41`), the perf script (`tools/perf/harness.R:301`) and the vignettes the tutorial tests run: `a2interactive.Rmd`, a CRAN vignette, calls `trimPedigree(focalAnimals, breederPed)` in that order 6 times, two website articles once each | 8 | 18 |
| The tutorial's chunks, after a chunk stops (the old order above) | 1 | 7 |
| Tests of nprcgenekeepr's own source: that a function is defined in its `R/`, the clean-room record, the `@inheritParams` count, the argument names R88-R89 changed | 5 | 6 |
| R81's legend pictures (pedkindraw's legend draws a section picture for each of two or more conditions) | 1 (`test_modPedigree.R`) | 2 |
| `test_perfHarness.R` running `tools/perf/run.R` in a child process (status 1; not traced, possibly the child not finding the scratch library) | 1 | 2 |

The 17 copied test files fail in 237 blocks: 213 call pedkindraw's internal functions (the layout engine's helpers
and the structure comparison's), 9 look a name up in nprcgenekeepr's own namespace, and 15 test what pedkindraw
changed on purpose (R87-R89's argument names and order, R92's check and its messages, R81's legend). pedkindraw's
suite already carries its versions of all 43.

**What it means:**

- **Taking pedkindraw's functions works for nprcgenekeepr's code once four calls are rewritten.** Of the 55 own test
  files that failed, 24 were cured by those four lines alone. Of what is left, no failure is a shared export giving
  a different result for the same valid input: each is a change pedkindraw made on purpose (R81, R88-R89, R92), a
  test of nprcgenekeepr's own source, or the one perf test not traced.
- **R89's order is a change for nprcgenekeepr's users, not only its code.** If nprcgenekeepr re-exports pedkindraw's
  `trimPedigree()`, `getProbandPedigree()`, `getDescendantPedigree()` and `hasBothParents()`, a user's script written
  from its own vignette stops. nprcgenekeepr then needs its users told: a NEWS item, and a release with a warning
  first if it keeps its own deprecation habit (`lifecycle` is in its Imports).
- **R92's check finds nprcgenekeepr's two faults** (section 3.4): with pedkindraw's `kinship()` those calls stop
  instead of returning a wrong matrix. They must be fixed in nprcgenekeepr before it can take pedkindraw's
  `kinship()`, and they are worth fixing whatever D11 decides.
- **The 43 copied test files leave nprcgenekeepr with its copies;** their pedkindraw versions already run in
  pedkindraw's suite.

### 3.4 Two faults in nprcgenekeepr found on the way

pedkindraw's `kinship()` stops when a known parent's generation is not below its offspring's (R92, S35), since the
computation then gives a wrong matrix with no error. nprcgenekeepr's `kinship()` has no such check. Section 3.3's run
hit the check in 18 of nprcgenekeepr's own test files; two of the sources are faults in nprcgenekeepr itself, each
measured with nprcgenekeepr's own code at `eafd54851` (scratch `pdepthProbe.R`, `simProbe.R`):

1. **The dataset `smallPed` stores wrong generations.** Its `gen` column differs from `findGeneration()`'s in 8 of
   its 17 animals, and 2 animals are not below a parent. nprcgenekeepr's `kinship()` with the stored column gives 4
   of the 289 cells different from the matrix with `findGeneration()`'s, the largest by 0.25. Its other five
   datasets with a `gen` column agree with `findGeneration()` and give identical matrices: `examplePedigree` (3,694
   animals), `lacy1989Ped` (7), `pedWithGenotype` (280), `qcPed` (280), `rhesusPedigree` (375). Tests that compute
   kinship from `smallPed$gen` may hold expected values pinned to the wrong matrix (not measured which).
2. **The kinship simulation passes stale generations.** `.simulateKinship()` (nprcgenekeepr's
   `R/simulateKinship.R:25-28`) gives animals simulated parents with `makeSimPed()` and then calls `kinship()` with
   the input pedigree's `gen`, unchanged. When a simulated parent is an animal of the pedigree at the same or a later
   generation, the matrix is wrong. On the `simulatedKValues` vignette's own case (`smallPed` and its six lists of
   possible parents), 200 seeded draws: nprcgenekeepr's `kinship()` differs from kinship2's (given the same
   pedigree, with a parent that has no row read as unknown, as nprcgenekeepr reads it) in **200 of 200**, the largest
   cell by 0.375; with the generations recomputed after the draw, in **0 of 200**. Starting from `findGeneration()`'s
   generations instead of `smallPed`'s stored ones: 198 of 200, and 0 of 200. The same code is in nprcgenekeepr
   3.0.0 on CRAN (`git show v3.0.0:R/simulateKinship.R`). It is reached through the exports `createSimKinships()`
   and `cumulateSimKinships()` (and `countKinshipValues()`, `kinshipMatricesToKValues()`,
   `summarizeKinshipValues()` on their results) and that vignette; no Shiny module calls it. On real data, one of
   nprcgenekeepr's tests (`test_cranVignettesChecked.R`, "S5", possible parents from `getPotentialParents()`) gives
   a simulated sire a generation above its offspring's ("BRI2MW has 0 and its sire D0Z114 has 1"); the values there
   were not measured.

**What they mean:** a user of `createSimKinships()` in nprcgenekeepr 3.0.0 can get wrong simulated kinships with no
message, and so wrong counts and summaries built on them. pedkindraw is not affected: it has no `makeSimPed()`, and
its `kinship()` stops on such input. Both fixes are nprcgenekeepr's (recompute the generations after
`makeSimPed()`; correct `smallPed`'s `gen` and any test pinned to it), in a session Mark starts there (R8). They are
also a cost of D11's dependency: with pedkindraw's `kinship()`, these calls stop instead of answering wrongly.

### 3.5 CRAN's rules that set the order

From the CRAN Repository Policy (revision 6985, read 2026-11-18 at
<https://cran.r-project.org/web/packages/policies.html>):

- "The strong dependencies (i.e., packages listed in the 'Depends', 'Imports' or 'LinkingTo' fields) should be
  available from CRAN or the Bioconductor software repository." **So nprcgenekeepr's CRAN version cannot import
  pedkindraw until CRAN accepts pedkindraw.** This is why Mark's point 3 says "once pedkindraw is accepted by CRAN".
- Suggests may name a package from elsewhere only with "an 'Additional_repositories' field", and it "should be used
  conditionally". Code nprcgenekeepr's app needs on every run cannot sit behind a Suggests.
- "CRAN versions of packages should work with the current CRAN and Bioconductor releases of packages they depend on
  and not anticipate nor recommend development versions of such packages". **So nprcgenekeepr's CRAN version works
  with pedkindraw's CRAN version**, not with its GitHub tree.
- Before an update, a maintainer checks "that packages depending on this one still pass R CMD check", and when one
  breaks, contacts its maintainer and gives "at least 2 weeks" before submitting. Mark maintains both, so the notice
  is to himself, but **every pedkindraw release must then pass nprcgenekeepr's check.**
- Updates: "no more than every 1–2 months" once a package is established. **A fix nprcgenekeepr needs from
  pedkindraw waits for a pedkindraw release on that pace.**
- `:::` to another package's internals gives the `R CMD check` NOTE of section 2, so nprcgenekeepr keeps its own copy
  of each internal it calls (section 3.2's seven) unless pedkindraw exports it.

**Dependencies:** pedkindraw imports `data.table`, `Matrix`, `methods`, `quadprog`, `stats`, `utils` and
`visNetwork`; nprcgenekeepr already imports all of them but `stats`, which comes with R. So importing pedkindraw adds
no new package to install for nprcgenekeepr's users.

### 3.6 The pace of each repository (for D13)

- **nprcgenekeepr:** 521 commits from 2026-11-01, the day 3.0.0 reached CRAN, to its S1188 claim on 2026-11-18;
  it reads 3.0.0.9000. Its `ROADMAP.md` and `BACKLOG.md` name no next CRAN release. 4 of its commits since the
  copy commit `baef1e12c` touched copied files: `471589138` (S1153), inside Phase 9's copy (R34), and S1159's
  three, ported by pedkindraw S12 (R37); none since.
- **pedkindraw:** Phase 17 has 17g-17q left, about 14-17 sessions by its session map's guesses
  (`docs/planning/cran-submission-plan.md` section 8), and whatever D4 adds; then CRAN's review. pedkindraw made 14
  of the copied functions differ from nprcgenekeepr's: 9 by the name rulings R87-R89 and R92 (17c), the rest by
  Phase 15's hints and the drawing fixes R81, R94 and R95.
- **The ports waiting in nprcgenekeepr** (`methodology/BACKLOG.md`, three BLOCKED items): R81's legend pictures,
  R94's `__jog_` prefix and R95's legend lines; and the `DIVERGENCE.md` rows for R87-R89 and R92 each say "Not yet
  made in nprcgenekeepr". nprcgenekeepr's own backlog still lists S1159's legend fill as "Not yet mirrored", though
  pedkindraw S12 ported it (`docs/planning/cran-submission-plan.md` section 4.2).

---

## 4. Decisions (Mark's picks, S41; rulings R97-R101)

Each was put to Mark by a picker in plain words, after sections 1-3 were committed (`5bebd3c`) for him to read. The
rulings are copied into section 2 of `docs/planning/standalone-pedigree-package-plan.md`.

| Ruling | Decision | Mark's pick | What it decides |
|---|---|---|---|
| R97 | D4 | "All before release (Recommended)" | Every row of section 3.1 is closed before the first CRAN release, where possible, in this order: N and B2 (the two that change behaviour); the size-S additions B6, B5's colours, C4, C5, C6, C2, B7; the M additions C3, C1, B4, B3's marks, B5's sizes and spacing; the L additions B1, A1 with A2, and A3, each starting with a planning session of its own. Not possible, as measured in the gaps document: A2 inside the browser (ids would be drawn under a pixel tall; A2 closes through A1's files) and B3's "asymptomatic" mark (Pedixplorer itself stops when the column is given). These are phases G1-G17 (section 5.1), before 17g. An L row whose own plan finds it far larger may move after the release by a ruling then. |
| R98 | D11 | "Name calls now, switch later (Recommended)" | nprcgenekeepr comes to use pedkindraw's functions. **Now**, in a session there (N2), it writes its calls to the functions whose argument order pedkindraw changed (R89) with named arguments, wherever they are called, so each runs with its own copies and with pedkindraw's. Its copies stay as they are, and pedkindraw's changes to copied functions are not ported into them: each stays a `DIVERGENCE.md` row marked "at the switch". **After CRAN accepts pedkindraw** (N3), nprcgenekeepr imports it, deletes its 82 copied definitions and 43 copied test files, and re-exports (R100), in a release with a NEWS item for its users. This is the decision R8 left to Mark ("until Mark later decides to have it use the new package"), and it schedules the standalone plan's "Later, optional". It replaces "port later" for R81, R94, R95 and the name rulings R87-R89 and R92. |
| R99 | The two faults (section 3.4) | "Next nprcgenekeepr session (Recommended)" | The next nprcgenekeepr work Mark starts (N1), ahead of R98's steps: `.simulateKinship()` recomputes the generations after `makeSimPed()`; `smallPed`'s `gen` is corrected, with any test pinned to it; a NEWS item, since 3.0.0's simulated kinships can be wrong. |
| R100 | D12 | "Re-export all 22 (Recommended)" | At the switch nprcgenekeepr imports the 22 shared exports (its code calls 13) and re-exports all 22, so its users' scripts keep the names, each now pedkindraw's function (NEWS tells them of R87-R89's names and order and R92's check). It keeps its own copies of the 7 internals it calls (`isEmpty()`, `isAddedRecord()`, `walkPedigree()`, `mzTwinGroups()`, `.escapeHtml()`, `.checkOnClick()`, `.diagramHeight()`) and of `addIdRecords()` (internal in pedkindraw, R90). It does not re-export pedkindraw's 9 own exports (point 5: it does not need them). |
| R101 | D13 | "pedkindraw leads shared code (Recommended)" | Until the switch, a change to any of the 91 copied functions starts in pedkindraw. nprcgenekeepr does not change its copies of them, except a fix its users need before the switch, ported from pedkindraw in a session of its own that Mark decides on. Its other work goes on (the app, the colony tools, N1 and N2). pedkindraw's Orient keeps the drift tool and Learning 15's log, and reports to Mark any nprcgenekeepr commit to a copied file as a departure from this rule. nprcgenekeepr's drift-watch backlog item is reworded to this rule, and its stale S1159 line removed, in N2. |

The clarifications before R97, in Mark's words: "I do not see how this picker's options map to the
maps-and-shared-code-plan. Clarify" (the first two pickers offered sets of rows without naming them, and left the M
and L rows in no option), then "The last four rows do not seem to be covered. I have not seen a reason to not close
all gaps." The third picker named each option's rows, gave the reasons against closing all (time, a later CRAN
answer, more drift, check time, the app's `shiny`) with the measured pace of 4.6 sessions a day (41 sessions,
2026-11-10 to 2026-11-18), and offered "All before release".

**What R98 and R101 change in the drift rule** (standalone plan section 5): until the switch, a change pedkindraw makes
to a copied function is recorded as a `DIVERGENCE.md` row ("at the switch") and is not ported; nprcgenekeepr makes
no change to its copies (R101's exception aside). At the switch every row goes, since nprcgenekeepr then has no
copies. If CRAN does not accept pedkindraw, N3 does not happen: nprcgenekeepr keeps its copies with its named calls
(which work either way), the rows stay, and Mark decides then between two copies for good (R8's state) and a new
submission.

---

## 5. Phases

### 5.1 pedkindraw: the gap phases G1-G17 (R97), before 17g

**Every G phase:**

- **Process:** strict TDD (`CLAUDE.md`), its three gates put to Mark by picker; a pre-RED picker for the phase's
  choices (named in the table), each option measured on a scratch copy first (Learning 17); every expected value
  computed with the reference package where it does the same thing, run on typed, fixture and seeded random cases
  under a time limit (Learnings 18-21).
- **DONE, common:** the full suite 0 failed, WARN 0; `lintr::lint_package()` 0; `roxygen2::roxygenise()` leaves
  `NAMESPACE` and `man/` unchanged; `covr` reaches every new statement; `R CMD check --as-cran` R16's NOTE only;
  a NEWS bullet; the contract's section 4 gains any new export or argument. In copied code: a `DIVERGENCE.md` row
  marked "at the switch" (R98) and the drift tool exit 0; the fidelity tool against nprcgenekeepr exit 0, with
  **600 of 600 identical for an addition** (its default must leave every case as it was, which is the check that it
  only adds) or one new, counted set-aside for a change (as R81, R94 and R95 have).
- **Commands:** `CLAUDE.md`'s Build / Test / Verify table; `Rscript tools/compareWithNprcgenekeepr.R ../nprcgenekeepr`;
  `Rscript tools/compareResultsWithNprcgenekeepr.R ../nprcgenekeepr`; the gap's case,
  `Rscript tools/gapCases.R <case>`.
- **Surface:** this Mac; headless Chrome (chromote) for anything drawn, measured from vis.js rather than a screenshot
  (plan dragon 25 of `docs/planning/cran-submission-plan.md`); GitHub Actions after the push. kinship2 and
  Pedixplorer are compared only where each returns (Learning 19).
- **Session boundary:** each G phase is its own session or sessions, as the table says (a guess); close out when its
  DONE is met.

| Phase | Gap | Work | DONE, the phase's own (its case in `tools/gapCases.R`) | Choices at its pre-RED picker | Sessions (a guess) |
|---|---|---|---|---|---|
| G1 | N | A condition column that is not true-or-false is reported at both places it is read (`R/makePedigreeDiagramData.R:117`, `:1913`), naming the column | `measuredTrait`: the numbers 2.5, 0, 0.3, 9 give the message; true, false and `NA` columns draw as before (fidelity 600 of 600) | a warning or a stop; whether 0 and 1 count as true-or-false. Found at close-out (S41): `asPedFrame()` passes kinship2's 0/1 `affected` values through unchanged (`R/asPedFrame.R:255-262`), so 0 and 1 must stay accepted or pedkindraw would refuse its own converter's output; and the `as.logical()` reading was chosen on purpose in nprcgenekeepr's issue #133, so that a CSV's text "TRUE" and "FALSE" read (the comment at `R/makePedigreeDiagramData.R:109`) | 1 |
| G2 | B2 | An unknown affected status (`NA`) gets its own look, in one-condition and several-condition symbols, and a legend row when any animal has it | `unknownAffected`: B's fill differs from C's in headless Chrome and the legend has the row; the drawings with an `NA` status counted as a set-aside | grey fill (Pedixplorer) or a "?" (kinship2); the legend's words | 1-2 |
| G3 | B6 | The 15-character limit on the notes under an id becomes an argument (`.nameLabelCharBudget`, `:240`) | `labels`: the 26-character note written whole when asked; default 15 (600 of 600) | the argument's name and which function takes it; a value for "no limit" | 1 |
| G4 | B5 colours | A colours argument carried to the fills, the sections script and the legend, so all three agree (the gaps document's section 9, item 2) | `style`: chosen colours in fills, sections and legend, read in headless Chrome; default unchanged (600 of 600) | which function takes it; how colours are checked | 1 |
| G5 | C4 | A function that rewrites missing-parent codes ("0", "") and sex codes (1/2, male/female, m/f) into pedkindraw's (`NA`, "M", "F") | `inputCodes`: afterwards `checkPedigree()` reports no such code, `findGeneration()` places all 4 animals, no diamond is drawn; sex codes read as nprcgenekeepr's `convertSexCodes()` reads them | its name; which codes by default; "0" read as missing only when asked (an animal may be named "0") | 1 |
| G6 | C5 | Each animal's offspring count, and its mates | `lookups`: counts 2, 2, 0, 0, as Pedixplorer's; mates checked against the fixture pedigrees | names; one function or two | 1 |
| G7 | C6 | A function that removes listed animals and clears their offspring's links to them | `removeAnimals`: C removed, F's and G's sire cleared, `kinship()` then computes (F with G 0.125); compared with Pedixplorer's `subset(del_parents = "one")`, which also clears the other parent | clear the one link, or both as Pedixplorer does | 1 |
| G8 | C2 | `findGeneration()` gains aligned generations, written from the method kinship2 describes (R11) | `alignedDepth`: equal to kinship2's `kindepth(align = TRUE)` on sample family 1 (6 of 41 differ from plain) and on every fixture pedigree where kinship2 returns; default unchanged (600 of 600). S49, R123: "on every fixture" became the measured counts (equal on 2 of the 7 fixtures and 73 of 100 random; at most 93 of 5,004 animals different on the other 5), kinship2's own answer depending on the order of the rows | the argument's name | 1 |
| G9 | B7 | A documented example: the pedigree drawn with the animals `shrinkPedigree()` removed marked, from `idTrimmed` | `shrinkPicture`: the example runs and the removed animals are marked in the drawing. S50, R125: kinship2's `plot.pedigree.shrink()` draws only the animals kept (18 of 41), not the removed ones marked as B7 says; the help example draws all 7, the 3 removed filled, and a test runs it (R126) | a help example or a vignette section | 1 |
| G10 | C3 | `makePedigreeMatingLayout()` returns the hints it used (`:1836`, `:2219`), in the form it takes (`R/layoutHints.R`) | `ownHints`: the returned hints, passed back, give the same positions; the new list element counted as a set-aside. S51, R127-R128: the element `hints`; `order` by row, founders only where an order hint named them, and `mate` rows except for an animal with three or more matings or one the given rows place, both measured as the only forms that pass back the same layout; on sample family 1, 29 numbers and 11 rows, passed back identical; set aside in 72 of the 600 results (the row's `:1836` and `:2219` were S41's lines: the returns are now at the end of `makePedigreeMatingLayout()`) | the element's name; order hints only, or mate hints too | 1 (S51) |
| G11 | C1 | A function that keeps the relatives within k steps of chosen animals, its rule written from Pedixplorer's help and measured results (as R52) | `distanceSubset`: 14, 30 and 33 of 41 kept for k = 1, 2, 3, as Pedixplorer's `useful_inds()`, or a measured, stated difference; seeded random cases compared (Learnings 19-21). S52, R129-R130: `getNearRelativePedigree(ped, probands, maxDist)`; distance `log2(1 / kinship)`, and each parent of an animal within it whose own and its mates' offspring number two or more (`num_child_tot`): the same animals as `useful_inds(max_dist = )` in 1,980 of 1,980 runs, 14, 30 and 33 on the case; probands named by id | its name; what "informative" means by default (S52 also asked the rule: Pedixplorer's, over every parent kept or within distance only) | 1 (S52) |
| G12 | B4 | A measured trait drawn by a threshold, with the rule in the legend; builds on G1 | `measuredTrait`: at threshold 5, A, B, C unaffected and D affected; the legend states the rule. S53, R131-R132: `conditionThresholds` in both builders, each cut-off a comparison the user writes (`>`, `>=`, `<`, `<=`) and a number; A, B, C white and D pink, the legend row "Affected (> 5)" (`>=` and `<=` as the signs), the tooltip "Yes (9)"; `>` and `<` as Pedixplorer's `generate_aff_inds()` in 250 seeded comparisons | threshold argument or a colour scale; above or at-and-above (S53 also asked the legend's words and the argument's name and functions) | 1 (S53) |
| G13 | B3 | Pedixplorer's marks: carrier, proband, consultand, evaluated, genotyped border, infertile, miscarriage; each a column read by the layout, a mark drawn, a legend row | `markings`: each mark drawn and in the legend, read in headless Chrome; no column, no change (600 of 600) | which marks first (the genotyped border is the colony's), their shapes; the phase's session count. S54, R133-R134: all seven, the genotyped mark first, then carrier, proband with consultand, evaluated, infertile, miscarriage, one kind a session; the genotyped mark DONE: a column `genotyped` (Pedixplorer's `avail` would change 10 of samplePed's 50 compared results), the outline 4 px wide (in headless Chrome at 500 px 621-679 pixels changed per animal with one condition, 339-540 with three, 299-613 in greyscale; Pedixplorer's green 0 in greyscale), `NA` unmarked, a "Genotyped" legend row; the gap case reads 4 / 1 / 4 / 1. Measured too: Pedixplorer's legend shows only the border; its miscarriage triangle is pedkindraw's "Unknown" sex; its infertile bars sit where pedkindraw writes the id. S55, R135: the carrier mark DONE: a column `carrier` (Pedixplorer's name; none of the compared CSVs holds it; `asPedFrame()` keeps it when it holds anything besides `NA`), a black dot at the symbol's centre, its radius 0.24 of the symbol's size, painted after the deceased slash (in headless Chrome at 500 px 67-82 pixels changed per carrier on white, on pink, where three conditions' sections meet and under the slash, the same in greyscale; Pedixplorer's size, 0.14, 22-29 and nearly hidden under the slash; a white ring cut the slash), `NA` unmarked, a "Carrier" legend row; the gap case reads TRUE / FALSE / FALSE / FALSE and "Carrier image"; the REFACTOR moved the column reader and the node lookup to `R/markColumns.R` (`.readMarkColumn()`, `.markedNodes()`) for the four marks left. S56, R136: the proband and consultand marks DONE: columns `proband` and `consultand` (Pedixplorer's names; none of the compared CSVs holds them; `asPedFrame()` keeps them), a black arrow rising at 30 degrees to just outside the lower-left corner of the symbol's square, "P" left of a proband's tail (in headless Chrome at 500 px 46-92 pixels per animal and none over the outline, the slash, a line or an id label; Pedixplorer's 45 degrees runs along the slash and over a 10-character id's label), invisible size-0 points `__mark_<id>` so vis.js's fit takes each arrow in (the leftmost "P" 10 px outside the canvas without them, 19 px inside with), an animal marked both stops (as in Pedixplorer), `NA` unmarked, a "Proband" and a "Consultand" legend row; the gap case reads `FALSE` / `FALSE` / `TRUE` / `FALSE` and `FALSE` / `FALSE` / `FALSE` / `TRUE`; the REFACTOR built the legend's picture rows with `.markLegendRow()`. S57, R137: the evaluated mark DONE: a column `evaluated` (Pedixplorer's name; none of the compared CSVs holds it; `asPedFrame()` keeps it), a black star (three strokes) to the right of the upper-right corner of the symbol's square (in headless Chrome at 500 px on 8 pedigrees, the star drawn red: 0 pixels over ink in the rectilinear style, 2 on a direct-style line to a twin far left of its mating; Pedixplorer's place, just outside the corner, 4-7 on every deceased square's slash end), invisible points `__eval_<id>` so vis.js's fit takes each star in (the rightmost 2 px outside the canvas without them, 17 px inside with), `NA` unmarked, an "Evaluated" legend row, the star alone (32 dark pixels); the gap case reads `TRUE` / `FALSE` / `FALSE` / `FALSE`; the REFACTOR built the invisible points with `.markRoom()`. S58, R138: the infertile mark DONE: a column `fertility` (Pedixplorer's name and three values; none of the compared CSVs holds it; `asPedFrame()` returns it as a factor), Pedixplorer's line and two bars (one for "infertile_choice_na", no offspring by choice or for an unknown reason) under the symbol, the id moved 14 units down below them (in headless Chrome at 500 px on 7 pedigrees, the mark drawn red: 0 pixels on anything else for an animal without offspring in both edge styles, 2-6 px clear of its own id; Pedixplorer's place with the id kept 1-23 on the id), an infertile parent drawn as recorded (Pedixplorer refuses it), invisible points `__fert_<id>` below each moved id (the bottom id cut by 1.5 px without them, 25.5 px inside with, measured to the widget's box: the canvas reaches 5.5 px past it), `NA` unmarked, "Infertile" and "No offspring" legend rows, the mark alone; the gap case reads "" / "" / "infertile" / "" and "Infertile image TRUE __fert_C"; the REFACTOR shared the bad-values text and the node-to-animal lookup (`.oddValuesShown()`, `.nodeAnimals()`). S59, R139: the miscarriage mark DONE: a column `miscarriage` (Pedixplorer's name and values, SAB, TOP, ECT and none, read without spaces and in any case, also the right spelling "spontaneous abortion", which Pedixplorer reads as none; none of the compared CSVs holds it; `asPedFrame()` returns it as a factor), a triangle 0.6 the size of the symbol it replaces, since a full-size triangle is pedkindraw's Unknown sex (29 by 25 px against 48 by 41 at 500 px), Pedixplorer's line from its lower-left to its upper-right corner for a termination and an ectopic pregnancy and "ECT" under the latter's, the id moved 12 units down into its row, no deceased slash, which lies along the line on the small triangle (in headless Chrome at 500 px on 7 pedigrees, 31 marked animals, in both edge styles, the line and "ECT" drawn red: 0 px on anything else, "ECT" 6-12 px from its id; Pedixplorer's full-size triangle is the Unknown sex's), two invisible points per miscarriage `__misc_l_<id>` and `__misc_r_<id>` at a full-size triangle's lower corners (the 10-character ids at the edges cut by 6 px without them, 7 px inside with; the bottom moved id cut by 5, 16 inside), a miscarriage that is a parent or has a fertility mark stopping (Pedixplorer refuses both), `NA` unmarked, "Miscarriage", "Termination" and "Ectopic" legend rows, the small triangle; the gap case reads "" / "" / "SAB" / "" and "Miscarriage image triangle 15 __misc_l_C __misc_r_C"; the REFACTOR shared the reader of a column of words and the naming of up to five animals (`.readWordColumn()`, `.idsShown()`). G13 DONE | 8-9; R133: 6, DONE in 6 (S54 the first, S55 the second, S56 the third, S57 the fourth, S58 the fifth, S59 the sixth) |
| G14 | B5 sizes | Symbol and text sizes, and spacing, as arguments | `style`: each setting measured in headless Chrome; defaults unchanged (600 of 600). S60, R140: four settings, the symbol size, the text size, the column and row spacing and the line width, each a multiple of today's in `makePedigreeMatingLayout()`, one positive number with no upper limit; hatching, the legend's sizes and kinship2's layout settings left out; one setting a session. Measured first (headless Chrome at 500 px, 7 pedigrees, both edge styles, all seven marks on): only proportions matter, since the drawing zooms to fit; the symbol size must be known by the layout (66-129 of rhesus375's arcs differ when it is not); the moved ids must follow it (8-85 px over the marks at 1.6 when fixed); smaller symbols and larger text cut the long ids at the edges (4-5 px at symbol 0.6, 8-10 at text 20); from 2.0 symbols reach lines and mating points. The symbol size DONE (S60): `symbolSize = 1`, each animal's node 25 times it units, rounded, the moved ids in proportion, below full size two invisible points per animal (`__size_`) keeping today's room; the case reads kinship2's `boxw` 0.031 / 0.052 / 0.086 and pedkindraw's sizes 15 / 25 / 40 at 0.6, 1, 1.6 | which settings (S60: R140) | 2-3; R140: 3, 1 done (S60) |
| G15 | B1 | **A planning session first** (the layout builds every mating from shared offspring, `.buildMatingUnitForest()`, `R/makePedigreeDiagramData.R:454`), then its build sessions | its plan's; `matesNoOffspring`: E and F drawn as a mating, not isolated | its plan's | 1 + 3-5 |
| G16 | A1, A2 | **A planning session first** (a renderer with R graphics from the layout, or a headless-browser picture; which file types), then its build sessions | its plan's; `files`: a PDF, SVG and PNG written by a script; `largeIds`: the 375 ids of the rhesus pedigree in one PDF page, counted as for kinship2 | its plan's | 1 + 3-6 |
| G17 | A3 | **A planning session first** (what the app does, `shiny` in Suggests or Imports, its tests' CRAN time), then its build sessions | its plan's; `app`: the app builds and starts | its plan's | 1 + 4-8 |

**Before G1:** the numeric-condition item and the gaps are already in `methodology/BACKLOG.md`; each G phase removes
its item when done. The order may change by ruling, but G1 comes before G12 (G12 builds on it).

### 5.2 nprcgenekeepr: N1-N3 (R98-R100), sessions Mark starts there

Each runs under nprcgenekeepr's own `CLAUDE.md`, protocol and TDD gates; its commands are its own ("Clean regression
read", `devtools::check()`, its E2E tests, its workflows). pedkindraw's sessions do not make them (R8).

| Phase | Work | DONE | Needs first | Sessions (a guess) |
|---|---|---|---|---|
| N1 (R99) | `.simulateKinship()` (`R/simulateKinship.R:25-28` at `eafd54851`) recomputes the generations of the simulated pedigree, a parent with no row read as unknown, before `kinship()`; `smallPed`'s `gen` corrected (8 of 17 animals), with the tests pinned to it; NEWS | section 3.4's simulation case: 0 of 200 draws differ from kinship2; `smallPed$gen` equals `findGeneration()` in 17 of 17; its clean regression read 0 failed, 0 errors; `devtools::check()` 0/0/0 | nothing | 1 |
| N2 (R98, R101) | Inventory by parse (as section 3.2's scratch `callsites.R` did) every call to the functions R88-R89 changed, outside its copied code: in `R/`, tests, `tools/`, vignettes, articles and `data-raw/`. Write R89's four (`getProbandPedigree()`, `getDescendantPedigree()`, `trimPedigree()`, `hasBothParents()`) with named arguments, since their names are the same in both packages and their order is not; leave R88's (`getParents()`, `getOffspring()`, `getIdsWithOneParent()`, `addBackSecondParents()`) positional, since their positions are the same and their names are not. Reword the drift-watch backlog item to R101, removing the stale S1159 line | the parse finds no positional call to R89's four and no named call to R88's old names outside the copied code; section 3.3's scratch run repeated (pedkindraw installed in a scratch library) shows no failure of the argument-order cause; its suite 0 failed, 0 errors; its vignettes build | nothing (N1 first by R99) | 1 |
| N3 (R98, R100) | **After CRAN accepts pedkindraw:** `Imports: pedkindraw (>=` the accepted version`)`; `importFrom()` for the 22 and a re-exports help page; the 82 copied definitions and 43 copied test files deleted (the 8 of R100 kept); its pkgdown reference and README; NEWS for its users (R87-R89's names and order, R92's check, R81, R94 and R95's drawing changes, and what G1-G17 add) | `identical(nprcgenekeepr::kinship, pedkindraw::kinship)` and the same for the other 21; its suite 0 failed, 0 errors; `R CMD check --as-cran` 0/0/0; its E2E tests; all its workflows green; its next CRAN submission names the new dependency | 17q (acceptance) | 2 |

**After N1, in pedkindraw:** its own `tests/testthat/fixtures/smallPed.rds` has the same 8 of 17 wrong (measured
S41); S35 made the one test that used its `gen` compute it with `findGeneration()`. Correct the fixture to
nprcgenekeepr's corrected dataset (a backlog item; the fixture's provenance is R21's).

### 5.3 pedkindraw after the switch: P1

- **Work:** retire `tools/compareWithNprcgenekeepr.R` and `tools/compareResultsWithNprcgenekeepr.R` (nprcgenekeepr
  then has no copies to compare); empty `DIVERGENCE.md` of the rows marked "at the switch", keeping its history; close
  the BLOCKED backlog items; README and NEWS say nprcgenekeepr uses pedkindraw; every later pedkindraw release checks
  nprcgenekeepr as a reverse dependency (CRAN policy, section 3.5) and allows its two weeks' notice.
- **DONE:** nothing in `tools/`, `CLAUDE.md` or the plans runs the two tools; `DIVERGENCE.md` has no open row; the
  next release plan names the reverse-dependency check. **Needs first:** N3 on CRAN. **Sessions:** 1.

---

## 6. How the two repositories keep in step (R101)

1. **The shared code is the 91 copied functions.** Until the switch a change to one starts in pedkindraw: a G phase,
   or a fix found in either repository.
2. **nprcgenekeepr does not change its copies,** except a fix its users need before the switch, ported from pedkindraw
   in a session Mark decides on. N1 and N2 do not touch the copies: N1 changes `.simulateKinship()` and a dataset,
   neither copied; N2 changes callers.
3. **pedkindraw records, nprcgenekeepr does not port:** each pedkindraw change to a copied function is a
   `DIVERGENCE.md` row marked "at the switch", and the drift tool fails without it, as now.
4. **Every pedkindraw Orient** runs the drift tool and `git -C ../nprcgenekeepr log --oneline <copy commit>..HEAD --`
   the copied files (Learning 15). A new nprcgenekeepr commit there is reported to Mark: it departs from rule 2, and
   R37 applies (a port or a row) until he rules.
5. **Releases.** nprcgenekeepr may release before the switch with N1 and N2 (Mark's choice of when; CRAN's pace is no
   more than every 1-2 months, and 3.0.0 was 2026-11-01). pedkindraw releases after G1-G17 and 17g-17q. nprcgenekeepr's
   switch release (N3) follows pedkindraw's acceptance; from then on each pedkindraw release passes nprcgenekeepr's
   check first.
6. **If CRAN does not accept pedkindraw,** N3 waits; the named calls work with nprcgenekeepr's copies; Mark decides
   between two copies for good and another submission.

---

## 7. Session order, risks, out of scope, sources

### 7.1 Session order

| Step | Repository | Work | Needs first | Sessions (a guess) |
|---|---|---|---|---|
| N1 | nprcgenekeepr | the two faults (R99) | nothing | 1 |
| N2 | nprcgenekeepr | named calls; the drift-watch item (R98, R101) | N1 | 1 |
| G1-G9 | pedkindraw | N, B2 and the size-S additions | 17f2 | 9-10 |
| G10-G14 | pedkindraw | the M additions | G9 (G12 after G1) | 16-21 |
| G15-G17 | pedkindraw | the L additions, each planned first | G14 | 13-22 |
| 17g-17q | pedkindraw | the release phases as planned | G17 | 14-17 |
| N3 | nprcgenekeepr | the switch (R98, R100) | 17q, CRAN's acceptance | 2 |
| P1 | pedkindraw | retire the drift and fidelity tools | N3 on CRAN | 1 |

N1 and N2 run whenever Mark starts them, beside the G phases (they touch no copied function). pedkindraw's sessions to
submission: about 52-70 (38-53 for G1-G17, the sum of the guesses, and 14-17 for 17g-17q); at the measured 4.6
sessions a day, about 11-15 days, an estimate.

### 7.2 Here be dragons

1. **An addition must leave the 600 fidelity cases identical.** That is the measured proof a G phase only adds; a
   difference in a phase called an addition is a defect, not a set-aside.
2. **R88's renamed arguments do not all partial-match.** `getParents(ped = x)` reaches nprcgenekeepr's `pedSourceDf`
   by partial matching (dragon 20 of the CRAN plan), but `ped` is not a prefix of `uPed`
   (`getIdsWithOneParent()`, `addBackSecondParents()`). N2 names R89's four and leaves R88's positional.
3. **nprcgenekeepr moves during a session** (Learning 15; 521 commits in 18 days). R101 makes a commit to a copied
   file there a finding for Mark, not a quiet port.
4. **The check time grows with every G phase.** 398 s on win-builder against 540 s (S33); 17k's reading after 17j
   (R86) decides what is skipped on CRAN; browser and app tests skip on CRAN already.
5. **A3 brings `shiny`:** in Suggests, every use is conditional and the noSuggests check (17l) must pass without it.
6. **kinship2 and Pedixplorer are GPL** (R11): G8's aligned generations, G11's distance rule and G12's threshold are
   written from the described method and measured results, not from their code.
7. **The sizes are guesses** from the code each gap touches; each L phase's own plan re-sizes it, and R97 lets Mark
   move an L row after the release then.
8. **A scratch substitution reads its own artifacts:** S41's first run re-wrapped `DESCRIPTION` with `write.dcf()` and
   a wording test failed; edit `DESCRIPTION` as text when repeating section 3.3.
9. **Give the reference package the same reading of the input** (section 3.4): S41's first comparison of the
   simulation with kinship2 gave the simulated parents rows in kinship2's pedigree, while nprcgenekeepr's `kinship()`
   reads a parent with no row as unknown, so even the recomputed generations "differed" in 190 of 200 draws. With
   those parents set to unknown for kinship2 too, the recomputed generations agreed in 200 of 200. Print one
   differing cell before trusting a count (two half-siblings through a made-up dam: 0.125 against 0).
10. **Find every caller of a shared check before a picker describes its reach** (S42, G1): R104's picker named the
    three functions that pass `affected` to `.checkShrinkInput()`, found by grepping for `affected`, and missed
    `bitSize()` and `findUnavailable()`, which call it with `affected = NULL` and so read the column too; GREEN 1
    made them stop, found only by grepping the check's own name (R105). Grep the name of the function you change
    (`grep -n '\.checkShrinkInput(' R/*.R`), and run each caller on the case, before the picker.
11. **Log what the code reads before a picker on its input** (S42, G1): a scratch copy that wrote each read
    column's class and values to a file, keyed by fidelity case and test file, answered "which cases have such a
    column" for all 600 cases and 707 tests in one run (about 6 minutes), and showed samplePed's text "0"/"1",
    which `as.logical()` reads as unknown; delete the scratch copy's `.Rprofile` first, or renv starts there with
    an empty library.
12. **An all-`NA` status is also "no column" and "several conditions"** (S43, G2): `makePedigreeDiagramData()` and the
    layout fill from an `affected` vector that is all `NA` when the column is absent, and the layout's is all `NA`
    with two or more conditions too, so changing how `NA` is drawn in `.affectedColor()` alone would have greyed every
    animal of every pedigree without a condition. Pass the look for `NA` from the caller, which knows whether a
    column is drawn (`unknown =`), and test "no column" and "several conditions" beside the change.
13. **A set-aside that changes a drawing's height changes it twice** (S43, G2): visNetwork keeps the height in the
    widget (`$height`) and in its data (`$x$height`); a first `withoutUnknownStatus()` lowered only the first and left
    26 drawings differing. Diff one small pedigree's results field by field (`--child` on a folder holding only
    `synthetic_300.csv`, about 13 s a run) before rerunning the whole tool; and run a set-aside that adds a legend row
    before R81's, which counts the condition rows.
14. **An edit placed by matching text lands at the first match** (S44, G3): the prototype's `perl` insert "after the
    column check" matched `.buildMatingUnitForest()`'s identical lines (now `R/makePedigreeDiagramData.R:521`; the
    same text is in `.positionMatingUnitForest()` at `:972` and in `makePedigreeMatingLayout()` at `:1839`), not the
    layout's, and only `diff` against `HEAD` showed it. Anchor a scripted edit on text that names its function (the
    `stop()` message does), count the anchor's matches first (`grep -c`), and diff every scratch edit before
    measuring with it.
15. **A new argument's default is linted** (S44, G3): `implicit_integer_linter` refuses `maxNameChars = 15`; write
    `15.0` (the same double, so `formals()` and a test comparing with `15` still agree, and the help's usage still
    reads `15`) or `15L` (an integer: change the tests to match). The fidelity cases' names have no line break, so
    a change to how a label counts lines is seen only by the tests, not by the tool's 600 cases.
16. **R's colour names are not a browser's** (S45, G4): in headless Chrome a canvas reads 516 of R's 657 colour names
    (`grDevices::colors()`) as no colour and 5 as other colours (`gray` and `grey` as `#808080`, R's `#BEBEBE`;
    `green`, `maroon`, `purple`), and an SVG fill reads them the same way. Any colour a user gives that reaches
    vis.js, an SVG legend picture or the section painter is turned into its `"#RRGGBB"` code in R first
    (`.checkConditionColors()`, `R/conditionColors.R`); G13's marks and G14's sizes and colours meet this again.
17. **Read a drawn colour with the shared reader** (S45, G4): the three browser colour tests had three copies of the
    same widget lookup and one-pixel read; S45's REFACTOR made it `.pixelReaderJs(body)` in
    `tests/testthat/helper-legendPictures.R`. Write the next browser colour test with it (and
    `.waitForLegendPictures()`); a legend section picture is read halfway out along the section's middle, at
    `0.5 * size * 22 / 25` from its centre. Two traps met in the drafts: a drawing with fewer than two conditions has
    no section painter, so a helper reading its colour list must return none rather than index an empty match; and
    `unlist()` of an empty list is `NULL`, not `character(0)`.
18. **A pedigree's sex is often a factor** (S46, G5): 5 of the 6 fixture pedigrees with a `sex` column (`qcPed`,
    `pedWithGenotype`, `rhesusPedigree`, `examplePedigree`, `qcdRhesusPed()`; not `smallPed`) hold it as a factor,
    some with an empty level `H`. A function that rewrites a column and returns the pedigree keeps a factor a factor
    by rewriting its levels (`levels(x) <- f(levels(x))` merges levels that become one value and drops one set to
    `NA`), or "a pedigree already in pedkindraw's codes comes back as it was" fails for most of them. Read each
    fixture's column classes before a help page states what comes back.
19. **Render the README from a scratch copy** (S46, G5): `rmarkdown::render("README.Rmd")` run in the repository's
    root starts through its `.Rprofile`, which activates renv and puts renv's library first, so the render loaded
    renv's installed pedkindraw (without the new export) although `R_LIBS` named a scratch library holding the
    current tree. Install the tree into a scratch library, render a copy of `README.Rmd` in a scratch copy without
    `.Rprofile` with `R_LIBS` set, check `exists("<new export>", asNamespace("pedkindraw"))` in the same call, and
    copy `README.md` back. S46's two renders agreed only because the README's chunks call no new function.
20. **Pedixplorer's `num_child()` has two faults; its `spouse()` is not a mates list** (S47, G6). Measured on 311
    pedigrees (Pedixplorer 1.8.0): `num_child_dir` is each animal's own offspring except in a pedigree where no
    sire and dam share an offspring, where it is 0 for every animal (4 of 300 random); `num_child_tot` is the
    distinct offspring of the animal and of its mates, 0 for an animal with offspring but no mate, so
    `num_child_ind` (`tot - dir`) is negative in 286 of 300 random pedigrees. Its counts are doubles, so compare
    with `as.integer()`. `spouse()` reads the drawing hints' pairs (`Hints@spouse`), not the matings. Compare a
    count with `num_child_dir` only on a pedigree with a mating (`expect_gte()` on the number compared).
21. **Source the test helpers with `TESTTHAT` set** (S47): outside a test run, `test_path()` looks for
    `tests/testthat` below the working folder unless `Sys.getenv("TESTTHAT")` is `"true"`, so
    `withr::with_dir("tests/testthat", testthat::source_test_helpers("."))` stops with "Can't find
    tests/testthat" (`helper-fixtures.R` calls `test_path()` as it loads). `Sys.setenv(TESTTHAT = "true")`,
    `setwd("tests/testthat")`, then `testthat::source_test_helpers(".", env = globalenv())`; call
    `qcdRhesusPed()` and the like from there.
22. **`$` partially matches a list's names in a scratch tally** (S47): `r$px`, unset, read `r$pxIndNonZero`, and
    the tally said Pedixplorer "failed in 300 of 300" while the counts beside it showed it had run. Use `[[ ]]` for
    a name that may be absent, and read each tally against the others before a picker quotes it.
23. **kinship2's `pedigree.trim()` refuses most removals and mishandles an absent id** (S48, G7; kinship2 1.9.6.2).
    It stops ("A subpedigree cannot choose only one parent of a subject") whenever a kept animal would keep one
    parent: 151 of the 156 pedigrees it built (fixture and seeded random), a tenth of their animals and one parent
    removed. Compare with it only on removals closed under mates (`withMates()` in
    `tests/testthat/helper-removeAnimals.R`: each removed animal's mates removed too), where it returned on 105 of
    107 (the other two it would not build). Given an id it lacks, `pedigree.trim("Z", ped)` returns a
    one-animal pedigree whose id is `NA` and which is its own parent (`findex` and `mindex` 1); `c("I", "Z")` stops
    ("only 0's may be mixed with negative subscripts"). Its `pedigree()` takes a sex vector one per animal; a
    single 3 for a pedigree without `sex` stops ("Mismatched lengths").
24. **Pedixplorer's `Pedigree()` returns a data frame, not an object, when it finds a problem** (S48, G7;
    Pedixplorer 1.8.0): the input with an `error` column ("one-parent-missing" for all 150 seeded pedigrees with an
    animal of one known parent), with the warning "The Pedigree informations are not valid"; read `is.data.frame()`
    before using it. `subset()` runs `fix_parents()` again, which warns "More than 25% of the gender values are
    'unknown'" on a pedigree without `sex`; muffle only those two messages (`quietPedixplorer()`), never all
    warnings. `subset(del_parents = "one")` clears both parents of any animal missing either; `NULL` and `"both"`
    put a removed parent back as a founder (`fix_parents()` adds a row for every parent named without one).
25. **kinship2's `kindepth(align = TRUE)` depends on the order of the rows and misplaces one-parent offspring** (S49,
    G8; kinship2 1.9.6.2). Reversing the rows changed its answer on 4 of the 8 fixture pedigrees (sample family 1
    and the 7) and on 54 of 96 seeded random ones where an animal may have one parent; on those 96 it put an
    offspring level with or above a parent 443 times, and on 4 more it stopped ("You found a bug in kindepth's
    alignment code!"). Called on `id`, `dad.id` and `mom.id` vectors it returns on one-parent pedigrees and on
    lacy1989Ped, which its `pedigree()` refuses (dragon 23). To find a rule from its results, shrink a differing
    pedigree mechanically (`tests/testthat/helper-findGenerationAligned.R`'s typed pedigrees came from that), but
    keep both parents or neither when removing an animal (removing one parent makes the one-parent case above),
    and shrink while one named animal still differs: "any difference" can land on another discrepancy than the
    full pedigree's, as it did twice.
26. **Helpers load alphabetically and a later one with the same name wins** (S49): a new
    `kinship2SampleFamily()` in `helper-findGenerationAligned.R` was replaced by `helper-findUnrelated.R`'s, which
    returns a list, so the draft tests read an empty pedigree (caught on the prototype before RED); had the order
    been reversed, `test_findUnrelated.R` would have broken. Before naming a helper, `grep -n '^<name> <- '
    tests/testthat/*.R`.
27. **A slow version written by name can be too slow for examplePedigree** (S49): `alignedGenerationsSlow()` took
    397 s on its 3,694 animals (0.6 s on 375), so its comparison leaves that pedigree out; the first draft run hit
    a 10-minute limit before that was found. Time the slow version on each fixture before RED. Sort text with
    `order(..., method = "radix")`, as `.alignGenerations()` does: the default order follows the locale, which a
    CRAN machine may not share.
28. **A test of a help example reads the example itself, from where the help is** (S50, G9): `R CMD check` runs the
    tests in `pedkindraw.Rcheck/tests/testthat`, where there is no `man/`, so a reader of the source Rd alone (as
    nprcgenekeepr's help tests are) skips there. `helpExampleCode()` (`tests/testthat/helper-helpExample.R`) falls
    back to the installed help (`tools::Rd_db()`), and the 4 G9 tests ran inside the check. Evaluate the code in
    `new.env(parent = globalenv())`, as `example()` does, so it sees only what a user sees. The layout draws no
    animal without a parent, mate or offspring (`isolatedIds`), so a fill looked up per id can be `NA`: sample
    family 1's 113 (removed by shrinking) is not drawn; compare with `!is.na(fill) & fill == ...`.
29. **Wait on a run's own end, not on a word it may print** (S50): a loop `until grep -q "real\|total" <log>` ended
    while the suite still ran, because two tests print "on the real fixture", and `roxygenise()` then ran beside
    the suite (FM #29; it changed nothing). Wait for the background task's notice, or on a line only the shell's
    `time` writes (`grep -q "cpu .* total$"`).
30. **A round trip passes in silence when the thing passed back is missing** (S51, G10): on the old code
    `layout$hints` is `NULL`, and `makePedigreeMatingLayout(ped, hints = NULL)` gives the same layout, so every
    "passed back, the same layout" check passed in RED. The round-trip helper first expects `hints` to hold `order`
    and `mate` (`returnedAgain()`, `tests/testthat/test_layoutHintsReturned.R`). Read RED's passing checks too.
31. **Before the RED-to-GREEN gate, run the prototype through `R CMD build`, not only the suite** (S51, G10): a
    vignette checks its own words as it is built (`stopifnot()` in hidden chunks), and four such checks in
    `vignettes/drawing.Rmd` compared whole layouts; the suite on the prototype found three test checks of the same
    kind (RED 2), the build found the vignette's only at GREEN's `R CMD check` (GREEN 3, a picker). A scratch copy's
    `R CMD build` takes 15 s. grep `vignettes/` for the changed object's comparisons as well as `tests/`.
32. **A rule that fits the gap case can fit by coincidence; read the help of every quantity the reference names**
    (S52, G11): "keep a parent with two or more offspring" fitted Pedixplorer's sample family 1 at all four
    distances and 76 of 396 random pedigrees. Shrinking two misses showed the count included the mates' other
    offspring: `useful_inds()`'s help names `num_child_tot`, and `num_child()`'s help defines it (direct plus
    indirect offspring). With it, 1,980 of 1,980. Hold each candidate against every saved case (Learning 19), and
    read the help of each argument or column the reference's help names before guessing a rule.
33. **The reference package's comparison is the slowest test; time the draft file before RED** (S52, G11):
    Pedixplorer took 29 s for 500 `useful_inds()` calls, against 1 s for pedkindraw's own. Building its object
    once per case (8 s per 100 cases, 5.8 s of it the building) and comparing 50 seeded cases, not the measure's
    400, kept the file at about 10 s; the measure's counts go in the ruling, the test is the guard.
34. **Rd math gives `R CMD check --as-cran` a NOTE here** (S52, G11): `\eqn{}` in a help page makes the check try
    to render it ("Skipping checking math rendering: package 'V8' unavailable"). Write a formula as code
    (`\code{log2(1 / k)}`); found by the prototype's check before RED.
35. **The Write and Edit tools write `\u2265` as the sign itself** (S53, G12): the prototype's `"\u2265"` reached the
    file as the character, and `R CMD check --as-cran` gave a WARNING ("non-ASCII characters" in
    `R/conditionThresholds.R`; the test file too). Put a `\u` escape into R code with a script (Python with a raw
    string, or `perl -CSD -pi -e 's/\x{2265}/\\u2265/g'`), then `grep -cP "[^\x00-\x7F]"` each written file; the
    prototype's check found it before RED (dragon 31 again).
36. **Measure a legend label's room in a narrow drawing** (S53, G12): the legend's canvas is 0.28 of the drawing's
    width (269 px at the saved widget's 960 px, 140 px at 500 px), and a label wider than the widest row shrinks the
    whole legend (vis.js fits it): words for the rule shrank it 8-26% at 500 px, the signs not at all. At 500 px G2's
    "Affected status unknown" already runs 9 px past the canvas (the backlog). Set the widget's width
    (`w$width <- "500px"`) before `saveWidget()`; chromote's `setDeviceMetricsOverride()` left a saved widget at
    960 px.
37. **The fidelity tool run from a scratch copy needs renv's library given** (S53): a copy without `.Rprofile` loads
    no renv, so its pedkindraw child stopped ("The package "quadprog" is required") after nprcgenekeepr's 100 s.
    Run it with `env -u RENV_PROJECT R_LIBS=<renv lib> R_LIBS_USER=<renv lib>`: with `RENV_PROJECT` unset
    `renvFreeEnv()` passes nothing, and nprcgenekeepr's child activates its own renv in its folder.
38. **A copy of a tree taken while its suite runs holds the suite's temporary files** (S53): a copy made mid-suite
    gained an empty `tests/testthat/_snaps`. Copy from a commit (`git archive`) or after the run.
39. **The legend is drawn small, so its thin lines blur, and the shared reader has no alpha** (S54, G13): at 500 px
    the legend's scale is 0.70, and a 1 px outline there spreads over two faint pixels (alpha 110 and 247);
    `.pixelReaderJs()`'s `read()` returns the colour without alpha, so a point 1.75 units outside the Male row's
    outline read blue. Read a legend outline from inside, against the row's white fill (1.5 units in: blue in a
    4 px outline, white in a 1 px one), and the diagram's (scale 1) from outside (1.75 units: solid blue, or
    nothing). A profile across the outline with the alpha (`getImageData()` in a scratch script) tells which.
40. **Check a new column's name against the compared pedigrees** (S54, G13): nprcgenekeepr's
    `tools/pedigreeComparison/data/samplePed.csv` holds `affected`, `avail` and `famid`, and the layout cases pass
    a pedigree of 400 animals or fewer whole, so a builder reading `avail` changes 10 of samplePed's 50 results.
    Read each CSV's first line before naming a column, and count by running `runCases()` (the tool's first
    expression) on that pedigree alone with a builder wrapped to add a node column when the pedigree has the
    name: 3 s.
41. **Pedixplorer's drawing functions write `Rplots.pdf` in the folder R runs in** (S54): `ped_to_plotdf()` opens a
    graphics device, and a scratch script run from the repository's root left an empty `Rplots.pdf` there
    (untracked). Run such scripts from the scratchpad, and look at `git status` after a gap case.
42. **A scratch copy's `.Rprofile` is deleted, not skipped** (S55): with `Rscript --no-init-file` in place of
    deleting the copy's `.Rprofile` (dragon 37), the fidelity tool's nprcgenekeepr child stopped ("The package
    "openxlsx" is required") before comparing anything; deleted, with plain `Rscript` and
    `env -u RENV_PROJECT R_LIBS=<renv lib> R_LIBS_USER=<renv lib>`, it ran (600 of 600). The cause was not traced.
    `--no-init-file` is fine for a one-file test run (`pkgload::load_all()` with renv's library on `R_LIBS`).
43. **Count pixels between two drawings of the same height** (S55, G13): adding a legend row makes the canvas
    45 px taller, which shifts every symbol by part of a pixel, so 150-240 anti-aliased pixels changed around
    animals that had no mark. Measure a mark on the diagram with the height held (no legend row), and read the
    legend in a pass of its own; then the unmarked animals read 0.
44. **A mark drawn by a script is added only when some node has it** (S55, G13): the copied
    `.diagramAfterDrawing()` is every drawing's `afterDrawing` text, which the fidelity tool compares, so a
    handler added to every drawing would change all 600 results. The carrier's dot handler is passed in only when
    a node is a carrier's (`carrier = TRUE`), and without the column the text is as before. The marks to come that
    need a script (proband's arrow, evaluated's star, infertile's bars) take the same form.
45. **The shared pixel reader cannot tell black from nothing** (S56, G13): `.pixelReaderJs()`'s `read()` returns the
    canvas's r,g,b without the alpha, and the canvas is transparent where nothing is drawn, so an empty spot reads
    `0,0,0`, as a black mark does; S56's draft read "white" beside an unmarked animal, found because its black
    expectation passed there too. To tell a black mark from nothing, count near-black pixels with the alpha
    (luminance on white below 60, which also leaves out the blue lines) in a small box, as
    `tests/testthat/test_probandMark.R`'s browser test does (dragon 39's reader problem, the other way round).
46. **vis.js fits its view to the nodes only, with a twentieth of the range to spare** (S56, G13): `fit()` takes
    each node's box (its label included) and enlarges the range by 1.1, so a mark a script draws outside a node's box
    is cut off at the edge of a small drawing (the proband's "P", 35 units left of the symbol, 10 px outside the
    canvas in a six-animal drawing at 500 px). An invisible size-0 node at the mark's far end, in the layout's
    routing-point style, makes the fit take it in (`.probandArrowRoom()`); it changes the zoom only when the mark is
    near the edge (0.800 to 0.734 there). A mark drawn outside the symbol at another corner needs the same.
47. **Locate a changed pixel before calling it an overlap** (S56, G13): two drawings that differed only in the
    arrows read 6-14 "changed ink" pixels on each deceased animal in both looks; printed by position, they lay along
    the slash through the symbol's centre, its anti-aliasing differing between the two page loads (luminance 127 and
    71), not near the arrow; a whole-canvas screenshot comparison read 0. Count against a reading the change cannot
    reach (a third load of the unmarked drawing) or print where the pixels are.
48. **roxygen's markdown reads two asterisks in one paragraph as emphasis** (S57, G13): with
    `Roxygen: list(markdown = TRUE)`, GREEN 1's three `\dQuote{*}` in one help paragraph became
    `\dQuote{\emph{} to the ... \dQuote{}}` in `man/drawPedigreeDiagram.Rd`; the suite, lint and
    `R CMD check` read none of the help's words, and the prototype had it too. `\dQuote{\*}` made roxygen report
    mismatched braces and left `\*` in the other page; a code span, `` `*` ``, gives `\code{*}`, rendered `*`.
    In `NEWS.md` write `\*`. After every roxygen run that adds a symbol to the help, grep the Rd for `\emph{`
    and read it with `R CMD Rd2txt`.
49. **Measure a mark's overlap with the mark drawn in a colour of its own** (S57, G13): a whole-box difference
    between two loads counted 6-14 "over ink" pixels on deceased animals that lay along the slash through the
    symbol's centre, far from the star (dragon 47 again). Drawing the star pure red for the measure and counting
    red pixels over the unmarked drawing's ink, with the distance to the nearest ink, counts only the mark, and
    the anti-aliasing of the rest cannot reach it.
50. **The direct edge style's lines reach a child from the upper right** (S57, G13): a child left of its mating's
    point is joined by a line coming down from the upper right, at a shallower angle the farther left it is, so
    any mark at a symbol's upper right meets that line in some pedigree (the chosen place 2 px on a twin far
    left, Pedixplorer's 10). Measure an upper-right mark on a wide sibship and on twins in the direct style.
51. **A mark's invisible points need a reserved prefix of their own** (S57, G13): an id built under another
    mark's prefix (`__mark_eval_` and the node's id) can equal that mark's point for an animal whose id begins
    `eval_`, since real ids may hold any text; ids under a prefix the layout refuses (`__eval_`) cannot collide.
    Each new mark drawn outside the symbol (infertile's bars, if they need room) takes a prefix of its own in
    `.reservedIdPrefixes`, and `.markRoom()` builds its points.
52. **The canvas reaches 5.5 px below the widget's box** (S58, G13): with the "Select by id" box above it, the
    drawing's canvas runs from 35 px below the widget's top to 5.5 px past its bottom (measured in a 590 px widget:
    the widget at 40-630 in the page, the canvas at 75-635.5), so room at the bottom read against
    `cv.clientHeight` is 5.5 px too generous: S58's picker said "0.6 px to spare" for an id that was cut by 1.5 px.
    Measure bottom room against the widget's `getBoundingClientRect()`; the left and right edges are the canvas's.
53. **A mark whose node field is not TRUE or FALSE is copied onto other marks' points** (S58, G13): `.markRoom()`
    set every logical field `FALSE` on its points, so the text field `fertility` passed from a proband to its
    arrow's point, which then had bars and a point of its own (found by the draft tests on the prototype; a probe
    with an integer field counted the points too). `.markRoom()` now empties `fertility`; a later mark whose field
    is text or a number needs the same.
54. **vis.js's `font.vadjust` moves a label but not its box** (S58, G13): the label is drawn lower, but
    `labelModule.size` and `getBoundingBox()` do not change, so vis.js's fit ignores the move, and a moved id needs
    points as a mark outside the symbol does. Read a label's ink, not its box: its grey `#343434` at zoom 0.94 is not
    below luminance 60 (read text below 128), and a letter's lowest row depends on the glyph (an "F"; the gap
    between "M" and "1"), so count ink in a band.
55. **Check a look harness's geometry against the reference's numbers before measuring** (S58, G13): S58's first
    harness drew Pedixplorer's bars at half their width (Pedixplorer's proportions are of the box, twice the node's
    size, and the script halved them again); found before the prototype by recomputing each length from
    `ped_to_plotdf()`'s numbers, and re-measured. Write the reference's number beside each of the harness's.
56. **A background check's processes are named `R`, not `Rscript`** (S59): covr and a package's tests run as
    `.../exec/R`, so `ps aux | grep Rscript` read 0 while a coverage run was alive; S59 took it for dead and reran the
    suite and coverage into the same copies and logs, which lost one suite result and ran two coverage runs in one
    copy (failure mode #29). Wait for the task's notification, or `pgrep -f "package_coverage|test_local"`; never
    rerun into a copy or log a run may still hold, and give each run its own copy and its own task.
57. **A smaller node tightens vis.js's fit and cuts long ids at the edges** (S59, G13): with the miscarriage's
    triangle at 0.6 of its size, the six-animal drawing's zoom rose from 0.80 to 0.84 and a 10-character id at the
    left edge was cut by 6 px (3 px inside at full size), though `getBoundingBox()` includes the label: the fit
    leaves out a label's overhang past its node's shape (dragon 46 again). A mark that shrinks a symbol needs
    invisible points where the full-size symbol's corners are (`.miscarriageRoom()`: 7 px inside with them).
58. **Read an id's row from the side a mark's text is not on** (S59, G13): the browser test's first id measure took
    the top row of ink under the triangle and found "ECT", written between the triangle and the id (12 px off); the
    id's lowest ink in its middle, where the long ids have digits, read 0.9 px from the row. Where a mark writes text
    beside an id, read the id from its far side.
59. **The legend's thin outline is lighter than luminance 128** (S59, G13): at the legend's zoom (0.69) the small
    triangle's blue outline read 1 pixel below 128, so a "dark pixels" count could not tell it from nothing; count
    drawn ink below 200 (39, 60 and 80 px for the three pictures, 79 for the Unknown row's triangle).
60. **Set a size in the layout, not after it** (S60, G14): the rectilinear layout's detours are worked out from
    each node's `size` (a step around an animal runs `size` + 1 units below its row; a curved arc to a repeat
    appearance is bent until it clears the symbols), so a size changed in the layout's nodes afterwards leaves
    detours made for the old size: with every animal's size changed after the layout, 66-129 of rhesus375's arcs
    and smallPed's two steps differ from the layout made at that size (the direct style was unchanged). Measure a
    geometry setting both ways before choosing where it goes.
61. **vis.js's fit never zooms past 1** (S60, G14): a small drawing (three or four animals in a row) is drawn at
    its own size, zoom 1.000, so a size setting shows there whole, while a wide one is shrunk to fit, so the same
    setting changes only its proportions (the 8-sibling sibship's ids 5 px tall at 500 px). Measure a size setting
    on both kinds and read the zoom beside each reading.
62. **A "below" check passes a mutant that lands just below** (S60, G14): the browser test's first form read an
    infertile animal's moved id below its bar with the id moved its fixed 14 units at symbol size 1.6, 0.34 units
    below; the real move leaves 8.4. Give a moved label's check a floor measured on the prototype and its mutant
    (S60: at least 4 units).
63. **The id's 25-unit allowance is the text's** (S60, G14): `.infertileRoom()` and `.miscarriageRoom()` put
    their points `25 + 2` units below the moved id's place, 25 being the id label's box at the default text (about
    11 below the symbol and 14 tall), and `.symbolSizeRoom()` puts its points 25 below the centre. A text-size
    setting must scale that allowance (the S60 looks prototype used 11 plus the text size) and keep room for each
    label's ends, since vis.js's fit leaves out a label's overhang (dragon 57): at text 20 the 10-character ids at
    the edges were cut by 8-10 px.

### 7.3 Out of scope

- Any change to nprcgenekeepr from a pedkindraw session (R8): N1-N3 are nprcgenekeepr sessions.
- nprcgenekeepr's own release dates.
- What R3 (block kinship), R13 (file readers), R21 (datasets) and R7 (objects) ruled out; copying nprcgenekeepr's
  colony overview (still a decision for later, `docs/planning/cran-submission-plan.md` section 3).

### 7.4 Sources

- pedkindraw: `docs/research/pedkindraw-gaps-2026-11-18.md` and its two records; `docs/planning/cran-submission-plan.md`
  (sections 2.1, 3, 4, 6, 9); `docs/planning/standalone-pedigree-package-plan.md` (R1, R3, R7-R9, R11, R13, R21, R37,
  R52, R81, R86-R96; section 4 "Later, optional"; section 5); `docs/planning/pedkindraw-api-contract.md` (section 6);
  `docs/research/pedigree-diagram-package-split-scoping-2026-09-02.md` (section 7, the split checklist N3 follows);
  `DIVERGENCE.md`; `methodology/BACKLOG.md`; `CLAUDE.md` (Learnings 5, 6, 12, 15, 17-21).
- nprcgenekeepr at `eafd54851`, read from an archive: `R/`, `NAMESPACE`, `DESCRIPTION`, `tests/testthat/`,
  `vignettes/`, `data/`, `data-raw/`, `tools/`, `BACKLOG.md`, `methodology/ROADMAP.md`, `CLAUDE.md` (its clean
  regression read); `git show v3.0.0:R/simulateKinship.R`.
- CRAN Repository Policy, revision 6985 (read 2026-11-18); R 4.6.2's `tools:::format.check_packages_used()`.
- S41's scratch scripts (not committed; the steps of sections 3.2-3.4 say what each did): `callers.R`, `callsites.R`,
  `testcalls.R`, `substitute.R`, `runtests.R`, `rerun.R`, `classify.R`, `pdepthProbe.R`, `simProbe.R`.
