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

  if (any(map_lgl(.data, any_bad))) {
    abort("Can't process NaN values with `as_duckplyr_df()`.")
  }

  class(.data) <- c("duckplyr_df", class(.data))
  .data
}

any_bad <- function(x) {
  if (!is.numeric(x)) {
    return(FALSE)
  }

  if (!identical(class(x), "numeric") && !identical(class(x), "integer")) {
    return(TRUE)
  }

  any(is.nan(x))
}
