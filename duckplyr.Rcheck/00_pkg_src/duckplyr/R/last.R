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
