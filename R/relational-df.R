rel_from_df <- function(df) {
  # FIXME: make generic
  stopifnot(is.data.frame(df))
  new_relational(list(df), class = "relational_df")
}

#' @export
rel_to_df.relational_df <- function(rel, ...) {
  rel[[1L]]
}

#' @export
rel_filter.relational_df <- function(rel, exprs, ...) {}

#' @export
rel_project.relational_df <- function(rel, exprs, ...) {}

#' @export
rel_aggregate.relational_df <- function(rel, groups, aggregates, ...) {}

#' @export
rel_order.relational_df <- function(rel, orders, ...) {}

#' @export
rel_join.relational_df <- function(left, right, conds, ...) {}

#' @export
rel_limit.relational_df <- function(rel, n, ...) {}

#' @export
rel_distinct.relational_df <- function(rel, ...) {}

#' @export
rel_set_intersect.relational_df <- function(rel_a, rel_b, ...) {}

#' @export
rel_set_diff.relational_df <- function(rel_a, rel_b, ...) {}

#' @export
rel_set_symdiff.relational_df <- function(rel_a, rel_b, ...) {}

#' @export
rel_union_all.relational_df <- function(rel_a, rel_b, ...) {}


#' @export
rel_explain.relational_df <- function(rel, ...) {}

#' @export
rel_alias.relational_df <- function(rel, ...) {}

#' @export
rel_set_alias.relational_df <- function(rel, alias, ...) {}

#' @export
rel_names.relational_df <- function(rel, ...) {}
