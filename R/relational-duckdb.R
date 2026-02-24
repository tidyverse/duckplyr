# To be moved to duckdb

# singleton DuckDB instance since we need only one really
# we need a finalizer to disconnect on exit otherwise we get a warning
default_duckdb_connection <- new.env(parent = emptyenv())
get_default_duckdb_connection <- function() {
  if (is.null(default_duckdb_connection$con)) {
    default_duckdb_connection$con <- create_default_duckdb_connection()
    reg.finalizer(default_duckdb_connection, onexit = TRUE, reset_default_duckdb_connection)
  }
  default_duckdb_connection$con
}

reset_default_duckdb_connection <- function(e = NULL) {
  if (is.null(e)) {
    e <- default_duckdb_connection
  }
  DBI::dbDisconnect(e$con)
  # duckdb::duckdb_shutdown(e$con@driver)
  e$con <- NULL
}

create_default_duckdb_connection <- function() {
  dbroot <- Sys.getenv("DUCKPLYR_TEMP_DIR", file.path(tempdir(), "duckplyr"))
  dbdir <- tempfile("duckplyr", tmpdir = dbroot, fileext = ".duckdb")
  dir.create(dbroot, recursive = TRUE, showWarnings = FALSE)

  drv <- duckdb::duckdb(dbdir = dbdir)
  con <- DBI::dbConnect(drv)

  DBI::dbExecute(con, paste0("pragma temp_directory='", dbroot, "'"))

  duckdb$rapi_load_rfuns(drv@database_ref)

  for (i in seq_along(duckplyr_macros)) {
    sql <- paste0('CREATE MACRO "', names(duckplyr_macros)[[i]], '"', duckplyr_macros[[i]])
    DBI::dbExecute(con, sql)
  }

  con
}

duckdb_rel_from_df <- function(df, call = caller_env()) {
  # FIXME: make generic
  stopifnot(is.data.frame(df))

  rel <- duckdb$rel_from_altrep_df(
    df,
    strict = FALSE,
    allow_materialized = FALSE,
    wrap = TRUE
  )

  if (!is.null(rel)) {
    # Once we're here, we know it's an ALTREP data frame
    # We don't get here if it's already materialized

    rel_names <- duckdb$rapi_rel_names(rel)
    if (!identical(rel_names, names(df))) {
      # This can happen when column names change for an existing relational data frame
      exprs <- nexprs_from_loc(rel_names, set_names(seq_along(df), names(df)))
      rel <- rel_project.duckdb_relation(rel, exprs)
    }
    return(rel)
  }

  if (!is_duckdb_tibble(df)) {
    df <- as_duckplyr_df_impl(df)
  }

  con <- get_default_duckdb_connection()

  # FIXME: For some reason, it seems crucial to assign the result to a
  # variable before returning it
  experimental <- (Sys.getenv("DUCKPLYR_EXPERIMENTAL") == "TRUE")
  out <- duckdb$rel_from_df(con, df, experimental = experimental)

  check_df_for_rel(out, df, call)
  meta_rel_register_df(out, df)

  out

  # Causes protection errors
  # duckdb$rel_from_df(get_default_duckdb_connection(), df)
}

check_df_for_rel <- function(rel, df, call = caller_env()) {
  if (Sys.getenv("DUCKPLYR_CHECK_ROUNDTRIP") != "TRUE") {
    return()
  }

  roundtrip <- duckdb$rapi_rel_to_altrep(rel)
  rlang::with_options(duckdb.materialize_callback = NULL, {
    for (i in seq_along(df)) {
      if (!identical(df[[i]], roundtrip[[i]])) {
        cli::cli_abort("Imperfect roundtrip. Affected column: {.var {names(df)[[i]]}}.", call = call)
      }
    }
  })
}

# https://github.com/r-lib/vctrs/issues/1956
vec_ptype_safe <- function(x) {
  if (inherits(x, "Date")) {
    return(new_date())
  }

  exec(structure, vec_ptype(unclass(x)), !!!attributes(x))
}

#' @export
rel_to_df.duckdb_relation <- function(rel, ..., prudence = NULL, remote = FALSE) {
  if (is.null(prudence)) {
    cli::cli_abort("Argument {.arg {prudence}} is missing.")
  }

  # Same code in new_duckdb_tibble(), to avoid recursion there
  prudence_parsed <- prudence_parse(prudence, remote)
  out <- duckdb$rel_to_altrep(
    rel,
    n_rows = prudence_parsed$n_rows,
    n_cells = prudence_parsed$n_cells
  )

  new_duckdb_tibble(out, prudence = prudence)
}

#' @export
rel_filter.duckdb_relation <- function(rel, exprs, ...) {
  duckdb_exprs <- to_duckdb_exprs(exprs)
  out <- duckdb$rel_filter(rel, duckdb_exprs)

  meta_rel_register(out, expr(duckdb$rel_filter(
    !!meta_rel_get(rel)$name,
    list(!!!to_duckdb_exprs_meta(exprs))
  )))

  out
}

