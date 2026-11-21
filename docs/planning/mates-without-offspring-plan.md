# Phase G15: mates with no offspring (gap B1) -- the plan

**Date:** 2026-11-21 · **Session:** pedkindraw S64 · **Type:** planning session (`methodology/SESSION_RUNNER.md`
"Planning Sessions"; failure mode #18: this session writes no package code). **Governs:** Phase G15 of
`docs/planning/gaps-and-shared-code-plan.md` (section 5.1, G15's row), gap B1 of
`docs/research/pedkindraw-gaps-2026-11-18.md` (section 4, B1). **Ruling made here:** R141 (Mark's pick of the input,
`docs/planning/standalone-pedigree-package-plan.md` section 2). **Status:** plan written; G15a next.

**Versions:** kinship2 1.9.6.2 and Pedixplorer 1.8.0 from this project's renv library; pedkindraw at `d58a52f`
(its `R/` as at `4b31671`); nprcgenekeepr at `3e06730c5`; R 4.6.2; this Mac (Apple M2 Max). Every count below was
measured in this session by the scratch scripts of section 10, and covers the cases run, no more (Learning 19).

---

## 1. What G15 closes, and for whom

kinship2 (`pedigree(relation = )`, code 4) and Pedixplorer (a `rel_df` row with code `"Spouse"`) let a user say
that two animals are mates although they have no offspring together, and both draw the two joined as a mating.
pedkindraw has no way to say it. Its layout builds every mating from offspring that share a sire and a dam
(`.buildMatingUnitForest()`, `R/makePedigreeDiagramData.R:638`), so two founders mated without offspring have no
line to anything and are left out of the drawing (`isolatedIds`, `.findIsolatedIds()` at `:540`, called at `:2276`,
with the message "... with no recorded parents, mates, or offspring suppressed ..."); a mate hint naming them stops
(R70, `R/layoutHints.R:148`); and the converters drop both packages' spouse rows (`R/asPedFrame.R:37`-`:40`, `:86`,
`:284`-`:294`, `:402`-`:408`).

**What it means for users:** a pairing that has not yet produced offspring (a colony's planned or newly housed
breeding pair) or one that never did cannot be shown; both animals vanish, or, when one has parents, it is drawn
under them with no sign of its mate. The research record's words: "A planned or unsuccessful mating cannot be shown;
both animals disappear" (gap B1's row in its section 1).

**nprcgenekeepr shares the gap.** Its layout is the one pedkindraw copied, and its gap run reads E and F in
`isolatedIds` (`tools/gapCasesNprcgenekeepr.R:91`, "B1 isolatedIds with E and F unmated, no offspring"). Under R98
and R101 pedkindraw leads: each copied function G15 changes gets a `DIVERGENCE.md` row marked "at the switch", and
nprcgenekeepr gains the feature when it imports pedkindraw (N3). No nprcgenekeepr session is needed for G15.

---

## 2. What kinship2 and Pedixplorer do (measured)

`refcases.R` (section 10) ran 16 typed shapes, each in its own R process under a 30 s limit (Learning 19); none
reached the limit. "Rows" are the left-to-right ids of each drawn row from `align.pedigree()` / `align()`, `=`
between two animals drawn as mates, `#` between related mates (the double line), a space otherwise.

| Shape | Mates declared | kinship2 (code 4) | Pedixplorer (`"Spouse"`) |
|---|---|---|---|
| `matesNoOffspring` (the gap case: A, B with C, D; E, F founders) | E, F | `[A=B E=F] [C D]` | the same |
| `onlyTwo` (E and F, nothing else) | E, F | `[E=F]`; `plot()` stops ("Cannot plot pedigree with fewer than 3 subjects") | `align()` and `plot()` stop ("Impossible Pedigree") |
| `marryIn` (C, a son of A and B, with founder E) | C, E | `[A=B] [C=E D]` | the same |
| `secondMate` (A with B and C, D; A with founder G) | A, G | `[G=A=B] [C D]` | the same |
| `twoChildless` (A with B and with G, no offspring at all) | A, B; A, G | `[B=A=G]`; `plot()` stops ("subscript out of bounds") | `align()` and `plot()` stop |
| `sibMates` (C and D, full siblings) | C, D | `[A=B] [C#D]` | the same |
| `bothHaveParents` (C with J, a daughter of H and I) | C, J | `[A=B H=I] [D C=J]` | the same |
| `crossGen` (founder E with K, a granddaughter) | E, K | `[A=B] [C=H D] [E=K]`: E on K's row | the same |
| `childlessPlusKids` (C has K by H, and is mated with E) | C, E | `[A=B] [E=C=H D] [K]` | the same |
| `redundant` (A and B, who have offspring) | A, B | unchanged: `[A=B] [C D]` | the same |
| `twice` (E, F and F, E) | both rows | accepted: `[A=B E=F] [C D]` | stops ("Pairs of individuals should be unique") |
| `sameSex` (two males) | E, F | accepted, drawn as mates | accepted, drawn as mates |
| `unknownSex` (E of unknown sex) | E, F | accepted: `F=E` | accepted: `F=E` |
| `femaleFirst` (dam named first) | F, E | `E=F` (the male left) | `E=F` |
| `unknownId` (Z not in the pedigree) | E, Z | stops ("Subjects in relationships that are not in the pedigree") | stops |
| `selfMate` (E with itself) | E, E | stops ("Subject E is their own spouse or twin") | warns and returns a data frame, not a `Pedigree` |

**The spouse hint alone.** kinship2's `hints$spouse`, given with no code 4, also draws the pair as mates in 11 of
the 13 shapes that declare two different animals of the pedigree with no offspring together (it stops, "A
marriage is not male/female", on `sameSex` and `unknownSex`). Pedixplorer's spouse
hint alone (`pxhint.R`) drew `matesNoOffspring` and `sibMates` as mates and left E out of `marryIn` and G out of
`secondMate` (2 of 4). R74's reason for leaving such hint rows out, "kinship2 and Pedixplorer ignore it", was
measured on the 8-animal case only and does not hold for these shapes; G15c rewords it (section 7).

---

## 3. The decision: a matings table (R141)

Four ways to give the pair were measured on scratch copies (`apply_option.py`, `runtests.R`: the least change each
needs, then 12 test files run) and put to Mark. His pick, "A matings table (Recommended)":

`makePedigreeMatingLayout(..., matings = NULL)`, `matings` a data frame with the columns `sire` and `dam`, the first
two columns `getMatings()` returns, one row per mating drawn whether or not the two have offspring together.
`getMatings()` can list these too (G15b), and `asPedFrame()` returns them as a fourth element (G15c).

| Option | What the user writes | Existing tests it breaks (measured) | Copied functions newly different | Why not picked |
|---|---|---|---|---|
| **A matings table** (picked) | `matings = data.frame(sire = "E", dam = "F")` | 10: whole-list comparisons of `asPedFrame()`'s result (5 in `test_asPedFrame.R`, 4 in `test_asPedFramePedixplorer.R`, 1 in `test_asPedFrameHints.R`), each fixed by adding `matings = NULL` to the expected list | 1, `.findIsolatedIds()` | -- |
| A code in the twins table | a `twinRelations` row with code `"Mates"` | 2, the two "spouses left out" tests, reversed | 2, `checkTwinRelations()` (its help says kinship2's spouse code is out of scope) and `.buildTwinConnectorEdges()` (must skip the row); `makePedigreeDiagramData()` must skip it too | a table named for twins; a row has no sire-or-dam order; `getMatings()` would need the table |
| Mate hints declare it | a `hints$mate` row for the pair | 3: R70's stop test and two converter tests, reversed | 1, `.findIsolatedIds()` | R60 (hints only place animals), R70 and R74 partly reversed; every row needs an anchor; `getMatings()` cannot see hints |
| A column in the pedigree | `ped$mate` | 0 (read, not run: the two spouse tests read only the twins table) | 1, `.findIsolatedIds()` | an animal with two such mates needs two ids in one cell (`"B;G"`); neither package does it so |

---

## 4. What the prototype showed

`apply_proto.py` made the least layout change for the picked input in a `git archive` copy of `4b31671`'s code
(`.Rprofile` removed, dragon 67): `makePedigreeMatingLayout(matings = )` read a `sire`/`dam` table;
`.findIsolatedIds()` left out no declared partner; `.buildMatingUnitForest()` added a mating unit for each declared
pair with no offspring together, after the units built from offspring (so every existing `__union_<n>` keeps its
number). `protorun.R` ran it on 10 typed shapes and on 100 seeded random family pedigrees (the generator of
`tests/testthat/helper-layoutHints.R:14`, 11 to 1,776 animals) with 1 to 3 declared matings each (200 in all,
every one of the 16 kinds of pair: founder or with parents, already a parent or not), in both edge styles.

1. **One stop, one line to fix.** 13 of the first 20 random pedigrees, and `secondMate` and `twoChildless`, stopped
   with "missing value where TRUE/FALSE needed" at `R/makePedigreeDiagramData.R:1524`: a mating unit's side is read
   from its offspring's mean (`childSide`, `:1522`), which is `NA` for a unit with none. With such a unit taking the
   sex rule there (`apply_fix.py`, variant `na`), **0 of 100 random pedigrees stopped in either style**.
2. **Each declared mating drawn as a mating.** In the direct style, all 200: the two partners and the mating point on
   one row, the point between them, nothing else drawn between them (`checkMatings()`). The typed shapes drew
   `[A B E F] [C D]` (the gap case), `[E F]` (`onlyTwo`, which kinship2 and Pedixplorer cannot draw), `[C E D]`,
   `[E K]` on K's row, `[H C E D]`. A related pair's mating line is drawn as today's related parents' (`#D55E00`,
   width 4) with no further change (`extras.R`, `sibMates`).
3. **Repeat nodes.** A declared partner with parents of its own is drawn again beside its mate, as for a mating
   with offspring today (S678's rule): `sibMates` `[C D' D]`, `bothHaveParents` `[C J' D J]`, where kinship2 draws
   `C#D` and `C=J` without a repeat. With today's anchor rule (the partner with fewer matings anchors) an animal with
   two matings is drawn twice: `secondMate` `[A B A' G]`, `twoChildless` `[A B A' G]` where kinship2 draws `G=A=B`
   and `B=A=G`. 72 of the 100 random pedigrees gained repeat nodes, 130 in all (1 to 4 each). A "hub" variant (for
   a unit with no offspring only, the partner with more matings anchors) drew `twoChildless` as kinship2 does,
   `[B A G]`, but `secondMate` as `[A G A' B]`, and 129 repeat nodes in 72 pedigrees: a choice for G15a's picker.
4. **Lines through animals.** In the rectilinear style, 7 of the 100 pedigrees (seeds 18, 30, 55, 65, 73, 77, 84)
   gave more "same-row edge-node collision(s) could not be fully resolved" warnings with the matings than without,
   and 1 fewer; G15a reads them before RED.
5. **The hover** of a mating point with no offspring reads "0 offspring" (`:2554`).
6. **The returned hints.** The layout returns a `mate` row for the declared pair (`E F left`, G10's rule); passed
   back with the same `matings` it stops on R70's check, which reads only offspring (`.layoutHintTogether()`,
   `R/layoutHints.R:189`). G10's promise that returned hints give the same layout needs that check to accept a
   declared pair.
7. **Fidelity.** The fidelity tool run on the prototype (`matings` absent): **600 results, 600 identical**, kinship's
   largest difference 0, exit 0 (`fidelity_na.out`).
8. **Speed.** A layout with matings took a median 0.05 s, at most 6.1 s (the 1,776-animal pedigree, rectilinear;
   4.4 s direct). Not timed without them.

---

## 5. The interface (R141, with what each build session decides)

**`makePedigreeMatingLayout(ped, ..., lineWidth = 1, matings = NULL)`** (G15a). `matings`: `NULL` or zero rows,
no declared mating (the layout of today, 600 of 600); otherwise a data frame with the columns `sire` and `dam`
(text or factor; other columns ignored, so `getMatings()`'s result can be passed with rows added). Each row is a
mating: its two animals are drawn joined, on the row of the later-generation partner (R71's rule, as kinship2 and
Pedixplorer draw `crossGen`), the mating point between them, with no line down when they have no offspring
together; neither is left out as isolated; a hint may place it (R70's check accepts it); the layout's returned hints
include it. A row naming a pair with offspring together changes nothing (both packages accept `redundant`).
Stops (decided now, as both packages and R70 stop): not a data frame; a column `sire` or `dam` missing; `NA`; an id
not in `ped`; the same id as sire and dam. **G15a's picker decides:** a pair named twice (Pedixplorer stops, kinship2
accepts); the sexes (both packages accept two males and an unknown sex; kinship2's spouse hint refuses them;
pedkindraw's offspring matings are not sex-checked today); the anchor of an animal with several matings (section 4,
item 3); the hover's words; rows naming animals a trimming function removed (stop, as hints do, or leave them out
with a message).

**`getMatings(ped, matings = NULL)`** (G15b). With `matings`, its declared pairs with no offspring together are
added after the matings built from offspring, in their rows' order, with `offspring` 0, so that R119's "the matings
the drawing's layout builds" holds for the same input. Checked as the layout checks them (one shared check).

**`asPedFrame(x)`** (G15c). A fourth element, `matings`: `NULL` or a data frame `sire`, `dam` from kinship2's
relation code 4 (number or text) and Pedixplorer's `"Spouse"` rows, the male as sire. **G15c's picker decides:** a
pair with offspring together (kept or left out); a pair the layout would refuse (left out with the one message, as
R74 fixes hint rows); a same-sex pair. A mate hint row naming a declared pair is kept (no longer "left out, no
offspring together"); one naming an undeclared pair with no offspring together is left out as now, with R74's reason
reworded to section 2's measures.

**Not changed:** `drawPedigreeDiagram()` (it draws any layout; its legend has no mating row); `makePedigreeDiagramData()`
(it draws sire-to-offspring and dam-to-offspring lines only and leaves no animal out: no mating to add, as R61 kept
hints out of it); `kinship()`, `findGeneration()`, `countOffspring()` and the trimming functions (a mating with no
offspring changes no relationship, generation or offspring count).

---

## 6. Inventory (grep, at `d58a52f`)

Searched: `.findIsolatedIds`, `isolatedIds`, `.buildMatingUnitForest`, `.positionMatingUnitForest`,
`.layoutHintTogether`, `.layoutHintsUsedMate`, `.asPedFrameUsableMate`, `.asPedFrameTwins`, `.asPedFramePxTwins`,
`getMatings`, `"%d offspring"`, `childSide`, `makePedigreeMatingLayout(` (615 calls in `R/`, `tests/`, `tools/` and
`vignettes/`, none naming an argument after `lineWidth`, so a new last argument changes none), and the help text
"offspring together", "shared child", "no recorded parents", "isolated", over `R/`, `tests/`, `tools/`,
`vignettes/`, `README.Rmd`, `NEWS.md`, `_pkgdown.yml` and `man/`.

| File | Lines (text) | Change | Phase |
|---|---|---|---|
| `R/makePedigreeDiagramData.R` (copied) | `:2179` (`lineWidth = 1.0) {`), `:2206` (`hints <- .checkLayoutHints(hints, ped)`) | the argument, checked before the hints | G15a |
| | `:540`-`:553` (`.findIsolatedIds()`), help `:513`-`:538` ("only recognizes a union via a shared child") | a declared partner is not isolated; help | G15a |
| | `:2276` (the call), `:2282`-`:2286` (the message) | passes `matings`; the message's words stay true | G15a |
| | `:638` (`.buildMatingUnitForest()`), `:669`-`:686` (the pair keys and the unit's sire and dam) | a unit per declared pair, after the offspring units | G15a |
| | `:2327` (the call) | passes `matings` | G15a |
| | `:1522`-`:1528` (`childSide`) | a unit with no offspring takes the sex rule | G15a |
| | `:1382`-`:1387` (`xDerivableUnits`), `:1407`-`:1453` (Tier 3's `derivedX()`) | none in the prototype (a unit with no offspring keeps `NA` there; the seeding at `:1503`-`:1562` sets it): read in G15a | G15a |
| | `:2554` (`"%d offspring"`) | per G15a's picker | G15a |
| | help `:1812` ("It cannot be turned off, unless a mate hint says"), `:1930` and `:1947` (`hints$mate`: "a sire and a dam with offspring together"), `:2117`-`:2122` (`isolatedIds`) | `@param matings`; the hint and `isolatedIds` help name declared matings | G15a |
| `R/layoutHints.R` (own) | `:28` (`.checkLayoutHints()`), `:114`-`:180` (`.checkLayoutHintMate()`, R70), `:148` and `:189` (`.layoutHintTogether()`), help `:101` | a pair with offspring together or declared in `matings` | G15a |
| | `:450`, `:489` (`.layoutHintsUsedMate()`, G10) | none expected (the prototype returned the declared row); tested | G15a |
| `R/getMatings.R` (own) | `:6`-`:40` (help, examples, `getMatings <- function(ped)`) | the argument; help | G15b |
| `R/pedkindraw-package.R` | `:23`-`:24` ("lists the matings, each sire and dam with an offspring together") | words | G15b |
| `README.Rmd` | `:167` (`getMatings()` lists ...) | words | G15b |
| `R/asPedFrame.R` (own) | help `:37`-`:40` (code 4 left out), `:86` (spouse pairs left out), `:111` (R74's reason), `@return`; `:248` and `:351`-`:353` (the two returns); `:287` (`.asPedFrameTwins()`), `:404` (`.asPedFramePxTwins()`); `:496`-`:527` (`.asPedFrameUsableMate()`) | the fourth element; a mate hint row naming a declared pair kept | G15c |
| `R/checkTwinRelations.R`, `R/kinship.R`, `R/mzTwinGroups.R`, `R/comparePedigreeStructure.R`, `R/drawPedigreeDiagram.R`, `R/orderRootSubtrees.R` | read `twinRelations` or call the layout's internals | none (section 5) | -- |
| `tests/testthat/test_findIsolatedIds.R`, `test_makePedigreeMatingLayout.R`, `test_layoutHintsMate.R` (`:241`, R70's stop) | 17, 12 and 1 references | unchanged; new tests beside them | G15a |
| new `tests/testthat/test_matesNoOffspring.R` (name at G15a's RED) | -- | the typed shapes, seeded random cases with `checkMatings()`'s checks, the hints round trip, the related pair's line, a headless-Chrome test | G15a |
| `tests/testthat/test_getMatings.R`, `helper-offspringAndMatings.R` | 27 references | new tests | G15b |
| `tests/testthat/helper-asPedFrame.R:139`, `helper-asPedFramePedixplorer.R:78`, `test_asPedFrameHints.R:127`; `test_asPedFrame.R:156` and `test_asPedFramePedixplorer.R:134` ("spouses left out") | the 10 measured failures; the two spouse tests | `matings = NULL` added; the spouse tests read `$matings` too | G15c |
| `vignettes/drawing.Rmd` | `:69` ("A mating is the small dot between two mates, with lines down to each of their offspring"), `:433`-`:446` (the left-out animal and its checks) | a sentence and an example, its claims checked in the chunk | G15a |
| `tools/gapCases.R` | `:289`-`:312` (`matesNoOffspring`) | probes with `matings`: `isolatedIds` empty, E and F drawn as a mating, the mate hint accepted | G15a |
| `tools/gapCasesNprcgenekeepr.R` | `:89`-`:92` | none: nprcgenekeepr keeps the gap until the switch | -- |
| `DIVERGENCE.md` | rows `makePedigreeMatingLayout()` (`:14`), `.positionMatingUnitForest()` (`:17`), `.buildMatingUnitForest()` (`:18`); a new row `.findIsolatedIds()` | each names G15a's change, "at the switch" (R98) | G15a |
| `docs/planning/pedkindraw-api-contract.md` | `:135` (the layout), `:186` (`getMatings()`), `:214` (`asPedFrame()`) | each row | G15a, G15b, G15c |
| `NEWS.md` | -- | a bullet each | G15a, G15b, G15c |
| `docs/research/pedkindraw-gaps-2026-11-18.md` | B1 | none: a dated record (`CLAUDE.md` "Governing documents") | -- |

---

## 7. Phases

**Common to each** (the gaps plan's "Every G phase", `docs/planning/gaps-and-shared-code-plan.md:341`): strict TDD,
its three gates and a pre-RED picker by `AskUserQuestion` in plain words; every expected value computed before RED
(Learnings 18-21); **DONE:** the full suite 0 failed, WARN 0; `lintr::lint_package()` 0; `roxygen2::roxygenise()`
leaves `NAMESPACE` and `man/` unchanged; `covr` reaches every new statement; `R CMD check --as-cran` R16's NOTE only;
a NEWS bullet; the contract's row; the drift tool exit 0 with each changed copied function's row; the fidelity tool
600 of 600 identical (each phase only adds). **Commands:** `CLAUDE.md`'s Build / Test / Verify table, with
`NOT_CRAN=true` for the browser tests; `Rscript tools/compareWithNprcgenekeepr.R ../nprcgenekeepr`;
`Rscript tools/compareResultsWithNprcgenekeepr.R ../nprcgenekeepr`; `Rscript tools/gapCases.R matesNoOffspring`
(then `rm -f Rplots.pdf`). **Surface:** this Mac; GitHub Actions after the push, where Ubuntu release runs the
browser tests in Chrome and Ubuntu R-devel stops before checking pedkindraw (Bioconductor's S4Vectors in
"setup-r-dependencies", S56-S63), so R-devel enforces nothing; CRAN's machines skip the browser tests
(`skip_on_cran()`), so a drawing is checked only here and on GitHub. kinship2 and Pedixplorer are compared only where
each returns (section 2: both fail on `onlyTwo` and `twoChildless`).

### G15a -- the layout draws declared matings (one session; two if item 3 or 4 of section 4 grows)

- **Work:** section 5's `makePedigreeMatingLayout(matings = )`, `.findIsolatedIds()`, `.buildMatingUnitForest()`,
  the `childSide` line, R70's check, the help, the vignette's sentence and example, the gap case's probes, the four
  `DIVERGENCE.md` rows, the contract row, NEWS.
- **Measure before the pre-RED picker** (Learning 17, on a scratch copy; the prototype scripts of section 10 are the
  start): pictures in headless Chrome at 500 px of the typed shapes in both edge styles, for the anchor choice and
  for what a mating point with nothing below looks like; the 7 seeds' extra collision warnings (which line crosses
  which animal, and whether the declared mating causes it); each anchor variant's repeat nodes on the random cases;
  what a trimming function's output does to a `matings` table.
- **Pre-RED picker:** the anchor of an animal with several matings when one has no offspring (today's rule or the
  hub rule; counts from section 4, item 3); a pair named twice; the sexes; the hover's words; rows naming removed
  animals; whether the mating point is drawn.
- **DONE, its own:** `matesNoOffspring` with `matings = data.frame(sire = "E", dam = "F")`: `isolatedIds` empty, E and
  F drawn on one row with the mating point between them and nothing between, in both edge styles, and in headless
  Chrome (vis.js's positions and the drawn mate line, no line down from the point); every typed shape of section 4
  as picked; seeded random cases (at least 100 pedigrees, a floor with `expect_gte()`) all drawn with each declared
  mating's checks; the related pair's line `#D55E00`, width 4; the returned hints passed back with the same
  `matings` give the same layout; each stop tested; 600 of 600.
- **Surface:** as common; the browser test reads the canvas (dragon 73: an outline in screen pixels, a line in
  units).
- **Session boundary:** close out when DONE. The 5-file cap splits GREEN into commits (`R/`, then `man/` and
  NEWS, then `DIVERGENCE.md`, contract, vignette, gap case).

### G15b -- `getMatings()` lists declared matings (one session)

- **Work:** `getMatings(ped, matings = NULL)`, the shared check, help, `R/pedkindraw-package.R:23`, `README.Rmd:167`,
  contract `:186`, NEWS.
- **Pre-RED picker:** the declared matings' place in the result (after the offspring matings, or in one order of
  first appearance); `offspring` 0 or a separate column saying a row was declared.
- **DONE, its own:** on the typed shapes and the random cases, `getMatings(ped, matings)` lists exactly the matings
  G15a's layout draws, in the layout's order (R119's claim kept: the drawn mating points, read from the layout,
  equal the rows); without `matings`, every existing `getMatings()` test unchanged.
- **Surface:** this Mac; no browser.
- **Session boundary:** close out when DONE.

### G15c -- the converters keep the matings (one session)

- **Work:** `asPedFrame()`'s fourth element for kinship2 (`pedigree`, `pedigreeList`) and Pedixplorer, the mate
  hint rows naming a declared pair kept, R74's reason reworded (section 2), help, contract `:214`, NEWS; the 10
  measured test changes (`matings = NULL`) and the two spouse tests.
- **Measure before the pre-RED picker:** `asPedFrame()` then the layout on every typed shape of section 2 and on
  seeded random pedigrees with code 4 or `"Spouse"` rows, against kinship2's and Pedixplorer's rows where each
  returns (Learning 19); which hint rows `autohint()` and `auto_hint()` write for declared pairs.
- **Pre-RED picker:** a declared pair with offspring together; a pair the layout refuses; a same-sex pair (as G15a's
  sex rule).
- **DONE, its own:** each typed shape converted and drawn: the matings kinship2 and Pedixplorer draw are drawn by
  pedkindraw (rows compared as joined pairs, not as positions, R69); the round trip of a data frame with `matings`
  through `kinship2::pedigree()` and `Pedixplorer::Pedigree()` and back gives the same `matings`; every existing
  converter test passes with `matings = NULL` added.
- **Surface:** this Mac; kinship2 and Pedixplorer from renv (Suggests).
- **Session boundary:** close out when DONE; G15 DONE (the gaps plan's row, the backlog item).

**Sessions:** 1 (this) + 3 to 4 (a guess; the gaps plan guessed 1 + 3-5).

---

## 8. Here be dragons (found this session)

1. **A unit with no offspring has no side** (`R/makePedigreeDiagramData.R:1522`-`:1524`): `childSide` is the sign of
   the offspring's mean minus the anchor's place, `NA` with no offspring, and `NA == 0.0` stops an `if`. It is
   reached only when the anchor has that one mating and `qualifies()` refuses it (a mate with other matings, or sexes
   not male and female); the gap case itself does not reach it, `secondMate` does. Seed the RED with such a case.
2. **Today's anchor rule draws a hub twice** (section 4, item 3): the partner with fewer matings anchors, so a sire
   with two dams, one of them with no offspring, is drawn at each. Decide it at G15a's picker with pictures.
3. **The layout returns the declared pair as a hint** (G10, `.layoutHintsUsedMate()`), and R70's check refuses it
   unless it reads `matings`: `.checkLayoutHints()` needs the table, so `matings` is checked first.
4. **R74's stated reason is wrong for some shapes** (section 2): kinship2's spouse hint alone draws a pair with no
   offspring in 11 of the 13 such shapes. A reason recorded from one typed case is a claim about that case (Learning 19).
5. **Both references fail where pedkindraw does not:** kinship2's `plot()` on fewer than 3 animals and on
   `twoChildless`, Pedixplorer's `align()` on both. A test comparing with them must skip those, and count how many it
   compared (`expect_gte()`).
6. **Pedixplorer refuses a pair named twice; kinship2 accepts it.** Pedixplorer's `rel()` is an S4 object: read it
   with `as.data.frame()` (`$` stops).
7. **New units go after the offspring units.** The fidelity results compare the layout's node ids, `__union_<n>`
   among them: units numbered from the declared table first would renumber every existing one (the prototype appends
   and reads 600 of 600).
8. **A repeat node beside a declared mate with parents** is today's rule for a mating with offspring (S678), so it
   is not a G15 change; kinship2 draws such a pair without one (`C#D`, `C=J`). Say so in the help rather than change
   it.

---

## 9. Out of scope

- A mark for a mating with no offspring by choice or infertility on the mating line (the clinical standard's line
  down from the mating with one or two bars): pedkindraw draws Pedixplorer's fertility marks under the animal (G13,
  R138); a mating-line mark would be a new gap.
- Inferring a mating from a mate hint alone (kinship2 does, section 2): hints stay placement only (R60, R141).
- Any change to nprcgenekeepr (R8, R98, R101).
- The drawing vignette's other open items (`methodology/BACKLOG.md:60`, `:67`).

---

## 10. Sources

- `docs/research/pedkindraw-gaps-2026-11-18.md` (B1); `docs/planning/gaps-and-shared-code-plan.md` (sections 4 and
  5.1); `docs/planning/standalone-pedigree-package-plan.md` (R60, R61, R69-R74, R98, R101, R117, R119, R127-R128,
  R141); `docs/planning/layout-hints-design.md` (D6, the spouse hint with no child); `docs/planning/pedkindraw-api-contract.md`
  (sections 4.1, 4.4, 4.5); `DIVERGENCE.md`; `CLAUDE.md` (Learnings 7, 11, 17-21).
- S64's scratch scripts (not committed; session scratchpad `g15/`): `refcases.R` (the 16 shapes in kinship2 and
  Pedixplorer, one process each under `timeout 30`), `pxhint.R` (Pedixplorer's spouse hint alone), `apply_proto.py`
  (the prototype's edits, dry-run on a copy first), `apply_fix.py` (variants `na` and `hub`), `protorun.R` (typed
  shapes and seeded random cases; `checkMatings()`, `pickMatings()`), `tabulate.R`, `extras.R` (the related pair's
  line, the hover, the returned hints), `trace.R` and `trace2.R` (the stop's condition call), `apply_option.py` and
  `runtests.R` (each input option's test cost), `fidelity_na.out` (the prototype's fidelity run).
