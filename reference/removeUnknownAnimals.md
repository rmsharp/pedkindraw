# Remove placeholder animals added for unknown parents

Remove placeholder animals added for unknown parents

## Usage

``` r
removeUnknownAnimals(ped)
```

## Arguments

- ped:

  The pedigree information in data.frame format

## Value

Pedigree with the animals whose `recordStatus` is `"added"` removed.
Every other animal is kept, including one whose `recordStatus` is
missing (`NA`) or has any other value. A pedigree without a
`recordStatus` column has no animals marked as added, so it is returned
unchanged.

## Examples

``` r
ped <- data.frame(
  id = c("o1", "o2"),
  sire = c("s1", "s1"),
  dam = c("d1", "d1"),
  sex = c("F", "M"),
  stringsAsFactors = FALSE
)
## addParents() adds records for the parents s1 and d1, marked "added"
withParents <- addParents(ped)
withParents
#>   id sire  dam sex recordStatus
#> 1 o1   s1   d1   F     original
#> 2 o2   s1   d1   M     original
#> 3 s1 <NA> <NA>   M        added
#> 4 d1 <NA> <NA>   F        added
removeUnknownAnimals(withParents)
#>   id sire dam sex recordStatus
#> 1 o1   s1  d1   F     original
#> 2 o2   s1  d1   M     original
```
