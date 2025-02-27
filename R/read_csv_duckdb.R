#' Read CSV files using DuckDB
#'
#' @description
#' `read_csv_duckdb()` reads a CSV file using DuckDB's `read_csv_auto()` table function.
#'
#' @inheritParams read_file_duckdb
#' @param options Arguments to the DuckDB `read_csv_auto` table function.
#'
#' @seealso [read_parquet_duckdb()], [read_json_duckdb()]
#'
#' @export
#' @examples
#' # Create simple CSV file
#' path <- tempfile("duckplyr_test_", fileext = ".csv")
#' write.csv(data.frame(a = 1:3, b = letters[4:6]), path, row.names = FALSE)
#'
#' # Reading is immediate
#' df <- read_csv_duckdb(path)
#'
#' # Names are always available
#' names(df)
#'
#' # Materialization upon access is turned off by default
#' try(print(df$a))
#'
#' # Materialize explicitly
#' collect(df)$a
#'
#' # Automatic materialization with prudence = "lavish"
#' df <- read_csv_duckdb(path, prudence = "lavish")
#' df$a
#'
#' # Specify column types
#' read_csv_duckdb(
#'   path,
#'   options = list(delim = ",", types = list(c("DOUBLE", "VARCHAR")))
#' )
read_csv_duckdb <- function(path, ..., prudence = c("thrifty", "lavish", "stingy"), options = list()) {
  check_dots_empty()

  read_file_duckdb(path, "read_csv_auto", prudence = prudence, options = options)
}
