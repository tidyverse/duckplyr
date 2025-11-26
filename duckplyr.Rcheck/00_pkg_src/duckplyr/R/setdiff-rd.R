#' @title Set difference
#'
#' @description  This is a method for the [dplyr::setdiff()] generic.
#' See "Fallbacks" section for differences in implementation.
#' `setdiff(x, y)` finds all rows in `x` that aren't in `y`.
#'
#' @inheritParams dplyr::setdiff
#' @examples
#' df1 <- duckdb_tibble(x = 1:3)
#' df2 <- duckdb_tibble(x = 3:5)
#' setdiff(df1, df2)
#' setdiff(df2, df1)
#' @seealso [dplyr::setdiff()]
#' @rdname setdiff.duckplyr_df
#' @name setdiff.duckplyr_df
NULL
