relocate.data.frame <- function(.data, ..., .before = NULL, .after = NULL) {
  loc <- eval_relocate(
    expr = expr(c(...)),
    data = .data,
    before = enquo(.before),
    after = enquo(.after),
    before_arg = ".before",
    after_arg = ".after"
  )

  out <- dplyr_col_select(.data, loc)
  out <- set_names(out, names(loc))

  out
}
