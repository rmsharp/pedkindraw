# Find genotyped animals that add no information to a pedigree

The ids
[`shrinkPedigree`](https://rmsharp.github.io/pedkindraw/reference/shrinkPedigree.md)
removes in its second trim, in the order it removes them. An animal is
uninformative when it is genotyped, is no animal's parent, is not
`affected` (an `NA` status counts as unaffected), and has both parents
known and genotyped. Each round removes the uninformative animals, with
any animal their removal leaves removable as in the first trim (see
[`findUnavailable`](https://rmsharp.github.io/pedkindraw/reference/findUnavailable.md)),
such as a founder left with no offspring; the rounds go on until one
removes nothing, so a parent left as a leaf can go in a later round. An
animal with one known parent is never uninformative.

## Usage

``` r
findAvailNonInform(ped, genotyped, affected = NULL)
```

## Arguments

- ped:

  a pedigree `data.frame` with the fields `id`, `sire` and `dam`, and
  optionally a logical `affected` column.

- genotyped:

  a logical vector, one value per row of `ped`, `TRUE` where the animal
  is genotyped (or otherwise available). `NA` is not allowed.

- affected:

  `NULL` (default) or a logical vector, one value per row of `ped`. When
  `NULL`, `ped$affected` is used if it exists, and otherwise every
  animal counts as unaffected. The numbers 1 and 0 read as `TRUE` and
  `FALSE`; any other number stops.

## Value

A character vector of ids in the order they are removed; `character(0)`
when none is.

## Details

It runs the first trim itself and returns only the second trim's ids, so
it takes the whole pedigree. kinship2's `findAvailNonInform()` makes one
pass and does not follow on to the parents it leaves;
[`kinship2::pedigree.shrink()`](https://rdrr.io/pkg/kinship2/man/pedigree.shrink.html)'s
second step does, as this function does. On every pedigree its tests
compare, it and
[`findUnavailable()`](https://rmsharp.github.io/pedkindraw/reference/findUnavailable.md)
together remove the same animals as `pedigree.shrink()`'s first two
steps.

It stops with
[`shrinkPedigree()`](https://rmsharp.github.io/pedkindraw/reference/shrinkPedigree.md)'s
message for a bad pedigree, or for a `genotyped` or `affected` vector of
the wrong length, or an `NA` in `genotyped`.

## References

Sinnwell JP, Therneau TM, Schaid DJ (2014). "The kinship2 R Package for
Pedigree Data." *Human Heredity*, 78(2), 91-93.

## See also

[`shrinkPedigree`](https://rmsharp.github.io/pedkindraw/reference/shrinkPedigree.md),
[`findUnavailable`](https://rmsharp.github.io/pedkindraw/reference/findUnavailable.md),
[`findAvailAffected`](https://rmsharp.github.io/pedkindraw/reference/findAvailAffected.md),
[`bitSize`](https://rmsharp.github.io/pedkindraw/reference/bitSize.md)

## Examples

``` r
## All genotyped. G and H are uninformative; with G gone, E has no
## offspring and goes; then C is uninformative. D is affected, and I has
## one known parent.
ped <- data.frame(
  id = c("A", "B", "C", "D", "E", "G", "H", "I"),
  sire = c(NA, NA, "A", "A", NA, "C", "A", "A"),
  dam = c(NA, NA, "B", "B", NA, "E", "B", NA),
  affected = c(FALSE, FALSE, FALSE, TRUE, FALSE, FALSE, NA, FALSE),
  stringsAsFactors = FALSE
)
findAvailNonInform(ped, rep(TRUE, nrow(ped)))
#> [1] "G" "H" "E" "C"
```
