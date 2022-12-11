#' Relational API
#'
#' TBD.
#'
#' @param ... Passed on to [structure()]
#' @param class Classes added in front of the `"relational"` base class
#'
#' @export
new_relational <- function(..., class = NULL) {
  structure(..., class = unique(c(class, "relational")))
}

#' Convert a relation object to a data frame
#'
#' TBD.
#'
#' @param rel The relation object.
#' @param ... Reserved for future extensions, must be empty.
#' @return A data frame.
#' @export
#' @examples
#' rel <- rel_from_df(mtcars)
#' rel2 <- rel_filter(rel, list(expr_function("gt", list(expr_reference("cyl"), expr_constant("6")))))
rel_to_df <- function(rel, ...) {
  UseMethod("rel_to_df")
}

#' Lazily filter a relation object
#'
#' TBD.
#'
#' @inheritParams rel_to_df
#' @param exprs a list of DuckDB expressions to filter by
#' @return the now filtered relation object
#' @export
#' @examples
#' rel <- rel_from_df(mtcars)
#' rel2 <- rel_filter(rel, list(expr_function("gt", list(expr_reference("cyl"), expr_constant("6")))))
rel_filter <- function(rel, exprs, ...) {
  UseMethod("rel_filter")
}

#' Lazily project a relation object
#'
#' TBD.
#'
#' @inheritParams rel_to_df
#' @param exprs a list of DuckDB expressions to project
#' @return the now projected relation object
#' @export
#' @examples
#' rel <- rel_from_df(mtcars)
#' rel2 <- rel_project(rel, list(expr_reference("cyl"), expr_reference("disp")))
rel_project <- function(rel, exprs, ...) {
  UseMethod("rel_project")
}

#' Lazily aggregate a relation object
#'
#' TBD.
#'
#' @inheritParams rel_to_df
#' @param groups a list of DuckDB expressions to group by
#' @param aggregates a (optionally named) list of DuckDB expressions with aggregates to compute
#' @return the now aggregated relation object
#' @export
#' @examples
#' rel <- rel_from_df(mtcars)
#' aggrs <- list(avg_hp = expr_function("avg", list(expr_reference("hp"))))
#' rel2 <- rel_aggregate(rel, list(expr_reference("cyl")), aggrs)
rel_aggregate <- function(rel, groups, aggregates, ...) {
  UseMethod("rel_aggregate")
}

#' Lazily reorder a relation object
#'
#' TBD.
#'
#' @inheritParams rel_to_df
#' @param orders a list of DuckDB expressions to order by
#' @return the now aggregated relation object
#' @export
#' @examples
#' rel <- rel_from_df(mtcars)
#' rel2 <- rel_order(rel, list(expr_reference("hp")))
rel_order <- function(rel, orders, ...) {
  UseMethod("rel_order")
}

#' Lazily INNER join two relation objects
#'
#' TBD.
#'
#' @inheritParams rel_to_df
#' @param left the left-hand-side relation object
#' @param right the right-hand-side relation object
#' @param conds a list of DuckDB expressions to use for the join
#' @return a new relation object resulting from the join
#' @export
#' @examples
#' left <- rel_from_df(mtcars)
#' right <- rel_from_df(mtcars)
#' cond <- list(expr_function("eq", list(expr_reference("cyl", left), expr_reference("cyl", right))))
#' rel2 <- rel_inner_join(left, right, cond)
rel_inner_join <- function(left, right, conds, ...) {
  UseMethod("rel_inner_join")
}

#' Lazily limit the rows in a relation object
#'
#' TBD.
#'
#' @inheritParams rel_to_df
#' @param n The number of rows.
#' @export
rel_limit <- function(rel, n, ...) {
  UseMethod("rel_limit")
}

#' Lazily compute a distinct result on a relation object
#'
#' TBD.
#'
#' @inheritParams rel_to_df
#' @return a new relation object with distinct rows
#' @export
#' @examples
#' rel <- rel_from_df(mtcars)
#' rel2 <- rel_distinct(rel)
rel_distinct <- function(rel, ...) {
  UseMethod("rel_distinct")
}

#' TBD
#'
#' TBD.
#'
#' @inheritParams rel_to_df
#' @rdname rel
#' @export
rel_tostring <- function(rel, ...) {
  UseMethod("rel_tostring")
}

#' Print the EXPLAIN output for a relation object
#'
#' TBD.
#'
#' @inheritParams rel_to_df
#' @export
#' @examples
#' rel <- rel_from_df(mtcars)
#' rel_explain(rel)
rel_explain <- function(rel, ...) {
  UseMethod("rel_explain")
}

#' Get the internal alias for a relation object
#'
#' TBD.
#'
#' @inheritParams rel_to_df
#' @export
#' @examples
#' rel <- rel_from_df(mtcars)
#' rel_alias(rel)
rel_alias <- function(rel, ...) {
  UseMethod("rel_alias")
}

#' Set the internal alias for a relation object
#'
#' TBD.
#'
#' @inheritParams rel_to_df
#' @param alias the new alias
#' @export
#' @examples
#' rel <- rel_from_df(mtcars)
#' rel_set_alias(rel, "my_new_alias")
rel_set_alias <- function(rel, alias, ...) {
  UseMethod("rel_set_alias")
}

#' @rdname rel
#' @export
rel_names <- function(rel, ...) {
  UseMethod("rel_names")
}

