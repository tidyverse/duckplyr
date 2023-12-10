#' @export
head.duckplyr_df <- function(x, n = 6L, ...) {
  stopifnot(is_integerish(n))

  rel <- duckdb_rel_from_df(x)
  out_rel <- rel_limit(rel, n)
  out <- rel_to_df(out_rel)
  dplyr_reconstruct(out, x)
}
