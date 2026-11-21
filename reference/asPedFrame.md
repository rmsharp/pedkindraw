# Convert a kinship2 or Pedixplorer pedigree object to the package's data frames

Turns a kinship2 `pedigree` or `pedigreeList` object, or a Pedixplorer
`Pedigree` object, back into the data frames the rest of the package
takes: a pedigree with one row per animal, a table of twin pairs and a
table of declared matings; and its layout hints into the form
[`makePedigreeMatingLayout()`](https://rmsharp.github.io/pedkindraw/reference/makePedigreeMatingLayout.md)
takes.

## Usage

``` r
asPedFrame(x, ...)

# Default S3 method
asPedFrame(x, ...)

# S3 method for class 'pedigree'
asPedFrame(x, ...)

# S3 method for class 'pedigreeList'
asPedFrame(x, ...)

# S3 method for class 'Pedigree'
asPedFrame(x, ...)
```

## Arguments

- x:

  a kinship2 `pedigree` or `pedigreeList` object, or a Pedixplorer
  `Pedigree` object.

- ...:

  not used.

## Value

A list of four:

- `ped`:

  a data frame with the character columns `id`, `sire`, `dam` (an
  unknown parent is `NA`) and `sex`; then `famid` for a `pedigreeList`
  or a `Pedigree` with families; then the condition columns; then
  `status`; and, for a `Pedigree`, Pedixplorer's fields that hold data
  and the object's other columns.

- `twinRelations`:

  a data frame with the character columns `id1`, `id2` and `code`
  (`"MZ twin"`, `"DZ twin"` or `"UZ twin"`), or `NULL` when the object
  has no twin pair.

- `hints`:

  the object's layout hints as a list of `order` (numbers named by id)
  and `mate` (a data frame of `left`, `right` and `anchor`), each only
  when the object holds it, or `NULL` when it holds none.

- `matings`:

  a data frame with the character columns `sire` and `dam`, one row per
  spouse pair the object holds, or `NULL` when it holds none.

## Details

**kinship2 objects.** The rows keep the object's order, which is the
order the animals were given to
[`kinship2::pedigree()`](https://rdrr.io/pkg/kinship2/man/pedigree.html).
Each parent is read by its own index, so an unknown parent (index 0)
never moves another animal's parent. Ids become text: a factor's labels,
and whole numbers written in full (`"100000"`, not `"1e+05"`), so no id
is renamed.

Sex becomes `M`, `F` or `U`: male, female, and unknown or terminated.
kinship2 has no code for a hermaphrodite, so an animal entered as `H`
comes back `U`. A single `affected` vector becomes the column
`affected`; the columns of an `affected` matrix become
`affected_<column name>`, or `affected_1`, `affected_2` and so on when
the matrix has no column names. Their values stay as kinship2 holds
them: 0, 1 or `NA`. A `status` of 1 becomes `"DECEASED"` and 0
`"ALIVE"`. An object with no `affected` or no `status` gives no such
column. kinship2 keeps no other column, so names, dates and the like are
not in its objects to convert.

Twin pairs come from the object's `relation` codes 1, 2 and 3 (MZ, DZ
and UZ twins), and declared matings from its code 4, a spouse pair,
whether kinship2 stored them as numbers or as text.

A `pedigreeList` (several families) is converted whole when no id
appears in two families, with a `famid` column naming each animal's
family. When ids repeat across families, `asPedFrame()` stops and names
them (ten at most, in byte order); one family, such as `x["2"]`, is a
`pedigree` and converts on its own.

A kinship2 object is a plain list, so it is read without calling
kinship2: kinship2 need not be installed, for an object read back from a
file for instance. `asPedFrame()` stops for a `pedigree` or
`pedigreeList` that lacks a part it needs (`id`, `findex`, `mindex`,
`sex`, and `famid` for a `pedigreeList`), naming the parts.

**Pedixplorer objects.** A `Pedigree` is read through Pedixplorer's own
functions, so Pedixplorer must be installed; `asPedFrame()` stops,
saying so, when it is not. The rows keep the object's order. Ids and
parents are as the object holds them: when it has families, Pedixplorer
has joined each id to its family (`"F1_A"`), and a `famid` column names
each animal's family. Sex becomes `M`, `F` or `U` (Pedixplorer, too,
holds a hermaphrodite as unknown).

