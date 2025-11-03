# Read JSON files using DuckDB

`read_json_duckdb()` reads a JSON file using DuckDB's `read_json()`
table function.

## Usage

``` r
read_json_duckdb(
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
  [`vignette("prudence")`](https://duckplyr.tidyverse.org/dev/articles/prudence.md)
  for more information.

- options:

  Arguments to the DuckDB `read_json` table function.

## See also

[`read_csv_duckdb()`](https://duckplyr.tidyverse.org/dev/reference/read_csv_duckdb.md),
[`read_parquet_duckdb()`](https://duckplyr.tidyverse.org/dev/reference/read_parquet_duckdb.md)

## Examples

``` r
if (FALSE) { # identical(Sys.getenv("IN_PKGDOWN"), "TRUE")

# Create and read a simple JSON file
path <- tempfile("duckplyr_test_", fileext = ".json")
writeLines('[{"a": 1, "b": "x"}, {"a": 2, "b": "y"}]', path)

# Reading needs the json extension
db_exec("INSTALL json")
db_exec("LOAD json")
read_json_duckdb(path)
}
```
