# Bit size of a pedigree

The bit size of a pedigree, `2 * nNonFounder - nFounder`: the measure
[`shrinkPedigree`](https://rmsharp.github.io/pedkindraw/reference/shrinkPedigree.md)
reduces toward its `maxBits` budget, and its first `bitSize` value. A
founder is an animal whose `sire` and `dam` are both unknown (`NA`); an
animal with one known parent is a non-founder (see
[`isFounder`](https://rmsharp.github.io/pedkindraw/reference/isFounder.md)).

## Usage

``` r
bitSize(ped)
```

## Arguments

- ped:

  a pedigree `data.frame` with the fields `id`, `sire` and `dam`.

## Value

A list of three integers: `bitSize`, `nFounder` and `nNonFounder`.

## Details

It returns the same list as
[`kinship2::bitSize()`](https://rdrr.io/pkg/kinship2/man/bitSize.html),
from a pedigree data frame instead of a kinship2 pedigree object.

It stops with
[`shrinkPedigree()`](https://rmsharp.github.io/pedkindraw/reference/shrinkPedigree.md)'s
message when `ped` lacks `id`, `sire` or `dam` (naming them), is not a
data frame, has an `id` that is missing, empty or repeated, has a `sire`
or `dam` that is not an `id` of `ped`, or has an animal that is both a
sire and a dam.

## References

Sinnwell JP, Therneau TM, Schaid DJ (2014). "The kinship2 R Package for
Pedigree Data." *Human Heredity*, 78(2), 91-93.

## See also

[`shrinkPedigree`](https://rmsharp.github.io/pedkindraw/reference/shrinkPedigree.md),
[`findUnavailable`](https://rmsharp.github.io/pedkindraw/reference/findUnavailable.md),
[`findAvailNonInform`](https://rmsharp.github.io/pedkindraw/reference/findAvailNonInform.md),
[`findAvailAffected`](https://rmsharp.github.io/pedkindraw/reference/findAvailAffected.md)

## Examples

``` r
## A, B and E are founders; C, D and F are not
ped <- data.frame(
  id = c("A", "B", "C", "D", "E", "F"),
  sire = c(NA, NA, "A", "A", NA, "D"),
  dam = c(NA, NA, "B", "B", NA, "E"),
  stringsAsFactors = FALSE
)
bitSize(ped)
#> $bitSize
#> [1] 3
#> 
#> $nFounder
#> [1] 3
#> 
#> $nNonFounder
#> [1] 3
#> 
```
