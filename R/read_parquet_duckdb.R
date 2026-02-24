#' Read Parquet files using DuckDB
#'
#' @description
#' `read_parquet_duckdb()` reads a Parquet file using DuckDB's `read_parquet()` table function.
#'
#' @inheritParams read_file_duckdb
#' @param options Arguments to the DuckDB `read_parquet` table function.
#'
#' @seealso [read_csv_duckdb()], [read_json_duckdb()]
#'
#' @export
read_parquet_duckdb <- function(
  path,
  ...,
  prudence = c("thrifty", "lavish", "stingy"),
  options = list()
) {
  check_dots_empty()

  read_file_duckdb(path, "read_parquet", prudence = prudence, options = options)
}
