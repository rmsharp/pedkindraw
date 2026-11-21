# List the matings of a pedigree

A mating is a sire and a dam with at least one offspring recorded with
both of them, or a pair declared mated in `matings`. `getMatings()`
lists each mating once: first those with offspring, in the order the
first offspring of each comes in `ped`, with the number of offspring the
two share; then each declared pair with no offspring together, in the
order of `matings`, with 0. These are the matings a drawing of the
pedigree draws, in its order
([`makePedigreeMatingLayout`](https://rmsharp.github.io/pedkindraw/reference/makePedigreeMatingLayout.md),
given the same `matings`). An animal's mates are the animals it is
listed with.

## Usage

``` r
getMatings(ped, matings = NULL)
```

## Arguments

- ped:

  a data frame with the columns `id`, `sire` and `dam`, an unknown
  parent written `NA` (see
  [`recodePedigree`](https://rmsharp.github.io/pedkindraw/reference/recodePedigree.md)).
  Factor columns are read by their labels and numbers as text.

- matings:

  `NULL` (the default) or a data frame with the columns `sire` and `dam`
  (text or factor; other columns are ignored), one row per mating
  declared whether or not the two have offspring together, as
  [`makePedigreeMatingLayout`](https://rmsharp.github.io/pedkindraw/reference/makePedigreeMatingLayout.md)
  takes it. Stops on anything but `NULL` or a data frame with both
  columns, on `NA`, and on the same id as sire and dam.

## Value

A data frame with one row per mating and the columns `sire` and `dam`
(text) and `offspring` (an integer, the number of animals with that sire
and dam; 0 for a declared mating with none). It has no rows when no
animal has both parents known and no mating is declared.

## Details

An offspring with only one known parent makes no mating (its parent's
[`countOffspring`](https://rmsharp.github.io/pedkindraw/reference/countOffspring.md)
counts it). A sire or dam with no row of its own is listed as recorded.
Each offspring is counted once.

A row of `matings` naming a pair with offspring together, in either
column, adds nothing and gives no message, so the result of
`getMatings()` can be passed back, with rows added. A pair named twice,
in either column, is listed once, as its first row names it; the sexes
are not checked. A row naming an animal without a row of its own in
`ped`, as a trimming function leaves, is left out, with a message naming
the pair, as the drawing leaves it out.

## See also

[`countOffspring`](https://rmsharp.github.io/pedkindraw/reference/countOffspring.md),
[`getOffspring`](https://rmsharp.github.io/pedkindraw/reference/getOffspring.md)

## Examples

``` r
## A and B have C; A and E have F; A has G, its dam unknown; B has H,
## its sire unknown; K and E have I.
ped <- data.frame(
  id = c("A", "B", "E", "K", "C", "F", "G", "H", "I"),
  sire = c(NA, NA, NA, NA, "A", "A", "A", NA, "K"),
  dam = c(NA, NA, NA, NA, "B", "E", NA, "B", "E")
)
matings <- getMatings(ped)
matings
#>   sire dam offspring
#> 1    A   B         1
#> 2    A   E         1
#> 3    K   E         1
## The mates of E.
c(matings$dam[matings$sire == "E"], matings$sire[matings$dam == "E"])
#> [1] "A" "K"
## K and B declared mated, with no offspring together.
getMatings(ped, matings = data.frame(sire = "K", dam = "B"))
#>   sire dam offspring
#> 1    A   B         1
#> 2    A   E         1
#> 3    K   E         1
#> 4    K   B         0
```
