# Relational implementer's interface

The constructor and generics described here define a class that helps
separating dplyr's user interface from the actual underlying operations.
In the longer term, this will help packages that implement the dplyr
interface (such as dbplyr, dtplyr, arrow and similar) to focus on the
core details of their functionality, rather than on the intricacies of
dplyr's user interface.

`new_relational()` constructs an object of class `"relational"`. Users
are encouraged to provide the `class` argument. The typical use case
will be to create a wrapper function.

`rel_to_df()` extracts a data frame representation from a relational
object, to be used by
[`dplyr::collect()`](https://dplyr.tidyverse.org/reference/compute.html).

`rel_filter()` keeps rows that match a predicate, to be used by
[`dplyr::filter()`](https://dplyr.tidyverse.org/reference/filter.html).

`rel_project()` selects columns or creates new columns, to be used by
[`dplyr::select()`](https://dplyr.tidyverse.org/reference/select.html),
[`dplyr::rename()`](https://dplyr.tidyverse.org/reference/rename.html),
[`dplyr::mutate()`](https://dplyr.tidyverse.org/reference/mutate.html),
[`dplyr::relocate()`](https://dplyr.tidyverse.org/reference/relocate.html),
and others.

`rel_aggregate()` combines several rows into one, to be used by
[`dplyr::summarize()`](https://dplyr.tidyverse.org/reference/summarise.html).

`rel_order()` reorders rows by columns or expressions, to be used by
[`dplyr::arrange()`](https://dplyr.tidyverse.org/reference/arrange.html).

`rel_join()` joins or merges two tables, to be used by
[`dplyr::left_join()`](https://dplyr.tidyverse.org/reference/mutate-joins.html),
[`dplyr::right_join()`](https://dplyr.tidyverse.org/reference/mutate-joins.html),
[`dplyr::inner_join()`](https://dplyr.tidyverse.org/reference/mutate-joins.html),
[`dplyr::full_join()`](https://dplyr.tidyverse.org/reference/mutate-joins.html),
[`dplyr::cross_join()`](https://dplyr.tidyverse.org/reference/cross_join.html),
[`dplyr::semi_join()`](https://dplyr.tidyverse.org/reference/filter-joins.html),
and
[`dplyr::anti_join()`](https://dplyr.tidyverse.org/reference/filter-joins.html).

`rel_limit()` limits the number of rows in a table, to be used by
[`utils::head()`](https://rdrr.io/r/utils/head.html).

`rel_distinct()` only keeps the distinct rows in a table, to be used by
[`dplyr::distinct()`](https://dplyr.tidyverse.org/reference/distinct.html).

`rel_set_intersect()` returns rows present in both tables, to be used by
[`generics::intersect()`](https://generics.r-lib.org/reference/setops.html).

`rel_set_diff()` returns rows present in any of both tables, to be used
by
[`generics::setdiff()`](https://generics.r-lib.org/reference/setops.html).

`rel_set_symdiff()` returns rows present in any of both tables, to be
used by
[`dplyr::symdiff()`](https://dplyr.tidyverse.org/reference/setops.html).

`rel_union_all()` returns rows present in any of both tables, to be used
by
[`dplyr::union_all()`](https://dplyr.tidyverse.org/reference/setops.html).

`rel_explain()` prints an explanation of the plan executed by the
relational object.

`rel_alias()` returns the alias name for a relational object.

`rel_set_alias()` sets the alias name for a relational object.

`rel_names()` returns the column names as character vector, to be used
by [`colnames()`](https://rdrr.io/r/base/colnames.html).

## Usage

``` r
new_relational(..., class = NULL)

rel_to_df(rel, ...)

rel_filter(rel, exprs, ...)

rel_project(rel, exprs, ...)

rel_aggregate(rel, groups, aggregates, ...)

rel_order(rel, orders, ascending, ...)

rel_join(
  left,
  right,
  conds,
  join = c("inner", "left", "right", "outer", "cross", "semi", "anti"),
  join_ref_type = c("regular", "natural", "cross", "positional", "asof"),
  ...
)

rel_limit(rel, n, ...)

rel_distinct(rel, ...)

rel_set_intersect(rel_a, rel_b, ...)

rel_set_diff(rel_a, rel_b, ...)

rel_set_symdiff(rel_a, rel_b, ...)

rel_union_all(rel_a, rel_b, ...)

rel_explain(rel, ...)

rel_alias(rel, ...)

rel_set_alias(rel, alias, ...)

rel_names(rel, ...)
```

## Arguments

- ...:

  Reserved for future extensions, must be empty.

- class:

  Classes added in front of the `"relational"` base class.

- rel, rel_a, rel_b, left, right:

  A relational object.

- exprs:

  A list of `"relational_relexpr"` objects to filter by, created by
  [`new_relexpr()`](https://duckplyr.tidyverse.org/reference/new_relexpr.md).

- groups:

  A list of expressions to group by.

- aggregates:

  A list of expressions with aggregates to compute.

- orders:

  A list of expressions to order by.

- ascending:

  A logical vector describing the sort order.

- conds:

  A list of expressions to use for the join.

- join:

  The type of join.

- join_ref_type:

  The ref type of join.

- n:

  The number of rows.

- alias:

  the new alias

## Value

- `new_relational()` returns a new relational object.

- `rel_to_df()` returns a data frame.

- `rel_names()` returns a character vector.

- All other generics return a modified relational object.

## Examples

``` r
new_dfrel <- function(x) {
  stopifnot(is.data.frame(x))
  new_relational(list(x), class = "dfrel")
}
mtcars_rel <- new_dfrel(mtcars[1:5, 1:4])

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

rel_filter.dfrel <- function(rel, exprs, ...) {
  df <- unclass(rel)[[1]]

  # A real implementation would evaluate the predicates defined
  # by the exprs argument
  new_dfrel(df[seq_len(min(3, nrow(df))), ])
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
#>                mpg cyl disp  hp
#> Mazda RX4     21.0   6  160 110
#> Mazda RX4 Wag 21.0   6  160 110
#> Datsun 710    22.8   4  108  93
#> 
#> attr(,"class")
#> [1] "dfrel"      "relational"

rel_project.dfrel <- function(rel, exprs, ...) {
  df <- unclass(rel)[[1]]

  # A real implementation would evaluate the expressions defined
  # by the exprs argument
  new_dfrel(df[seq_len(min(3, ncol(df)))])
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
#> [[1]]
#>   mpg cyl disp  hp
#> 1  21   6  160 110
#> 2  21   6  160 110
#> 
#> attr(,"class")
#> [1] "dfrel"      "relational"

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

rel_names.dfrel <- function(rel, ...) {
  df <- unclass(rel)[[1]]

  names(df)
}

rel_names(mtcars_rel)
#> [1] "mpg"  "cyl"  "disp" "hp"  
```
