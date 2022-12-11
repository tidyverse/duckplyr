transmute.data.frame <- function(.data, ...) {
  dots <- check_transmute_args(...)
  dots <- dplyr_quosures(!!!dots)

  # We don't expose `.by` because `transmute()` is superseded
  by <- compute_by(by = NULL, data = .data)

  cols <- mutate_cols(.data, dots, by)

  out <- dplyr_col_modify(.data, cols)

  # Compact out `NULL` columns that got removed.
  # These won't exist in `out`, but we don't want them to look "new".
  # Note that `dplyr_col_modify()` makes it impossible to `NULL` a group column,
  # which we rely on below.
  cols <- compact_null(cols)

  # Retain expression columns in order of their appearance
  cols_expr <- names(cols)

  # Retain untouched group variables up front
  cols_group <- by$names
  cols_group <- setdiff(cols_group, cols_expr)

  cols_retain <- c(cols_group, cols_expr)

  dplyr_col_select(out, cols_retain)
}
