#' Execute a statement for the default connection
#'
#' The \pkg{duckplyr} package relies on a DBI connection
#' to an in-memory database.
#' The `db_exec()` function allows running SQL statements
#' with side effects on this connection.
#' It can be used to execute statements that start with
#' `PRAGMA`, `SET`, or `ATTACH`
#' to, e.g., set up credentials, change configuration options,
#' or attach other databases.
#' See <https://duckdb.org/docs/configuration/overview.html>
#' for more information on the configuration options,
#' and <https://duckdb.org/docs/sql/statements/attach.html>
#' for attaching databases.
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
