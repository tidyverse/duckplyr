oo_prep <- function(data, colname = "___row_number") {
  if (Sys.getenv("DUCKPLYR_OUTPUT_ORDER") != "TRUE") {
    return(data)
  }

  if (colname %in% names(data)) {
    abort("Must use column name not yet present in data")
  }

  mutate(data, "{colname}" := row_number())
}

oo_restore <- function(data, colname = "___row_number") {
  if (Sys.getenv("DUCKPLYR_OUTPUT_ORDER") != "TRUE") {
    return(data)
  }

  col <- sym(colname)
  sorted <- arrange(data, !!col)
  select(sorted, -!!col)
}