#' @export
rel_project.duckdb_relation <- function(rel, exprs, ...) {
  duckdb_exprs <- to_duckdb_exprs(exprs)

  out <- duckdb$rel_project(rel, duckdb_exprs)

  meta_rel_register(out, expr(duckdb$rel_project(
    !!meta_rel_get(rel)$name,
    list(!!!to_duckdb_exprs_meta(exprs))
  )))

  check_duplicate_names(out)

  out
}

#' @export
rel_aggregate.duckdb_relation <- function(rel, groups, aggregates, ...) {
  duckdb_groups <- to_duckdb_exprs(groups)
  duckdb_aggregates <- to_duckdb_exprs(aggregates)

  out <- duckdb$rel_aggregate(
    rel,
    groups = duckdb_groups,
    aggregates = duckdb_aggregates
  )

  meta_rel_register(out, expr(duckdb$rel_aggregate(
    !!meta_rel_get(rel)$name,
    groups = list(!!!to_duckdb_exprs_meta(groups)),
    aggregates = list(!!!to_duckdb_exprs_meta(aggregates))
  )))

  check_duplicate_names(out)

  out
}

#' @export
rel_order.duckdb_relation <- function(rel, orders, ascending = NULL, ...) {
  duckdb_orders <- to_duckdb_exprs(orders)

  out <- duckdb$rel_order(rel, duckdb_orders, ascending)

  meta_rel_register(out, expr(duckdb$rel_order(
    !!meta_rel_get(rel)$name,
    list(!!!to_duckdb_exprs_meta(orders))
  )))

  out
}

#' @export
rel_join.duckdb_relation <- function(left, right, conds, join, join_ref_type, ...) {
  duckdb_conds <- to_duckdb_exprs(conds)
  if (join == "full") {
    join <- "outer"
  }

  if (join_ref_type == "regular") {
    # Compatibility with older duckdb versions
    out <- duckdb$rel_join(left, right, duckdb_conds, join)

    meta_rel_register(out, expr(duckdb$rel_join(
      !!meta_rel_get(left)$name,
      !!meta_rel_get(right)$name,
      list(!!!to_duckdb_exprs_meta(conds)),
      !!join
    )))
  } else {
    out <- duckdb$rel_join(left, right, duckdb_conds, join, join_ref_type)

    meta_rel_register(out, expr(duckdb$rel_join(
      !!meta_rel_get(left)$name,
      !!meta_rel_get(right)$name,
      list(!!!to_duckdb_exprs_meta(conds)),
      !!join,
      !!join_ref_type
    )))
  }

  check_duplicate_names(out)

  out
}

#' @export
rel_limit.duckdb_relation <- function(rel, n, ...) {
  out <- duckdb$rel_limit(rel, n)

  meta_rel_register(out, expr(duckdb$rel_limit(
    !!meta_rel_get(rel)$name,
    !!n
  )))

  out
}

#' @export
rel_distinct.duckdb_relation <- function(rel, ...) {
  out <- duckdb$rel_distinct(rel)

  meta_rel_register(out, expr(duckdb$rel_distinct(
    !!meta_rel_get(rel)$name
  )))

  out
}

#' @export
rel_set_intersect.duckdb_relation <- function(rel_a, rel_b, ...) {
  out <- duckdb$rel_set_intersect(rel_a, rel_b)

  meta_rel_register(out, expr(duckdb$rel_set_intersect(
    !!meta_rel_get(rel_a)$name,
    !!meta_rel_get(rel_b)$name
  )))

  out
}

#' @export
rel_set_diff.duckdb_relation <- function(rel_a, rel_b, ...) {
  out <- duckdb$rel_set_diff(rel_a, rel_b)

  meta_rel_register(out, expr(duckdb$rel_set_diff(
    !!meta_rel_get(rel_a)$name,
    !!meta_rel_get(rel_b)$name
  )))

  out
}

#' @export
rel_set_symdiff.duckdb_relation <- function(rel_a, rel_b, ...) {
  out <- duckdb$rel_set_symdiff(rel_a, rel_b)

  meta_rel_register(out, expr(duckdb$rel_set_symdiff(
    !!meta_rel_get(rel_a)$name,
    !!meta_rel_get(rel_b)$name
  )))

  out
}

#' @export
rel_union_all.duckdb_relation <- function(rel_a, rel_b, ...) {
  out <- duckdb$rel_union_all(rel_a, rel_b)

  meta_rel_register(out, expr(duckdb$rel_union_all(
    !!meta_rel_get(rel_a)$name,
    !!meta_rel_get(rel_b)$name
  )))

  out
}

#' @export
rel_explain.duckdb_relation <- function(rel, ...) {
  duckdb$rel_explain(rel)
}

#' @export
rel_alias.duckdb_relation <- function(rel, ...) {}

#' @export
rel_set_alias.duckdb_relation <- function(rel, alias, ...) {
  out <- duckdb$rel_set_alias(rel, alias)

  meta_rel_register(out, expr(duckdb$rel_set_alias(
    !!meta_rel_get(rel)$name,
    !!alias
  )))

  out
}

