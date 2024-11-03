#' @export
head.duckplyr_df <- function(x, n = 6L, ...) {
  stopifnot(is_integerish(n))

  rel_try(list(name = "head", x = x, args = try_list(n = n)),
    "Can't process negative n" = (n < 0),
    {
      rel <- duckdb_rel_from_df(x)
      out_rel <- rel_limit(rel, n)
      out <- rel_to_df(out_rel)
      out <- dplyr_reconstruct(out, x)
      return(out)
    }
  )

  NextMethod()
}
