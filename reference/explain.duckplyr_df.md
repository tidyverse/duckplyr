# Explain details of a tbl

This is a method for the
[`dplyr::explain()`](https://dplyr.tidyverse.org/reference/explain.html)
generic. This is a generic function which gives more details about an
object than [`print()`](https://rdrr.io/r/base/print.html), and is more
focused on human readable output than
[`str()`](https://rdrr.io/r/utils/str.html).

## Usage

``` r
# S3 method for class 'duckplyr_df'
explain(x, ...)
```

## Arguments

- x:

  An object to explain

- ...:

  Other parameters possibly used by generic

## Value

The input, invisibly.

## See also

[`dplyr::explain()`](https://dplyr.tidyverse.org/reference/explain.html)

## Examples

``` r
library(duckplyr)
df <- duckdb_tibble(x = c(1, 2))
df <- mutate(df, y = 2)
explain(df)
#> ┌───────────────────────────┐
#> │         PROJECTION        │
#> │    ────────────────────   │
#> │             x             │
#> │             y             │
#> │                           │
#> │          ~2 rows          │
#> └─────────────┬─────────────┘
#> ┌─────────────┴─────────────┐
#> │     R_DATAFRAME_SCAN      │
#> │    ────────────────────   │
#> │      Text: data.frame     │
#> │       Projections: x      │
#> │                           │
#> │          ~2 rows          │
#> └───────────────────────────┘
```
