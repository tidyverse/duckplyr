# Extract a single column

This is a method for the
[`dplyr::pull()`](https://dplyr.tidyverse.org/reference/pull.html)
generic. See "Fallbacks" section for differences in implementation.
[`pull()`](https://dplyr.tidyverse.org/reference/pull.html) is similar
to `$`. It's mostly useful because it looks a little nicer in pipes, it
also works with remote data frames, and it can optionally name the
output.

## Usage

``` r
# S3 method for class 'duckplyr_df'
pull(.data, var = -1, name = NULL, ...)
```

## Arguments

- .data:

  A data frame, data frame extension (e.g. a tibble), or a lazy data
  frame (e.g. from dbplyr or dtplyr). See *Methods*, below, for more
  details.

- var:

  A variable specified as:

  - a literal variable name

  - a positive integer, giving the position counting from the left

  - a negative integer, giving the position counting from the right.

  The default returns the last column (on the assumption that's the
  column you've created most recently).

  This argument is taken by expression and supports
  [quasiquotation](https://rlang.r-lib.org/reference/topic-inject.html)
  (you can unquote column names and column locations).

- name:

  An optional parameter that specifies the column to be used as names
  for a named vector. Specified in a similar manner as `var`.

- ...:

  For use by methods.

## Fallbacks

There is no DuckDB translation in `pull.duckplyr_df()`

- with a selection that returns no columns.

These features fall back to
[`dplyr::pull()`](https://dplyr.tidyverse.org/reference/pull.html), see
[`vignette("fallback")`](https://duckplyr.tidyverse.org/articles/fallback.md)
for details.

## See also

[`dplyr::pull()`](https://dplyr.tidyverse.org/reference/pull.html)

## Examples

``` r
library(duckplyr)
pull(mtcars, cyl)
#>  [1] 6 6 4 6 8 6 8 4 4 6 6 8 8 8 8 8 8 4 4 4 4 8 8 8 8 4 4 4 8 6 8 4
pull(mtcars, 1)
#>  [1] 21.0 21.0 22.8 21.4 18.7 18.1 14.3 24.4 22.8 19.2 17.8 16.4 17.3
#> [14] 15.2 10.4 10.4 14.7 32.4 30.4 33.9 21.5 15.5 15.2 13.3 19.2 27.3
#> [27] 26.0 30.4 15.8 19.7 15.0 21.4
```
