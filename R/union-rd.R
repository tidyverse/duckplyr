#' @title Union
#'
#' @description  This is a method for the [dplyr::union()] generic.
#' `union(x, y)` finds all rows in either x or y, excluding duplicates.
#' The implementation forwards to `distinct(union_all(x, y))`.
#'
#' @inheritParams dplyr::union
#' @seealso [dplyr::union()]
#' @rdname union.duckplyr_df
#' @name union.duckplyr_df
NULL
