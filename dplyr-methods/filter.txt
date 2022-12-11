filter.data.frame <- function(.data, ..., .by = NULL, .preserve = FALSE) {
  dots <- dplyr_quosures(...)
  check_filter(dots)

  by <- compute_by(
    by = {{ .by }},
    data = .data,
    by_arg = ".by",
    data_arg = ".data"
  )

  loc <- filter_rows(.data, dots, by)
  dplyr_row_slice(.data, loc, preserve = .preserve)
}
