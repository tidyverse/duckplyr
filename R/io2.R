#' Read Parquet, CSV, and other files using DuckDB
#'
#' @description
#' These functions ingest data from a file.
#' In many cases, these functions return immediately because they only read the metadata.
#' The actual data is only read when it is actually processed.
#'
#' @name duck_file
NULL

#' @description
#' `duck_parquet()` reads a CSV file using DuckDB's `read_parquet()` table function.
#'
#' @rdname duck_file
#' @export
duck_parquet <- function(path, ..., lazy = TRUE, options = list()) {
  check_dots_empty()

  duck_file(path, "read_parquet", lazy = lazy, options = options)
}

#' @description
#' `duck_csv()` reads a CSV file using DuckDB's `read_csv_auto()` table function.
#'
#' @rdname duck_file
#' @export
#' @examples
#' # Create simple CSV file
#' path <- tempfile("duckplyr_test_", fileext = ".csv")
#' write.csv(data.frame(a = 1:3, b = letters[4:6]), path, row.names = FALSE)
#'
#' # Reading is immediate
#' df <- duck_csv(path)
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
#' # Automatic materialization with lazy = FALSE
#' df <- duck_csv(path, lazy = FALSE)
#' df$a
#'
#' # Specify column types
#' duck_csv(
#'   path,
#'   options = list(delim = ",", types = list(c("DOUBLE", "VARCHAR")))
#' )
duck_csv <- function(path, ..., lazy = TRUE, options = list()) {
  check_dots_empty()

  duck_file(path, "read_csv_auto", lazy = lazy, options = options)
}

#' @description
#' `duck_json()` reads a JSON file using DuckDB's `read_json()` table function.
#'
#' @rdname duck_file
#' @export
#' @examples
#'
#' # Create and read a simple JSON file
#' path <- tempfile("duckplyr_test_", fileext = ".json")
#' writeLines('[{"a": 1, "b": "x"}, {"a": 2, "b": "y"}]', path)
#'
#' # Reading needs the json extension
#' duckplyr_execute("INSTALL json")
#' duckplyr_execute("LOAD json")
#' duck_json(path)
duck_json <- function(path, ..., lazy = TRUE, options = list()) {
  check_dots_empty()

  duck_file(path, "read_json", lazy = lazy, options = options)
}

#' @description
#' `duck_file()` uses arbitrary readers to read data.
#' See <https://duckdb.org/docs/data/overview> for a documentation
#' of the available functions and their options.
#' To read multiple files with the same schema,
#' pass a wildcard or a character vector to the `path` argument,
#'
#' @details
#' By default, a lazy duckplyr frame is created.
#' This means that all the data can be shown and all dplyr verbs can be used,
#' but attempting to access the columns of the data frame or using an unsupported verb,
#' data type, or function will result in an error.
#' Pass `lazy = FALSE` to transparently switch to local processing as needed,
#' or use [collect()] to explicitly materialize and continue local processing.
#'
#' @inheritParams rlang::args_dots_empty
#'
#' @param path Path to files, glob patterns `*` and `?` are supported.
#' @param table_function The name of a table-valued
#'   DuckDB function such as `"read_parquet"`,
#'   `"read_csv"`, `"read_csv_auto"` or `"read_json"`.
#' @param lazy Logical, whether to create a lazy duckplyr frame.
#'   If `TRUE` (the default), [collect()] must be called before the data can be accessed.
#' @param options Arguments to the DuckDB function
#'   indicated by `table_function`.
#'
#' @return A duckplyr frame, see [as_duck_tbl()] for details.
#'
#' @rdname duck_file
#' @export
duck_file <- function(
  path,
  table_function,
  ...,
  lazy = TRUE,
  options = list()
) {
  check_dots_empty()

  if (!rlang::is_character(path)) {
    cli::cli_abort("{.arg path} must be a character vector.")
  }

  if (length(path) != 1) {
    path <- list(path)
  }

  duckfun(table_function, c(list(path), options), lazy = lazy)
}

duckfun <- function(table_function, args, ..., lazy = TRUE) {
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

  out <- duckdb$rel_to_altrep(rel)
  as_duck_tbl(out, .lazy = lazy)
}
