# Large data

Working with large datasets in R can be challenging, especially when
performance and memory constraints are a concern. The duckplyr package,
built on top of DuckDB, offers a powerful solution by enabling efficient
data manipulation using familiar dplyr syntax. This article explores
strategies for handling large datasets with duckplyr, covering
ingestion, materialization of intermediate and final results, and good
practice.

``` r
library(conflicted)
library(duckplyr)
#> Loading required package: dplyr
#> ✔ Overwriting dplyr methods with duckplyr methods.
#> ℹ Turn off with `duckplyr::methods_restore()`.
conflict_prefer("filter", "dplyr")
#> [conflicted] Will prefer dplyr::filter
#> over any other package.
```

## Introduction

Data frames and other objects in R are stored in RAM. This can become
problematic:

- Data must be loaded into RAM first, even if only part of it is needed.
- Data must be stored in RAM, even if it is not used.
- RAM is limited, and data sets can be larger than the available RAM.

A variety of tools have been developed to work with large data sets,
also in R. One example is the dbplyr package, a dplyr backend that
connects to SQL databases and is designed to work with various databases
that support SQL. This is a viable approach if the data is already
stored in a database, or if the data is stored in Parquet or CSV files
and loaded as a lazy table via
[`duckdb::tbl_file()`](https://r.duckdb.org/reference/backend-duckdb.html).

The dbplyr package translates dplyr code to SQL. The syntax and
semantics are very similar, but not identical to plain dplyr. In
contrast, the duckplyr package aims to be a fully compatible drop-in
replacement for dplyr, with *exactly* the same syntax and semantics:

- Input and output are data frames or tibbles.
- All dplyr verbs are supported, with fallback.
- All R data types and functions are supported, with fallback.
- No SQL is generated, instead, DuckDB’s “relational” interface is used.

Full compatibility means fewer surprises and less cognitive load for the
user. With DuckDB as the backend, duckplyr can also handle large data
sets that do not fit into RAM, keeping full dplyr compatibility. The
tools for bringing data into and out of R memory are modeled after the
dplyr and dbplyr packages, and are described in the following sections.

See
[`vignette("prudence")`](https://duckplyr.tidyverse.org/dev/articles/prudence.md)
on eager and lazy data,
[`vignette("limits")`](https://duckplyr.tidyverse.org/dev/articles/limits.md)
for limitations in the translation employed by duckplyr,
[`vignette("duckdb")`](https://duckplyr.tidyverse.org/dev/articles/duckdb.md)
for a way to overcome these limitations, and
[`vignette("fallback")`](https://duckplyr.tidyverse.org/dev/articles/fallback.md)
for more information on fallback.

## To duckplyr

The
[`duckdb_tibble()`](https://duckplyr.tidyverse.org/dev/reference/duckdb_tibble.md)
function creates a duckplyr data frame from vectors:

``` r
df <- duckdb_tibble(x = 1:3, y = letters[1:3])
df
#> # A duckplyr data frame: 2 variables
#>       x y    
#>   <int> <chr>
#> 1     1 a    
#> 2     2 b    
#> 3     3 c
```

The
[`duckdb_tibble()`](https://duckplyr.tidyverse.org/dev/reference/duckdb_tibble.md)
function is a drop-in replacement for
[`tibble()`](https://tibble.tidyverse.org/reference/tibble.html), and
can be used in the same way.

Similarly,
[`as_duckdb_tibble()`](https://duckplyr.tidyverse.org/dev/reference/duckdb_tibble.md)
can be used to convert a data frame or another object to a duckplyr data
frame:

``` r
flights_df() |>
  as_duckdb_tibble()
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
```

Existing code that uses DuckDB via dbplyr can also take advantage. The
following code creates a DuckDB connection and writes a data frame to a
table:

``` r
path_duckdb <- tempfile(fileext = ".duckdb")
con <- DBI::dbConnect(duckdb::duckdb(path_duckdb))
DBI::dbWriteTable(con, "data", data.frame(x = 1:3, y = letters[1:3]))

dbplyr_data <- tbl(con, "data")
dbplyr_data
#> # Source:   table<"data"> [?? x 2]
#> # Database: DuckDB 1.4.4 [unknown@Linux 6.14.0-1017-azure:R 4.5.2//tmp/Rtmpc1wMi7/file3dff6e0adaef.duckdb]
#>       x y    
#>   <int> <chr>
#> 1     1 a    
#> 2     2 b    
#> 3     3 c

dbplyr_data |>
  explain()
#> <SQL>
#> SELECT *
#> FROM "data"
#> 
#> <PLAN>
#> physical_plan
#> ┌---------------------------┐
#> │         SEQ_SCAN          │
#> │    --------------------   │
#> │        Table: data        │
#> │   Type: Sequential Scan   │
#> │                           │
#> │        Projections:       │
#> │             x             │
#> │             y             │
#> │                           │
#> │          ~3 rows          │
#> └---------------------------┘
```

The [`explain()`](https://dplyr.tidyverse.org/reference/explain.html)
output shows that the data is actually coming from a DuckDB table. The
[`as_duckdb_tibble()`](https://duckplyr.tidyverse.org/dev/reference/duckdb_tibble.md)
function can then be used to seamlessly convert the data to a duckplyr
frame:

``` r
dbplyr_data |>
  as_duckdb_tibble()
#> # A duckplyr data frame: 2 variables
#>       x y    
#>   <int> <chr>
#> 1     1 a    
#> 2     2 b    
#> 3     3 c

dbplyr_data |>
  as_duckdb_tibble() |>
  explain()
#> ┌---------------------------┐
#> │         SEQ_SCAN          │
#> │    --------------------   │
#> │        Table: data        │
#> │   Type: Sequential Scan   │
#> │                           │
#> │        Projections:       │
#> │             x             │
#> │             y             │
#> │                           │
#> │          ~3 rows          │
#> └---------------------------┘
```

This only works for DuckDB connections. For other databases, turn the
data into an R data frame or export it to a file before using
[`as_duckdb_tibble()`](https://duckplyr.tidyverse.org/dev/reference/duckdb_tibble.md).

``` r
DBI::dbDisconnect(con)
```

For other common cases, the
[`duckdb_tibble()`](https://duckplyr.tidyverse.org/dev/reference/duckdb_tibble.md)
function fails with a helpful error message:

- duckplyr does not support
  [`group_by()`](https://dplyr.tidyverse.org/reference/group_by.html):

``` r
duckdb_tibble(a = 1) |>
  group_by(a) |>
  as_duckdb_tibble()
#> Error in `as_duckdb_tibble()` at duckplyr/R/ducktbl.R:84:3:
#> ! duckplyr does not support `group_by()`.
#> ℹ Use `.by` instead.
#> ℹ To proceed with dplyr, use `as_tibble()` or `as.data.frame()`.
```

- duckplyr does not support
  [`rowwise()`](https://dplyr.tidyverse.org/reference/rowwise.html):

``` r
duckdb_tibble(a = 1) |>
  rowwise() |>
  as_duckdb_tibble()
#> Error in `as_duckdb_tibble()` at duckplyr/R/ducktbl.R:84:3:
#> ! duckplyr does not support `rowwise()`.
#> ℹ To proceed with dplyr, use `as_tibble()` or `as.data.frame()`.
```

- Use
  [`read_csv_duckdb()`](https://duckplyr.tidyverse.org/dev/reference/read_csv_duckdb.md)
  to read with the built-in reader:

``` r
readr::read_csv("a\n1", show_col_types = FALSE) |>
  as_duckdb_tibble()
#> Warning: The `file` argument of `read_csv()` should use `I()` for literal data
#> as of readr 2.2.0.
#>   
#>   # Bad (for example):
#>   read_csv("x,y\n1,2")
#>   
#>   # Good:
#>   read_csv(I("x,y\n1,2"))
#> This warning is displayed once per session.
#> Call `lifecycle::last_lifecycle_warnings()` to see where this warning
#> was generated.
#> Error in `as_duckdb_tibble()` at duckplyr/R/ducktbl.R:84:3:
#> ! The input is data read by readr, and duckplyr supports
#>   reading CSV files directly.
#> ℹ Use `read_csv_duckdb()` to read with the built-in reader.
#> ℹ To proceed with the data as read by readr, use `as_tibble()` before
#>   `as_duckdb_tibble()`.
```

In all cases,
[`as_tibble()`](https://tibble.tidyverse.org/reference/as_tibble.html)
can be used to proceed with the existing code.

## From files

DuckDB supports data ingestion from CSV, Parquet, and JSON files. The
[`read_csv_duckdb()`](https://duckplyr.tidyverse.org/dev/reference/read_csv_duckdb.md)
function accepts a file path and returns a duckplyr frame.

``` r
path_csv_1 <- tempfile(fileext = ".csv")
writeLines("x,y\n1,a\n2,b\n3,c", path_csv_1)
read_csv_duckdb(path_csv_1)
#> # A duckplyr data frame: 2 variables
#>       x y    
#>   <dbl> <chr>
#> 1     1 a    
#> 2     2 b    
#> 3     3 c
```

Reading multiple files is also supported:

``` r
path_csv_2 <- tempfile(fileext = ".csv")
writeLines("x,y\n4,d\n5,e\n6,f", path_csv_2)
read_csv_duckdb(c(path_csv_1, path_csv_2))
#> # A duckplyr data frame: 2 variables
#>       x y    
#>   <dbl> <chr>
#> 1     1 a    
#> 2     2 b    
#> 3     3 c    
#> 4     4 d    
#> 5     5 e    
#> 6     6 f
```

The `options` argument can be used to control the reading.

Similarly, the
[`read_parquet_duckdb()`](https://duckplyr.tidyverse.org/dev/reference/read_parquet_duckdb.md)
and
[`read_json_duckdb()`](https://duckplyr.tidyverse.org/dev/reference/read_json_duckdb.md)
functions can be used to read Parquet and JSON files, respectively.

For reading from HTTPS or S3 URLs, the [httpfs
extension](https://duckdb.org/docs/extensions/httpfs/overview.html) must
be installed and loaded in each session.

``` r
db_exec("INSTALL httpfs")
db_exec("LOAD httpfs")
```

Installation is fast if the extension is already installed. Once loaded,
the
[`read_csv_duckdb()`](https://duckplyr.tidyverse.org/dev/reference/read_csv_duckdb.md),
[`read_parquet_duckdb()`](https://duckplyr.tidyverse.org/dev/reference/read_parquet_duckdb.md),
and
[`read_json_duckdb()`](https://duckplyr.tidyverse.org/dev/reference/read_json_duckdb.md)
functions can be used with URLs:

``` r
url <- "https://blobs.duckdb.org/flight-data-partitioned/Year=2024/data_0.parquet"
flights_parquet <- read_parquet_duckdb(url)
flights_parquet
#> # A duckplyr data frame: 110 variables
#>     Year Quarter Month DayofMonth DayOfWeek FlightDate
#>    <dbl>   <dbl> <dbl>      <dbl>     <dbl> <date>    
#>  1  2024       1     1          8         1 2024-01-08
#>  2  2024       1     1          9         2 2024-01-09
#>  3  2024       1     1         10         3 2024-01-10
#>  4  2024       1     1         11         4 2024-01-11
#>  5  2024       1     1         12         5 2024-01-12
#>  6  2024       1     1         15         1 2024-01-15
#>  7  2024       1     1         16         2 2024-01-16
#>  8  2024       1     1         17         3 2024-01-17
#>  9  2024       1     1         18         4 2024-01-18
#> 10  2024       1     1         19         5 2024-01-19
#> # ℹ more rows
#> # ℹ 104 more variables: Reporting_Airline <chr>,
#> #   DOT_ID_Reporting_Airline <dbl>, IATA_CODE_Reporting_Airline <chr>,
#> #   Tail_Number <chr>, Flight_Number_Reporting_Airline <dbl>,
#> #   OriginAirportID <dbl>, OriginAirportSeqID <dbl>,
#> #   OriginCityMarketID <dbl>, Origin <chr>, OriginCityName <chr>,
#> #   OriginState <chr>, OriginStateFips <chr>, OriginStateName <chr>, …
```

In all cases, the data is read lazily: only the metadata is read
initially, and the data is read as required. This means that data can be
read from files that are larger than the available RAM. The Parquet
format is particularly efficient for this purpose, as it stores data in
a columnar format and allows reading only the columns that are required.
See
[`vignette("prudence")`](https://duckplyr.tidyverse.org/dev/articles/prudence.md)
for more details on the concept of lazy data.

## From DuckDB

In addition to
[`as_duckdb_tibble()`](https://duckplyr.tidyverse.org/dev/reference/duckdb_tibble.md),
arbitrary DuckDB queries can be executed and the result can be converted
to a duckplyr frame. For this,
[attach](https://duckdb.org/docs/sql/statements/attach.html) an existing
DuckDB database first:

``` r
sql_attach <- paste0(
  "ATTACH DATABASE '",
  path_duckdb,
  "' AS external (READ_ONLY)"
)
db_exec(sql_attach)
```

Then, use
[`read_sql_duckdb()`](https://duckplyr.tidyverse.org/dev/reference/read_sql_duckdb.md)
to execute a query and return a duckplyr frame:

``` r
read_sql_duckdb("SELECT * FROM external.data")
#> # A duckplyr data frame: 2 variables
#>       x y    
#>   <int> <chr>
#> 1     1 a    
#> 2     2 b    
#> 3     3 c
```

## Materialization

In dbplyr,
[`compute()`](https://dplyr.tidyverse.org/reference/compute.html) is
used to materialize a lazy table in a temporary table on the database,
and [`collect()`](https://dplyr.tidyverse.org/reference/compute.html) is
used to bring the data into R memory. This interface works exactly the
same in duckplyr:

``` r
simple_data <-
  duckdb_tibble(a = 1) |>
  mutate(b = 2)

simple_data |>
  explain()
#> ┌---------------------------┐
#> │         PROJECTION        │
#> │    --------------------   │
#> │             a             │
#> │             b             │
#> │                           │
#> │           ~1 row          │
#> └-------------┬-------------┘
#> ┌-------------┴-------------┐
#> │     R_DATAFRAME_SCAN      │
#> │    --------------------   │
#> │      Text: data.frame     │
#> │       Projections: a      │
#> │                           │
#> │           ~1 row          │
#> └---------------------------┘

simple_data_computed <-
  simple_data |>
  compute()
```

The
[`compute.duckplyr_df()`](https://duckplyr.tidyverse.org/dev/reference/compute.duckplyr_df.md)
function returns a duckplyr frame that is materialized in a temporary
table. The return value of the function is a duckplyr frame that can be
used in further computations. The materialization is done in a temporary
table, so the data is not persisted after the session ends:

``` r
simple_data_computed |>
  explain()
#> ┌---------------------------┐
#> │         SEQ_SCAN          │
#> │    --------------------   │
#> │           Table:          │
#> │    duckplyr_eexomb92Q9    │
#> │                           │
#> │   Type: Sequential Scan   │
#> │                           │
#> │        Projections:       │
#> │             a             │
#> │             b             │
#> │                           │
#> │           ~1 row          │
#> └---------------------------┘
```

The [`collect()`](https://dplyr.tidyverse.org/reference/compute.html)
function brings the data into R memory and returns a plain tibble:

``` r
duckdb_tibble(a = 1) |>
  mutate(b = 2) |>
  collect()
#> # A tibble: 1 × 2
#>       a     b
#>   <dbl> <dbl>
#> 1     1     2
```

## To files

To materialize data in a persistent file, the
[`compute_csv()`](https://duckplyr.tidyverse.org/dev/reference/compute_csv.md)
and
[`compute_parquet()`](https://duckplyr.tidyverse.org/dev/reference/compute_parquet.md)
functions can be used. The
[`compute_csv()`](https://duckplyr.tidyverse.org/dev/reference/compute_csv.md)
function writes the data to a CSV file:

``` r
path_csv_out <- tempfile(fileext = ".csv")
duckdb_tibble(a = 1) |>
  mutate(b = 2) |>
  compute_csv(path_csv_out)
#> # A duckplyr data frame: 2 variables
#>       a     b
#>   <dbl> <dbl>
#> 1     1     2

writeLines(readLines(path_csv_out))
#> a,b
#> 1.0,2.0
```

The
[`compute_parquet()`](https://duckplyr.tidyverse.org/dev/reference/compute_parquet.md)
function writes the data to a Parquet file:

``` r
path_parquet_out <- tempfile(fileext = ".parquet")
duckdb_tibble(a = 1) |>
  mutate(b = 2) |>
  compute_parquet(path_parquet_out) |>
  explain()
#> ┌---------------------------┐
#> │       READ_PARQUET        │
#> │    --------------------   │
#> │         Function:         │
#> │        READ_PARQUET       │
#> │                           │
#> │        Projections:       │
#> │             a             │
#> │             b             │
#> │                           │
#> │           ~1 row          │
#> └---------------------------┘
```

Just like with
[`compute.duckplyr_df()`](https://duckplyr.tidyverse.org/dev/reference/compute.duckplyr_df.md),
the return value of
[`compute_csv()`](https://duckplyr.tidyverse.org/dev/reference/compute_csv.md)
and
[`compute_parquet()`](https://duckplyr.tidyverse.org/dev/reference/compute_parquet.md)
is a duckplyr frame that uses the created CSV or Parquet file and can be
used in further computations. At the time of writing, direct JSON export
is not supported.

## Memory usage

Computations carried out by DuckDB allocate RAM in the context of the R
process. This memory separate from the memory used by R objects, and is
managed by DuckDB. Limit the memory used by DuckDB by setting a pragma
with
[`db_exec()`](https://duckplyr.tidyverse.org/dev/reference/db_exec.md):

``` r
read_sql_duckdb("SELECT current_setting('memory_limit') AS memlimit")
#> # A duckplyr data frame: 1 variable
#>   memlimit
#>   <chr>   
#> 1 12.4 GiB

db_exec("PRAGMA memory_limit = '1GB'")

read_sql_duckdb("SELECT current_setting('memory_limit') AS memlimit")
#> # A duckplyr data frame: 1 variable
#>   memlimit 
#>   <chr>    
#> 1 953.6 MiB
```

See [the DuckDB
documentation](https://duckdb.org/docs/configuration/overview.html) for
other configuration options.

## The big picture

The functions shown in this vignette allow the construction of data
transformation pipelines spanning multiple data sources and data that is
too large to fit into memory. Full compatibility with dplyr is provided,
so existing code can be used with duckplyr with minimal changes. The
lazy computation of duckplyr frames allows for efficient data
processing, as only the required data is read from disk. The
materialization functions allow the data to be persisted in temporary
tables or files, depending on the use case. A typical workflow might
look like this:

- Prepare all data sources as duckplyr frames: local data frames and
  files
- Combine the data sources using dplyr verbs
- Preview intermediate results as usual: the computation will be faster
  because only the first few rows are requested
- To avoid rerunning the whole pipeline all over, use
  [`compute.duckplyr_df()`](https://duckplyr.tidyverse.org/dev/reference/compute.duckplyr_df.md)
  or
  [`compute_parquet()`](https://duckplyr.tidyverse.org/dev/reference/compute_parquet.md)
  to materialize any intermediate result that is too large to fit into
  memory
- Collect the final result using
  [`collect.duckplyr_df()`](https://duckplyr.tidyverse.org/dev/reference/collect.duckplyr_df.md)
  or write it to a file using
  [`compute_csv()`](https://duckplyr.tidyverse.org/dev/reference/compute_csv.md)
  or
  [`compute_parquet()`](https://duckplyr.tidyverse.org/dev/reference/compute_parquet.md)

There is a caveat: due to the design of duckplyr, if a dplyr verb is not
supported or uses a function that is not supported, the data will be
read into memory before being processed further. By default, if the data
pipeline starts with an ingestion function, the data will only be read
into memory if it has less than 1 million cells or values in the table:

``` r
flights_parquet |>
  group_by(Month)
#> Error in `group_by()`:
#> ! This operation cannot be carried out by DuckDB, and the input
#>   is a stingy duckplyr frame.
#> • Try `summarise(.by = ...)` or `mutate(.by = ...)` instead of
#>   `group_by()` and `ungroup()`.
#> ℹ Use `compute(prudence = "lavish")` to materialize to temporary
#>   storage and continue with duckplyr.
#> ℹ See `vignette("prudence")` for other options.
```

Because
[`group_by()`](https://dplyr.tidyverse.org/reference/group_by.html) is
not supported, the data will be attempted to read into memory before the
[`group_by()`](https://dplyr.tidyverse.org/reference/group_by.html)
operation is executed. Once the data is small enough to fit into memory,
this works transparently.

``` r
flights_parquet |>
  count(Month, DayofMonth) |>
  group_by(Month)
#> # A tibble: 182 × 3
#> # Groups:   Month [6]
#>    Month DayofMonth     n
#>    <dbl>      <dbl> <int>
#>  1     1          1 17265
#>  2     1          2 18977
#>  3     1          3 18520
#>  4     1          4 18066
#>  5     1          5 18109
#>  6     1          6 16950
#>  7     1          7 18812
#>  8     1          8 18472
#>  9     1          9 16775
#> 10     1         10 16795
#> # ℹ 172 more rows
```

See
[`vignette("prudence")`](https://duckplyr.tidyverse.org/dev/articles/prudence.md)
for the concepts and mechanisms at play, and
[`vignette("fallback")`](https://duckplyr.tidyverse.org/dev/articles/fallback.md)
for a detailed explanation of the fallback mechanism.
