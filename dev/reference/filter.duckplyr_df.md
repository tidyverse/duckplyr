# Keep rows that match a condition

This is a method for the
[`dplyr::filter()`](https://dplyr.tidyverse.org/reference/filter.html)
generic. See "Fallbacks" section for differences in implementation. The
[`filter()`](https://dplyr.tidyverse.org/reference/filter.html) function
is used to subset a data frame, retaining all rows that satisfy your
conditions. To be retained, the row must produce a value of `TRUE` for
all conditions. Note that when a condition evaluates to `NA` the row
will be dropped, unlike base subsetting with `[`.

## Usage

``` r
# S3 method for class 'duckplyr_df'
filter(.data, ..., .by = NULL, .preserve = FALSE)
```

## Arguments

- .data:

  A data frame, data frame extension (e.g. a tibble), or a lazy data
  frame (e.g. from dbplyr or dtplyr). See *Methods*, below, for more
  details.

- ...:

  \<[`data-masking`](https://rlang.r-lib.org/reference/args_data_masking.html)\>
  Expressions that return a logical value, and are defined in terms of
  the variables in `.data`. If multiple expressions are included, they
  are combined with the `&` operator. Only rows for which all conditions
  evaluate to `TRUE` are kept.

- .by:

  **\[experimental\]**

  \<[`tidy-select`](https://dplyr.tidyverse.org/reference/dplyr_tidy_select.html)\>
  Optionally, a selection of columns to group by for just this
  operation, functioning as an alternative to
  [`group_by()`](https://dplyr.tidyverse.org/reference/group_by.html).
  For details and examples, see
  [?dplyr_by](https://dplyr.tidyverse.org/reference/dplyr_by.html).

- .preserve:

  Relevant when the `.data` input is grouped. If `.preserve = FALSE`
  (the default), the grouping structure is recalculated based on the
  resulting data, otherwise the grouping is kept as is.

## Fallbacks

There is no DuckDB translation in `filter.duckplyr_df()`

- with no filter conditions,

- nor for a grouped operation (if `.by` is set).

These features fall back to
[`dplyr::filter()`](https://dplyr.tidyverse.org/reference/filter.html),
see
[`vignette("fallback")`](https://duckplyr.tidyverse.org/dev/articles/fallback.md)
for details.

## See also

[`dplyr::filter()`](https://dplyr.tidyverse.org/reference/filter.html)

## Examples

``` r
df <- duckdb_tibble(x = 1:3, y = 3:1)
filter(df, x >= 2)
#> # A duckplyr data frame: 2 variables
#>       x     y
#>   <int> <int>
#> 1     2     2
#> 2     3     1
```
