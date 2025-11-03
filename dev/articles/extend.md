# Implementer's interface

``` r
library(conflicted)
library(dplyr)
conflict_prefer("filter", "dplyr")
#> [conflicted] Will prefer dplyr::filter
#> over any other package.
```

duckplyr also defines a set of generics that provide a low-level
implementer’s interface for dplyr’s high-level user interface. Other
packages may then implement methods for those generics.

``` r
library(conflicted)
library(dplyr)
conflict_prefer("filter", "dplyr")
#> [conflicted] Removing existing preference.
#> [conflicted] Will prefer dplyr::filter over any other package.
library(duckplyr)
#> ✔ Overwriting dplyr methods with duckplyr methods.
#> ℹ Turn off with `duckplyr::methods_restore()`.
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
#>                      mpg cyl disp  hp
#> Hornet Sportabout   18.7   8  360 175
#> Hornet 4 Drive      21.4   6  258 110
#> Hornet Sportabout.1 18.7   8  360 175
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
