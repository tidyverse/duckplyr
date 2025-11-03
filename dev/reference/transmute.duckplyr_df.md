# Create, modify, and delete columns

This is a method for the
[`dplyr::transmute()`](https://dplyr.tidyverse.org/reference/transmute.html)
generic. See "Fallbacks" section for differences in implementation.
[`transmute()`](https://dplyr.tidyverse.org/reference/transmute.html)
creates a new data frame containing only the specified computations.
It's superseded because you can perform the same job with
`mutate(.keep = "none")`.

## Usage

``` r
# S3 method for class 'duckplyr_df'
transmute(.data, ...)
```

## Arguments

- .data:

  A data frame, data frame extension (e.g. a tibble), or a lazy data
  frame (e.g. from dbplyr or dtplyr). See *Methods*, below, for more
  details.

- ...:

  \<[`data-masking`](https://rlang.r-lib.org/reference/args_data_masking.html)\>
  Name-value pairs. The name gives the name of the column in the output.

  The value can be:

  - A vector of length 1, which will be recycled to the correct length.

  - A vector the same length as the current group (or the whole data
    frame if ungrouped).

  - `NULL`, to remove the column.

  - A data frame or tibble, to create multiple columns in the output.

## Fallbacks

There is no DuckDB translation in `transmute.duckplyr_df()`

- with a selection that returns no columns:

These features fall back to
[`dplyr::transmute()`](https://dplyr.tidyverse.org/reference/transmute.html),
see
[`vignette("fallback")`](https://duckplyr.tidyverse.org/dev/articles/fallback.md)
for details.

## See also

[`dplyr::transmute()`](https://dplyr.tidyverse.org/reference/transmute.html)

## Examples

``` r
library(duckplyr)
transmute(mtcars, mpg2 = mpg*2)
#>                     mpg2
#> Mazda RX4           42.0
#> Mazda RX4 Wag       42.0
#> Datsun 710          45.6
#> Hornet 4 Drive      42.8
#> Hornet Sportabout   37.4
#> Valiant             36.2
#> Duster 360          28.6
#> Merc 240D           48.8
#> Merc 230            45.6
#> Merc 280            38.4
#> Merc 280C           35.6
#> Merc 450SE          32.8
#> Merc 450SL          34.6
#> Merc 450SLC         30.4
#> Cadillac Fleetwood  20.8
#> Lincoln Continental 20.8
#> Chrysler Imperial   29.4
#> Fiat 128            64.8
#> Honda Civic         60.8
#> Toyota Corolla      67.8
#> Toyota Corona       43.0
#> Dodge Challenger    31.0
#> AMC Javelin         30.4
#> Camaro Z28          26.6
#> Pontiac Firebird    38.4
#> Fiat X1-9           54.6
#> Porsche 914-2       52.0
#> Lotus Europa        60.8
#> Ford Pantera L      31.6
#> Ferrari Dino        39.4
#> Maserati Bora       30.0
#> Volvo 142E          42.8
```
