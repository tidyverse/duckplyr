oo_prep <- function(data, colname = "___row_number") {
  if (Sys.getenv("DUCKPLYR_OUTPUT_ORDER") != "TRUE") {
    return(data)
  }

  if (colname %in% names(data)) {
    abort("Must use column name not yet present in data")
  }

  mutate(data, "{colname}" := row_number())
}

oo_restore <- function(rel, colname = "___row_number") {
  if (Sys.getenv("DUCKPLYR_OUTPUT_ORDER") != "TRUE") {
    return(rel)
  }

  order_exprs <- map(colname, relexpr_reference)
  rel <- rel_order(rel, order_exprs)

  names <- setdiff(rel_names(rel), colname)
  proj_exprs <- imap(set_names(names), relexpr_reference, rel = NULL)

  rel_project(rel, proj_exprs)
}
