# Selective use of duckplyr

This vignette demonstrates how to use duckplyr selectively, for
individual data frames or for other packages.

``` r
library(conflicted)
library(dplyr)
conflict_prefer("filter", "dplyr")
#> [conflicted] Will prefer dplyr::filter
#> over any other package.
```

## Introduction

The default behavior of duckplyr is to enable itself for all data frames
in the session. This happens when the package is attached with
[`library(duckplyr)`](https://duckplyr.tidyverse.org), or by calling
[`methods_overwrite()`](https://duckplyr.tidyverse.org/reference/methods_overwrite.md).
To enable duckplyr for individual data frames instead of session-wide,
it is sufficient to prefix all calls to duckplyr functions with
`duckplyr::` and not attach the package. Alternatively,
[`methods_restore()`](https://duckplyr.tidyverse.org/reference/methods_overwrite.md)
can be called to undo the session-wide overwrite after
[`library(duckplyr)`](https://duckplyr.tidyverse.org).

## External data with explicit qualification

The following example uses
[`duckplyr::as_duckdb_tibble()`](https://duckplyr.tidyverse.org/reference/duckdb_tibble.md)
to convert a data frame to a duckplyr frame and to enable duckplyr
operation.

``` r
lazy <-
  duckplyr::flights_df() |>
  duckplyr::as_duckdb_tibble() |>
  mutate(inflight_delay = arr_delay - dep_delay) |>
  summarize(
    .by = c(year, month),
    mean_inflight_delay = mean(inflight_delay, na.rm = TRUE),
    median_inflight_delay = median(inflight_delay, na.rm = TRUE),
  ) |>
  filter(month <= 6)
```

The result is a tibble, with its own class.

``` r
class(lazy)
#> [1] "duckplyr_df" "tbl_df"      "tbl"         "data.frame"

names(lazy)
#> [1] "year"                  "month"                
#> [3] "mean_inflight_delay"   "median_inflight_delay"
```

DuckDB is responsible for eventually carrying out the operations.
Despite the filter coming very late in the pipeline, it is applied to
the raw data.

``` r
lazy |>
  explain()
#> ┌---------------------------┐
#> │       HASH_GROUP_BY       │
#> │    --------------------   │
#> │          Groups:          │
#> │             #0            │
#> │             #1            │
#> │                           │
#> │        Aggregates:        │
#> │          mean(#2)         │
#> │         median(#3)        │
#> │                           │
#> │        ~67,354 rows       │
#> └-------------┬-------------┘
#> ┌-------------┴-------------┐
#> │         PROJECTION        │
#> │    --------------------   │
#> │            year           │
#> │           month           │
#> │       inflight_delay      │
#> │       inflight_delay      │
#> │                           │
#> │        ~67,355 rows       │
#> └-------------┬-------------┘
#> ┌-------------┴-------------┐
#> │         PROJECTION        │
#> │    --------------------   │
#> │            year           │
#> │           month           │
#> │       inflight_delay      │
#> │                           │
#> │        ~67,355 rows       │
#> └-------------┬-------------┘
#> ┌-------------┴-------------┐
#> │           FILTER          │
#> │    --------------------   │
#> │ (CAST(month AS DOUBLE) <= │
#> │            6.0)           │
#> │                           │
#> │        ~67,355 rows       │
#> └-------------┬-------------┘
#> ┌-------------┴-------------┐
#> │     R_DATAFRAME_SCAN      │
#> │    --------------------   │
#> │      Text: data.frame     │
#> │                           │
#> │        Projections:       │
#> │            year           │
#> │           month           │
#> │         dep_delay         │
#> │         arr_delay         │
#> │                           │
#> │       ~336,776 rows       │
#> └---------------------------┘
```

All data frame operations are supported. Computation happens upon the
first request.

``` r
lazy$mean_inflight_delay
#> [1] -5.147220 -9.370201 -3.855519 -7.356713 -2.673124 -4.244284
```

After the computation has been carried out, the results are preserved
and available immediately:

``` r
lazy
#> # A duckplyr data frame: 4 variables
#>    year month mean_inflight_delay median_inflight_delay
#>   <int> <int>               <dbl>                 <dbl>
#> 1  2013     2               -5.15                    -6
#> 2  2013     5               -9.37                   -10
#> 3  2013     1               -3.86                    -5
#> 4  2013     3               -7.36                    -9
#> 5  2013     4               -2.67                    -5
#> 6  2013     6               -4.24                    -7
```

## Restoring dplyr methods

The same can be achieved by calling
[`methods_restore()`](https://duckplyr.tidyverse.org/reference/methods_overwrite.md)
after [`library(duckplyr)`](https://duckplyr.tidyverse.org).

``` r
library(duckplyr)
#> ✔ Overwriting dplyr methods with duckplyr methods.
#> ℹ Turn off with `duckplyr::methods_restore()`.

methods_restore()
#> ℹ Restoring dplyr methods.
```

If the input is a plain data frame, duckplyr is not involved.

``` r
flights_df() |>
  mutate(inflight_delay = arr_delay - dep_delay) |>
  explain()
#> Error in UseMethod("explain"): no applicable method for 'explain' applied to an object of class "c('tbl_df', 'tbl', 'data.frame')"
```

## Own data

Construct duckplyr frames directly with
[`duckdb_tibble()`](https://duckplyr.tidyverse.org/reference/duckdb_tibble.md):

``` r
data <- duckdb_tibble(
  x = 1:3,
  y = 5,
  z = letters[1:3]
)
data
#> # A duckplyr data frame: 3 variables
#>       x     y z    
#>   <int> <dbl> <chr>
#> 1     1     5 a    
#> 2     2     5 b    
#> 3     3     5 c
```

## In other packages

Like other dependencies, duckplyr must be declared in the `DESCRIPTION`
file and optionally imported in the `NAMESPACE` file. Because duckplyr
does not import dplyr, it is necessary to import both packages. The
recipe below shows how to achieve this with the usethis package.

- Add dplyr as a dependency with `usethis::use_package("dplyr")`
- Add duckplyr as a dependency with `usethis::use_package("duckplyr")`
- In your code, use a pattern like
  `data |> duckplyr::as_duckdb_tibble() |> dplyr::filter(...)`
- To avoid the package prefix and simply write
  [`as_duckdb_tibble()`](https://duckplyr.tidyverse.org/reference/duckdb_tibble.md)
  or [`filter()`](https://dplyr.tidyverse.org/reference/filter.html):
  - Import the duckplyr function with
    `usethis::use_import_from("duckplyr", "as_duckdb_tibble")`
  - Import the dplyr function with
    `usethis::use_import_from("dplyr", "filter")`

Learn more about prudence in
[`vignette("prudence")`](https://duckplyr.tidyverse.org/articles/prudence.md),
about fallbacks to dplyr in
[`vignette("fallback")`](https://duckplyr.tidyverse.org/articles/fallback.md),
about the translation employed by duckplyr in
[`vignette("limits")`](https://duckplyr.tidyverse.org/articles/limits.md),
about direct use of DuckDB functions in
[`vignette("duckdb")`](https://duckplyr.tidyverse.org/articles/duckdb.md),
and about the usethis package at <https://usethis.r-lib.org/>.
