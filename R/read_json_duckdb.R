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
#' @examplesIf identical(Sys.getenv("IN_PKGDOWN"), "TRUE")
#'
#' # Create and read a simple JSON file
#' path <- tempfile("duckplyr_test_", fileext = ".json")
#' writeLines('[{"a": 1, "b": "x"}, {"a": 2, "b": "y"}]', path)
#'
#' # Reading needs the json extension
#' db_exec("INSTALL json")
#' db_exec("LOAD json")
#' read_json_duckdb(path)
read_json_duckdb <- function(path, ..., prudence = c("thrifty", "lavish", "stingy"), options = list()) {
  check_dots_empty()

  read_file_duckdb(path, "read_json", prudence = prudence, options = options)
}