#' @export
rel_names.duckdb_relation <- function(rel, ...) {
  duckdb$rapi_rel_names(rel)
}

to_duckdb_exprs <- function(exprs) {
  lapply(exprs, to_duckdb_expr)
}

to_duckdb_expr <- function(x) {
  switch(class(x)[[1]],
    relational_relexpr_reference = {
      out <- duckdb$expr_reference(x$name, if (is.null(x$rel)) "" else x$rel)
      if (!is.null(x$alias)) {
        duckdb$expr_set_alias(out, x$alias)
      }
      out
    },
    relational_relexpr_comparison = {
      out <- duckdb$expr_comparison(x$cmp_op, to_duckdb_exprs(x$exprs))
      if (!is.null(x$alias)) {
        duckdb$expr_set_alias(out, x$alias)
      }
      out
    },
    relational_relexpr_function = {
      out <- duckdb$expr_function(x$name, to_duckdb_exprs(x$args), order_bys = to_duckdb_exprs(x$order_bys))
      if (!is.null(x$alias)) {
        duckdb$expr_set_alias(out, x$alias)
      }
      out
    },
    relational_relexpr_window = {
      out <- duckdb$expr_window(
        to_duckdb_expr(x$expr),
        to_duckdb_exprs(x$partitions),
        to_duckdb_exprs(x$order_bys),
        offset_expr = to_duckdb_expr(x$offset_expr),
        default_expr = to_duckdb_expr(x$default_expr)
      )
      if (!is.null(x$alias)) {
        duckdb$expr_set_alias(out, x$alias)
      }
      out
    },
    relational_relexpr_constant = {
      out <- duckdb$expr_constant(x$val)
      if (!is.null(x$alias)) {
        duckdb$expr_set_alias(out, x$alias)
      }
      out
    },
    NULL = NULL,
    cli::cli_abort("Unknown expr class: {.cls {class(x)}}")
  )
}

to_duckdb_exprs_meta <- function(exprs) {
  lapply(exprs, to_duckdb_expr_meta)
}

to_duckdb_expr_meta <- function(x) {
  switch(class(x)[[1]],
    relational_relexpr_reference = {
      args <- list(x$name)
      if (!is.null(x$rel)) {
        args <- c(args, meta_rel_get(x$rel)$name)
      }
      out <- expr(duckdb$expr_reference(!!!args))
      if (!is.null(x$alias)) {
        out <- expr({
          tmp_expr <- !!out
          duckdb$expr_set_alias(tmp_expr, !!x$alias)
          tmp_expr
        })
      }
      out
    },
    relational_relexpr_comparison = {
      out <- expr(duckdb$expr_comparison(!!x$cmp_op, list(!!!to_duckdb_exprs_meta(x$exprs))))
      if (!is.null(x$alias)) {
        out <- expr({
          tmp_expr <- !!out
          duckdb$expr_set_alias(tmp_expr, !!x$alias)
          tmp_expr
        })
      }
      out
    },
    relational_relexpr_function = {
      meta_macro_register(x$name)
      order_bys_meta <- to_duckdb_exprs_meta(x$order_bys)
      out <- expr(duckdb$expr_function(!!x$name, list(!!!to_duckdb_exprs_meta(x$args)), order_bys = list(!!!order_bys_meta)))
      if (!is.null(x$alias)) {
        out <- expr({
          tmp_expr <- !!out
          duckdb$expr_set_alias(tmp_expr, !!x$alias)
          tmp_expr
        })
      }
      out
    },
    relational_relexpr_window = {
      out <- expr(duckdb$expr_window(
        !!to_duckdb_expr_meta(x$expr),
        list(!!!to_duckdb_exprs_meta(x$partitions)),
        list(!!!to_duckdb_exprs_meta(x$order_bys)),
        offset_expr = !!to_duckdb_expr_meta(x$offset_expr),
        default_expr = !!to_duckdb_expr_meta(x$default_expr)
      ))
      if (!is.null(x$alias)) {
        out <- expr({
          tmp_expr <- !!out
          duckdb$expr_set_alias(tmp_expr, !!x$alias)
          tmp_expr
        })
      }
      out
    },
    relational_relexpr_constant = {
      out <- expr(duckdb$expr_constant(!!x$val))

      if (!is.null(x$alias)) {
        out <- expr({
          tmp_expr <- !!out
          duckdb$expr_set_alias(tmp_expr, !!x$alias)
          tmp_expr
        })
      }
      out
    },
    NULL = expr(NULL),
    cli::cli_abort("Unknown expr class: {.cls {class(x)}}")
  )
}

check_duplicate_names <- function(rel) {
  # https://github.com/duckdb/duckdb/discussions/14682
  if (anyDuplicated(tolower(duckdb$rel_names(rel)))) {
    cli::cli_abort("Column names are case-insensitive in duckdb, fallback required.")
  }
}