Each condition Pedixplorer holds (one row of `fill(x)` and its
`<name>_mods` column) becomes a column with 0, 1 or `NA`: Pedixplorer's
default condition `affection`, the name it gives a column `affected`,
becomes `affected`; a condition whose name starts with `affected` keeps
it; any other becomes `affected_<name>`. A condition with no known value
is left out: an object built with no condition still holds an all-`NA`
`affection`, and that is not a condition. The death status becomes
`status`: `"DECEASED"`, `"ALIVE"`, or `NA` where it is unknown, with no
column when every value is unknown.

Then come those of Pedixplorer's fields `fertility`, `miscarriage`,
`avail`, `evaluated`, `consultand`, `proband`, `carrier`,
`asymptomatic`, `adopted`, `dateofbirth` and `dateofdeath` that hold
anything besides the value Pedixplorer fills in when none is given,
under their own names and types (Pedixplorer keeps a `birth` column it
is given as `dateofbirth`, as text). Last come the object's other
columns, of its `mcols()`, as they are, less Pedixplorer's own (`error`,
and each condition's and the availability's columns). `asPedFrame()`
stops when a column name would appear twice (an extra column called
`sire`, say), naming it. Twin pairs are the MZ, DZ and UZ twins of
`rel(x)`, and declared matings its `"Spouse"` rows.

