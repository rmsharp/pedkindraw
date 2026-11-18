# Plan: closing the gaps, and how pedkindraw and nprcgenekeepr share their code (Phase 17f2)

**Date:** 2026-11-18 · **Session:** pedkindraw S41 · **Type:** planning session (`methodology/SESSION_RUNNER.md`
"Planning Sessions"). No package code changed in either repository. nprcgenekeepr was read from an archive of its
commit in a scratch folder and run there with its own renv library; its folder was not changed (R8).
**Answers:** ruling R96 (Mark's direction, S40); Phase 17f2 of `docs/planning/cran-submission-plan.md`.
**Status:** sections 1-3 (the evidence) written; the decisions of section 4 are put to Mark one picker at a time.
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
