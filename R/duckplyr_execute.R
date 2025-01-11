#' Execute a statement for the default connection
#'
#' @description
#' `r lifecycle::badge("deprecated")`
#'
#' The \pkg{duckplyr} package relies on a DBI connection
#' to an in-memory database.
#' The `duckplyr_execute()` function allows running SQL statements
#' with this connection to, e.g., set up credentials
#' or attach other databases.
#' See <https://duckdb.org/docs/configuration/overview.html>
#' for more information on the configuration options.
#'
#' @param sql The statement to run.
#' @return The return value of the [DBI::dbExecute()] call, invisibly.
#' @keywords internal
#' @export
#' @examples
#' duckplyr_execute("SET threads TO 2")
duckplyr_execute <- function(sql) {
  lifecycle::deprecate_soft("1.0.0", "duckplyr_execute()", "db_exec()")

  con <- get_default_duckdb_connection()
  invisible(DBI::dbExecute(con, sql))
}
