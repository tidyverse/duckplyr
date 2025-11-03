# Flight data

Provides a variant of
[`nycflights13::flights`](https://rdrr.io/pkg/nycflights13/man/flights.html)
that is compatible with duckplyr, as a tibble: the timezone has been set
to UTC to work around a current limitation of duckplyr, see
[`vignette("limits")`](https://duckplyr.tidyverse.org/dev/articles/limits.md).
Call
[`as_duckdb_tibble()`](https://duckplyr.tidyverse.org/dev/reference/duckdb_tibble.md)
to enable duckplyr operations.

## Usage

``` r
flights_df()
```

## Examples

``` r
flights_df()
#> # A tibble: 336,776 × 19
#>     year month   day dep_time sched_dep_time dep_delay arr_time
#>    <int> <int> <int>    <int>          <int>     <dbl>    <int>
#>  1  2013     1     1      517            515         2      830
#>  2  2013     1     1      533            529         4      850
#>  3  2013     1     1      542            540         2      923
#>  4  2013     1     1      544            545        -1     1004
#>  5  2013     1     1      554            600        -6      812
#>  6  2013     1     1      554            558        -4      740
#>  7  2013     1     1      555            600        -5      913
#>  8  2013     1     1      557            600        -3      709
#>  9  2013     1     1      557            600        -3      838
#> 10  2013     1     1      558            600        -2      753
#> # ℹ 336,766 more rows
#> # ℹ 12 more variables: sched_arr_time <int>, arr_delay <dbl>,
#> #   carrier <chr>, flight <int>, tailnum <chr>, origin <chr>,
#> #   dest <chr>, air_time <dbl>, distance <dbl>, hour <dbl>,
#> #   minute <dbl>, time_hour <dttm>
```
