#' Return SQL query as ducktbl
#'
#' @description
#' `r lifecycle::badge("experimental")`
#'
#' Runs a query and returns it as a duckplyr frame.
#'
#' @details
#' Using data frames from the calling environment is not supported yet,
#' see <https://github.com/duckdb/duckdb-r/issues/645> for details.
#'
#' @inheritParams duckfile
#' @param sql The SQL to run.
#' @param con The connection, defaults to the default connection.
#'
#' @export
#' @examples
#' ducksql("FROM duckdb_settings()")
ducksql <- function(sql, ..., lazy = TRUE, con = NULL) {
  if (!is_string(sql)) {
    cli::cli_abort("{.arg sql} must be a string.")
  }

  # FIXME: For some reason, it's important to create an alias here
  if (is.null(con)) {
    con <- get_default_duckdb_connection()
  }

  rel <- duckdb$rel_from_sql(con, sql)

  meta_rel_register(rel, expr(duckdb$rel_from_sql(con, !!sql)))

  out <- duckdb$rel_to_altrep(rel)
  as_ducktbl(out, .lazy = lazy)
}
