# Roadmap

What pedkindraw is working toward, what it can do today and how it got here. The plan, with each phase's DONE
criteria, is `docs/planning/standalone-pedigree-package-plan.md`; open work is `methodology/BACKLOG.md`; what each
session did is `methodology/CHANGELOG.md`.

## Current Milestone

**The copy slices, plan Phases 6-10.** pedkindraw starts as a copy of nprcgenekeepr's tested code (plan R8;
nprcgenekeepr is not changed). Each slice copies one group of functions, tests first, and its results must be
identical to nprcgenekeepr's on the Phase 1 pedigrees. Why: when the five slices are done, pedkindraw computes
kinship, trims and shrinks pedigrees and draws them interactively, and the drawing is what the comparison found is
left to offer next to kinship2, Pedixplorer and ggpedigree (`docs/research/pedigree-package-comparison-2026-11.md`
section 10). All five are done (S13). The new work of Phases 11-15 has begun: Phases 11 (S14), 12 (S15-S16) and 13
(S17-S18: `checkPedigree()` and `findUnrelated()`; What's Built, below) and 14 (S19-S20: `asPedFrame()` for
kinship2 and Pedixplorer objects) are done; Phase 15, layout hints, is done: designed (S21), then 15a the order
hint, 15b the mate hint and 15c the converters passing hints on (S22-S24). Phase 16, documentation, is planned
(S25: `docs/planning/documentation-plan.md`, R77-R80); its first sessions are done, 16a, the README, NEWS and
`?pedkindraw` (S26), 16b, the getting-started vignette (S27), and 16c, the drawing vignette (S29), after the
legend item it needed (S28, R81); 16d, the speed vignette, is deferred until pedkindraw times itself (S30, R82);
and 16e, the website, is done (S31), so Phase 16 is DONE. Phase 17, the CRAN submission, is planned (S32,
`docs/planning/cran-submission-plan.md`) and under way: 17a, the check time on win-builder, is done (S33); 17b, the
argument-name review, is done (S34); 17c1, `kinship()`, is done (S35); 17c2, the pedigree argument's name, is done
(S36); 17c3, the pedigree first, is done (S37), so 17c is done; 17d, the "Select by id" fix, is done (S38); 17e,
the legend's label, is done (S39); 17f, the gaps document, is done (S40); 17f2, the plan for closing the gaps in
both repositories and coordinating them, is done (S41, `docs/planning/gaps-and-shared-code-plan.md`, R97-R101):
every gap closes before the release, phases G1-G17; G1, a number in a condition column, is done (S42, R102-R105),
G2, an unknown affected status drawn grey, is done (S43, R106-R107), G3, the 15-character limit on a name made an
argument, is done (S44, R108-R110), G4, the colours of the conditions made an argument, is done (S45, R111-R113),
G5, other ways of writing an unknown parent and a sex rewritten into pedkindraw's, is done (S46, R114-R116), G6,
each animal's offspring count and the matings, is done (S47, R117-R119), G7, removing listed animals with their
offspring's links to them, is done (S48, R120-R122), G8, aligned generations in `findGeneration()`, is done (S49,
R123-R124), G9, an example drawing the animals `shrinkPedigree()` removed, is done (S50, R125-R126), G10, the layout
returning the hints it used, is done (S51, R127-R128), G11, the relatives within a distance of chosen animals, is
done (S52, R129-R130), G12, a measured trait drawn by a cut-off, is done (S53, R131-R132), and G13, Pedixplorer's
marks, is done: the genotyped mark (S54, R133-R134), the carrier mark (S55, R135), the proband and consultand marks
(S56, R136), the evaluated mark (S57, R137), the infertile mark (S58, R138) and the miscarriage mark (S59, R139);
G14, symbol and text sizes, spacing and line width as arguments, is done: the symbol size is done (S60, R140),
the text size is done (S61, R140), the column and row spacing is done (S62, R140), and the line width is done
(S63, R140), so G14 is done in four sessions. Next is G15, mates with no offspring, its planning session first
(Planned, below).

