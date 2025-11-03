# Convert to a duckplyr data frame

**\[deprecated\]**

These functions convert a data-frame-like input to an object of class
`"duckpylr_df"`. For such objects, dplyr verbs such as
[`dplyr::mutate()`](https://dplyr.tidyverse.org/reference/mutate.html),
[`dplyr::select()`](https://dplyr.tidyverse.org/reference/select.html)
or
[`dplyr::filter()`](https://dplyr.tidyverse.org/reference/filter.html)
will attempt to use DuckDB. If this is not possible, the original dplyr
implementation is used.

`as_duckplyr_df()` requires the input to be a plain data frame or a
tibble, and will fail for any other classes, including subclasses of
`"data.frame"` or `"tbl_df"`. This behavior is likely to change, do not
rely on it.

`as_duckplyr_tibble()` converts the input to a tibble and then to a
duckplyr data frame.

## Usage

``` r
as_duckplyr_df(.data)

as_duckplyr_tibble(.data)
```

## Arguments

- .data:

  data frame or tibble to transform

## Value

For `as_duckplyr_df()`, an object of class `"duckplyr_df"`, inheriting
from the classes of the `.data` argument.

For `as_duckplyr_tibble()`, an object of class
`c("duckplyr_df", class(tibble()))` .

## Details

Set the `DUCKPLYR_FALLBACK_INFO` and `DUCKPLYR_FORCE` environment
variables for more control over the behavior, see
[config](https://duckplyr.tidyverse.org/dev/reference/config.md) for
more details.

## Examples

``` r
tibble(a = 1:3) %>%
  mutate(b = a + 1)
#> # A tibble: 3 × 2
#>       a     b
#>   <int> <dbl>
#> 1     1     2
#> 2     2     3
#> 3     3     4
```
