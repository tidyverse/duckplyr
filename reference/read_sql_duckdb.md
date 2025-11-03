# Return SQL query as duckdb_tibble

**\[experimental\]**

Runs a query and returns it as a duckplyr frame.

## Usage

``` r
read_sql_duckdb(
  sql,
  ...,
  prudence = c("thrifty", "lavish", "stingy"),
  con = NULL
)
```

## Arguments

- sql:

  The SQL to run.

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

- con:

  The connection, defaults to the default connection.

## Details

Using data frames from the calling environment is not supported yet, see
<https://github.com/duckdb/duckdb-r/issues/645> for details.

## See also

[`db_exec()`](https://duckplyr.tidyverse.org/reference/db_exec.md)

## Examples

``` r
read_sql_duckdb("FROM duckdb_settings()")
#> # A duckplyr data frame: 6 variables
#>    name                      value description input_type scope aliases
#>    <chr>                     <chr> <chr>       <chr>      <chr> <list> 
#>  1 access_mode               auto… Access mod… VARCHAR    GLOB… <chr>  
#>  2 allocator_background_thr… false Whether to… BOOLEAN    GLOB… <chr>  
#>  3 allocator_bulk_deallocat… 512.… If a bulk … VARCHAR    GLOB… <chr>  
#>  4 allocator_flush_threshold 128.… Peak alloc… VARCHAR    GLOB… <chr>  
#>  5 allow_community_extensio… true  Allow to l… BOOLEAN    GLOB… <chr>  
#>  6 allow_extensions_metadat… false Allow to l… BOOLEAN    GLOB… <chr>  
#>  7 allow_persistent_secrets  true  Allow the … BOOLEAN    GLOB… <chr>  
#>  8 allow_unredacted_secrets  false Allow prin… BOOLEAN    GLOB… <chr>  
#>  9 allow_unsigned_extensions false Allow to l… BOOLEAN    GLOB… <chr>  
#> 10 allowed_directories       []    List of di… VARCHAR[]  GLOB… <chr>  
#> # ℹ more rows
```
