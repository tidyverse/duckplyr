# Read Parquet, CSV, and other files using DuckDB

**\[deprecated\]**

`df_from_file()` uses arbitrary table functions to read data. See
<https://duckdb.org/docs/data/overview> for a documentation of the
available functions and their options. To read multiple files with the
same schema, pass a wildcard or a character vector to the `path`
argument,

`duckplyr_df_from_file()` is a thin wrapper around `df_from_file()` that
calls
[`as_duckplyr_df()`](https://duckplyr.tidyverse.org/reference/as_duckplyr_df.md)
on the output.

These functions ingest data from a file using a table function. The
results are transparently converted to a data frame, but the data is
only read when the resulting data frame is actually accessed.

`df_from_csv()` reads a CSV file using the `read_csv_auto()` table
function.

`duckplyr_df_from_csv()` is a thin wrapper around `df_from_csv()` that
calls
[`as_duckplyr_df()`](https://duckplyr.tidyverse.org/reference/as_duckplyr_df.md)
on the output.

`df_from_parquet()` reads a Parquet file using the `read_parquet()`
table function.

`duckplyr_df_from_parquet()` is a thin wrapper around
`df_from_parquet()` that calls
[`as_duckplyr_df()`](https://duckplyr.tidyverse.org/reference/as_duckplyr_df.md)
on the output.

`df_to_parquet()` writes a data frame to a Parquet file via DuckDB. If
the data frame is a `duckplyr_df`, the materialization occurs outside of
R. An existing file will be overwritten. This function requires duckdb
\>= 0.10.0.

## Usage

``` r
df_from_file(path, table_function, ..., options = list(), class = NULL)

duckplyr_df_from_file(
  path,
  table_function,
  ...,
  options = list(),
  class = NULL
)

df_from_csv(path, ..., options = list(), class = NULL)

duckplyr_df_from_csv(path, ..., options = list(), class = NULL)

df_from_parquet(path, ..., options = list(), class = NULL)

duckplyr_df_from_parquet(path, ..., options = list(), class = NULL)

df_to_parquet(data, path)
```

## Arguments

- path:

  Path to files, glob patterns `*` and `?` are supported.

- table_function:

  The name of a table-valued DuckDB function such as `"read_parquet"`,
  `"read_csv"`, `"read_csv_auto"` or `"read_json"`.

- ...:

  These dots are for future extensions and must be empty.

- options:

  Arguments to the DuckDB function indicated by `table_function`.

- class:

  The class of the output. By default, a tibble is created. The returned
  object will always be a data frame. Use `class = "data.frame"` or
  `class = character()` to create a plain data frame.

- data:

  A data frame to be written to disk.

## Value

A data frame for `df_from_file()`, or a `duckplyr_df` for
`duckplyr_df_from_file()`, extended by the provided `class`.

## Examples

``` r
# Create simple CSV file
path <- tempfile("duckplyr_test_", fileext = ".csv")
write.csv(data.frame(a = 1:3, b = letters[4:6]), path, row.names = FALSE)

# Reading is immediate
df <- df_from_csv(path)
#> Warning: `df_from_csv()` was deprecated in duckplyr 1.0.0.
#> ℹ Please use `read_csv_duckdb()` instead.

# Materialization only upon access
names(df)
#> [1] "a" "b"
df$a
#> [1] 1 2 3

# Return as tibble, specify column types:
df_from_file(
  path,
  "read_csv",
  options = list(delim = ",", types = list(c("DOUBLE", "VARCHAR"))),
  class = class(tibble())
)
#> Warning: `df_from_file()` was deprecated in duckplyr 1.0.0.
#> ℹ Please use `read_file_duckdb()` instead.
#> # A tibble: 3 × 2
#>       a b    
#>   <dbl> <chr>
#> 1     1 d    
#> 2     2 e    
#> 3     3 f    

# Read multiple file at once
path2 <- tempfile("duckplyr_test_", fileext = ".csv")
write.csv(data.frame(a = 4:6, b = letters[7:9]), path2, row.names = FALSE)

duckplyr_df_from_csv(file.path(tempdir(), "duckplyr_test_*.csv"))
#> Warning: `duckplyr_df_from_csv()` was deprecated in duckplyr 1.0.0.
#> ℹ Please use `read_csv_duckdb()` instead.
#> # A duckplyr data frame: 2 variables
#>       a b    
#>   <dbl> <chr>
#> 1     1 d    
#> 2     2 e    
#> 3     3 f    
#> 4     4 g    
#> 5     5 h    
#> 6     6 i    

unlink(c(path, path2))

# Write a Parquet file:
path_parquet <- tempfile(fileext = ".parquet")
df_to_parquet(df, path_parquet)
#> Warning: `df_to_parquet()` was deprecated in duckplyr 1.0.0.
#> ℹ Please use `compute_parquet()` instead.
#> NULL

# With a duckplyr_df, the materialization occurs outside of R:
df %>%
  as_duckplyr_df() %>%
  mutate(b = a + 1) %>%
  df_to_parquet(path_parquet)
#> Warning: `as_duckplyr_df()` was deprecated in duckplyr 1.0.0.
#> ℹ Please use `as_duckdb_tibble()` instead.
#> NULL

duckplyr_df_from_parquet(path_parquet)
#> Warning: `duckplyr_df_from_parquet()` was deprecated in duckplyr 1.0.0.
#> ℹ Please use `read_parquet_duckdb()` instead.
#> # A duckplyr data frame: 2 variables
#>       a     b
#>   <dbl> <dbl>
#> 1     1     2
#> 2     2     3
#> 3     3     4

unlink(path_parquet)
```
