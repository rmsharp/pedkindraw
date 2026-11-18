# Check whether an animal has both parents

Check whether an animal has both parents

## Usage

``` r
hasBothParents(ped, id)
```

## Arguments

- ped:

  The pedigree information in data.frame format

- id:

  a single ID to examine for parents. A vector of IDs is not supported:
  the result is not one value per ID, and a recycling warning appears
  only when the number of IDs does not divide the number of rows of
  `ped`.

## Value

TRUE if ID has both sire and dam identified in `ped`, FALSE if one or
both are unknown, and `logical(0)` if `id` is not in `ped`.

## Examples

``` r
ped <- data.frame(
  id = c("s1", "d1", "s2", "d2", "o1", "o2", "o3", "o4"),
  sire = c(NA, NA, NA, NA, "s1", "s1", "s2", "s2"),
  dam = c(NA, NA, NA, NA, "d1", "d2", "d2", "d2"),
  stringsAsFactors = FALSE
)
hasBothParents(ped, "o2")
#> [1] TRUE
ped$sire[ped$id == "o2"] <- NA
hasBothParents(ped, "o2")
#> [1] FALSE
```
