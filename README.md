
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
straight from files on your disk or from the web. If you are new to
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

## Drop-in replacement for dplyr

Calling `library(duckplyr)` overwrites dplyr methods, enabling duckplyr
for the entire session.

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
`nycflights13::flights` dataset that works around an incompatibility
with duckplyr.

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

Restart R, or call `duckplyr::methods_restore()` to revert to the
default dplyr implementation.

``` r
duckplyr::methods_restore()
#> ℹ Restoring dplyr methods.
```

## Analyzing larger-than-memory data

An extended variant of this dataset is also available for download as
Parquet files.

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

Using the httpfs DuckDB extension, we can query these files directly
from R, without even downloading them first.

``` r
duck_exec("INSTALL httpfs")
duck_exec("LOAD httpfs")

flights <- duck_parquet(urls)
```

Unlike with local data frames, the default is to disallow automatic
materialization of the results on access.

``` r
nrow(flights)
#> Error: Materialization is disabled, use collect() or as_tibble() to materialize
```

Queries on the remote data are executed lazily, and the results are not
materialized until explicitly requested. For printing, only the first
few rows of the result are fetched.

``` r
flights
#> # A duckplyr data frame: 110 variables
#>     Year Quarter Month DayofMonth DayOfWeek FlightDate Reporti…¹ DOT_I…² IATA_…³
#>    <dbl>   <dbl> <dbl>      <dbl>     <dbl> <date>     <chr>       <dbl> <chr>  
#>  1  2022       1     1         14         5 2022-01-14 YX          20452 YX     
#>  2  2022       1     1         15         6 2022-01-15 YX          20452 YX     
#>  3  2022       1     1         16         7 2022-01-16 YX          20452 YX     
#>  4  2022       1     1         17         1 2022-01-17 YX          20452 YX     
#>  5  2022       1     1         18         2 2022-01-18 YX          20452 YX     
#>  6  2022       1     1         19         3 2022-01-19 YX          20452 YX     
#>  7  2022       1     1         20         4 2022-01-20 YX          20452 YX     
#>  8  2022       1     1         21         5 2022-01-21 YX          20452 YX     
#>  9  2022       1     1         22         6 2022-01-22 YX          20452 YX     
#> 10  2022       1     1         23         7 2022-01-23 YX          20452 YX     
#> # ℹ more rows
#> # ℹ abbreviated names: ¹​Reporting_Airline, ²​DOT_ID_Reporting_Airline,
#> #   ³​IATA_CODE_Reporting_Airline
#> # ℹ 101 more variables: Tail_Number <chr>,
#> #   Flight_Number_Reporting_Airline <dbl>, OriginAirportID <dbl>,
#> #   OriginAirportSeqID <dbl>, OriginCityMarketID <dbl>, Origin <chr>,
#> #   OriginCityName <chr>, OriginState <chr>, OriginStateFips <chr>,
#> #   OriginStateName <chr>, OriginWac <dbl>, DestAirportID <dbl>,
#> #   DestAirportSeqID <dbl>, DestCityMarketID <dbl>, Dest <chr>,
#> #   DestCityName <chr>, DestState <chr>, DestStateFips <chr>,
#> #   DestStateName <chr>, DestWac <dbl>, CRSDepTime <chr>, DepTime <chr>,
#> #   DepDelay <dbl>, DepDelayMinutes <dbl>, DepDel15 <dbl>, …
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
#> │       ~1345825 Rows       │
#> └─────────────┬─────────────┘
#> ┌─────────────┴─────────────┐
#> │         PROJECTION        │
#> │    ────────────────────   │
#> │            Year           │
#> │           Month           │
#> │       InFlightDelay       │
#> │       InFlightDelay       │
#> │                           │
#> │       ~2691650 Rows       │
#> └─────────────┬─────────────┘
#> ┌─────────────┴─────────────┐
#> │         PROJECTION        │
#> │    ────────────────────   │
#> │            Year           │
#> │           Month           │
#> │       InFlightDelay       │
#> │                           │
#> │       ~2691650 Rows       │
#> └─────────────┬─────────────┘
#> ┌─────────────┴─────────────┐
#> │         PROJECTION        │
#> │    ────────────────────   │
#> │            Year           │
#> │           Month           │
#> │          DepDelay         │
#> │          ArrDelay         │
#> │                           │
#> │       ~2691650 Rows       │
#> └─────────────┬─────────────┘
#> ┌─────────────┴─────────────┐
#> │           FILTER          │
#> │    ────────────────────   │
#> │ ((NOT ((DepDelay IS NULL) │
#> │  OR isnan(DepDelay))) AND │
#> │  (NOT ((ArrDelay IS NULL) │
#> │    OR isnan(ArrDelay))))  │
#> │                           │
#> │       ~2691650 Rows       │
#> └─────────────┬─────────────┘
#> ┌─────────────┴─────────────┐
#> │       READ_PARQUET        │
#> │    ────────────────────   │
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
#>  4  2022     7             -5.13                  -7
#>  5  2023     4             -4.54                  -6
#>  6  2022     4             -4.88                  -6
#>  7  2023     8             -5.73                  -7
#>  8  2023     7             -4.47                  -7
#>  9  2022     6             -5.07                  -7
#> 10  2022    12             -4.63                  -6
#> # ℹ more rows
#>    user  system elapsed 
#>   1.759   0.350   9.322
```

Over 10M rows analyzed in about 10 seconds over the internet, that’s not
bad. Of course, working with Parquet, CSV, or JSON files downloaded
locally is possible as well.

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
