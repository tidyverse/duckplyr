
<!-- README.md and index.md are generated from README.Rmd. Please edit that file. -->



# duckplyr <a href="https://duckplyr.tidyverse.org"><img src="man/figures/logo.png" align="right" height="138" /></a>

<!-- badges: start -->
[![Lifecycle: experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
[![R-CMD-check](https://github.com/tidyverse/duckplyr/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/tidyverse/duckplyr/actions/workflows/R-CMD-check.yaml)
<!-- badges: end -->

> A **drop-in replacement** for dplyr, powered by DuckDB for **fast operation**.

[dplyr](https://dplyr.tidyverse.org/) is the grammar of data manipulation in the tidyverse.
The duckplyr package will run all of your existing dplyr code with identical results, using [DuckDB](https://duckdb.org/) where possible to compute the results faster.
In addition, you can analyze larger-than-memory datasets straight from files on your disk or from S3 storage.
If you are new to dplyr, the best place to start is the [data transformation chapter](https://r4ds.hadley.nz/data-transform) in R for Data Science.


## Installation

Install duckplyr from CRAN with:

``` r
install.packages("duckplyr")
```

You can also install the development version of duckplyr from [R-universe](https://tidyverse.r-universe.dev/builds):

``` r
install.packages("duckplyr", repos = c("https://tidyverse.r-universe.dev", "https://cloud.r-project.org"))
```

Or from [GitHub](https://github.com/) with:

``` r
# install.packages("pak")
pak::pak("tidyverse/duckplyr")
```

## Example

Calling `library(duckplyr)` overwrites dplyr methods,
enabling duckplyr instead for the entire session.


``` r
library(conflicted)
library(duckplyr)
```


```
#> [1m[22m[32m✔[39m Overwriting [34mdplyr[39m methods with [34mduckplyr[39m methods.
#> [36mℹ[39m Turn off with `duckplyr::methods_restore()`.
```


``` r
conflict_prefer("filter", "dplyr", quiet = TRUE)
```

The following code aggregates the inflight delay by year and month for the first half of the year.
We use a variant of the `nycflights13::flights` dataset that removes an incompatibility with duckplyr.


``` r
flights_df()
#> [38;5;246m# A tibble: 336,776 × 19[39m
#>     [1myear[22m [1mmonth[22m   [1mday[22m [1mdep_time[22m [1msched_de…¹[22m [1mdep_d…²[22m [1marr_t…³[22m [1msched…⁴[22m [1marr_d…⁵[22m [1mcarrier[22m
#>    [3m[38;5;246m<int>[39m[23m [3m[38;5;246m<int>[39m[23m [3m[38;5;246m<int>[39m[23m    [3m[38;5;246m<int>[39m[23m      [3m[38;5;246m<int>[39m[23m   [3m[38;5;246m<dbl>[39m[23m   [3m[38;5;246m<int>[39m[23m   [3m[38;5;246m<int>[39m[23m   [3m[38;5;246m<dbl>[39m[23m [3m[38;5;246m<chr>[39m[23m  
#> [38;5;250m 1[39m  [4m2[24m013     1     1      517        515       2     830     819      11 UA     
#> [38;5;250m 2[39m  [4m2[24m013     1     1      533        529       4     850     830      20 UA     
#> [38;5;250m 3[39m  [4m2[24m013     1     1      542        540       2     923     850      33 AA     
#> [38;5;250m 4[39m  [4m2[24m013     1     1      544        545      -[31m1[39m    [4m1[24m004    [4m1[24m022     -[31m18[39m B6     
#> [38;5;250m 5[39m  [4m2[24m013     1     1      554        600      -[31m6[39m     812     837     -[31m25[39m DL     
#> [38;5;250m 6[39m  [4m2[24m013     1     1      554        558      -[31m4[39m     740     728      12 UA     
#> [38;5;250m 7[39m  [4m2[24m013     1     1      555        600      -[31m5[39m     913     854      19 B6     
#> [38;5;250m 8[39m  [4m2[24m013     1     1      557        600      -[31m3[39m     709     723     -[31m14[39m EV     
#> [38;5;250m 9[39m  [4m2[24m013     1     1      557        600      -[31m3[39m     838     846      -[31m8[39m B6     
#> [38;5;250m10[39m  [4m2[24m013     1     1      558        600      -[31m2[39m     753     745       8 AA     
#> [38;5;246m# ℹ 336,766 more rows[39m
#> [38;5;246m# ℹ abbreviated names: ¹​sched_dep_time, ²​dep_delay, ³​arr_time, ⁴​sched_arr_time,[39m
#> [38;5;246m#   ⁵​arr_delay[39m
#> [38;5;246m# ℹ 9 more variables: [1mflight[22m <int>, [1mtailnum[22m <chr>, [1morigin[22m <chr>, [1mdest[22m <chr>,[39m
#> [38;5;246m#   [1mair_time[22m <dbl>, [1mdistance[22m <dbl>, [1mhour[22m <dbl>, [1mminute[22m <dbl>, [1mtime_hour[22m <dttm>[39m

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

Nothing has been computed yet.
Querying the number of rows, or a column, starts the computation:


``` r
system.time(print(out$month))
#> [1] 2 4 1 5 3 6
#>    user  system elapsed 
#>   0.011   0.001   0.009
```

Note that, unlike dplyr, the results are not ordered, see `?config` for details.
However, once materialized, the results are stable:


``` r
out
#> [38;5;246m# A tibble: 6 × 4[39m
#>    [1myear[22m [1mmonth[22m [1mmean_inflight_delay[22m [1mmedian_inflight_delay[22m
#>   [3m[38;5;246m<int>[39m[23m [3m[38;5;246m<int>[39m[23m               [3m[38;5;246m<dbl>[39m[23m                 [3m[38;5;246m<dbl>[39m[23m
#> [38;5;250m1[39m  [4m2[24m013     2               -[31m5[39m[31m.[39m[31m15[39m                    -[31m6[39m
#> [38;5;250m2[39m  [4m2[24m013     4               -[31m2[39m[31m.[39m[31m67[39m                    -[31m5[39m
#> [38;5;250m3[39m  [4m2[24m013     1               -[31m3[39m[31m.[39m[31m86[39m                    -[31m5[39m
#> [38;5;250m4[39m  [4m2[24m013     5               -[31m9[39m[31m.[39m[31m37[39m                   -[31m10[39m
#> [38;5;250m5[39m  [4m2[24m013     3               -[31m7[39m[31m.[39m[31m36[39m                    -[31m9[39m
#> [38;5;250m6[39m  [4m2[24m013     6               -[31m4[39m[31m.[39m[31m24[39m                    -[31m7[39m
```

Restart R, or call `duckplyr::methods_restore()` to revert to the default dplyr implementation.


``` r
duckplyr::methods_restore()
#> [1m[22m[36mℹ[39m Restoring [34mdplyr[39m methods.
```

## Using duckplyr in other packages

Refer to `vignette("developers", package = "duckplyr")`.

## Telemetry

We would like to guide our efforts towards improving duckplyr, focusing on the features with the most impact.
To this end, duckplyr collects and uploads telemetry data, but only if permitted by the user:

- No collection will happen unless the user explicitly opts in.
- Uploads are done upon request only.
- There is an option to automatically upload when the package is loaded, this is also opt-in.

The data collected contains:

- The package version
- The error message
- The operation being performed, and the arguments
    - For the input data frames, only the structure is included (column types only), no column names or data

The first time the package encounters an unsupported function, data type, or operation, instructions are printed to the console.




``` r
out <-
  nycflights13::flights %>%
  duckplyr::as_duck_tbl()
```

## How is this different from dbplyr?

The duckplyr package is a dplyr backend that uses DuckDB, a high-performance, embeddable analytical database.
It is designed to be a fully compatible drop-in replacement for dplyr, with *exactly* the same syntax and semantics:

- Input and output are data frames or tibbles.
- All dplyr verbs are supported, with fallback.
- All R data types and functions are supported, with fallback.
- No SQL is generated.

The dbplyr package is a dplyr backend that connects to SQL databases, and is designed to work with various databases that support SQL, including DuckDB.
Data must be copied into and collected from the database, and the syntax and semantics are similar but not identical to plain dplyr.
