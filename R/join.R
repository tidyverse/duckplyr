rel_join_impl <- function(x, y, by, suffix, keep, na_matches, join, error_call = caller_env()) {
  message(1)

  check_keep(keep, error_call = error_call)
  na_matches <- check_na_matches(na_matches, error_call = error_call)

  message(2)

  x_names <- tbl_vars(x)
  y_names <- tbl_vars(y)

  message(3)

  if (is_null(by)) {
    by <- join_by_common(x_names, y_names, error_call = error_call)
  } else {
    by <- as_join_by(by, error_call = error_call)
  }

  message(4)

  vars <- join_cols(
    x_names = x_names,
    y_names = y_names,
    by = by,
    suffix = suffix,
    keep = keep,
    error_call = error_call
  )

  message(5)

  x_by <- by$x
  y_by <- by$y

  x_rel <- duckdb_rel_from_df(x)
  message(51)

  y_rel <- duckdb_rel_from_df(y, torture = TRUE)

  message(6)

  # Rename if non-unique column names
  if (length(intersect(x_names, y_names)) != 0) {
    message("6a")

    x_names_remap <- paste0(x_names, "_x")
    x_by <- paste0(x_by, "_x")
    x_exprs <- exprs_from_loc(x, set_names(seq_along(x_names_remap), x_names_remap))
    x_rel <- rel_project(x_rel, x_exprs)

    y_names_remap <- paste0(y_names, "_y")
    y_by <- paste0(y_by, "_y")
    y_exprs <- exprs_from_loc(y, set_names(seq_along(y_names_remap), y_names_remap))
    y_rel <- rel_project(y_rel, y_exprs)
  } else {
    message("6b")

    x_names_remap <- x_names
    y_names_remap <- y_names
  }

  message(7)

  x_by <- map(x_by, relexpr_reference, rel = x_rel)
  y_by <- map(y_by, relexpr_reference, rel = y_rel)

  message(8)

  if (na_matches == "na") {
    cond <- "___eq_na_matches_na"
  } else {
    cond <- "=="
  }

  message(9)

  conds <- map2(x_by, y_by, ~ relexpr_function(cond, list(.x, .y)))

  message(10)

  joined <- rel_join(x_rel, y_rel, conds, join)

  message(11)

  exprs <- c(
    nexprs_from_loc(x_names_remap, vars$x$out),
    nexprs_from_loc(y_names_remap, vars$y$out)
  )

  message(12)

  remap <- (is.null(keep) || is_false(keep))

  message(13)

  if (remap && join %in% c("right", "full")) {
    by_pos <- match(names(vars$x$key), x_names)

    if (join == "right") {
      exprs[by_pos] <- map2(y_by, names(vars$x$key), relexpr_set_alias)
    } else if (join == "full") {
      exprs[by_pos] <- pmap(
        list(x_by, y_by, names(vars$x$key)),
        ~ relexpr_function("___coalesce", list(..1, ..2), alias = ..3)
      )
    }
  }

  message(14)

  out <- rel_project(joined, exprs)

  message(15)

  out <- rel_to_df(out)

  message(16)

  out <- dplyr_reconstruct(out, x)

  message(17)

  return(out)
}
