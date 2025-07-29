#' Compute results to a Parquet file
#'
#' For a duckplyr frame, this function executes the query
#' and stores the results in a Parquet file,
#' without converting it to an R data frame.
#' The result is a duckplyr frame that can be used with subsequent dplyr verbs.
#' This function can also be used as a Parquet writer for regular data frames.
#'
#' @inheritParams rlang::args_dots_empty
#' @inheritParams compute.duckplyr_df
#' @param x A duckplyr frame.
#' @param path The path of the Parquet file to create.
#' @param options A list of additional options to pass to create the Parquet file,
#'   see <https://duckdb.org/docs/sql/statements/copy.html#parquet-options>
#'   for details.
#'
#' @return A duckplyr frame.
#'
#' @export
#' @seealso [compute_csv()], [compute.duckplyr_df()], [dplyr::collect()]
compute_parquet <- function(x, path, ..., prudence = NULL, options = NULL) {
  check_dots_empty()

  if (is.null(options)) {
    options <- list()
  }

  if (is.null(prudence)) {
    prudence <- get_prudence_duckplyr_df(x)
  }

  rel <- duckdb_rel_from_df(x)

  duckdb$rel_to_parquet(rel, path, options)

  # If the path is a directory, we assume that the user wants to write multiple files
  if (dir.exists(path)) {
    path <- file.path(path, "**", "**.parquet")
  }

  read_parquet_duckdb(path, prudence = prudence)
}
