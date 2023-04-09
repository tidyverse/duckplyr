oo_prep <- function(data, colname = "___row_number") {
  if (colname %in% names(data)) {
    abort("Must use column name not yet present in data")
  }

  mutate(data, "{colname}" := row_number())
}

oo_restore <- function(data, colname = "___row_number") {
  col <- sym(colname)
  sorted <- arrange(data, !!col)
  select(sorted, -!!col)
}
