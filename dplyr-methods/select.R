select.data.frame <- function(.data, ...) {
  error_call <- dplyr_error_call()

  loc <- tidyselect::eval_select(
    expr(c(...)),
    data = .data,
    error_call = error_call
  )
  loc <- ensure_group_vars(loc, .data, notify = TRUE)

  out <- dplyr_col_select(.data, loc)
  out <- set_names(out, names(loc))

  out
}
