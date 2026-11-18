# What kinship2 and Pedixplorer can do that pedkindraw cannot (2026-11-18)

**Date:** 2026-11-18 · **Session:** pedkindraw S40 · **Plan:** `docs/planning/cran-submission-plan.md`, Phase 17f
(section 8), ruling R84 of `docs/planning/standalone-pedigree-package-plan.md`; the backlog item "What kinship2 or
Pedixplorer can do that pedkindraw cannot" (Mark, S26: "document what pedkindraw does not do that kinship2 or
pedixplorer can do. Later we will decide if those gaps should be addressed and removed").
**Type:** a dated research record. It says what was measured and decides nothing. Which gaps, if any, are closed
before the first CRAN release is Mark's decision D4 (the plan's section 9), asked after this document.

**Versions:** kinship2 1.9.6.2 and Pedixplorer 1.8.0 from this project's renv library (both are Suggests);
pedkindraw at commit `2626c16` (its `R/` unchanged in this session), loaded from the working copy with
`pkgload::load_all()`; R 4.6.2; visNetwork's bundled vis-network for the one browser case.

**Surface:** this Mac only (Apple M2 Max, 96 GiB). The machine's load average was 6.7 during the recorded run. The
claims below cover the cases run, no more (CLAUDE.md Learning 19). The two seconds-and-memory figures (section 6.1)
are one run each.

**How each case runs:** `tools/gapCases.R` holds 20 cases. Each types a small pedigree (or reads one shipped with a
package), runs kinship2, Pedixplorer and pedkindraw on it, and prints one line per result. A call that stops is
recorded as "stops" with its message, a warning as "warns", and the case goes on (`tryCatch()`). Run with no
argument, the script starts each case in its own R process under GNU `timeout`: 60 s for most, 180 s for the
browser case, 600 s for the 28,081-person kinship case. All 20 finished, each with exit 0, in 82 s altogether.
The full output is beside this document, `docs/research/pedkindraw-gaps-2026-11-18-cases.txt`. To rerun:
`Rscript tools/gapCases.R` (every case) or `Rscript tools/gapCases.R <case>` (one), from the repository's root.
Section 10 (added after Mark asked which gaps nprcgenekeepr has) runs nprcgenekeepr's own code on the same typed
pedigrees with `tools/gapCasesNprcgenekeepr.R`; its output is `docs/research/pedkindraw-gaps-2026-11-18-nprcgenekeepr.txt`.

---

## 1. Summary

16 gaps in three groups (A 3, B 7, C 6), then the items already ruled on or found not to be gaps. "Size" is a
guess at the work to close a gap (S one session, M two or three, L more, or a plan of its own first); nothing was
built to check it.

