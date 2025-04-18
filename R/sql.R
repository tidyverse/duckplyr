#' Return SQL query as duckdb_tibble
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
#' @seealso [db_exec()]
#'
#' @inheritParams read_file_duckdb
#' @param sql The SQL to run.
#' @param con The connection, defaults to the default connection.
#'
#' @export
#' @examples
#' read_sql_duckdb("FROM duckdb_settings()")
read_sql_duckdb <- function(sql, ..., prudence = c("thrifty", "lavish", "stingy"), con = NULL) {
  if (!is_string(sql)) {
    cli::cli_abort("{.arg sql} must be a string.")
  }

  # FIXME: For some reason, it's important to create an alias here
  if (is.null(con)) {
    con <- get_default_duckdb_connection()
  }

  rel <- duckdb$rel_from_sql(con, sql)

  meta_rel_register(rel, expr(duckdb$rel_from_sql(con, !!sql)))

  rel_to_df(rel, prudence = prudence)
}
