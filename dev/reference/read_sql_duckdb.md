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
  [`vignette("prudence")`](https://duckplyr.tidyverse.org/dev/articles/prudence.md)
  for more information.

- con:

  The connection, defaults to the default connection.

## Details

Using data frames from the calling environment is not supported yet, see
<https://github.com/duckdb/duckdb-r/issues/645> for details.

## See also

[`db_exec()`](https://duckplyr.tidyverse.org/dev/reference/db_exec.md)

## Examples

``` r
read_sql_duckdb("FROM duckdb_settings()")
#> # A duckplyr data frame: 7 variables
#>    name          value description input_type scope aliases typed_value
#>    <chr>         <chr> <chr>       <chr>      <chr> <list>  <list>     
#>  1 access_mode   auto… Access mod… VARCHAR    GLOB… <chr>   <chr [1]>  
#>  2 active_gramm… []    The gramma… VARCHAR[]  LOCAL <chr>   <list [0]> 
#>  3 allocator_ba… false Whether to… BOOLEAN    GLOB… <chr>   <lgl [1]>  
#>  4 allocator_bu… 512.… If a bulk … VARCHAR    GLOB… <chr>   <chr [1]>  
#>  5 allocator_fl… 1342… Peak alloc… VARCHAR    GLOB… <chr>   <chr [1]>  
#>  6 allowed_conf… []    List of co… VARCHAR[]  GLOB… <chr>   <list [0]> 
#>  7 allowed_dire… []    List of di… VARCHAR[]  GLOB… <chr>   <list [0]> 
#>  8 allowed_paths []    List of fi… VARCHAR[]  GLOB… <chr>   <list [0]> 
#>  9 allow_commun… true  Allow load… BOOLEAN    GLOB… <chr>   <lgl [1]>  
#> 10 allow_extens… false Allow to l… BOOLEAN    GLOB… <chr>   <lgl [1]>  
#> # ℹ more rows
```
