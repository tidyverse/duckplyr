#' @title Compute results to a file
#'
#' @description
#' These functions apply to duckplyr frames.
#' They executes a query and stores the results in a flat file.
#' The result is a duckplyr frame that can be used with subsequent dplyr verbs.
#'
#' `compute_parquet()` creates a Parquet file.
#'
#' @inheritParams rlang::args_dots_empty
#' @inheritParams compute.duckplyr_df
#' @param path The path to store the result in.
#' @param options A list of additional options to pass to create the storage format,
#'   see <https://duckdb.org/docs/data/parquet/overview#writing-to-parquet-files>
#'   or <https://duckdb.org/docs/data/csv/overview#writing-using-the-copy-statement>
#'   for details.
#'
#' @export
#' @examples
#' library(duckplyr)
#' df <- data.frame(x = c(1, 2))
#' df <- mutate(df, y = 2)
#' path <- tempfile(fileext = ".parquet")
#' df <- compute_parquet(df, path)
#' explain(df)
#' @seealso [compute.duckplyr_df()], [dplyr::collect()]
#' @name compute_file
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

#' compute_csv()
#'
#' `compute_csv()` creates a CSV file.
#' @rdname compute_file
#' @export
compute_csv <- function(x, path, ..., prudence = NULL, options = NULL) {
  check_dots_empty()

  if (is.null(options)) {
    options <- list()
  }

  if (is.null(prudence)) {
    prudence <- get_prudence_duckplyr_df(x)
  }

  rel <- duckdb_rel_from_df(x)

  duckdb$rel_to_csv(rel, path, options)

  # If the path is a directory, we assume that the user wants to write multiple files
  if (dir.exists(path)) {
    path <- file.path(path, "**", "**.csv")
  }

  read_csv_duckdb(path, prudence = prudence)
}
