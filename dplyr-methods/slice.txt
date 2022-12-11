slice.data.frame <- function(.data, ..., .by = NULL, .preserve = FALSE) {
  dots <- enquos(...)

  by <- compute_by(
    by = {{ .by }},
    data = .data,
    by_arg = the$slice_by_arg,
    data_arg = ".data"
  )

  loc <- slice_rows(.data, dots, by)
  dplyr_row_slice(.data, loc, preserve = .preserve)
}
