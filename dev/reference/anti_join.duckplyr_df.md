# Anti join

This is a method for the
[`dplyr::anti_join()`](https://dplyr.tidyverse.org/reference/filter-joins.html)
generic.
[`anti_join()`](https://dplyr.tidyverse.org/reference/filter-joins.html)
returns all rows from `x` with**out** a match in `y`.

## Usage

``` r
# S3 method for class 'duckplyr_df'
anti_join(x, y, by = NULL, copy = FALSE, ..., na_matches = c("na", "never"))
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

- ...:

  Other parameters passed onto methods.

- na_matches:

  Should two `NA` or two `NaN` values match?

  - `"na"`, the default, treats two `NA` or two `NaN` values as equal,
    like `%in%`, [`match()`](https://rdrr.io/r/base/match.html), and
    [`merge()`](https://rdrr.io/r/base/merge.html).

  - `"never"` treats two `NA` or two `NaN` values as different, and will
    never match them together or to any other values. This is similar to
    joins for database sources and to `base::merge(incomparables = NA)`.

## See also

[`dplyr::anti_join()`](https://dplyr.tidyverse.org/reference/filter-joins.html)

## Examples

``` r
library(duckplyr)
band_members %>% anti_join(band_instruments)
#> Joining with `by = join_by(name)`
#> # A tibble: 1 × 2
#>   name  band  
#>   <chr> <chr> 
#> 1 Mick  Stones
```