| Phase | Slice | State |
|---|---|---|
| 6a | 10 relationship functions: generations, family ids, parents, offspring, founders, walking | DONE (pedkindraw S3) |
| 6b | 11 functions that repair and trim pedigrees, and the constant `sexCodes` (R25) | DONE (pedkindraw S7) |
| 7 | kinship and twins: `kinship()`, `checkTwinRelations()` (nprcgenekeepr's clean-room code, C2) | DONE (pedkindraw S8) |
| 8 | layout engine: `makePedigreeMatingLayout()`, `makePedigreeDiagramData()` (2 sessions, R30) | DONE (pedkindraw S9-S10) |
| 9 | renderer: `drawPedigreeDiagram()`, a `visNetwork` widget | DONE (pedkindraw S11) |
| 10 | shrink: `shrinkPedigree()` (clean-room code, C2) | DONE (pedkindraw S13) |

## Planned

Scoped in the plan (section 4) and the API contract (`docs/planning/pedkindraw-api-contract.md` section 4); one
session each unless marked. They follow the copy slices.

- **Phase 17 (under way), the CRAN submission:** planned (S32, `docs/planning/cran-submission-plan.md`, R83-R86)
  as phases 17a-17q, about 20 to 23 sessions (a guess; R93). 17a is done (S33): win-builder R-devel read 398 s,
  under the 540 s target, with its tests on an idle machine, so whether to cut tests on CRAN is decided by one more
  reading after 17j (R86). 17b is done (S34, R87-R93): `kinship()` takes `sire` and `dam`, the pedigree argument is
  `ped` and comes first in every export, `kinship()` refuses generation numbers that put a parent at or after its
  offspring, and the shared export names stay; 17c makes the changes test-first in three sessions: 17c1
  (`kinship()`) is done (S35), 17c2 (the pedigree argument's name) is done (S36), 17c3 (the pedigree first) is
  done (S37); 17d, the "Select by id" fix, is done (S38); 17e, the legend's label, is done (S39); 17f, the gaps
  document, is done (S40); 17f2 is done (S41, R97-R101): every gap closes before the release, in phases G1-G17
  (`docs/planning/gaps-and-shared-code-plan.md` section 5.1; 38-53 sessions, a guess): G1 (a number in a
  condition column stops, not drawn as affected in silence) is done (S42); G2 (an unknown affected status drawn
  grey) is done (S43); G3 (the note under an id, its 15-character limit an argument) is done (S44); G4 (a colours
  argument carried to the fills, the sections and the legend) is done (S45); G5 (other ways of writing missing
  parents and sex rewritten into pedkindraw's) is done (S46); G6 (each animal's offspring count and its mates)
  is done (S47); G7 (removing listed animals, their offspring's links to them cleared) is done (S48); G8
  (aligned generations in `findGeneration()`) is done (S49); G9 (an example marking the animals
  `shrinkPedigree()` removed) is done (S50); G10 (the layout returns the hints it used) is done (S51); G11 (the
  relatives within a distance of chosen animals) is done (S52); G12 (a measured trait drawn by a cut-off) is
  done (S53); G13 (Pedixplorer's marks) is done, the genotyped mark (S54), the carrier mark (S55), proband with
  consultand (S56), evaluated (S57), infertile (S58) and miscarriage (S59); G14 (sizes, spacing and line
  width) is done, the symbol size (S60), the text size (S61), the spacing (S62) and the line width (S63);
  then
  the medium additions and the three large ones (mates with no offspring; PDF, SVG
  and PNG files; an app), each large one planned first; then 17g-17q.
  Before the release, by Mark's picks (R84):
  the argument-name review (contract section 6; ruled S34, its changes 17c1-17c3), the "Select by id" and
  legend-label fixes, a document of what kinship2 or
  Pedixplorer can do that pedkindraw cannot, pedkindraw's own timing runs and the speed and
  size-limits vignette (R82; the draft built to R79 is on the branch `draft/speed-vignette`), and tests for full
  coverage. Then the CRAN-mode test cut if needed, hygiene and noSuggests, the release text and version, the frozen
  gate, the cross-platform runs, Mark's submission, and the steps after acceptance.
- **nprcgenekeepr uses pedkindraw (decided S41, R98-R101):** in sessions Mark starts there, nprcgenekeepr fixes two
  faults found in S41 (N1: its kinship simulation's stale generations, its `smallPed` dataset's generations), names
  its calls to the four functions whose argument order pedkindraw changed (N2), and after CRAN accepts pedkindraw
  imports it and re-exports the 22 shared functions (N3). Until then changes to the copied functions start in
  pedkindraw (`docs/planning/gaps-and-shared-code-plan.md` sections 5.2-6).

## What's Built

- **Documentation, a start (Phase 16a):** `README.md` (made from `README.Rmd`) says what the package does, how to
  install it from GitHub, and runs a 12-animal example: checked, kinship, laid out and drawn, with a picture of the
  drawing (`man/figures/README-pedigree.png`, remade by `tools/makeReadmePicture.R`) and every export named in six
  groups; `NEWS.md`; the package help page `?pedkindraw`.
- **The website (Phase 16e):** <https://rmsharp.github.io/pedkindraw/>, made by pkgdown: the README as its home
  page, the 32 help pages in `?pedkindraw`'s seven groups, the two vignettes as articles ("Get started" and
  "Drawing pedigrees") and NEWS as its changelog. A workflow rebuilds it on each push to master and puts it on the
  `gh-pages` branch, which GitHub Pages serves; `DESCRIPTION`'s `URL` and the README name it. The project's notes
  (`CLAUDE.md`, `DIVERGENCE.md`) are left off.
- **The getting-started vignette and the example pedigree (Phase 16b):** `vignette("pedkindraw")` reads the
  375-animal rhesus pedigree that ships in `inst/extdata/` (with its twins table, both from nprcgenekeepr's
  examples), checks it, numbers its generations and family trees, computes kinship, trims it to one inbred animal's
  16 ancestors and draws them, shrinks it and finds unrelated animals, and converts a kinship2 pedigree (run only
  when kinship2 is installed); a hidden check stops the build if a value its text states stops holding. knitr and
  rmarkdown in Suggests.
- **The drawing vignette (Phase 16c):** `vignette("drawing")` shows what a drawing shows and how to change it, one
  feature at a time on small pedigrees typed in the code: rows and mating dots, the sex symbols, the deceased
  slash and the legend, hover text, one condition and three as sections, twins, an animal drawn twice, a mating of
  relatives, the two edge styles, animals with no relative, the order and mate hints, kinship2 and Pedixplorer
  objects with hints, saving a drawing, clicks in Shiny, and the 375-animal pedigree as one colony-size drawing;
  11 drawings, each statement held by a hidden check.
- **Layout hints from kinship2 and Pedixplorer objects (Phase 15c), no new export:** `asPedFrame()` returns a third
  element, `hints`, the object's layout hints in `makePedigreeMatingLayout()`'s form (`order` named by id, `mate`
  rows of ids and anchor words), or `NULL`, so `makePedigreeMatingLayout(x$ped, hints = x$hints)` draws with them
  (R62, R73-R76): kinship2's `x$hints` (`order`, `spouse` by place) and Pedixplorer's `horder()` and `spouse()`;
  mate rows the layout would refuse fixed, one message naming each change (a pair with no offspring together or
  named before left out, an earlier-generation anchor set to `"either"`); unreadable kinship2 hints stop; a
  `pedigreeList`'s read as a `pedigree`'s. Three helpers in `R/layoutHints.R` (`.layoutHintTogether()`,
  `.layoutHintPairKey()`, `.layoutHintAnchorGenerations()`) give the converter and the layout's check one set of
  rules. 12 tests; 100 random pedigrees each with kinship2's `autohint()` and Pedixplorer's `auto_hint()` hints
  converted and drawn, every hinted mating on its side; rows as kinship2 (42 typed cases) and Pedixplorer (21)
  draw them where they return.
- **Layout hints, the mate (Phase 15b), no new export:** `makePedigreeMatingLayout(..., hints = list(mate = ))`,
  a data frame of `left`, `right` (a sire and dam with offspring together) and `anchor`, draws `left` left of
  `right` at their mating and hangs the offspring under the anchor, the other partner a repeat node when it has
  parents (R60-R61, R70-R73): strict checks, no anchor on the earlier-generation partner, an animal with several
  mates drawn as kinship2 draws it (its families follow its mates, same-side mates in the hint's row order).
  `R/layoutHints.R` gains `.checkLayoutHintOrder()`, `.checkLayoutHintMate()`, `.layoutHintMateRow()`,
  `.layoutHintAnchor()`, `.layoutHintMatingSides()`, `.layoutHintSides()`, `.layoutHintFamilies()`, called from a
  few lines in three copied functions (`DIVERGENCE.md`). 9 tests; on 100 seeded random pedigrees 1,090 of 1,090
  hinted sides, 197 of 197 animals' families following their mates, 2,525 of 2,525 anchor flips; kinship2's rows
  on 22 typed cases. Without hints the layout is nprcgenekeepr's (600 of 600 results identical).
- **Layout hints, the order (Phase 15a), no new export:** `makePedigreeMatingLayout(..., hints = list(order = ))`,
  a number per animal named by id, draws siblings, separate families and founder couples left to right in the
  order of the numbers (R60-R61, R64-R68): animals it does not name keep their rows, equal numbers keep row order,
  a founder couple is placed by its female's number, the founder-reordering step is skipped in a family whose
  founders it names, twins are drawn as ordered; strict checks. pedkindraw's own `R/layoutHints.R`
  (`.checkLayoutHints()`, `.layoutHintRows()`, `.layoutHintKeepsRoots()`, `.layoutHintRoots()`,
  `.layoutHintPlaces()`), called from a few lines in two copied functions (`DIVERGENCE.md`). 12 tests; on 100 seeded
  random pedigrees 4,670 of 4,670 sibships and 201 of 201 families' founder lines in hinted order; kinship2's rows
  on the typed cases (R69). Without hints the layout is nprcgenekeepr's (600 of 600 results identical).
- **Converters from kinship2 and Pedixplorer objects (Phase 14), 1 export:** `asPedFrame()` turns a kinship2
  `pedigree` or `pedigreeList` object back into the package's pedigree data frame and twins table (R55-R57): each
  parent read by its own index, ids as text with whole numbers in full, sex M, F or U, conditions as `affected` or
  `affected_<name>`, status `DECEASED` or `ALIVE`, twins from relation codes 1-3; a family list converted whole when
  no id repeats, with a `famid` column. It reads the object without kinship2 and refuses any other class. An S3
  generic with internal helpers `.asPedFrameKinship2()`, `.asPedFrameConditions()`, `.asPedFrameText()` and
  `.asPedFrameTwins()`. 15 tests; a data frame through `kinship2::pedigree()` and back comes out identical on 9
  fixtures in 8 variants and 300 random pedigrees. 0.04 s for 100,000 animals. S20 added Pedixplorer's `Pedigree`
  (R58-R59): ids as the object holds them (`F1_A` with families, and a `famid` column), sex M, F or U, each
  condition with a known value (`affection` as `affected`, others `affected_<name>`), status `DECEASED`, `ALIVE` or
  `NA`, Pedixplorer's fields that hold data, then the object's own extra columns; twins from `rel(x)`; it stops
  when Pedixplorer is not installed or a column name would repeat. Internal helpers `.asPedFramePedixplorer()`,
  `.asPedFramePxConditions()`, `.asPedFramePxStatus()`, `.asPedFramePxKeptFields()`, `.asPedFramePxTwins()` and the
  shared `.asPedFrameTwinTable()`. 14 tests; a data frame through `Pedixplorer::Pedigree()` and back comes out
  identical on 9 fixtures in 12 variants and 100 random pedigrees. 0.005 s for 100,000 animals. Pedixplorer
  (Bioconductor 3.23) is in `Suggests` and renv, never required (R7).
- **Unrelated-set finder (Phase 13, second session), 1 export:** `findUnrelated()` chooses genotyped animals of
  which no two share an ancestor (kinship 0), to which none can be added and in which no chosen animal can be
  traded for two, the same set every time (R52-R54): the animal with the fewest relatives first, ties in byte order,
  then a swap pass. It refuses a pedigree from which relatedness cannot be read (`checkPedigree()`'s missing or
  duplicate ids, own parents, cycles, parents with no row, `"0"` codes) and does not read sex. pedkindraw's own new
  code with internal helpers `.founderAncestors()`, `.unrelatedPick()`, `.unrelatedSwap()` and three others. 19
  tests; checked against a slow check from the definition on 300 random pedigrees and, where installed, against
  kinship2's set sizes. 138 animals in 0.57 s on 10,000 animals with 30% genotyped, where kinship2 takes 6.5 s.
- **Pedigree checker (Phase 13, first session), 1 export:** `checkPedigree()` lists a pedigree's problems, one row
  per problem id (`check`, `id`, `detail`), and repairs nothing: ids missing or duplicated, an animal its own
  parent or its own ancestor, parents with no row, `"0"` or blank for an unknown parent, male dams, female sires,
  parents of unknown sex, one id used as sire and dam, and sex codes other than M, F, H, U (R49-R51). pedkindraw's
  own new code with internal helpers `.checkRows()`, `.checkSorted()`, `.checkListed()`, `.checkOffspring()`,
  `.checkCycles()` and `.checkSexRows()`. 23 tests; checked against a slow checker on 300 random pedigrees and,
  where installed, against what kinship2's `pedigree()` refuses and accepts. 0.14 s on 100,000 animals.
- **IBD matrix (Phase 12, second session), 1 export:** `ibdMatrix()` turns pairs of ids and their IBD values, as
  programs such as SOLAR write them, into kinship2's class, a symmetric sparse `dsCMatrix` with a row and a column
  per id, sorted (numbers by value, character ids in byte order), named from `idmap` when given (R46-R48).
  pedkindraw's own code with internal helpers `.ibdNames()`, `.ibdEntries()`, `.ibdSparse()` and `.ibdListed()`;
  written from kinship2's help page and measured results, not its source (R14). It gives kinship2's value for every
  pair wherever kinship2 returns, and stops with a plain message where kinship2 is silent, wrong or never returns
  (a missing diagonal value, unequal lengths, one pair given two values). 19 tests; checked against
  `kinship2::ibdMatrix()` where installed.
- **Family check (Phase 12, first session), 1 export:** `familyCheck()` compares the family ids animals are given
  with the family trees their parent links form: per family id, its animals, those related to no one, the trees it
  spans (`split`) and the other family ids sharing them (`join`), and a table of the joined ids by tree (R43-R45).
  pedkindraw's own code with two internal helpers, `.familyTrees()` (numbered as kinship2's `makefamid()`) and
  `.familyJoinTable()`; written from kinship2's help pages and measured results, not its source (R14). It gives
  kinship2's `familycheck()` answer wherever kinship2 returns, and answers where kinship2 stops (every join inside
  one tree, empty input). 16 tests; checked against `kinship2::familycheck()` and `makefamid()` where installed.
- **Shrink steps (Phase 11), 4 exports:** `bitSize()` (kinship2's list: `bitSize`, `nFounder`, `nNonFounder`),
  `findUnavailable()`, `findAvailNonInform()` and `findAvailAffected()`, each giving `shrinkPedigree()`'s answer for
  its step (R40-R42): the first trim's ids, the second trim's ids (the first run inside), and one third-trim removal
  returned with kinship2's `ped`, `idTrimmed`, `isTrimmed`, `bitSize`, so repeated calls walk the third trim.
  pedkindraw's own code, calling the copied internals of `R/shrinkPedigree.R` (unchanged) and one internal helper,
  `.parentPositions()`; written from kinship2's help pages, not its source (R11). 32 tests; checked against
  `kinship2::bitSize()` and the first two steps of `kinship2::pedigree.shrink()` where kinship2 is installed.
- **Shrink (Phase 10), 1 export:** `shrinkPedigree()` trims a pedigree to the animals that keep it informative within
  a genotyping budget (`maxBits`), in kinship2's three tiers (unavailable, non-informative, affected-priority); it
  stops with a plain message on malformed input (C15) and breaks ties by byte order, the same on every computer
  (C16); 4 internal helpers. nprcgenekeepr's clean-room code (C2) copied from `baef1e12c`, code unchanged; its 24
  tests pass as there, and its results are identical to nprcgenekeepr's.
- **Renderer (Phase 9), 1 export:** `drawPedigreeDiagram()` turns a layout into an interactive `visNetwork` widget:
  the symbols at the layout's positions, the legend, each deceased animal's slash and each multi-condition symbol's
  coloured sections (painted by a drawing script inside the widget), Export Diagram (PNG), Select by id and the hover
  highlight; 6 internal functions and 2 constants (`deceasedSlash.R`, `affectedConditions.R`'s drawing half). Copied
  from nprcgenekeepr `471589138` (R34) and `baef1e12c`, code unchanged, help rewritten (R36); its 12 tests and the
  3 Chrome tests pass as there, and its widgets are identical to nprcgenekeepr's. Imports `visNetwork`; CI sets up
  Chrome. nprcgenekeepr's later legend fill (S1159: the five sex symbols open, as the diagram draws an unaffected
  animal) was ported in S12 (R37), so the copy matches nprcgenekeepr `4283e3502`. Since S28 (R81) the legend
  explains a multi-condition symbol: with two or more conditions each condition's row is a circle cut into the same
  sections, its own filled (`.conditionLegendImage()`; 8 tests, one reading 58 pixels in Chrome); nprcgenekeepr is to
  get the same change, and `DIVERGENCE.md` records it until then.
- **Layout engine (Phase 8), 2 exports:** `makePedigreeMatingLayout()` (each animal's position, symbol and hover
  text, union nodes for matings, lines routed `"rectilinear"` or `"direct"`, twins, consanguineous matings marked from
  `kinship()`, up to four affected conditions) and `makePedigreeDiagramData()` (plain nodes and edges for visNetwork);
  52 internal functions and 4 constants, among them nprcgenekeepr's clean-room solver (C2) and the four that compare a
  layout's structure with kinship2's (`comparePedigreeStructure.R`, used by the tests). Copied from nprcgenekeepr
  `baef1e12c`, code unchanged but for the order hint's call-site lines in two functions (S22, `DIVERGENCE.md`);
  its 333 tests pass as they do there (R29-R33), and its results without hints are identical to nprcgenekeepr's. Imports `quadprog`, `utils`.
- **Kinship and twins (Phase 7), 2 exports:** `kinship()` (autosomal or X-chromosome kinship, dense or a `Matrix`
  sparse matrix, identical twins declared in a `twinRelations` table made identical) and `checkTwinRelations()`
  (validates that table by kinship2's rules); internal `mzTwinGroups()` and the constant `mzTwinIdsAbsentMessage`.
  nprcgenekeepr's clean-room code (C2) copied from `baef1e12c`; results identical to it. Imports `Matrix` (R27),
  `methods`, `stats`.
- **Pedigree repair and trimming (Phase 6b), 8 exports:** `trimPedigree()`, `removeUninformativeFounders()`,
  `addBackSecondParents()`, `getIdsWithOneParent()`, `hasBothParents()`, `addParents()`, `correctParentSex()`,
  `removeUnknownAnimals()`; internal `addIdRecords()` (exported in nprcgenekeepr; contract section 4.1),
  `isAddedRecord()`, `rbindFill()` and the constant `sexCodes`. Copied from nprcgenekeepr `baef1e12c`; results
  identical to it. Imports `data.table` (only `addIdRecords()` uses it).
- **Pedigree relationships (Phase 6a), 8 exports:** `findGeneration()`, `findPedigreeNumber()`, `getParents()`,
  `getOffspring()`, `getFounders()`, `isFounder()`, `getProbandPedigree()`, `getDescendantPedigree()`; internal
  `isEmpty()` and `walkPedigree()`. Copied from nprcgenekeepr `baef1e12c`; results identical to it.
- **Package skeleton (Phase 5):** `DESCRIPTION` 0.0.1, MIT `LICENSE` (R14, R17), roxygen2, testthat 3rd edition,
  `.lintr` with nprcgenekeepr's linters, renv on a dated Posit snapshot, GitHub Actions R-CMD-check on Linux (devel,
  release, oldrel-1), macOS and Windows.
- **Checks against nprcgenekeepr** (read from its local clone): `tools/compareWithNprcgenekeepr.R`, the drift check
  (plan section 5; `DIVERGENCE.md` records allowed differences: none since S12), and
  `tools/compareResultsWithNprcgenekeepr.R`, which compares every copied function's results, warnings and messages
  on the Phase 1 pedigrees (the layout and shrink on at most 400 animals of each, S10, S13), against the clone's working tree or, with
  a commit, its package at that commit read with `git archive` (S11, R37).
- **Test fixtures:** `tools/makeTestFixtures.R` saves nprcgenekeepr's sample pedigrees into
  `tests/testthat/fixtures/` (`lacy1989Ped`, `smallPed`; `pedSix`, `qcPed` from Phase 6b; `pedOne` from Phase 7;
  `examplePedigree`, `pedWithGenotype`, `rhesusPedigree` and three rhesus `.csv` files from Phase 8) instead of
  shipping them as datasets (R21). `tools/makeComputedTestFixtures.R` (S9) saves what nprcgenekeepr's own code builds
  for a copied test: the QC'd rhesus pedigree (until Phase 10 also `shrinkPedigree()`'s Track B results, for a
  stand-in deleted in S13, R39). Both it and the results tool start R in nprcgenekeepr's folder with `tools/renvFreeEnv.R`.
- **Quality gates** (`methodology/.quality-gates.json`): `renv-lock-no-latest-repository`, `lint-package-zero`,
  `test-suite-warnings-zero` (S8), `tests-no-saved-expect-condition` (S9), `user-facing-sire-dam-words` (S23; S26
  widened it from `R/` and `man/` to the README, NEWS and vignettes).

## Completed Milestones

- **Phase G14, session 4 of 4: the line width (pedkindraw S63, 2026-11-20).** kinship2's and Pedixplorer's
  `lwd` thicken every line they draw; pedkindraw's lines were 1 unit wide, its outlines 1 pixel (a genotyped
  one 4). `makePedigreeMatingLayout(lineWidth = )` now sets the width of every line, outline and mark as a
  multiple of today's, the dashes growing with it so a thick dashed line stays dashed. Mark's picks: every
  line, outline and mark follows it; a genotyped outline is the width plus 3, so an affected animal's colour
  keeps more of its symbol; the legend keeps its widths (R140). The fidelity cases 600 of 600, nothing set
  aside. G14 is done.
- **Phase G14, session 3 of 4: the column and row spacing (pedkindraw S62, 2026-11-20).** kinship2's distances
  follow the width and height of its page; pedkindraw placed the animals of a row 120 units apart and the rows 150
  apart. `makePedigreeMatingLayout(columnSpacing = , rowSpacing = )` now set them as multiples of those
  distances, so a drawing can be made wider or deeper; every place is today's times the spacing, and the
  rectilinear lines' steps and curves are worked out at it. Mark's picks: two settings; large text does not widen
  the columns by itself (the help says text 2 needs columns 1.4); the line width a session of its own (R140). The
  fidelity cases 600 of 600, nothing set aside.
- **Phase G14, session 2 of 3: the text size (pedkindraw S61, 2026-11-20).** kinship2 and Pedixplorer take a
  text size; pedkindraw wrote every id and name at vis.js's 14 pixels. `makePedigreeMatingLayout(textSize = )`
  now sets it as a multiple of that size, as their `cex` does, the layout's places and lines unchanged; with
  larger text the drawing keeps room for the outermost labels, so long ids at the edges are not cut, and the
  infertile and miscarriage ids keep their room below their marks. Mark's picks: invisible points at the outermost
  labels' ends; the marks' words and the twins' labels keep their sizes (R140). The fidelity cases 600 of 600,
  nothing set aside.
- **Phase G14, session 1 of 3: the symbol size (pedkindraw S60, 2026-11-20).** kinship2 and Pedixplorer take a
  symbol size; pedkindraw drew every animal 25 units across. `makePedigreeMatingLayout(symbolSize = )` now sets it
  as a multiple of that size, as their `symbolsize` does: the layout works its line detours out from it, and the
  drawing moves the infertile and miscarriage ids in proportion and keeps a full-size symbol's room for smaller
  symbols, so long ids at the edges are not cut. Mark's picks: four settings (symbol size, text size, spacing,
  line width) as multiples in the layout, none of B5's others, one a session, the symbol size first (R140). The
  fidelity cases 600 of 600, nothing set aside.
