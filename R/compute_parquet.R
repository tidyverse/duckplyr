#' Compute results to a Parquet file
#'
#' This is a generic function that executes a query
#' and stores the results in a Parquet file.
#' For a duckplyr frame, the materialization occurs outside of R.
#' The result is a duckplyr frame that can be used with subsequent dplyr verbs.
#'
#' @inheritParams rlang::args_dots_empty
#' @param x A data frame or lazy data frame.
#' @param path The path of the Parquet file to create.
#' @param ... Additional arguments passed to methods.
#'
#' @return A data frame (the class may vary based on the input).
#'
#' @export
#' @examples
#' library(duckplyr)
#' df <- data.frame(x = c(1, 2))
#' df <- mutate(df, y = 2)
#' path <- tempfile(fileext = ".parquet")
#' df <- compute_parquet(df, path)
#' explain(df)
#' @seealso [compute_csv()], [compute.duckplyr_df()], [dplyr::collect()]
compute_parquet <- function(x, path, ...) {
  UseMethod("compute_parquet")
}

#' @inheritParams compute.duckplyr_df
#' @param options A list of additional options to pass to create the Parquet file,
#'   see <https://duckdb.org/docs/sql/statements/copy.html#parquet-options>
#'   for details.
#'
#' @rdname compute_parquet
#' @export
compute_parquet.duckplyr_df <- function(
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

  duckdb$rel_to_parquet(rel, path, options)

  # If the path is a directory, we assume that the user wants to write multiple files
  if (dir.exists(path)) {
    path <- file.path(path, "**", "**.parquet")
  }

  # Filter out write-only options before reading
  write_only_options <- c(
    "partition_by",
    "compression_level",
    "row_group_size",
    "row_group_size_bytes",
    "kv_metadata",
    "field_ids",
    "per_thread_output",
    "use_tmp_file",
    "write_partition_columns",
    "overwrite_or_ignore",
    "append",
    "overwrite",
    "filename_pattern",
    "file_extension",
    "file_size_bytes",
    "preserve_order",
    "return_files",
    "return_stats"
  )
  read_options <- options[setdiff(names(options), write_only_options)]
  read_parquet_duckdb(path, prudence = prudence, options = read_options)
}

#' @rdname compute_parquet
#' @export
compute_parquet.data.frame <- function(
  x,
  path,
  ...,
  prudence = NULL,
  options = NULL
) {
  x <- as_duckdb_tibble(x)
  compute_parquet.duckplyr_df(
    x,
    path,
    ...,
    prudence = prudence,
    options = options
  )
}
