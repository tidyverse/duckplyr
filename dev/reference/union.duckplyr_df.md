# Union

This is a method for the
[`dplyr::union()`](https://dplyr.tidyverse.org/reference/setops.html)
generic. `union(x, y)` finds all rows in either x or y, excluding
duplicates. The implementation forwards to `distinct(union_all(x, y))`.

## Usage

``` r
# S3 method for class 'duckplyr_df'
union(x, y, ...)
```

## Arguments

- x, y:

  Pair of compatible data frames. A pair of data frames is compatible if
  they have the same column names (possibly in different orders) and
  compatible types.

- ...:

  These dots are for future extensions and must be empty.

## See also

[`dplyr::union()`](https://dplyr.tidyverse.org/reference/setops.html)

## Examples

``` r
df1 <- duckdb_tibble(x = 1:3)
df2 <- duckdb_tibble(x = 3:5)
union(df1, df2)
#> # A duckplyr data frame: 1 variable
#>       x
#>   <int>
#> 1     2
#> 2     5
#> 3     1
#> 4     3
#> 5     4
```
