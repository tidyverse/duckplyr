#' Read a table from a DuckDB database file
#'
#' @description
#' `r lifecycle::badge("experimental")`
#'
#' `read_tbl_duckdb()` reads a table from a DuckDB database file
#' by attaching the database file and reading the specified table.
#'
#' The database file is attached to the default duckplyr connection
#' and remains attached for the duration of the R session
#' to support lazy evaluation.
#'
#' @inheritParams read_file_duckdb
#' @inheritParams rlang::args_dots_empty
#' @param path Path to the DuckDB database file.
#' @param table_name The name of the table to read.
#' @param schema The schema name where the table is located. Defaults to `"main"`.
#'
#' @seealso [read_sql_duckdb()], [db_exec()]
#'
#' @return A duckplyr frame, see [as_duckdb_tibble()] for details.
#'
#' @export
#' @examplesIf rlang::is_interactive()
#' # Create a temporary DuckDB database with a table
#' db_path <- tempfile(fileext = ".duckdb")
#' con <- DBI::dbConnect(duckdb::duckdb(), db_path)
#' DBI::dbWriteTable(con, "test_table", data.frame(a = 1:3, b = c("x", "y", "z")))
#' DBI::dbDisconnect(con)
#'
#' # Read the table from the database file
#' df <- read_tbl_duckdb(db_path, "test_table")
#' print(df)
#'
#' # Clean up
#' unlink(db_path)
read_tbl_duckdb <- function(
  path,
  table_name,
  ...,
  schema = "main",
  prudence = c("thrifty", "lavish", "stingy")
) {
  check_dots_empty()

  if (!is_string(path)) {
    cli::cli_abort("{.arg path} must be a string.")
  }
  if (!is_string(table_name)) {
    cli::cli_abort("{.arg table_name} must be a string.")
  }
  if (!is_string(schema)) {
    cli::cli_abort("{.arg schema} must be a string.")
  }

  con <- get_default_duckdb_connection()

  # Normalize path for consistent database aliasing
  path <- normalizePath(path, mustWork = TRUE)

  # Generate a deterministic alias based on the file path using rlang::hash()
  path_hash <- substr(rlang::hash(path), 1, 16)
  db_alias <- paste0("duckplyr_db_", path_hash)

  # Check if database is already attached, attach if not
  attached_dbs <- DBI::dbGetQuery(
    con,
    "SELECT database_name FROM duckdb_databases()"
  )
  if (!(db_alias %in% attached_dbs$database_name)) {
    # Escape path for SQL (replace single quotes with escaped quotes)
    escaped_path <- gsub("'", "''", path)
    attach_sql <- paste0(
      "ATTACH '",
      escaped_path,
      "' AS \"",
      db_alias,
      "\" (READ_ONLY)"
    )
    DBI::dbExecute(con, attach_sql)
  }

  # Construct SQL to read the table
  # Escape identifiers by doubling any double quotes
  escaped_schema <- gsub('"', '""', schema)
  escaped_table <- gsub('"', '""', table_name)
  sql <- paste0(
    "SELECT * FROM \"",
    db_alias,
    "\".\"",
    escaped_schema,
    "\".\"",
    escaped_table,
    "\""
  )

  rel <- duckdb$rel_from_sql(con, sql)

  meta_rel_register(rel, expr(duckdb$rel_from_sql(con, !!sql)))

  rel_to_df(rel, prudence = prudence)
}
