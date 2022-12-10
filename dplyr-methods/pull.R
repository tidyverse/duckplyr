pull.data.frame <- function(.data, var = -1, name = NULL, ...) {
  var <- tidyselect::vars_pull(names(.data), !!enquo(var))
  name <- enquo(name)
  if (quo_is_null(name)) {
    return(.data[[var]])
  }
  name <- tidyselect::vars_pull(names(.data), !!name)
  set_names(.data[[var]], nm = .data[[name]])
}
