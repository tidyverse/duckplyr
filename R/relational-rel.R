rel_stats_env <- new.env(parent = emptyenv(), size = 937L)

rel_stats_clean <- function() {
  rm(list = ls(rel_stats_env, all.names = TRUE), pos = rel_stats_env)
}

#' Relational API
#'
#' TBD.
#'
#' @param ... Passed on to [structure()]
#' @param class Classes added in front of the `"relational"` base class
#'
#' @return A (new/modified) relational object.
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
#' @examplesIf FALSE
#' rel <- rel_from_df(mtcars)
#' rel2 <- rel_filter(
#'   rel,
#'   list(
#'     relexpr_function(
#'       "gt",
#'       list(relexpr_reference("cyl"), relexpr_constant("6"))
#'    )
#'   )
#'  )
rel_to_df <- function(rel, ...) {
  rel_stats_env$rel_to_df <- (rel_stats_env$rel_to_df %||% 0L) + 1L
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
#' @examplesIf FALSE
#' rel <- rel_from_df(mtcars)
#' rel2 <- rel_filter(
#'   rel,
#'   list(
#'     relexpr_function(
#'       "gt",
#'       list(relexpr_reference("cyl"), relexpr_constant("6")))
#'   )
#' )
rel_filter <- function(rel, exprs, ...) {
  rel_stats_env$rel_filter <- (rel_stats_env$rel_filter %||% 0L) + 1L
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
#' @examplesIf FALSE
#' rel <- rel_from_df(mtcars)
#' rel2 <- rel_project(rel, list(relexpr_reference("cyl"), relexpr_reference("disp")))
rel_project <- function(rel, exprs, ...) {
  rel_stats_env$rel_project <- (rel_stats_env$rel_project %||% 0L) + 1L
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
#' @examplesIf FALSE
#' rel <- rel_from_df(mtcars)
#' aggrs <- list(avg_hp = relexpr_function("avg", list(relexpr_reference("hp"))))
#' rel2 <- rel_aggregate(rel, list(relexpr_reference("cyl")), aggrs)
rel_aggregate <- function(rel, groups, aggregates, ...) {
  rel_stats_env$rel_aggregate <- (rel_stats_env$rel_aggregate %||% 0L) + 1L
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
#' @examplesIf FALSE
#' rel <- rel_from_df(mtcars)
#' rel2 <- rel_order(rel, list(relexpr_reference("hp")))
rel_order <- function(rel, orders, ...) {
  rel_stats_env$rel_order <- (rel_stats_env$rel_order %||% 0L) + 1L
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
#' @param join type of join
#' @return a new relation object resulting from the join
#' @export
#' @examplesIf FALSE
#' \dontrun{
#' left <- rel_from_df(mtcars)
#' right <- rel_from_df(mtcars)
#' cond <- list(
#'   relexpr_function(
#'     "eq",
#'     list(relexpr_reference("cyl", left), relexpr_reference("cyl", right))
#'   )
#' )
#' rel2 <- rel_join(left, right, cond)
#' }
rel_join <- function(left, right, conds, join, ...) {
  rel_stats_env$rel_join <- (rel_stats_env$rel_join %||% 0L) + 1L
  UseMethod("rel_join")
}

#' Lazily limit the rows in a relation object
#'
#' TBD.
#'
#' @inheritParams rel_to_df
#' @param n The number of rows.
#' @return A (new/modified) relational object.
#' @export
rel_limit <- function(rel, n, ...) {
  rel_stats_env$rel_limit <- (rel_stats_env$rel_limit %||% 0L) + 1L
  UseMethod("rel_limit")
}

#' Lazily compute a distinct result on a relation object
#'
#' TBD.
#'
#' @inheritParams rel_to_df
#' @return a new relation object with distinct rows
#' @export
#' @examplesIf FALSE
#' rel <- rel_from_df(mtcars)
#' rel2 <- rel_distinct(rel)
rel_distinct <- function(rel, ...) {
  rel_stats_env$rel_distinct <- (rel_stats_env$rel_distinct %||% 0L) + 1L
  UseMethod("rel_distinct")
}

#' Lazily compute a set_intersect result on a relation object
#'
#' TBD.
#'
#' @inheritParams rel_to_df
#' @param rel_a a DuckDB relation object
#' @param rel_b a DuckDB relation object
#' @return a new relation object with the result
#' @export
#' @examplesIf FALSE
#' rel <- rel_from_df(mtcars)
#' rel2 <- rel_set_intersect(rel)
rel_set_intersect <- function(rel_a, rel_b, ...) {
  rel_stats_env$rel_set_intersect <- (rel_stats_env$rel_set_intersect %||% 0L) + 1L
  UseMethod("rel_set_intersect")
}

#' Lazily compute a set_diff result on a relation object
#'
#' TBD.
#'
#' @inheritParams rel_to_df
#' @inheritParams rel_set_intersect
#' @return a new relation object with the result
#' @export
#' @examplesIf FALSE
#' rel <- rel_from_df(mtcars)
#' rel2 <- rel_set_diff(rel)
rel_set_diff <- function(rel_a, rel_b, ...) {
  rel_stats_env$rel_set_diff <- (rel_stats_env$rel_set_diff %||% 0L) + 1L
  UseMethod("rel_set_diff")
}

#' Lazily compute a set_symdiff result on a relation object
#'
#' TBD.
#'
#' @inheritParams rel_to_df
#' @inheritParams rel_set_intersect
#' @return a new relation object with the result
#' @export
#' @examplesIf FALSE
#' rel <- rel_from_df(mtcars)
#' rel2 <- rel_set_symdiff(rel)
rel_set_symdiff <- function(rel_a, rel_b, ...) {
  rel_stats_env$rel_set_symdiff <- (rel_stats_env$rel_set_symdiff %||% 0L) + 1L
  UseMethod("rel_set_symdiff")
}

#' Lazily compute a set_union_all result on a relation object
#'
#' TBD.
#'
#' @inheritParams rel_to_df
#' @inheritParams rel_set_intersect
#' @return a new relation object with the result
#' @export
#' @examplesIf FALSE
#' rel <- rel_from_df(mtcars)
#' rel2 <- rel_union_all(rel)
rel_union_all <- function(rel_a, rel_b, ...) {
  rel_stats_env$rel_union_all <- (rel_stats_env$rel_union_all %||% 0L) + 1L
  UseMethod("rel_union_all")
}

#' TBD
#'
#' TBD.
#'
#' @inheritParams rel_to_df
#' @rdname rel
#' @return A (new/modified) relational object.
#' @export
rel_tostring <- function(rel, ...) {
  rel_stats_env$rel_tostring <- (rel_stats_env$rel_tostring %||% 0L) + 1L
  UseMethod("rel_tostring")
}

#' Print the EXPLAIN output for a relation object
#'
#' TBD.
#'
#' @inheritParams rel_to_df
#' @return A (new/modified) relational object.
#' @export
#' @examplesIf FALSE
#' rel <- rel_from_df(mtcars)
#' rel_explain(rel)
rel_explain <- function(rel, ...) {
  rel_stats_env$rel_explain <- (rel_stats_env$rel_explain %||% 0L) + 1L
  UseMethod("rel_explain")
}

#' Get the internal alias for a relation object
#'
#' TBD.
#'
#' @inheritParams rel_to_df
#' @return A (new/modified) relational object.
#' @export
#' @examplesIf FALSE
#' rel <- rel_from_df(mtcars)
#' rel_alias(rel)
rel_alias <- function(rel, ...) {
  rel_stats_env$rel_alias <- (rel_stats_env$rel_alias %||% 0L) + 1L
  UseMethod("rel_alias")
}

#' Set the internal alias for a relation object
#'
#' TBD.
#'
#' @inheritParams rel_to_df
#' @param alias the new alias
#' @return A (new/modified) relational object.
#' @export
#' @examplesIf FALSE
#' rel <- rel_from_df(mtcars)
#' rel_set_alias(rel, "my_new_alias")
rel_set_alias <- function(rel, alias, ...) {
  rel_stats_env$rel_set_alias <- (rel_stats_env$rel_set_alias %||% 0L) + 1L
  UseMethod("rel_set_alias")
}

#' @rdname rel
#' @return A (new/modified) relational object.
#' @export
rel_names <- function(rel, ...) {
  rel_stats_env$rel_names <- (rel_stats_env$rel_names %||% 0L) + 1L
  UseMethod("rel_names")
}
