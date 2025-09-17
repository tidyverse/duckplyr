#' Read files using DuckDB
#'
#' @description
#' `read_file_duckdb()` uses arbitrary readers to read data.
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
#' @param prudence Memory protection, controls if DuckDB may convert
#'   intermediate results in DuckDB-managed memory to data frames in R memory.
#'
#'   - `"thrifty"`: up to a maximum size of 1 million cells,
#'   - `"lavish"`: regardless of size,
#'   - `"stingy"`: never.
#'
#' The default is `"thrifty"` for the ingestion functions,
#' and may be different for other functions.
#' See `vignette("prudence")` for more information.
#'
#' @param options Arguments to the DuckDB function
#'   indicated by `table_function`.
#'
#' @inheritSection duckdb_tibble Fine-tuning prudence
#'
#' @return A duckplyr frame, see [as_duckdb_tibble()] for details.
#'
#' @seealso [read_csv_duckdb()], [read_parquet_duckdb()], [read_json_duckdb()]
#'
#' @rdname read_file_duckdb
#' @export
read_file_duckdb <- function(
  path,
  table_function,
  ...,
  prudence = c("thrifty", "lavish", "stingy"),
  options = list()
) {
  check_dots_empty()

  if (!rlang::is_character(path)) {
    cli::cli_abort("{.arg path} must be a character vector.")
  }

  remote <- any(grepl("^[a-zA-Z]+://", path))

  duckfun(
    table_function,
    c(list(list(path)), options),
    prudence = prudence,
    remote = remote
  )
}

duckfun <- function(table_function, args, ..., prudence, remote = FALSE) {
  if (!is.list(args)) {
    cli::cli_abort("{.arg args} must be a list.")
  }
  if (length(args) == 0) {
    cli::cli_abort("{.arg args} must not be empty.")
  }

  # FIXME: For some reason, it's important to create an alias here
  con <- get_default_duckdb_connection()

  # FIXME: Provide better duckdb API
  path <- args[[1]]
  options <- args[-1]

  rel <- duckdb$rel_from_table_function(
    con,
    table_function,
    list(path),
    options
  )

  meta_rel_register_file(rel, table_function, path, options)

  rel_to_df(rel, prudence = prudence, remote = remote)
}
