# Rewrite other codes for unknown parents and sex into pedkindraw's

Pedigrees written by other tools often give an unknown parent as `0` or
leave it empty, and a sex as `1` and `2` or as a word.
`recodePedigree()` rewrites these into the codes the rest of the package
reads: `NA` for an unknown parent, and `"M"`, `"F"`, `"H"` and `"U"` for
male, female, hermaphrodite and unknown sex. It changes nothing else,
and a pedigree already written in these codes comes back as it was.

## Usage

``` r
recodePedigree(ped, missingParentCodes = c("0", "NA", ""))
```

## Arguments

- ped:

  a data frame with the columns `id`, `sire` and `dam`, and optionally
  `sex`. Factor columns are read by their labels and numbers as text.

- missingParentCodes:

  a character vector of the values that mean an unknown parent, compared
  with `sire` and `dam` as text; by default `"0"`, `"NA"` and `""`
  (empty or spaces only), the codes
  [`checkPedigree`](https://rmsharp.github.io/pedkindraw/reference/checkPedigree.md)
  reports. `character(0)` leaves the parents as they are.

## Value

`ped`, with each unknown parent written `NA` and each sex written `"M"`,
`"F"`, `"H"` or `"U"` where it was written another way; its other
columns, rows and ids unchanged.

## Details

- Parents:

  In `sire` and `dam`, each value named in `missingParentCodes` becomes
  `NA`; `""` there stands for an empty or spaces-only value. A value
  that is also the id of a row is a real parent and is kept, as
  [`checkPedigree`](https://rmsharp.github.io/pedkindraw/reference/checkPedigree.md)
  reads it. Each column keeps its type, so number ids stay numbers.

- Sex:

  When `ped` has a `sex` column, it is returned as text, or as a factor
  when it is one (its levels rewritten, and levels that become one code
  merged). Case and spaces around a value are ignored: `"M"`, `"male"`
  and `1` become `"M"`; `"F"`, `"female"` and `2` become `"F"`; `"H"`
  and `"hermaphrodite"` become `"H"`; `"U"`, `"unknown"`, `3` and `4`
  become `"U"`. An empty or spaces-only value becomes `NA`, an
  unrecorded sex, and `NA` stays `NA`. Any other value, such as
  `"mael"`, is left as written, so
  [`checkPedigree`](https://rmsharp.github.io/pedkindraw/reference/checkPedigree.md)
  still reports it.

The numbers 1 and 2 are read as nprcgenekeepr's `convertSexCodes()`,
kinship2's `pedigree()` and Pedixplorer read them, and 3 and 4 as
`convertSexCodes()` reads them by default (kinship2 reads 4 as a
terminated pregnancy, which
[`asPedFrame`](https://rmsharp.github.io/pedkindraw/reference/asPedFrame.md)
also writes as `"U"`). Unlike `convertSexCodes()`, `recodePedigree()`
keeps `"H"`, `NA` and any value it does not know.

## See also

[`checkPedigree`](https://rmsharp.github.io/pedkindraw/reference/checkPedigree.md),
[`asPedFrame`](https://rmsharp.github.io/pedkindraw/reference/asPedFrame.md)

## Examples

``` r
## A pedigree written as kinship2's sample data write theirs.
ped <- data.frame(
  id = c("A", "B", "C", "D"),
  sire = c("0", "0", "A", "A"),
  dam = c("0", "0", "B", "B"),
  sex = c("male", "female", "1", "2")
)
checkPedigree(ped)
#>                check id                    detail
#> 1 missingParentCodes  0 sire of A, B; dam of A, B
#> 2           sexCodes  A       sex "male" in row 1
#> 3           sexCodes  B     sex "female" in row 2
#> 4           sexCodes  C          sex "1" in row 3
#> 5           sexCodes  D          sex "2" in row 4
recoded <- recodePedigree(ped)
recoded
#>   id sire  dam sex
#> 1  A <NA> <NA>   M
#> 2  B <NA> <NA>   F
#> 3  C    A    B   M
#> 4  D    A    B   F
checkPedigree(recoded)
#> [1] check  id     detail
#> <0 rows> (or 0-length row.names)
findGeneration(recoded$id, recoded$sire, recoded$dam)
#> [1] 0 0 1 1
```
