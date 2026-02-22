# Order rows using column values

This is a method for the
[`dplyr::arrange()`](https://dplyr.tidyverse.org/reference/arrange.html)
generic. See "Fallbacks" section for differences in implementation.
[`arrange()`](https://dplyr.tidyverse.org/reference/arrange.html) orders
the rows of a data frame by the values of selected columns.

Unlike other dplyr verbs,
[`arrange()`](https://dplyr.tidyverse.org/reference/arrange.html)
largely ignores grouping; you need to explicitly mention grouping
variables (or use `.by_group = TRUE`) in order to group by them, and
functions of variables are evaluated once per data frame, not once per
group.

## Usage

``` r
# S3 method for class 'duckplyr_df'
arrange(.data, ..., .by_group = FALSE, .locale = NULL)
```

## Arguments

- .data:

  A data frame, data frame extension (e.g. a tibble), or a lazy data
  frame (e.g. from dbplyr or dtplyr). See *Methods*, below, for more
  details.

- ...:

  \<[`data-masking`](https://rlang.r-lib.org/reference/args_data_masking.html)\>
  Variables, or functions of variables. Use
  [`desc()`](https://dplyr.tidyverse.org/reference/desc.html) to sort a
  variable in descending order.

- .by_group:

  If `TRUE`, will sort first by grouping variable. Applies to grouped
  data frames only.

- .locale:

  The locale to sort character vectors in.

  - If `NULL`, the default, uses the `"C"` locale unless the deprecated
    `dplyr.legacy_locale` global option escape hatch is active. See the
    [dplyr-locale](https://dplyr.tidyverse.org/reference/dplyr-locale.html)
    help page for more details.

  - If a single string from
    [`stringi::stri_locale_list()`](https://rdrr.io/pkg/stringi/man/stri_locale_list.html)
    is supplied, then this will be used as the locale to sort with. For
    example, `"en"` will sort with the American English locale. This
    requires the stringi package.

  - If `"C"` is supplied, then character vectors will always be sorted
    in the C locale. This does not require stringi and is often much
    faster than supplying a locale identifier.

  The C locale is not the same as English locales, such as `"en"`,
  particularly when it comes to data containing a mix of upper and lower
  case letters. This is explained in more detail on the
  [locale](https://dplyr.tidyverse.org/reference/dplyr-locale.html) help
  page under the `Default locale` section.

## Fallbacks

There is no DuckDB translation in `arrange.duckplyr_df()`

- with `.by_group = TRUE`,

- providing a value for the `.locale` argument,

- providing a value for the `dplyr.legacy_locale` option.

These features fall back to
[`dplyr::arrange()`](https://dplyr.tidyverse.org/reference/arrange.html),
see
[`vignette("fallback")`](https://duckplyr.tidyverse.org/dev/articles/fallback.md)
for details.

## See also

[`dplyr::arrange()`](https://dplyr.tidyverse.org/reference/arrange.html)

## Examples

``` r
library(duckplyr)
arrange(mtcars, cyl, disp)
#>                      mpg cyl  disp  hp drat    wt  qsec vs am gear
#> Toyota Corolla      33.9   4  71.1  65 4.22 1.835 19.90  1  1    4
#> Honda Civic         30.4   4  75.7  52 4.93 1.615 18.52  1  1    4
#> Fiat 128            32.4   4  78.7  66 4.08 2.200 19.47  1  1    4
#> Fiat X1-9           27.3   4  79.0  66 4.08 1.935 18.90  1  1    4
#> Lotus Europa        30.4   4  95.1 113 3.77 1.513 16.90  1  1    5
#> Datsun 710          22.8   4 108.0  93 3.85 2.320 18.61  1  1    4
#> Toyota Corona       21.5   4 120.1  97 3.70 2.465 20.01  1  0    3
#> Porsche 914-2       26.0   4 120.3  91 4.43 2.140 16.70  0  1    5
#> Volvo 142E          21.4   4 121.0 109 4.11 2.780 18.60  1  1    4
#> Merc 230            22.8   4 140.8  95 3.92 3.150 22.90  1  0    4
#> Merc 240D           24.4   4 146.7  62 3.69 3.190 20.00  1  0    4
#> Ferrari Dino        19.7   6 145.0 175 3.62 2.770 15.50  0  1    5
#> Mazda RX4           21.0   6 160.0 110 3.90 2.620 16.46  0  1    4
#> Mazda RX4 Wag       21.0   6 160.0 110 3.90 2.875 17.02  0  1    4
#> Merc 280            19.2   6 167.6 123 3.92 3.440 18.30  1  0    4
#> Merc 280C           17.8   6 167.6 123 3.92 3.440 18.90  1  0    4
#> Valiant             18.1   6 225.0 105 2.76 3.460 20.22  1  0    3
#> Hornet 4 Drive      21.4   6 258.0 110 3.08 3.215 19.44  1  0    3
#> Merc 450SE          16.4   8 275.8 180 3.07 4.070 17.40  0  0    3
#> Merc 450SL          17.3   8 275.8 180 3.07 3.730 17.60  0  0    3
#> Merc 450SLC         15.2   8 275.8 180 3.07 3.780 18.00  0  0    3
#> Maserati Bora       15.0   8 301.0 335 3.54 3.570 14.60  0  1    5
#> AMC Javelin         15.2   8 304.0 150 3.15 3.435 17.30  0  0    3
#> Dodge Challenger    15.5   8 318.0 150 2.76 3.520 16.87  0  0    3
#> Camaro Z28          13.3   8 350.0 245 3.73 3.840 15.41  0  0    3
#> Ford Pantera L      15.8   8 351.0 264 4.22 3.170 14.50  0  1    5
#> Hornet Sportabout   18.7   8 360.0 175 3.15 3.440 17.02  0  0    3
#> Duster 360          14.3   8 360.0 245 3.21 3.570 15.84  0  0    3
#> Pontiac Firebird    19.2   8 400.0 175 3.08 3.845 17.05  0  0    3
#> Chrysler Imperial   14.7   8 440.0 230 3.23 5.345 17.42  0  0    3
#> Lincoln Continental 10.4   8 460.0 215 3.00 5.424 17.82  0  0    3
#> Cadillac Fleetwood  10.4   8 472.0 205 2.93 5.250 17.98  0  0    3
#>                     carb
#> Toyota Corolla         1
#> Honda Civic            2
#> Fiat 128               1
#> Fiat X1-9              1
#> Lotus Europa           2
#> Datsun 710             1
#> Toyota Corona          1
#> Porsche 914-2          2
#> Volvo 142E             2
#> Merc 230               2
#> Merc 240D              2
#> Ferrari Dino           6
#> Mazda RX4              4
#> Mazda RX4 Wag          4
#> Merc 280               4
#> Merc 280C              4
#> Valiant                1
#> Hornet 4 Drive         1
#> Merc 450SE             3
#> Merc 450SL             3
#> Merc 450SLC            3
#> Maserati Bora          8
#> AMC Javelin            2
#> Dodge Challenger       2
#> Camaro Z28             4
#> Ford Pantera L         4
#> Hornet Sportabout      2
#> Duster 360             4
#> Pontiac Firebird       2
#> Chrysler Imperial      4
#> Lincoln Continental    4
#> Cadillac Fleetwood     4
arrange(mtcars, desc(disp))
#>                      mpg cyl  disp  hp drat    wt  qsec vs am gear
#> Cadillac Fleetwood  10.4   8 472.0 205 2.93 5.250 17.98  0  0    3
#> Lincoln Continental 10.4   8 460.0 215 3.00 5.424 17.82  0  0    3
#> Chrysler Imperial   14.7   8 440.0 230 3.23 5.345 17.42  0  0    3
#> Pontiac Firebird    19.2   8 400.0 175 3.08 3.845 17.05  0  0    3
#> Hornet Sportabout   18.7   8 360.0 175 3.15 3.440 17.02  0  0    3
#> Duster 360          14.3   8 360.0 245 3.21 3.570 15.84  0  0    3
#> Ford Pantera L      15.8   8 351.0 264 4.22 3.170 14.50  0  1    5
#> Camaro Z28          13.3   8 350.0 245 3.73 3.840 15.41  0  0    3
#> Dodge Challenger    15.5   8 318.0 150 2.76 3.520 16.87  0  0    3
#> AMC Javelin         15.2   8 304.0 150 3.15 3.435 17.30  0  0    3
#> Maserati Bora       15.0   8 301.0 335 3.54 3.570 14.60  0  1    5
#> Merc 450SE          16.4   8 275.8 180 3.07 4.070 17.40  0  0    3
#> Merc 450SL          17.3   8 275.8 180 3.07 3.730 17.60  0  0    3
#> Merc 450SLC         15.2   8 275.8 180 3.07 3.780 18.00  0  0    3
#> Hornet 4 Drive      21.4   6 258.0 110 3.08 3.215 19.44  1  0    3
#> Valiant             18.1   6 225.0 105 2.76 3.460 20.22  1  0    3
#> Merc 280            19.2   6 167.6 123 3.92 3.440 18.30  1  0    4
#> Merc 280C           17.8   6 167.6 123 3.92 3.440 18.90  1  0    4
#> Mazda RX4           21.0   6 160.0 110 3.90 2.620 16.46  0  1    4
#> Mazda RX4 Wag       21.0   6 160.0 110 3.90 2.875 17.02  0  1    4
#> Merc 240D           24.4   4 146.7  62 3.69 3.190 20.00  1  0    4
#> Ferrari Dino        19.7   6 145.0 175 3.62 2.770 15.50  0  1    5
#> Merc 230            22.8   4 140.8  95 3.92 3.150 22.90  1  0    4
#> Volvo 142E          21.4   4 121.0 109 4.11 2.780 18.60  1  1    4
#> Porsche 914-2       26.0   4 120.3  91 4.43 2.140 16.70  0  1    5
#> Toyota Corona       21.5   4 120.1  97 3.70 2.465 20.01  1  0    3
#> Datsun 710          22.8   4 108.0  93 3.85 2.320 18.61  1  1    4
#> Lotus Europa        30.4   4  95.1 113 3.77 1.513 16.90  1  1    5
#> Fiat X1-9           27.3   4  79.0  66 4.08 1.935 18.90  1  1    4
#> Fiat 128            32.4   4  78.7  66 4.08 2.200 19.47  1  1    4
#> Honda Civic         30.4   4  75.7  52 4.93 1.615 18.52  1  1    4
#> Toyota Corolla      33.9   4  71.1  65 4.22 1.835 19.90  1  1    4
#>                     carb
#> Cadillac Fleetwood     4
#> Lincoln Continental    4
#> Chrysler Imperial      4
#> Pontiac Firebird       2
#> Hornet Sportabout      2
#> Duster 360             4
#> Ford Pantera L         4
#> Camaro Z28             4
#> Dodge Challenger       2
#> AMC Javelin            2
#> Maserati Bora          8
#> Merc 450SE             3
#> Merc 450SL             3
#> Merc 450SLC            3
#> Hornet 4 Drive         1
#> Valiant                1
#> Merc 280               4
#> Merc 280C              4
#> Mazda RX4              4
#> Mazda RX4 Wag          4
#> Merc 240D              2
#> Ferrari Dino           6
#> Merc 230               2
#> Volvo 142E             2
#> Porsche 914-2          2
#> Toyota Corona          1
#> Datsun 710             1
#> Lotus Europa           2
#> Fiat X1-9              1
#> Fiat 128               1
#> Honda Civic            2
#> Toyota Corolla         1
```
