#' @export
duckdb_from_csv <- function(path) {
  # FIXME: For some reason, it's important to create an alias here
  con <- get_default_duckdb_connection()

  out <- duckdb:::rel_from_table_function(
    con,
    'read_csv_auto',
    list(path),
    list()
  )

  meta_rel_register_csv(out, path)

  duckdb:::rel_to_altrep(out)
}

#' @export
duckplyr_df_from_csv <- function(path) {
  out <- duckdb_from_csv(path)
  as_duckplyr_df(out)
}
