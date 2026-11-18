# Get offspring to corresponding animal IDs provided

Get offspring to corresponding animal IDs provided

## Usage

``` r
getOffspring(ped, ids)
```

## Arguments

- ped:

  dataframe with pedigree structure having at least the columns id,
  sire, and dam.

- ids:

  character vector of animal IDs

## Value

A character vector containing all of the offspring IDs for all of the
IDs provided in the second argument `ids`. All offspring are combined
and duplicates are removed.

## Examples

``` r
ped <- data.frame(
  id = c("A", "B", "C", "D", "E", "F", "G"),
  sire = c(NA, NA, "A", "A", NA, "D", "D"),
  dam = c(NA, NA, "B", "B", NA, "E", "E"),
  stringsAsFactors = FALSE
)
getOffspring(ped, c("A", "E"))
#> [1] "C" "D" "F" "G"
```
