# List the matings of a pedigree

A mating is a sire and a dam with at least one offspring recorded with
both of them. `getMatings()` lists each mating once, in the order its
first offspring comes in `ped`, with the number of offspring the two
share; these are the matings a drawing of the pedigree draws
([`makePedigreeMatingLayout`](https://rmsharp.github.io/pedkindraw/reference/makePedigreeMatingLayout.md)).
An animal's mates are the animals it is listed with.

## Usage

``` r
getMatings(ped)
```

## Arguments

- ped:

  a data frame with the columns `id`, `sire` and `dam`, an unknown
  parent written `NA` (see
  [`recodePedigree`](https://rmsharp.github.io/pedkindraw/reference/recodePedigree.md)).
  Factor columns are read by their labels and numbers as text.

## Value

A data frame with one row per mating and the columns `sire` and `dam`
(text) and `offspring` (an integer, the number of animals with that sire
and dam). It has no rows when no animal has both parents known.

## Details

An offspring with only one known parent makes no mating (its parent's
[`countOffspring`](https://rmsharp.github.io/pedkindraw/reference/countOffspring.md)
counts it). A sire or dam with no row of its own is listed as recorded.
Each offspring is counted once.

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
```
