rel_join_impl <- function(x, y, by, suffix, keep, na_matches, error_call = caller_env()) {
  na_matches <- check_na_matches(na_matches, error_call = error_call)

  x_names <- tbl_vars(x)
  y_names <- tbl_vars(y)

  if (is_null(by)) {
    by <- join_by_common(x_names, y_names, error_call = error_call)
  } else {
    by <- as_join_by(by, error_call = error_call)
  }

  vars <- join_cols(
    x_names = x_names,
    y_names = y_names,
    by = by,
    suffix = suffix,
    keep = keep,
    error_call = error_call
  )

  x_by <- by$x
  y_by <- by$y
  x_rel <- duckdb_rel_from_df(x)
  y_rel <- duckdb_rel_from_df(y)

  # Rename if non-unique column names
  if (length(intersect(x_names, y_names)) != 0) {
    x_names <- paste0(x_names, "_x")
    x_by <- paste0(x_by, "_x")
    x_exprs <- exprs_from_loc(x, set_names(seq_along(x_names), x_names))
    x_rel <- rel_project(x_rel, x_exprs)

    y_names <- paste0(y_names, "_y")
    y_by <- paste0(y_by, "_y")
    y_exprs <- exprs_from_loc(y, set_names(seq_along(y_names), y_names))
    y_rel <- rel_project(y_rel, y_exprs)
  }

  x_by <- map(x_by, relexpr_reference, rel = x_rel)
  y_by <- map(y_by, relexpr_reference, rel = y_rel)

  if (na_matches == "na") {
    cond <- "___eq_na_matches_na"
  } else {
    cond <- "=="
  }

  conds <- map2(x_by, y_by, ~ relexpr_function(cond, list(.x, .y)))

  joined <- rel_join(x_rel, y_rel, conds, "inner")

  exprs <- c(
    nexprs_from_loc(x_names, vars$x$out),
    nexprs_from_loc(y_names, vars$y$out)
  )
  out <- rel_project(joined, exprs)

  out <- rel_to_df(out)
  out <- dplyr_reconstruct(out, x)

  return(out)
}
