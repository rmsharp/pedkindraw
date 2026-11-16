# Get parents to corresponding animal IDs provided

Get parents to corresponding animal IDs provided

## Usage

``` r
getParents(pedSourceDf, ids)
```

## Arguments

- pedSourceDf:

  dataframe with pedigree structure having at least the columns id,
  sire, and dam. The pedigree is the first argument, unlike
  [`getProbandPedigree()`](https://rmsharp.github.io/pedkindraw/reference/getProbandPedigree.md)
  and
  [`getDescendantPedigree()`](https://rmsharp.github.io/pedkindraw/reference/getDescendantPedigree.md),
  which take the animal ids first.

- ids:

  character vector of animal IDs

## Value

A character vector with the IDs of the parents of the provided ID list.

## Examples

``` r
ped <- data.frame(
  id = c("A", "B", "C", "D", "E", "F", "G"),
  sire = c(NA, NA, "A", "A", NA, "D", "D"),
  dam = c(NA, NA, "B", "B", NA, "E", "E"),
  stringsAsFactors = FALSE
)
getParents(ped, c("C", "F"))
#> [1] "A" "D" "B" "E"
```
