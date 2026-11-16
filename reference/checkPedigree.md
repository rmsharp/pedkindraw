# Check a pedigree for problems

Lists each problem found in a pedigree, one row per problem id, and
changes nothing. Repairing a problem is left to the user:
[`addParents`](https://rmsharp.github.io/pedkindraw/reference/addParents.md)
adds a row for each parent that has none, and
[`correctParentSex`](https://rmsharp.github.io/pedkindraw/reference/correctParentSex.md)
sets the sex of a male dam or a female sire.

## Usage

``` r
checkPedigree(ped)
```

## Arguments

- ped:

  a data frame with the columns `id`, `sire` and `dam` (an unknown
  parent is `NA`) and optionally `sex` (`M`, `F`, `H` or `U`). Factor
  columns are read by their labels and numbers as text; other columns
  are not read.

## Value

A data frame with the character columns `check` (the name of the check),
`id` (the animal, parent id or code the problem is about) and `detail`
(what was found), one row per problem id; zero rows when no problem is
found.

## Details

The checks, in the order their rows come:

- `missingIds`:

  an id that is `NA`, empty or spaces only; one row per such row of
  `ped`, in row order.

- `duplicateIds`:

  an id on more than one row.

- `ownParent`:

  an animal that is its own sire or dam.

- `cycle`:

  an animal that is its own ancestor through at least one other animal;
  `detail` names the other animals that are both its ancestors and its
  descendants.

- `rowlessParents`:

  a sire or dam that has no row of its own.

- `missingParentCodes`:

  `"0"`, `"NA"`, or an empty or spaces-only value used for an unknown
  parent, which should be `NA`. Such a value that is also the id of a
  row is a real parent.

- `maleDams`:

  a dam whose sex is `M`.

- `femaleSires`:

  a sire whose sex is `F`.

- `unknownSexParents`:

  a sire or dam whose sex is `U` or `NA`.

- `sireAndDam`:

  one id used both as a sire and as a dam.

- `sexCodes`:

  a sex other than `M`, `F`, `H`, `U` or `NA`, such as `"male"`; one row
  per such row of `ped`, in row order. Such an animal gets no other sex
  check.

Within a check the ids come in byte order (capitals before lower case),
except where row order is stated. An animal can appear under several
checks. A parent's sex is the sex on its first row, and the four sex
checks run only when `ped` has a `sex` column. For a parent, `detail`
lists its offspring, ten at most and then a count ("sire of B, C; dam of
D").

Not reported, because they are legal here: one known parent, an animal
of unknown sex that is no parent, a hermaphrodite (`H`), and number ids.

On the seeded random pedigrees its tests compare with kinship2 1.9.6.2's
`pedigree()`, it names the problem wherever kinship2 refuses the
pedigree, and none of the problems kinship2 refuses wherever kinship2
accepts it; cases with one known parent, a hermaphrodite parent or a sex
other than `M`, `F`, `H` and `U` are set aside. In the cases measured
before it was written, kinship2 accepted cycles, an animal that is its
own parent and `""` for an unknown parent, which are reported here, and
refused one known parent and a hermaphrodite parent, which are not.

## See also

[`addParents`](https://rmsharp.github.io/pedkindraw/reference/addParents.md),
[`correctParentSex`](https://rmsharp.github.io/pedkindraw/reference/correctParentSex.md)

## Examples

``` r
ped <- data.frame(
  id = c("s1", "d1", "o1", "o2", "o2"),
  sire = c(NA, NA, "s1", "s9", "s1"),
  dam = c(NA, "0", "d1", "d1", "d1"),
  sex = c("F", "F", "M", "F", "F")
)
checkPedigree(ped)
#>                check id         detail
#> 1       duplicateIds o2      rows 4, 5
#> 2     rowlessParents s9     sire of o2
#> 3 missingParentCodes  0      dam of d1
#> 4        femaleSires s1 sire of o1, o2
## A pedigree without problems gives zero rows.
checkPedigree(data.frame(id = c("s", "d", "o"), sire = c(NA, NA, "s"),
                         dam = c(NA, NA, "d")))
#> [1] check  id     detail
#> <0 rows> (or 0-length row.names)
```
