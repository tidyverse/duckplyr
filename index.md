
<!-- README.md and index.md are generated from README.Rmd. Please edit that file. -->



# duckplyr <a href="https://duckplyr.tidyverse.org"><img src="man/figures/logo.png" align="right" height="138" /></a>

<!-- badges: start -->
[![Lifecycle: experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
[![R-CMD-check](https://github.com/tidyverse/duckplyr/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/tidyverse/duckplyr/actions/workflows/R-CMD-check.yaml)
<!-- badges: end -->

> A **drop-in replacement for [dplyr](https://dplyr.tidyverse.org/)** that uses **[DuckDB](https://duckdb.org/)** as a backend for **fast operation**.

[DuckDB](https://duckdb.org/) is an in-process analytical database management system, 
[dplyr](https://dplyr.tidyverse.org/) is the grammar of data manipulation in the tidyverse.

If you are new to dplyr, the best place to start is the [data transformation chapter](If you are new to dplyr, the best place to start is the data transformation chapter in R for Data Science.) in R for Data Science.

## Installation

Install duckplyr from CRAN with:

``` r
install.packages("duckplyr")
```

You can also install the development version of duckplyr from [R-universe](https://tidyverse.r-universe.dev/builds):

``` r
install.packages("duckplyr", repos = c("https://tidyverse.r-universe.dev", "https://cloud.r-project.org"))
```

Or from [GitHub](https://github.com/) with:

``` r
# install.packages("pak", repos = sprintf("https://r-lib.github.io/p/pak/stable/%s/%s/%s", .Platform$pkgType, R.Version()$os, R.Version()$arch))
pak::pak("tidyverse/duckplyr")
```


## Example


``` r
library(conflicted)
library(dplyr)
conflict_prefer("filter", "dplyr", quiet = TRUE)
library(duckplyr)
```

Calling `library(duckplyr)` overwrites dplyr methods,
enabling duckplyr instead for the entire session. 
To turn this off, call `methods_restore()`.

See also the companion [demo repository](https://github.com/Tmonster/duckplyr_demo) for a use case with a large dataset.

This example illustrates usage of duckplyr for all data frames in the R session 
("session-wide").

Use `library(duckplyr)` or `duckplyr::methods_overwrite()` to overwrite dplyr methods and enable processing with duckdb for all data frames:


``` r
duckplyr::methods_overwrite()
```





``` r
out <-
  palmerpenguins::penguins %>%
  # CAVEAT: factor columns are not supported yet
  mutate(across(where(is.factor), as.character)) %>%
  mutate(bill_area = bill_length_mm * bill_depth_mm) %>%
  summarize(.by = c(species, sex), mean_bill_area = mean(bill_area)) %>%
  filter(species != "Gentoo")
```

The result is a plain tibble now:


``` r
class(out)
#> [1] "tbl_df"     "tbl"        "data.frame"
```

Querying the number of rows also starts the computation:


``` r
nrow(out)
#> [1] 5
```

Restart R, or call `duckplyr::methods_restore()` to revert to the default dplyr implementation.


``` r
duckplyr::methods_restore()
#> [1m[22m[36mℹ[39m Restoring [34mdplyr[39m methods.
```

dplyr is active again:


``` r
palmerpenguins::penguins %>%
  # CAVEAT: factor columns are not supported yet
  mutate(across(where(is.factor), as.character)) %>%
  mutate(bill_area = bill_length_mm * bill_depth_mm) %>%
  summarize(.by = c(species, sex), mean_bill_area = mean(bill_area)) %>%
  filter(species != "Gentoo")
#> [38;5;246m# A tibble: 5 × 3[39m
#>   species   sex    mean_bill_area
#>   [3m[38;5;246m<chr>[39m[23m     [3m[38;5;246m<chr>[39m[23m           [3m[38;5;246m<dbl>[39m[23m
#> [38;5;250m1[39m Adelie    male             770.
#> [38;5;250m2[39m Adelie    female           657.
#> [38;5;250m3[39m Adelie    [31mNA[39m                [31mNA[39m 
#> [38;5;250m4[39m Chinstrap female           820.
#> [38;5;250m5[39m Chinstrap male             984.
```


## Using duckplyr in other packages

Refer to `vignette("developers", package = "duckplyr")`.

## Telemetry

We would like to guide our efforts towards improving duckplyr, focusing on the features with the most impact.
To this end, duckplyr collects and uploads telemetry data, but only if permitted by the user:

- No collection will happen unless the user explicitly opts in.
- Uploads are done upon request only.
- There is an option to automatically upload when the package is loaded, this is also opt-in.

The data collected contains:

- The package version
- The error message
- The operation being performed, and the arguments
    - For the input data frames, only the structure is included (column types only), no column names or data

The first time the package encounters an unsupported function, data type, or operation, instructions are printed to the console.




``` r
palmerpenguins::penguins %>%
  duckplyr::as_duckplyr_tibble() %>%
  transmute(bill_area = bill_length_mm * bill_depth_mm) %>%
  head(3)
#> [1m[22mThe [34mduckplyr[39m package is configured to fall back to [34mdplyr[39m when it encounters an
#> incompatibility. Fallback events can be collected and uploaded for analysis to
#> guide future development. By default, no data will be collected or uploaded.
#> [36mℹ[39m A fallback situation just occurred. The following information would have been
#>   recorded:
#>   {"version":"0.4.1","message":"Can't convert columns of class <factor> to
#>   relational. Affected
#>   column:\n`...1`.","name":"transmute","x":{"...1":"factor","...2":"factor","...3":"numeric","...4":"numeric","...5":"integer","...6":"integer","...7":"factor","...8":"integer"},"args":{"dots":{"...9":"...3
#>   * ...4"}}}
#> → Run `duckplyr::fallback_sitrep()` to review the current settings.
#> → Run `Sys.setenv(DUCKPLYR_FALLBACK_COLLECT = 1)` to enable fallback logging,
#>   and `Sys.setenv(DUCKPLYR_FALLBACK_VERBOSE = TRUE)` in addition to enable
#>   printing of fallback situations to the console.
#> → Run `duckplyr::fallback_review()` to review the available reports, and
#>   `duckplyr::fallback_upload()` to upload them.
#> [36mℹ[39m See `?duckplyr::fallback()` for details.
#> [36mℹ[39m [90mThis message will be displayed once every eight hours.[39m
#> duckplyr: materializing, review details with duckplyr::last_rel()
#> [38;5;246m# A tibble: 3 × 1[39m
#>   bill_area
#>       [3m[38;5;246m<dbl>[39m[23m
#> [38;5;250m1[39m      731.
#> [38;5;250m2[39m      687.
#> [38;5;250m3[39m      725.
```

## How is this different from dbplyr?

The duckplyr package is a dplyr backend that uses DuckDB, a high-performance, embeddable analytical database.
It is designed to be a fully compatible drop-in replacement for dplyr, with *exactly* the same syntax and semantics:

- Input and output are data frames or tibbles.
- All dplyr verbs are supported, with fallback.
- All R data types and functions are supported, with fallback.
- No SQL is generated.

The dbplyr package is a dplyr backend that connects to SQL databases, and is designed to work with various databases that support SQL, including DuckDB.
Data must be copied into and collected from the database, and the syntax and semantics are similar but not identical to plain dplyr.
