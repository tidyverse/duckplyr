# Compute results to a Parquet file

This is a generic function that executes a query and stores the results
in a Parquet file. For a duckplyr frame, the materialization occurs
outside of R. The result is a duckplyr frame that can be used with
subsequent dplyr verbs.

## Usage

``` r
compute_parquet(x, path, ...)

# S3 method for class 'duckplyr_df'
compute_parquet(x, path, ..., prudence = NULL, options = NULL)

# S3 method for class 'data.frame'
compute_parquet(x, path, ..., prudence = NULL, options = NULL)
```

## Arguments

- x:

  A data frame or lazy data frame.

- path:

  The path of the Parquet file to create.

- ...:

  Additional arguments passed to methods.

- prudence:

  Memory protection, controls if DuckDB may convert intermediate results
  in DuckDB-managed memory to data frames in R memory.

  - `"lavish"`: regardless of size,

  - `"stingy"`: never,

  - `"thrifty"`: up to a maximum size of 1 million cells.

  The default is to inherit from the input. This argument is provided
  here only for convenience. The same effect can be achieved by
  forwarding the output to
  [`as_duckdb_tibble()`](https://duckplyr.tidyverse.org/reference/duckdb_tibble.md)
  with the desired prudence. See
  [`vignette("prudence")`](https://duckplyr.tidyverse.org/articles/prudence.md)
  for more information.

- options:

  A list of additional options to pass to create the Parquet file, see
  <https://duckdb.org/docs/sql/statements/copy.html#parquet-options> for
  details.

## Value

A data frame (the class may vary based on the input).

## See also

[`compute_csv()`](https://duckplyr.tidyverse.org/reference/compute_csv.md),
[`compute.duckplyr_df()`](https://duckplyr.tidyverse.org/reference/compute.duckplyr_df.md),
[`dplyr::collect()`](https://dplyr.tidyverse.org/reference/compute.html)

## Examples

``` r
library(duckplyr)
df <- data.frame(x = c(1, 2))
df <- mutate(df, y = 2)
path <- tempfile(fileext = ".parquet")
df <- compute_parquet(df, path)
explain(df)
#> ┌───────────────────────────┐
#> │       READ_PARQUET        │
#> │    ────────────────────   │
#> │         Function:         │
#> │        READ_PARQUET       │
#> │                           │
#> │        Projections:       │
#> │             x             │
#> │             y             │
#> │                           │
#> │          ~2 rows          │
#> └───────────────────────────┘
```
