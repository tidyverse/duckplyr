# Keep distinct/unique rows

This is a method for the
[`dplyr::distinct()`](https://dplyr.tidyverse.org/reference/distinct.html)
generic. Keep only unique/distinct rows from a data frame. This is
similar to [`unique.data.frame()`](https://rdrr.io/r/base/unique.html)
but considerably faster.

## Usage

``` r
# S3 method for class 'duckplyr_df'
distinct(.data, ..., .keep_all = FALSE)
```

## Arguments

- .data:

  A data frame, data frame extension (e.g. a tibble), or a lazy data
  frame (e.g. from dbplyr or dtplyr). See *Methods*, below, for more
  details.

- ...:

  \<[`data-masking`](https://rlang.r-lib.org/reference/args_data_masking.html)\>
  Optional variables to use when determining uniqueness. If there are
  multiple rows for a given combination of inputs, only the first row
  will be preserved. If omitted, will use all variables in the data
  frame.

- .keep_all:

  If `TRUE`, keep all variables in `.data`. If a combination of `...` is
  not distinct, this keeps the first row of values.

## See also

[`dplyr::distinct()`](https://dplyr.tidyverse.org/reference/distinct.html)

## Examples

``` r
df <- duckdb_tibble(
  x = sample(10, 100, rep = TRUE),
  y = sample(10, 100, rep = TRUE)
)
nrow(df)
#> [1] 100
nrow(distinct(df))
#> [1] 63
```
