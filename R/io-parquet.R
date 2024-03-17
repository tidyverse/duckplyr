#' df_from_parquet
#'
#' @description
#' `df_from_parquet()` reads a Parquet file using the `read_parquet()` table function.
#'
#' @rdname df_from_file
#' @export
df_from_parquet <- function(path, ..., options = list(), class = NULL) {
  check_dots_empty()

  df_from_file(path, "read_parquet", options, class)
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

  duckplyr_df_from_file(path, "read_parquet", options, class)
}
