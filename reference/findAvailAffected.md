# Remove the one animal of an affected status that shrinks a pedigree most

One round of
[`shrinkPedigree`](https://rmsharp.github.io/pedkindraw/reference/shrinkPedigree.md)'s
third trim on the pedigree it is given. Among the genotyped animals that
are no animal's parent and whose `affected` status is `affstatus`, it
removes the one whose removal leaves the smallest bit size (see
[`bitSize`](https://rmsharp.github.io/pedkindraw/reference/bitSize.md)),
with any animal that removal leaves removable as in the first trim (see
[`findUnavailable`](https://rmsharp.github.io/pedkindraw/reference/findUnavailable.md)):
an ungenotyped parent left as a leaf, an ungenotyped founder couple left
with one child, a founder left with no offspring. Ties go to the first
`id` in byte order (capitals before lower case), whatever the computer's
language setting, as in
[`shrinkPedigree()`](https://rmsharp.github.io/pedkindraw/reference/shrinkPedigree.md);
kinship2 breaks ties at random.

## Usage

``` r
findAvailAffected(ped, genotyped, affected, affstatus)
```

## Arguments

- ped:

  a pedigree `data.frame` with the fields `id`, `sire` and `dam`, and
  optionally a logical `affected` column.

- genotyped:

  a logical vector, one value per row of `ped`, `TRUE` where the animal
  is genotyped (or otherwise available). `NA` is not allowed.

- affected:

  `NULL` or a logical vector, one value per row of `ped`. When `NULL`,
  `ped$affected` is used if it exists, and otherwise every animal counts
  as unaffected (`FALSE`).

- affstatus:

  the affected status of the animals to choose from: `NA`, `FALSE` or
  `TRUE`.

## Value

A list, with
[`kinship2::findAvailAffected()`](https://rdrr.io/pkg/kinship2/man/findAvailAffected.html)'s
names:

- ped:

  The pedigree after the removal, every column kept; `id`, `sire` and
  `dam` as character, and an animal made a founder has its `sire` and
  `dam` set to `NA`. When nothing is removed, `ped` with every row.

- idTrimmed:

  Character vector, every id removed, in the order removed;
  `character(0)` when none is.

- isTrimmed:

  `TRUE` when an animal was removed; `FALSE` when no genotyped
  non-parent has that status.

- bitSize:

  Integer, the bit size of the returned `ped`.

## Details

[`shrinkPedigree()`](https://rmsharp.github.io/pedkindraw/reference/shrinkPedigree.md)
tries an `NA` status first, then `FALSE`, then `TRUE`, and repeats until
the bit size is within its `maxBits`. Called the same way on the
pedigree its first two trims leave
(`shrinkPedigree(ped, genotyped, maxBits = Inf)$ped`), this function
makes the same removals.

It stops with
[`shrinkPedigree()`](https://rmsharp.github.io/pedkindraw/reference/shrinkPedigree.md)'s
message for a bad pedigree, or for a `genotyped` or `affected` vector of
the wrong length, or an `NA` in `genotyped`, and when `affstatus` is not
one of `NA`, `FALSE` and `TRUE`.

## References

Sinnwell JP, Therneau TM, Schaid DJ (2014). "The kinship2 R Package for
Pedigree Data." *Human Heredity*, 78(2), 91-93.

## See also

[`shrinkPedigree`](https://rmsharp.github.io/pedkindraw/reference/shrinkPedigree.md),
[`findUnavailable`](https://rmsharp.github.io/pedkindraw/reference/findUnavailable.md),
[`findAvailNonInform`](https://rmsharp.github.io/pedkindraw/reference/findAvailNonInform.md),
[`bitSize`](https://rmsharp.github.io/pedkindraw/reference/bitSize.md)

## Examples

``` r
## K and M are genotyped non-parents of unknown affected status. Removing K
## also removes its ungenotyped sire P and leaves its dam Q a founder with
## no offspring, so the bit size falls from 5 to 2; removing M leaves 3.
ped <- data.frame(
  id = c("GA", "GB", "P", "K", "Q", "L", "M"),
  sire = c(NA, NA, "GA", "P", NA, "GA", "GA"),
  dam = c(NA, NA, "GB", "Q", NA, "GB", "GB"),
  stringsAsFactors = FALSE
)
genotyped <- c(TRUE, TRUE, FALSE, TRUE, TRUE, TRUE, TRUE)
affected <- c(FALSE, FALSE, FALSE, NA, FALSE, TRUE, NA)
result <- findAvailAffected(ped, genotyped, affected, NA)
result$idTrimmed
#> [1] "K" "P" "Q"
result$bitSize
#> [1] 2
```
