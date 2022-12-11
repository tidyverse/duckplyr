#' Data frame relational backend
#'
#' TBD.
#'
#' @param df A data frame.
#' @return A relational object.
#'
#' @export
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
rel_filter.relational_df <- function(rel, exprs, ...) {
}

#' @export
rel_project.relational_df <- function(rel, exprs, ...) {
}

#' @export
rel_aggregate.relational_df <- function(rel, groups, aggregates, ...) {
}

#' @export
rel_order.relational_df <- function(rel, orders, ...) {
}

#' @export
rel_inner_join.relational_df <- function(left, right, conds, ...) {
}

#' @export
rel_limit.relational_df <- function(rel, n, ...) {
}

#' @export
rel_distinct.relational_df <- function(rel, ...) {
}

#' @export
rel_tostring.relational_df <- function(rel, ...) {
}

#' @export
rel_explain.relational_df <- function(rel, ...) {
}

#' @export
rel_alias.relational_df <- function(rel, ...) {
}

#' @export
rel_set_alias.relational_df <- function(rel, alias, ...) {
}

#' @export
rel_names.relational_df <- function(rel, ...) {
}

