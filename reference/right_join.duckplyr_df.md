# Right join

This is a method for the
[`dplyr::right_join()`](https://dplyr.tidyverse.org/reference/mutate-joins.html)
generic. See "Fallbacks" section for differences in implementation. A
[`right_join()`](https://dplyr.tidyverse.org/reference/mutate-joins.html)
keeps all observations in `y`.

## Usage

``` r
# S3 method for class 'duckplyr_df'
right_join(
  x,
  y,
  by = NULL,
  copy = FALSE,
  suffix = c(".x", ".y"),
  ...,
  keep = NULL,
  na_matches = c("na", "never"),
  multiple = "all",
  unmatched = "drop",
  relationship = NULL
)
```

## Arguments

- x, y:

  A pair of data frames, data frame extensions (e.g. a tibble), or lazy
  data frames (e.g. from dbplyr or dtplyr). See *Methods*, below, for
  more details.

- by:

  A join specification created with
  [`join_by()`](https://dplyr.tidyverse.org/reference/join_by.html), or
  a character vector of variables to join by.

  If `NULL`, the default, `*_join()` will perform a natural join, using
  all variables in common across `x` and `y`. A message lists the
  variables so that you can check they're correct; suppress the message
  by supplying `by` explicitly.

  To join on different variables between `x` and `y`, use a
  [`join_by()`](https://dplyr.tidyverse.org/reference/join_by.html)
  specification. For example, `join_by(a == b)` will match `x$a` to
  `y$b`.

  To join by multiple variables, use a
  [`join_by()`](https://dplyr.tidyverse.org/reference/join_by.html)
  specification with multiple expressions. For example,
  `join_by(a == b, c == d)` will match `x$a` to `y$b` and `x$c` to
  `y$d`. If the column names are the same between `x` and `y`, you can
  shorten this by listing only the variable names, like `join_by(a, c)`.

  [`join_by()`](https://dplyr.tidyverse.org/reference/join_by.html) can
  also be used to perform inequality, rolling, and overlap joins. See
  the documentation at
  [?join_by](https://dplyr.tidyverse.org/reference/join_by.html) for
  details on these types of joins.

  For simple equality joins, you can alternatively specify a character
  vector of variable names to join by. For example, `by = c("a", "b")`
  joins `x$a` to `y$a` and `x$b` to `y$b`. If variable names differ
  between `x` and `y`, use a named character vector like
  `by = c("x_a" = "y_a", "x_b" = "y_b")`.

  To perform a cross-join, generating all combinations of `x` and `y`,
  see
  [`cross_join()`](https://dplyr.tidyverse.org/reference/cross_join.html).

- copy:

  If `x` and `y` are not from the same data source, and `copy` is
  `TRUE`, then `y` will be copied into the same src as `x`. This allows
  you to join tables across srcs, but it is a potentially expensive
  operation so you must opt into it.

- suffix:

  If there are non-joined duplicate variables in `x` and `y`, these
  suffixes will be added to the output to disambiguate them. Should be a
  character vector of length 2.

- ...:

  Other parameters passed onto methods.

- keep:

  Should the join keys from both `x` and `y` be preserved in the output?

  - If `NULL`, the default, joins on equality retain only the keys from
    `x`, while joins on inequality retain the keys from both inputs.

  - If `TRUE`, all keys from both inputs are retained.

  - If `FALSE`, only keys from `x` are retained. For right and full
    joins, the data in key columns corresponding to rows that only exist
    in `y` are merged into the key columns from `x`. Can't be used when
    joining on inequality conditions.

- na_matches:

  Should two `NA` or two `NaN` values match?

  - `"na"`, the default, treats two `NA` or two `NaN` values as equal,
    like `%in%`, [`match()`](https://rdrr.io/r/base/match.html), and
    [`merge()`](https://rdrr.io/r/base/merge.html).

  - `"never"` treats two `NA` or two `NaN` values as different, and will
    never match them together or to any other values. This is similar to
    joins for database sources and to `base::merge(incomparables = NA)`.

- multiple:

  Handling of rows in `x` with multiple matches in `y`. For each row of
  `x`:

  - `"all"`, the default, returns every match detected in `y`. This is
    the same behavior as SQL.

  - `"any"` returns one match detected in `y`, with no guarantees on
    which match will be returned. It is often faster than `"first"` and
    `"last"` if you just need to detect if there is at least one match.

  - `"first"` returns the first match detected in `y`.

  - `"last"` returns the last match detected in `y`.

- unmatched:

  How should unmatched keys that would result in dropped rows be
  handled?

  - `"drop"` drops unmatched keys from the result.

  - `"error"` throws an error if unmatched keys are detected.

  `unmatched` is intended to protect you from accidentally dropping rows
  during a join. It only checks for unmatched keys in the input that
  could potentially drop rows.

  - For left joins, it checks `y`.

  - For right joins, it checks `x`.

  - For inner joins, it checks both `x` and `y`. In this case,
    `unmatched` is also allowed to be a character vector of length 2 to
    specify the behavior for `x` and `y` independently.

- relationship:

  Handling of the expected relationship between the keys of `x` and `y`.
  If the expectations chosen from the list below are invalidated, an
  error is thrown.

  - `NULL`, the default, doesn't expect there to be any relationship
    between `x` and `y`. However, for equality joins it will check for a
    many-to-many relationship (which is typically unexpected) and will
    warn if one occurs, encouraging you to either take a closer look at
    your inputs or make this relationship explicit by specifying
    `"many-to-many"`.

    See the *Many-to-many relationships* section for more details.

  - `"one-to-one"` expects:

    - Each row in `x` matches at most 1 row in `y`.

    - Each row in `y` matches at most 1 row in `x`.

  - `"one-to-many"` expects:

    - Each row in `y` matches at most 1 row in `x`.

  - `"many-to-one"` expects:

    - Each row in `x` matches at most 1 row in `y`.

  - `"many-to-many"` doesn't perform any relationship checks, but is
    provided to allow you to be explicit about this relationship if you
    know it exists.

  `relationship` doesn't handle cases where there are zero matches. For
  that, see `unmatched`.

## Fallbacks

There is no DuckDB translation in `right_join.duckplyr_df()`

- for an implicit cross join,

- for a value of the `multiple` argument that isn't the default `"all"`.

- for a value of the `unmatched` argument that isn't the default
  `"drop"`.

These features fall back to
[`dplyr::right_join()`](https://dplyr.tidyverse.org/reference/mutate-joins.html),
see
[`vignette("fallback")`](https://duckplyr.tidyverse.org/articles/fallback.md)
for details.

## See also

[`dplyr::right_join()`](https://dplyr.tidyverse.org/reference/mutate-joins.html)

## Examples

``` r
library(duckplyr)
right_join(band_members, band_instruments)
#> Joining with `by = join_by(name)`
#> # A tibble: 3 × 3
#>   name  band    plays 
#>   <chr> <chr>   <chr> 
#> 1 John  Beatles guitar
#> 2 Paul  Beatles bass  
#> 3 Keith NA      guitar
```
