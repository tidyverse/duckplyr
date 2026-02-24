# Count the observations in each group

This is a method for the
[`dplyr::count()`](https://dplyr.tidyverse.org/reference/count.html)
generic. See "Fallbacks" section for differences in implementation.
[`count()`](https://dplyr.tidyverse.org/reference/count.html) lets you
quickly count the unique values of one or more variables:
`df %>% count(a, b)` is roughly equivalent to
`df %>% group_by(a, b) %>% summarise(n = n())`.
[`count()`](https://dplyr.tidyverse.org/reference/count.html) is paired
with [`tally()`](https://dplyr.tidyverse.org/reference/count.html), a
lower-level helper that is equivalent to `df %>% summarise(n = n())`.
Supply `wt` to perform weighted counts, switching the summary from
`n = n()` to `n = sum(wt)`.

## Usage

``` r
# S3 method for class 'duckplyr_df'
count(
  x,
  ...,
  wt = NULL,
  sort = FALSE,
  name = NULL,
  .drop = group_by_drop_default(x)
)
```

## Arguments

- x:

  A data frame, data frame extension (e.g. a tibble), or a lazy data
  frame (e.g. from dbplyr or dtplyr).

- ...:

  \<[`data-masking`](https://rlang.r-lib.org/reference/args_data_masking.html)\>
  Variables to group by.

- wt:

  \<[`data-masking`](https://rlang.r-lib.org/reference/args_data_masking.html)\>
  Frequency weights. Can be `NULL` or a variable:

  - If `NULL` (the default), counts the number of rows in each group.

  - If a variable, computes `sum(wt)` for each group.

- sort:

  If `TRUE`, will show the largest groups at the top.

- name:

  The name of the new column in the output.

  If omitted, it will default to `n`. If there's already a column called
  `n`, it will use `nn`. If there's a column called `n` and `nn`, it'll
  use `nnn`, and so on, adding `n`s until it gets a new name.

- .drop:

  Handling of factor levels that don't appear in the data, passed on to
  [`group_by()`](https://dplyr.tidyverse.org/reference/group_by.html).

  For [`count()`](https://dplyr.tidyverse.org/reference/count.html): if
  `FALSE` will include counts for empty groups (i.e. for levels of
  factors that don't exist in the data).

  **\[defunct\]** For
  [`add_count()`](https://dplyr.tidyverse.org/reference/count.html):
  defunct since it can't actually affect the output.

## Fallbacks

There is no DuckDB translation in `count.duckplyr_df()`

- with complex expressions in `...`,

- with `.drop = FALSE`,

- with `sort = TRUE`.

These features fall back to
[`dplyr::count()`](https://dplyr.tidyverse.org/reference/count.html),
see
[`vignette("fallback")`](https://duckplyr.tidyverse.org/articles/fallback.md)
for details.

## See also

[`dplyr::count()`](https://dplyr.tidyverse.org/reference/count.html)

## Examples

``` r
library(duckplyr)
count(mtcars, am)
#>   am  n
#> 1  0 19
#> 2  1 13
```
