# Fallback to dplyr

This article details the fallback mechanism in duckplyr, which allows
support for all dplyr verbs and R functions.

``` r
library(conflicted)
library(dplyr)
conflict_prefer("filter", "dplyr")
#> [conflicted] Will prefer dplyr::filter
#> over any other package.
```

## Introduction

The duckplyr package aims at providing a fully compatible drop-in
replacement for dplyr. All operations, R functions, and data types that
are supported by dplyr should work in an identical way with duckplyr.
This is achieved in two ways:

- A carefully selected subset of dplyr operations, R functions, and R
  data types are implemented in DuckDB, focusing on faithful
  translation.
- When DuckDB does not support an operation, duckplyr falls back to
  dplyr, guaranteeing identical behavior.

## DuckDB mode

The following operation is supported by duckplyr:

``` r
duckdb <-
  duckplyr::duckdb_tibble(a = 1:3) |>
  arrange(desc(a)) |>
  mutate(b = a + 1) |>
  select(-a)
```

The [`explain()`](https://dplyr.tidyverse.org/reference/explain.html)
function shows what happens under the hood:

``` r
duckdb |>
  explain()
#> ┌---------------------------┐
#> │         PROJECTION        │
#> │    --------------------   │
#> │             b             │
#> │                           │
#> │          ~3 rows          │
#> └-------------┬-------------┘
#> ┌-------------┴-------------┐
#> │          ORDER_BY         │
#> │    --------------------   │
#> │      dataframe_42_42      │
#> │       3409599.a DESC      │
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

The plan shows three operations:

- a data frame scan (the input),
- a sort operation,
- a projection (adding the `b` column and removing the `a` column).

Each operation is supported by DuckDB. The resulting object contains a
plan for the entire pipeline that is executed lazily, only when the data
is needed.

## Relation objects

DuckDB accepts a tree of interconnected *relation objects* as input.
Each relation object represents a logical step of the execution plan.
The duckplyr package translates dplyr verbs into relation objects.

The
[`last_rel()`](https://duckplyr.tidyverse.org/dev/reference/last_rel.md)
function shows the last relation that has been materialized:

``` r
duckplyr::last_rel()
#> NULL
```

It is `NULL` because nothing has been computed yet. Converting the
object to a data frame triggers the computation:

``` r
duckdb |> collect()
#> # A tibble: 3 × 1
#>       b
#>   <dbl>
#> 1     4
#> 2     3
#> 3     2
duckplyr::last_rel()
#> DuckDB Relation: 
#> ---------------------
#> --- Relation Tree ---
#> ---------------------
#> Projection [b as b]
#>   Projection [a as a, "+"(a, 1.0) as b]
#>     Order [a DESC]
#>       r_dataframe_scan(0xdeadbeef)
#> 
#> ---------------------
#> -- Result Columns  --
#> ---------------------
#> - b (DOUBLE)
```

The
[`last_rel()`](https://duckplyr.tidyverse.org/dev/reference/last_rel.md)
function now shows a relation that describes logical plan for executing
the whole pipeline.

## Help from dplyr

Using a custom function with a side effect is not supported by DuckDB
and triggers a dplyr fallback:

``` r
verbose_plus_one <- function(x) {
  message("Adding one to ", paste(x, collapse = ", "))
  x + 1
}

fallback <-
  duckplyr::duckdb_tibble(a = 1:3) |>
  arrange(desc(a)) |>
  mutate(b = verbose_plus_one(a)) |>
  select(-a)
#> Adding one to 3, 2, 1
```

The `verbose_plus_one()` function is not supported by DuckDB, so the
[`mutate()`](https://dplyr.tidyverse.org/reference/mutate.html) step is
forwarded to dplyr and already executed (eagerly) when the pipeline is
defined. This is confirmed by the
[`last_rel()`](https://duckplyr.tidyverse.org/dev/reference/last_rel.md)
function:

``` r
duckplyr::last_rel()
#> DuckDB Relation: 
#> ---------------------
#> --- Relation Tree ---
#> ---------------------
#> Order [a DESC]
#>   r_dataframe_scan(0xdeadbeef)
#> 
#> ---------------------
#> -- Result Columns  --
#> ---------------------
#> - a (INTEGER)
```

Only the
[`arrange()`](https://dplyr.tidyverse.org/reference/arrange.html) step
is executed by DuckDB. Because the dplyr implementation of
[`mutate()`](https://dplyr.tidyverse.org/reference/mutate.html) needs
the data before it can proceed, the data is first converted to a data
frame, and this triggers the materialization of the first step.

The [`explain()`](https://dplyr.tidyverse.org/reference/explain.html)
function also confirms indirectly that at least a part of the operation
is handled by dplyr:

``` r
fallback |>
  explain()
#> ┌---------------------------┐
#> │     R_DATAFRAME_SCAN      │
#> │    --------------------   │
#> │      Text: data.frame     │
#> │       Projections: b      │
#> │                           │
#> │          ~3 rows          │
#> └---------------------------┘
```

The final plan now only consists of a data frame scan. This is the
result of the
[`mutate()`](https://dplyr.tidyverse.org/reference/mutate.html) step,
which at this stage already has been executed by dplyr.

Converting the final object to a data frame triggers the rest of the
computation:

``` r
fallback |> collect()
#> # A tibble: 3 × 1
#>       b
#>   <dbl>
#> 1     4
#> 2     3
#> 3     2

duckplyr::last_rel()
#> DuckDB Relation: 
#> ---------------------
#> --- Relation Tree ---
#> ---------------------
#> Projection [b as b]
#>   r_dataframe_scan(0xdeadbeef)
#> 
#> ---------------------
#> -- Result Columns  --
#> ---------------------
#> - b (DOUBLE)
```

The
[`last_rel()`](https://duckplyr.tidyverse.org/dev/reference/last_rel.md)
function confirms that only the final
[`select()`](https://dplyr.tidyverse.org/reference/select.html) is
handled by DuckDB again.

## Enforce DuckDB operation

For any duck frame, one can control the automatic materialization. For
fallbacks to dplyr, automatic materialization must be allowed for the
duck frame at hand, as dplyr necessitates eager evaluation.

Therefore, by making a data frame stingy, one can ensure a pipeline will
error when a fallback to dplyr would have normally happened. See
[`vignette("prudence")`](https://duckplyr.tidyverse.org/dev/articles/prudence.md)
for details.

By using operations supported by duckplyr and avoiding fallbacks as much
as possible, your pipelines will be executed by DuckDB in an optimized
way. As of duckplyr 1.1.0, most DuckDB functions can be used directly,
see
[`vignette("duckdb")`](https://duckplyr.tidyverse.org/dev/articles/duckdb.md)
for details.

## Configure fallbacks

Using the
[`fallback_sitrep()`](https://duckplyr.tidyverse.org/dev/reference/fallback.md)
and
[`fallback_config()`](https://duckplyr.tidyverse.org/dev/reference/fallback.md)
functions you can examine and change settings related to fallbacks.

- You can choose to make fallbacks verbose with
  `fallback_config(info = TRUE)`.

- You can change settings related to logging and reporting fallback to
  duckplyr development team to inform their work.

See
[`vignette("telemetry")`](https://duckplyr.tidyverse.org/dev/articles/telemetry.md)
for details.

## Conclusion

The fallback mechanism in duckplyr allows for a seamless integration of
dplyr verbs and R functions that are not supported by DuckDB. It is
transparent to the user and only triggers when necessary. With small or
medium-sized data sets, it will not even be noticeable in most settings.

See
[`vignette("large")`](https://duckplyr.tidyverse.org/dev/articles/large.md)
for techniques for working with large data,
[`vignette("limits")`](https://duckplyr.tidyverse.org/dev/articles/limits.md)
for the currently implementated translations,
[`vignette("duckdb")`](https://duckplyr.tidyverse.org/dev/articles/duckdb.md)
for direct access to DuckDB functions,
[`vignette("prudence")`](https://duckplyr.tidyverse.org/dev/articles/prudence.md)
for details on controlling fallback behavior, and
[`vignette("telemetry")`](https://duckplyr.tidyverse.org/dev/articles/telemetry.md)
for the automatic reporting of fallback situations.
