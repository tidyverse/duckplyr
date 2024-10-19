#' @export
explain.duckplyr_df <- function(x, ...) {
  rel_try(list(name = "explain", x = x),
    "No restrictions" = FALSE,
    {
      rel <- duckdb_rel_from_df(x)
      rel_explain(rel)
      return(invisible())
    }
  )

  writeLines("Can't convert to relational, fallback implementation will be used.")
  invisible()
}
