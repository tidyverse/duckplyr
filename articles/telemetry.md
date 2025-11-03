# Telemetry

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

As a drop-in replacement for dplyr, duckplyr will use DuckDB for the
operations only if it can, and fall back to dplyr otherwise. A fallback
will not change the correctness of the results, but it may be slower or
consume more memory. We would like to guide our efforts towards
improving duckplyr, focusing on the features with the most impact. To
this end, duckplyr collects and uploads telemetry data about fallback
situations, but only if permitted by the user:

- Collection is on by default, but can be turned off.
- Uploads are done upon request only.
- There is an option to automatically upload when the package is loaded,
  this is also opt-in.

The data collected contains:

- The package version
- The error message
- The operation being performed, and the arguments
  - For the input data frames, only the structure is included (column
    types only), no column names or data

Fallback is silent by default, but can be made verbose.

``` r
Sys.setenv(DUCKPLYR_FALLBACK_INFO = TRUE)
out <-
  flights_df() |>
  summarize(.by = origin, paste(dest, collapse = " "))
#> Error processing duckplyr query with DuckDB, falling back to dplyr.
#> Caused by error in `summarize()`:
#> ! Can't translate function `paste()`.
```

After logs have been collected, the upload options are displayed the
next time the duckplyr package is loaded in an R session.

The
[`fallback_sitrep()`](https://duckplyr.tidyverse.org/reference/fallback.md)
function describes the current configuration and the available options.

See
[`vignette("fallback")`](https://duckplyr.tidyverse.org/articles/fallback.md)
for details on the fallback mechanism.
