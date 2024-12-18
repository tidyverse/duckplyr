
<!-- README.md and index.md are generated from README.Rmd. Please edit that file. -->

# duckplyr <a href="https://duckplyr.tidyverse.org"><img src="man/figures/logo.png" align="right" height="138" /></a>

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
[![R-CMD-check](https://github.com/tidyverse/duckplyr/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/tidyverse/duckplyr/actions/workflows/R-CMD-check.yaml)
<!-- badges: end -->

> A **drop-in replacement** for dplyr, powered by DuckDB for **fast
> operation**.

[dplyr](https://dplyr.tidyverse.org/) is the grammar of data
manipulation in the tidyverse. The duckplyr package will run all of your
existing dplyr code with identical results, using
[DuckDB](https://duckdb.org/) where possible to compute the results
faster. In addition, you can analyze larger-than-memory datasets
straight from files on your disk or from S3 storage. If you are new to
dplyr, the best place to start is the [data transformation
chapter](https://r4ds.hadley.nz/data-transform) in R for Data Science.

## Installation

Install duckplyr from CRAN with:

``` r
install.packages("duckplyr")
```

You can also install the development version of duckplyr from
[R-universe](https://tidyverse.r-universe.dev/builds):

``` r
install.packages("duckplyr", repos = c("https://tidyverse.r-universe.dev", "https://cloud.r-project.org"))
```

Or from [GitHub](https://github.com/) with:

``` r
# install.packages("pak")
pak::pak("tidyverse/duckplyr")
```

## Example

Calling `library(duckplyr)` overwrites dplyr methods, enabling duckplyr
instead for the entire session.

``` r
library(conflicted)
library(duckplyr)
```

    #> ✔ Overwriting dplyr methods with duckplyr methods.
    #> ℹ Turn off with `duckplyr::methods_restore()`.

``` r
conflict_prefer("filter", "dplyr", quiet = TRUE)
```

The following code aggregates the inflight delay by year and month for
the first half of the year. We use a variant of the
`nycflights13::flights` dataset that removes an incompatibility with
duckplyr.

``` r
flights_df()
#> # A tibble: 336,776 × 19
#>     year month   day dep_time sched_de…¹ dep_d…² arr_t…³ sched…⁴ arr_d…⁵ carrier
#>    <int> <int> <int>    <int>      <int>   <dbl>   <int>   <int>   <dbl> <chr>  
#>  1  2013     1     1      517        515       2     830     819      11 UA     
#>  2  2013     1     1      533        529       4     850     830      20 UA     
#>  3  2013     1     1      542        540       2     923     850      33 AA     
#>  4  2013     1     1      544        545      -1    1004    1022     -18 B6     
#>  5  2013     1     1      554        600      -6     812     837     -25 DL     
#>  6  2013     1     1      554        558      -4     740     728      12 UA     
#>  7  2013     1     1      555        600      -5     913     854      19 B6     
#>  8  2013     1     1      557        600      -3     709     723     -14 EV     
#>  9  2013     1     1      557        600      -3     838     846      -8 B6     
#> 10  2013     1     1      558        600      -2     753     745       8 AA     
#> # ℹ 336,766 more rows
#> # ℹ abbreviated names: ¹​sched_dep_time, ²​dep_delay, ³​arr_time, ⁴​sched_arr_time,
#> #   ⁵​arr_delay
#> # ℹ 9 more variables: flight <int>, tailnum <chr>, origin <chr>, dest <chr>,
#> #   air_time <dbl>, distance <dbl>, hour <dbl>, minute <dbl>, time_hour <dttm>

out <-
  flights_df() %>%
  filter(!is.na(arr_delay), !is.na(dep_delay)) %>%
  mutate(inflight_delay = arr_delay - dep_delay) %>%
  summarize(
    .by = c(year, month),
    mean_inflight_delay = mean(inflight_delay),
    median_inflight_delay = median(inflight_delay),
  ) %>%
  filter(month <= 6)
```

The result is a plain tibble:

``` r
class(out)
#> [1] "tbl_df"     "tbl"        "data.frame"
```

Nothing has been computed yet. Querying the number of rows, or a column,
starts the computation:

``` r
system.time(print(out$month))
#> [1] 2 4 1 5 3 6
#>    user  system elapsed 
#>   0.011   0.001   0.009
```

Note that, unlike dplyr, the results are not ordered, see `?config` for
details. However, once materialized, the results are stable:

``` r
out
#> # A tibble: 6 × 4
#>    year month mean_inflight_delay median_inflight_delay
#>   <int> <int>               <dbl>                 <dbl>
#> 1  2013     2               -5.15                    -6
#> 2  2013     4               -2.67                    -5
#> 3  2013     1               -3.86                    -5
#> 4  2013     5               -9.37                   -10
#> 5  2013     3               -7.36                    -9
#> 6  2013     6               -4.24                    -7
```

Restart R, or call `duckplyr::methods_restore()` to revert to the
default dplyr implementation.

``` r
duckplyr::methods_restore()
#> ℹ Restoring dplyr methods.
```

## Using duckplyr in other packages

Refer to `vignette("developers", package = "duckplyr")`.

## Telemetry

We would like to guide our efforts towards improving duckplyr, focusing
on the features with the most impact. To this end, duckplyr collects and
uploads telemetry data, but only if permitted by the user:

- No collection will happen unless the user explicitly opts in.
- Uploads are done upon request only.
- There is an option to automatically upload when the package is loaded,
  this is also opt-in.

The data collected contains:

- The package version
- The error message
- The operation being performed, and the arguments
  - For the input data frames, only the structure is included (column
    types only), no column names or data

The first time the package encounters an unsupported function, data
type, or operation, instructions are printed to the console.

``` r
out <-
  nycflights13::flights %>%
  duckplyr::as_duck_tbl()
```

## How is this different from dbplyr?

The duckplyr package is a dplyr backend that uses DuckDB, a
high-performance, embeddable analytical database. It is designed to be a
fully compatible drop-in replacement for dplyr, with *exactly* the same
syntax and semantics:

- Input and output are data frames or tibbles.
- All dplyr verbs are supported, with fallback.
- All R data types and functions are supported, with fallback.
- No SQL is generated.

The dbplyr package is a dplyr backend that connects to SQL databases,
and is designed to work with various databases that support SQL,
including DuckDB. Data must be copied into and collected from the
database, and the syntax and semantics are similar but not identical to
plain dplyr.
