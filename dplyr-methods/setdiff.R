setdiff.data.frame <- function(x, y, ...) {
  check_dots_empty()
  check_compatible(x, y)

  cast <- vec_cast_common(x = x, y = y)
  out <- vec_unique(vec_slice(cast$x, !vec_in(cast$x, cast$y)))
  dplyr_reconstruct(out, x)
}