| # | Gap | Who has it | Case | Size (a guess) |
|---|---|---|---|---|
| **A** | **Pictures outside the browser** | | | |
| A1 | Picture files (PDF, SVG, PNG) and a ggplot object from a script | both | `files` | L |
| A2 | A whole large pedigree in one picture, every id written | kinship2 (Pedixplorer leaves 18 of 375 out) | `largeIds` | comes with A1 |
| A3 | A ready-made app: load a file, choose a family, draw | Pedixplorer | `app` | L |
| **B** | **What a drawing can show** | | | |
| B1 | Two animals mated, with no offspring together | both | `matesNoOffspring` | M-L |
| B2 | An affected status recorded as unknown, marked on the symbol | both | `unknownAffected` | S |
| B3 | Carrier, proband, consultand, evaluated, genotyped, infertile and miscarriage marks | Pedixplorer | `markings` | M-L |
| B4 | A measured trait: affected above a threshold, with its legend | Pedixplorer | `measuredTrait` | M |
| B5 | Colours, hatching, symbol and text sizes, spacing | both | `style` | S-M |
| B6 | Label text longer than 15 characters on the drawing | both | `labels` | S |
| B7 | A picture of what shrinking removed | kinship2 | `shrinkPicture` | S-M |
| **C** | **Computing and input** | | | |
| C1 | Keep the relatives within k steps of the informative animals | Pedixplorer | `distanceSubset` | M |
| C2 | Generation numbers aligned for drawing | kinship2 (Pedixplorer's argument not run) | `alignedDepth` | S |
| C3 | The package's own layout hints, returned to edit | both | `ownHints` | M |
| C4 | Missing parents written "0" or "", sex written 1/2, "male"/"female" or "m"/"f" | both | `inputCodes` | S |
| C5 | Small lookups: each animal's offspring count, its mates | Pedixplorer | `lookups` | S |
| C6 | Remove listed animals, a parent among them, in one call | Pedixplorer | `removeAnimals` | S |

B3 is one row for seven marks Pedixplorer draws. Section 6 lists the gaps already ruled out (block kinship R3,
file readers R13, datasets R21, object classes R7) and three things that looked like gaps and are not.

### 1.1 What each gap means for someone using pedkindraw

Drawn from the "pedkindraw today" lines of sections 3-5 and the measured results there.

| Gap | What it means for a user | Way round it today |
|---|---|---|
| A1 | A drawing cannot go straight into a paper, a printed report or a PDF or Word document made with R Markdown; it shows only in HTML output, and a PNG only from the button in a browser | none in pedkindraw; draw that figure with kinship2 or Pedixplorer |
| A2 | No one-page overview of a large pedigree with ids, on screen or on paper: the 375-animal rhesus pedigree shows no id until zoomed in 6.3 times | zoom in, or hover |
| A3 | Users must write R; nobody can load a file and click | none in pedkindraw (nprcgenekeepr's app, section 10) |
| B1 | A planned or unsuccessful mating cannot be shown; both animals disappear | none |
| B2 | A reader can take missing data for "not affected"; only the hover says "Unknown" | none on the drawing |
| B3 | Clinical-style pedigrees cannot be drawn; for a colony the likely one is a genotyped mark | an extra `affected_...` column, drawn as a coloured section |
| B4 | The true-or-false column must be made first; numbers passed instead are drawn affected wherever they are not 0, with no message | `ped$affected <- ped$value > 5` |
| B5 | Colours cannot match a journal's or print in black and white; colours edited by hand make the legend and the drawing disagree | none reliable |
| B6 | Notes under the id longer than 15 characters are cut on the drawing | the full text is in the hover |
| B7 | Which animals `shrinkPedigree()` dropped cannot be seen at a glance | a condition column from `idTrimmed` (not tried) |
| C1 | Only ancestors are kept around the informative animals, not near relatives | write the rule |
| C2 | Little: the layout aligns mates itself | none needed |
| C3 | Adjusting a drawing means writing hints from nothing | kinship2's `autohint()`, converted by `asPedFrame()` |
| C4 | Data from other tools must be recoded first; `checkPedigree()` names the problem, but generations come back `NA` and every animal is drawn as a diamond | recode in base R |
| C5 | Minor | `length(getOffspring(ped, id))` |
| C6 | Dropping a parent's row stops `kinship()` | `addParents()`, or set those parent entries to `NA` |
| R3 (ruled) | 28,081 people needed about 9-10 GB and 14 s, against kinship2's 0.2 GB and 0.4 s | run family by family |

---

## 2. Terms

- **Gap:** something kinship2 1.9.6.2 or Pedixplorer 1.8.0 does, through an export or an argument, that no
  pedkindraw export or argument does. A gap can still have a way round it by hand in base R; each section says so
  under "pedkindraw today".
- **Case:** a typed pedigree and the calls on it, in `tools/gapCases.R`, named in the table's "Case" column. Its
  results are quoted from the recorded output.
- **Open gap:** sections 3-5. Mark decides, by D4, whether any is closed before the release.
- **Ruled:** a gap Mark has already ruled out of pedkindraw (section 6.1); its ruling is named and it is not asked
  again.
- **Not a gap:** something that looked like a gap but that the other package does not do, or does not do at its
  defaults, on the cases run (section 6.2).
- **Mate, mating:** two animals drawn joined as parents. kinship2 and Pedixplorer call it spouse and marriage, words
  for human families; this document uses the animal words.
- **Proband, consultand:** human-genetics words Pedixplorer uses. A proband is the affected family member who
  brought the family to attention; a consultand is the person asking for counselling. Each gets an arrow.
- **Genotyped:** pedkindraw's word for what kinship2 and Pedixplorer call available (`avail`): a sample exists.

---

## 3. Group A: pictures outside the browser

### A1. Picture files from a script

- **There:** `kinship2::plot.pedigree()` and `Pedixplorer::plot()` draw with R's own graphics, so any R graphics
  device takes the picture: a PDF or SVG file for printing or a paper, a PNG, a window. Pedixplorer also returns
  the picture as a ggplot object (`plot(ggplot_gen = TRUE)`), which ggplot2 can save or change.
- **The case (`files`):** four animals (A and B, with offspring C and D), drawn into a PDF, an SVG and a PNG file by
  each package. kinship2: PDF 4,742 B, SVG 8,606 B, PNG 9,872 B; Pedixplorer 4,752 B, 8,957 B and 9,489 B; each
  PDF one page. Pedixplorer's `ggplot` element has class `ggplot2::ggplot`.
- **pedkindraw today:** `drawPedigreeDiagram()` returns a `visNetwork` htmlwidget, drawn by JavaScript in a
  browser. Its only print method is `print.htmlwidget` (no method for a graphics device): `plot()` on it inside
  `pdf()` stops ("'x' is a list, but does not have components 'x' and 'y'") and the PDF has 0 pages. A script can
  save a web page (`htmlwidgets::saveWidget()`, 6,586 B plus its library folder); a PNG comes only from the
  widget's *Export Diagram (PNG)* button, in a browser. No SVG or PDF. This is the comparison study's "missing
  beside the others: SVG and PDF export" (`docs/research/pedigree-package-comparison-2026-11.md`, section 10).
- **To close it (a guess, L):** either a second renderer that draws the layout `makePedigreeMatingLayout()`
  already returns (positions of every symbol and line) with R graphics, its symbols, condition sections, slashes,
  twin lines and legend redrawn; or a screenshot of the widget taken by a headless browser (chromote, already a
  Suggests for the tests), which needs Chrome on the user's machine and gives PNG or PDF, not SVG.

### A2. A whole large pedigree in one picture, every id written

- **There:** kinship2 writes every animal's id into its one-page picture, however small; in a PDF or SVG file the
  ids can be read by zooming the file or printing it large.
- **The case (`largeIds`):** the 375-animal rhesus pedigree the vignettes use (`inst/extdata`, R80). kinship2
  writes 520 id labels into its page, 375 of them distinct (the others are animals drawn twice). Pedixplorer stops
  at its default text size ("Labels leave no room for the graph, reduce cex"); at `cex` 0.5 or 0.2 it writes 473
  labels, 357 distinct, leaving 18 animals out (as the comparison study found, its section 8.2).
- **pedkindraw today:** all 375 animals are drawn. In the fitted view a page first shows, at the website's 776 px
  width (a canvas 691 px wide in headless Chrome), the zoom scale is 0.0456, so a 14 px label would be 0.638 px
  tall; vis-network draws a label only when it would be at least 4 px (its `scaling.label.drawThreshold`, 5, less
  1, in the bundled `vis-network.min.js`). No id shows until the reader zooms in 6.27 times. This is the comparison study's "a fitted view of a large pedigree that shows ids without
  zooming" (its section 10).
- **To close it:** in a file, it comes with A1. In the browser, lowering vis-network's threshold would draw labels
  under a pixel tall, which nobody can read; the measured gap is about a printed page.

### A3. A ready-made app

- **There:** Pedixplorer ships a Shiny application, `ped_shiny(port, host, precision, ind_max_warning,
  ind_max_error)`, and the 20 modules and demonstrations it is built from (section 8): load a pedigree file, choose
  a family and a condition column, pick informative animals, draw and download.
- **The case (`app`):** `Pedixplorer::ped_ui()` builds (class `shiny.tag.list`); the app itself was not run.
- **pedkindraw today:** no export names an app, Shiny, a server or a user interface. `drawPedigreeDiagram()`'s
  `onClick` lets an application someone else writes act on a clicked animal (nprcgenekeepr's Pedigree Browser is
  one; it stays in nprcgenekeepr).
- **To close it (a guess, L):** a new application, with a plan of its own first.

---

## 4. Group B: what a drawing can show

### B1. Two animals mated, with no offspring together

- **There:** kinship2's `pedigree(relation = )` takes code 4 for two animals that are mates, and Pedixplorer's
  relation table takes `"Spouse"`; both draw the two joined as a mating even with no offspring.
- **The case (`matesNoOffspring`):** A and B with offspring C and D, and E (male) and F (female) declared mates with
  none. kinship2's `align.pedigree()` and Pedixplorer's `align()` each mark 2 matings (A with B, E with F).
- **pedkindraw today:** there is no input that declares a mating. E and F are left out of the drawing
  (`isolatedIds`: E, F, with the message that animals "with no recorded parents, mates, or offspring" are
  suppressed). A mate hint naming them stops: "found pair(s) in 'hints$mate' with no offspring together in 'ped':
  E and F" (R70).
- **To close it (a guess, M-L):** a table of matings (or a new code in the twins table, as kinship2 does), and a
  mating with no offspring placed by the layout engine, which today builds every mating from shared offspring.

### B2. An affected status recorded as unknown

- **There:** kinship2 draws a "?" in the symbol of an animal whose affected status is `NA`; Pedixplorer fills it
  grey, between the affected and unaffected colours.
- **The case (`unknownAffected`):** affected A and D, unknown B, unaffected C. kinship2 draws 1 "?" (0 when no
  status is unknown). Pedixplorer fills A, B, C, D red, grey, white, red.
- **pedkindraw today:** B is filled white (`#FFFFFF`), as C is, so the drawing does not tell unknown from
  unaffected; its hover text says "Affected: Unknown".
- **To close it (a guess, S):** a fill or mark for `NA`, and a legend row for it.

### B3. Pedixplorer's other marks on a symbol

- **There:** Pedixplorer's `Pedigree()` takes more columns about each animal, and its picture marks each one.
- **The case (`markings`):** each column given alone on the four animals; what the picture gains:

  | Column (Pedixplorer) | Its mark, as counted in the picture's elements | pedkindraw's layout with the column |
  |---|---|---|
  | `carrier` | 1 point (a dot in the symbol) | identical to the layout without it |
  | `proband` | 1 arrow and 1 text | identical |
  | `consultand` | 1 arrow | identical |
  | `evaluated` | 1 text | identical |
  | `avail` (genotyped) | the borders of all 4 symbols change colour | identical |
  | `fertility` = "infertile" | 3 line segments under the symbol | identical |
  | `miscarriage` = "SAB" | the square becomes a triangle | identical |
  | `adopted` | nothing changes (stored, not drawn) | identical |
  | `asymptomatic` | stops: "arguments imply differing number of rows: 0, 1" | identical |

  kinship2's `pedigree()` takes none of them (its arguments: `id`, `dadid`, `momid`, `sex`, `affected`, `status`,
  `relation`, `famid`, `missid`).
- **pedkindraw today:** draws affected conditions (up to four) and deceased; every other column is ignored. A user
  can show one of these as an extra condition column (`affected_carrier`, say), drawn as a coloured section, not
  as Pedixplorer's mark.
- **To close it (a guess, M-L):** each mark is a column read by the layout, a shape or mark painted by the
  drawing's script, and a legend row; seven marks, or the few a colony uses (the genotyped border is the one with
  a pedkindraw name already, `genotyped` in `shrinkPedigree()` and `findUnrelated()`).

