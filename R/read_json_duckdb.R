#' Read JSON files using DuckDB
#'
#' @description
#' `read_json_duckdb()` reads a JSON file using DuckDB's `read_json()` table function.
#'
#' @inheritParams read_file_duckdb
#' @param options Arguments to the DuckDB `read_json` table function.
#'
#' @seealso [read_csv_duckdb()], [read_parquet_duckdb()]
#'
#' @export
read_json_duckdb <- function(path, ..., prudence = c("thrifty", "lavish", "stingy"), options = list()) {
  check_dots_empty()

  read_file_duckdb(path, "read_json", prudence = prudence, options = options)
}
