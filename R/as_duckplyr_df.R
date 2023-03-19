#' @export
as_duckplyr_df <- function(.data) {
  if (inherits(.data, "duckplyr_df")) {
    return(.data)
  }

  if (!identical(class(.data), "data.frame") && !identical(class(.data), c("tbl_df", "tbl", "data.frame"))) {
    abort("Must pass a plain data frame or a tibble to `as_duckplyr_df()`.")
  }

  if (is.character(.row_names_info(.data, 0L))) {
    abort("Must pass data frame without row names to `as_duckplyr_df()`.")
  }

  if (anyNA(names(.data)) || any(names(.data) == "")) {
    abort("Missing or empty names not allowed.")
  }

  class(.data) <- c("duckplyr_df", class(.data))
  .data
}
