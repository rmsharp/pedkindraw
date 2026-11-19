# Remove listed animals from a pedigree

`removeAnimals()` removes the rows of the listed animals and sets to
`NA` each `sire` or `dam` entry that names one of them, so that no
animal is left with a parent that has no row. An offspring of a removed
animal keeps its other parent: one known parent is legal here.
Afterwards
[`checkPedigree`](https://rmsharp.github.io/pedkindraw/reference/checkPedigree.md)
reports none of the removed animals as `rowlessParents`, a parent with
no row, which
[`findGeneration`](https://rmsharp.github.io/pedkindraw/reference/findGeneration.md)
cannot place and
[`kinship`](https://rmsharp.github.io/pedkindraw/reference/kinship.md)
cannot take.

## Usage

``` r
removeAnimals(ped, ids)
```

## Arguments

- ped:

  a data frame with the columns `id`, `sire` and `dam`, an unknown
  parent written `NA` (see
  [`recodePedigree`](https://rmsharp.github.io/pedkindraw/reference/recodePedigree.md)).
  Factor columns are read by their labels and numbers as text.

- ids:

  a vector of the animals to remove, compared with `id`, `sire` and
  `dam` as text. An id need not have a row: a listed sire or dam with no
  row of its own is cleared from its offspring. An id found nowhere in
  `ped` is ignored, and `NA` among `ids` removes the rows whose id is
  `NA`.

## Value

`ped` without the rows whose id is listed, and with each listed `sire`
or `dam` set to `NA`; its other rows, in their order and with their row
names, its columns and each column's type are unchanged.

## Details

On the pedigrees its tests compare, the result equals kinship2's
`pedigree.trim()` wherever that returns (it stops whenever an offspring
would keep only one parent), and Pedixplorer's
`subset(del_parents = "one")` except that Pedixplorer also clears the
parent that is not removed.

## See also

[`removeUnknownAnimals`](https://rmsharp.github.io/pedkindraw/reference/removeUnknownAnimals.md),
[`removeUninformativeFounders`](https://rmsharp.github.io/pedkindraw/reference/removeUninformativeFounders.md),
[`checkPedigree`](https://rmsharp.github.io/pedkindraw/reference/checkPedigree.md)

## Examples

``` r
## A and B have C and D; C and E have F and G; D and H have I.
ped <- data.frame(
  id = c("A", "B", "C", "D", "E", "F", "G", "H", "I"),
  sire = c(NA, NA, "A", "A", NA, "C", "C", NA, "D"),
  dam = c(NA, NA, "B", "B", NA, "E", "E", NA, "H")
)
## Without C's row, C is a sire with no row of its own.
checkPedigree(ped[ped$id != "C", ])
#>            check id       detail
#> 1 rowlessParents  C sire of F, G
## removeAnimals() also clears C as the sire of F and G, who keep their
## dam E.
kept <- removeAnimals(ped, "C")
kept
#>   id sire  dam
#> 1  A <NA> <NA>
#> 2  B <NA> <NA>
#> 4  D    A    B
#> 5  E <NA> <NA>
#> 6  F <NA>    E
#> 7  G <NA>    E
#> 8  H <NA> <NA>
#> 9  I    D    H
checkPedigree(kept)
#> [1] check  id     detail
#> <0 rows> (or 0-length row.names)
gen <- findGeneration(kept$id, kept$sire, kept$dam)
kinship(kept$id, kept$sire, kept$dam, gen)["F", "G"]
#> [1] 0.125
```
