union.data.frame <- function(x, y, ...) {
  check_dots_empty()
  check_compatible(x, y)

  out <- vec_unique(vec_rbind(x, y))
  dplyr_reconstruct(out, x)
}
