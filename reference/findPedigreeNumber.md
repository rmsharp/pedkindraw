# Determine the pedigree number for each ID

One of Pedigree Curation functions

## Usage

``` r
findPedigreeNumber(id, sire, dam)
```

## Arguments

- id:

  character vector with unique identifier for an individual

- sire:

  character vector with unique identifier for an individual's father
  (`NA` if unknown).

- dam:

  character vector with unique identifier for an individual's mother
  (`NA` if unknown).

## Value

Integer vector indicating the pedigree (family group) number for each
id. Ids that are connected through parent-offspring links share the same
number; numbering starts at 1. Numbering starts from ids with both
parents unknown (`NA`), so an id that cannot be reached from such an id,
for example one whose only parent is absent from `id`, or one in a
cycle, is returned as `NA`.

## Examples

``` r
## Two unrelated families: A and B are the parents of C, D and E of F.
ped <- data.frame(
  id = c("A", "B", "C", "D", "E", "F"),
  sire = c(NA, NA, "A", NA, NA, "D"),
  dam = c(NA, NA, "B", NA, NA, "E"),
  stringsAsFactors = FALSE
)
ped$pedigree <- findPedigreeNumber(ped$id, ped$sire, ped$dam)
ped$pedigree
#> [1] 1 1 1 2 2 2
```