### B4. A measured trait

- **There:** Pedixplorer colours a numeric column by a threshold (`generate_colors(is_num = TRUE, threshold = ,
  sup_thres_aff = )`), or by a scale of colours (`keep_full_scale`, `breaks`), and writes the rule in the legend.
- **The case (`measuredTrait`):** values 2.5, 0, 0.3 and 9, affected above 5. Pedixplorer fills A, B, C, D white,
  white, white, red; its legend reads "Healthy <= to 5" and "Affected > to 5".
- **pedkindraw today:** a condition column is read as true or false. Given the same numbers as `affected`, A, C and
  D are drawn affected (every value other than 0) and B unaffected, with no message (section 9, item 1). The user
  makes the true-or-false column first: `ped$affected <- ped$value > 5`.
- **To close it (a guess, M):** a threshold for one column, or a colour scale and its legend for a measured trait.

### B5. Colours, hatching, sizes and spacing

- **There:** kinship2's `plot.pedigree()` takes `cex`, `col`, `symbolsize`, `branch`, `packed`, `align`, `width`,
  `density` and `angle` (hatching, for black-and-white printing); Pedixplorer's `plot()` takes `cex`,
  `symbolsize`, `branch`, `packed`, `align`, `width`, `leg_cex`, `lwd` and `label_cex`, and its colour functions
  take the colours of affected, unaffected and genotyped animals.
