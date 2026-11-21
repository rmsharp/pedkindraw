# Drawing pedigrees

pedkindraw draws a pedigree in two steps.
[`makePedigreeMatingLayout()`](https://rmsharp.github.io/pedkindraw/reference/makePedigreeMatingLayout.md)
works out where each animal and each mating goes, and
[`drawPedigreeDiagram()`](https://rmsharp.github.io/pedkindraw/reference/drawPedigreeDiagram.md)
draws that layout as an interactive picture: in the RStudio viewer, in a
web page or in a document such as this one. This vignette shows what a
drawing shows and how to change it, one feature at a time, on small
pedigrees typed in the code. The last drawing is the 375-animal example
pedigree that comes with the package. In each drawing you can zoom with
the mouse wheel or a trackpad, drag to move the picture, hover over an
animal, and pick one in the “Select by id” box.

## From a data frame to a drawing

A pedigree is a data frame with one row per animal: its `id`, `sire`,
`dam` and `sex`, and the generation number `gen` that
[`findGeneration()`](https://rmsharp.github.io/pedkindraw/reference/findGeneration.md)
gives
([`vignette("pedkindraw")`](https://rmsharp.github.io/pedkindraw/articles/pedkindraw.md)
describes the columns). Here A and B are the parents of C, D and E, and
C and F are the parents of G and H.

``` r

library(pedkindraw)

fam <- data.frame(
  id   = c("A", "B", "C", "D", "E", "F", "G", "H"),
  sire = c(NA, NA, "A", "A", "A", NA, "C", "C"),
  dam  = c(NA, NA, "B", "B", "B", NA, "F", "F"),
  sex  = c("M", "F", "M", "F", "F", "F", "F", "M")
)
fam$gen <- findGeneration(fam$id, fam$sire, fam$dam)
layout <- makePedigreeMatingLayout(fam)
drawPedigreeDiagram(layout)
```

Each generation is a row: A and B at the top, their offspring C, D and E
below them, and G and H at the bottom. F has no parents in the pedigree,
so she is a founder like A and B, but she is drawn beside her mate C, on
his row. A mating is the small dot between two mates, with lines down to
each of their offspring, drawn at right angles as kinship2 draws them.
In each mating here the sire is drawn left of the dam, and C, D and E
are drawn left to right in the order of their rows.

The layout is a list. Its `nodes` data frame has a row for each animal
and each mating dot, and for each of the invisible points that the lines
turn at, with the node’s place: `x`, and `y`, which grows downward. The
ids of the dots and points start with two underscores. Its `edges` data
frame has a row for each line.

``` r

names(layout)
#> [1] "nodes"              "edges"              "duplicateToReal"   
#> [4] "isolatedIds"        "conditions"         "conditionsNotDrawn"
#> [7] "hints"
animals <- layout$nodes[!startsWith(layout$nodes$id, "__"), ]
data.frame(id = animals$id, shape = animals$shape,
           x = round(animals$x), y = animals$y)
#>   id  shape    x   y
#> 1  A square  -10   0
#> 2  B    dot  110   0
#> 3  C square -150 150
#> 4  D    dot   90 150
#> 5  E    dot  210 150
#> 6  F    dot  -30 150
#> 7  G    dot -150 300
#> 8  H square  -30 300
```

## Symbols and the legend

The symbol shows the sex: a square for `"M"`, a circle for `"F"`, a star
for `"H"` (a hermaphrodite), a triangle for `"U"` (unknown) and a
diamond for any other code or none (`NA`), “Other / Unrecorded” in the
legend. An optional `status` column marks with a slash each animal whose
status is `"DECEASED"`. Here S1 and D1 have one offspring of each sex
code, and S1 has died.

``` r

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
kidsLayout <- makePedigreeMatingLayout(kids)
drawPedigreeDiagram(kidsLayout)
```

The legend on the right of every drawing lists the five symbols, then
“Affected” (see Conditions, below) and “Deceased”, then the lines: the
dashed line that joins two places of the same animal, and the three twin
lines. Hover over an animal to see its id, sex, generation, sire and
dam, and each condition; hover over a mating dot to see how many
offspring it has. While you hover, the animals and lines that are not
near the one under the pointer turn grey.

## Conditions

A column whose name starts with `affected` is a condition. With one such
column, an animal whose value is `TRUE` (or 1) is filled pink, `FALSE`
(or 0) leaves it white, and `NA` fills it grey, so that an animal whose
status is not known does not look unaffected; the legend then has a grey
row “Affected status unknown”. Hovering over an animal says Yes, No or
Unknown. Here D and G are affected, and whether H is affected is not
known.

``` r

fam1 <- fam
fam1$affected <- c(FALSE, FALSE, FALSE, TRUE, FALSE, FALSE, TRUE, NA)
layout1 <- makePedigreeMatingLayout(fam1)
drawPedigreeDiagram(layout1)
```

With two to four condition columns, each symbol is cut into one section
per condition, filled in that condition’s colour where the animal is
affected, and each condition’s row in the legend shows the sections with
its own filled; a section whose status is not known is grey. The
sections go counter-clockwise from the top, in the order of the columns.
The column’s name gives the label: `affected_diabetes` becomes “Affected
(diabetes)”. The drawing grows 45 pixels taller for each condition past
the first, and for the “Affected status unknown” row, to make room in
the legend. Here C has diabetes, B and E are obese, and A has arthritis;
G has diabetes and is obese, and whether H is obese is not known, so H’s
obesity section is grey.

``` r

fam3 <- fam
fam3$affected_diabetes  <- c(FALSE, FALSE, TRUE, FALSE, FALSE, FALSE, TRUE,
                             FALSE)
fam3$affected_obesity   <- c(FALSE, TRUE, FALSE, FALSE, TRUE, FALSE, TRUE, NA)
fam3$affected_arthritis <- c(TRUE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,
                             FALSE)
layout3 <- makePedigreeMatingLayout(fam3)
layout3$conditions
#>               column                label   color
#> 1  affected_diabetes  Affected (diabetes) #CC79A7
#> 2   affected_obesity   Affected (obesity) #E69F00
#> 3 affected_arthritis Affected (arthritis) #56B4E9
drawPedigreeDiagram(layout3)
```

A fifth condition column and any after it are not drawn: the layout
names them in `conditionsNotDrawn`.

``` r

fam5 <- fam3
fam5$affected_cataract     <- FALSE
fam5$affected_hypertension <- FALSE
layout5 <- makePedigreeMatingLayout(fam5)
layout5$conditions$label
#> [1] "Affected (diabetes)"  "Affected (obesity)"   "Affected (arthritis)"
#> [4] "Affected (cataract)"
layout5$conditionsNotDrawn
#> [1] "affected_hypertension"
```

## Twins

Twins are listed in a table of their own, one pair per row: `id1`, `id2`
and `code`, which is `"MZ twin"`, `"DZ twin"` or `"UZ twin"` (identical,
fraternal or unknown).
[`checkTwinRelations()`](https://rmsharp.github.io/pedkindraw/reference/checkTwinRelations.md)
stops if a pair is not possible: MZ and DZ twins must have the same sire
and dam, and MZ twins the same sex. The layout takes the table as
`twinRelations` and draws a green line between the two animals of each
pair: solid and labelled “MZ”, dashed and labelled “DZ”, or with long
dashes and labelled “?”.

``` r

litter <- data.frame(
  id   = c("S1", "D1", "A1", "A2", "B1", "B2", "C1", "C2"),
  sire = c(NA, NA, "S1", "S1", "S1", "S1", "S1", "S1"),
  dam  = c(NA, NA, "D1", "D1", "D1", "D1", "D1", "D1"),
  sex  = c("M", "F", "F", "F", "M", "F", "M", "M")
)
litter$gen <- findGeneration(litter$id, litter$sire, litter$dam)
twins <- data.frame(
  id1  = c("A1", "B1", "C1"),
  id2  = c("A2", "B2", "C2"),
  code = c("MZ twin", "DZ twin", "UZ twin")
)
twins <- checkTwinRelations(litter, twins)
twinLayout <- makePedigreeMatingLayout(litter, twinRelations = twins)
drawPedigreeDiagram(twinLayout)
```

## Animals drawn twice

An animal is drawn in its own row under its sire and dam. When it mates
with an animal that also has parents in the pedigree, one of the two is
drawn a second time, beside the other, and a dashed line joins its two
places. Here C, an offspring of A and B, and R, an offspring of P and Q,
are the parents of S and T.

``` r

two <- data.frame(
  id   = c("A", "B", "C", "P", "Q", "R", "S", "T"),
  sire = c(NA, NA, "A", NA, NA, "P", "C", "C"),
  dam  = c(NA, NA, "B", NA, NA, "Q", "R", "R"),
  sex  = c("M", "F", "M", "M", "F", "F", "F", "M")
)
two$gen <- findGeneration(two$id, two$sire, two$dam)
twoLayout <- makePedigreeMatingLayout(two)
twoLayout$duplicateToReal
#> __dup_R_1 
#>       "R"
drawPedigreeDiagram(twoLayout)
```

R is drawn under her parents P and Q, and again beside her mate C, where
S and T are drawn under their mating. The layout’s `duplicateToReal`
names each repeat node and the animal it stands for, and hovering over a
repeat says “(duplicate occurrence)”.

## Matings of relatives

When a sire and dam are related, that is when their kinship coefficient
is above 0, the two lines from them to their mating are drawn thick and
orange; kinship2 draws a double line. Here C and D are full siblings,
with a kinship coefficient of 0.25, so D is drawn again beside C.

``` r

sibs <- data.frame(
  id   = c("A", "B", "C", "D", "K"),
  sire = c(NA, NA, "A", "A", "C"),
  dam  = c(NA, NA, "B", "B", "D"),
  sex  = c("M", "F", "M", "F", "F")
)
sibs$gen <- findGeneration(sibs$id, sibs$sire, sibs$dam)
sibsLayout <- makePedigreeMatingLayout(sibs)
drawPedigreeDiagram(sibsLayout)
```

## Two edge styles

`edgeStyle = "direct"` draws a straight line from each parent to the
mating dot and from the dot to each offspring, instead of lines at right
angles. The animals and the dots stay where they were. Give
[`drawPedigreeDiagram()`](https://rmsharp.github.io/pedkindraw/reference/drawPedigreeDiagram.md)
the same `edgeStyle`: it sets how far the highlight reaches when you
hover.

``` r

direct <- makePedigreeMatingLayout(fam, edgeStyle = "direct")
drawPedigreeDiagram(direct, edgeStyle = "direct")
```

## Animals with no relative

An animal with no known parent, no offspring and no twin has nothing to
join it to the others, so the layout leaves it out, says so in a
message, and lists it in `isolatedIds`.

``` r

withZ <- rbind(fam, data.frame(id = "Z", sire = NA, dam = NA, sex = "M",
                               gen = 0L))
zLayout <- makePedigreeMatingLayout(withZ)
#> makePedigreeMatingLayout(): 1 individual(s) with no recorded parents, mates, or offspring suppressed from the pedigree diagram: Z
zLayout$isolatedIds
#> [1] "Z"
```

Two animals that have mated but have no offspring together are not left
out when the `matings` argument names them, one row per mating with its
`sire` and `dam`: they are drawn side by side on one row, joined at a
mating dot with no line down, as kinship2 and Pedixplorer draw a
declared mating. The dot’s hover text reads “0 offspring”. Here Y is Z’s
mate.

``` r

withYZ <- rbind(withZ, data.frame(id = "Y", sire = NA, dam = NA, sex = "F",
                                  gen = 0L))
yzLayout <- makePedigreeMatingLayout(
  withYZ, matings = data.frame(sire = "Z", dam = "Y")
)
drawPedigreeDiagram(yzLayout)
```

## Layout hints

The layout chooses the order of siblings and of families, and, for two
animals with parents of their own, which one their offspring are drawn
under. Layout hints change these choices. `hints` is a list with
`order`, `mate` or both, in the form kinship2 and Pedixplorer give them.

`order` is a number for each animal, named by its id. Siblings, separate
families and founder couples are drawn left to right in increasing order
of their numbers; an animal without a number keeps its row’s place. Here
E, D and C are drawn in that order, and C’s mate F and their offspring
move with him.

``` r

orderLayout <- makePedigreeMatingLayout(
  fam, hints = list(order = c(C = 3, D = 2, E = 1))
)
drawPedigreeDiagram(orderLayout)
```

`mate` is a data frame with one row per mating to place. `left` and
`right` are its two animals, `left` drawn left of `right`, and `anchor`
names the one under whose own place their offspring are drawn: `"left"`,
`"right"`, or `"either"` for the layout’s own choice. Here the anchor is
R, so C, not R, is drawn twice, and S and T are drawn under R’s place.

``` r

mateLayout <- makePedigreeMatingLayout(
  two,
  hints = list(mate = data.frame(left = "C", right = "R", anchor = "right"))
)
drawPedigreeDiagram(mateLayout)
```

The layout returns the hints it used as `hints`, in the same form, so an
edit can start from the layout’s own choices; passed back, they give the
same layout. `order` numbers each animal that has a parent by its row (a
founder gets a number only where an order named it, since naming one
turns off the layout’s own order of founder lines). `mate` has the rows
given, then a row for each other mating as drawn, except the matings of
an animal with three or more of them, where a row can move its mates.

``` r

layout$hints
#> $order
#> C D E G H 
#> 3 4 5 7 8 
#> 
#> $mate
#>   left right anchor
#> 1    A     B   left
#> 2    C     F   left
identical(makePedigreeMatingLayout(fam, hints = layout$hints), layout)
#> [1] TRUE
```

## kinship2 and Pedixplorer objects

[`asPedFrame()`](https://rmsharp.github.io/pedkindraw/reference/asPedFrame.md)
converts a kinship2 `pedigree` or a Pedixplorer `Pedigree` to the data
frame, the twins table and the hints that the layout takes. kinship2
keeps hints in the object’s `hints` element: `order`, and `spouse`, a
matrix with a row for each mating to place, holding the places (row
numbers) of its left and right animal and the anchor, 1 for left, 2 for
right and 0 for either. Here they are set by hand to show their form;
[`kinship2::autohint()`](https://rdrr.io/pkg/kinship2/man/autohint.html)
makes them for kinship2’s own layout, and gives these same hints for
this pedigree. Add the generations before the layout. The chunks below
run only when kinship2 or Pedixplorer is installed.

``` r

p <- kinship2::pedigree(
  id = two$id, dadid = two$sire, momid = two$dam,
  sex = ifelse(two$sex == "M", "male", "female")
)
p$hints <- list(order = 1:8, spouse = matrix(c(3, 6, 2), ncol = 3))
x <- asPedFrame(p)
x$hints
#> $order
#> A B C P Q R S T 
#> 1 2 3 4 5 6 7 8 
#> 
#> $mate
#>   left right anchor
#> 1    C     R  right
x$ped$gen <- findGeneration(x$ped$id, x$ped$sire, x$ped$dam)
k2Layout <- makePedigreeMatingLayout(x$ped, hints = x$hints)
identical(k2Layout$nodes, mateLayout$nodes)
#> [1] TRUE
```

The layout is the one drawn above for the mate hint. Pedixplorer keeps
the same hints as `horder`, already named by id, and `spouse`, a data
frame of `idl`, `idr` and `anchor`:

``` r

px <- Pedixplorer::Pedigree(
  data.frame(id = two$id, dadid = two$sire, momid = two$dam,
             sex = ifelse(two$sex == "M", "male", "female")),
  hints = list(horder = setNames(1:8, two$id),
               spouse = data.frame(idl = "C", idr = "R", anchor = 2))
)
y <- asPedFrame(px)
y$hints
#> $order
#> A B C P Q R S T 
#> 1 2 3 4 5 6 7 8 
#> 
#> $mate
#>   left right anchor
#> 1    C     R  right
```

Both packages’ automatic hints are made for their own layouts, and some
of their mate rows are ones the layout refuses;
[`asPedFrame()`](https://rmsharp.github.io/pedkindraw/reference/asPedFrame.md)
fixes those, and a message names each change.

## Saving a drawing

A drawing is an htmlwidget, so
[`htmlwidgets::saveWidget()`](https://rdrr.io/pkg/htmlwidgets/man/saveWidget.html)
saves it as a web page that any browser opens, with its sections and
slashes. The “Export Diagram (PNG)” button at the bottom right of each
drawing saves a picture of the drawing as you see it, as
`pedigree_diagram.png`.

``` r

diagram <- drawPedigreeDiagram(layout)
htmlwidgets::saveWidget(diagram, "pedigree.html")
```

## Clicks in a Shiny application

A click on a drawing does nothing unless `onClick` gives a JavaScript
function to run. In a Shiny application it can send the id of the node
clicked to the server. The drawing needs 500 pixels of height, 45 more
for each condition past the first.

``` r

## In the user interface:
visNetwork::visNetworkOutput("pedigree", height = "500px")

## In the server function:
output$pedigree <- visNetwork::renderVisNetwork({
  drawPedigreeDiagram(layout, onClick = paste(
    "function(params) {",
    "Shiny.setInputValue('pedigreeClick', params.nodes);",
    "}"
  ))
})
shiny::observeEvent(input$pedigreeClick, {
  print(input$pedigreeClick)
})
```

`params.nodes` holds the id of the node clicked: an animal’s id, a
repeat node’s, which `duplicateToReal` turns into its animal’s, or a
mating dot’s, which starts with `__union_`.

## A colony-size drawing

The example pedigree that comes with the package
([`vignette("pedkindraw")`](https://rmsharp.github.io/pedkindraw/articles/pedkindraw.md))
has 375 rhesus macaques in nine generations, and three twin pairs.

``` r

pedFile <- system.file("extdata", "obfuscated_rhesus_mhc_ped.csv",
                       package = "pedkindraw")
twinFile <- system.file("extdata", "obfuscated_rhesus_mhc_twin_relations.csv",
                        package = "pedkindraw")
ped <- read.csv(pedFile, stringsAsFactors = FALSE)
colonyTwins <- read.csv(twinFile, stringsAsFactors = FALSE)
ped$gen <- findGeneration(ped$id, ped$sire, ped$dam)
colony <- makePedigreeMatingLayout(ped, twinRelations = colonyTwins)
#> Warning: makePedigreeMatingLayout(): 72 same-row edge-node collision(s) could
#> not be fully resolved (residual after the repair-pass cap, or a curved
#> connector whose arc no roundness step fully clears) -- rendered output may
#> still show a straight or curved edge passing near an unrelated node.
drawPedigreeDiagram(colony)
```

The warning says that in 72 places a line may pass close to an animal it
does not belong to: in the right-angle style the layout steps a line
around an animal in its way, and these it could not fully clear. Nothing
is missing from the drawing; all 375 animals are in it.

Fitted to the page, the drawing is too small to read its ids. Zoom in to
read them, or pick an animal in the “Select by id” box: the animals and
lines that are not near it turn grey, which shows where it is. The arcs
are the dashed lines that join each of the 113 animals drawn more than
once to its other places.

## How large a drawing can be

Most of the time a drawing takes goes to the layout, in R. In
measurements made in November 2026 on one Mac (Apple M2 Max),
nprcgenekeepr’s drawing, from which pedkindraw’s is copied, drew 1,000
animals in about 16 seconds, and 2,000 animals not within two minutes.
At 1,000 animals an animal could still be found by its id, and its lines
followed to its parents, once zoomed in.

## Where next

The help pages of
[`makePedigreeMatingLayout()`](https://rmsharp.github.io/pedkindraw/reference/makePedigreeMatingLayout.md)
and
[`drawPedigreeDiagram()`](https://rmsharp.github.io/pedkindraw/reference/drawPedigreeDiagram.md)
give every argument, among them `kinshipMatrix`, which passes the layout
kinship coefficients you have computed;
[`?asPedFrame`](https://rmsharp.github.io/pedkindraw/reference/asPedFrame.md)
gives each conversion, and
[`vignette("pedkindraw")`](https://rmsharp.github.io/pedkindraw/articles/pedkindraw.md)
the rest of the package.
