symdiff.data.frame <- function(x, y, ...) {
  check_dots_empty()
  check_compatible(x, y)

  cast <- vec_cast_common(x = x, y = y)
  only_x <- vec_slice(cast$x, !vec_in(cast$x, cast$y))
  only_y <- vec_slice(cast$y, !vec_in(cast$y, cast$x))

  out <- vec_unique(vec_rbind(only_x, only_y))
  dplyr_reconstruct(out, x)
}
