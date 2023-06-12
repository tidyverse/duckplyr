#' Shell class
#'
#' @param x numeric vector
#' @export
new_shell <- function(x) {
  x <- split(x, seq_along(x))
  structure(x, class = "shell")
}

#' @export
rel_to_df.shell <- function(rel, ...) {
  rel[[1L]]
}

#' @export
rel_filter.shell <- function(rel, exprs, ...) {
  rel[[1L]]
}

#' @export
rel_project.shell <- function(rel, exprs, ...) {
  rel[[1L]]
}

#' @export
rel_aggregate.shell <- function(rel, groups, aggregates, ...) {
  rel[[1L]]
}

#' @export
rel_order.shell <- function(rel, orders, ...) {
  rel[[1L]]
}

#' @export
rel_join.shell <- function(left, right, conds, ...) {
  rel[[1L]]
}

#' @export
rel_limit.shell <- function(rel, n, ...) {
  rel[[1L]]
}

#' @export
rel_distinct.shell <- function(rel, ...) {
  rel[[1L]]
}

#' @export
rel_set_intersect.shell <- function(rel_a, rel_b, ...) {
  rel[[1L]]
}

#' @export
rel_set_diff.shell <- function(rel_a, rel_b, ...) {
  rel[[1L]]
}

#' @export
rel_set_symdiff.shell <- function(rel_a, rel_b, ...) {
  rel[[1L]]
}

#' @export
rel_union_all.shell <- function(rel_a, rel_b, ...) {
  rel[[1L]]
}


#' @export
rel_tostring.shell <- function(rel, ...) {
  rel[[1L]]
}

#' @export
rel_explain.shell <- function(rel, ...) {
  rel[[1L]]
}

#' @export
rel_alias.shell <- function(rel, ...) {
  rel[[1L]]
}

#' @export
rel_set_alias.shell <- function(rel, alias, ...) {
  rel[[1L]]
}

#' @export
rel_names.shell <- function(rel, ...) {
  rel[[1L]]
}
