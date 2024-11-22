#' Read Parquet, CSV, and other files using DuckDB
#'
#' `df_from_file()` uses arbitrary table functions to read data.
#' See <https://duckdb.org/docs/data/overview> for a documentation
#' of the available functions and their options.
#' To read multiple files with the same schema,
#' pass a wildcard or a character vector to the `path` argument,
#'
#' @inheritParams rlang::args_dots_empty
#'
#' @param path Path to files, glob patterns `*` and `?` are supported.
#' @param table_function The name of a table-valued
#'   DuckDB function such as `"read_parquet"`,
#'   `"read_csv"`, `"read_csv_auto"` or `"read_json"`.
#' @param lazy If `TRUE` (the default), [collect()] must be called
#'   before the data can be accessed.
#' @param options Arguments to the DuckDB function
#'   indicated by `table_function`.
#' @param class The class of the output.
#'   By default, a tibble is created.
#'   The returned object will always be a data frame.
#'   Use `class = "data.frame"` or `class = character()`
#'   to create a plain data frame.
#'
#' @return A data frame for `df_from_file()`, or a `duckplyr_df` for
#'   `duckplyr_df_from_file()`, extended by the provided `class`.
#'
#' @export
read_duckplyr <- function(
  path,
  table_function,
  ...,
  lazy = TRUE,
  options = list(),
  class = NULL
) {
  check_dots_empty()

  if (!rlang::is_character(path)) {
    cli::cli_abort("{.arg path} must be a character vector.")
  }

  if (length(path) != 1) {
    path <- list(path)
  }

  if (is.null(class)) {
    class <- default_df_class()
  }

  # FIXME: For some reason, it's important to create an alias here
  con <- get_default_duckdb_connection()

  out <- duckdb$rel_from_table_function(
    con,
    table_function,
    list(path),
    options
  )

  meta_rel_register_file(out, path, table_function, options)

  out <- duckdb$rel_to_altrep(out, allow_materialization = !lazy)
  class(out) <- unique(c(class, "data.frame"), fromLast = TRUE)
  out <- as_duckplyr_df(out)
  if (lazy) {
    out <- add_lazy_duckplyr_df_class(out)
  }
  out
}

default_df_class <- function() {
  class(new_tibble(list()))
}
