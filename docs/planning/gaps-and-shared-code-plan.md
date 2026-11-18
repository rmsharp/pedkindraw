# Plan: closing the gaps, and how pedkindraw and nprcgenekeepr share their code (Phase 17f2)

**Date:** 2026-11-18 · **Session:** pedkindraw S41 · **Type:** planning session (`methodology/SESSION_RUNNER.md`
"Planning Sessions"). No package code changed in either repository. nprcgenekeepr was read from an archive of its
commit in a scratch folder and run there with its own renv library; its folder was not changed (R8).
**Answers:** ruling R96 (Mark's direction, S40); Phase 17f2 of `docs/planning/cran-submission-plan.md`.
**Status:** complete. Mark decided D4, D11, D12 and D13 and the two nprcgenekeepr faults by picker (S41), rulings
R97-R101 (section 4). G1 DONE (pedkindraw S42; R102-R105 in the standalone plan). Next: G2 in pedkindraw (section
5.1); N1 and N2 are nprcgenekeepr sessions Mark starts (section 5.2).
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
| G8 | C2 | `findGeneration()` gains aligned generations, written from the method kinship2 describes (R11) | `alignedDepth`: equal to kinship2's `kindepth(align = TRUE)` on sample family 1 (6 of 41 differ from plain) and on every fixture pedigree where kinship2 returns; default unchanged (600 of 600) | the argument's name | 1 |
| G9 | B7 | A documented example: the pedigree drawn with the animals `shrinkPedigree()` removed marked, from `idTrimmed` | `shrinkPicture`: the example runs and the removed animals are marked in the drawing | a help example or a vignette section | 1 |
| G10 | C3 | `makePedigreeMatingLayout()` returns the hints it used (`:1836`, `:2219`), in the form it takes (`R/layoutHints.R`) | `ownHints`: the returned hints, passed back, give the same positions; the new list element counted as a set-aside | the element's name; order hints only, or mate hints too | 2-3 |
| G11 | C1 | A function that keeps the relatives within k steps of chosen animals, its rule written from Pedixplorer's help and measured results (as R52) | `distanceSubset`: 14, 30 and 33 of 41 kept for k = 1, 2, 3, as Pedixplorer's `useful_inds()`, or a measured, stated difference; seeded random cases compared (Learnings 19-21) | its name; what "informative" means by default | 2-3 |
| G12 | B4 | A measured trait drawn by a threshold, with the rule in the legend; builds on G1 | `measuredTrait`: at threshold 5, A, B, C unaffected and D affected; the legend states the rule | threshold argument or a colour scale; above or at-and-above | 2-3 |
| G13 | B3 | Pedixplorer's marks: carrier, proband, consultand, evaluated, genotyped border, infertile, miscarriage; each a column read by the layout, a mark drawn, a legend row | `markings`: each mark drawn and in the legend, read in headless Chrome; no column, no change (600 of 600) | which marks first (the genotyped border is the colony's), their shapes; the phase's session count | 8-9 |
| G14 | B5 sizes | Symbol and text sizes, and spacing, as arguments | `style`: each setting measured in headless Chrome; defaults unchanged (600 of 600) | which settings | 2-3 |
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