- **Phase G13, mark 6 of 6: the miscarriage mark (pedkindraw S59, 2026-11-20).** Pedixplorer draws a miscarriage
  as a triangle in place of its symbol, with a line across a termination's and an ectopic pregnancy's and "ECT"
  under the latter's; pedkindraw ignored such a column, and its full-size triangle means the Unknown sex.
  `makePedigreeMatingLayout()` now reads a column `miscarriage` in Pedixplorer's words and values: each miscarriage
  is drawn as a triangle 0.6 the size, so it is not the Unknown sex's, with Pedixplorer's line and "ECT", its id in
  the row of the others and no deceased slash; hovering says "Miscarriage:" and the kind, and the legend gains
  rows "Miscarriage", "Termination" and "Ectopic". A miscarriage that is a parent or has a fertility mark stops.
  Mark's picks: Pedixplorer's column and values; the small triangle with the id in its row; the stop, as
  Pedixplorer refuses both; three legend rows of short words (R139). The fidelity cases 600 of 600, nothing set
  aside. Phase G13, Pedixplorer's seven marks, is DONE in six sessions.
- **Phase G13, mark 5 of 6: the infertile mark (pedkindraw S58, 2026-11-20).** Pedixplorer marks an infertile animal
  with a line down from its symbol and two bars, and one with no offspring by choice or for an unknown reason with
  a line and one bar; pedkindraw ignored such a column. `makePedigreeMatingLayout()` now reads a column `fertility`
  in Pedixplorer's words and values: each such animal's symbol has its mark, the animal's id moves down below it,
  hovering says "Fertility:" and the kind, and the legend gains rows "Infertile" and "No offspring". The drawing
  takes each moved id into its view, so one at the bottom edge is not cut off. Mark's picks: Pedixplorer's column
  and values; the mark under the symbol with the id moved, Pedixplorer's picture; an infertile parent drawn as
  recorded (Pedixplorer refuses it; a colony animal can be sterilised after it has bred); legend rows of the mark
  alone (R138). The fidelity cases 600 of 600, nothing set aside.
