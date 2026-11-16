# Get ids of animals with only one parent

Get ids of animals with only one parent

## Usage

``` r
getIdsWithOneParent(uPed)
```

## Arguments

- uPed:

  a trimmed pedigree dataframe with uninformative founders removed.

## Value

Character vector of the IDs of animals with exactly one known parent.

## Examples

``` r
ped <- data.frame(
  id = c("A", "B", "C", "D", "E", "F", "G"),
  sire = c(NA, NA, NA, "A", "A", "D", "D"),
  dam = c(NA, NA, NA, "B", "C", "E", "E"),
  stringsAsFactors = FALSE
)
## B and C are founders that appear only once (uninformative), so
## removing them leaves D and E with one known parent each
p <- removeUninformativeFounders(ped)
p
#>   id sire  dam
#> 1  A <NA> <NA>
#> 4  D    A <NA>
#> 5  E    A <NA>
#> 6  F    D    E
#> 7  G    D    E
getIdsWithOneParent(p)
#> [1] "D" "E"
```
