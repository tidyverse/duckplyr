
<!-- README.md and index.md are generated from README.Rmd. Please edit that file. -->



# duckplyr <a href="https://duckplyr.tidyverse.org"><img src="man/figures/logo.png" align="right" height="138" /></a>

<!-- badges: start -->
[![Lifecycle: experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
[![R-CMD-check](https://github.com/tidyverse/duckplyr/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/tidyverse/duckplyr/actions/workflows/R-CMD-check.yaml)
<!-- badges: end -->

> A **drop-in replacement** for dplyr, powered by DuckDB for **fast operation**.

[dplyr](https://dplyr.tidyverse.org/) is the grammar of data manipulation in the tidyverse.
The duckplyr package will run all of your existing dplyr code with identical results, using [DuckDB](https://duckdb.org/) where possible to compute the results faster.
In addition, you can analyze larger-than-memory datasets straight from files on your disk or from the web.
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

## Drop-in replacement for dplyr

Calling `library(duckplyr)` overwrites dplyr methods, enabling duckplyr for the entire session.


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
We use a variant of the `nycflights13::flights` dataset that works around an incompatibility with duckplyr.


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
out$month
#> [1] 1 2 3 4 5 6
```

Note that, unlike dplyr, the results are not ordered, see `?config` for details.
However, once materialized, the results are stable:


``` r
out
#> [38;5;246m# A tibble: 6 × 4[39m
#>    [1myear[22m [1mmonth[22m [1mmean_inflight_delay[22m [1mmedian_inflight_delay[22m
#>   [3m[38;5;246m<int>[39m[23m [3m[38;5;246m<int>[39m[23m               [3m[38;5;246m<dbl>[39m[23m                 [3m[38;5;246m<dbl>[39m[23m
#> [38;5;250m1[39m  [4m2[24m013     1               -[31m3[39m[31m.[39m[31m86[39m                    -[31m5[39m
#> [38;5;250m2[39m  [4m2[24m013     2               -[31m5[39m[31m.[39m[31m15[39m                    -[31m6[39m
#> [38;5;250m3[39m  [4m2[24m013     3               -[31m7[39m[31m.[39m[31m36[39m                    -[31m9[39m
#> [38;5;250m4[39m  [4m2[24m013     4               -[31m2[39m[31m.[39m[31m67[39m                    -[31m5[39m
#> [38;5;250m5[39m  [4m2[24m013     5               -[31m9[39m[31m.[39m[31m37[39m                   -[31m10[39m
#> [38;5;250m6[39m  [4m2[24m013     6               -[31m4[39m[31m.[39m[31m24[39m                    -[31m7[39m
```

Restart R, or call `duckplyr::methods_restore()` to revert to the default dplyr implementation.


``` r
duckplyr::methods_restore()
#> [1m[22m[36mℹ[39m Restoring [34mdplyr[39m methods.
```

## Analyzing larger-than-memory data

An extended variant of this dataset is also available for download as Parquet files.


``` r
year <- 2022:2024
base_url <- "https://blobs.duckdb.org/flight-data-partitioned/"
files <- paste0("Year=", year, "/data_0.parquet")
urls <- paste0(base_url, files)
urls
#> [1] "https://blobs.duckdb.org/flight-data-partitioned/Year=2022/data_0.parquet"
#> [2] "https://blobs.duckdb.org/flight-data-partitioned/Year=2023/data_0.parquet"
#> [3] "https://blobs.duckdb.org/flight-data-partitioned/Year=2024/data_0.parquet"
```

Using the httpfs DuckDB extension, we can query these files directly from R, without even downloading them first.


``` r
duck_exec("INSTALL httpfs")
duck_exec("LOAD httpfs")

flights <- duck_parquet(urls)
```

Unlike with local data frames, the default is to disallow automatic materialization of the results on access.


``` r
nrow(flights)
#> Error: Materialization is disabled, use collect() or as_tibble() to materialize
```

Queries on the remote data are executed lazily, and the results are not materialized until explicitly requested.
For printing, only the first few rows of the result are fetched.


``` r
flights
#> [38;5;246m# A duckplyr data frame: 110 variables[39m
#>     [1mYear[22m [1mQuarter[22m [1mMonth[22m [1mDayofMonth[22m [1mDayOfWeek[22m [1mFlightDate[22m [1mReporti…¹[22m [1mDOT_I…²[22m [1mIATA_…³[22m
#>    [3m[38;5;246m<dbl>[39m[23m   [3m[38;5;246m<dbl>[39m[23m [3m[38;5;246m<dbl>[39m[23m      [3m[38;5;246m<dbl>[39m[23m     [3m[38;5;246m<dbl>[39m[23m [3m[38;5;246m<date>[39m[23m     [3m[38;5;246m<chr>[39m[23m       [3m[38;5;246m<dbl>[39m[23m [3m[38;5;246m<chr>[39m[23m  
#> [38;5;250m 1[39m  [4m2[24m022       1     1         14         5 2022-01-14 YX          [4m2[24m[4m0[24m452 YX     
#> [38;5;250m 2[39m  [4m2[24m022       1     1         15         6 2022-01-15 YX          [4m2[24m[4m0[24m452 YX     
#> [38;5;250m 3[39m  [4m2[24m022       1     1         16         7 2022-01-16 YX          [4m2[24m[4m0[24m452 YX     
#> [38;5;250m 4[39m  [4m2[24m022       1     1         17         1 2022-01-17 YX          [4m2[24m[4m0[24m452 YX     
#> [38;5;250m 5[39m  [4m2[24m022       1     1         18         2 2022-01-18 YX          [4m2[24m[4m0[24m452 YX     
#> [38;5;250m 6[39m  [4m2[24m022       1     1         19         3 2022-01-19 YX          [4m2[24m[4m0[24m452 YX     
#> [38;5;250m 7[39m  [4m2[24m022       1     1         20         4 2022-01-20 YX          [4m2[24m[4m0[24m452 YX     
#> [38;5;250m 8[39m  [4m2[24m022       1     1         21         5 2022-01-21 YX          [4m2[24m[4m0[24m452 YX     
#> [38;5;250m 9[39m  [4m2[24m022       1     1         22         6 2022-01-22 YX          [4m2[24m[4m0[24m452 YX     
#> [38;5;250m10[39m  [4m2[24m022       1     1         23         7 2022-01-23 YX          [4m2[24m[4m0[24m452 YX     
#> [38;5;246m# ℹ more rows[39m
#> [38;5;246m# ℹ abbreviated names: ¹​Reporting_Airline, ²​DOT_ID_Reporting_Airline,[39m
#> [38;5;246m#   ³​IATA_CODE_Reporting_Airline[39m
#> [38;5;246m# ℹ 101 more variables: [1mTail_Number[22m <chr>,[39m
#> [38;5;246m#   [1mFlight_Number_Reporting_Airline[22m <dbl>, [1mOriginAirportID[22m <dbl>,[39m
#> [38;5;246m#   [1mOriginAirportSeqID[22m <dbl>, [1mOriginCityMarketID[22m <dbl>, [1mOrigin[22m <chr>,[39m
#> [38;5;246m#   [1mOriginCityName[22m <chr>, [1mOriginState[22m <chr>, [1mOriginStateFips[22m <chr>,[39m
#> [38;5;246m#   [1mOriginStateName[22m <chr>, [1mOriginWac[22m <dbl>, [1mDestAirportID[22m <dbl>,[39m
#> [38;5;246m#   [1mDestAirportSeqID[22m <dbl>, [1mDestCityMarketID[22m <dbl>, [1mDest[22m <chr>,[39m
#> [38;5;246m#   [1mDestCityName[22m <chr>, [1mDestState[22m <chr>, [1mDestStateFips[22m <chr>,[39m
#> [38;5;246m#   [1mDestStateName[22m <chr>, [1mDestWac[22m <dbl>, [1mCRSDepTime[22m <chr>, [1mDepTime[22m <chr>,[39m
#> [38;5;246m#   [1mDepDelay[22m <dbl>, [1mDepDelayMinutes[22m <dbl>, [1mDepDel15[22m <dbl>, …[39m
```


``` r
flights |>
  count(Year)
#> [38;5;246m# A duckplyr data frame: 2 variables[39m
#>    [1mYear[22m       [1mn[22m
#>   [3m[38;5;246m<dbl>[39m[23m   [3m[38;5;246m<int>[39m[23m
#> [38;5;250m1[39m  [4m2[24m022 6[4m7[24m[4m2[24m[4m9[24m125
#> [38;5;250m2[39m  [4m2[24m023 6[4m8[24m[4m4[24m[4m7[24m899
#> [38;5;250m3[39m  [4m2[24m024 3[4m4[24m[4m6[24m[4m1[24m319
```

Complex queries can be executed on the remote data.
Note how only the relevant columns are fetched and the 2024 data isn't even touched, as it's not needed for the result.


``` r
out <-
  flights |>
  filter(!is.na(DepDelay), !is.na(ArrDelay)) |>
  mutate(InFlightDelay = ArrDelay - DepDelay) |>
  summarize(
    .by = c(Year, Month),
    MeanInFlightDelay = mean(InFlightDelay),
    MedianInFlightDelay = median(InFlightDelay),
  ) |>
  filter(Year < 2024)

out |>
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
#> │       ~1345825 Rows       │
#> └-------------┬-------------┘
#> ┌-------------┴-------------┐
#> │         PROJECTION        │
#> │    --------------------   │
#> │            Year           │
#> │           Month           │
#> │       InFlightDelay       │
#> │       InFlightDelay       │
#> │                           │
#> │       ~2691650 Rows       │
#> └-------------┬-------------┘
#> ┌-------------┴-------------┐
#> │         PROJECTION        │
#> │    --------------------   │
#> │            Year           │
#> │           Month           │
#> │       InFlightDelay       │
#> │                           │
#> │       ~2691650 Rows       │
#> └-------------┬-------------┘
#> ┌-------------┴-------------┐
#> │         PROJECTION        │
#> │    --------------------   │
#> │            Year           │
#> │           Month           │
#> │          DepDelay         │
#> │          ArrDelay         │
#> │                           │
#> │       ~2691650 Rows       │
#> └-------------┬-------------┘
#> ┌-------------┴-------------┐
#> │           FILTER          │
#> │    --------------------   │
#> │ ((NOT ((DepDelay IS NULL) │
#> │  OR isnan(DepDelay))) AND │
#> │  (NOT ((ArrDelay IS NULL) │
#> │    OR isnan(ArrDelay))))  │
#> │                           │
#> │       ~2691650 Rows       │
#> └-------------┬-------------┘
#> ┌-------------┴-------------┐
#> │       READ_PARQUET        │
#> │    --------------------   │
#> │         Function:         │
#> │        READ_PARQUET       │
#> │                           │
#> │        Projections:       │
#> │          DepDelay         │
#> │          ArrDelay         │
#> │            Year           │
#> │           Month           │
#> │                           │
#> │       File Filters:       │
#> │  (CAST(Year AS DOUBLE) <  │
#> │           2024.0)         │
#> │                           │
#> │    Scanning Files: 2/2    │
#> │                           │
#> │       ~13458250 Rows      │
#> └---------------------------┘

out |>
  print() |>
  system.time()
#> [38;5;246m# A duckplyr data frame: 4 variables[39m
#>     [1mYear[22m [1mMonth[22m [1mMeanInFlightDelay[22m [1mMedianInFlightDelay[22m
#>    [3m[38;5;246m<dbl>[39m[23m [3m[38;5;246m<dbl>[39m[23m             [3m[38;5;246m<dbl>[39m[23m               [3m[38;5;246m<dbl>[39m[23m
#> [38;5;250m 1[39m  [4m2[24m022    11             -[31m5[39m[31m.[39m[31m21[39m                  -[31m7[39m
#> [38;5;250m 2[39m  [4m2[24m023    11             -[31m7[39m[31m.[39m[31m10[39m                  -[31m8[39m
#> [38;5;250m 3[39m  [4m2[24m022     8             -[31m5[39m[31m.[39m[31m27[39m                  -[31m7[39m
#> [38;5;250m 4[39m  [4m2[24m022     7             -[31m5[39m[31m.[39m[31m13[39m                  -[31m7[39m
#> [38;5;250m 5[39m  [4m2[24m023     4             -[31m4[39m[31m.[39m[31m54[39m                  -[31m6[39m
#> [38;5;250m 6[39m  [4m2[24m022     4             -[31m4[39m[31m.[39m[31m88[39m                  -[31m6[39m
#> [38;5;250m 7[39m  [4m2[24m023     8             -[31m5[39m[31m.[39m[31m73[39m                  -[31m7[39m
#> [38;5;250m 8[39m  [4m2[24m023     7             -[31m4[39m[31m.[39m[31m47[39m                  -[31m7[39m
#> [38;5;250m 9[39m  [4m2[24m022     6             -[31m5[39m[31m.[39m[31m0[39m[31m7[39m                  -[31m7[39m
#> [38;5;250m10[39m  [4m2[24m022    12             -[31m4[39m[31m.[39m[31m63[39m                  -[31m6[39m
#> [38;5;246m# ℹ more rows[39m
#>    user  system elapsed 
#>   1.759   0.350   9.322
```

Over 10M rows analyzed in about 10 seconds over the internet, that's not bad.
Of course, working with Parquet, CSV, or JSON files downloaded locally is possible as well.


## Using duckplyr in other packages

Refer to `vignette("developers", package = "duckplyr")`.

## Telemetry

As a drop-in replacement for dplyr, duckplyr will use DuckDB for the operations only if it can, and fall back to dplyr otherwise.
A fallback will not change the correctness of the results, but it may be slower or consume more memory.
We would like to guide our efforts towards improving duckplyr, focusing on the features with the most impact.
To this end, duckplyr collects and uploads telemetry data about fallback situations, but only if permitted by the user:

- Collection is on by default, but can be turned off.
- Uploads are done upon request only.
- There is an option to automatically upload when the package is loaded, this is also opt-in.

The data collected contains:

- The package version
- The error message
- The operation being performed, and the arguments
    - For the input data frames, only the structure is included (column types only), no column names or data



Fallback is silent by default, but can be made verbose.


``` r
Sys.setenv(DUCKPLYR_FALLBACK_INFO = TRUE)
out <-
  nycflights13::flights %>%
  duckplyr::as_duck_tbl() %>%
  mutate(inflight_delay = arr_delay - dep_delay)
#> Error processing duckplyr query with DuckDB, falling back to dplyr.
#> [1mCaused by error in `check_df_for_rel()` at duckplyr/R/relational-duckdb.R:103:3:[22m
#> [1m[22m[33m![39m Attributes are lost during conversion. Affected column: `time_hour`.
```

After logs have been collected, the upload options are displayed the next time the duckplyr package is loaded in an R session.


```
#> [1m[22mThe [34mduckplyr[39m package is configured to fall back to [34mdplyr[39m when it encounters an
#> incompatibility. Fallback events can be collected and uploaded for analysis to
#> guide future development. By default, data will be collected but no data will
#> be uploaded.
#> [36mℹ[39m Automatic fallback uploading is not controlled and therefore disabled, see
#>   `?duckplyr::fallback()`.
#> [32m✔[39m Number of reports ready for upload: [1m1[22m.
#> → Review with `duckplyr::fallback_review()`, upload with
#>   `duckplyr::fallback_upload()`.
#> [36mℹ[39m [90mThis message can be disabled by setting `DUCKPLYR_FALLBACK_AUTOUPLOAD`.[39m
```

The `fallback_sitrep()` function describes the current configuration and the available options.


## How is this different from dbplyr?

The duckplyr package is a dplyr backend that uses DuckDB, a high-performance, embeddable analytical database.
It is designed to be a fully compatible drop-in replacement for dplyr, with *exactly* the same syntax and semantics:

- Input and output are data frames or tibbles.
- All dplyr verbs are supported, with fallback.
- All R data types and functions are supported, with fallback.
- No SQL is generated.

The dbplyr package is a dplyr backend that connects to SQL databases, and is designed to work with various databases that support SQL, including DuckDB.
Data must be copied into and collected from the database, and the syntax and semantics are similar but not identical to plain dplyr.
