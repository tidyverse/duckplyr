# Memory protection: controlling automatic materialization

Unlike traditional data frames, duckplyr defers computation until
absolutely necessary, allowing DuckDB to optimize execution. This
article explains how to control the materialization of data to maintain
a seamless dplyr-like experience while remaining cautious of memory
usage.

``` r
library(conflicted)
library(dplyr)
conflict_prefer("filter", "dplyr")
#> [conflicted] Will prefer dplyr::filter
#> over any other package.
```

## Introduction

From a user’s perspective, data frames backed by duckplyr, with class
`"duckplyr_df"`, behave as regular data frames in almost all respects.
In particular, direct column access like `df$x`, or retrieving the
number of rows with [`nrow()`](https://rdrr.io/r/base/nrow.html), works
identically. Conceptually, duckplyr frames are “eager”:

``` r
df <-
  duckplyr::duckdb_tibble(x = 1:3) |>
  mutate(y = x + 1)
df
#> # A duckplyr data frame: 2 variables
#>       x     y
#>   <int> <dbl>
#> 1     1     2
#> 2     2     3
#> 3     3     4

class(df)
#> [1] "duckplyr_df" "tbl_df"      "tbl"         "data.frame"

df$y
#> [1] 2 3 4

nrow(df)
#> [1] 3
```

Under the hood, two key differences provide improved performance and
usability:

- **lazy materialization**: Unlike traditional data frames, duckplyr
  defers computation until absolutely necessary, i.e. lazily, allowing
  DuckDB to optimize execution.
- **prudence**: Automatic materialization is controllable, as automatic
  materialization of large data might otherwise inadvertently lead to
  memory problems.

The term “prudence” is introduced here to set a clear distinction from
the concept of “laziness”, and because “control of automatic
materialization” is a mouthful.

## Eager and lazy computation

For a duckplyr frame that is the result of a dplyr operation, accessing
column data or retrieving the number of rows will trigger a computation
that is carried out by DuckDB, not dplyr. In this sense, duckplyr frames
are also “lazy”: the computation is deferred until the last possible
moment, allowing DuckDB to optimize the whole pipeline.

### Example

This is explained in the following example that computes the mean
arrival delay for flights departing from Newark airport (EWR) by day and
month:

``` r
flights <- duckplyr::flights_df()

flights_duckdb <-
  flights |>
  duckplyr::as_duckdb_tibble()

system.time(
  mean_arr_delay_ewr <-
    flights_duckdb |>
    filter(origin == "EWR", !is.na(arr_delay)) |>
    summarize(
      .by = month,
      mean_arr_delay = mean(arr_delay),
      min_arr_delay = min(arr_delay),
      max_arr_delay = max(arr_delay),
      median_arr_delay = median(arr_delay),
    )
)
#>    user  system elapsed 
#>   0.012   0.003   0.015
```

Setting up the pipeline is fast, the size of the data does not affect
the setup costs. Because the computation is deferred, DuckDB can
optimize the whole pipeline, which can be seen in the output below:

``` r
mean_arr_delay_ewr |>
  explain()
#> ┌---------------------------┐
#> │         PROJECTION        │
#> │    --------------------   │
#> │           month           │
#> │       mean_arr_delay      │
#> │       min_arr_delay       │
#> │       max_arr_delay       │
#> │      median_arr_delay     │
#> │                           │
#> │        ~61,046 rows       │
#> └-------------┬-------------┘
#> ┌-------------┴-------------┐
#> │         PROJECTION        │
#> │    --------------------   │
#> │           month           │
#> │     (sum(CASE  WHEN (     │
#> │ (arr_delay IS NULL)) THEN │
#> │ (CAST(1 AS INTEGER)) ELSE │
#> │  CAST(0 AS INTEGER) END) >│
#> │             0)            │
#> │       avg(arr_delay)      │
#> │       min(arr_delay)      │
#> │       max(arr_delay)      │
#> │  quantile_cont(arr_delay) │
#> │                           │
#> │        ~61,046 rows       │
#> └-------------┬-------------┘
#> ┌-------------┴-------------┐
#> │       HASH_GROUP_BY       │
#> │    --------------------   │
#> │         Groups: #0        │
#> │                           │
#> │        Aggregates:        │
#> │    sum_no_overflow(#1)    │
#> │          avg(#2)          │
#> │          min(#3)          │
#> │          max(#4)          │
#> │     quantile_cont(#5)     │
#> │                           │
#> │        ~61,046 rows       │
#> └-------------┬-------------┘
#> ┌-------------┴-------------┐
#> │         PROJECTION        │
#> │    --------------------   │
#> │           month           │
#> │ CASE  WHEN ((arr_delay IS │
#> │ NULL)) THEN (1) ELSE 0 END│
#> │         arr_delay         │
#> │         arr_delay         │
#> │         arr_delay         │
#> │         arr_delay         │
#> │                           │
#> │        ~67,355 rows       │
#> └-------------┬-------------┘
#> ┌-------------┴-------------┐
#> │         PROJECTION        │
#> │    --------------------   │
#> │             #0            │
#> │             #1            │
#> │                           │
#> │        ~67,355 rows       │
#> └-------------┬-------------┘
#> ┌-------------┴-------------┐
#> │           FILTER          │
#> │    --------------------   │
#> │ ((NOT (arr_delay IS NULL))│
#> │    AND (origin = 'EWR'))  │
#> │                           │
#> │        ~67,355 rows       │
#> └-------------┬-------------┘
#> ┌-------------┴-------------┐
#> │     R_DATAFRAME_SCAN      │
#> │    --------------------   │
#> │      Text: data.frame     │
#> │                           │
#> │        Projections:       │
#> │           month           │
#> │         arr_delay         │
#> │           origin          │
#> │                           │
#> │       ~336,776 rows       │
#> └---------------------------┘
```

The first step in the pipeline is to prune the unneeded columns, only
`origin`, `month`, and `arr_delay` are kept. The result becomes
available when accessed:

``` r
system.time(mean_arr_delay_ewr$mean_arr_delay[[1]])
#>    user  system elapsed 
#>   0.024   0.004   0.021
```

### Comparison

The functionality is similar to lazy tables in
[dbplyr](https://dbplyr.tidyverse.org/) and lazy frames in
[dtplyr](https://dtplyr.tidyverse.org/). However, the behavior is
different: at the time of writing, the internal structure of a lazy
table or frame is different from a data frame, and columns cannot be
accessed directly.

|              | **Eager** 😃 | **Lazy** 😴 |
|--------------|:------------:|:-----------:|
| **dplyr**    |      ✅      |             |
| **dbplyr**   |              |     ✅      |
| **dtplyr**   |              |     ✅      |
| **duckplyr** |      ✅      |     ✅      |

In contrast, with [dplyr](https://dplyr.tidyverse.org/), each
intermediate step and also the final result is a proper data frame, and
computed right away, forfeiting the opportunity for optimization:

``` r
system.time(
  flights |>
    filter(origin == "EWR", !is.na(arr_delay)) |>
    summarize(
      .by = c(month, day),
      mean_arr_delay = mean(arr_delay),
      min_arr_delay = min(arr_delay),
      max_arr_delay = max(arr_delay),
      median_arr_delay = median(arr_delay),
    )
)
#>    user  system elapsed 
#>   0.037   0.008   0.045
```

See also the [duckplyr: dplyr Powered by
DuckDB](https://duckdb.org/2024/04/02/duckplyr.html) blog post for more
information.

## Prudence

Being both “eager” and “lazy” at the same time introduces a challenge:
it is too easy to accidentally trigger computation, which is prohibitive
if an intermediate result is too large to fit into memory. Prudence is a
setting for duckplyr frames that limits the size of the data that is
materialized automatically.

### Concept

Three levels of prudence are available:

- *lavish* (careless about resources): always automatically materialize,
  as in the first example.
- *stingy* (avoid spending at all cost): never automatically
  materialize, throw an error when attempting to access the data.
- *thrifty* (use resources wisely): only automaticaly materialize the
  data if it is small, otherwise throw an error.

For lavish duckplyr frames, as in the two previous examples, the
underlying DuckDB computation is carried out upon the first request.
Once the results are computed, they are cached and subsequent requests
are fast. This is a good choice for small to medium-sized data, where
DuckDB can provide a nice speedup but materializing the data is
affordable at any stage. This is the default for
[`duckdb_tibble()`](https://duckplyr.tidyverse.org/reference/duckdb_tibble.md)
and
[`as_duckdb_tibble()`](https://duckplyr.tidyverse.org/reference/duckdb_tibble.md).

For stingy duckplyr frames, accessing a column or requesting the number
of rows triggers an error. This is a good choice for large data sets
where the cost of materializing the data may be prohibitive due to size
or computation time, and the user wants to control when the computation
is carried out and where the results are stored. Results can be
materialized explicitly with
[`collect()`](https://dplyr.tidyverse.org/reference/compute.html) and
other functions.

Thrifty duckplyr frames are a compromise between lavish and stingy,
discussed further below.

### Example

Passing `prudence = "stingy"` to
[`as_duckdb_tibble()`](https://duckplyr.tidyverse.org/reference/duckdb_tibble.md)
creates a stingy duckplyr frame.

``` r
flights_stingy <-
  flights |>
  duckplyr::as_duckdb_tibble(prudence = "stingy")
```

The data can be displayed, and column names and types can be accessed.

``` r
flights_stingy
#> # A duckplyr data frame: 19 variables
#>     year month   day dep_time sched_dep_time dep_delay arr_time
#>    <int> <int> <int>    <int>          <int>     <dbl>    <int>
#>  1  2013     1     1      517            515         2      830
#>  2  2013     1     1      533            529         4      850
#>  3  2013     1     1      542            540         2      923
#>  4  2013     1     1      544            545        -1     1004
#>  5  2013     1     1      554            600        -6      812
#>  6  2013     1     1      554            558        -4      740
#>  7  2013     1     1      555            600        -5      913
#>  8  2013     1     1      557            600        -3      709
#>  9  2013     1     1      557            600        -3      838
#> 10  2013     1     1      558            600        -2      753
#> # ℹ more rows
#> # ℹ 12 more variables: sched_arr_time <int>, arr_delay <dbl>,
#> #   carrier <chr>, flight <int>, tailnum <chr>, origin <chr>,
#> #   dest <chr>, air_time <dbl>, distance <dbl>, hour <dbl>,
#> #   minute <dbl>, time_hour <dttm>

names(flights_stingy)[1:10]
#>  [1] "year"           "month"          "day"           
#>  [4] "dep_time"       "sched_dep_time" "dep_delay"     
#>  [7] "arr_time"       "sched_arr_time" "arr_delay"     
#> [10] "carrier"

class(flights_stingy)
#> [1] "prudent_duckplyr_df" "duckplyr_df"         "tbl_df"             
#> [4] "tbl"                 "data.frame"

class(flights_stingy[[1]])
#> [1] "integer"
```

On the other hand, accessing a column or requesting the number of rows
triggers an error:

``` r
nrow(flights_stingy)
#> Error:
#> ! Materialization is disabled, use `collect()` or `as_tibble()` to materialize.
#> ℹ Context: GetQueryResult

flights_stingy[[1]]
#> Error:
#> ! Materialization is disabled, use `collect()` or `as_tibble()` to materialize.
#> ℹ Context: GetQueryResult
```

This means that stingy duckplyr frames can also be used to enforce
DuckDB operation for a pipeline.

### Enforcing DuckDB operation

For operations not supported by duckplyr, the original dplyr
implementation is used as a fallback. As the original dplyr
implementation accesses columns directly, the data must be materialized
before a fallback can be executed. Therefore, stingy frames allow you to
check that all operations are supported by DuckDB: for a stingy frame,
fallbacks to dplyr are not possible.

``` r
flights_stingy |>
  group_by(origin) |>
  summarize(n = n()) |>
  ungroup()
#> Error in `group_by()`:
#> ! This operation cannot be carried out by DuckDB, and the input
#>   is a stingy duckplyr frame.
#> • Try `summarise(.by = ...)` or `mutate(.by = ...)` instead of
#>   `group_by()` and `ungroup()`.
#> ℹ Use `compute(prudence = "lavish")` to materialize to temporary
#>   storage and continue with duckplyr.
#> ℹ See `vignette("prudence")` for other options.
```

The same pipeline with a lavish frame works, but the computation is
carried out by dplyr:

``` r
flights_stingy |>
  duckplyr::as_duckdb_tibble(prudence = "lavish") |>
  group_by(origin) |>
  summarize(n = n()) |>
  ungroup()
#> # A tibble: 3 × 2
#>   origin      n
#>   <chr>   <int>
#> 1 EWR    120835
#> 2 JFK    111279
#> 3 LGA    104662
```

By using operations supported by duckplyr and avoiding fallbacks as much
as possible, your pipelines will be executed by DuckDB in an optimized
way.

### From stingy to lavish

A stingy duckplyr frame can be converted to a lavish one with
`as_duckdb_tibble(prudence = "lavish")`. The
[`collect.duckplyr_df()`](https://duckplyr.tidyverse.org/reference/collect.duckplyr_df.md)
method triggers computation and converts to a plain tibble. The
difference between the two is the class of the returned object:

``` r
flights_stingy |>
  duckplyr::as_duckdb_tibble(prudence = "lavish") |>
  class()
#> [1] "duckplyr_df" "tbl_df"      "tbl"         "data.frame"

flights_stingy |>
  collect() |>
  class()
#> [1] "tbl_df"     "tbl"        "data.frame"
```

The same behavior is achieved with
[`as_tibble()`](https://tibble.tidyverse.org/reference/as_tibble.html)
and [`as.data.frame()`](https://rdrr.io/r/base/as.data.frame.html):

``` r
flights_stingy |>
  as_tibble() |>
  class()
#> [1] "tbl_df"     "tbl"        "data.frame"

flights_stingy |>
  as.data.frame() |>
  class()
#> [1] "data.frame"
```

### Comparison

Stingy duckplyr frames behave like lazy tables in dbplyr and lazy frames
in dtplyr: the computation only starts when you *explicitly* request it
with
[`collect.duckplyr_df()`](https://duckplyr.tidyverse.org/reference/collect.duckplyr_df.md)
or through other means. However, stingy duckplyr frames can be converted
to lavish ones at any time, and vice versa. In dtplyr and dbplyr, there
are no lavish frames: collection always needs to be explicit.

## Thrift

Thrifty is a compromise between stingy and lavish. Materialization is
allowed for data up to a certain size, measured in cells (values) and
rows in the resulting data frame.

``` r
nrow(flights)
#> [1] 336776
flights_partial <-
  flights |>
  duckplyr::as_duckdb_tibble(prudence = "thrifty")
```

With this setting, the data is materialized only if the result has fewer
than 1,000,000 cells (rows multiplied by columns).

``` r
flights_partial |>
  select(origin, dest, dep_delay, arr_delay) |>
  nrow()
#> Error:
#> ! Materialization would result in more than 250000 rows. Use `collect()` or `as_tibble()` to materialize.
#> ℹ Context: GetQueryResult
```

The original input is too large to be materialized, so the operation
fails. On the other hand, the result after aggregation is small enough
to be materialized:

``` r
flights_partial |>
  count(origin) |>
  nrow()
#> [1] 3
```

Thrifty is a good choice for data sets where the cost of materializing
the data is prohibitive only for large results.

### File ingestion and custom limits

Thrifty is the default for the ingestion functions like
[`read_parquet_duckdb()`](https://duckplyr.tidyverse.org/reference/read_parquet_duckdb.md).
Here, the limit is adapted depending on the source of the data:

- For local files, the limit is 1,000,000 cells.
- For remote files (if the file name starts with a URL protocol
  specifier), the limit is 1,000 cells.

A custom limit can be set by passing a named vector to `prudence`, with
elements `cells` and/or `rows`:

``` r
read_parquet_duckdb(
  "personas.parquet",
  prudence = c(cells = 10000, rows = 1000)
)
```

## Conclusion

The duckplyr package provides

- a drop-in replacement for duckplyr, which necessitates “eager” data
  frames that automatically materialize like in dplyr,
- optimization by DuckDB, which means “lazy” evaluation where the data
  is materialized at the latest possible stage.

Automatic materialization can be dangerous for memory with large data,
so duckplyr provides a setting called `prudence` that controls automatic
materialization: is the data automatically materialized *always*
(“lavish” frames), *never* (“stingy” frames) or *up to a certain size*
(“thrifty” frames).

See
[`vignette("large")`](https://duckplyr.tidyverse.org/articles/large.md)
for more details on working with large data sets,
[`vignette("fallback")`](https://duckplyr.tidyverse.org/articles/fallback.md)
for fallbacks to dplyr,
[`vignette("limits")`](https://duckplyr.tidyverse.org/articles/limits.md)
for the operations supported by duckplyr, and
[`vignette("duckdb")`](https://duckplyr.tidyverse.org/articles/duckdb.md)
for using DuckDB functions directly.
