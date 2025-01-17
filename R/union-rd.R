#' @title Union
#'
#' @description  This is a method for the [dplyr::union()] generic.
#' `union(x, y)` finds all rows in either x or y, excluding duplicates.
#' The implementation forwards to `distinct(union_all(x, y))`.
#'
#' @inheritParams dplyr::union
#' @examples
#' df1 <- duckdb_tibble(x = 1:3)
#' df2 <- duckdb_tibble(x = 3:5)
#' union(df1, df2)
#' @seealso [dplyr::union()]
#' @rdname union.duckplyr_df
#' @name union.duckplyr_df
NULL
