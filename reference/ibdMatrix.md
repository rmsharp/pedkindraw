# Build an IBD matrix from pairs of ids and their values

Turns the identity-by-descent (IBD) values that programs such as SOLAR
write, one line per pair of animals, into a symmetric sparse matrix with
a row and a column per animal. Such programs list only the pairs with a
value above 0, and the matrix stores only those and the diagonal (each
animal with itself), which the input gives or `diagonal` fills in.

## Usage

``` r
ibdMatrix(id1, id2, x, idmap, diagonal)
```

## Arguments

- id1, id2:

  the two ids of each pair: numbers, character or factor ids, `NA` not
  allowed. A pair may be given either way round, and twice if with the
  same value. Instead, `id1` may be a data frame or matrix with 3
  columns, the ids and the value, with `id2` and `x` left out.

- x:

  the IBD value of each pair: finite numbers, kept as given. A 0 is not
  stored.

- idmap:

  optional: a matrix or data frame with 2 columns, the ids as they
  appear in `id1` and `id2` (such as SOLAR's own numbers) and the name
  each is given in the result (such as the animals' own ids). Each id in
  the pairs must appear in the first column, and once; ids there that
  are not in the pairs add no row.

- diagonal:

  optional: one number, usually 1, for the diagonal entries the input
  does not give. Diagonal entries given are kept.

## Value

A `dsCMatrix` (package `Matrix`): symmetric, its upper triangle stored,
with a row and a column per id in `id1` or `id2`, numbers sorted by
value and character ids in byte order. With `idmap` the rows keep that
order of the ids in the pairs and are named from its second column.

## Details

It is `kinship2`'s `ibdMatrix()`, with its arguments. On every case its
tests compare with kinship2 (random pairs in which every animal has a
diagonal value or `diagonal` is given), it gives kinship2's value for
every pair. It differs from kinship2 1.9.6.2 in these ways. The rows are
the ids given, sorted, where kinship2 often orders them otherwise and,
for some number ids, gives a row for every number from 1 to the largest,
empty for those not given. `idmap` works as kinship2's help page
describes it; kinship2 refuses it. It stops, naming the ids, when an id
has no diagonal value and `diagonal` is not given, where kinship2
returns a diagonal of 0 or, on some such input, never returns. It stops
on vectors of unequal length, which kinship2 recycles, and on one pair
given two different values, where kinship2 keeps the first. Empty input
gives a 0 x 0 matrix.

## References

Sinnwell JP, Therneau TM, Schaid DJ (2014). "The kinship2 R Package for
Pedigree Data." *Human Heredity*, 78(2), 91-93.

## See also

[`kinship`](https://rmsharp.github.io/pedkindraw/reference/kinship.md)

## Examples

``` r
## SOLAR numbers the animals 1 to 4; idmap gives their own ids.
idmap <- data.frame(solarId = 1:4, id = c("M12", "F3", "M7", "F10"))
ibdMatrix(c(1, 1, 2, 3, 3, 4), c(1, 2, 2, 3, 4, 4),
          c(1, 0.5, 1, 1, 0.25, 1), idmap = idmap)
#> 4 x 4 sparse Matrix of class "dsCMatrix"
#>     M12  F3   M7  F10
#> M12 1.0 0.5 .    .   
#> F3  0.5 1.0 .    .   
#> M7  .   .   1.00 0.25
#> F10 .   .   0.25 1.00
## The pairs as one table, the diagonal entries filled in with 1.
pairs <- data.frame(id1 = c("A", "A", "B"), id2 = c("B", "C", "C"),
                    x = c(0.5, 0.25, 0.5))
ibdMatrix(pairs, diagonal = 1)
#> 3 x 3 sparse Matrix of class "dsCMatrix"
#>      A   B    C
#> A 1.00 0.5 0.25
#> B 0.50 1.0 0.50
#> C 0.25 0.5 1.00
```
