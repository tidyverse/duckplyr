# Interoperability with DuckDB and dbplyr

This article describes how to use the full power of DuckDB with
duckplyr. Two options are discussed: interoperability with dbplyr and
the use of DuckDB’s functions in duckplyr.

``` r
library(conflicted)
library(duckplyr)
#> Loading required package: dplyr
#> ✔ Overwriting dplyr methods with duckplyr methods.
#> ℹ Turn off with `duckplyr::methods_restore()`.
conflict_prefer("filter", "dplyr")
#> [conflicted] Will prefer dplyr::filter
#> over any other package.
```

## Introduction

The duckplyr package is a drop-in replacement for dplyr, designed to
work with DuckDB as the backend. There is a translation layer that
converts R function calls to DuckDB functions or macros, aiming at full
compatibility with R. Many functions are translated already, and many
more are not. For functions that cannot be translated, duckplyr falls
back to the original R implementation, disrupting the DuckDB pipeline
and materializing intermediate results.

Furthermore, DuckDB has functions with no R equivalent. These might be
used already by code that interacts with DuckDB through dbplyr, either
making use of its passthrough feature (unknown functions are translated
to SQL verbatim), or by using the `mutate(x = sql(...))` pattern. When
working with duckplyr, this functionality is still accessible, albeit
through experimental interfaces:

- [`as_tbl()`](https://duckplyr.tidyverse.org/dev/reference/as_tbl.md)
  converts a duckplyr table to a duckdb `tbl` object
- for a duckplyr table, the escape hatch `dd$fun(...)` can be used to
  call arbitrary DuckDB functions

## From duckplyr to dbplyr

The experimental
[`as_tbl()`](https://duckplyr.tidyverse.org/dev/reference/as_tbl.md)
function, introduced in duckplyr 1.1.0, transparently converts a
duckplyr frame to a dbplyr `tbl` object:

``` r
df <- duckdb_tibble(a = 2L)
df
#> # A duckplyr data frame: 1 variable
#>       a
#>   <int>
#> 1     2

tbl <- as_tbl(df)
tbl
#> # Source:   table<as_tbl_duckplyr_SwlKLUUEdL> [?? x 1]
#> # Database: DuckDB 1.4.4 [unknown@Linux 6.11.0-1018-azure:R 4.5.2//tmp/RtmpLEdC2d/duckplyr/duckplyr3b80f2fa7e4.duckdb]
#>       a
#>   <int>
#> 1     2
```

It achieves this by creating a temporary view that points to the
relational object created internally by duckplyr, in the same DBI
connection as the duckplyr object. No data is copied in this operation.
The view is discarded when the `tbl` object goes out of scope.

This allows using arbitrary SQL code, either through
[`sql()`](https://dplyr.tidyverse.org/reference/sql.html) or by relying
on dbplyr’s passthrough feature.

``` r
tbl %>%
  mutate(b = sql("a + 1"), c = least_common_multiple(a, b)) %>%
  show_query()
#> <SQL>
#> SELECT q01.*, least_common_multiple(a, b) AS c
#> FROM (
#>   SELECT as_tbl_duckplyr_SwlKLUUEdL.*, a + 1 AS b
#>   FROM as_tbl_duckplyr_SwlKLUUEdL
#> ) q01
```

There is no R function called `least_common_multiple()`, it is
interpreted as a SQL function.

``` r
least_common_multiple(2, 3)
#> Error in `least_common_multiple()`:
#> ! could not find function "least_common_multiple"
```

``` r
tbl %>%
  mutate(b = sql("a + 1"), c = least_common_multiple(a, b))
#> # Source:   SQL [?? x 3]
#> # Database: DuckDB 1.4.4 [unknown@Linux 6.11.0-1018-azure:R 4.5.2//tmp/RtmpLEdC2d/duckplyr/duckplyr3b80f2fa7e4.duckdb]
#>       a     b     c
#>   <int> <int> <dbl>
#> 1     2     3     6
```

To continue processing with duckplyr, use
[`as_duckdb_tibble()`](https://duckplyr.tidyverse.org/dev/reference/duckdb_tibble.md):

``` r
tbl %>%
  mutate(b = sql("a + 1"), c = least_common_multiple(a, b)) %>%
  as_duckdb_tibble()
#> # A duckplyr data frame: 3 variables
#>       a     b     c
#>   <int> <int> <dbl>
#> 1     2     3     6
```

## Call arbitrary functions in duckplyr

The escape hatch, also introduced in duckplyr 1.1.0, allows calling
arbitrary DuckDB functions directly from duckplyr, without going through
SQL:

``` r
duckdb_tibble(a = 2L, b = 3L) %>%
  mutate(c = dd$least_common_multiple(a, b))
#> # A duckplyr data frame: 3 variables
#>       a     b     c
#>   <int> <int> <dbl>
#> 1     2     3     6
```

The `dd` prefix has been picked for the following reasons:

- it is an abbreviation of “DuckDB”
- it is short and easy to type
- there is no package of this name
- objects are not commonly named `dd` in R

A prefix is necessary to avoid name clashes with existing R functions.
If this is used widely, large-scale code analysis may help prioritize
the translation of functions that are not yet supported by duckplyr.

The [dd package](https://github.com/cynkra/dd), when attached, will
provide a `dd` object containing many known DuckDB functions. This adds
support for autocomplete:

![Screenshot for autocomplete with the dd package](dd.png)

Screenshot for autocomplete with the dd package

This package is not necessary to use duckplyr, and the list of functions
is incomplete and growing. In case you’re wondering:

``` r
duckdb_tibble(a = "dbplyr", b = "duckplyr") %>%
  mutate(c = dd$damerau_levenshtein(a, b))
#> # A duckplyr data frame: 3 variables
#>   a      b            c
#>   <chr>  <chr>    <dbl>
#> 1 dbplyr duckplyr     3
```

## Conclusion

While duckplyr is designed to be a drop-in replacement for dplyr, it
still allows to harness most if not all of the power of DuckDB.

See
[`vignette("limits")`](https://duckplyr.tidyverse.org/dev/articles/limits.md)
for limitations in the translation employed by duckplyr,
[`vignette("fallback")`](https://duckplyr.tidyverse.org/dev/articles/fallback.md)
for more information on fallback, and
[`vignette("telemetry")`](https://duckplyr.tidyverse.org/dev/articles/telemetry.md)
for existing attempts to prioritize work on the translation layer.
