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
#' # Return as tibble, specify column types:
#' df_from_file(
#'   path,
#'   "read_csv",
#'   options = list(delim = ",", types = list(c("DOUBLE", "VARCHAR"))),
#'   class = class(tibble())
#' )
read_csv_duckplyr <- function(path, ..., lazy = TRUE, options = list(), class = NULL) {
  check_dots_empty()

  read_duckplyr(path, "read_csv_auto", lazy = lazy, options = options, class = class)
}
