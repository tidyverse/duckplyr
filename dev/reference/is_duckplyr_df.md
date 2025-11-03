# Class predicate for duckplyr data frames

**\[deprecated\]**

Tests if the input object is of class `"duckplyr_df"`.

## Usage

``` r
is_duckplyr_df(.data)
```

## Arguments

- .data:

  The object to test

## Value

`TRUE` if the input object is of class `"duckplyr_df"`, otherwise
`FALSE`.

## Examples

``` r
tibble(a = 1:3) %>%
  is_duckplyr_df()
#> Warning: `is_duckplyr_df()` was deprecated in duckplyr 1.0.0.
#> ℹ Please use `is_duckdb_tibble()` instead.
#> [1] FALSE

tibble(a = 1:3) %>%
  as_duckplyr_df() %>%
  is_duckplyr_df()
#> [1] TRUE
```
