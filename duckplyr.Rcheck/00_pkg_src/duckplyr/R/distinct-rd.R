#' @title Keep distinct/unique rows
#'
#' @description  This is a method for the [dplyr::distinct()] generic.
#' Keep only unique/distinct rows from a data frame.
#' This is similar to `unique.data.frame()` but considerably faster.
#'
#' @inheritParams dplyr::distinct
#' @examples
#' df <- duckdb_tibble(
#'   x = sample(10, 100, rep = TRUE),
#'   y = sample(10, 100, rep = TRUE)
#' )
#' nrow(df)
#' nrow(distinct(df))
#' @seealso [dplyr::distinct()]
#' @rdname distinct.duckplyr_df
#' @name distinct.duckplyr_df
NULL
