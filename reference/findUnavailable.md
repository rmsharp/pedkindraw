# Find the animals a pedigree can lose because they are unavailable

The ids
[`shrinkPedigree`](https://rmsharp.github.io/pedkindraw/reference/shrinkPedigree.md)
removes in its first trim, in the order it removes them: animals that
are not genotyped and have no genotyped descendant (ungenotyped leaves,
removed until none is left); then each founder couple with one child
together and no other mate when neither founder is genotyped (the child
becomes a founder); then each founder left with no offspring (a stray
marry-in), genotyped or not.

## Usage

``` r
findUnavailable(ped, genotyped)
```

## Arguments

- ped:

  a pedigree `data.frame` with the fields `id`, `sire` and `dam`.

- genotyped:

  a logical vector, one value per row of `ped`, `TRUE` where the animal
  is genotyped (or otherwise available). `NA` is not allowed.

## Value

A character vector of ids in the order they are removed; `character(0)`
when none is.

## Details

It is the step of
[`shrinkPedigree()`](https://rmsharp.github.io/pedkindraw/reference/shrinkPedigree.md)
that `kinship2`'s `findUnavailable()` performs, from a pedigree data
frame instead of a kinship2 pedigree object. Two differences: when no
animal is genotyped, kinship2's function stops with an error, and this
one returns every id; and when removing an ungenotyped founder couple
makes its ungenotyped child a founder, this function, like
[`shrinkPedigree()`](https://rmsharp.github.io/pedkindraw/reference/shrinkPedigree.md),
removes in the same trim the couple that child forms with another
ungenotyped founder, if that couple's child comes later in `ped`, where
kinship2 leaves that couple for its next step. On every pedigree its
tests compare, this function and
[`findAvailNonInform`](https://rmsharp.github.io/pedkindraw/reference/findAvailNonInform.md)
together remove the same animals as
[`kinship2::pedigree.shrink()`](https://rdrr.io/pkg/kinship2/man/pedigree.shrink.html)'s
first two steps. An animal may have one known parent.

It stops with
[`shrinkPedigree()`](https://rmsharp.github.io/pedkindraw/reference/shrinkPedigree.md)'s
message for a bad pedigree or a `genotyped` vector of the wrong length
or with an `NA`.

## References

Sinnwell JP, Therneau TM, Schaid DJ (2014). "The kinship2 R Package for
Pedigree Data." *Human Heredity*, 78(2), 91-93.

## See also

[`shrinkPedigree`](https://rmsharp.github.io/pedkindraw/reference/shrinkPedigree.md),
[`findAvailNonInform`](https://rmsharp.github.io/pedkindraw/reference/findAvailNonInform.md),
[`findAvailAffected`](https://rmsharp.github.io/pedkindraw/reference/findAvailAffected.md),
[`bitSize`](https://rmsharp.github.io/pedkindraw/reference/bitSize.md)

## Examples

``` r
## D, G and I are ungenotyped leaves; then A and B are an ungenotyped
## founder couple with one child, C; then H is a founder with no offspring
ped <- data.frame(
  id = c("A", "B", "C", "D", "E", "F", "G", "H", "I"),
  sire = c(NA, NA, "A", "A", NA, "C", "C", NA, "H"),
  dam = c(NA, NA, "B", "B", NA, "E", "E", NA, "E"),
  stringsAsFactors = FALSE
)
genotyped <- c(FALSE, FALSE, TRUE, FALSE, TRUE, TRUE, FALSE, TRUE, FALSE)
findUnavailable(ped, genotyped)
#> [1] "D" "G" "I" "A" "B" "H"
```
