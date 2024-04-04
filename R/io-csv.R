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
#' path <- tempfile(fileext = ".csv")
#' write.csv(data.frame(a = 1:3, b = letters[4:6]), path, row.names = FALSE)
#'
#' # Reading is immediate
#' df <- df_from_csv(path)
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
df_from_csv <- function(path, ..., options = list(), class = NULL) {
  check_dots_empty()

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
#' tbl1 <- data.frame(a = 1)
#' tbl2 <- data.frame(a = 2)
#'
#' temp1 <- tempfile(fileext = ".csv")
#' temp2 <- tempfile(fileext = ".csv")
#'
#' purrr::walk2(
#'   list(tbl1, tbl2),
#'   list(temp1, temp2),
#'   ~ write.csv(x = .x, file = .y)
#' )
#'
#' df <- duckplyr_df_from_csv(file.path(dirname(temp1), "*.csv"))
duckplyr_df_from_csv <- function(path, ..., options = list(), class = NULL) {
  check_dots_empty()

  duckplyr_df_from_file(path, "read_csv_auto", options = options, class = class)
}
