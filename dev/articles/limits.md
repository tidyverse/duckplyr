# Translations

This article describes the translations provided by duckplyr for
different data types, verbs, and functions within verbs. If a
translation is not provided, duckplyr falls back to dplyr, see
[`vignette("fallback")`](https://duckplyr.tidyverse.org/dev/articles/fallback.md)
for details. The translation layer can be bypassed, see
[`vignette("duckdb")`](https://duckplyr.tidyverse.org/dev/articles/duckdb.md)
for details.

``` r
library(conflicted)
library(dplyr)
conflict_prefer("filter", "dplyr")
#> [conflicted] Will prefer dplyr::filter
#> over any other package.
conflict_prefer("lag", "dplyr")
#> [conflicted] Will prefer dplyr::lag over
#> any other package.
```

## Data types

duckplyr supports the following data types:

- [`is.logical()`](https://rdrr.io/r/base/logical.html)
- [`is.integer()`](https://rdrr.io/r/base/integer.html)
- [`is.numeric()`](https://rdrr.io/r/base/numeric.html)
- [`is.character()`](https://rdrr.io/r/base/character.html)
- `is.Date()`
- `is.POSIXct()` (with UTC time zone)
- `is.difftime()`

``` r
duckplyr::duckdb_tibble(
  logical = TRUE,
  integer = 1L,
  numeric = 1.1,
  character = "a",
  Date = as.Date("2025-01-11"),
  POSIXct = as.POSIXct("2025-01-11 19:23:00", tz = "UTC"),
  difftime = as.difftime(1, units = "secs"),
) |>
  compute()
#> # A duckplyr data frame: 7 variables
#>   logical integer numeric character Date       POSIXct            
#>   <lgl>     <int>   <dbl> <chr>     <date>     <dttm>             
#> 1 TRUE          1     1.1 a         2025-01-11 2025-01-11 19:23:00
#> # ℹ 1 more variable: difftime <drtn>
```

Generally, zero-column tibbles are not supported by duckplyr, neither as
input nor as a result.

``` r
duckplyr::duckdb_tibble()
#> Error in `duckdb_rel_from_df()` at duckplyr/R/duckplyr_df.R:20:5:
#> ! rel_from_df: Can't convert empty data frame to relational.
duckplyr::duckdb_tibble(a = 1, .prudence = "stingy") |>
  select(-a)
#> Error in `select()`:
#> ! This operation cannot be carried out by DuckDB, and the input
#>   is a stingy duckplyr frame.
#> • Zero-column result set not supported.
#> ℹ Use `compute(prudence = "lavish")` to materialize to temporary
#>   storage and continue with duckplyr.
#> ℹ See `vignette("prudence")` for other options.
```

Support for more data types, and passthrough of unknown data types, is
planned. Let’s
[discuss](https://github.com/tidyverse/duckplyr/discussions/) any
additional data types you would like to see supported.

## Verbs

Not all dplyr verbs are implemented within duckplyr. For unsupported
verbs, duckplyr automatically falls back to dplyr. See
[`?unsupported`](https://duckplyr.tidyverse.org/dev/reference/unsupported.md)
for a list of verbs for which duckplyr does not provide a method.

See the [reference
index](https://duckplyr.tidyverse.org/reference/index.html) for a list
of verbs with corresponding duckplyr methods.

Let’s [discuss](https://github.com/tidyverse/duckplyr/discussions/) any
additional verbs you would like to see supported.

## Functions within verbs

For all functions used in dplyr verbs, translations must be provided. If
an expression contains a function for which no translation is provided,
duckplyr falls back to dplyr. With some exceptions, only positional
matching is implemented.

As of now, here are the translations provided:

### Parentheses

Implemented: `(`.

Reference: [`?Paren`](https://rdrr.io/r/base/Paren.html).

``` r
duckplyr::duckdb_tibble(a = 1, b = 2, c = 3, .prudence = "stingy") |>
  mutate((a + b) * c)
#> # A duckplyr data frame: 4 variables
#>       a     b     c `(a + b) * c`
#>   <dbl> <dbl> <dbl>         <dbl>
#> 1     1     2     3             9
```

### Comparison operators

Implemented: `>`, `>=`, `<`, `<=`, `==`, `!=`.

Reference: [`?Comparison`](https://rdrr.io/r/base/Comparison.html).

``` r
duckplyr::duckdb_tibble(
  a = c(1, 2, NA),
  b = c(2, NA, 3),
  c = c(NA, 3, 4),
  .prudence = "stingy"
) |>
  mutate(a > b, b != c, c < a, a >= b, b <= c)
#> # A duckplyr data frame: 8 variables
#>       a     b     c `a > b` `b != c` `c < a` `a >= b` `b <= c`
#>   <dbl> <dbl> <dbl> <lgl>   <lgl>    <lgl>   <lgl>    <lgl>   
#> 1     1     2    NA FALSE   NA       NA      FALSE    NA      
#> 2     2    NA     3 NA      NA       FALSE   NA       NA      
#> 3    NA     3     4 NA      TRUE     NA      NA       TRUE
```

### Basic arithmetics

Implemented: `+`, `-`, `*`, `/`.

Reference: [`?Arithmetic`](https://rdrr.io/r/base/Arithmetic.html).

``` r
duckplyr::duckdb_tibble(a = 1, b = 2, c = 3, .prudence = "stingy") |>
  mutate(a + b, a / b, a - b, a * b)
#> # A duckplyr data frame: 7 variables
#>       a     b     c `a + b` `a/b` `a - b` `a * b`
#>   <dbl> <dbl> <dbl>   <dbl> <dbl>   <dbl>   <dbl>
#> 1     1     2     3       3   0.5      -1       2
```

### Math functions

Implemented: [`log()`](https://rdrr.io/r/base/Log.html),
[`log10()`](https://rdrr.io/r/base/Log.html),
[`abs()`](https://rdrr.io/r/base/MathFun.html).

Reference: [`?Math`](https://rdrr.io/r/base/groupGeneric.html).

``` r
duckplyr::duckdb_tibble(a = 1, b = 2, c = -3, .prudence = "stingy") |>
  mutate(log10(a), log(b), abs(c))
#> # A duckplyr data frame: 6 variables
#>       a     b     c `log10(a)` `log(b)` `abs(c)`
#>   <dbl> <dbl> <dbl>      <dbl>    <dbl>    <dbl>
#> 1     1     2    -3          0    0.693        3
```

### Logical operators

Implemented: `!`, `&`, `|`.

Reference: [`?Logic`](https://rdrr.io/r/base/Logic.html).

``` r
duckplyr::duckdb_tibble(a = FALSE, b = TRUE, c = NA, .prudence = "stingy") |>
  mutate(!a, a & b, b | c)
#> # A duckplyr data frame: 6 variables
#>   a     b     c     `!a`  `a & b` `b | c`
#>   <lgl> <lgl> <lgl> <lgl> <lgl>   <lgl>  
#> 1 FALSE TRUE  NA    TRUE  FALSE   TRUE
```

### Branching and conversion

Implemented:

- [`is.na()`](https://rdrr.io/r/base/NA.html),
  [`as.integer()`](https://rdrr.io/r/base/integer.html)
- [`dplyr::if_else()`](https://dplyr.tidyverse.org/reference/if_else.html),
  [`dplyr::coalesce()`](https://dplyr.tidyverse.org/reference/coalesce.html)
- `strftime(x, format)`

``` r
duckplyr::duckdb_tibble(a = 1, b = NA, .prudence = "stingy") |>
  mutate(is.na(b), if_else(is.na(b), 0, 1), as.integer(b))
#> # A duckplyr data frame: 5 variables
#>       a b     `is.na(b)` `if_else(is.na(b), 0, 1)` `as.integer(b)`
#>   <dbl> <lgl> <lgl>                          <dbl>           <int>
#> 1     1 NA    TRUE                               0              NA

duckplyr::duckdb_tibble(
  a = as.POSIXct("2025-01-11 19:23:46", tz = "UTC"),
  .prudence = "stingy") |>
  mutate(strftime(a, "%H:%M:%S"))
#> # A duckplyr data frame: 2 variables
#>   a                   `strftime(a, "%H:%M:%S")`
#>   <dttm>              <chr>                    
#> 1 2025-01-11 19:23:46 19:23:46
```

### String manipulation

Implemented: [`grepl()`](https://rdrr.io/r/base/grep.html),
[`substr()`](https://rdrr.io/r/base/substr.html),
[`sub()`](https://rdrr.io/r/base/grep.html),
[`gsub()`](https://rdrr.io/r/base/grep.html).

``` r
duckplyr::duckdb_tibble(a = "abbc", .prudence = "stingy") |>
  mutate(grepl("b", a), substr(a, 2L, 3L), sub("b", "B", a), gsub("b", "B", a))
#> # A duckplyr data frame: 5 variables
#>   a     `grepl("b", a)` `substr(a, 2L, 3L)` `sub("b", "B", a)`
#>   <chr> <lgl>           <chr>               <chr>             
#> 1 abbc  TRUE            bbc                 aBbc              
#> # ℹ 1 more variable: `gsub("b", "B", a)` <chr>
```

### Date manipulation

Implemented:
[`lubridate::hour()`](https://lubridate.tidyverse.org/reference/hour.html),
[`lubridate::minute()`](https://lubridate.tidyverse.org/reference/minute.html),
[`lubridate::second()`](https://lubridate.tidyverse.org/reference/second.html),
[`lubridate::wday()`](https://lubridate.tidyverse.org/reference/day.html).

``` r
duckplyr::duckdb_tibble(
  a = as.POSIXct("2025-01-11 19:23:46", tz = "UTC"),
  .prudence = "stingy"
) |>
  mutate(
    hour = lubridate::hour(a),
    minute = lubridate::minute(a),
    second = lubridate::second(a),
    wday = lubridate::wday(a)
  )
#> # A duckplyr data frame: 5 variables
#>   a                    hour minute second  wday
#>   <dttm>              <dbl>  <dbl>  <dbl> <int>
#> 1 2025-01-11 19:23:46    19     23     46     7
```

### Aggregation

Implemented:

- `sum(x, na.rm)`,
  [`dplyr::n()`](https://dplyr.tidyverse.org/reference/context.html),
  [`dplyr::n_distinct()`](https://dplyr.tidyverse.org/reference/n_distinct.html)
- `mean(x, na.rm)`, `median(x, na.rm)`, `sd(x, na.rm)`
- [`min()`](https://rdrr.io/r/base/Extremes.html),
  [`max()`](https://rdrr.io/r/base/Extremes.html),
  [`any()`](https://rdrr.io/r/base/any.html),
  [`all()`](https://rdrr.io/r/base/all.html)

``` r
duckplyr::duckdb_tibble(a = 1:3, b = c(1, 2, 2), .prudence = "stingy") |>
  summarize(
    sum(a),
    n(),
    n_distinct(b),
  )
#> # A duckplyr data frame: 3 variables
#>   `sum(a)` `n()` `n_distinct(b)`
#>      <dbl> <int>           <dbl>
#> 1        6     3               2

duckplyr::duckdb_tibble(a = 1:3, b = c(1, 2, NA), .prudence = "stingy") |>
  summarize(
    mean(b, na.rm = TRUE),
    median(a),
    sd(b),
  )
#> # A duckplyr data frame: 3 variables
#>   `mean(b, na.rm = TRUE)` `median(a)` `sd(b)`
#>                     <dbl>       <dbl>   <dbl>
#> 1                     1.5           2      NA

duckplyr::duckdb_tibble(a = 1:3, .prudence = "stingy") |>
  summarize(
    min(a),
    max(a),
    any(a > 1),
    all(a > 1),
  )
#> # A duckplyr data frame: 4 variables
#>   `min(a)` `max(a)` `any(a > 1)` `all(a > 1)`
#>      <int>    <int> <lgl>        <lgl>       
#> 1        1        3 TRUE         FALSE
```

### Shifting

All optional arguments to
[`dplyr::lag()`](https://dplyr.tidyverse.org/reference/lead-lag.html)
and
[`dplyr::lead()`](https://dplyr.tidyverse.org/reference/lead-lag.html)
are supported.

``` r
duckplyr::duckdb_tibble(a = 1:3, .prudence = "stingy") |>
  mutate(lag(a), lead(a))
#> # A duckplyr data frame: 3 variables
#>       a `lag(a)` `lead(a)`
#>   <int>    <int>     <int>
#> 1     1       NA         2
#> 2     2        1         3
#> 3     3        2        NA
duckplyr::duckdb_tibble(a = 1:3, .prudence = "stingy") |>
  mutate(lag(a, 2), lead(a, n = 2))
#> # A duckplyr data frame: 3 variables
#>       a `lag(a, 2)` `lead(a, n = 2)`
#>   <int>       <int>            <int>
#> 1     1          NA                3
#> 2     2          NA               NA
#> 3     3           1               NA
duckplyr::duckdb_tibble(a = 1:3, .prudence = "stingy") |>
  mutate(lag(a, default = 0), lead(a, default = 4))
#> # A duckplyr data frame: 3 variables
#>       a `lag(a, default = 0)` `lead(a, default = 4)`
#>   <int>                 <int>                  <int>
#> 1     1                     0                      2
#> 2     2                     1                      3
#> 3     3                     2                      4
duckplyr::duckdb_tibble(a = 1:3, b = c(2, 3, 1), .prudence = "stingy") |>
  mutate(lag(a, order_by = b), lead(a, order_by = b))
#> # A duckplyr data frame: 4 variables
#>       a     b `lag(a, order_by = b)` `lead(a, order_by = b)`
#>   <int> <dbl>                  <int>                   <int>
#> 1     3     1                     NA                       1
#> 2     1     2                      3                       2
#> 3     2     3                      1                      NA
```

### Ranking

[Ranking in
DuckDB](https://duckdb.org/docs/sql/functions/window_functions.html) is
very different from dplyr. Most functions in DuckDB rank only by the
current row number, whereas in dplyr, ranking is done by a column. It
will be difficult to provide translations for the following ranking
functions.

- [`rank()`](https://rdrr.io/r/base/rank.html),
  [`dplyr::min_rank()`](https://dplyr.tidyverse.org/reference/row_number.html),
  [`dplyr::dense_rank()`](https://dplyr.tidyverse.org/reference/row_number.html)
- [`dplyr::percent_rank()`](https://dplyr.tidyverse.org/reference/percent_rank.html),
  [`dplyr::cume_dist()`](https://dplyr.tidyverse.org/reference/percent_rank.html)

Implementing
[`dplyr::ntile()`](https://dplyr.tidyverse.org/reference/ntile.html) is
feasible for the `n` argument. The only ranking function currently
implemented is
[`dplyr::row_number()`](https://dplyr.tidyverse.org/reference/row_number.html).

``` r
duckplyr::duckdb_tibble(a = c(1, 2, 2, 3), .prudence = "stingy") |>
  mutate(row_number())
#> # A duckplyr data frame: 2 variables
#>       a `row_number()`
#>   <dbl>          <int>
#> 1     1              1
#> 2     2              2
#> 3     2              3
#> 4     3              4
```

### Special cases

`$` ([`?Extract`](https://rdrr.io/r/base/Extract.html)) is implemented
if the LHS is `.data` or `.env`:

``` r
b <- 4
duckplyr::duckdb_tibble(a = 1, b = 2, .prudence = "stingy") |>
  mutate(.data$a + .data$b, .env$b)
#> # A duckplyr data frame: 4 variables
#>       a     b `.data$a + .data$b` `.env$b`
#>   <dbl> <dbl>               <dbl>    <dbl>
#> 1     1     2                   3        4
```

`%in%` ([`?match`](https://rdrr.io/r/base/match.html)) is implemented if
the RHS is a constant with up to 100 values:

``` r
duckplyr::duckdb_tibble(a = 1:3, .prudence = "stingy") |>
  mutate(a %in% c(1, 3)) |>
  collect()
#> # A tibble: 3 × 2
#>       a `a %in% c(1, 3)`
#>   <int> <lgl>           
#> 1     1 TRUE            
#> 2     2 FALSE           
#> 3     3 TRUE
duckplyr::last_rel()
#> DuckDB Relation: 
#> ---------------------
#> --- Relation Tree ---
#> ---------------------
#> Projection [a as a, ___coalesce("|"("r_base::=="(a, 1.0), "r_base::=="(a, 3.0)), false) as a %in% c(1, 3)]
#>   r_dataframe_scan(0xdeadbeef)
#> 
#> ---------------------
#> -- Result Columns  --
#> ---------------------
#> - a (INTEGER)
#> - a %in% c(1, 3) (BOOLEAN)
```

[`dplyr::desc()`](https://dplyr.tidyverse.org/reference/desc.html) is
only implemented in the context of
[`dplyr::arrange()`](https://dplyr.tidyverse.org/reference/arrange.html):

``` r
duckplyr::duckdb_tibble(a = 1:3, .prudence = "stingy") |>
  arrange(desc(a)) |>
  explain()
#> ┌---------------------------┐
#> │          ORDER_BY         │
#> │    --------------------   │
#> │      dataframe_42_42      │
#> │       4391854.a DESC      │
#> └-------------┬-------------┘
#> ┌-------------┴-------------┐
#> │     R_DATAFRAME_SCAN      │
#> │    --------------------   │
#> │      Text: data.frame     │
#> │       Projections: a      │
#> │                           │
#> │          ~3 rows          │
#> └---------------------------┘
```

[`suppressWarnings()`](https://rdrr.io/r/base/warning.html) is a no-op:

``` r
duckplyr::duckdb_tibble(a = 1, .prudence = "stingy") |>
  mutate(suppressWarnings(a + 1))
#> # A duckplyr data frame: 2 variables
#>       a `suppressWarnings(a + 1)`
#>   <dbl>                     <dbl>
#> 1     1                         2
```

### Contributing

Refer to [our contributing
guide](https://duckplyr.tidyverse.org/CONTRIBUTING.html#new-translations-for-functions)
to learn how to contribute new translations to the package. Ideally,
duckplyr will also support adding custom translations for functions for
the duration of the current R session.

## Known incompatibilities

This section tracks known incompatibilities between dplyr and duckplyr.
Changing these is likely to require substantial effort, and might be
best addressed by providing new functions with consistent behavior in
both dplyr and DuckDB.

### Output order stability

DuckDB does not guarantee order stability for the output. For
performance reasons, duckplyr does not enable output order stability by
default.

``` r
duckplyr::flights_df() |>
  duckplyr::as_duckdb_tibble() |>
  distinct(day) |>
  summarize(paste(day, collapse = " ")) # fallback
#> # A duckplyr data frame: 1 variable
#>   `paste(day, collapse = " ")`                                         
#>   <chr>                                                                
#> 1 1 7 8 13 19 21 25 27 2 10 18 28 29 5 9 11 14 15 16 17 22 26 30 31 3 …

duckplyr::flights_df() |>
  distinct(day) |>
  summarize(paste(day, collapse = " "))
#> # A tibble: 1 × 1
#>   `paste(day, collapse = " ")`                                         
#>   <chr>                                                                
#> 1 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26…
```

This can be changed globally with the `DUCKPLYR_OUTPUT_ORDER`
environment variable, see
[`?config`](https://duckplyr.tidyverse.org/dev/reference/config.md) for
details. With this setting, the output order is stable, but the plans
are more complicated, and DuckDB needs to do more work.

``` r
duckplyr::flights_df() |>
  duckplyr::as_duckdb_tibble() |>
  distinct(day) |>
  explain()
#> ┌---------------------------┐
#> │       HASH_GROUP_BY       │
#> │    --------------------   │
#> │         Groups: #0        │
#> │                           │
#> │       ~336,776 rows       │
#> └-------------┬-------------┘
#> ┌-------------┴-------------┐
#> │         PROJECTION        │
#> │    --------------------   │
#> │            day            │
#> │                           │
#> │       ~336,776 rows       │
#> └-------------┬-------------┘
#> ┌-------------┴-------------┐
#> │     R_DATAFRAME_SCAN      │
#> │    --------------------   │
#> │      Text: data.frame     │
#> │      Projections: day     │
#> │                           │
#> │       ~336,776 rows       │
#> └---------------------------┘

withr::with_envvar(
  c(DUCKPLYR_OUTPUT_ORDER = "TRUE"),
  duckplyr::flights_df() |>
    duckplyr::as_duckdb_tibble() |>
    distinct(day) |>
    explain()
)
#> ┌---------------------------┐
#> │          ORDER_BY         │
#> │    --------------------   │
#> │      dataframe_42_42      │
#> │ 42.___row_number ASC│
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
#> │   (___row_number_by = 1)  │
#> │                           │
#> │        ~67,355 rows       │
#> └-------------┬-------------┘
#> ┌-------------┴-------------┐
#> │         PROJECTION        │
#> │    --------------------   │
#> │             #0            │
#> │             #1            │
#> │             #2            │
#> │                           │
#> │       ~336,776 rows       │
#> └-------------┬-------------┘
#> ┌-------------┴-------------┐
#> │           WINDOW          │
#> │    --------------------   │
#> │        Projections:       │
#> │     ROW_NUMBER() OVER     │
#> │ (PARTITION BY day ORDER BY│
#> │   ___row_number ASC NULLS │
#> │            LAST)          │
#> └-------------┬-------------┘
#> ┌-------------┴-------------┐
#> │         PROJECTION        │
#> │    --------------------   │
#> │             #0            │
#> │             #1            │
#> │                           │
#> │       ~336,776 rows       │
#> └-------------┬-------------┘
#> ┌-------------┴-------------┐
#> │      STREAMING_WINDOW     │
#> │    --------------------   │
#> │        Projections:       │
#> │    ROW_NUMBER() OVER ()   │
#> └-------------┬-------------┘
#> ┌-------------┴-------------┐
#> │     R_DATAFRAME_SCAN      │
#> │    --------------------   │
#> │      Text: data.frame     │
#> │      Projections: day     │
#> │                           │
#> │       ~336,776 rows       │
#> └---------------------------┘
```

### `sum()`

In duckplyr, this function returns a numeric value also for integers,
due to DuckDB’s type stability requirement.

``` r
duckplyr::duckdb_tibble(a = 1:100) |>
  summarize(sum(a))
#> # A duckplyr data frame: 1 variable
#>   `sum(a)`
#>      <dbl>
#> 1     5050

duckplyr::duckdb_tibble(a = 1:1000000) |>
  summarize(sum(a))
#> # A duckplyr data frame: 1 variable
#>       `sum(a)`
#>          <dbl>
#> 1 500000500000

tibble(a = 1:100) |>
  summarize(sum(a))
#> # A tibble: 1 × 1
#>   `sum(a)`
#>      <int>
#> 1     5050

tibble(a = 1:1000000) |>
  summarize(sum(a))
#> # A tibble: 1 × 1
#>       `sum(a)`
#>          <dbl>
#> 1 500000500000
```

### Empty vectors in aggregate functions

At the time of writing, empty vectors only occur when summarizing an
empty table without grouping. In all cases, duckplyr returns `NA`, and
the behavior of dplyr is different:

- [`sum()`](https://rdrr.io/r/base/sum.html) for an empty vector returns
  `0`
- [`any()`](https://rdrr.io/r/base/any.html) and
  [`all()`](https://rdrr.io/r/base/all.html) return `FALSE`
- [`min()`](https://rdrr.io/r/base/Extremes.html) and
  [`max()`](https://rdrr.io/r/base/Extremes.html) return infinity values
  (with a warning)

``` r
duckplyr::duckdb_tibble(a = integer(), b = logical()) |>
  summarize(sum(a), any(b), all(b), min(a), max(a))
#> # A duckplyr data frame: 5 variables
#>   `sum(a)` `any(b)` `all(b)` `min(a)` `max(a)`
#>      <dbl> <lgl>    <lgl>       <int>    <int>
#> 1       NA NA       NA             NA       NA
tibble(a = integer(), b = logical()) |>
  summarize(sum(a), any(b), all(b), min(a), max(a))
#> Warning: There were 2 warnings in `summarize()`.
#> The first warning was:
#> ℹ In argument: `min(a)`.
#> Caused by warning in `min()`:
#> ! no non-missing arguments to min; returning Inf
#> ℹ Run `dplyr::last_dplyr_warnings()` to see the 1 remaining warning.
#> # A tibble: 1 × 5
#>   `sum(a)` `any(b)` `all(b)` `min(a)` `max(a)`
#>      <int> <lgl>    <lgl>       <dbl>    <dbl>
#> 1        0 FALSE    TRUE          Inf     -Inf
```

### `min()` and `max()` for logical input

For completeness, duckplyr returns a logical for
[`min()`](https://rdrr.io/r/base/Extremes.html) and
[`max()`](https://rdrr.io/r/base/Extremes.html) when the input is
logical, while dplyr returns an integer.

``` r
duckplyr::duckdb_tibble(a = c(TRUE, FALSE)) |>
  summarize(min(a), max(a))
#> # A duckplyr data frame: 2 variables
#>   `min(a)` `max(a)`
#>   <lgl>    <lgl>   
#> 1 FALSE    TRUE

tibble(a = c(TRUE, FALSE)) |>
  summarize(min(a), max(a))
#> # A tibble: 1 × 2
#>   `min(a)` `max(a)`
#>      <int>    <int>
#> 1        0        1
```

### `n_distinct()` and multiple arguments

This function needs exactly one argument besides the optional `na.rm`.
Multiple arguments is not supported.

### `is.na()` and `NaN` values

This function returns `FALSE` for `NaN` values in duckplyr, while it
returns `TRUE` in dplyr.

``` r
duckplyr::duckdb_tibble(a = c(NA, NaN)) |>
  mutate(is.na(a))
#> # A duckplyr data frame: 2 variables
#>       a `is.na(a)`
#>   <dbl> <lgl>     
#> 1    NA TRUE      
#> 2   NaN FALSE

tibble(a = c(NA, NaN)) |>
  mutate(is.na(a))
#> # A tibble: 2 × 2
#>       a `is.na(a)`
#>   <dbl> <lgl>     
#> 1    NA TRUE      
#> 2   NaN TRUE
```

### Row names

DuckDB does not support data frames with row names. When converting a
data frame with row names to a duckplyr data frame, the row names are
silently stripped. This is relevant when working with data frames that
have row names, such as `mtcars`.

``` r
# mtcars has character row names
head(rownames(mtcars))
#> [1] "Mazda RX4"         "Mazda RX4 Wag"     "Datsun 710"       
#> [4] "Hornet 4 Drive"    "Hornet Sportabout" "Valiant"
# After conversion, the row names are lost
mtcars |>
  duckplyr::as_duckdb_tibble() |>
  head()
#> # A duckplyr data frame: 11 variables
#>     mpg   cyl  disp    hp  drat    wt  qsec    vs    am  gear  carb
#>   <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl>
#> 1  21       6   160   110  3.9   2.62  16.5     0     1     4     4
#> 2  21       6   160   110  3.9   2.88  17.0     0     1     4     4
#> 3  22.8     4   108    93  3.85  2.32  18.6     1     1     4     1
#> 4  21.4     6   258   110  3.08  3.22  19.4     1     0     3     1
#> 5  18.7     8   360   175  3.15  3.44  17.0     0     0     3     2
#> 6  18.1     6   225   105  2.76  3.46  20.2     1     0     3     1
```

To preserve row names, convert them to a column before using duckplyr:

``` r
mtcars |>
  tibble::rownames_to_column("name") |>
  duckplyr::as_duckdb_tibble() |>
  head()
#> # A duckplyr data frame: 12 variables
#>   name        mpg   cyl  disp    hp  drat    wt  qsec    vs    am  gear
#>   <chr>     <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl>
#> 1 Mazda RX4  21       6   160   110  3.9   2.62  16.5     0     1     4
#> 2 Mazda RX…  21       6   160   110  3.9   2.88  17.0     0     1     4
#> 3 Datsun 7…  22.8     4   108    93  3.85  2.32  18.6     1     1     4
#> 4 Hornet 4…  21.4     6   258   110  3.08  3.22  19.4     1     0     3
#> 5 Hornet S…  18.7     8   360   175  3.15  3.44  17.0     0     0     3
#> 6 Valiant    18.1     6   225   105  2.76  3.46  20.2     1     0     3
#> # ℹ 1 more variable: carb <dbl>
```

### Other differences

Does the same pipeline give different results with
[`tibble()`](https://tibble.tidyverse.org/reference/tibble.html) and
[`duckdb_tibble()`](https://duckplyr.tidyverse.org/dev/reference/duckdb_tibble.md)?
We would love to hear about it, please file an
[issue](https://github.com/tidyverse/duckplyr/issues/new).
