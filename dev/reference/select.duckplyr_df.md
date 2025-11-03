# Keep or drop columns using their names and types

This is a method for the
[`dplyr::select()`](https://dplyr.tidyverse.org/reference/select.html)
generic. See "Fallbacks" section for differences in implementation.
Select (and optionally rename) variables in a data frame, using a
concise mini-language that makes it easy to refer to variables based on
their name (e.g. `a:f` selects all columns from a on the left to f on
the right) or type (e.g. `where(is.numeric)` selects all numeric
columns).

## Usage

``` r
# S3 method for class 'duckplyr_df'
select(.data, ...)
```

## Arguments

- .data:

  A data frame, data frame extension (e.g. a tibble), or a lazy data
  frame (e.g. from dbplyr or dtplyr). See *Methods*, below, for more
  details.

- ...:

  \<[`tidy-select`](https://dplyr.tidyverse.org/reference/dplyr_tidy_select.html)\>
  One or more unquoted expressions separated by commas. Variable names
  can be used as if they were positions in the data frame, so
  expressions like `x:y` can be used to select a range of variables.

## Fallbacks

There is no DuckDB translation in `select.duckplyr_df()`

- with no expression,

- nor with a selection that returns no columns.

These features fall back to
[`dplyr::select()`](https://dplyr.tidyverse.org/reference/select.html),
see
[`vignette("fallback")`](https://duckplyr.tidyverse.org/dev/articles/fallback.md)
for details.

## See also

[`dplyr::select()`](https://dplyr.tidyverse.org/reference/select.html)

## Examples

``` r
library(duckplyr)
select(mtcars, mpg)
#>                      mpg
#> Mazda RX4           21.0
#> Mazda RX4 Wag       21.0
#> Datsun 710          22.8
#> Hornet 4 Drive      21.4
#> Hornet Sportabout   18.7
#> Valiant             18.1
#> Duster 360          14.3
#> Merc 240D           24.4
#> Merc 230            22.8
#> Merc 280            19.2
#> Merc 280C           17.8
#> Merc 450SE          16.4
#> Merc 450SL          17.3
#> Merc 450SLC         15.2
#> Cadillac Fleetwood  10.4
#> Lincoln Continental 10.4
#> Chrysler Imperial   14.7
#> Fiat 128            32.4
#> Honda Civic         30.4
#> Toyota Corolla      33.9
#> Toyota Corona       21.5
#> Dodge Challenger    15.5
#> AMC Javelin         15.2
#> Camaro Z28          13.3
#> Pontiac Firebird    19.2
#> Fiat X1-9           27.3
#> Porsche 914-2       26.0
#> Lotus Europa        30.4
#> Ford Pantera L      15.8
#> Ferrari Dino        19.7
#> Maserati Bora       15.0
#> Volvo 142E          21.4
```
