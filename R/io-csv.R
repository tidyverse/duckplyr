#' df_from_csv
#'
#' @description
#' These functions ingest data from a file using a table function.
#' The results are transparently converted to a data frame, but the data is only read when
#' the resulting data frame is actually accessed.
#'
#' `df_from_csv()` reads a CSV file using the `read_csv_auto()` table function.
#'
#' @rdname df_from_file
#' @export
#' @examples
#' # Create simple CSV file
#' path <- tempfile("duckplyr_test_", fileext = ".csv")
#' write.csv(data.frame(a = 1:3, b = letters[4:6]), path, row.names = FALSE)
#'
#' # Reading is immediate
#' df <- df_from_csv(path)
#'
#' # Materialization only upon access
#' names(df)
#' df$a
#'
#' # Return as tibble, specify column types positionally:
#' df_from_file(
#'   path,
#'   "read_csv",
#'   options = list(delim = ",", types = list(c("DOUBLE", "VARCHAR"))),
#'   class = class(tibble())
#' )
#'
#' # Specify column types by name:
#' df_from_file(
#'   path,
#'   "read_csv",
#'   options = list(delim = ",", types = list(c(a = "DOUBLE", b = "VARCHAR"))),
#'   class = class(tibble())
#' )
df_from_csv <- function(path, ..., options = list(), class = NULL) {
  check_dots_empty()
  lifecycle::deprecate_soft("1.0.0", "df_from_csv()", "read_csv_duckdb()")

  df_from_file(path, "read_csv_auto", options = options, class = class)
}

#' duckplyr_df_from_csv
#'
#' `duckplyr_df_from_csv()` is a thin wrapper around `df_from_csv()`
#' that calls `as_duckplyr_df()` on the output.
#'
#' @rdname df_from_file
#' @export
#' @examples
#'
#' # Read multiple file at once
#' path2 <- tempfile("duckplyr_test_", fileext = ".csv")
#' write.csv(data.frame(a = 4:6, b = letters[7:9]), path2, row.names = FALSE)
#'
#' duckplyr_df_from_csv(file.path(tempdir(), "duckplyr_test_*.csv"))
#'
#' unlink(c(path, path2))
duckplyr_df_from_csv <- function(path, ..., options = list(), class = NULL) {
  check_dots_empty()
  lifecycle::deprecate_soft("1.0.0", "duckplyr_df_from_csv()", "read_csv_duckdb()")

  duckplyr_df_from_file(path, "read_csv_auto", options = options, class = class)
}
