# Execute a statement for the default connection

The duckplyr package relies on a DBI connection to an in-memory
database. The `db_exec()` function allows running SQL statements with
side effects on this connection. It can be used to execute statements
that start with `PRAGMA`, `SET`, or `ATTACH` to, e.g., set up
credentials, change configuration options, or attach other databases.
See <https://duckdb.org/docs/configuration/overview.html> for more
information on the configuration options, and
<https://duckdb.org/docs/sql/statements/attach.html> for attaching
databases.

## Usage

``` r
db_exec(sql, ..., con = NULL)
```

## Arguments

- sql:

  The statement to run.

- ...:

  These dots are for future extensions and must be empty.

- con:

  The connection, defaults to the default connection.

## Value

The return value of the
[`DBI::dbExecute()`](https://dbi.r-dbi.org/reference/dbExecute.html)
call, invisibly.

## See also

[`read_sql_duckdb()`](https://duckplyr.tidyverse.org/dev/reference/read_sql_duckdb.md)

## Examples

``` r
db_exec("SET threads TO 2")
```
