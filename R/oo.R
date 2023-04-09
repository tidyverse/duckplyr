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

oo_restore <- function(rel, colname = "___row_number", column_rels = list(NULL)) {
  rel <- oo_restore_order(rel, colname, column_rels)
  oo_restore_cols(rel, colname)
}

oo_restore_order <- function(rel, colname = "___row_number", column_rels = list(NULL)) {
  if (Sys.getenv("DUCKPLYR_OUTPUT_ORDER") != "TRUE") {
    return(rel)
  }

  order_exprs <- map2(colname, column_rels, relexpr_reference)
  rel_order(rel, order_exprs)
}

oo_restore_cols <- function(rel, colname = "___row_number") {
  if (Sys.getenv("DUCKPLYR_OUTPUT_ORDER") != "TRUE") {
    return(rel)
  }

  names <- setdiff(rel_names(rel), colname)
  proj_exprs <- imap(set_names(names), relexpr_reference, rel = NULL)

  rel_project(rel, proj_exprs)
}
