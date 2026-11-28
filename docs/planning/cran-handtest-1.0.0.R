## pedkindraw 1.0.0 -- hand test before the CRAN upload (Session 103)
##
## Run one step at a time (put the cursor on a line and press Cmd+Enter), and
## tell Claude what you see after each part, or paste anything odd.
##
## "Should show" lines say what to expect:
##   (measured)  Claude ran the same call on the same tarball, installed the
##               same way, at 18:54 today, and ran this whole file (but
##               Part E and the install, help and browser lines) at 18:56;
##   (vignette)  / (help)  the vignette or help page says so; not run by Claude.
## Anything different from a "Should show" line is worth telling Claude.
## Things to watch for everywhere: an error, a warning not named here, a word
## that reads wrong, anything slow, anything that looks wrong in a drawing.


## ---- PART 0. Start outside the project ----------------------------------
## 0.1 In RStudio: File > Close Project. RStudio restarts R. Inside the
##     project, renv would load the development library instead of the
##     installed tarball.
## 0.2 Open this file again (File > Recent Files), then run:

base <- path.expand("~/pedkindraw-handtest")
testLib <- file.path(base, "lib")
outDir <- file.path(base, "out")
dir.create(testLib, recursive = TRUE, showWarnings = FALSE)
dir.create(outDir, showWarnings = FALSE)
.libPaths(c(testLib, .libPaths()))
.libPaths()
Sys.getenv("RENV_PROJECT")
## Should show: the first path ends in handtest/lib, and no path contains
## "renv"; RENV_PROJECT is "".


## ---- PART A. Install it as a user would --------------------------------
## A1. The one package pedkindraw needs that your library lacks (quadprog),
##     and kinship2, used only in Part D.
install.packages(c("quadprog", "kinship2"), lib = testLib)
## Should show (measured): quadprog 1.5-8 and kinship2 1.9.6.2 downloaded
## and installed, no error.

## A2. The exact file going to CRAN (SHA-256 abb78758...22dcfe3c).
install.packages("/Users/rmsharp/Development/pedkindraw/pedkindraw_1.0.0.tar.gz",
                 lib = testLib, repos = NULL, type = "source")
## Should show (measured): "installing *source* package 'pedkindraw'",
## "installing vignettes", then "* DONE (pedkindraw)".

## A3. Load it, and check it is the installed copy.
library(pedkindraw)
packageVersion("pedkindraw")
find.package("pedkindraw")
## Should show (measured): '1.0.0'; a path ending in handtest/lib/pedkindraw.

## A4. The help and the vignettes, as installed. Read as much as you like.
help(package = "pedkindraw")   # the index of help pages (Help pane)
?pedkindraw                    # the overview: every function by what it does
browseVignettes("pedkindraw")  # opens a page in the browser
## Should show (measured): 3 vignettes: "Drawing pedigrees", "Getting
## started with pedkindraw" and "Speed and size limits", each opening as HTML.
## Look for: a broken link, a page that does not open, wording that is wrong.


## ---- PART B. The analysis functions (vignette "Getting started") -------
## B1. The sample pedigree that comes with the package.
pedFile <- system.file("extdata", "obfuscated_rhesus_mhc_ped.csv",
                       package = "pedkindraw")
twinFile <- system.file("extdata", "obfuscated_rhesus_mhc_twin_relations.csv",
                        package = "pedkindraw")
ped <- read.csv(pedFile, stringsAsFactors = FALSE)
twins <- read.csv(twinFile, stringsAsFactors = FALSE)
nrow(ped)
head(ped)
twins
## Should show (measured): 375 animals; columns id, sire, dam, sex, gen,
## birth, exit, age; 3 twin pairs: E06FRB-HV7LZ3 MZ, 8GSXTQ-P844CW DZ,
## BRI2MW-677E7M UZ.

## B2. Checking records.
checkPedigree(ped)
twins <- checkTwinRelations(ped, twins)
## Should show (measured): checkPedigree() a table with 0 rows (no
## problems). checkTwinRelations() returns the twins table unchanged when
## every pair is possible (twins still holds its 3 pairs; type twins to see
## them) and stops with an error when a pair is not.

records <- data.frame(
  id   = c("s1", "d1", "o1", "o2"),
  sire = c(NA, NA, "s1", "s2"),
  dam  = c(NA, NA, "d1", "d1"),
  sex  = c("M", "M", "F", "M")
)
checkPedigree(records)
## Should show (measured): 2 rows: rowlessParents s2 "sire of o2";
## maleDams d1 "dam of o1, o2".
records <- addParents(records)
records$sex <- correctParentSex(records$id, records$sire, records$dam,
                                records$sex, records$recordStatus)
