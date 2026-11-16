# Check family ids against the family trees the parents form

Compares the family id each animal is given with the family trees its
parent links form. Two animals are in the same tree when a chain of
parent-offspring links joins them. A link counts only when the parent
has a row (an id in `id`), so a parent id with no row, such as `"0"` or
`""`, links no one, as in `kinship2`. An animal linked to no other is
related to no one.

## Usage

``` r
familyCheck(famid, id, sire, dam, newfam)
```

## Arguments

- famid:

  a vector of family ids, one per animal. `NA` is not allowed.

- id:

  a vector of unique animal ids. `NA` is not allowed.

- sire:

  a vector with each animal's sire, `NA` if unknown.

- dam:

  a vector with each animal's dam, `NA` if unknown.

- newfam:

  optional: a family-tree number per animal, 0 for an animal related to
  no one, as
  [`kinship2::makefamid()`](https://rdrr.io/pkg/kinship2/man/makefamid.html)
  returns. When given it is used as it is, instead of computing the
  trees.

## Value

A data frame with one row per family id, sorted (character ids in byte
order, numbers by value), and the columns `famid` (the family id, of the
type given; a factor's as character), `n`, `unrelated`, `split` and
`join` (integers). When any `join` is above 0, the data frame has an
attribute `"join"`: an integer matrix with a row per joined family id
and a column per family tree their animals belong to, named by tree
number, each entry the number of that family's animals in that tree.
Trees are numbered 1, 2, ... in the order of their first animal, as
[`kinship2::makefamid()`](https://rdrr.io/pkg/kinship2/man/makefamid.html)
numbers them.

## Details

For each family id, `familyCheck()` counts its animals (`n`), those
related to no one (`unrelated`), the trees its other animals fall in
(`split`: 1 is what a family should be; 0 means none of its animals is
related to another; 2 or more means it is two or more trees with no link
between them), and the other family ids sharing those trees (`join`: 0
is what a family should be). `join` counts another family id once for
each tree the two share, as
[`kinship2::familycheck()`](https://rdrr.io/pkg/kinship2/man/familycheck.html)
does.

It is `kinship2`'s `familycheck()` for pedigree vectors whose unknown
parents are `NA`. On every case its tests compare with kinship2 (the
fixture pedigrees with family ids given wrongly, and random families),
it gives kinship2's counts and join table. It differs where kinship2
stops with an error: when every join lies within one family tree, and
for empty input, where it returns zero rows. It sorts character family
ids in byte order, where kinship2 follows the locale; keeps the family
ids' type and returns integer counts; names the join table's columns by
tree number; and stops on a repeated id, which kinship2 accepts. An
animal that is its own ancestor does not stop it (kinship2 stops on some
such pedigrees).

## References

Sinnwell JP, Therneau TM, Schaid DJ (2014). "The kinship2 R Package for
Pedigree Data." *Human Heredity*, 78(2), 91-93.

## See also

[`findPedigreeNumber`](https://rmsharp.github.io/pedkindraw/reference/findPedigreeNumber.md)

## Examples

``` r
## A and B are the parents of C, and D and E of F; G is related to no one.
## Family "a" is given to A and B, but C, their child, is given "x".
id <- c("A", "B", "C", "D", "E", "F", "G")
sire <- c(NA, NA, "A", NA, NA, "D", NA)
dam <- c(NA, NA, "B", NA, NA, "E", NA)
famid <- c("a", "a", "x", "b", "b", "b", "b")
result <- familyCheck(famid, id, sire, dam)
result
#>   famid n unrelated split join
#> 1     a 2         0     1    1
#> 2     b 4         1     1    0
#> 3     x 1         0     1    1
attr(result, "join")
#>   1
#> a 2
#> x 1
```
