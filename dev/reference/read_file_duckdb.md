# Read files using DuckDB

`read_file_duckdb()` uses arbitrary readers to read data. See
<https://duckdb.org/docs/data/overview> for a documentation of the
available functions and their options. To read multiple files with the
same schema, pass a wildcard or a character vector to the `path`
argument,

## Usage

``` r
read_file_duckdb(
  path,
  table_function,
  ...,
  prudence = c("thrifty", "lavish", "stingy"),
  options = list()
)
```

## Arguments

- path:

  Path to files, glob patterns `*` and `?` are supported.

- table_function:

  The name of a table-valued DuckDB function such as `"read_parquet"`,
  `"read_csv"`, `"read_csv_auto"` or `"read_json"`.

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
  [`vignette("prudence")`](https://duckplyr.tidyverse.org/dev/articles/prudence.md)
  for more information.

- options:

  Arguments to the DuckDB function indicated by `table_function`.

## Value

A duckplyr frame, see
[`as_duckdb_tibble()`](https://duckplyr.tidyverse.org/dev/reference/duckdb_tibble.md)
for details.

## Fine-tuning prudence

**\[experimental\]**

The `prudence` argument can also be a named numeric vector with at least
one of `cells` or `rows` to limit the cells (values) and rows in the
resulting data frame after automatic materialization. If both limits are
specified, both are enforced. The equivalent of `"thrifty"` is
`c(cells = 1e6)`.

## See also

[`read_csv_duckdb()`](https://duckplyr.tidyverse.org/dev/reference/read_csv_duckdb.md),
[`read_parquet_duckdb()`](https://duckplyr.tidyverse.org/dev/reference/read_parquet_duckdb.md),
[`read_json_duckdb()`](https://duckplyr.tidyverse.org/dev/reference/read_json_duckdb.md)