records
checkPedigree(records)
## Should show (measured): 5 rows, s2 added (recordStatus "added"), d1 now F;
## then a table with 0 rows.

## B3. Generations and family trees.
ped$gen <- findGeneration(ped$id, ped$sire, ped$dam)
table(ped$gen)
ped$family <- findPedigreeNumber(ped$id, ped$sire, ped$dam)
table(ped$family)
## Should show (measured): generations 0 to 8 with 124, 60, 46, 40, 34, 29,
## 23, 16, 3 animals; families 1 to 5 with 11, 5, 3, 13, 343 animals.

## B4. Kinship.
k <- kinship(ped$id, ped$sire, ped$dam, ped$gen, twinRelations = twins)
dim(k)
k[c("E06FRB", "HV7LZ3", "8GSXTQ", "P844CW"),
  c("E06FRB", "HV7LZ3", "8GSXTQ", "P844CW")]
sum(diag(k) > 0.5)
k[c("81MJXH", "H16XSK", "ED5PDV"), c("81MJXH", "H16XSK", "ED5PDV")]
## Should show (measured): 375 375; the MZ twins 0.5 with each other, the DZ
## twins 0.25; 29 inbred animals; 81MJXH-H16XSK 0.125, ED5PDV with itself
## 0.5625.

## B5. Trimming to one animal's ancestors.
small <- getProbandPedigree(ped, "ED5PDV")
nrow(small)
core <- trimPedigree(ped, "ED5PDV", removeUninformative = TRUE)
core[, c("id", "sire", "dam", "sex")]
## Should show (measured): 16; then 4 animals: YPHFHF, H16XSK, 81MJXH, ED5PDV.

## B6. Shrinking, and finding unrelated animals.
set.seed(42)
genotyped <- runif(nrow(ped)) < 0.3
sum(genotyped)
bitSize(ped)
shrunk <- shrinkPedigree(ped, genotyped, maxBits = 16L)
c(shrunk$pedSizeOriginal, shrunk$pedSizeIntermed, shrunk$pedSizeFinal)
unrelated <- findUnrelated(ped, genotyped)
length(unrelated)
kU <- k[unrelated, unrelated]
all(kU[upper.tri(kU)] == 0)
## Should show (measured): 109; bitSize 378 (124 founders, 251 others);
## 375 267 53; 44; TRUE.


## ---- PART C. Drawings in RStudio ----------------------------------------
## Each drawPedigreeDiagram() line opens the drawing in the Viewer pane.
## In each, try: scroll to zoom; drag the background to move; hover over an
## animal (the others not near it turn gray, and a box gives its id, sex,
## generation, sire and dam); the "Select by id" box; the "Export Diagram
## (PNG)" button at the bottom right; the Viewer's "Show in new window"
## button, then the same in the browser.

## C1. ED5PDV and its 15 ancestors (vignette "Getting started").
layout <- makePedigreeMatingLayout(small)
drawPedigreeDiagram(layout)
## Should show: 16 animals (measured); the mating of 81MJXH and H16XSK drawn
## in orange (vignette); YPHFHF, 5LDNWE and H16XSK each drawn twice, joined
## by a dashed line (measured).

## C2. A small family; the symbols and the legend (vignette "Drawing").
fam <- data.frame(
  id   = c("A", "B", "C", "D", "E", "F", "G", "H"),
  sire = c(NA, NA, "A", "A", "A", NA, "C", "C"),
  dam  = c(NA, NA, "B", "B", "B", NA, "F", "F"),
  sex  = c("M", "F", "M", "F", "F", "F", "F", "M")
)
fam$gen <- findGeneration(fam$id, fam$sire, fam$dam)
drawPedigreeDiagram(makePedigreeMatingLayout(fam))
## Should show (vignette): A and B on top, C, D, E below, G and H at the
## bottom; F beside her mate C on his row; lines at right angles.

