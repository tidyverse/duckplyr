#' Compute results to a CSV file
#'
#' For a duckplyr frame, this function executes the query
#' and stores the results in a CSV file,
#' without converting it to an R data frame.
#' The result is a duckplyr frame that can be used with subsequent dplyr verbs.
#' This function can also be used as a CSV writer for regular data frames.
#'
#' @inheritParams rlang::args_dots_empty
#' @inheritParams compute.duckplyr_df
#' @inheritParams compute_parquet
#' @param options A list of additional options to pass to create the storage format,
#'   see <https://duckdb.org/docs/data/csv/overview#writing-using-the-copy-statement>
#'   for details.
#'
#' @return A duckplyr frame.
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