- **Phase G13, mark 4 of 6: the evaluated mark (pedkindraw S57, 2026-11-20).** Pedixplorer marks an animal with a
  documented evaluation with a "\*" beside its symbol; pedkindraw ignored such a column.
  `makePedigreeMatingLayout()` now reads a column `evaluated`: each evaluated animal's symbol has a black star to
  the right of its upper-right corner, hovering says "Evaluated: Yes", "No" or "Unknown", and the legend gains a
  row "Evaluated". The drawing takes each star into its view, so one at the right edge is not cut off. Mark's
  picks: the star a little lower and farther right than Pedixplorer's, which lies on the deceased slash's end; the
  view widened; a legend row of the star alone (R137). The fidelity cases 600 of 600, nothing set aside.
- **Phase G13, mark 3 of 6: the proband and consultand marks (pedkindraw S56, 2026-11-19).** Pedixplorer marks the
  proband, the affected animal through whom the family came to attention, with an arrow and "P", and the
  consultand, for whom counselling or testing is sought, with the arrow alone; pedkindraw ignored such columns.
  `makePedigreeMatingLayout()` now reads the columns `proband` and `consultand`: each such animal's symbol has a
  black arrow pointing at it from the lower left, a proband's with "P", hovering says "Proband:" and "Consultand:"
  "Yes", "No" or "Unknown", an animal marked both stops, and the legend gains rows "Proband" and "Consultand". The
  drawing takes each arrow into its view, so one at the left edge is not cut off. Mark's picks: an arrow flatter
  than Pedixplorer's, which would run along the deceased slash; the view widened; both marks on one animal
  refused, as in Pedixplorer; two legend rows of the arrow (R136). The fidelity cases 600 of 600, nothing set aside.
