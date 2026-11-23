# Getting started with pedkindraw

This vignette takes one pedigree from its records to a drawing. It reads
the example pedigree that comes with the package, checks it, numbers its
generations and family trees, computes kinship, trims it to one animal’s
ancestors and draws them. Then it shrinks the pedigree and finds a set
of unrelated animals in it. The last section converts a kinship2
pedigree.

## A pedigree is a data frame

A pedigree has one row per animal: its `id`, `sire` and `dam` (`NA` for
an unknown parent; an animal may have one known parent), and optionally
its `sex` (`"M"`, `"F"`, `"H"` for a hermaphrodite or `"U"` for
unknown), a `status` (`"DECEASED"` marks an animal that has died) and
condition columns, whose names start with `affected`. Other columns are
kept. Twins are listed in a table of their own, one pair per row: `id1`,
`id2` and `code` (`"MZ twin"`, `"DZ twin"` or `"UZ twin"`, for
identical, fraternal and unknown).

pedkindraw comes with a pedigree of 375 rhesus macaques and the table of
its three twin pairs. Both are files copied unchanged from the examples
of the package nprcgenekeepr, which disguised (obfuscated) the records
for use in examples.

``` r

library(pedkindraw)

pedFile <- system.file("extdata", "obfuscated_rhesus_mhc_ped.csv",
                       package = "pedkindraw")
twinFile <- system.file("extdata", "obfuscated_rhesus_mhc_twin_relations.csv",
                        package = "pedkindraw")
ped <- read.csv(pedFile, stringsAsFactors = FALSE)
twins <- read.csv(twinFile, stringsAsFactors = FALSE)
nrow(ped)
#> [1] 375
head(ped)
#>       id sire  dam sex gen      birth exit  age
#> 1 BRI2MW <NA> <NA>   F   0 1998-12-06   NA 20.7
#> 2 677E7M <NA> <NA>   F   0 1998-07-24   NA 21.1
#> 3 ZZ646X <NA> <NA>   F   0 1997-12-08   NA 21.7
#> 4 FEEN9W <NA> <NA>   M   0 1997-12-23   NA 21.7
#> 5 83U0EX <NA> <NA>   M   0       <NA>   NA   NA
#> 6 6VUC6R <NA> <NA>   F   0       <NA>   NA   NA
twins
#>      id1    id2    code
#> 1 E06FRB HV7LZ3 MZ twin
#> 2 8GSXTQ P844CW DZ twin
#> 3 BRI2MW 677E7M UZ twin
```

Besides `id`, `sire`, `dam` and `sex`, the file gives each animal’s
generation (`gen`), birth date, exit date and age. It has no `status` or
condition column, so the drawing below marks neither.

## Checking the records

