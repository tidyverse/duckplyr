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
read_csv_duckdb <- function(path, ..., prudence = c("thrifty", "lavish", "stingy"), options = list()) {
  check_dots_empty()

  read_file_duckdb(path, "read_csv_auto", prudence = prudence, options = options)
}
