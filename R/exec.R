#' Execute a statement for the default connection
#'
#' The \pkg{duckplyr} package relies on a DBI connection
#' to an in-memory database.
#' The `duck_exec()` function allows running SQL statements
#' with this connection to, e.g., set up credentials
#' or attach other databases.
#' See <https://duckdb.org/docs/configuration/overview.html>
#' for more information on the configuration options.
#'
#' @seealso [duck_sql()]
#'
#' @param sql The statement to run.
#' @inheritParams duck_sql
#' @return The return value of the [DBI::dbExecute()] call, invisibly.
#' @export
#' @examples
#' duck_exec("SET threads TO 2")
duck_exec <- function(sql, ..., con = NULL) {
  check_dots_empty()

  if (!is_string(sql)) {
    cli::cli_abort("{.arg sql} must be a string.")
  }

  if (is.null(con)) {
    con <- get_default_duckdb_connection()
  }

  invisible(DBI::dbExecute(con, sql))
}
