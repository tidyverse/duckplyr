# Forward all dplyr methods to duckplyr

After calling `methods_overwrite()`, all dplyr methods are redirected to
duckplyr for the duraton of the session, or until a call to
`methods_restore()`. The `methods_overwrite()` function is called
automatically when the package is loaded if the environment variable
`DUCKPLYR_METHODS_OVERWRITE` is set to `TRUE`.

## Usage

``` r
methods_overwrite()

methods_restore()
```

## Value

Called for their side effects.

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

methods_overwrite()
#> ✔ Overwriting dplyr methods with duckplyr methods.
#> ℹ Turn off with `duckplyr::methods_restore()`.

tibble(a = 1:3) %>%
  mutate(b = a + 1)
#> # A tibble: 3 × 2
#>       a     b
#>   <int> <dbl>
#> 1     1     2
#> 2     2     3
#> 3     3     4

methods_restore()
#> ℹ Restoring dplyr methods.

tibble(a = 1:3) %>%
  mutate(b = a + 1)
#> # A tibble: 3 × 2
#>       a     b
#>   <int> <dbl>
#> 1     1     2
#> 2     2     3
#> 3     3     4
```