- **The case (`style`):** kinship2 with `col = c("red", "blue", "black", "black")` draws the four symbols' borders
  red, blue, black, black. Pedixplorer with `colors_aff = "orange"` fills the affected animals orange.
- **pedkindraw today:** `drawPedigreeDiagram(layout, edgeStyle, onClick)` takes no style argument; the four
  condition colours are fixed (`R/affectedConditions.R:23`). Editing the colours in a layout by hand does not work
  as a setting: with one condition, the two affected animals take an edited fill but the legend's "Affected" row
  keeps `#CC79A7` (`R/drawPedigreeDiagram.R:107`); with two conditions, edited `conditions$color` values reach the
  legend's pictures, but the animals' sections are painted from the drawing script's own list (`'#CC79A7',
  '#E69F00', '#56B4E9', '#009E73'`), so the drawing and its legend disagree (section 9, item 2). A user can still
  change some of the widget afterwards with visNetwork's own functions (not measured here).
- **To close it (a guess, S-M):** a `colors` argument carried to the fills, the sections script and the legend
  (S); sizes and spacing (M).

### B6. Label text longer than 15 characters

- **There:** kinship2 writes any label text, over several lines (`plot.pedigree(id = )`); Pedixplorer writes a
  `label` column under the id.
- **The case (`labels`):** "age 7", a line break, "MHC A01/B02 long text" (26 characters) for A. kinship2 and
  Pedixplorer each write the whole text.
- **pedkindraw today:** the `name` column is written under the id, line breaks kept, cut at 15 characters with
  "..." (`.nameLabelCharBudget`, `R/makePedigreeDiagramData.R:240`): "A", "age 7", "MHC A01/B...". The full text
  is in the hover.
- **To close it (a guess, S):** a setting for that limit, or a label column written whole.

### B7. A picture of what shrinking removed

- **There:** kinship2's `plot.pedigree.shrink()` draws a shrunken pedigree with the removed animals marked.
- **The case (`shrinkPicture`):** Pedixplorer's sample family 1 (41 animals), shrunk to 16 bits: kinship2 draws it,
  one PDF page.
- **pedkindraw today:** `shrinkPedigree()` returns the lists (`ped`, `idTrimmed`, `idList`, `bitSize`,
  `genotyped`, `pedSizeOriginal`, `pedSizeIntermed`, `pedSizeFinal`); a user could draw the original pedigree with
  a condition column made from `idTrimmed` (not tried).
- **To close it (a guess, S-M):** a documented example, or an argument that marks removed animals.

---

## 5. Group C: computing and input

### C1. Keep the relatives within k steps of the informative animals

- **There:** Pedixplorer's `is_informative()` picks the informative animals (for instance genotyped and affected)
  and `useful_inds(max_dist = k)` keeps the animals within k steps of them; `min_dist_inf()` gives each animal's
  distance.
- **The case (`distanceSubset`):** Pedixplorer's sample family 1, 41 animals, 7 of them genotyped and affected.
  `useful_inds()` keeps 14 animals at `max_dist = 1`, 30 at 2 and 33 at 3.
- **pedkindraw today:** `trimPedigree(ped, probands, removeUninformative, addBackParents)` keeps the 7 and their
  ancestors, 18 animals (13 with `removeUninformative = TRUE`); it has no distance. `getDescendantPedigree()` adds
  descendants. A different rule, not a weaker one: a user wanting Pedixplorer's must write it.
- **To close it (a guess, M):** a new function, its rule written from Pedixplorer's help page and measured
  results, as `findUnrelated()` was from kinship2's (R52).

### C2. Generation numbers aligned for drawing

- **There:** kinship2's `kindepth(align = TRUE)` gives a mate the generation of its mate, for drawing.
  Pedixplorer's `kindepth()` has the same choice (`align_parents`), not run here.
- **The case (`alignedDepth`):** sample family 1: the aligned numbers differ from the plain ones in 6 of 41
  animals. pedkindraw's `findGeneration()` equals kinship2's plain numbers in 41 of 41.
- **pedkindraw today:** its layout places mates on one row itself, so the drawing does not need the aligned
  numbers; a user who wants the numbers has no export for them.
- **To close it (a guess, S):** an argument to `findGeneration()`. Its value outside drawing is small.

### C3. The package's own layout hints, returned to edit

- **There:** kinship2's `autohint()` returns the hints its layout would use (`order`, `spouse`), which a user edits
  and passes back; Pedixplorer's `auto_hint()` does the same (class `Hints`), and its `best_hint()` searches for
  better ones (it stops here: "there is no package called 'R.utils'", which renv's library lacks).
- **The case (`ownHints`):** sample family 1.
- **pedkindraw today:** `makePedigreeMatingLayout()` takes hints (R61, R73) but returns none (`nodes`, `edges`,
  `duplicateToReal`, `isolatedIds`, `conditions`, `conditionsNotDrawn`), so an edit starts from nothing. One route
  exists, through kinship2: a `pedigree` carrying `autohint()`'s hints, passed to `asPedFrame()`, gives them in
  pedkindraw's form (41 order numbers and 1 mate row in the case; R62).
- **To close it (a guess, M):** return the layout's own order as hints.

### C4. Other ways of writing missing parents and sex

- **There:** kinship2's `pedigree(missid = )` names the code for a missing parent, and Pedixplorer reads `NA` and
  "0" as missing by default. Both read sex written as numbers 1 and 2, "male" and "female", or "m" and "f"
  (kinship2 stops on the text "1" and "2": "Invalid values for 'sex'").
- **The case (`inputCodes`):** the four animals with their missing parents written "0": kinship2 builds the
  pedigree (`missid = "0"`), Pedixplorer finds 2 founders. pedkindraw: `checkPedigree()` reports
  `missingParentCodes` for "0" (and for ""), but `findGeneration()` places none of the 4 (all `NA`, with a warning
  naming "0" as a parent with no record). Sex written each of the four ways: `checkPedigree()` flags 4 rows of 4,
  and the layout draws 4 diamonds (the symbol for an unrecorded sex) each time.
- **pedkindraw today:** `checkPedigree()` names the problem; the user recodes in base R, or builds a kinship2
  `pedigree` and converts it with `asPedFrame()`.
- **To close it (a guess, S):** a function that rewrites these codes into pedkindraw's (`NA`, "M", "F"), or
  arguments that accept them. Reading "0" as missing everywhere would change what an animal named "0" means.

### C5. Small lookups

- **There:** Pedixplorer's `Pedigree()` stores each animal's offspring count (A, B, C, D: 2, 2, 0, 0), and it
  exports `num_child`, `parent_of`, `is_parent`, `ancestors`, `is_founder`, `descendants` and `spouse`.
- **The case (`lookups`).**
- **pedkindraw today:** `getOffspring()`, `getParents()`, `getProbandPedigree()`, `getDescendantPedigree()`,
  `getFounders()`, `isFounder()`, `hasBothParents()` and `getIdsWithOneParent()`; no mates list and no count
  (`length(getOffspring(ped, "A"))` is 2).
- **To close it (a guess, S):** two small functions, if wanted at all.

### C6. Remove listed animals, a parent among them

- **There:** Pedixplorer's `subset(del_parents = "one")` removes the animals and clears the parent links that
  pointed to them.
- **The case (`removeAnimals`):** A and B with offspring C and D; C with E has F and G; D with H has I. Removing C,
  sire of F and G: kinship2's `pedigree.trim("C")` stops ("A subpedigree cannot choose only one parent of a
  subject"; removing the leaf I works, 8 left). Pedixplorer with `del_parents = "one"` keeps ABDEFGHI and gives F
  no sire and no dam (it clears E too, as Pedixplorer does not allow one known parent); with `NULL` or `"both"` it
  puts C back. pedkindraw, the row dropped: `checkPedigree()` reports `rowlessParents` C ("sire of F, G"),
  `findGeneration()` cannot place F and G, and `kinship()` stops ("pdepth must not be missing for any animal").
- **pedkindraw today:** two fixes by hand. `addParents()` puts C back as a founder (9 rows; kinship of F and G
  0.25), or the user clears C from the `sire` column (kinship of F and G 0.125, one known parent being legal here).
- **To close it (a guess, S):** a function that removes animals and clears their links. Before this session's
  measurement the framing outline listed this as not a gap; the case changed that.

---

## 6. Already ruled, and not gaps

### 6.1 Ruled by Mark

| Gap | Ruling | Measured here |
|---|---|---|
| Kinship over many families, built family by family (kinship2's `makekinship()`, the `pedigreeList` method) | R3 (S742): OUT, "block-sparse `makekinship`" (`docs/planning/standalone-pedigree-package-plan.md:124`) | `blockKinship`: kinship2's minnbreast, 28,081 people in 426 families. kinship2 0.4 s and 202 MB at R's peak (`gc()`); pedkindraw's `kinship(sparse = TRUE)` 14.4 s and 8,863 MB, because it fills a dense 28,081 by 28,081 matrix first (`R/kinship.R:184`) and makes it sparse at the end. The values are the same (largest difference 0, matched by id); kinship2 stores one triangle (512,843 values), pedkindraw both (997,605). A scratch run read the whole process's peak with `/usr/bin/time -l`: 347 MB and 10.2 GB (not in the record). On a machine with less than about 10 GB of memory pedkindraw would likely fail on this pedigree (an inference, not tried) |
| Reading pedigree files (Pedixplorer's `plink_to_pedigree()`, and its `norm_ped()` reading text dates and codes) | R13 (S1128): "The file readers stay out" (`:134`) | `plinkReader`: Pedixplorer reads a typed 4-line PLINK `.fam` file into a `Pedigree`; pedkindraw has no export naming read, file or PLINK |
| Example datasets | R21 (pedkindraw S3): the tests' pedigrees are fixtures, not package datasets, and help examples type their own (`:143`); R80: the vignettes' rhesus files in `inst/extdata` (`:202`) | `datasets`: kinship2 3 (`minnbreast`, `sample.ped`, `testped1`), Pedixplorer 3 (`minnbreast`, `relped`, `sampleped`), pedkindraw 0 and the 2 rhesus files |
| Pedigree objects and their methods (kinship2's `pedigree`, `print`, `as.data.frame`, `[`; Pedixplorer's 11 S4 classes, `summary`, `show`, 30 pairs of slot accessors) | R7 (S1121): data frames, plus converters (`:128`) | from the export lists; `asPedFrame()` converts both packages' objects |

### 6.2 Not gaps, on the cases run

- **Five or more conditions (`fiveConditions`):** kinship2 at its defaults stops on 5 ("More columns in the affected
  matrix than angle/density values"; it might draw 5 given 5 hatching values, not tried); pedkindraw draws 4 and
  names the fifth in `conditionsNotDrawn`.
- **Adopted:** Pedixplorer stores the column and does not draw it (B3's table).
- **Asymptomatic:** Pedixplorer stops when the column is given (B3's table).

---

## 7. The 2026-09-20 gap table, row by row now

`docs/research/kinship2-feature-gap-analysis-2026-09-20.md` classed kinship2's 25 exports against nprcgenekeepr
(15 equivalent, 8 partial, 2 absent) before pedkindraw existed. Against pedkindraw's 31 exports today:

| # | kinship2 export | 2026-09-20 | pedkindraw now |
|---|---|---|---|
| 1 | `pedigree()` | equivalent, other approach | data frames and `checkPedigree()` (R7, R9); `asPedFrame()` converts; gaps B1 (mates by relation code 4), C4 (`missid`) |
| 2 | `print.pedigree` | equivalent (data frames) | the same (R7) |
| 3 | `as.data.frame.pedigree` | equivalent | `asPedFrame()` |
| 4 | `align.pedigree` | equivalent, other approach | `makePedigreeMatingLayout()`; `packed`, `width`, `align` are gap B5 |
| 5 | `autohint` | partial: no hints taken | hints taken (R61, R73); returning the layout's own is gap C3 |
| 6 | `bitSize` | partial: internal | exported, `bitSize()` (R40) |
| 7 | `familycheck` | absent | `familyCheck()` (R43) |
| 8 | `findAvailAffected` | partial: internal | exported (R40) |
| 9 | `findAvailNonInform` | partial: internal | exported (R40) |
| 10 | `findUnavailable` | partial: internal | exported (R40) |
| 11 | `fixParents` | equivalent | `addParents()`, `correctParentSex()`, `addBackSecondParents()` |
| 12 | `ibdMatrix` | absent | `ibdMatrix()` (R46) |
| 13 | `kindepth` | equivalent | `findGeneration()`; `align = TRUE` is gap C2 |
| 14 | `kinship` | equivalent | `kinship()`; its `pedigreeList` method is R3 (section 6.1) |
| 15 | `kinship.default` | equivalent | `kinship(id, sire, dam, pdepth, ...)`, `chrtype = "x"` (R87) |
| 16 | `legendPlot` | equivalent, other approach | the legend `drawPedigreeDiagram()` always draws |
| 17 | `makefamid` | equivalent | `findPedigreeNumber()` |
| 18 | `makekinship` | partial: no block-sparse | ruled out, R3 (section 6.1) |
| 19 | `pedigree.legend` | equivalent, other approach | the same legend |
| 20 | `pedigree.shrink` | equivalent | `shrinkPedigree()` |
| 21 | `pedigree.trim` | equivalent | `trimPedigree()`; removing listed parents in one call is gap C6 |
| 22 | `pedigree.unrelated` | equivalent, other approach | `findUnrelated()` (R52) |
| 23 | `plot.pedigree` | equivalent, other approach; slash and repeat line missing | slash and the "Same animal, again" line now drawn; files are gap A1, unknown status B2, style B5, long labels B6 |
| 24 | `plot.pedigree.shrink` | partial | gap B7 |
| 25 | `print.pedigree.shrink` | partial | `shrinkPedigree()`'s returned fields (R7) |

Of the 2026-09-20 table's 10 partial or absent rows, 6 are closed by an export (rows 6-10 and 12), 1 is half
closed (row 5: hints are taken; returning the layout's own is gap C3), 1 is ruled out (18), 1 is gap B7 (24) and 1
is a design choice (25, R7). The open parts of rows 1, 4, 5, 13, 21 and 23 are gaps of sections 3-5.

---

## 8. Pedixplorer's functions, mapped

Pedixplorer 1.8.0 exports 247 names: 107 S4 classes and method tables, and 140 functions, of which 60 are 30 pairs
of slot accessors (`adopted`, `affected`, `asymptomatic`, `avail`, `border`, `carrier`, `consultand`, `dadid`,
`dateofbirth`, `dateofdeath`, `deceased`, `evaluated`, `famid`, `fertility`, `fill`, `hints`, `horder`, `id`,
`isinf`, `kin`, `mcols`, `miscarriage`, `momid`, `ped`, `proband`, `rel`, `scales`, `sex`, `spouse`, `useful`;
R7). The other 80, grouped (checked by script: each once):

| Group | Pedixplorer functions | pedkindraw | Gaps |
|---|---|---|---|
| Building and checking (26) | `Pedigree`, `Ped`, `Rel`, `Hints`, `Scales`, `norm_ped`, `norm_rel`, `is_disconnected`, `sex_to_factor`, `fertility_to_factor`, `miscarriage_to_factor`, `rel_code_to_factor`, `vect_to_binary`, `fix_parents`, `family_check`, `make_famid`, `get_famid`, `upd_famid`, `show`, `summary`, `as.data.frame`, `as.list`, `code`, `id1`, `id2`, `subset` | data frames; `checkPedigree()`, `addParents()`, `correctParentSex()`, `familyCheck()`, `findPedigreeNumber()`, `checkTwinRelations()`, `asPedFrame()` | C4, C6; objects R7 |
| Computing (18) | `kinship`, `kindepth`, `bit_size`, `shrink`, `find_avail_affected`, `find_avail_noninform`, `find_unavailable`, `unrelated`, `ibd_matrix`, `is_informative`, `useful_inds`, `min_dist_inf`, `num_child`, `parent_of`, `is_parent`, `ancestors`, `descendants`, `is_founder` | `kinship()`, `findGeneration()`, `bitSize()`, `shrinkPedigree()`, `findAvailAffected()`, `findAvailNonInform()`, `findUnavailable()`, `findUnrelated()`, `ibdMatrix()`, `trimPedigree()`, `getOffspring()` and the other lookups | C1, C2, C5 |
| Layout and drawing (14) | `align`, `auto_hint`, `best_hint`, `compute_stress`, `eval_perm`, `plot`, `ped_to_plotdf`, `ped_to_legdf`, `plot_fromdf`, `generate_colors`, `generate_fill`, `generate_border`, `generate_aff_inds`, `rescale` | `makePedigreeMatingLayout()`, `makePedigreeDiagramData()`, `drawPedigreeDiagram()` | A1, A2, B1-B7, C3 |
| Files (1) | `plink_to_pedigree` | none | R13 |
| The app (21) | `ped_shiny`, `ped_server`, `ped_ui`, and `color_picker_demo`, `color_picker_server`, `data_col_sel_demo`, `data_download_demo`, `data_import_demo`, `family_sel_demo`, `health_sel_demo`, `inf_sel_demo`, `ped_avaf_infos_demo`, `plot_download_demo`, `plot_legend_demo`, `plot_legend_server`, `plot_legend_ui`, `plot_ped_demo`, `plot_resize_server`, `make_reactive`, `get_families_table`, `get_title` | none | A3 |

---

## 9. Found on the way (not gaps)

1. **pedkindraw reads a numeric condition column as affected wherever it is not 0, with no message** (case
   `measuredTrait`: 2.5, 0.3 and 9 drawn affected). `makePedigreeDiagramData()`'s help asks for a logical
   `affected` column and `makePedigreeMatingLayout()`'s help does not say; neither says what a number does. A
   measured trait passed by mistake is drawn without warning. nprcgenekeepr's copy does the same (section 10).
2. **Colours edited in a layout reach the legend but not the animals' sections** (case `style`, two conditions).
   Editing a layout is not a documented use, but it is a trap for anyone who tries it.
3. **Pedixplorer 1.8.0:** drawing stops when `asymptomatic` is given; `adopted` is stored and not drawn;
   `best_hint()` needs R.utils, which renv's library does not have; at its default text size it refuses to draw
   the 375-animal rhesus pedigree.
4. **kinship2 1.9.6.2** reads sex written as the numbers 1 and 2 but stops on the text "1" and "2".
5. **A method trap:** a first scratch probe attached kinship2, Pedixplorer and pedkindraw together, and the
   `kinship()` it called was not pedkindraw's; its result (pedkindraw "computes" after a parent's row is dropped)
   was wrong. `tools/gapCases.R` calls every function through `::`, and C6 is written from its result.

---

## 10. The same gaps in nprcgenekeepr

Measured on nprcgenekeepr commit `ae3491dff` (its S1187), with its own code and renv library, on the typed
pedigrees of the cases above (`tools/gapCasesNprcgenekeepr.R`; output beside this document). pedkindraw's drawing
and computing code is a copy of nprcgenekeepr's (R8), so most gaps are shared; the drift tool lists the 14 copied
functions that differ, each with a `DIVERGENCE.md` row (hints, R94, R95 and the renames among them).

| Gap | nprcgenekeepr | Measured |
|---|---|---|
| A1 picture files | same gap | `drawPedigreeDiagram()` returns the same widget (`layout`, `edgeStyle`, `onClick`); its `savePlotToFile()` saves its ggplot charts as PNG, PDF or SVG and returns `FALSE` given the pedigree widget |
| A2 ids on a large pedigree | same gap | its `drawColonyOverview(overview, onClick)` draws a whole colony as one circle per maternal line, labelled by the founding dam, not each animal's id |
| A3 an app | **has it** | `runGeneKeepR(port, launch.browser)`, its Shiny application with the Pedigree Browser |
| B1 mates with no offspring | same gap | E and F left out (`isolatedIds`) |
| B2 unknown affected status | same gap | A, B (unknown), C, D filled `#CC79A7`, `#FFFFFF`, `#FFFFFF`, `#CC79A7` |
| B3 other marks | same gap | a `carrier` column leaves the layout identical |
| B4 measured trait | same gap, and the same pitfall | 2.5, 0, 0.3, 9 filled affected, unaffected, affected, affected |
| B5 colours and sizes | same gap | the same `drawPedigreeDiagram()` arguments and fixed colours |
| B6 15-character labels | same gap | "A", "age 7", "MHC A01/B..." |
| B7 shrink picture | same gap | no export draws one |
| C1 relatives within k steps | same gap | `getPedDirectRelatives(ids, ped, unrelatedParents)` returns the whole connected family (all 9 animals of C6's pedigree, from F), with no distance |
| C2 aligned generations | same gap | `findGeneration(id, sire, dam)` |
| C3 the layout's own hints | wider gap | `makePedigreeMatingLayout(ped, edgeStyle, twinRelations, kinshipMatrix)` takes no hints at all (pedkindraw added them, R61) |
| C4 other codes | **half** | sex: `convertSexCodes()` reads 1, 2, male, female, m, f as M, F, M, F, M, F, and `qcStudbook()` applies it; blank parent cells in a CSV become `NA` when `getPedigree()` reads it; parents written "0", or "" in a data frame, stop `qcStudbook()` ("Subject(s) listed as both sire and dam") |
| C5 small lookups | **half** | `offspringCounts(probands, ped)` counts offspring (2 and 2 for A and B); no mates list |
| C6 remove listed animals | same gap | none of its `remove...()` exports does it |
| R3 kinship by family | same gap | the same dense `kinship()` (copied) |
| R13 file readers | has readers | `getPedigree(fileName, sep)` (CSV or Excel), `readTwinRelations()`; none reads PLINK |
| R21 datasets | has them | 25 datasets |

So nprcgenekeepr has 13 of the 16 open gaps too and closes 3 in whole or part: A3 (its app), half of C4 (sex
codes) and half of C5 (offspring counts). The two halves exist as small nprcgenekeepr functions,
`convertSexCodes()` and `offspringCounts()`; the app is nprcgenekeepr's whole application.
