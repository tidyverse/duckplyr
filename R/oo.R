oo_prep <- function(rel, colname = "___row_number") {
  if (Sys.getenv("DUCKPLYR_OUTPUT_ORDER") != "TRUE") {
    return(rel)
  }

  names <- rel_names(rel)

  if (colname %in% names) {
    abort("Must use column name not yet present in rel")
  }

  proj_exprs <- c(
    imap(set_names(names), relexpr_reference, rel = NULL),
    list(
      relexpr_window(
        relexpr_function("row_number", list()),
        list(),
        alias = colname
      )
    )
  )

  rel_project(rel, proj_exprs)
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
