# Return the First Parts of an Object

This is a method for the [`head()`](https://rdrr.io/r/utils/head.html)
generic. See "Fallbacks" section for differences in implementation.
Return the first rows of a data.frame

## Usage

``` r
# S3 method for class 'duckplyr_df'
head(x, n = 6L, ...)
```

## Arguments

- x:

  A data.frame

- n:

  A positive integer, how many rows to return.

- ...:

  Not used yet.

## Fallbacks

There is no DuckDB translation in `head.duckplyr_df()`

- with a negative `n`.

These features fall back to
[`head()`](https://rdrr.io/r/utils/head.html), see
[`vignette("fallback")`](https://duckplyr.tidyverse.org/dev/articles/fallback.md)
for details.

## See also

[`head()`](https://rdrr.io/r/utils/head.html)

## Examples

``` r
head(mtcars, 2)
#>               mpg cyl disp  hp drat    wt  qsec vs am gear carb
#> Mazda RX4      21   6  160 110  3.9 2.620 16.46  0  1    4    4
#> Mazda RX4 Wag  21   6  160 110  3.9 2.875 17.02  0  1    4    4
```