- **Phase G13, mark 2 of 6: the carrier mark (pedkindraw S55, 2026-11-19).** Pedixplorer marks a carrier, an
  animal that has the genetic trait but is not expected to show the disease, with a black point in its symbol;
  pedkindraw ignored any such column. `makePedigreeMatingLayout()` now reads a column `carrier`: a carrier's symbol
  is drawn with a black dot at its centre, on top of its fill, its sections and the deceased slash, hovering says
  "Carrier: Yes", "No" or "Unknown", and the legend gains a row "Carrier". A Pedixplorer object converted by
  `asPedFrame()` keeps its carriers in that column. Mark's picks: a black dot a quarter of the symbol's size over
  a ringed dot and Pedixplorer's smaller one (hidden under the deceased slash), `NA` drawn unmarked (R135). The
  fidelity cases 600 of 600, nothing set aside.
- **Phase G13, mark 1 of 6: the genotyped mark (pedkindraw S54, 2026-11-19).** Pedixplorer marks an available
  animal by its border; pedkindraw ignored any such column. `makePedigreeMatingLayout()` now reads a column
  `genotyped`: a genotyped animal's symbol is drawn with its outline 4 pixels wide, hovering says "Genotyped: Yes",
  "No" or "Unknown", and the legend gains a row "Genotyped". Mark's picks: all seven marks, the genotyped one
  first, then one kind a session (R133); the column `genotyped` over Pedixplorer's `avail`, a thick outline over a
  ring or Pedixplorer's colours (which vanish in greyscale), `NA` drawn unmarked (R134). The fidelity cases 600 of
  600, nothing set aside.
- **Phase G12, a measured trait drawn by a cut-off (pedkindraw S53, 2026-11-19).** Pedixplorer colours a column of
  numbers by a threshold and writes the rule in its legend; pedkindraw stopped on such numbers (G1).
  `makePedigreeMatingLayout()` and `makePedigreeDiagramData()` now take `conditionThresholds`, a cut-off the user
  writes for each measured trait, such as `c(affected_glucose = ">= 126")`: the animals passing it are drawn
  affected, the legend reads "Affected (glucose ≥ 126)", and hovering shows the number. Mark's picks: a cut-off
  over a colour scale, the comparison written by the user (`>`, `>=`, `<`, `<=`) over above-only (R131); the
  signs in the legend, the argument's name, both builders (R132). `>` and `<` decide as Pedixplorer's threshold,
  250 seeded comparisons. The fidelity cases 600 of 600, nothing set aside.
- **Phase G11, the near relatives of chosen animals (pedkindraw S52, 2026-11-19).** Pedixplorer's
  `useful_inds(max_dist = )` keeps the animals within a distance of its informative ones; pedkindraw kept only
  ancestors (`trimPedigree()`) or descendants (`getDescendantPedigree()`), with no distance.
  `getNearRelativePedigree(ped, probands, maxDist)` now keeps each animal within `maxDist`, read from kinship (1 the
  proband, 2 a parent, offspring or full sibling, 3 a grandparent, half sibling, uncle or aunt), and each parent
  that joins their families. Mark's picks: Pedixplorer's rule (R129), found from its help and results and the
  same animals in 1,980 of 1,980 runs; the name and the probands named by id (R130). Faster than Pedixplorer (0.5 s
  to 2.0 s on 3,694 animals). The fidelity cases 600 of 600, nothing set aside.