kids <- data.frame(
  id     = c("S1", "D1", "female", "male", "hermaphrodite", "unknown",
             "unrecorded"),
  sire   = c(NA, NA, "S1", "S1", "S1", "S1", "S1"),
  dam    = c(NA, NA, "D1", "D1", "D1", "D1", "D1"),
  sex    = c("M", "F", "F", "M", "H", "U", NA),
  status = c("DECEASED", "ALIVE", "ALIVE", "ALIVE", "ALIVE", "ALIVE",
             "ALIVE")
)
kids$gen <- findGeneration(kids$id, kids$sire, kids$dam)
drawPedigreeDiagram(makePedigreeMatingLayout(kids))
## Should show (vignette): square M, circle F, star H, triangle U, diamond
## for NA ("Other / Unrecorded"); a slash through S1 (deceased); the legend
## on the right.

## C3. Conditions.
fam1 <- fam
fam1$affected <- c(FALSE, FALSE, FALSE, TRUE, FALSE, FALSE, TRUE, NA)
drawPedigreeDiagram(makePedigreeMatingLayout(fam1))
## Should show (vignette): D and G pink, H gray; a legend row "Affected
## status unknown".

fam3 <- fam
fam3$affected_diabetes  <- c(FALSE, FALSE, TRUE, FALSE, FALSE, FALSE, TRUE,
                             FALSE)
fam3$affected_obesity   <- c(FALSE, TRUE, FALSE, FALSE, TRUE, FALSE, TRUE, NA)
fam3$affected_arthritis <- c(TRUE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,
                             FALSE)
drawPedigreeDiagram(makePedigreeMatingLayout(fam3))
## Should show (vignette): each symbol cut into 3 sections; C diabetes,
## B and E obese, A arthritis, G diabetes and obese, H's obesity section gray;
## legend rows "Affected (diabetes)", "(obesity)", "(arthritis)".

## C4. Twins.
litter <- data.frame(
  id   = c("S1", "D1", "A1", "A2", "B1", "B2", "C1", "C2"),
  sire = c(NA, NA, "S1", "S1", "S1", "S1", "S1", "S1"),
  dam  = c(NA, NA, "D1", "D1", "D1", "D1", "D1", "D1"),
  sex  = c("M", "F", "F", "F", "M", "F", "M", "M")
)
litter$gen <- findGeneration(litter$id, litter$sire, litter$dam)
litterTwins <- data.frame(
  id1  = c("A1", "B1", "C1"),
  id2  = c("A2", "B2", "C2"),
  code = c("MZ twin", "DZ twin", "UZ twin")
)
litterTwins <- checkTwinRelations(litter, litterTwins)
drawPedigreeDiagram(makePedigreeMatingLayout(litter,
                                             twinRelations = litterTwins))
## Should show (vignette): a green line between each pair: solid "MZ",
## dashed "DZ", long dashes "?".

## C5. An animal drawn twice; a mating of relatives; straight lines.
two <- data.frame(
  id   = c("A", "B", "C", "P", "Q", "R", "S", "T"),
  sire = c(NA, NA, "A", NA, NA, "P", "C", "C"),
  dam  = c(NA, NA, "B", NA, NA, "Q", "R", "R"),
  sex  = c("M", "F", "M", "M", "F", "F", "F", "M")
)
two$gen <- findGeneration(two$id, two$sire, two$dam)
drawPedigreeDiagram(makePedigreeMatingLayout(two))
## Should show (vignette): R under P and Q, and again beside C, a dashed line
## joining her two places; hovering over the repeat says "(duplicate
## occurrence)".

sibs <- data.frame(
  id   = c("A", "B", "C", "D", "K"),
  sire = c(NA, NA, "A", "A", "C"),
  dam  = c(NA, NA, "B", "B", "D"),
  sex  = c("M", "F", "M", "F", "F")
)
sibs$gen <- findGeneration(sibs$id, sibs$sire, sibs$dam)
drawPedigreeDiagram(makePedigreeMatingLayout(sibs))
## Should show (vignette): the lines from full siblings C and D to their
## mating thick and orange; D drawn again beside C.

drawPedigreeDiagram(makePedigreeMatingLayout(fam, edgeStyle = "direct"),
                    edgeStyle = "direct")
## Should show (vignette): the C2 family with straight lines; the animals
## where they were.

## C6. The whole colony: 375 animals with the 3 twin pairs.
colony <- makePedigreeMatingLayout(ped, twinRelations = twins)
drawPedigreeDiagram(colony)
## Should show (measured): one warning, "72 same-row edge-node collision(s)
## could not be fully resolved ..." (the vignette explains it: a line may
## pass close to an animal it does not belong to; nothing is missing); the
## layout took 1.8 s. Too small to read until you zoom; try "Select by id"
## with ED5PDV.

