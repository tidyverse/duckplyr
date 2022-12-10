setequal.data.frame <- function(x, y, ...) {
  check_dots_empty()
  if (!is.data.frame(y)) {
    abort("`y` must be a data frame.")
  }
  if (!isTRUE(is_compatible(x, y))) {
    return(FALSE)
  }

  cast <- vec_cast_common(x = x, y = y)
  all(vec_in(cast$x, cast$y)) && all(vec_in(cast$y, cast$x))
}
