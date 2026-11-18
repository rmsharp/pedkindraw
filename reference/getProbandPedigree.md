# Reduce a pedigree to probands and their ancestors

Filters a pedigree down to the provided group (the probands) together
with all of their ancestors, removing unnecessary individuals from the
studbook. This version builds the pedigree back in time starting from a
group of probands. This will include all ancestors of the probands, even
ones that might be uninformative.

## Usage

``` r
getProbandPedigree(ped, probands)
```

## Arguments

- ped:

  datatable that is the `Pedigree`. It contains pedigree information.
  The fields `id`, `sire` and `dam` are required.

- probands:

  a character vector with the list of animals whose ancestors should be
  included in the final pedigree.

## Value

A reduced pedigree.

## Examples

``` r
ped <- data.frame(
  id = c("A", "B", "C", "D", "E", "F", "G"),
  sire = c(NA, NA, "A", "A", NA, "D", "D"),
  dam = c(NA, NA, "B", "B", NA, "E", "E"),
  stringsAsFactors = FALSE
)
## F's ancestors are its parents D and E and D's parents A and B
getProbandPedigree(probands = "F", ped = ped)$id
#> [1] "A" "B" "D" "E" "F"
```
