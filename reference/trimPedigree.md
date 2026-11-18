# Trim a pedigree to a group's ancestors

Filters a pedigree down to the provided group (the probands) and all of
their ancestors, removing unnecessary individuals from the studbook. By
default only that filtering is done. Uninformative founders are removed
only when `removeUninformative = TRUE`, and single parents are added
back only when both `removeUninformative` and `addBackParents` are
`TRUE`.

## Usage

``` r
trimPedigree(
  ped,
  probands,
  removeUninformative = FALSE,
  addBackParents = FALSE
)
```

## Arguments

- ped:

  datatable that is the `Pedigree`. It contains pedigree information.
  The fields `id`, `sire` and `dam` are required.

- probands:

  a character vector with the list of animals whose ancestors should be
  included in the final pedigree.

- removeUninformative:

  logical defaults to `FALSE`. If set to `TRUE`, uninformative founders
  are removed.

  Founders (having unknown sire and dam) that appear only one time in a
  pedigree are uninformative and can be removed from a pedigree without
  loss of information.

- addBackParents:

  logical defaults to `FALSE`. If set to `TRUE`, the function adds back
  single parents to the `p` dataframe when one parent is known. It is
  ignored unless `removeUninformative = TRUE`. The function
  `addBackSecondParents` uses the `ped` dataframe, which has full
  complement of parents and the `p` dataframe, which has all
  uninformative parents removed to add back single parents to the `p`
  dataframe.

## Value

A pedigree containing the probands and all of their ancestors.
Uninformative founders are removed only when `removeUninformative` is
`TRUE`, and single parents are added back only when `addBackParents` is
also `TRUE`.

## Examples

``` r
ped <- data.frame(
  id = c("A", "B", "C", "D", "E", "F", "G", "H"),
  sire = c(NA, NA, NA, "A", "A", "D", "D", NA),
  dam = c(NA, NA, NA, "B", "C", "E", "E", NA),
  stringsAsFactors = FALSE
)
## F and G and their ancestors; H is not one of them
trimmedPed <- trimPedigree(ped, c("F", "G"))
trimmedPedInformative <- trimPedigree(ped, c("F", "G"),
  removeUninformative = TRUE
)
nrow(ped)
#> [1] 8
nrow(trimmedPed)
#> [1] 7
nrow(trimmedPedInformative)
#> [1] 5
```
