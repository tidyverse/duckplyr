# Summarise each group down to one row

This is a method for the
[`dplyr::summarise()`](https://dplyr.tidyverse.org/reference/summarise.html)
generic. See "Fallbacks" section for differences in implementation.
[`summarise()`](https://dplyr.tidyverse.org/reference/summarise.html)
creates a new data frame. It returns one row for each combination of
grouping variables; if there are no grouping variables, the output will
have a single row summarising all observations in the input. It will
contain one column for each grouping variable and one column for each of
the summary statistics that you have specified.

## Usage

``` r
# S3 method for class 'duckplyr_df'
summarise(.data, ..., .by = NULL, .groups = NULL)
```

## Arguments

- .data:

  A data frame, data frame extension (e.g. a tibble), or a lazy data
  frame (e.g. from dbplyr or dtplyr). See *Methods*, below, for more
  details.

- ...:

  \<[`data-masking`](https://rlang.r-lib.org/reference/args_data_masking.html)\>
  Name-value pairs of summary functions. The name will be the name of
  the variable in the result.

  The value can be:

  - A vector of length 1, e.g. `min(x)`,
    [`n()`](https://dplyr.tidyverse.org/reference/context.html), or
    `sum(is.na(y))`.

  - A data frame with 1 row, to add multiple columns from a single
    expression.

- .by:

  \<[`tidy-select`](https://dplyr.tidyverse.org/reference/dplyr_tidy_select.html)\>
  Optionally, a selection of columns to group by for just this
  operation, functioning as an alternative to
  [`group_by()`](https://dplyr.tidyverse.org/reference/group_by.html).
  For details and examples, see
  [?dplyr_by](https://dplyr.tidyverse.org/reference/dplyr_by.html).

- .groups:

  **\[experimental\]** Grouping structure of the result.

  - `"drop_last"`: drops the last level of grouping. This was the only
    supported option before version 1.0.0.

  - `"drop"`: All levels of grouping are dropped.

  - `"keep"`: Same grouping structure as `.data`.

  - `"rowwise"`: Each row is its own group.

  When `.groups` is not specified, it is set to `"drop_last"` for a
  grouped data frame, and `"keep"` for a rowwise data frame. In
  addition, a message informs you of how the result will be grouped
  unless the result is ungrouped, the option `"dplyr.summarise.inform"`
  is set to `FALSE`, or when
  [`summarise()`](https://dplyr.tidyverse.org/reference/summarise.html)
  is called from a function in a package.

## Fallbacks

There is no DuckDB translation in `summarise.duckplyr_df()`

- with `.groups = "rowwise"`.

These features fall back to
[`dplyr::summarise()`](https://dplyr.tidyverse.org/reference/summarise.html),
see
[`vignette("fallback")`](https://duckplyr.tidyverse.org/dev/articles/fallback.md)
for details.

## See also

[`dplyr::summarise()`](https://dplyr.tidyverse.org/reference/summarise.html)

## Examples

``` r
library(duckplyr)
summarise(mtcars, mean = mean(disp), n = n())
#>       mean  n
#> 1 230.7219 32
```
