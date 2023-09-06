#' TODO
#'
#' @param path Path to file TODO add what kind
#'
#' @param table_function TODO
#' @param options TODO
#'
#' @export
duckdb_from_file <- function(path, table_function, options=list()) {
  # FIXME: For some reason, it's important to create an alias here
  con <- get_default_duckdb_connection()

  out <- duckdb$rel_from_table_function(
    con,
    table_function,
    list(path),
    options
  )

  meta_rel_register_file(out, path, table_function, options)

  duckdb$rel_to_altrep(out)
}

#' TODO
#'
#' @param path Path to file TODO add what kind
#'
#' @param table_function TODO
#' @param options TODO
#'
#' @export
duckplyr_df_from_file <- function(path, table_function, options=list()) {
  out <- duckdb_from_file(path, table_function, options)
  as_duckplyr_df(out)
}
