rows_delete.data.frame <- function(x,
         y,
         by = NULL,
         ...,
         unmatched = c("error", "ignore"),
         copy = FALSE,
         in_place = FALSE) {
  check_dots_empty()
  rows_df_in_place(in_place)

  y <- auto_copy(x, y, copy = copy)

  by <- rows_check_by(by, y)

  x_key <- rows_select_key(x, by, "x")
  y_key <- rows_select_key(y, by, "y")
  args <- vec_cast_common(x = x_key, y = y_key)
  x_key <- args$x
  y_key <- args$y

  keep <- rows_check_y_unmatched(x_key, y_key, unmatched)

  if (!is.null(keep)) {
    y_key <- dplyr_row_slice(y_key, keep)
  }

  extra <- setdiff(names(y), names(y_key))
  if (!is_empty(extra)) {
    message <- glue("Ignoring extra `y` columns: ", commas(tick_if_needed(extra)))
    inform(message, class = c("dplyr_message_delete_extra_cols", "dplyr_message"))
  }

  loc <- vec_match(x_key, y_key)
  unmatched <- is.na(loc)

  x_loc <- which(unmatched)

  dplyr_row_slice(x, x_loc)
}
