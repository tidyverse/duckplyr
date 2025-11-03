# Read CSV files using DuckDB

`read_csv_duckdb()` reads a CSV file using DuckDB's `read_csv_auto()`
table function.

## Usage

``` r
read_csv_duckdb(
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

  Arguments to the DuckDB `read_csv_auto` table function.

## See also

[`read_parquet_duckdb()`](https://duckplyr.tidyverse.org/reference/read_parquet_duckdb.md),
[`read_json_duckdb()`](https://duckplyr.tidyverse.org/reference/read_json_duckdb.md)

## Examples

``` r
# Create simple CSV file
path <- tempfile("duckplyr_test_", fileext = ".csv")
write.csv(data.frame(a = 1:3, b = letters[4:6]), path, row.names = FALSE)

# Reading is immediate
df <- read_csv_duckdb(path)

# Names are always available
names(df)
#> [1] "a" "b"

# Materialization upon access is turned off by default
try(print(df$a))
#> [1] 1 2 3

# Materialize explicitly
collect(df)$a
#> [1] 1 2 3

# Automatic materialization with prudence = "lavish"
df <- read_csv_duckdb(path, prudence = "lavish")
df$a
#> [1] 1 2 3

# Specify column types
read_csv_duckdb(
  path,
  options = list(delim = ",", types = list(c("DOUBLE", "VARCHAR")))
)
#> # A duckplyr data frame: 2 variables
#>       a b    
#>   <dbl> <chr>
#> 1     1 d    
#> 2     2 e    
#> 3     3 f    
```
