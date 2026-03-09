#' Retrieve details about the most recent computation
#'
#' Before a result is computed, it is specified as a "relation" object.
#' This function retrieves this object for the last computation that led to the
#' materialization of a data frame.
#'
#' @return A duckdb "relation" object, or `NULL` if no computation has been
#'   performed yet.
#' @export
last_rel <- function() {
  duckplyr_the$last_rel
}

# Ellipsis for future extensions
last_rel_store <- function(rel, ...) {
  duckplyr_the$last_rel <- rel
}

on_load({
  options(duckdb.materialize_callback = last_rel_store)
})

duckplyr_the <- new_environment()

# Retrieve the supported read parameters for a DuckDB table function,
# caching the result in duckplyr_the for subsequent calls.
get_duckdb_read_opts <- function(fn_name) {
  cache_key <- paste0(fn_name, "_read_opts")
  cached <- duckplyr_the[[cache_key]]
  if (!is.null(cached)) {
    return(cached)
  }

  con <- get_default_duckdb_connection()
  res <- DBI::dbGetQuery(
    con,
    paste0(
      "SELECT parameters FROM duckdb_functions() ",
      "WHERE function_type = 'table' AND function_name = '",
      fn_name,
      "'"
    )
  )
  params <- res$parameters[[1]]
  # Remove "col0" which is the positional file path argument
  opts <- sort(params[params != "col0"])
  duckplyr_the[[cache_key]] <- opts
  opts
}
