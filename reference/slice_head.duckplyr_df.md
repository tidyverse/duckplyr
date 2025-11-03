# Subset rows using their positions

This is a method for the
[`dplyr::slice_head()`](https://dplyr.tidyverse.org/reference/slice.html)
generic.
[`slice_head()`](https://dplyr.tidyverse.org/reference/slice.html)
selects the first rows.

## Usage

``` r
# S3 method for class 'duckplyr_df'
slice_head(.data, ..., n, prop, by = NULL)
```

## Arguments

- .data:

  A data frame, data frame extension (e.g. a tibble), or a lazy data
  frame (e.g. from dbplyr or dtplyr). See *Methods*, below, for more
  details.

- ...:

  For [`slice()`](https://dplyr.tidyverse.org/reference/slice.html):
  \<[`data-masking`](https://rlang.r-lib.org/reference/args_data_masking.html)\>
  Integer row values.

  Provide either positive values to keep, or negative values to drop.
  The values provided must be either all positive or all negative.
  Indices beyond the number of rows in the input are silently ignored.

  For `slice_*()`, these arguments are passed on to methods.

- n, prop:

  Provide either `n`, the number of rows, or `prop`, the proportion of
  rows to select. If neither are supplied, `n = 1` will be used. If `n`
  is greater than the number of rows in the group (or `prop > 1`), the
  result will be silently truncated to the group size. `prop` will be
  rounded towards zero to generate an integer number of rows.

  A negative value of `n` or `prop` will be subtracted from the group
  size. For example, `n = -2` with a group of 5 rows will select 5 - 2 =
  3 rows; `prop = -0.25` with 8 rows will select 8 \* (1 - 0.25) = 6
  rows.

- by:

  **\[experimental\]**

  \<[`tidy-select`](https://dplyr.tidyverse.org/reference/dplyr_tidy_select.html)\>
  Optionally, a selection of columns to group by for just this
  operation, functioning as an alternative to
  [`group_by()`](https://dplyr.tidyverse.org/reference/group_by.html).
  For details and examples, see
  [?dplyr_by](https://dplyr.tidyverse.org/reference/dplyr_by.html).

## Fallbacks

There is no DuckDB translation in `slice_head.duckplyr_df()`

- if `by` or `prop` is provided,

- with a negative `n`.

These features fall back to
[`dplyr::slice_head()`](https://dplyr.tidyverse.org/reference/slice.html),
see
[`vignette("fallback")`](https://duckplyr.tidyverse.org/articles/fallback.md)
for details.

## See also

[`dplyr::slice_head()`](https://dplyr.tidyverse.org/reference/slice.html)

## Examples

``` r
library(duckplyr)
df <- data.frame(x = 1:3)
df <- slice_head(df, n = 2)
df
#>   x
#> 1 1
#> 2 2
```
