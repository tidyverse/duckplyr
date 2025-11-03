# Configuration options

The behavior of duckplyr can be fine-tuned with several environment
variables, and one option.

## Environment variables

`DUCKPLYR_TEMP_DIR`: Set to a path where temporary files can be created.
By default, [`tempdir()`](https://rdrr.io/r/base/tempfile.html) is used.

`DUCKPLYR_OUTPUT_ORDER`: If `TRUE`, row output order is preserved. The
default may change the row order where dplyr would keep it stable.
Preserving the order leads to more complicated execution plans with less
potential for optimization, and thus may be slower.

`DUCKPLYR_FORCE`: If `TRUE`, fail if duckdb cannot handle a request.

`DUCKPLYR_CHECK_ROUNDTRIP`: If `TRUE`, check if all columns are
roundtripped perfectly when creating a relational object from a data
frame, This is slow, and mostly useful for debugging. The default is to
check roundtrip of attributes.

`DUCKPLYR_METHODS_OVERWRITE`: If `TRUE`, call
[`methods_overwrite()`](https://duckplyr.tidyverse.org/reference/methods_overwrite.md)
when the package is loaded.

See [fallback](https://duckplyr.tidyverse.org/reference/fallback.md) for
more options related to printing, logging, and uploading of fallback
events.

## Examples

``` r
# Sys.setenv(DUCKPLYR_OUTPUT_ORDER = TRUE)
data.frame(a = 3:1) %>%
  as_duckdb_tibble() %>%
  inner_join(data.frame(a = 1:4), by = "a")
#> # A duckplyr data frame: 1 variable
#>       a
#>   <int>
#> 1     1
#> 2     2
#> 3     3

withr::with_envvar(c(DUCKPLYR_OUTPUT_ORDER = "TRUE"), {
  data.frame(a = 3:1) %>%
    as_duckdb_tibble() %>%
    inner_join(data.frame(a = 1:4), by = "a")
})
#> # A duckplyr data frame: 1 variable
#>       a
#>   <int>
#> 1     3
#> 2     2
#> 3     1

# Sys.setenv(DUCKPLYR_FORCE = TRUE)
add_one <- function(x) {
  x + 1
}

data.frame(a = 3:1) %>%
  as_duckdb_tibble() %>%
  mutate(b = add_one(a))
#> # A duckplyr data frame: 2 variables
#>       a     b
#>   <int> <dbl>
#> 1     3     4
#> 2     2     3
#> 3     1     2

try(withr::with_envvar(c(DUCKPLYR_FORCE = "TRUE"), {
  data.frame(a = 3:1) %>%
    as_duckdb_tibble() %>%
    mutate(b = add_one(a))
}))
#> Error in mutate(., b = add_one(a)) : 
#>   Can't translate function `add_one()`.

# Sys.setenv(DUCKPLYR_FALLBACK_INFO = TRUE)
withr::with_envvar(c(DUCKPLYR_FALLBACK_INFO = "TRUE"), {
  data.frame(a = 3:1) %>%
    as_duckdb_tibble() %>%
    mutate(b = add_one(a))
})
#> Error processing duckplyr query with DuckDB, falling back to dplyr.
#> Caused by error in `mutate()`:
#> ! Can't translate function `add_one()`.
#> # A duckplyr data frame: 2 variables
#>       a     b
#>   <int> <dbl>
#> 1     3     4
#> 2     2     3
#> 3     1     2
```
