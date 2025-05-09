#' df_from_parquet
#'
#' @description
#' `df_from_parquet()` reads a Parquet file using the `read_parquet()` table function.
#'
#' @rdname df_from_file
#' @export
df_from_parquet <- function(path, ..., options = list(), class = NULL) {
  check_dots_empty()
  lifecycle::deprecate_soft("1.0.0", "df_from_parquet()", "read_parquet_duckdb()")

  df_from_file(path, "read_parquet", options = options, class = class)
}

#' duckplyr_df_from_parquet
#'
#' `duckplyr_df_from_parquet()` is a thin wrapper around `df_from_parquet()`
#' that calls `as_duckplyr_df()` on the output.
#'
#' @rdname df_from_file
#' @export
duckplyr_df_from_parquet <- function(path, ..., options = list(), class = NULL) {
  check_dots_empty()
  lifecycle::deprecate_soft("1.0.0", "duckplyr_df_from_parquet()", "read_parquet_duckdb()")

  duckplyr_df_from_file(path, "read_parquet", options = options, class = class)
}

#' df_to_parquet
#'
#' `df_to_parquet()` writes a data frame to a Parquet file via DuckDB.
#' If the data frame is a `duckplyr_df`, the materialization occurs outside of R.
#' An existing file will be overwritten.
#' This function requires duckdb >= 0.10.0.
#'
#' @param data A data frame to be written to disk.
#'
#' @rdname df_from_file
#' @export
#' @examples
#'
#' # Write a Parquet file:
#' path_parquet <- tempfile(fileext = ".parquet")
#' df_to_parquet(df, path_parquet)
#'
#' # With a duckplyr_df, the materialization occurs outside of R:
#' df %>%
#'   as_duckplyr_df() %>%
#'   mutate(b = a + 1) %>%
#'   df_to_parquet(path_parquet)
#'
#' duckplyr_df_from_parquet(path_parquet)
#'
#' unlink(path_parquet)
df_to_parquet <- function(data, path) {
  lifecycle::deprecate_soft("1.0.0", "df_to_parquet()", "compute_parquet()")
  rel <- duckdb_rel_from_df(data)
  duckdb$rel_to_parquet(rel, path)
}
