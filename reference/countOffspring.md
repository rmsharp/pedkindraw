# Count each animal's offspring

`countOffspring()` counts, for each animal, the animals that name it as
their sire or dam. Each offspring is counted once, so an animal's count
is the length of
[`getOffspring`](https://rmsharp.github.io/pedkindraw/reference/getOffspring.md)`(ped, id)`.
An id with no offspring in `ped` gets 0, `NA` among them.

## Usage

``` r
countOffspring(ped, ids = ped[["id"]])
```

## Arguments

- ped:

  a data frame with the columns `id`, `sire` and `dam`, an unknown
  parent written `NA` (see
  [`recodePedigree`](https://rmsharp.github.io/pedkindraw/reference/recodePedigree.md)).
  Factor columns are read by their labels and numbers as text.

- ids:

  a vector of the animals to count, by default every animal of `ped`. An
  id need not have a row of its own: a sire or dam recorded only as a
  parent is counted too.

## Value

An integer vector of each animal's number of offspring, named by `ids`
as text, in their order.

## Details

The count is Pedixplorer's `num_child_dir` on the pedigrees this
package's tests compare, where a sire and dam have an offspring
together. An animal recorded as both a sire and a dam (which
[`checkPedigree`](https://rmsharp.github.io/pedkindraw/reference/checkPedigree.md)
reports) is counted for its offspring of both kinds.

## See also

[`getOffspring`](https://rmsharp.github.io/pedkindraw/reference/getOffspring.md),
[`getMatings`](https://rmsharp.github.io/pedkindraw/reference/getMatings.md)

## Examples

``` r
## A and B have C; A and E have F; A has G, its dam unknown; B has H,
## its sire unknown; K and E have I.
ped <- data.frame(
  id = c("A", "B", "E", "K", "C", "F", "G", "H", "I"),
  sire = c(NA, NA, NA, NA, "A", "A", "A", NA, "K"),
  dam = c(NA, NA, NA, NA, "B", "E", NA, "B", "E")
)
countOffspring(ped)
#> A B E K C F G H I 
#> 3 2 2 1 0 0 0 0 0 
countOffspring(ped, c("A", "E"))
#> A E 
#> 3 2 
```
