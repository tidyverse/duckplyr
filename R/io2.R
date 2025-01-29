#' Read Parquet, CSV, and other files using DuckDB
#'
#' @description
#' These functions ingest data from a file.
#' In many cases, these functions return immediately because they only read the metadata.
#' The actual data is only read when it is actually processed.
#'
#' @name read_file_duckdb
NULL

#' @description
#' `read_parquet_duckdb()` reads a CSV file using DuckDB's `read_parquet()` table function.
#'
#' @rdname read_file_duckdb
#' @export
read_parquet_duckdb <- function(path, ..., inert = c(cells = 1e6), options = list()) {
  check_dots_empty()

  read_file_duckdb(path, "read_parquet", inert = inert, options = options)
}

#' @description
#' `read_csv_duckdb()` reads a CSV file using DuckDB's `read_csv_auto()` table function.
#'
#' @rdname read_file_duckdb
#' @export
#' @examples
#' # Create simple CSV file
#' path <- tempfile("duckplyr_test_", fileext = ".csv")
#' write.csv(data.frame(a = 1:3, b = letters[4:6]), path, row.names = FALSE)
#'
#' # Reading is immediate
#' df <- read_csv_duckdb(path)
#'
#' # Names are always available
#' names(df)
#'
#' # Materialization upon access is turned off by default
#' try(print(df$a))
#'
#' # Materialize explicitly
#' collect(df)$a
#'
#' # Automatic materialization with inert = "open"
#' df <- read_csv_duckdb(path, inert = "open")
#' df$a
#'
#' # Specify column types
#' read_csv_duckdb(
#'   path,
#'   options = list(delim = ",", types = list(c("DOUBLE", "VARCHAR")))
#' )
read_csv_duckdb <- function(path, ..., inert = c(cells = 1e6), options = list()) {
  check_dots_empty()

  read_file_duckdb(path, "read_csv_auto", inert = inert, options = options)
}

#' @description
#' `read_json_duckdb()` reads a JSON file using DuckDB's `read_json()` table function.
#'
#' @rdname read_file_duckdb
#' @export
#' @examples
#'
#' # Create and read a simple JSON file
#' path <- tempfile("duckplyr_test_", fileext = ".json")
#' writeLines('[{"a": 1, "b": "x"}, {"a": 2, "b": "y"}]', path)
#'
#' # Reading needs the json extension
#' db_exec("INSTALL json")
#' db_exec("LOAD json")
#' read_json_duckdb(path)
read_json_duckdb <- function(path, ..., inert = c(cells = 1e6), options = list()) {
  check_dots_empty()

  read_file_duckdb(path, "read_json", inert = inert, options = options)
}

#' @description
#' `read_file_duckdb()` uses arbitrary readers to read data.
#' See <https://duckdb.org/docs/data/overview> for a documentation
#' of the available functions and their options.
#' To read multiple files with the same schema,
#' pass a wildcard or a character vector to the `path` argument,
#'
#' @details
#' By default, an inert duckplyr frame, with a limit of one million cells, is created.
#' See the "Inertia" section in [duckdb_tibble()] for details.
#'
#' @inheritParams rlang::args_dots_empty
#'
#' @param path Path to files, glob patterns `*` and `?` are supported.
#' @param table_function The name of a table-valued
#'   DuckDB function such as `"read_parquet"`,
#'   `"read_csv"`, `"read_csv_auto"` or `"read_json"`.
#' @param inert Logical, whether to create an inert duckplyr frame.
#'   By default, an inert duckplyr frame is created.
#'   See the "Inertia" section in [duckdb_tibble()] for details.
#' @param options Arguments to the DuckDB function
#'   indicated by `table_function`.
#'
#' @return A duckplyr frame, see [as_duckdb_tibble()] for details.
#'
#' @rdname read_file_duckdb
#' @export
read_file_duckdb <- function(
  path,
  table_function,
  ...,
  inert = c(cells = 1e6),
  options = list()
) {
  check_dots_empty()

  if (!rlang::is_character(path)) {
    cli::cli_abort("{.arg path} must be a character vector.")
  }

  if (length(path) != 1) {
    path <- list(path)
  }

  duckfun(table_function, c(list(path), options), inert = inert)
}

duckfun <- function(table_function, args, ..., inert) {
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

  # Start with inert, to avoid unwanted materialization
  df <- duckdb$rel_to_altrep(rel, allow_materialization = FALSE)
  out <- new_duckdb_tibble(df, inert = "closed")

  if (!identical(inert, "closed")) {
    out <- as_duckdb_tibble(out, inert = inert)
  }

  out
}
