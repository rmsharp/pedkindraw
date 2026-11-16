# Remove uninformative founders

Founders (having unknown sire and dam) that appear only one time in a
pedigree are uninformative and can be removed from a pedigree without
loss of information. Removal repeats until no such founder remains,
because removing one can leave another founder appearing only once.

## Usage

``` r
removeUninformativeFounders(ped)
```

## Arguments

- ped:

  dataframe that is the `Pedigree`. The `id`, `sire` and `dam` columns
  are required.

## Value

A reduced pedigree.

## Examples

``` r
ped <- data.frame(
  id = c("A", "B", "C", "D", "E", "F", "G"),
  sire = c(NA, NA, NA, "A", "A", "D", "D"),
  dam = c(NA, NA, NA, "B", "C", "E", "E"),
  stringsAsFactors = FALSE
)
## B and C are founders that appear only once, so they are removed;
## A is the sire of two animals and stays
p <- removeUninformativeFounders(ped)
nrow(ped)
#> [1] 7
nrow(p)
#> [1] 5
```
