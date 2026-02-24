# Set difference

This is a method for the
[`dplyr::setdiff()`](https://dplyr.tidyverse.org/reference/setops.html)
generic. See "Fallbacks" section for differences in implementation.
`setdiff(x, y)` finds all rows in `x` that aren't in `y`.

## Usage

``` r
# S3 method for class 'duckplyr_df'
setdiff(x, y, ...)
```

## Arguments

- x, y:

  Pair of compatible data frames. A pair of data frames is compatible if
  they have the same column names (possibly in different orders) and
  compatible types.

- ...:

  These dots are for future extensions and must be empty.

## Fallbacks

There is no DuckDB translation in `setdiff.duckplyr_df()`

- if column names are duplicated in one of the tables,

- if column names are different in both tables.

These features fall back to
[`dplyr::setdiff()`](https://dplyr.tidyverse.org/reference/setops.html),
see
[`vignette("fallback")`](https://duckplyr.tidyverse.org/dev/articles/fallback.md)
for details.

## See also

[`dplyr::setdiff()`](https://dplyr.tidyverse.org/reference/setops.html)

## Examples

``` r
df1 <- duckdb_tibble(x = 1:3)
df2 <- duckdb_tibble(x = 3:5)
setdiff(df1, df2)
#> # A duckplyr data frame: 1 variable
#>       x
#>   <int>
#> 1     2
#> 2     1
setdiff(df2, df1)
#> # A duckplyr data frame: 1 variable
#>       x
#>   <int>
#> 1     5
#> 2     4
```
