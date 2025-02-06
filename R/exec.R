#' Execute a statement for the default connection
#'
#' The \pkg{duckplyr} package relies on a DBI connection
#' to an in-memory database.
#' The `db_exec()` function allows running SQL statements
#' with this connection to, e.g., set up credentials
#' or attach other databases.
#' With `db_exec()` you can run `PRAGMA`, `SET` and `RESET` statements
#' to change configuration options.
#' See <https://duckdb.org/docs/configuration/overview.html>
#' for more information on the configuration options.
#'
#' @seealso [read_sql_duckdb()]
#'
#' @param sql The statement to run.
#' @inheritParams read_sql_duckdb
#' @return The return value of the [DBI::dbExecute()] call, invisibly.
#' @export
#' @examples
#' db_exec("SET threads TO 2")
db_exec <- function(sql, ..., con = NULL) {
  check_dots_empty()

  if (!is_string(sql)) {
    cli::cli_abort("{.arg sql} must be a string.")
  }

  if (is.null(con)) {
    con <- get_default_duckdb_connection()
  }

  invisible(DBI::dbExecute(con, sql))
}
