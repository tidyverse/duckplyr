#' @title Compute results (duckplyr)
#'
#' @description  This is a method for the [`dplyr::compute()`] generic.
#' For a (lazy) duckplyr frame,
#' `compute()` executes a query but stores it in a (temporary) table,
#' or in a Parquet or CSV file.
#' The result is a duckplyr frame that can be used with subsequent dplyr verbs.
#'
#' @inheritParams dplyr::compute
#' @param lazy Set to `TRUE` to return a lazy or `FALSE` to return an eager data frame,
#'   see [duck_tbl()].  The default is to inherit the lazyness of the input.
#' @param name The name of the table to store the result in.
#' @param schema_name The schema to store the result in, defaults to the current schema.
#' @param temporary Set to `FALSE` to store the result in a permanent table.
#' @examples
#' library("duckplyr")
#' df <- duck_tbl(x = c(1, 2))
#' df <- mutate(df, y = 2)
#' df <- compute(df)
#' explain(df)
#' @seealso [`dplyr::collect()`]
#' @rdname compute.duckplyr_df
#' @name compute.duckplyr_df
NULL
