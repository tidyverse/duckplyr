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
#' @param format By default, the result is stored in a DuckDB table.
#'   Set to `"parquet"` or `"csv"` to store the result in a Parquet or CSV file.
#' @param name The name of the table to store the result in. Only for `format = "table"`.
#' @param schema_name The schema to store the result in, defaults to the current schema.
#'   Only for `format = "table"`.
#' @param temporary Set to `FALSE` to store the result in a permanent table.
#'   Only for `format = "table"`.
#' @param path The path to store the result in.
#'   Only for `format = "parquet"` or `format = "csv"`.
#' @param options A list of additional options to pass to the storage format,
#'   see <https://duckdb.org/docs/data/parquet/overview#writing-to-parquet-files>
#'   or <https://duckdb.org/docs/data/csv/overview#writing-using-the-copy-statement>
#'   for details.
#'   Only for `format = "parquet"` or `format = "csv"`.
#' @examples
#' library("duckplyr")
#' df <- data.frame(x = c(1, 2))
#' df <- mutate(df, y = 2)
#' df <- compute(df)
#' explain(df)
#' @seealso [`dplyr::collect()`]
#' @rdname compute.duckplyr_df
#' @name compute.duckplyr_df
NULL