## C7. Saving pictures. The first save starts a hidden Chrome.
diagram <- drawPedigreeDiagram(layout)
savePedigreeDiagram(diagram, file.path(outDir, "small.svg"), width = 10, height = 6)
savePedigreeDiagram(diagram, file.path(outDir, "small.pdf"), width = 10, height = 6)
savePedigreeDiagram(diagram, file.path(outDir, "small.png"), width = 10, height = 6,
                    dpi = 150)
colonyDiagram <- drawPedigreeDiagram(colony)
savePedigreeDiagram(colonyDiagram, file.path(outDir, "colony.pdf"), width = 14, height = 7)
savePedigreeDiagram(colonyDiagram, file.path(outDir, "colony.png"), width = 14, height = 7)
htmlwidgets::saveWidget(colonyDiagram, file.path(outDir, "colony.html"))
file.size(file.path(outDir, c("small.svg", "small.pdf", "small.png",
                              "colony.pdf", "colony.png", "colony.html")))
## Should show (measured): each save about 2 to 3 s; sizes about 38 KB,
## 107 KB, 63 KB, 1.0 MB, 355 KB, 1.9 MB. The console may print "[warning]
## got non-close frame while closing": known and harmless. Tell Claude if it
## prints "Unhandled promise error".
## Then open each and look at it: every id readable once zoomed, the legend,
## the colors, nothing blank.
for (f in c("small.svg", "small.pdf", "small.png", "colony.pdf",
            "colony.png", "colony.html")) {
  browseURL(file.path(outDir, f))
}


## ---- PART D. A kinship2 pedigree ----------------------------------------
data("sample.ped", package = "kinship2")
fam2 <- sample.ped[sample.ped$ped == 2, ]
p <- kinship2::pedigree(id = fam2$id, dadid = fam2$father,
                        momid = fam2$mother, sex = fam2$sex,
                        affected = fam2$affected)
x <- asPedFrame(p)
head(x$ped)
nrow(x$ped)
x$ped$gen <- findGeneration(x$ped$id, x$ped$sire, x$ped$dam)
k2 <- kinship(x$ped$id, x$ped$sire, x$ped$dam, x$ped$gen)
all.equal(k2, kinship2::kinship(p)[x$ped$id, x$ped$id])
drawPedigreeDiagram(makePedigreeMatingLayout(x$ped))
## Should show (measured): ids 201 to 206 first, sex M and F, unknown parents
## NA, an affected column of 1, 0 and NA; 14 animals; TRUE (the same kinship
## as kinship2's); a drawing of 14 animals, affected ones pink, unknown gray.


## ---- PART E. The app (from its help page; Claude has not run it) -------
## E1. Start it. It opens in your web browser, and the R console stays busy
##     until the app is closed: press Escape in the Console (or its red stop
##     sign) when done.
runPedigreeApp()
## In the app, try (help):
## E2. Open the sample pedigree (375 rhesus macaques, with its 3 twin pairs).
##     The columns id, sire, dam and sex are recognized for you.
## E3. Diagram tab: "375 animals drawn", and on the line just under it, as
##     plain text above the save buttons, the same 72-collisions warning as
##     C6 (measured: the app run in a headless Chrome, its "Use the sample
##     pedigree" button pressed). With straight lines chosen that line is
##     empty (no warning); the largest family (343) gives the same warning.
## E4. Choose the animals to draw: one family (families listed largest first;
##     measured sizes 343, 13, 11, 5, 3); focal animals with their ancestors
##     and descendants (type ED5PDV); near relatives; click an animal in the
##     drawing to make it the focal animal.
## E5. Checks tab: the records' problems (checkPedigree found none, B2).
##     Animals tab: the animals drawn.
## E6. Save the drawing as SVG, PDF and PNG with the buttons above it; save
##     the animals as CSV on the Animals tab; open that CSV in the app again:
##     it should give the same drawing.
## E7. Open one of your own pedigree files (CSV or text, commas, tabs or
##     semicolons). Check the columns it picks, the sex values it reads, the
##     conditions and marks it finds, and what it says about any problem.
## E8. Press Escape in the Console to close the app.


## ---- Done ----------------------------------------------------------------
## To go back to development: File > Open Project (pedkindraw). Everything
## these steps made is in ~/pedkindraw-handtest (the test library and the
## saved pictures); nothing in your own R library or in the repository was
## changed. Delete the folder when you no longer need it.
