#' Read Parquet, CSV, and other files using DuckDB
#'
#' This function ingests data from files.
#' Internally, a DuckDB table-valued function is called,
#' the results are transparently converted to a data frame.
#' The data is only read when the data is actually accessed.
#' See <https://duckdb.org/docs/data/overview> for a documentation
#' of the available functions and their options.
#'
#' @param path Path to file or directory
#' @param table_function The name of a table-valued
#'   DuckDB function such as `"read_parquet"`,
#'   `"read_csv"`, `"read_csv_auto"` or `"read_json"`.
#' @param options Arguments to the DuckDB function
#'   indicated by `table_function`.
#' @param class An optional class to add to the data frame.
#'   The returned object will always be a data frame.
#'   Pass `class(tibble())` to create a tibble.
#'
#' @return A data frame for `df_from_file()`, or a `duckplyr_df` for
#'   `duckplyr_df_from_file()`, extended by the provided `class`.
#'
#' @export
#' @examples
#' # Create simple CSV file
#' path <- tempfile(fileext = ".csv")
#' write.csv(data.frame(a = 1:3, b = letters[4:6]), path, row.names = FALSE)
#'
#' # Reading is immediate
#' df <- df_from_file(path, "read_csv_auto")
#'
#' # Materialization only upon access
#' names(df)
#' df$a
#'
#' # Return as tibble:
#' df_from_file(
#'   path,
#'   "read_csv",
#'   options = list(delim = ",", auto_detect = TRUE),
#'   class = class(tibble())
#' )
#'
#' unlink(path)
df_from_file <- function(path,
                         table_function,
                         options = list(),
                         class = NULL) {
  # FIXME: For some reason, it's important to create an alias here
  con <- get_default_duckdb_connection()

  out <- duckdb$rel_from_table_function(
    con,
    table_function,
    list(path),
    options
  )

  meta_rel_register_file(out, path, table_function, options)

  out <- duckdb$rel_to_altrep(out)
  class(out) <- c(setdiff(class, "data.frame"), "data.frame")
  out
}

#' duckplyr_df_from_file
#'
#' `duckplyr_df_from_file()` is a thin wrapper around `df_from_file()`
#' that calls `as_duckplyr_df()` on the output.
#'
#' @rdname df_from_file
#' @export
duckplyr_df_from_file <- function(
    path,
    table_function,
    options = list(),
    class = NULL) {
  out <- df_from_file(path, table_function, options, class)
  as_duckplyr_df(out)
}
