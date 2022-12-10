rename.data.frame <- function(.data, ...) {
  loc <- tidyselect::eval_rename(expr(c(...)), .data)
  # eval_rename() only returns changes
  names <- names(.data)
  names[loc] <- names(loc)

  set_names(.data, names)
}
