#' @rdname explain.duckplyr_df
#' @export
explain.duckplyr_df <- function(x, ...) {
  duckplyr_error <- rel_try(
    list(name = "explain", x = x),
    "No restrictions" = FALSE,
    {
      rel <- duckdb_rel_from_df(x)
      rel_explain(rel)
      return(invisible(x))
    }
  )

  writeLines(
    "Can't convert to relational, fallback implementation will be used."
  )
  invisible(x)
}

duckplyr_explain <- function(.data, ...) {
  try_fetch(
    .data <- as_duckplyr_df_impl(.data),
    error = function(e) {
      testthat::skip(conditionMessage(e))
    }
  )
  out <- explain(.data, ...)
  class(out) <- setdiff(class(out), "duckplyr_df")
  invisible(out)
}
