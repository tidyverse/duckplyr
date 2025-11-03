# duckplyr data frames

Data frames backed by duckplyr have a special class, `"duckplyr_df"`, in
addition to the default classes. This ensures that dplyr methods are
dispatched correctly. For such objects, dplyr verbs such as
[`dplyr::mutate()`](https://dplyr.tidyverse.org/reference/mutate.html),
[`dplyr::select()`](https://dplyr.tidyverse.org/reference/select.html)
or
[`dplyr::filter()`](https://dplyr.tidyverse.org/reference/filter.html)
will use DuckDB.

`duckdb_tibble()` works like
[`tibble::tibble()`](https://tibble.tidyverse.org/reference/tibble.html).

`as_duckdb_tibble()` converts a data frame or a dplyr lazy table to a
duckplyr data frame. This is a generic function that can be overridden
for custom classes.

`is_duckdb_tibble()` returns `TRUE` if `x` is a duckplyr data frame.

## Usage

``` r
duckdb_tibble(..., .prudence = c("lavish", "thrifty", "stingy"))

as_duckdb_tibble(x, ..., prudence = c("lavish", "thrifty", "stingy"))

is_duckdb_tibble(x)
```

## Arguments

- ...:

  For `duckdb_tibble()`, passed on to
  [`tibble::tibble()`](https://tibble.tidyverse.org/reference/tibble.html).
  For `as_duckdb_tibble()`, passed on to methods.

- x:

  The object to convert or to test.

- prudence, .prudence:

  Memory protection, controls if DuckDB may convert intermediate results
  in DuckDB-managed memory to data frames in R memory.

  - `"lavish"`: regardless of size,

  - `"stingy"`: never,

  - `"thrifty"`: up to a maximum size of 1 million cells.

  The default is `"lavish"` for `duckdb_tibble()` and
  `as_duckdb_tibble()`, and may be different for other functions. See
  [`vignette("prudence")`](https://duckplyr.tidyverse.org/articles/prudence.md)
  for more information.

## Value

For `duckdb_tibble()` and `as_duckdb_tibble()`, an object with the
following classes:

- `"prudent_duckplyr_df"` if `prudence` is not `"lavish"`

- `"duckplyr_df"`

- Classes of a
  [tibble::tibble](https://tibble.tidyverse.org/reference/tibble.html)

For `is_duckdb_tibble()`, a scalar logical.

## Fine-tuning prudence

**\[experimental\]**

The `prudence` argument can also be a named numeric vector with at least
one of `cells` or `rows` to limit the cells (values) and rows in the
resulting data frame after automatic materialization. If both limits are
specified, both are enforced. The equivalent of `"thrifty"` is
`c(cells = 1e6)`.

## Examples

``` r
x <- duckdb_tibble(a = 1)
x
#> # A duckplyr data frame: 1 variable
#>       a
#>   <dbl>
#> 1     1

library(dplyr)
x %>%
  mutate(b = 2)
#> # A duckplyr data frame: 2 variables
#>       a     b
#>   <dbl> <dbl>
#> 1     1     2

x$a
#> [1] 1

y <- duckdb_tibble(a = 1, .prudence = "stingy")
y
#> # A duckplyr data frame: 1 variable
#>       a
#>   <dbl>
#> 1     1
try(length(y$a))
#> Error in (function (context, message, error_type = NULL, raw_message = NULL,  : 
#>   Materialization is disabled, use `collect()` or `as_tibble()` to materialize.
#> ℹ Context: GetQueryResult
length(collect(y)$a)
#> [1] 1
```