- **Phase G10, the layout's own hints returned (pedkindraw S51, 2026-11-19).** kinship2's `autohint()` and
  Pedixplorer's `auto_hint()` return the hints their layouts use, for a user to edit; pedkindraw's layout took
  hints but returned none. `makePedigreeMatingLayout()` now returns the hints it used as `hints`, so
  `makePedigreeMatingLayout(ped, hints = layout$hints)` gives the same layout and an edit starts from the
  layout's own. Mark's picks: the name `hints` (R127), and both the order and mate rows (R128), each part in the
  only form measured to pass back the same layout: the order by row with founders left out (naming one turns off
  the layout's own founder order), no mate row for an animal with three or more matings. Measured on 10 fixture
  pedigrees, the twins pedigree, 400 random pedigrees and 15 colony cases. The fidelity cases 600 of 600, the new
  element set aside in 72.
- **Phase G9, a picture of what shrinking removed (pedkindraw S50, 2026-11-19).** kinship2's
  `plot.pedigree.shrink()` draws the animals a shrink keeps; pedkindraw had no picture of a shrink at all.
  `?shrinkPedigree`'s example now shrinks a 7-animal pedigree and draws all of it with the 3 animals removed
  filled, through a condition column made from `idTrimmed`; a test runs the help page's own example, also inside
  `R CMD check`. Mark's picks: a help example, not a vignette section (R125), and a test that runs it (R126).
  Measured: kinship2 draws only the 18 animals it keeps of sample family 1's 41, and its `idTrimmed` lists 18 of the
  23 it removes. Help text only, no code changed; the fidelity cases 600 of 600 identical.
- **Phase G8, aligned generations (pedkindraw S49, 2026-11-19).** kinship2's `kindepth(align = TRUE)` moves animals
  down so that both parents of an offspring share a generation, for drawing; pedkindraw had no such numbers. Its
  help gives the aim in one sentence, so the rule was measured from its results (R11: its code not read) on 26
  small pedigrees built for the purpose. `findGeneration(alignMates = TRUE)` now aligns them, ties broken by id so
  the order of the rows never changes the answer (kinship2's does on 4 of the 8 fixture pedigrees). Mark's picks:
  that rule (R123) and the name `alignMates` (R124). Equal to kinship2 on its sample families and 73 of 100 random
  pedigrees, a few animals different on the larger ones; 16 new tests, a slow version on 214 pedigrees; copied
  code changed with a `DIVERGENCE.md` row; the fidelity cases 600 of 600 identical.
- **Phase G7, removing listed animals (pedkindraw S48, 2026-11-19).** Dropping a parent's row left its offspring
  naming a sire or dam with no row, which `findGeneration()` cannot place and `kinship()` cannot take; kinship2's
  `pedigree.trim()` refuses such a removal and Pedixplorer's `subset()` clears both parents. The new export
  `removeAnimals()` removes the listed animals and clears each sire or dam entry naming one of them, the offspring
  keeping its other parent. Mark's picks: `removeAnimals(ped, ids)` under "Trimming and shrinking" (R120); clear
  that parent only (R121); an id found nowhere ignored (R122). 13 new tests, checked against a slow version, kinship2
  and Pedixplorer on 107 pedigrees each; the fidelity cases 600 of 600 identical.
- **Phase G6, each animal's offspring count and the matings (pedkindraw S47, 2026-11-19).** pedkindraw listed an
  animal's offspring but neither counted them nor listed its mates, which Pedixplorer stores. The new export
  `countOffspring()` counts each animal's offspring, each once (Pedixplorer's `num_child_dir` where a pedigree has
  a mating), and `getMatings()` lists each sire and dam with an offspring together, with the number they share:
  the matings the drawing draws. Mark's picks: two functions under "Pedigree structure", new code rather than a
  copy of nprcgenekeepr's `offspringCounts()` (R117); an animal's own offspring, not Pedixplorer's total with its
  mates' (R118); one row per mating (R119). 20 new tests, checked against slow versions on 107 pedigrees; the
  fidelity cases 600 of 600 identical.
- **Phase G5, other ways of writing an unknown parent and a sex (pedkindraw S46, 2026-11-18).** Data from other
  tools write an unknown parent as 0 or leave it empty, and sex as 1 and 2 or as words; `checkPedigree()` reported
  them, but nothing rewrote them, so generations came back `NA` and every animal was drawn as a diamond. The new
  export `recodePedigree()` rewrites them into pedkindraw's codes (`NA`; "M", "F", "H", "U"). Mark's picks: the
  name and its place under "Checking and repair" (R114); "0", "NA" and blanks by default, a row's id kept as a
  parent (R115); new code that keeps pedkindraw's own codes and leaves a sex it does not know for `checkPedigree()`
  (R116). 16 new tests; kinship2's `sample.ped` and `testped1` then give kinship2's own kinship; the fidelity cases
  600 of 600 identical.
- **Phase G4, the colours of the conditions (pedkindraw S45, 2026-11-18).** The four condition colours were fixed,
  and the drawing's section painter kept its own copy of them, so colours edited in a layout reached the legend but
  not the sections; now `makePedigreeDiagramData()` and `makePedigreeMatingLayout()` take `conditionColors`, the four
  colours as before by default, and `drawPedigreeDiagram()` paints the sections and the legend from the layout's
  colours, so the fills, sections and legend agree. Mark's picks: the name `conditionColors` and both builders
  (R111); any colour R knows, written as its code (R112); a clash or a missing colour stops (R113). 12 new tests, no
  copied test changed; the fidelity cases 600 of 600 identical with no set-aside.
- **Phase G3, the length of a name under an id (pedkindraw S44, 2026-11-18).** The `name` column was always cut
  after 15 characters on the drawing, where kinship2 and Pedixplorer write any label whole; now
  `makePedigreeDiagramData()` and `makePedigreeMatingLayout()` take `maxNameChars`, 15 by default as before, and
  `Inf` writes every name whole. Mark's picks: the name `maxNameChars` and both builders (R108); `Inf` for no limit
  (R109); the whole name counted, a line break included, as before (R110). 10 new tests, no copied test changed; the
  fidelity cases 600 of 600 identical with no set-aside.
- **Phase G2, an unknown affected status drawn (pedkindraw S43, 2026-11-18).** An animal whose affected status is
  unknown (`NA`) was filled white, like an unaffected one; it is now grey (`#BEBEBE`, as Pedixplorer fills it), the
  whole symbol with one condition or its section with two to four, in `makePedigreeMatingLayout()`,
  `drawPedigreeDiagram()` and `makePedigreeDiagramData()`, and the legend has a grey row "Affected status unknown"
  (the drawing 45 px taller for it). Mark's picks: grey fill over kinship2's "?" (R106); the legend's words
  (R107). 10 new tests and 9 copied ones changed; the fidelity cases 600 of 600 identical with a counted set-aside.
- **Phase G1, a number in a condition column (pedkindraw S42, 2026-11-18).** A condition column holding a number
  other than 0 and 1 (a measured trait, 2.5, 0.3, 9) stops `makePedigreeMatingLayout()`,
  `makePedigreeDiagramData()`, `shrinkPedigree()`, `findAvailNonInform()` and `findAvailAffected()`, naming the
  column and the numbers; before, every number but 0 was drawn or counted affected with no message. TRUE, FALSE,
  NA, 0, 1 and text read as before; `bitSize()` and `findUnavailable()` do not read the column. Mark's picks:
  stop, not warn (R102); numbers only (R103); all three reads (R104); the two functions that do not use the
  status ignore the column (R105). 12 tests; the fidelity cases 600 of 600 identical.
- **Phase 17f2, the plan for closing the gaps in both repositories (pedkindraw S41, 2026-11-18).**
  `docs/planning/gaps-and-shared-code-plan.md`: what closing each gap would touch, how nprcgenekeepr calls the copied
  code (57 calls from 24 files), its whole test suite run with pedkindraw's functions in place of its copies (31 of
  its 467 own test files failing once 4 calls pass the pedigree first, each for a change made on purpose or a test
  of its own source, one not traced), and two faults found in nprcgenekeepr on the way. Mark's picks: every gap
  closed before the first release (R97); nprcgenekeepr switches to pedkindraw after acceptance (R98-R100);
  pedkindraw leads changes to the shared code until then (R101).
- **Phase 17f, what kinship2 and Pedixplorer can do that pedkindraw cannot (pedkindraw S40, 2026-11-18).**
  `docs/research/pedkindraw-gaps-2026-11-18.md` lists 16 gaps, each shown on a small typed pedigree run with
  kinship2 1.9.6.2 and Pedixplorer 1.8.0 (`tools/gapCases.R`), with what each means for a user: chiefly no PDF,
  SVG or PNG picture from a script, no mark for an unknown affected status, no mating without offspring, no
  colour settings, and missing parents written "0" not read. nprcgenekeepr has 13 of the 16 too. Mark put the
  decision on which to close before the release into a planning session (R96).
- **Phase 17e, the legend's "Same animal, again" label reads whole (pedkindraw S39, 2026-11-17).** On the website
  the label read "Same animal; agai": the arrowhead visNetwork gives every legend line covered its last letter, and
  the dashed line through the comma made it look like a semicolon. The legend's four lines now have no arrowheads,
  as the drawing's own lines have none, and each label sits on white; in headless Chrome every legend line label of
  the shipped vignettes' 12 drawings is whole. nprcgenekeepr is to get the same fix later; until then
  `DIVERGENCE.md` and the comparison tool record the difference. NEWS says so.
- **Phase 17d, "Select by id" lists the animals only (pedkindraw S38, 2026-11-17).** A drawing with rectilinear
  lines adds routing points (ids starting `__jog_`) to step a line around an animal, and the box listed them as if
  they were animals: 196 beside the 375 animals of the drawing vignette's colony drawing. Now it lists the animals
  only, and `makePedigreeMatingLayout()` refuses an animal id that starts with `__jog_`, which had silently shared
  its id with a routing point. The six prefixes the layout keeps for its own nodes are written once. nprcgenekeepr
  is to get the same fix later; until then `DIVERGENCE.md` and the comparison tool record the difference. NEWS
  says so.
- **Phase 17c3, the pedigree first (pedkindraw S37, 2026-11-17).** `getProbandPedigree()`,
  `getDescendantPedigree()`, `trimPedigree()` and `hasBothParents()` now take the pedigree as their first argument,
  like every other function that takes one. The calls that passed both arguments by position changed with them, in
  the package, its tests, its help, the getting-started vignette and the comparison tool; a call in nprcgenekeepr's
  order stops with an error rather than giving a wrong answer. NEWS says so. With it, 17c, the argument-name
  changes, is done.
- **Phase 17c2, the pedigree argument is `ped` (pedkindraw S36, 2026-11-17).** `getParents()`, `getOffspring()`
  and `getIdsWithOneParent()` now call the pedigree `ped`, like every other function, and `addBackSecondParents()`
  calls its trimmed pedigree `trimmedPed` beside the full `ped`. Each argument kept its position, so no call in the
  package, its tests or its documents changed; only a call that names the old argument stops. NEWS says so.
- **Phase 17c1, `kinship()` takes `sire` and `dam` (pedkindraw S35, 2026-11-17).** `kinship()`'s parent arguments
  now say sire and dam like every other function's, and it stops with a plain message when an animal's generation
  number is not above its sire's and dam's. Called the way kinship2's users call their own `kinship()`, with the sex
  codes 4th, it gave a wrong matrix without any error; now it stops, in every family of kinship2's two example
  pedigrees. Its help page and the README say which names pedkindraw shares with kinship2 and Pedixplorer. The new
  check also found a test pedigree whose stored generation numbers were wrong.
