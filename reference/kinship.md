# Generate a kinship matrix

The generation number of each animal (`pdepth`) is calculated elsewhere,
for example with
[`findGeneration()`](https://rmsharp.github.io/pedkindraw/reference/findGeneration.md),
and passed in.

## Usage

``` r
kinship(
  id,
  fatherId,
  motherId,
  pdepth,
  sparse = FALSE,
  twinRelations = NULL,
  chrtype = "autosome",
  sex = NULL
)
```

## Arguments

- id:

  character vector of IDs for a set of animals.

- fatherId:

  character vector or NA for the IDs of the sires for the set of
  animals.

- motherId:

  character vector or NA for the IDs of the dams for the set of animals.

- pdepth:

  integer vector indicating the generation number for each animal.

- sparse:

  logical flag. If `TRUE`, the result is a sparse matrix of the Matrix
  package with the same values: a `ddiMatrix` when no two animals have a
  kinship, otherwise a `dgCMatrix`. If `FALSE`, the result is a base
  matrix.

- twinRelations:

  `NULL` (default, no-op) or a data.frame with columns `id1`, `id2`,
  `code` declaring twin pairs (see
  [`checkTwinRelations`](https://rmsharp.github.io/pedkindraw/reference/checkTwinRelations.md)).
  Only `code == "MZ twin"` rows affect the computed matrix –
  `"DZ twin"`/`"UZ twin"` rows are accepted but get zero special
  treatment, matching kinship2's own `relation` mechanism. A declared
  MZ-twin pair's coefficient is corrected to equal their shared
  self-kinship (genetic identity), and the correction is propagated
  transitively (chained MZ declarations, e.g. A-B and B-C, also correct
  the undeclared A-C pair) and to every relative computed at a later
  pedigree depth through either twin – not just the declared pair's own
  cell. `twinRelations` is trusted as already validated by
  [`checkTwinRelations`](https://rmsharp.github.io/pedkindraw/reference/checkTwinRelations.md)
  (this function has no `sex` parameter of its own and so cannot re-run
  that validator's full rule set itself); only a cheap self-contained
  check (both ids present in `id`) is performed here.

- chrtype:

  `"autosome"` (default) or `"x"`. When `"autosome"`, behavior is
  unchanged from every prior version of this function – `sex` is not
  required and is ignored if supplied. When `"x"`, computes X-chromosome
  kinship instead: a male's X comes from his mother only (self-kinship
  1, since he carries a single copy); a female's X-linked kinship
  follows the same average-of-parents formula as the autosomal case
  (self-kinship 0.5, as usual). A founder of unrecognized `sex` gets
  `NA` only on its own diagonal cell and 0 with the other founders, as
  in kinship2; an animal of unrecognized `sex` that has parents in the
  pedigree gets `NA` kinship with everyone, itself included. The MZ-twin
  correction (`twinRelations`) applies inside this branch identically to
  the autosomal branch. The method is that of Sinnwell, Therneau and
  Schaid (2014), cited below.

- sex:

  `NULL` (default) or a character vector, the same length as `id`, using
  this package's own internal sex codes (`sexCodes`): `"M"`/`"F"`; any
  other value, including `NA`, is treated as unknown). Required when
  `chrtype = "x"`; ignored (may be omitted) when `chrtype = "autosome"`.

## Value

A kinship square matrix

## Details

The rows (cols) of founders are just 0.5 \* identity matrix, no further
processing is needed for them. Parents must be processed before their
children, and then a child's kinship is just the average of the kinship
values for his or her parents.

## References

Lange K (1997). *Mathematical and Statistical Methods for Genetic
Analysis*. Springer, pp. 71-72: the kinship matrix.

Sinnwell JP, Therneau TM, Schaid DJ (2014). "The kinship2 R Package for
Pedigree Data." *Human Heredity*, 78(2), 91-93, and its supplementary
material (Table S2): the X chromosome.

## Examples

``` r
## Seven animals: C and D are full siblings, and so are F and G, D's
## offspring
ped <- data.frame(
  id = c("A", "B", "C", "D", "E", "F", "G"),
  sire = c(NA, NA, "A", "A", NA, "D", "D"),
  dam = c(NA, NA, "B", "B", NA, "E", "E"),
  stringsAsFactors = FALSE
)
ped$gen <- findGeneration(ped$id, ped$sire, ped$dam)
kmat <- kinship(ped$id, ped$sire, ped$dam, ped$gen)
ped
#>   id sire  dam gen
#> 1  A <NA> <NA>   0
#> 2  B <NA> <NA>   0
#> 3  C    A    B   1
#> 4  D    A    B   1
#> 5  E <NA> <NA>   0
#> 6  F    D    E   2
#> 7  G    D    E   2
## No animal is inbred, so each has 0.5 with itself; parent and child,
## and full siblings, have 0.25; grandparent and grandchild 0.125
kmat
#>       A     B     C    D    E     F     G
#> A 0.500 0.000 0.250 0.25 0.00 0.125 0.125
#> B 0.000 0.500 0.250 0.25 0.00 0.125 0.125
#> C 0.250 0.250 0.500 0.25 0.00 0.125 0.125
#> D 0.250 0.250 0.250 0.50 0.00 0.250 0.250
#> E 0.000 0.000 0.000 0.00 0.50 0.250 0.250
#> F 0.125 0.125 0.125 0.25 0.25 0.500 0.250
#> G 0.125 0.125 0.125 0.25 0.25 0.250 0.500
```
