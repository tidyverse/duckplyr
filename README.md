
<!-- README.md and index.md are generated from README.Rmd. Please edit that file. -->

# duckplyr <a href="https://duckplyr.tidyverse.org"><img src="man/figures/logo.png" align="right" height="138" /></a>

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
[![R-CMD-check](https://github.com/tidyverse/duckplyr/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/tidyverse/duckplyr/actions/workflows/R-CMD-check.yaml)
<!-- badges: end -->

The goal of the duckplyr R package is to provide a drop-in replacement
for [dplyr](https://dplyr.tidyverse.org/) that uses
[DuckDB](https://duckdb.org/) as a backend for fast operation. DuckDB is
an in-process OLAP database management system, dplyr is the grammar of
data manipulation in the tidyverse.

duckplyr also defines a set of generics that provide a low-level
implementer’s interface for dplyr’s high-level user interface.

## Installation

Install duckplyr from CRAN with:

``` r
install.packages("duckplyr")
```

You can also install the development version of duckplyr from
R-universe:

``` r
install.packages("duckplyr", repos = c("https://tidyverse.r-universe.dev", "https://cloud.r-project.org"))
```

Or from [GitHub](https://github.com/) with:

``` r
# install.packages("pak", repos = sprintf("https://r-lib.github.io/p/pak/stable/%s/%s/%s", .Platform$pkgType, R.Version()$os, R.Version()$arch))
pak::pak("tidyverse/duckplyr")
```

## Examples

``` r
library(conflicted)
library(dplyr)
conflict_prefer("filter", "dplyr")
#> [conflicted] Will prefer dplyr::filter over any
#> other package.
```

There are two ways to use duckplyr.

1.  To enable duckplyr for individual data frames, use
    `duckplyr::as_duckplyr_tibble()` as the first step in your pipe,
    without attaching the package.
2.  By calling `library(duckplyr)`, it overwrites dplyr methods and is
    automatically enabled for the entire session without having to call
    `as_duckplyr_tibble()`. To turn this off, call `methods_restore()`.

The examples below illustrate both methods. See also the companion [demo
repository](https://github.com/Tmonster/duckplyr_demo) for a use case
with a large dataset.

### Usage for individual data frames

This example illustrates usage of duckplyr for individual data frames.

Use `duckplyr::as_duckplyr_tibble()` to enable processing with duckdb:

``` r
out <-
  palmerpenguins::penguins %>%
  # CAVEAT: factor columns are not supported yet
  mutate(across(where(is.factor), as.character)) %>%
  duckplyr::as_duckplyr_tibble() %>%
  mutate(bill_area = bill_length_mm * bill_depth_mm) %>%
  summarize(.by = c(species, sex), mean_bill_area = mean(bill_area)) %>%
  filter(species != "Gentoo")
```

The result is a tibble, with its own class.

``` r
class(out)
#> [1] "duckplyr_df" "tbl_df"      "tbl"         "data.frame"
names(out)
#> [1] "species"        "sex"            "mean_bill_area"
```

duckdb is responsible for eventually carrying out the operations.
Despite the late filter, the summary is not computed for the Gentoo
species.

``` r
out %>%
  explain()
#> ┌───────────────────────────┐
#> │          ORDER_BY         │
#> │    ────────────────────   │
#> │      dataframe_42_42      │
#> │    42.___row_number ASC   │
#> └─────────────┬─────────────┘
#> ┌─────────────┴─────────────┐
#> │           FILTER          │
#> │    ────────────────────   │
#> │   "r_base::!="(species,   │
#> │         'Gentoo')         │
#> │                           │
#> │          ~34 Rows         │
#> └─────────────┬─────────────┘
#> ┌─────────────┴─────────────┐
#> │         PROJECTION        │
#> │    ────────────────────   │
#> │             #0            │
#> │             #1            │
#> │             #2            │
#> │             #3            │
#> │                           │
#> │         ~172 Rows         │
#> └─────────────┬─────────────┘
#> ┌─────────────┴─────────────┐
#> │      STREAMING_WINDOW     │
#> │    ────────────────────   │
#> │        Projections:       │
#> │    ROW_NUMBER() OVER ()   │
#> └─────────────┬─────────────┘
#> ┌─────────────┴─────────────┐
#> │          ORDER_BY         │
#> │    ────────────────────   │
#> │      dataframe_42_42      │
#> │    42.___row_number ASC   │
#> └─────────────┬─────────────┘
#> ┌─────────────┴─────────────┐
#> │       HASH_GROUP_BY       │
#> │    ────────────────────   │
#> │          Groups:          │
#> │             #0            │
#> │             #1            │
#> │                           │
#> │        Aggregates:        │
#> │          min(#2)          │
#> │          mean(#3)         │
#> │                           │
#> │         ~172 Rows         │
#> └─────────────┬─────────────┘
#> ┌─────────────┴─────────────┐
#> │         PROJECTION        │
#> │    ────────────────────   │
#> │          species          │
#> │            sex            │
#> │       ___row_number       │
#> │         bill_area         │
#> │                           │
#> │         ~344 Rows         │
#> └─────────────┬─────────────┘
#> ┌─────────────┴─────────────┐
#> │         PROJECTION        │
#> │    ────────────────────   │
#> │             #0            │
#> │             #1            │
#> │             #2            │
#> │             #3            │
#> │                           │
#> │         ~344 Rows         │
#> └─────────────┬─────────────┘
#> ┌─────────────┴─────────────┐
#> │      STREAMING_WINDOW     │
#> │    ────────────────────   │
#> │        Projections:       │
#> │    ROW_NUMBER() OVER ()   │
#> └─────────────┬─────────────┘
#> ┌─────────────┴─────────────┐
#> │         PROJECTION        │
#> │    ────────────────────   │
#> │          species          │
#> │            sex            │
#> │         bill_area         │
#> │                           │
#> │         ~344 Rows         │
#> └─────────────┬─────────────┘
#> ┌─────────────┴─────────────┐
#> │     R_DATAFRAME_SCAN      │
#> │    ────────────────────   │
#> │         data.frame        │
#> │                           │
#> │        Projections:       │
#> │          species          │
#> │       bill_length_mm      │
#> │       bill_depth_mm       │
#> │            sex            │
#> │                           │
#> │         ~344 Rows         │
#> └───────────────────────────┘
```

All data frame operations are supported. Computation happens upon the
first request.

``` r
out$mean_bill_area
#> duckplyr: materializing
#> [1] 770.2627 656.8523 694.9360 819.7503 984.2279
```

After the computation has been carried out, the results are available
immediately:

``` r
out
#> # A tibble: 5 × 3
#>   species   sex    mean_bill_area
#>   <chr>     <chr>           <dbl>
#> 1 Adelie    male             770.
#> 2 Adelie    female           657.
#> 3 Adelie    NA               695.
#> 4 Chinstrap female           820.
#> 5 Chinstrap male             984.
```

### Session-wide usage

This example illustrates usage of duckplyr for all data frames in the R
session.

Use `library(duckplyr)` or `duckplyr::methods_overwrite()` to overwrite
dplyr methods and enable processing with duckdb for all data frames:

``` r
duckplyr::methods_overwrite()
#> ✔ Overwriting dplyr methods with duckplyr methods.
#> ℹ Turn off with `duckplyr::methods_restore()`.
```

This is the same query as above, without `as_duckplyr_tibble()`:

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
#> duckplyr: materializing
#> [1] 5
```

Restart R, or call `duckplyr::methods_restore()` to revert to the
default dplyr implementation.

``` r
duckplyr::methods_restore()
#> ℹ Restoring dplyr methods.
```

dplyr is active again:

``` r
palmerpenguins::penguins %>%
  # CAVEAT: factor columns are not supported yet
  mutate(across(where(is.factor), as.character)) %>%
  mutate(bill_area = bill_length_mm * bill_depth_mm) %>%
  summarize(.by = c(species, sex), mean_bill_area = mean(bill_area)) %>%
  filter(species != "Gentoo")
#> # A tibble: 5 × 3
#>   species   sex    mean_bill_area
#>   <chr>     <chr>           <dbl>
#> 1 Adelie    male             770.
#> 2 Adelie    female           657.
#> 3 Adelie    NA                NA 
#> 4 Chinstrap female           820.
#> 5 Chinstrap male             984.
```

## Telemetry

We would like to guide our efforts towards improving duckplyr, focusing
on the features with the most impact. To this end, duckplyr collects and
uploads telemetry data, but only if permitted by the user:

- No collection will happen unless the user explicitly opts in.
- Uploads are done upon request only.
- There is an option to automatically upload when the package is loaded,
  this is also opt-in.

The data collected contains:

- The package version
- The error message
- The operation being performed, and the arguments
  - For the input data frames, only the structure is included (column
    types only), no column names or data

The first time the package encounters an unsupported function, data
type, or operation, instructions are printed to the console.

``` r
palmerpenguins::penguins %>%
  duckplyr::as_duckplyr_tibble() %>%
  transmute(bill_area = bill_length_mm * bill_depth_mm) %>%
  head(3)
#> The duckplyr package is configured to fall back to dplyr when it encounters an
#> incompatibility. Fallback events can be collected and uploaded for analysis to
#> guide future development. By default, no data will be collected or uploaded.
#> ℹ A fallback situation just occurred. The following information would have been
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
#> ℹ See `?duckplyr::fallback()` for details.
#> ℹ This message will be displayed once every eight hours.
#> duckplyr: materializing
#> # A tibble: 3 × 1
#>   bill_area
#>       <dbl>
#> 1      731.
#> 2      687.
#> 3      725.
```

## How is this different from dbplyr?

The duckplyr package is a dplyr backend that uses DuckDB, a
high-performance, embeddable OLAP database. It is designed to be a fully
compatible drop-in replacement for dplyr, with *exactly* the same syntax
and semantics:

- Input and output are data frames or tibbles
- All dplyr verbs are supported, with fallback
- All R data types and functions are supported, with fallback
- No SQL is generated

The dbplyr package is a dplyr backend that connects to SQL databases,
and is designed to work with various databases that support SQL,
including DuckDB. Data must be copied into and collected from the
database, and the syntax and semantics are similar but not identical to
plain dplyr.

## Extensibility

This package also provides generics, for which other packages may then
implement methods.

``` r
library(duckplyr)
```

    #> ✔ Overwriting dplyr methods with duckplyr methods.
    #> ℹ Turn off with `duckplyr::methods_restore()`.

``` r
# Create a relational to be used by examples below
new_dfrel <- function(x) {
  stopifnot(is.data.frame(x))
  new_relational(list(x), class = "dfrel")
}
mtcars_rel <- new_dfrel(mtcars[1:5, 1:4])

# Example 1: return a data.frame
rel_to_df.dfrel <- function(rel, ...) {
  unclass(rel)[[1]]
}
rel_to_df(mtcars_rel)
#>                    mpg cyl disp  hp
#> Mazda RX4         21.0   6  160 110
#> Mazda RX4 Wag     21.0   6  160 110
#> Datsun 710        22.8   4  108  93
#> Hornet 4 Drive    21.4   6  258 110
#> Hornet Sportabout 18.7   8  360 175

# Example 2: A (random) filter
rel_filter.dfrel <- function(rel, exprs, ...) {
  df <- unclass(rel)[[1]]

  # A real implementation would evaluate the predicates defined
  # by the exprs argument
  new_dfrel(df[sample.int(nrow(df), 3, replace = TRUE), ])
}

rel_filter(
  mtcars_rel,
  list(
    relexpr_function(
      "gt",
      list(relexpr_reference("cyl"), relexpr_constant("6"))
    )
  )
)
#> [[1]]
#>                  mpg cyl disp  hp
#> Mazda RX4 Wag   21.0   6  160 110
#> Mazda RX4 Wag.1 21.0   6  160 110
#> Datsun 710      22.8   4  108  93
#> 
#> attr(,"class")
#> [1] "dfrel"      "relational"

# Example 3: A custom projection
rel_project.dfrel <- function(rel, exprs, ...) {
  df <- unclass(rel)[[1]]

  # A real implementation would evaluate the expressions defined
  # by the exprs argument
  new_dfrel(df[seq_len(min(3, base::ncol(df)))])
}

rel_project(
  mtcars_rel,
  list(relexpr_reference("cyl"), relexpr_reference("disp"))
)
#> [[1]]
#>                    mpg cyl disp
#> Mazda RX4         21.0   6  160
#> Mazda RX4 Wag     21.0   6  160
#> Datsun 710        22.8   4  108
#> Hornet 4 Drive    21.4   6  258
#> Hornet Sportabout 18.7   8  360
#> 
#> attr(,"class")
#> [1] "dfrel"      "relational"

# Example 4: A custom ordering (eg, ascending by mpg)
rel_order.dfrel <- function(rel, exprs, ...) {
  df <- unclass(rel)[[1]]

  # A real implementation would evaluate the expressions defined
  # by the exprs argument
  new_dfrel(df[order(df[[1]]), ])
}

rel_order(
  mtcars_rel,
  list(relexpr_reference("mpg"))
)
#> [[1]]
#>                    mpg cyl disp  hp
#> Hornet Sportabout 18.7   8  360 175
#> Mazda RX4         21.0   6  160 110
#> Mazda RX4 Wag     21.0   6  160 110
#> Hornet 4 Drive    21.4   6  258 110
#> Datsun 710        22.8   4  108  93
#> 
#> attr(,"class")
#> [1] "dfrel"      "relational"

# Example 5: A custom join
rel_join.dfrel <- function(left, right, conds, join, ...) {
  left_df <- unclass(left)[[1]]
  right_df <- unclass(right)[[1]]

  # A real implementation would evaluate the expressions
  # defined by the conds argument,
  # use different join types based on the join argument,
  # and implement the join itself instead of relaying to left_join().
  new_dfrel(dplyr::left_join(left_df, right_df))
}

rel_join(new_dfrel(data.frame(mpg = 21)), mtcars_rel)
#> Joining with `by = join_by(mpg)`
#> Joining with `by = join_by(mpg)`
#> [[1]]
#>   mpg cyl disp  hp
#> 1  21   6  160 110
#> 2  21   6  160 110
#> 
#> attr(,"class")
#> [1] "dfrel"      "relational"

# Example 6: Limit the maximum rows returned
rel_limit.dfrel <- function(rel, n, ...) {
  df <- unclass(rel)[[1]]

  new_dfrel(df[seq_len(n), ])
}

rel_limit(mtcars_rel, 3)
#> [[1]]
#>                mpg cyl disp  hp
#> Mazda RX4     21.0   6  160 110
#> Mazda RX4 Wag 21.0   6  160 110
#> Datsun 710    22.8   4  108  93
#> 
#> attr(,"class")
#> [1] "dfrel"      "relational"

# Example 7: Suppress duplicate rows
#  (ignoring row names)
rel_distinct.dfrel <- function(rel, ...) {
  df <- unclass(rel)[[1]]

  new_dfrel(df[!duplicated(df), ])
}

rel_distinct(new_dfrel(mtcars[1:3, 1:4]))
#> [[1]]
#>             mpg cyl disp  hp
#> Mazda RX4  21.0   6  160 110
#> Datsun 710 22.8   4  108  93
#> 
#> attr(,"class")
#> [1] "dfrel"      "relational"

# Example 8: Return column names
rel_names.dfrel <- function(rel, ...) {
  df <- unclass(rel)[[1]]

  names(df)
}

rel_names(mtcars_rel)
#> [1] "mpg"  "cyl"  "disp" "hp"
```
