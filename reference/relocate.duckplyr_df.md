# Change column order

This is a method for the
[`dplyr::relocate()`](https://dplyr.tidyverse.org/reference/relocate.html)
generic. See "Fallbacks" section for differences in implementation. Use
[`relocate()`](https://dplyr.tidyverse.org/reference/relocate.html) to
change column positions, using the same syntax as
[`select()`](https://dplyr.tidyverse.org/reference/select.html) to make
it easy to move blocks of columns at once.

## Usage

``` r
# S3 method for class 'duckplyr_df'
relocate(.data, ..., .before = NULL, .after = NULL)
```

## Arguments

- .data:

  A data frame, data frame extension (e.g. a tibble), or a lazy data
  frame (e.g. from dbplyr or dtplyr). See *Methods*, below, for more
  details.

- ...:

  \<[`tidy-select`](https://dplyr.tidyverse.org/reference/dplyr_tidy_select.html)\>
  Columns to move.

- .before, .after:

  \<[`tidy-select`](https://dplyr.tidyverse.org/reference/dplyr_tidy_select.html)\>
  Destination of columns selected by `...`. Supplying neither will move
  columns to the left-hand side; specifying both is an error.

## Fallbacks

There is no DuckDB translation in `relocate.duckplyr_df()`

- with a selection that returns no columns.

These features fall back to
[`dplyr::relocate()`](https://dplyr.tidyverse.org/reference/relocate.html),
see
[`vignette("fallback")`](https://duckplyr.tidyverse.org/articles/fallback.md)
for details.

## See also

[`dplyr::relocate()`](https://dplyr.tidyverse.org/reference/relocate.html)

## Examples

``` r
df <- duckdb_tibble(a = 1, b = 1, c = 1, d = "a", e = "a", f = "a")
relocate(df, f)
#> # A duckplyr data frame: 6 variables
#>   f         a     b     c d     e    
#>   <chr> <dbl> <dbl> <dbl> <chr> <chr>
#> 1 a         1     1     1 a     a    
```
