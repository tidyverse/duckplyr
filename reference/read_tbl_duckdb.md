# Read a table from a DuckDB database file

**\[experimental\]**

`read_tbl_duckdb()` reads a table from a DuckDB database file by
attaching the database file and reading the specified table.

The database file is attached to the default duckplyr connection and
remains attached for the duration of the R session to support lazy
evaluation.

## Usage

``` r
read_tbl_duckdb(
  path,
  table_name,
  ...,
  schema = "main",
  prudence = c("thrifty", "lavish", "stingy")
)
```

## Arguments

- path:

  Path to the DuckDB database file.

- table_name:

  The name of the table to read.

- ...:

  These dots are for future extensions and must be empty.

- schema:

  The schema name where the table is located. Defaults to `"main"`.

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

## Value

A duckplyr frame, see
[`as_duckdb_tibble()`](https://duckplyr.tidyverse.org/reference/duckdb_tibble.md)
for details.

## See also

[`read_sql_duckdb()`](https://duckplyr.tidyverse.org/reference/read_sql_duckdb.md),
[`db_exec()`](https://duckplyr.tidyverse.org/reference/db_exec.md)

## Examples

``` r
if (FALSE) { # rlang::is_interactive()
# Create a temporary DuckDB database with a table
db_path <- tempfile(fileext = ".duckdb")
con <- DBI::dbConnect(duckdb::duckdb(), db_path)
DBI::dbWriteTable(con, "test_table", data.frame(a = 1:3, b = c("x", "y", "z")))
DBI::dbDisconnect(con)

# Read the table from the database file
df <- read_tbl_duckdb(db_path, "test_table")
print(df)

# Clean up
unlink(db_path)
}
```
