rows_insert.data.frame <- function(x,
         y,
         by = NULL,
         ...,
         conflict = c("error", "ignore"),
         copy = FALSE,
         in_place = FALSE) {
  check_dots_empty()
  rows_df_in_place(in_place)

  y <- auto_copy(x, y, copy = copy)

  by <- rows_check_by(by, y)

  rows_check_containment(x, y)
  y <- rows_cast_y(y, x)

  x_key <- rows_select_key(x, by, "x")
  y_key <- rows_select_key(y, by, "y")

  keep <- rows_check_y_conflict(x_key, y_key, conflict)

  if (!is.null(keep)) {
    y <- dplyr_row_slice(y, keep)
  }

  rows_bind(x, y)
}
