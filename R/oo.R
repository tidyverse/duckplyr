oo_force <- function() {
  if (dplyr_mode) {
    return(TRUE)
  }

  if (Sys.getenv("DUCKPLYR_OUTPUT_ORDER") == "TRUE") {
    return(TRUE)
  }

  return(FALSE)
}

oo_prep <- function(
    rel,
    colname = "___row_number",
    ...,
    extra_cols_pre = character(),
    extra_cols_post = character(),
    force = oo_force()) {
  check_dots_empty0(...)

  if (!force) {
    return(rel)
  }

  names <- rel_names(rel)

  if (colname %in% names) {
    cli::cli_abort("Can't use column {.var {colname}} already present in rel for order preservation")
  }

  proj_exprs <- imap(set_names(names), relexpr_reference, rel = NULL)
  proj_exprs <- c(
    proj_exprs,
    if (length(extra_cols_pre)) map(extra_cols_pre, relexpr_constant, val = NA_integer_),
    list(relexpr_window(
      relexpr_function("row_number", list()),
      partitions = list(),
      alias = colname
    )),
    if (length(extra_cols_post)) map(extra_cols_post, relexpr_constant, val = NA_integer_),
    NULL
  )

  rel_project(rel, unname(proj_exprs))
}

oo_restore <- function(rel, colname = "___row_number", column_rels = list(NULL), force = oo_force()) {
  rel <- oo_restore_order(rel, colname, column_rels, force = force)
  oo_restore_cols(rel, colname, force = force)
}

oo_restore_order <- function(rel, colname = "___row_number", column_rels = list(NULL), force = oo_force()) {
  if (!force) {
    return(rel)
  }

  order_exprs <- map2(colname, column_rels, relexpr_reference)
  rel_order(rel, order_exprs)
}

oo_restore_cols <- function(rel, colname = "___row_number", extra = NULL, force = oo_force()) {
  if (!force) {
    if (!is.null(extra)) {
      names <- setdiff(rel_names(rel), extra)
      proj_exprs <- imap(set_names(names), relexpr_reference, rel = NULL)
      rel <- rel_project(rel, unname(proj_exprs))
    }

    return(rel)
  }

  names <- setdiff(rel_names(rel), c(colname, extra))
  proj_exprs <- imap(set_names(names), relexpr_reference, rel = NULL)

  rel_project(rel, unname(proj_exprs))
}
