#' Execute a statement for the default connection
#'
#' The \pkg{duckplyr} package relies on a DBI connection
#' to an in-memory database.
#' The `duckplyr_execute()` function allows running SQL statements
#' with this connection to, e.g., set up credentials
#' or attach other databases.
#'
#' @param sql The statement to run.
#' @return The return value of the [DBI::dbExecute()] call, invisibly.
#' @export
#' @examples
#' duckplyr_execute("SET threads TO 2")
duckplyr_execute <- function(sql) {
  con <- get_default_duckdb_connection()
  invisible(DBI::dbExecute(con, sql))
}