- **Phase 17b, the argument-name review (pedkindraw S34, 2026-11-17).** Before the first CRAN release, the last time
  a change costs users nothing, Mark ruled on each name: `kinship()`'s parents become `sire` and `dam` like every
  other function's; the pedigree argument is `ped` in every function and comes first in each; `addIdRecords()` stays
  internal; names shared with nprcgenekeepr, kinship2 and Pedixplorer stay, with a note. Measuring the shared
  `kinship()` found that kinship2's own call form gives pedkindraw a wrong kinship matrix without any error; Mark
  ruled that `kinship()` will refuse such input. The changes are three test-first sessions, 17c1-17c3 (R87-R93).
- **Phase 17a, the check time on win-builder (pedkindraw S33, 2026-11-17).** Mark approved Claude uploading the
  package to win-builder R-devel, where CRAN's 10-minute limit applies. The check took 398 s, under the 540 s
  target and far under S32's estimate of 615-688 s, with only the new-submission NOTE. Its tests ran on an idle
  machine, so a busy day could read about 470-550 s; Mark chose to decide any cut of the tests run on CRAN after the
  last tests are written (17j), by one more reading.
- **Phase 17's plan, the CRAN submission (pedkindraw S32, 2026-11-16).** Mark asked that the release plan weigh
  the other open work, nprcgenekeepr's recent and ongoing changes, and the comparison with kinship2 and
  Pedixplorer. Measured first: the check takes 181 s on this Mac, which puts it near CRAN's 10-minute limit on
  CRAN's slower machines; nprcgenekeepr has changed none of the copied files since the copy. Mark put all four
  open items before the release and chose to measure the check time on win-builder first.
- **Phase 16e, the website; Phase 16 DONE (pedkindraw S31, 2026-11-16).** Mark approved the site's outline before
  its settings were written, chose to run pkgdown locally from R's own library (no change to the lock), and
  approved turning on GitHub Pages once the first build had made the `gh-pages` branch. The site answered within a
  minute; in Chrome every drawing on its two articles shows all its animals. Its address went into `DESCRIPTION`
  and the README only after it answered, as the CRAN check reads each URL.

- **Phase 16d decided: the speed vignette waits (pedkindraw S30, 2026-11-16; R82).** A draft built to R79 gave
  nprcgenekeepr's November 2026 timings in nine tables, every cell checked against the committed results by a
  script written and run failing first. Reading it, Mark judged the comparison premature while pedkindraw still
  tracks nprcgenekeepr: "Disambiguation between pedkindraw and nprcgenekeepr may need to wait until pedkindraw is
  completely separated." It returns when pedkindraw times itself; the draft is kept on a branch, and the contract
  records the copied shrinking code's own time.

- **Phase 16c, the drawing vignette (pedkindraw S29, 2026-11-16).** Mark approved the draft from a trial page at
  the vignette's width, chose to show the colony drawing's layout warning with a sentence explaining it, and to
  state the drawing size limit from the November 2026 records until the speed vignette exists. Two of the drafted
  hidden checks were wrong and stopped the trial build before anything was committed. Measuring the page in Chrome
  found that the "Select by id" box of a large drawing also lists invisible routing points (a backlog item). The
  package installs at 4.2 MB with both vignettes of drawings.

- **The legend explains a multi-condition symbol's sections (pedkindraw S28, 2026-11-16; R81).** Mark's S26 find:
  the dividing lines in a symbol with two or more conditions "are not explained in the legend. It looks like an
  error." Each condition's legend row now shows a circle cut the same way with its own section filled. Mark picked
  it over an extra legend row after both were drawn at two, three and four conditions, and ruled that nprcgenekeepr
  gets the same change later. A browser test checks that the legend's filled section sits where the diagram fills
  that condition. The comparison with nprcgenekeepr's results now sets aside those rows' symbols, its only change.

- **Phase 16b, the getting-started vignette and the example file (pedkindraw S27, 2026-11-15).** Mark picked the
  drawing, ED5PDV's 16 ancestors with a mating of half siblings, from three candidates drawn on trial pages at the
  vignette's width (36-37 animals drew their ids too small or not at all). Measuring what each shrink step removed
  corrected the draft's description before it was committed. The vignette builds with kinship2 and Pedixplorer
  absent, and the package installs at 2.2 MB.
- **Phase 16a, the README, NEWS and `?pedkindraw` (pedkindraw S26, 2026-11-15).** The README's example runs when
  the README is built, and a hidden check stops the build if a statement its text makes stops holding; its picture
  is made from the README's own code. Mark picked the install line (pak) and the picture's pedigree from three
  drawn candidates, dropping one whose two-condition symbols show divider lines the legend does not explain (a
  backlog item). `R CMD check` showed the plan's NEWS heading needs a version number.
- **Phase 16 planned (pedkindraw S25, 2026-11-15).** Measured on scratch copies before the picker: a vignette page
  with drawings is 1.6-1.9 MB and the package without vignettes 0.47 MB, so two such pages fit CRAN's 5 MB and three
  do not; a trial pkgdown site built in 34.5 s once the package was installed (a stale installed copy stopped it
  otherwise) and published the root's `CLAUDE.md` and `DIVERGENCE.md`; nprcgenekeepr's re-timing of its rewrite
  measured the very files pedkindraw copied. Mark's picks R77-R80, each the recommended option: three CRAN vignettes,
  two with live drawings; the site on GitHub Pages; the timing tables summarized from the records and checked by a
  script; the 375-animal rhesus pedigree as an example file. Five build sessions, 16a-16e.
- **Phase 15c, the converters pass hints on; Phase 15 DONE (pedkindraw S24, 2026-11-15).** Written test-first after
  measuring what kinship2 1.9.6.2 and Pedixplorer 1.8.0 objects hold in their hints, set by a user and by
  `autohint()` and `auto_hint()`, on 212 pedigrees (Mark's picks R74-R76, each the recommended option: mate rows the
  layout refuses fixed with a message, 40 of 143 kinship2 and 50 of 119 Pedixplorer automatic hints holding such
  rows; unreadable kinship2 hints stop; a `pedigreeList` read as a `pedigree`). 12 tests and 9 whole-list tests
  updated; the contract's row; fidelity 600 of 600 identical.
- **Phase 15b, the mate layout hint (pedkindraw S23, 2026-11-15).** Written test-first after measuring the design's
  open details D6, D7 and D9 on scratch prototypes against kinship2 and Pedixplorer (Mark's picks R70-R73, each the
  recommended option: strict checks; no anchor on the earlier-generation partner, which drew 2,916 random matings'
  anchors rows away from their dot; several mates as kinship2 draws them, 18 of 18 typed rows equal and 0 of 197
  crossed families; the element renamed `mate`, user-facing words being sire and dam). 9 tests, three
  `DIVERGENCE.md` rows, the contract's row; fidelity 600 of 600 identical without hints.
- **Phase 15a, the order layout hint (pedkindraw S22, 2026-11-15).** Written test-first after measuring the design's
  open details D1-D5 on a scratch prototype against kinship2 and Pedixplorer (Mark's picks R64-R69, each the
  recommended option: unnamed animals keep their rows, family order changed 0 times in 99; a founder couple by its
  female's number, kinship2's top row 720 of 720; the founder step skipped only where founders are named; twins
  drawn as ordered; strict checks; kinship2 compared on typed cases, where its rows agree). 12 tests, two
  `DIVERGENCE.md` rows, the contract's row; fidelity 600 of 600 identical without hints.
- **Phase 15's design, user-suppliable layout hints (pedkindraw S21, 2026-11-14).** A design document, no code:
  what kinship2's and Pedixplorer's hints do, read from their help pages; where the copied engine sets left-to-right
  order (the rows of `ped`, a founder-reordering step, fixed rules for anchors and mate sides); eight measurements
  before Mark's picks (sorting rows by a hint ordered 9,840 of 9,840 random sibships; scratch prototypes of the
  spouse hints worked on 1,090 and 1,936 matings); rulings R60-R63 (order and mate placement, a `hints` argument,
  converters pass hints on, three build sessions with their DONE criteria).
