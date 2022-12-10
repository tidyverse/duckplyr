distinct.data.frame <- function(.data, ..., .keep_all = FALSE) {
  prep <- distinct_prepare(
    .data,
    vars = enquos(...),
    group_vars = group_vars(.data),
    .keep_all = .keep_all,
    caller_env = caller_env()
  )

  out <- prep$data

  cols <- dplyr_col_select(out, prep$vars)
  loc <- vec_unique_loc(cols)

  out <- dplyr_col_select(out, prep$keep)
  dplyr_row_slice(out, loc)
}
