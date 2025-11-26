#' @title Keep rows that match a condition
#'
#' @description  This is a method for the [dplyr::filter()] generic.
#' See "Fallbacks" section for differences in implementation.
#' The `filter()` function is used to subset a data frame,
#' retaining all rows that satisfy your conditions.
#' To be retained, the row must produce a value of `TRUE` for all conditions.
#' Note that when a condition evaluates to `NA` the row will be dropped,
#' unlike base subsetting with `[`.
#'
#' @inheritParams dplyr::filter
#' @examples
#' df <- duckdb_tibble(x = 1:3, y = 3:1)
#' filter(df, x >= 2)
#' @seealso [dplyr::filter()]
#' @rdname filter.duckplyr_df
#' @name filter.duckplyr_df
NULL