- **Phase 14's second session, `asPedFrame()` for Pedixplorer objects, and with it Phase 14 (pedkindraw S20,
  2026-11-14).** Pedixplorer (Bioconductor 3.23) installed into renv, the 8 dependencies the lock took from
  "latest" reinstalled from the dated repository; new code written test-first (Mark's picks R58-R59: Pedixplorer's
  fields kept when they hold data; `affection` as `affected`; ids as the object holds them; unknown death left
  blank); the round trip shown able to fail by planting the comparison's all-`NA` defect (136 of 136 caught); a
  silent column clash found by measuring before RED and made a stop; the new code fully covered; CI green on five
  jobs at the first attempt, its first install of a Bioconductor package.
- **Phase 14's first session, `asPedFrame()` for kinship2 objects (pedkindraw S19, 2026-11-14).** New code written
  test-first (Mark's picks R55-R57: kinship2 now and Pedixplorer, with its 47-package install, in a session of its
  own; family lists accepted when no id repeats; status 0 as `ALIVE`; the object read without kinship2; typed cases
  and a round trip); Pedixplorer's install measured in a scratch library and a scratch lock file before the scope
  picker; the round trip shown able to fail by planting the comparison's unknown-parent defect (372 of 372 caught);
  the new file fully covered; CI green on five jobs at the first attempt.
- **Phase 13's second session, `findUnrelated()`, and with it Phase 13 (pedkindraw S18, 2026-11-13).** New code
  written test-first (Mark's picks R52-R54: relatedness from shared ancestors; the fewest relatives first, then a
  swap pass; a stop naming the animals where relatedness cannot be read; tests against a slow check and kinship2);
  kinship2 reproduced on the comparison's three cases first, and the rule measured against an exact search before
  the picker; the typed swap case found by shrinking a random one; the new file fully covered; CI green on five jobs
  at the first attempt.
- **Phase 13's first session, `checkPedigree()` (pedkindraw S17, 2026-11-13).** New code written test-first
  (Mark's picks R49-R51: `findUnrelated()` next session; one row per problem id; two checks added to the contract's
  nine; `"0"`, `"NA"` and blank as unknown-parent codes; tests against a slow checker and kinship2's `pedigree()`);
  a prototype measured on 300 random pedigrees before the pickers, the apparent misses traced to injections that
  changed nothing; the new file fully covered; CI green on five jobs at the first attempt.
- **Phase 12's second session, `ibdMatrix()`, and with it Phase 12 (pedkindraw S16, 2026-11-13).** Written
  test-first from kinship2's help page and measured results (Mark's picks R46-R48: kinship2's class with the ids
  given, sorted; a stop naming ids that lack a diagonal value; plain stops where kinship2 is silent or wrong; tests
  against kinship2); kinship2 measured before the picker, one case per process under a time limit, which showed it
  hangs on some inputs and not others; a ruling's description corrected before GREEN; the new file fully covered;
  CI green on five jobs at the first attempt.
- **Phase 12's first session, `familyCheck()` (pedkindraw S15, 2026-11-13).** Written test-first from kinship2's help
  pages and measured results (Mark's picks R43-R45: `ibdMatrix()` next session, kinship2's `join` numbers, plain
  stops and answers where kinship2 fails, `newfam` kept, tests against kinship2); kinship2 measured before each
  picker, its `join` found to disagree with its own help page; the new file fully covered; CI green on five jobs at
  the first attempt.
- **Phase 11, the shrink steps, the first new code (pedkindraw S14, 2026-11-12).** `bitSize()`, `findUnavailable()`,
  `findAvailNonInform()` and `findAvailAffected()` written test-first (Mark's picks R40-R42: each gives
  `shrinkPedigree()`'s answer for its step, kinship2's return shapes, tests against `shrinkPedigree()` and kinship2);
  every expected value computed before RED, and one described kinship2 difference corrected by reproducing it; the
  new files fully covered; CI green on five jobs at the first attempt, twice.
- **Phase 10, shrink, and with it the copy slices (pedkindraw S13, 2026-11-12).** `shrinkPedigree()` copied test-first
  from nprcgenekeepr's clean-room code (Mark's picks R38-R39: its 3 nprcgenekeepr-only test files left out, the
  Phase 8 stand-in deleted in RED); 600 of 600 results identical, the cases reaching every statement of the file;
  CI green on five jobs at the first attempt. Phases 6-10 are complete.
- **nprcgenekeepr S1159's legend fill, ported (pedkindraw S12, 2026-11-12; R37).** The legend draws its five sex
  symbols open, as the diagram draws an unaffected animal, copied test-first in nprcgenekeepr's own three steps;
  `DIVERGENCE.md` has no row; 540 of 540 results identical against nprcgenekeepr `45e0d8bfe`; CI green on five jobs
  at the first attempt.
- **Phase 9, the renderer (pedkindraw S11, 2026-11-12).** `drawPedigreeDiagram()` and its drawing helpers copied
  test-first (Mark's picks R34-R37: the newer source commit, nprcgenekeepr's app and docs tests left out, the help
  rewritten, and nprcgenekeepr's mid-session legend change ported later); 540 of 540 results identical, whole
  widgets included; CI green on five jobs at the first attempt, the Chrome tests running on all five.
- **Comparison and design, in nprcgenekeepr (S1121-S1130, 2026-11-02 to 11-04).** The plan; a comparison with
  kinship2, Pedixplorer and ggpedigree of what each computes and draws, and how fast, in how much memory, for how many
  animals (Phases 1-2); data frames plus converters as the input style (Phase 3, R7); the API contract, the name and
  the public repository (Phase 4, R10-R13). nprcgenekeepr then rewrote its kinship2-derived code by a clean-room
  process that pedkindraw copies (C2, finished S1140), and Mark ruled the license MIT (S1149, R14).
- **Phase 5, the skeleton (pedkindraw S1-S2, 2026-11-10).** The methodology and `CLAUDE.md`, then the empty package
  built test-first: 0 errors, 0 warnings and the one allowed NOTE (R16); first push, CI green on five jobs.
- **Phase 8, the layout engine (pedkindraw S9-S10, 2026-11-11 to 11-12).** All the layout code and its tests copied
  test-first in S9 (Mark's picks R30-R33: the split, the Chrome tests and drawing helpers to Phase 9, edition 3's
  fixes), then the kinship2 comparison and the fidelity tool's layout cases in S10 (468 of 468 results identical,
  messages now compared); CI green on five jobs at the first run of the layout.
- **Phase 7 (pedkindraw S8, 2026-11-11).** Kinship and twins copied test-first from nprcgenekeepr's clean-room code
  (Mark's picks R26-R29: 34 tests, Matrix's two classes imported, kinship2 and withr for tests, testthat edition 3
  kept), results identical to nprcgenekeepr's (360 of 360; 132 kinship matrices, largest difference 0); CI green on
  five jobs.
- **Phase 6b (pedkindraw S7, 2026-11-11).** The 11 functions that repair and trim pedigrees and the constant
  `sexCodes` copied test-first (Mark's picks R24-R25), results identical to nprcgenekeepr's (264 of 264); CI green on
  five jobs. Plan Phase 6 is complete.
- **Phase 6a (pedkindraw S3, 2026-11-10).** The 10 relationship functions copied test-first, results identical to
  nprcgenekeepr's on 12 Phase 1 pedigrees; the drift and results checks; CI green.
- **The plan moved here (pedkindraw S4-S6, 2026-11-10 to 11-11).** The plan, the contract and three studies copied
  from nprcgenekeepr `3d262d628` and brought up to date (rulings R16-R23); this roadmap and `methodology/BACKLOG.md`
  started; nprcgenekeepr's copies frozen (R23).
