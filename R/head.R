#' @rdname head.duckplyr_df
#' @export
head.duckplyr_df <- function(x, n = 6L, ...) {
  stopifnot(is_integerish(n))

  rel_try(list(name = "head", x = x, args = try_list(n = n)),
    #' @section Fallbacks:
    #' You cannot use `head.duckplyr_df()`
    #' - with a negative `n`.
    #'
    #' If you do the code will fall back to `head()` without any error.
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
