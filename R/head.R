#' @export
head.duckplyr_df <- function(x, n = 6L, ...) {
  stopifnot(is_integerish(n))

  if (n < 0) {
    return(NextMethod())
  }

  rel <- duckdb_rel_from_df(x)
  out_rel <- rel_limit(rel, n)
  out <- rel_to_df(out_rel)
  dplyr_reconstruct(out, x)
}
