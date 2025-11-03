# Read Parquet files using DuckDB

`read_parquet_duckdb()` reads a Parquet file using DuckDB's
`read_parquet()` table function.

## Usage

``` r
read_parquet_duckdb(
  path,
  ...,
  prudence = c("thrifty", "lavish", "stingy"),
  options = list()
)
```

## Arguments

- path:

  Path to files, glob patterns `*` and `?` are supported.

- ...:

  These dots are for future extensions and must be empty.

- prudence:

  Memory protection, controls if DuckDB may convert intermediate results
  in DuckDB-managed memory to data frames in R memory.

  - `"thrifty"`: up to a maximum size of 1 million cells,

  - `"lavish"`: regardless of size,

  - `"stingy"`: never.

  The default is `"thrifty"` for the ingestion functions, and may be
  different for other functions. See
  [`vignette("prudence")`](https://duckplyr.tidyverse.org/articles/prudence.md)
  for more information.

- options:

  Arguments to the DuckDB `read_parquet` table function.

## See also

[`read_csv_duckdb()`](https://duckplyr.tidyverse.org/reference/read_csv_duckdb.md),
[`read_json_duckdb()`](https://duckplyr.tidyverse.org/reference/read_json_duckdb.md)
