#' Compute results to a CSV file
#'
#' This is a generic function that executes a query
#' and stores the results in a CSV file.
#' For a duckplyr frame, the materialization occurs outside of R.
#' The result is a duckplyr frame that can be used with subsequent dplyr verbs.
#'
#' @inheritParams rlang::args_dots_empty
#' @param x A data frame or lazy data frame.
#' @param path The path of the CSV file to create.
#' @param ... Additional arguments passed to methods.
#'
#' @return A data frame (the class may vary based on the input).
#'
#' @export
#' @examples
#' library(duckplyr)
#' df <- data.frame(x = c(1, 2))
#' df <- mutate(df, y = 2)
#' path <- tempfile(fileext = ".csv")
#' df <- compute_csv(df, path)
#' readLines(path)
#' @seealso [compute_parquet()], [compute.duckplyr_df()], [dplyr::collect()]
compute_csv <- function(x, path, ...) {
  UseMethod("compute_csv")
}

#' @inheritParams compute.duckplyr_df
#' @param options A list of additional options to pass to create the storage format,
#'   see <https://duckdb.org/docs/sql/statements/copy.html#csv-options>
#'   for details.
#'
#' @rdname compute_csv
#' @export
compute_csv.duckplyr_df <- function(
  x,
  path,
  ...,
  prudence = NULL,
  options = NULL
) {
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

  # Filter out write-only options before reading
  read_options <- options[setdiff(names(options), csv_write_only_opts)]
  read_csv_duckdb(path, prudence = prudence, options = read_options)
}

#' @rdname compute_csv
#' @export
compute_csv.data.frame <- function(
  x,
  path,
  ...,
  prudence = NULL,
  options = NULL
) {
  x <- as_duckdb_tibble(x)
  compute_csv.duckplyr_df(x, path, ..., prudence = prudence, options = options)
}
