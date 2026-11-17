# Add back second parents to a trimmed pedigree

Uses the `ped` dataframe, which has full complement of parents and the
`trimmedPed` dataframe, which has all uninformative parents removed to
add back single parents to the `trimmedPed` dataframe where one parent
is known. The parents are added back to the pedigree as an ID record
with NA for both sire and dam of the added back ID.

## Usage

``` r
addBackSecondParents(trimmedPed, ped)
```

## Arguments

- trimmedPed:

  a trimmed pedigree dataframe with uninformative founders removed.

- ped:

  the full (untrimmed) pedigree dataframe, from which the second parents
  are taken.

## Value

A pedigree with single parents added. It is a `data.table` once any
record is added and a plain dataframe when none is.

## Examples

``` r
ped <- data.frame(
  id = c("A", "B", "C", "D", "E", "F", "G"),
  sire = c(NA, NA, NA, "A", "A", "D", "D"),
  dam = c(NA, NA, NA, "B", "C", "E", "E"),
  stringsAsFactors = FALSE
)
## Removing the uninformative founders B and C leaves D and E with
## one known parent each; adding back the second parents restores
## B and C as founders
p <- removeUninformativeFounders(ped)
nrow(p)
#> [1] 5
p <- addBackSecondParents(p, ped)
nrow(p)
#> [1] 7
```