**Declared matings.** Each spouse pair of either package becomes a row
of `matings`, a data frame of `sire` and `dam` in the form
[`makePedigreeMatingLayout`](https://rmsharp.github.io/pedkindraw/reference/makePedigreeMatingLayout.md)`(matings = )`
and
[`getMatings`](https://rmsharp.github.io/pedkindraw/reference/getMatings.md)`(matings = )`
take: two animals mated, whether or not they have offspring together.
Every row the object holds is kept, in the object's order, a pair with
offspring together (which the layout and
[`getMatings()`](https://rmsharp.github.io/pedkindraw/reference/getMatings.md)
set aside) and a pair kinship2 holds twice (Pedixplorer refuses one)
included, so a table converted to either package and back is the same.
When one of the two is male and the other not, the male is the sire;
otherwise, when one is female and the other not, the female is the dam;
otherwise the two are in the order the object holds them, which for
Pedixplorer is sorted by id.

**Layout hints.** An object's layout hints come back in the form
[`makePedigreeMatingLayout()`](https://rmsharp.github.io/pedkindraw/reference/makePedigreeMatingLayout.md)
takes, so
`makePedigreeMatingLayout(x$ped, hints = x$hints, matings = x$matings)`
draws with them and with the object's matings, once `x$ped` has its
generations
([`findGeneration()`](https://rmsharp.github.io/pedkindraw/reference/findGeneration.md)).
kinship2 keeps them in the object's `hints` element, which a user sets,
to
[`kinship2::autohint()`](https://rdrr.io/pkg/kinship2/man/autohint.html)'s
result for instance: its `order`, one number per animal in the object's
order, becomes `order`, the numbers named by id (an `NA` leaves that
animal unnumbered); its `spouse` rows (the places of the left and the
right animal and an anchor, 1 left, 2 right, 0 either) become `mate`, a
data frame of the ids `left` and `right` and the `anchor` `"left"`,
`"right"` or `"either"`. A `pedigreeList`'s hints are read the same way,
one number per animal of the whole list. `asPedFrame()` stops, saying
what is wrong, when they cannot be read as ids: hints that are not a
list, an order that is not numbers or not one per animal, or a `spouse`
table that is not three columns of whole numbers, places from 1 to the
number of animals and an anchor 1, 2 or 0. Pedixplorer keeps them in the
object's hints, `horder()` (already named by id) and `spouse()`, read
the same way.

Both packages make their automatic hints for their own layouts, and some
of the mate rows are ones
[`makePedigreeMatingLayout()`](https://rmsharp.github.io/pedkindraw/reference/makePedigreeMatingLayout.md)
refuses. `asPedFrame()` fixes them and one message names each change: a
pair with no offspring together that the object does not declare mated
is left out (the layout draws a mating only from offspring or from
`matings`); a pair named in an earlier row is left out, the first row
kept (as kinship2 keeps it); and an anchor on the partner of the earlier
generation
([`findGeneration()`](https://rmsharp.github.io/pedkindraw/reference/findGeneration.md))
becomes `"either"`, its side kept, since the layout draws a mating on
the row of its later partner.

`asPedFrame()` stops for an object of any other class, naming the class.

## See also

[`checkPedigree`](https://rmsharp.github.io/pedkindraw/reference/checkPedigree.md),
[`checkTwinRelations`](https://rmsharp.github.io/pedkindraw/reference/checkTwinRelations.md),
[`drawPedigreeDiagram`](https://rmsharp.github.io/pedkindraw/reference/drawPedigreeDiagram.md)

## Examples

``` r
if (requireNamespace("kinship2", quietly = TRUE)) {
  ## A and B are the parents of C and D, DZ twins; A has died and C is
  ## affected.
  p <- kinship2::pedigree(
    id = c("A", "B", "C", "D"),
    dadid = c(NA, NA, "A", "A"),
    momid = c(NA, NA, "B", "B"),
    sex = c("male", "female", "male", "female"),
    affected = c(0, 0, 1, 0),
    status = c(1, 0, 0, 0),
    relation = data.frame(id1 = "C", id2 = "D", code = 2)
  )
  asPedFrame(p)
  ## A layout hint: D drawn left of C.
  p$hints <- list(order = c(1, 2, 4, 3))
  asPedFrame(p)$hints
  ## E and F, with no offspring, declared mates (relation code 4): F, the
  ## male, is the sire.
  p <- kinship2::pedigree(
    id = c("A", "B", "C", "E", "F"),
    dadid = c(NA, NA, "A", NA, NA),
    momid = c(NA, NA, "B", NA, NA),
    sex = c("male", "female", "male", "female", "male"),
    relation = data.frame(id1 = "E", id2 = "F", code = 4)
  )
  asPedFrame(p)$matings
}
#>   sire dam
#> 1    F   E
if (requireNamespace("Pedixplorer", quietly = TRUE)) {
  ## The same family as a Pedixplorer object, with a name for each animal.
  p <- Pedixplorer::Pedigree(data.frame(
    id = c("A", "B", "C", "D"),
    dadid = c(NA, NA, "A", "A"),
    momid = c(NA, NA, "B", "B"),
    sex = c("male", "female", "male", "female"),
    affected = c(0, 0, 1, 0),
    status = c(1, 0, 0, 0),
    name = c("Al", "Bea", "Cy", "Di")
  ), rel_df = data.frame(id1 = "C", id2 = "D", code = 2))
  asPedFrame(p)
}
#> $ped
#>   id sire  dam sex affected   status name
#> 1  A <NA> <NA>   M        0 DECEASED   Al
#> 2  B <NA> <NA>   F        0    ALIVE  Bea
#> 3  C    A    B   M        1    ALIVE   Cy
#> 4  D    A    B   F        0    ALIVE   Di
#> 
#> $twinRelations
#>   id1 id2    code
#> 1   C   D DZ twin
#> 
#> $hints
#> NULL
#> 
#> $matings
#> NULL
#> 
```
