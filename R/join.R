rel_join_impl <- function(
  x,
  y,
  by,
  join,
  na_matches,
  suffix = c(".x", ".y"),
  keep = NULL,
  error_call = caller_env()
) {
  mutating <- !(join %in% c("semi", "anti"))

  if (mutating) {
    check_keep(keep, error_call = error_call)
  }

  na_matches <- check_na_matches(na_matches, error_call = error_call)

  x_names <- tbl_vars(x)
  y_names <- tbl_vars(y)

  if (is_null(by)) {
    by <- join_by_common(x_names, y_names, error_call = error_call)
  } else {
    by <- as_join_by(by, error_call = error_call)
  }

  x_by <- by$x
  y_by <- by$y
  x_rel <- duckdb_rel_from_df(x)
  x_rel <- rel_set_alias(x_rel, "lhs")
  y_rel <- duckdb_rel_from_df(y)
  y_rel <- rel_set_alias(y_rel, "rhs")

  # FIXME: Split join_cols, https://github.com/tidyverse/dplyr/issues/7050
  vars <- join_cols(
    x_names = x_names,
    y_names = y_names,
    by = by,
    suffix = suffix,
    keep = keep,
    error_call = error_call
  )

  # vec_ptype_safe: https://github.com/r-lib/vctrs/issues/1956
  x_in <- map(as.list(x)[vars$x$key], vec_ptype_safe)
  y_in <- map(as.list(y)[vars$y$key], vec_ptype_safe)

  x_key <- as.data.frame(set_names(x_in, names(vars$x$key)))
  y_key <- as.data.frame(set_names(y_in, names(vars$x$key)))

  # Side effect: check join compatibility
  join_ptype_common(x_key, y_key, vars, error_call = error_call)

  # Rename if non-unique column names
  if (mutating) {
    if (length(intersect(x_names, y_names)) != 0) {
      x_names_remap <- paste0(x_names, "_x")
      x_by <- paste0(x_by, "_x")
      x_exprs <- exprs_from_loc(x, set_names(seq_along(x_names_remap), x_names_remap))
      x_rel <- rel_project(x_rel, x_exprs)

      y_names_remap <- paste0(y_names, "_y")
      y_by <- paste0(y_by, "_y")
      y_exprs <- exprs_from_loc(y, set_names(seq_along(y_names_remap), y_names_remap))
      y_rel <- rel_project(y_rel, y_exprs)
    } else {
      x_names_remap <- x_names
      y_names_remap <- y_names
    }
  }

  x_rel <- oo_prep(x_rel, "___row_number_x")
  if (mutating) {
    y_rel <- oo_prep(y_rel, "___row_number_y")
  }

  x_by <- map(x_by, relexpr_reference, rel = x_rel)
  y_by <- map(y_by, relexpr_reference, rel = y_rel)

  cond_by <- by$condition

  if (na_matches == "na") {
    cond_by[cond_by == "=="] <- "___eq_na_matches_na"
  }

  conds <- pmap(list(cond_by, x_by, y_by), function(...) {
    if (..1 == "==") {
      relexpr_comparison(..1, list(..2, ..3))
    } else {
      relexpr_function(..1, list(..2, ..3))
    }
  })

  if (any(by$filter != "none")) {
    join_ref_type <- "asof"
  } else {
    join_ref_type <- "regular"
  }

  joined <- rel_join(x_rel, y_rel, conds, join, join_ref_type)

  if (mutating) {
    joined <- oo_restore_order(
      joined,
      c("___row_number_x", "___row_number_y"),
      list(x_rel, y_rel)
    )

    exprs <- c(
      nexprs_from_loc(x_names_remap, vars$x$out),
      nexprs_from_loc(y_names_remap, vars$y$out)
    )

    remap <- (is.null(keep) || is_false(keep))

    if (remap) {
      by_pos <- match(names(vars$x$key), x_names)
      # Only coalesce for equi-joins
      eq_idx <- (by$condition == "==")

      if (join == "right") {
        exprs[by_pos[eq_idx]] <- map2(y_by[eq_idx], names(vars$x$key)[eq_idx], relexpr_set_alias)
      } else {
        exprs[by_pos[eq_idx]] <- pmap(
          list(x_by[eq_idx], y_by[eq_idx], names(vars$x$key)[eq_idx]),
          function(...) {
            relexpr_function("___coalesce", list(..1, ..2), alias = ..3)
          }
        )
      }
    }

    out <- rel_project(joined, exprs)
  } else {
    out <- oo_restore(joined, "___row_number_x", list(x_rel))
  } # if (mutating)

  out <- rel_to_df(out)
  out <- dplyr_reconstruct(out, x)

  return(out)
}
