# Convert a pedigree data frame into visNetwork-ready diagram data

Builds the node and edge tables consumed by
[`visNetwork::visNetwork()`](https://rdrr.io/pkg/visNetwork/man/visNetwork.html)
from a pedigree data frame: one node per individual, sex-coded to a node
shape, positioned by generation; one directed edge per known sire and
one per known dam, pointing from parent to child.

## Usage

``` r
makePedigreeDiagramData(ped, twinRelations = NULL)
```

## Arguments

- ped:

  data frame with `id`, `sire`, `dam`, `sex`, and `gen` columns
  (`sire`/`dam` `NA` for unknown parents; `gen` an integer generation
  number, 0 for founders, as produced by
  [`findGeneration`](https://rmsharp.github.io/pedkindraw/reference/findGeneration.md)).
  Two optional columns are used when present: a logical `affected`
  column, which adds an affected-status line to `title` and fills
  affected nodes with `color.background` `"#CC79A7"` (all other nodes
  are white, `"#FFFFFF"`); and a character `name` column, which is shown
  in `label` (long names are truncated) and in `title`. In `affected`
  the numbers 1 and 0 read as `TRUE` and `FALSE`, and any other number
  stops (compare a measured trait with a threshold first); text reads as
  [`as.logical()`](https://rdrr.io/r/base/logical.html) reads it, other
  text as unknown.

- twinRelations:

  optional data.frame with columns `id1`, `id2`, `code` (see
  [`checkTwinRelations`](https://rmsharp.github.io/pedkindraw/reference/checkTwinRelations.md)).
  Not validated here; validate with
  [`checkTwinRelations`](https://rmsharp.github.io/pedkindraw/reference/checkTwinRelations.md)
  first. `NULL` (default) adds no connector edges, so `edges` has only
  `from` and `to`.

## Value

A list with two data frames: `nodes` (`id`, `label`, `shape`, `level`,
`title`, `color.background`) and `edges` (`from`, `to`, plus
`dashes`/`label`/`color` when `twinRelations` is supplied). `title` is
an HTML hover-tooltip string giving ID, sex, generation, sire, and dam
(and affected status and name when those optional columns are present).

## Examples

``` r
## Seven animals: C and D are full siblings, and so are F and G, D's
## offspring
ped <- data.frame(
  id = c("A", "B", "C", "D", "E", "F", "G"),
  sire = c(NA, NA, "A", "A", NA, "D", "D"),
  dam = c(NA, NA, "B", "B", NA, "E", "E"),
  sex = c("M", "F", "F", "M", "F", "M", "F"),
  stringsAsFactors = FALSE
)
ped$gen <- findGeneration(ped$id, ped$sire, ped$dam)
diagramData <- makePedigreeDiagramData(ped)
## One node per animal, and one edge per known parent
nrow(diagramData$nodes)
#> [1] 7
nrow(diagramData$edges)
#> [1] 8
```
