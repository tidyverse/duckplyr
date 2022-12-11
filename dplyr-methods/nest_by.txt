nest_by.data.frame <- function(.data, ..., .key = "data", .keep = FALSE) {
  .data <- group_by(.data, ...)
  nest_by.grouped_df(.data, .key = .key, .keep = .keep)
}
