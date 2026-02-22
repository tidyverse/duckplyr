# Convert a duckplyr frame to a dbplyr table

**\[experimental\]**

This function converts a lazy duckplyr frame or a data frame to a dbplyr
table in duckplyr's internal connection. This allows using dbplyr
functions on the data, including hand-written SQL queries. Use
[`as_duckdb_tibble()`](https://duckplyr.tidyverse.org/dev/reference/duckdb_tibble.md)
to convert back to a lazy duckplyr frame.

## Usage

``` r
as_tbl(.data)
```

## Arguments

- .data:

  A lazy duckplyr frame or a data frame.

## Value

A dbplyr table.

## Examples

``` r
df <- duckdb_tibble(a = 1L)
df
#> # A duckplyr data frame: 1 variable
#>       a
#>   <int>
#> 1     1

tbl <- as_tbl(df)
tbl
#> # Source:   table<as_tbl_duckplyr_EdLieexomb> [?? x 1]
#> # Database: DuckDB 1.4.4 [unknown@Linux 6.11.0-1018-azure:R 4.5.2//tmp/Rtmp286lph/duckplyr/duckplyr344a27073ded.duckdb]
#>       a
#>   <int>
#> 1     1

tbl %>%
  mutate(b = sql("a + 1")) %>%
  as_duckdb_tibble()
#> # A duckplyr data frame: 2 variables
#>       a     b
#>   <int> <int>
#> 1     1     2
```
