# Compute results

This is a method for the
[`dplyr::compute()`](https://dplyr.tidyverse.org/reference/compute.html)
generic. For a duckplyr frame,
[`compute()`](https://dplyr.tidyverse.org/reference/compute.html)
executes a query but stores it in a (temporary) table, or in a Parquet
or CSV file. The result is a duckplyr frame that can be used with
subsequent dplyr verbs.

## Usage

``` r
# S3 method for class 'duckplyr_df'
compute(
  x,
  ...,
  prudence = NULL,
  name = NULL,
  schema_name = NULL,
  temporary = TRUE
)
```

## Arguments

- x:

  A duckplyr frame.

- ...:

  Arguments passed on to methods

- prudence:

  Memory protection, controls if DuckDB may convert intermediate results
  in DuckDB-managed memory to data frames in R memory.

  - `"lavish"`: regardless of size,

  - `"stingy"`: never,

  - `"thrifty"`: up to a maximum size of 1 million cells.

  The default is to inherit from the input. This argument is provided
  here only for convenience. The same effect can be achieved by
  forwarding the output to
  [`as_duckdb_tibble()`](https://duckplyr.tidyverse.org/dev/reference/duckdb_tibble.md)
  with the desired prudence. See
  [`vignette("prudence")`](https://duckplyr.tidyverse.org/dev/articles/prudence.md)
  for more information.

- name:

  The name of the table to store the result in.

- schema_name:

  The schema to store the result in, defaults to the current schema.

- temporary:

  Set to `FALSE` to store the result in a permanent table.

## Value

A duckplyr frame.

## See also

[`dplyr::collect()`](https://dplyr.tidyverse.org/reference/compute.html)

## Examples

``` r
library(duckplyr)
df <- duckdb_tibble(x = c(1, 2))
df <- mutate(df, y = 2)
explain(df)
#> ┌───────────────────────────┐
#> │         PROJECTION        │
#> │    ────────────────────   │
#> │             x             │
#> │             y             │
#> │                           │
#> │          ~2 rows          │
#> └─────────────┬─────────────┘
#> ┌─────────────┴─────────────┐
#> │     R_DATAFRAME_SCAN      │
#> │    ────────────────────   │
#> │      Text: data.frame     │
#> │       Projections: x      │
#> │                           │
#> │          ~2 rows          │
#> └───────────────────────────┘
df <- compute(df)
explain(df)
#> ┌───────────────────────────┐
#> │         SEQ_SCAN          │
#> │    ────────────────────   │
#> │           Table:          │
#> │    duckplyr_QeuR8HfdVH    │
#> │                           │
#> │   Type: Sequential Scan   │
#> │                           │
#> │        Projections:       │
#> │             x             │
#> │             y             │
#> │                           │
#> │          ~2 rows          │
#> └───────────────────────────┘
```
