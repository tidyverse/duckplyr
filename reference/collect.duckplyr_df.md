# Force conversion to a data frame

This is a method for the
[`dplyr::collect()`](https://dplyr.tidyverse.org/reference/compute.html)
generic.
[`collect()`](https://dplyr.tidyverse.org/reference/compute.html)
converts the input to a tibble, materializing any lazy operations.

## Usage

``` r
# S3 method for class 'duckplyr_df'
collect(x, ...)
```

## Arguments

- x:

  A data frame, data frame extension (e.g. a tibble), or a lazy data
  frame (e.g. from dbplyr or dtplyr). See *Methods*, below, for more
  details.

- ...:

  Arguments passed on to methods

## See also

[`dplyr::collect()`](https://dplyr.tidyverse.org/reference/compute.html)

## Examples

``` r
library(duckplyr)
df <- duckdb_tibble(x = c(1, 2), .lazy = TRUE)
df
#> # A duckplyr data frame: 2 variables
#>       x .lazy
#>   <dbl> <lgl>
#> 1     1 TRUE 
#> 2     2 TRUE 
try(print(df$x))
#> [1] 1 2
df <- collect(df)
df
#> # A tibble: 2 × 2
#>       x .lazy
#>   <dbl> <lgl>
#> 1     1 TRUE 
#> 2     2 TRUE 
```
