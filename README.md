
<!-- README.md and index.md are generated from README.Rmd. Please edit that file. -->

# duckplyr <a href="https://duckplyr.tidyverse.org"><img src="man/figures/logo.png" align="right" height="138" /></a>

<!-- badges: start -->

[![Lifecycle:
stable](https://img.shields.io/badge/lifecycle-stable-brightgreen.svg)](https://lifecycle.r-lib.org/articles/stages.html#stable)
[![R-CMD-check](https://github.com/tidyverse/duckplyr/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/tidyverse/duckplyr/actions/workflows/R-CMD-check.yaml)
[![Codecov test
coverage](https://codecov.io/gh/tidyverse/duckplyr/graph/badge.svg)](https://app.codecov.io/gh/tidyverse/duckplyr)
<!-- badges: end -->

> A **drop-in replacement** for dplyr, powered by DuckDB for **speed**.

[dplyr](https://dplyr.tidyverse.org/) is the grammar of data
manipulation in the tidyverse. The duckplyr package will run all of your
existing dplyr code with identical results, using
[DuckDB](https://duckdb.org/) where possible to compute the results
faster. In addition, you can analyze larger-than-memory datasets
straight from files on your disk or from the web.

If you are new to dplyr, the best place to start is the [data
transformation chapter](https://r4ds.hadley.nz/data-transform) in R for
Data Science.

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

## Drop-in replacement for dplyr

Calling `library(duckplyr)` overwrites dplyr methods, enabling duckplyr
for the entire session.

``` r
library(conflicted)
library(duckplyr)
#> Loading required package: dplyr
#> ✔ Overwriting dplyr methods with duckplyr methods.
#> ℹ Turn off with `duckplyr::methods_restore()`.
```

``` r
conflict_prefer("filter", "dplyr", quiet = TRUE)
```

The following code aggregates the inflight delay by year and month for
the first half of the year. We use a variant of the
`nycflights13::flights` dataset, where the timezone has been set to UTC
to work around a current limitation of duckplyr, see
[`vignette("limits")`](https://duckplyr.tidyverse.org/dev/articles/limits.html).

``` r
flights_df()
#> # A tibble: 336,776 × 19
#>     year month   day dep_time sched_d…¹ dep_d…² arr_t…³ sched…⁴ arr_d…⁵
#>    <int> <int> <int>    <int>     <int>   <dbl>   <int>   <int>   <dbl>
#>  1  2013     1     1      517       515       2     830     819      11
#>  2  2013     1     1      533       529       4     850     830      20
#>  3  2013     1     1      542       540       2     923     850      33
#>  4  2013     1     1      544       545      -1    1004    1022     -18
#>  5  2013     1     1      554       600      -6     812     837     -25
#>  6  2013     1     1      554       558      -4     740     728      12
#>  7  2013     1     1      555       600      -5     913     854      19
#>  8  2013     1     1      557       600      -3     709     723     -14
#>  9  2013     1     1      557       600      -3     838     846      -8
#> 10  2013     1     1      558       600      -2     753     745       8
#> # ℹ 336,766 more rows
#> # ℹ abbreviated names: ¹​sched_dep_time, ²​dep_delay, ³​arr_time,
#> #   ⁴​sched_arr_time, ⁵​arr_delay
#> # ℹ 10 more variables: carrier <chr>, flight <int>, tailnum <chr>,
#> #   origin <chr>, dest <chr>, air_time <dbl>, distance <dbl>,
#> #   hour <dbl>, minute <dbl>, time_hour <dttm>

out <-
  flights_df() |>
  filter(!is.na(arr_delay), !is.na(dep_delay)) |>
  mutate(inflight_delay = arr_delay - dep_delay) |>
  summarize(
    .by = c(year, month),
    mean_inflight_delay = mean(inflight_delay),
    median_inflight_delay = median(inflight_delay),
  ) |>
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
out$month
#> [1] 1 2 3 4 5 6
```

Note that, unlike dplyr, the results are not ordered, see `?config` for
details. However, once materialized, the results are stable:

``` r
out
#> # A tibble: 6 × 4
#>    year month mean_inflight_delay median_inflight_delay
#>   <int> <int>               <dbl>                 <dbl>
#> 1  2013     1               -3.86                    -5
#> 2  2013     2               -5.15                    -6
#> 3  2013     3               -7.36                    -9
#> 4  2013     4               -2.67                    -5
#> 5  2013     5               -9.37                   -10
#> 6  2013     6               -4.24                    -7
```

If a computation is not supported by DuckDB, duckplyr will automatically
fall back to dplyr.

``` r
flights_df() |>
  summarize(
    .by = origin,
    dest = paste(sort(unique(dest)), collapse = " ")
  )
#> # A tibble: 3 × 2
#>   origin dest                                                          
#>   <chr>  <chr>                                                         
#> 1 EWR    ALB ANC ATL AUS AVL BDL BNA BOS BQN BTV BUF BWI BZN CAE CHS C…
#> 2 LGA    ATL AVL BGR BHM BNA BOS BTV BUF BWI CAE CAK CHO CHS CLE CLT C…
#> 3 JFK    ABQ ACK ATL AUS BHM BNA BOS BQN BTV BUF BUR BWI CHS CLE CLT C…
```

Restart R, or call `duckplyr::methods_restore()` to revert to the
default dplyr implementation.

``` r
duckplyr::methods_restore()
#> ℹ Restoring dplyr methods.
```

## Analyzing larger-than-memory data

An extended variant of the `nycflights13::flights` dataset is also
available for download as Parquet files.

``` r
year <- 2022:2024
base_url <- "https://blobs.duckdb.org/flight-data-partitioned/"
files <- paste0("Year=", year, "/data_0.parquet")
urls <- paste0(base_url, files)
tibble(urls)
#> # A tibble: 3 × 1
#>   urls                                                                 
#>   <chr>                                                                
#> 1 https://blobs.duckdb.org/flight-data-partitioned/Year=2022/data_0.pa…
#> 2 https://blobs.duckdb.org/flight-data-partitioned/Year=2023/data_0.pa…
#> 3 https://blobs.duckdb.org/flight-data-partitioned/Year=2024/data_0.pa…
```

Using the [httpfs DuckDB
extension](https://duckdb.org/docs/extensions/httpfs/overview.html), we
can query these files directly from R, without even downloading them
first.

``` r
db_exec("INSTALL httpfs")
db_exec("LOAD httpfs")

flights <- read_parquet_duckdb(urls)
```

Like with local data frames, queries on the remote data are executed
lazily. Unlike with local data frames, the default is to disallow
automatic materialization if the result is too large in order to protect
memory: the results are not materialized until explicitly requested,
with a `collect()` call for instance.

``` r
nrow(flights)
#> Error: Materialization would result in 9091 rows, which exceeds the limit of 9090. Use collect() or as_tibble() to materialize.
```

For printing, only the first few rows of the result are fetched.

``` r
flights
#> # A duckplyr data frame: 110 variables
#>     Year Quarter Month DayofMonth DayOfWeek FlightDate Report…¹ DOT_I…²
#>    <dbl>   <dbl> <dbl>      <dbl>     <dbl> <date>     <chr>      <dbl>
#>  1  2022       1     1         14         5 2022-01-14 YX         20452
#>  2  2022       1     1         15         6 2022-01-15 YX         20452
#>  3  2022       1     1         16         7 2022-01-16 YX         20452
#>  4  2022       1     1         17         1 2022-01-17 YX         20452
#>  5  2022       1     1         18         2 2022-01-18 YX         20452
#>  6  2022       1     1         19         3 2022-01-19 YX         20452
#>  7  2022       1     1         20         4 2022-01-20 YX         20452
#>  8  2022       1     1         21         5 2022-01-21 YX         20452
#>  9  2022       1     1         22         6 2022-01-22 YX         20452
#> 10  2022       1     1         23         7 2022-01-23 YX         20452
#> # ℹ more rows
#> # ℹ abbreviated names: ¹​Reporting_Airline, ²​DOT_ID_Reporting_Airline
#> # ℹ 102 more variables: IATA_CODE_Reporting_Airline <chr>,
#> #   Tail_Number <chr>, Flight_Number_Reporting_Airline <dbl>,
#> #   OriginAirportID <dbl>, OriginAirportSeqID <dbl>,
#> #   OriginCityMarketID <dbl>, Origin <chr>, OriginCityName <chr>,
#> #   OriginState <chr>, OriginStateFips <chr>, OriginStateName <chr>,
#> #   OriginWac <dbl>, DestAirportID <dbl>, DestAirportSeqID <dbl>,
#> #   DestCityMarketID <dbl>, Dest <chr>, DestCityName <chr>,
#> #   DestState <chr>, DestStateFips <chr>, DestStateName <chr>,
#> #   DestWac <dbl>, CRSDepTime <chr>, DepTime <chr>, DepDelay <dbl>,
#> #   DepDelayMinutes <dbl>, DepDel15 <dbl>, …
```

``` r
flights |>
  count(Year)
#> # A duckplyr data frame: 2 variables
#>    Year       n
#>   <dbl>   <int>
#> 1  2022 6729125
#> 2  2023 6847899
#> 3  2024 3461319
```

Complex queries can be executed on the remote data. Note how only the
relevant columns are fetched and the 2024 data isn’t even touched, as
it’s not needed for the result.

``` r
out <-
  flights |>
  mutate(InFlightDelay = ArrDelay - DepDelay) |>
  summarize(
    .by = c(Year, Month),
    MeanInFlightDelay = mean(InFlightDelay, na.rm = TRUE),
    MedianInFlightDelay = median(InFlightDelay, na.rm = TRUE),
  ) |>
  filter(Year < 2024)

out |>
  explain()
#> ┌───────────────────────────┐
#> │       HASH_GROUP_BY       │
#> │    ────────────────────   │
#> │          Groups:          │
#> │             #0            │
#> │             #1            │
#> │                           │
#> │        Aggregates:        │
#> │          mean(#2)         │
#> │         median(#3)        │
#> │                           │
#> │       ~6729125 Rows       │
#> └─────────────┬─────────────┘
#> ┌─────────────┴─────────────┐
#> │         PROJECTION        │
#> │    ────────────────────   │
#> │            Year           │
#> │           Month           │
#> │       InFlightDelay       │
#> │       InFlightDelay       │
#> │                           │
#> │       ~13458250 Rows      │
#> └─────────────┬─────────────┘
#> ┌─────────────┴─────────────┐
#> │         PROJECTION        │
#> │    ────────────────────   │
#> │            Year           │
#> │           Month           │
#> │       InFlightDelay       │
#> │                           │
#> │       ~13458250 Rows      │
#> └─────────────┬─────────────┘
#> ┌─────────────┴─────────────┐
#> │       READ_PARQUET        │
#> │    ────────────────────   │
#> │         Function:         │
#> │        READ_PARQUET       │
#> │                           │
#> │        Projections:       │
#> │            Year           │
#> │           Month           │
#> │          DepDelay         │
#> │          ArrDelay         │
#> │                           │
#> │       File Filters:       │
#> │  (CAST(Year AS DOUBLE) <  │
#> │           2024.0)         │
#> │                           │
#> │    Scanning Files: 2/3    │
#> │                           │
#> │       ~13458250 Rows      │
#> └───────────────────────────┘

out |>
  print() |>
  system.time()
#> # A duckplyr data frame: 4 variables
#>     Year Month MeanInFlightDelay MedianInFlightDelay
#>    <dbl> <dbl>             <dbl>               <dbl>
#>  1  2022    11             -5.21                  -7
#>  2  2023    11             -7.10                  -8
#>  3  2022     8             -5.27                  -7
#>  4  2023     4             -4.54                  -6
#>  5  2022     7             -5.13                  -7
#>  6  2022     4             -4.88                  -6
#>  7  2023     8             -5.73                  -7
#>  8  2023     7             -4.47                  -7
#>  9  2022     2             -6.52                  -8
#> 10  2023     5             -6.17                  -7
#> # ℹ more rows
#>    user  system elapsed 
#>   1.145   0.455   9.402
```

Over 10M rows analyzed in about 10 seconds over the internet, that’s not
bad. Of course, working with Parquet, CSV, or JSON files downloaded
locally is possible as well.

For full compatibility, `na.rm = FALSE` by default in the aggregation
functions:

``` r
flights |>
  summarize(mean(ArrDelay - DepDelay))
#> # A duckplyr data frame: 1 variable
#>   `mean(ArrDelay - DepDelay)`
#>                         <dbl>
#> 1                          NA
```

## Further reading

- [`vignette("large")`](https://duckplyr.tidyverse.org/dev/articles/large.html):
  Tools for working with large data

- [`vignette("prudence")`](https://duckplyr.tidyverse.org/dev/articles/prudence.html):
  How duckplyr can help protect memory when working with large data

- [`vignette("fallback")`](https://duckplyr.tidyverse.org/dev/articles/fallback.html):
  How the fallback to dplyr works internally

- [`vignette("limits")`](https://duckplyr.tidyverse.org/dev/articles/limits.html):
  Translation of dplyr employed by duckplyr, and current limitations

- [`vignette("developers")`](https://duckplyr.tidyverse.org/dev/articles/developers.html):
  Using duckplyr for individual data frames and in other packages

- [`vignette("telemetry")`](https://duckplyr.tidyverse.org/dev/articles/telemetry.html):
  Telemetry in duckplyr

## Getting help

If you encounter a clear bug, please file an issue with a minimal
reproducible example on
[GitHub](https://github.com/tidyverse/duckplyr/issues). For questions
and other discussion, please use
[forum.posit.co](https://forum.posit.co/).

## Code of conduct

Please note that this project is released with a [Contributor Code of
Conduct](https://duckplyr.tidyverse.org/CODE_OF_CONDUCT). By
participating in this project you agree to abide by its terms.
