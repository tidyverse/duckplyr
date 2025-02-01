#' @rdname head.duckplyr_df
#' @export
head.duckplyr_df <- function(x, n = 6L, ...) {
  stopifnot(is_integerish(n))

  duckplyr_error <- rel_try(list(name = "head", x = x, args = try_list(n = n)),
    #' @section Fallbacks:
    #' There is no DuckDB translation in `head.duckplyr_df()`
    #' - with a negative `n`.
    #'
    #' These features fall back to [head()], see `vignette("fallback")` for details.
    "Can't process negative n" = (n < 0),
    {
      rel <- duckdb_rel_from_df(x)
      out_rel <- rel_limit(rel, n)
      out <- duckplyr_reconstruct(out_rel, x)
      return(out)
    }
  )

  NextMethod()
}
