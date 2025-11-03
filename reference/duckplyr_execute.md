# Execute a statement for the default connection

**\[deprecated\]**

The duckplyr package relies on a DBI connection to an in-memory
database. The `duckplyr_execute()` function allows running SQL
statements with this connection to, e.g., set up credentials or attach
other databases. See
<https://duckdb.org/docs/configuration/overview.html> for more
information on the configuration options.

## Usage

``` r
duckplyr_execute(sql)
```

## Arguments

- sql:

  The statement to run.

## Value

The return value of the
[`DBI::dbExecute()`](https://dbi.r-dbi.org/reference/dbExecute.html)
call, invisibly.

## Examples

``` r
duckplyr_execute("SET threads TO 2")
#> Warning: `duckplyr_execute()` was deprecated in duckplyr 1.0.0.
#> ℹ Please use `db_exec()` instead.
```