[`checkPedigree()`](https://rmsharp.github.io/pedkindraw/reference/checkPedigree.md)
lists each problem it finds, one row per problem, and changes nothing.
It finds none in the example.
[`checkTwinRelations()`](https://rmsharp.github.io/pedkindraw/reference/checkTwinRelations.md)
stops if a twin pair is not possible, for instance MZ or DZ twins that
do not share a sire and a dam, and otherwise returns the table.

``` r

checkPedigree(ped)
#> [1] check  id     detail
#> <0 rows> (or 0-length row.names)
twins <- checkTwinRelations(ped, twins)
```

Records with problems look like this. Here `s2` is the sire of `o2` but
has no row of its own, and `d1`, the dam of `o1` and `o2`, is recorded
as male.

``` r

records <- data.frame(
  id   = c("s1", "d1", "o1", "o2"),
  sire = c(NA, NA, "s1", "s2"),
  dam  = c(NA, NA, "d1", "d1"),
  sex  = c("M", "M", "F", "M")
)
checkPedigree(records)
#>            check id        detail
#> 1 rowlessParents s2    sire of o2
#> 2       maleDams d1 dam of o1, o2
```

[`addParents()`](https://rmsharp.github.io/pedkindraw/reference/addParents.md)
adds a row for each sire or dam that has none, and marks the rows in a
`recordStatus` column.
[`correctParentSex()`](https://rmsharp.github.io/pedkindraw/reference/correctParentSex.md)
sets the sex of each sire recorded as female and each dam recorded as
male. After both, the check finds nothing.

``` r

records <- addParents(records)
records$sex <- correctParentSex(records$id, records$sire, records$dam,
                                records$sex, records$recordStatus)
records
#>   id sire  dam sex recordStatus
#> 1 s1 <NA> <NA>   M     original
#> 2 d1 <NA> <NA>   F     original
#> 3 o1   s1   d1   F     original
#> 4 o2   s2   d1   M     original
#> 5 s2 <NA> <NA>   M        added
checkPedigree(records)
#> [1] check  id     detail
#> <0 rows> (or 0-length row.names)
```

## Generations and family trees

[`findGeneration()`](https://rmsharp.github.io/pedkindraw/reference/findGeneration.md)
numbers each animal’s generation: 0 for a founder, an animal with no
known sire or dam, and one more than its later parent’s for every other.
The layout and
[`kinship()`](https://rmsharp.github.io/pedkindraw/reference/kinship.md)
need these numbers. The example spans nine generations, 0 to 8, and the
numbers are the same as the file’s own `gen` column, which this line
replaces.

``` r

ped$gen <- findGeneration(ped$id, ped$sire, ped$dam)
table(ped$gen)
#> 
#>   0   1   2   3   4   5   6   7   8 
#> 124  60  46  40  34  29  23  16   3
```

[`findPedigreeNumber()`](https://rmsharp.github.io/pedkindraw/reference/findPedigreeNumber.md)
numbers the family trees: animals joined through their sires and dams
share a number. The example has five trees, one of 343 animals and four
of 3 to 13.

``` r

ped$family <- findPedigreeNumber(ped$id, ped$sire, ped$dam)
table(ped$family)
#> 
#>   1   2   3   4   5 
#>  11   5   3  13 343
```

## Kinship

[`kinship()`](https://rmsharp.github.io/pedkindraw/reference/kinship.md)
computes the kinship coefficient of every pair of animals: the chance
that an allele taken at random from one animal and an allele taken at
random from the other are identical by descent. An animal’s coefficient
with itself is 0.5, or more when it is inbred. With `sparse = TRUE` it
returns a sparse matrix, which saves memory in a large pedigree.

``` r

k <- kinship(ped$id, ped$sire, ped$dam, ped$gen, twinRelations = twins)
dim(k)
#> [1] 375 375
k[c("E06FRB", "HV7LZ3", "8GSXTQ", "P844CW"),
  c("E06FRB", "HV7LZ3", "8GSXTQ", "P844CW")]
#>        E06FRB HV7LZ3 8GSXTQ P844CW
#> E06FRB    0.5    0.5   0.00   0.00
#> HV7LZ3    0.5    0.5   0.00   0.00
#> 8GSXTQ    0.0    0.0   0.50   0.25
#> P844CW    0.0    0.0   0.25   0.50
```

E06FRB and HV7LZ3 are identical (MZ) twins. The twins table gives them a
coefficient of 0.5, the same as each has with itself; without it they
would have 0.25, that of full siblings. 8GSXTQ and P844CW are fraternal
(DZ) twins, full siblings, at 0.25.

An animal whose sire and dam are related is inbred. The example has 29
such animals.

``` r

sum(diag(k) > 0.5)
#> [1] 29
k[c("81MJXH", "H16XSK", "ED5PDV"), c("81MJXH", "H16XSK", "ED5PDV")]
#>        81MJXH H16XSK ED5PDV
#> 81MJXH 0.5000 0.1250 0.3125
#> H16XSK 0.1250 0.5000 0.3125
#> ED5PDV 0.3125 0.3125 0.5625
```

One of them is ED5PDV. Its sire 81MJXH and its dam H16XSK are half
siblings, both offspring of YPHFHF, and their kinship coefficient is
0.125. So ED5PDV’s coefficient with itself is (1 + 0.125) / 2 = 0.5625.

## Trimming a pedigree to the animals of interest

[`getProbandPedigree()`](https://rmsharp.github.io/pedkindraw/reference/getProbandPedigree.md)
keeps the animals of interest, the probands, and all of their ancestors.
ED5PDV and its ancestors are 16 animals in five generations, 8 of them
founders.

``` r

small <- getProbandPedigree(ped, "ED5PDV")
nrow(small)
#> [1] 16
```

[`trimPedigree()`](https://rmsharp.github.io/pedkindraw/reference/trimPedigree.md)
does the same, and with `removeUninformative = TRUE` it also removes
each founder that has only one offspring, again and again until none is
left. Such a founder changes no kinship coefficient among the animals
left. Here that leaves the four animals that make ED5PDV inbred: YPHFHF,
its offspring 81MJXH and H16XSK, and ED5PDV.

``` r

core <- trimPedigree(ped, "ED5PDV", removeUninformative = TRUE)
core[, c("id", "sire", "dam", "sex")]
#>         id   sire    dam sex
#> 204 YPHFHF   <NA>   <NA>   M
#> 237 H16XSK YPHFHF   <NA>   F
#> 252 81MJXH YPHFHF   <NA>   M
#> 301 ED5PDV 81MJXH H16XSK   M
```

## Drawing a pedigree

[`makePedigreeMatingLayout()`](https://rmsharp.github.io/pedkindraw/reference/makePedigreeMatingLayout.md)
places each animal and each mating of a pedigree, and
[`drawPedigreeDiagram()`](https://rmsharp.github.io/pedkindraw/reference/drawPedigreeDiagram.md)
draws the layout as an interactive graph. The layout can also take a
twins table, a kinship matrix and layout hints, which its help page
describes.

``` r

layout <- makePedigreeMatingLayout(small)
drawPedigreeDiagram(layout)
```

Squares are males and circles females. The small dot between two animals
is their mating, and a line goes down from it to each of their
offspring. The mating of the half siblings 81MJXH and H16XSK is drawn in
orange, because their kinship coefficient is above 0. Three animals are
drawn twice, and a dashed line joins the two places of each: YPHFHF
beside each of its two mates, and 5LDNWE and H16XSK under their sire and
dam and again beside their mate. In the drawing you can zoom, hover over
an animal to highlight the animals joined to it, pick an animal in the
“Select by id” box, and save the picture with the “Export Diagram (PNG)”
button. From a script,
[`savePedigreeDiagram()`](https://rmsharp.github.io/pedkindraw/reference/savePedigreeDiagram.md)
saves the drawing as an SVG, a PDF or a PNG file;
[`vignette("drawing")`](https://rmsharp.github.io/pedkindraw/articles/drawing.md)
shows how.

To draw a pedigree with no code,
[`runPedigreeApp()`](https://rmsharp.github.io/pedkindraw/reference/runPedigreeApp.md)
opens a CSV or text file in an app in the web browser: it draws
everyone, one family or a few animals’ relatives, with the file’s
conditions and marks, and saves the drawing and the animals. It needs
the shiny package; its help page says what it does.

## Shrinking a pedigree

[`shrinkPedigree()`](https://rmsharp.github.io/pedkindraw/reference/shrinkPedigree.md)
trims a pedigree to the animals needed to keep it informative within a
budget on its bit size, given which animals are genotyped and,
optionally, which are affected. It follows kinship2’s
`pedigree.shrink()`. The bit size, which
[`bitSize()`](https://rmsharp.github.io/pedkindraw/reference/bitSize.md)
gives, is twice the number of animals with a known parent less the
number of founders. The example has no genotypes, so 30 percent of the
animals are picked at random to stand for the genotyped ones: 109 of the
375.

``` r

set.seed(42)
genotyped <- runif(nrow(ped)) < 0.3
sum(genotyped)
#> [1] 109
bitSize(ped)
#> $bitSize
#> [1] 378
#> 
#> $nFounder
#> [1] 124
#> 
#> $nNonFounder
#> [1] 251
```

The whole pedigree’s bit size is 2 \* 251 - 124 = 378.

``` r

shrunk <- shrinkPedigree(ped, genotyped, maxBits = 16L)
lengths(shrunk$idList)
#>   unavail noninform  affected 
#>       104         4       214
c(shrunk$pedSizeOriginal, shrunk$pedSizeIntermed, shrunk$pedSizeFinal)
#> [1] 375 267  53
shrunk$bitSize[c(1L, 2L, length(shrunk$bitSize))]
#> [1] 378 237  16
```

It works in steps. It first removes 104 unavailable animals: those not
genotyped that are left with no offspring, and founders that add
nothing. Then it removes 4 genotyped animals with no offspring left
whose sire and dam are both genotyped. That takes the pedigree from 375
animals to 267, and its bit size from 378 to 237. Last, it removes one
genotyped animal with no offspring left at a time, each time the one
whose removal leaves the smallest bit size, with the animals that
removal leaves unavailable, until the bit size is at most 16. That takes
214 more animals and leaves 53, at a bit size of 16. Its help page gives
each rule.

## Finding unrelated animals

[`findUnrelated()`](https://rmsharp.github.io/pedkindraw/reference/findUnrelated.md)
chooses genotyped animals of which no two are related, as many as it
can: 44 of the 109 genotyped animals here. Their kinship coefficients
with each other are all 0.

``` r

unrelated <- findUnrelated(ped, genotyped)
length(unrelated)
#> [1] 44
kU <- k[unrelated, unrelated]
all(kU[upper.tri(kU)] == 0)
#> [1] TRUE
```

## For kinship2 users

[`asPedFrame()`](https://rmsharp.github.io/pedkindraw/reference/asPedFrame.md)
converts a kinship2 `pedigree` or `pedigreeList`, or a Pedixplorer
`Pedigree`, to a list: the pedigree as a data frame (`ped`), its twins
table (`twinRelations`), its layout hints (`hints`) and its declared
matings (`matings`, from kinship2’s relation code 4), each `NULL` when
the object has none. The chunks below run only when kinship2 is
installed. They convert family 2 of kinship2’s `sample.ped`, 14 animals.
kinship2 codes sex as 1 and 2 and an unknown parent as 0; the data frame
has `"M"`, `"F"` and `NA`.

``` r

data("sample.ped", package = "kinship2")
fam2 <- sample.ped[sample.ped$ped == 2, ]
p <- kinship2::pedigree(id = fam2$id, dadid = fam2$father,
                        momid = fam2$mother, sex = fam2$sex,
                        affected = fam2$affected)
x <- asPedFrame(p)
head(x$ped)
#>    id sire  dam sex affected
#> 1 201 <NA> <NA>   M        1
#> 2 202 <NA> <NA>   F       NA
#> 3 203 <NA> <NA>   M        1
#> 4 204  201  202   F        0
#> 5 205  201  202   M       NA
#> 6 206  201  202   F        1
```

The data frame then goes to the functions above, and
[`kinship()`](https://rmsharp.github.io/pedkindraw/reference/kinship.md)
gives the same coefficients as kinship2’s own
[`kinship()`](https://rmsharp.github.io/pedkindraw/reference/kinship.md).

``` r

x$ped$gen <- findGeneration(x$ped$id, x$ped$sire, x$ped$dam)
k2 <- kinship(x$ped$id, x$ped$sire, x$ped$dam, x$ped$gen)
all.equal(k2, kinship2::kinship(p)[x$ped$id, x$ped$id])
#> [1] TRUE
```

## Where next

[`?pedkindraw`](https://rmsharp.github.io/pedkindraw/reference/pedkindraw-package.md)
lists every function by what it does.
[`vignette("drawing", package = "pedkindraw")`](https://rmsharp.github.io/pedkindraw/articles/drawing.md)
shows what a drawing shows and how to change it, one feature at a time:
the symbols and the legend, conditions, twins, animals drawn twice, the
two edge styles and layout hints, among others. The help pages of
[`makePedigreeMatingLayout()`](https://rmsharp.github.io/pedkindraw/reference/makePedigreeMatingLayout.md)
and
[`drawPedigreeDiagram()`](https://rmsharp.github.io/pedkindraw/reference/drawPedigreeDiagram.md)
describe the twins table, the kinship matrix and the layout hints the
drawing takes.
