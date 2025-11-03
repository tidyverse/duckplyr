# Show stats

Prints statistics on how many calls were handled by DuckDB. The output
shows the total number of requests in the current session, split by
fallbacks to dplyr and requests handled by duckdb.

## Usage

``` r
stats_show()
```

## Value

Called for its side effect.

## Examples

``` r
stats_show()
#> 🛠: 53
#> 🔨:  7
#> 🦆: 46
#> anti_join.data.frame, arrange.data.frame, compute, count.data.frame, distinct, explain, filter, full_join.data.frame, group_by.data.frame, head, inner_join, inner_join.data.frame, intersect, left_join.data.frame, mutate, mutate.data.frame, relocate, setdiff

tibble(a = 1:3) %>%
  as_duckplyr_tibble() %>%
  mutate(b = a + 1)
#> Warning: `as_duckplyr_tibble()` was deprecated in duckplyr 1.0.0.
#> ℹ Please use `as_duckdb_tibble()` instead.
#> # A duckplyr data frame: 2 variables
#>       a     b
#>   <int> <dbl>
#> 1     1     2
#> 2     2     3
#> 3     3     4

stats_show()
#> 🛠: 55
#> 🔨:  7
#> 🦆: 48
#> anti_join.data.frame, arrange.data.frame, compute, count.data.frame, distinct, explain, filter, full_join.data.frame, group_by.data.frame, head, inner_join, inner_join.data.frame, intersect, left_join.data.frame, mutate, mutate.data.frame, relocate, setdiff
```
