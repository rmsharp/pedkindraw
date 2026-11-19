# Reduce a pedigree to the near relatives of a group

Keeps each animal within a distance of the probands, and the parents
that join those animals' families, as Pedixplorer's `useful_inds()` does
when given `max_dist`.

## Usage

``` r
getNearRelativePedigree(ped, probands, maxDist)
```

## Arguments

- ped:

  a data frame with the columns `id`, `sire` and `dam` (an unknown
  parent is `NA`). Factor columns are read by their labels and numbers
  as text.

- probands:

  a vector of the animals whose near relatives are kept, compared with
  `id` as text. An id with no row is ignored.

- maxDist:

  one finite number, 1 or more: the largest distance kept.

## Value

`ped` with only the rows kept, in their order and with their row names,
each column and its type unchanged, and `NA` for each `sire` or `dam`
left out; no rows when no proband has a row.

## Details

An animal's distance is `log2(1 / k)`, where `k` is its largest kinship
([`kinship`](https://rmsharp.github.io/pedkindraw/reference/kinship.md))
with a proband: 1 for a proband itself, 2 for a parent, offspring or
full sibling, 3 for a grandparent, grandoffspring, half sibling, uncle,
aunt, nephew or niece, 4 for a first cousin, and so on. Distance is read
from kinship, not counted in steps, so a double first cousin is at 3 and
an inbred animal can be at less than 1; an animal not related to any
proband has no distance and is kept only as a parent.

Every animal within `maxDist` is kept. So is each parent of a kept
animal whose own offspring and the offspring of its mates (with any
partner), counted once, number two or more; any other parent is left
out, and its id is set to `NA` in its offspring's row, as
[`removeAnimals`](https://rmsharp.github.io/pedkindraw/reference/removeAnimals.md)
does. On the pedigrees its tests compare, the animals kept are the ones
Pedixplorer 1.8.0's `useful_inds(max_dist = maxDist)` marks useful, with
the same informative animals.

Pedixplorer chooses its informative animals with `is_informative()`, by
default those both available and affected; pass those as `probands`, for
instance `ped$id[genotyped & ped$affected]`.

A pedigree from which kinship cannot be read is refused:
`getNearRelativePedigree()` stops, naming the animals, when
[`checkPedigree`](https://rmsharp.github.io/pedkindraw/reference/checkPedigree.md)
reports `missingIds`, `duplicateIds`, `ownParent`, `cycle`,
`rowlessParents`
([`addParents`](https://rmsharp.github.io/pedkindraw/reference/addParents.md)
adds a row for each such parent) or `missingParentCodes`. Sex is not
read, and one known parent is legal.

## See also

[`getProbandPedigree`](https://rmsharp.github.io/pedkindraw/reference/getProbandPedigree.md),
[`getDescendantPedigree`](https://rmsharp.github.io/pedkindraw/reference/getDescendantPedigree.md),
[`trimPedigree`](https://rmsharp.github.io/pedkindraw/reference/trimPedigree.md),
[`removeAnimals`](https://rmsharp.github.io/pedkindraw/reference/removeAnimals.md),
[`kinship`](https://rmsharp.github.io/pedkindraw/reference/kinship.md)

## Examples

``` r
## O is the proband. F and M are its parents, S its sister and K its
## offspring by Q. G1 and G2 are F's parents, U is F's brother and C is
## U's offspring by X. S has N by Y and N2 by Z.
ped <- data.frame(
  id = c("G1", "G2", "F", "U", "M", "X", "O", "S", "Q", "K", "Y", "Z",
         "N", "N2", "C"),
  sire = c(NA, NA, "G1", "G1", NA, NA, "F", "F", NA, "O", NA, NA, "Y",
           "Z", "U"),
  dam = c(NA, NA, "G2", "G2", NA, NA, "M", "M", NA, "Q", NA, NA, "S",
          "S", "X")
)
## Distance 1: O, and its parents F and M, who have two offspring.
near1 <- getNearRelativePedigree(ped, "O", 1)
near1$id
#> [1] "F" "M" "O"
## Distance 2: also S, K, G1 and G2. Q is left out (K is its only
## offspring and O has no other), so K's dam is NA.
near2 <- getNearRelativePedigree(ped, "O", 2)
near2[near2$id == "K", ]
#>    id sire  dam
#> 10  K    O <NA>
## Distance 3: also U, N and N2, and their sires Y and Z, each with one
## offspring by S, who has two.
near3 <- getNearRelativePedigree(ped, "O", 3)
near3$id
#>  [1] "G1" "G2" "F"  "U"  "M"  "O"  "S"  "K"  "Y"  "Z"  "N"  "N2"
```
