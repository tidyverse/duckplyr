# To be moved to duckdb

# singleton DuckDB instance since we need only one really
# we need a finalizer to disconnect on exit otherwise we get a warning
default_duckdb_connection <- new.env(parent = emptyenv())
get_default_duckdb_connection <- function() {
  if (!exists("con", default_duckdb_connection)) {
    default_duckdb_connection$con <- create_default_duckdb_connection()

    reg.finalizer(default_duckdb_connection, onexit = TRUE, function(e) {
      DBI::dbDisconnect(e$con, shutdown = TRUE)
    })
  }
  default_duckdb_connection$con
}

duckplyr_macros <- c(
  "<" = '(x, y) AS x < y',
  "<=" = '(x, y) AS x <= y',
  ">" = '(x, y) AS x > y',
  ">=" = '(x, y) AS x >= y',
  "==" = '(x, y) AS x = y',
  "!=" = '(x, y) AS x <> y',

  "___divide" = "(x, y) AS CASE WHEN x = 0 AND y = 0 THEN CAST('NaN' AS double) ELSE CAST(x AS double) / y END",

  "is.na" = '(x) AS (x IS NULL)',
  "n" = '() AS CAST(COUNT(*) AS int32)',

  "log10" = '(x) AS log(x)',
  "log" = '(x) AS ln(x)',
  # TPCH

  # https://github.com/duckdb/duckdb/discussions/8599
  # "as.Date" = '(x) AS strptime(x, \'%Y-%m-%d\')',

  "grepl" = '(pattern, x) AS regexp_matches(x, pattern)',
  "as.integer" = '(x) AS CAST(x AS int32)',
  "ifelse" = '(test, yes, no) AS (CASE WHEN test THEN yes ELSE no END)',
  "|" = '(x, y) AS (x OR y)',
  "&" = '(x, y) AS (x AND y)',
  "!" = '(x) AS (NOT x)',
  "any" = '(x) AS (bool_or(x))',
  "desc" = '(x) AS (-x)',
  "n_distinct" = '(x) AS (COUNT(DISTINCT x))',

  "wday" = "(x) AS CAST(weekday(CAST (x AS DATE)) + 1 AS int32)",

  "___eq_na_matches_na" = '(x, y) AS ((x IS NULL AND y IS NULL) OR (x = y))',
  # https://github.com/duckdb/duckdb/issues/8605
  # "___eq_na_matches_na" = '(x, y) AS (x IS DISTINCT FROM y)',
  "___coalesce" = '(x, y) AS COALESCE(x, y)',

  NULL
)

create_default_duckdb_connection <- function() {
  con <- DBI::dbConnect(duckdb::duckdb())

  for (i in seq_along(duckplyr_macros)) {
    sql <- paste0('CREATE MACRO "', names(duckplyr_macros)[[i]], '"', duckplyr_macros[[i]])
    DBI::dbExecute(con, sql)
  }

  con
}

#' DuckDB relational backend
#'
#' TBD.
#'
#' @param df A data frame.
#' @return A relational object.
#'
#' @export
duckdb_rel_from_df <- function(df) {
  # FIXME: make generic
  stopifnot(is.data.frame(df))

  rel <- duckdb:::rel_from_altrep_df(df, strict = FALSE, allow_materialized = FALSE)
  if (!is.null(rel)) {
    # Once we're here, we know it's an ALTREP data frame
    # We don't get here if it's already materialized

    rel_names <- duckdb:::rapi_rel_names(rel)
    if (!identical(rel_names, names(df))) {
      # This can happen when column names change for an existing relational data frame
      exprs <- nexprs_from_loc(rel_names, set_names(seq_along(df), names(df)))
      rel <- rel_project.duckdb_relation(rel, exprs)
    }
    return(rel)
  }

  if (!is_duckplyr_df(df)) {
    df <- as_duckplyr_df(df)
  }

  if (is.character(.row_names_info(df, 0L))) {
    stop("Need data frame without row names to convert to relational.")
  }

  for (i in seq_along(df)) {
    col <- .subset2(df, i)
    if (!is.null(names(col))) {
      stop("Can't convert named vectors to relational. Affected column: `", names(df)[[i]], "`.")
    }
    if (!is.null(dim(col))) {
      stop("Can't convert arrays or matrices to relational. Affected column: `", names(df)[[i]], "`.")
    }
    if (isS4(col)) {
      stop("Can't convert S4 columns to relational. Affected column: `", names(df)[[i]], "`.")
    }
    # https://github.com/duckdb/duckdb/issues/8561
    if (is.factor(col)) {
      stop("Can't convert factor columns to relational. Affected column: `", names(df)[[i]], "`.")
    }
  }

  # FIXME: For some reason, it's important to create an alias here
  con <- get_default_duckdb_connection()

  # FIXME: For some other reason, it seems crucial to assign the result to a
  # variable before returning it
  experimental <- (Sys.getenv("DUCKPLYR_EXPERIMENTAL") == "TRUE")
  out <- duckdb:::rel_from_df(con, df, experimental = experimental)

  roundtrip <- duckdb:::rapi_rel_to_altrep(out)
  if (Sys.getenv("DUCKPLYR_CHECK_ROUNDTRIP") == "TRUE") {
    rlang::with_options(duckdb.materialize_message = FALSE, {
      for (i in seq_along(df)) {
        if (!identical(df[[i]], roundtrip[[i]])) {
          stop("Imperfect roundtrip. Affected column: `", names(df)[[i]], "`.")
        }
      }
    })
  } else {
    for (i in seq_along(df)) {
      df_attrib <- attributes(df[[i]])
      roundtrip_attrib <- attributes(roundtrip[[i]])
      if (!identical(df_attrib, roundtrip_attrib)) {
        stop("Attributes are lost during conversion. Affected column: `", names(df)[[i]], "`.")
      }
    }
  }

  meta_rel_register_df(out, df)

  out

  # Causes protection errors
  # duckdb:::rel_from_df(get_default_duckdb_connection(), df)
}

#' @export
rel_to_df.duckdb_relation <- function(rel, ...) {
  duckdb:::rel_to_altrep(rel)
}

#' @export
rel_filter.duckdb_relation <- function(rel, exprs, ...) {
  duckdb_exprs <- to_duckdb_exprs(exprs)
  out <- duckdb:::rel_filter(rel, duckdb_exprs)

  meta_rel_register(out, expr(duckdb:::rel_filter(
    !!meta_rel_get(rel)$name,
    list(!!!to_duckdb_exprs_meta(exprs))
  )))

  out
}

#' @export
rel_project.duckdb_relation <- function(rel, exprs, ...) {
  duckdb_exprs <- to_duckdb_exprs(exprs)

  out <- duckdb:::rel_project(rel, duckdb_exprs)

  meta_rel_register(out, expr(duckdb:::rel_project(
    !!meta_rel_get(rel)$name,
    list(!!!to_duckdb_exprs_meta(exprs))
  )))

  out
}

#' @export
rel_aggregate.duckdb_relation <- function(rel, groups, aggregates, ...) {
  duckdb_groups <- to_duckdb_exprs(groups)
  duckdb_aggregates <- to_duckdb_exprs(aggregates)

  out <- duckdb:::rel_aggregate(
    rel,
    groups = duckdb_groups,
    aggregates = duckdb_aggregates
  )

  meta_rel_register(out, expr(duckdb:::rel_aggregate(
    !!meta_rel_get(rel)$name,
    groups = list(!!!to_duckdb_exprs_meta(groups)),
    aggregates = list(!!!to_duckdb_exprs_meta(aggregates))
  )))

  out
}

#' @export
rel_order.duckdb_relation <- function(rel, orders, ...) {
  duckdb_orders <- to_duckdb_exprs(orders)

  out <- duckdb:::rel_order(rel, duckdb_orders)

  meta_rel_register(out, expr(duckdb:::rel_order(
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
    out <- duckdb:::rel_join(left, right, duckdb_conds, join)

    meta_rel_register(out, expr(duckdb:::rel_join(
      !!meta_rel_get(left)$name,
      !!meta_rel_get(right)$name,
      list(!!!to_duckdb_exprs_meta(conds)),
      !!join
    )))
  } else {
    out <- duckdb:::rel_join(left, right, duckdb_conds, join, join_ref_type)

    meta_rel_register(out, expr(duckdb:::rel_join(
      !!meta_rel_get(left)$name,
      !!meta_rel_get(right)$name,
      list(!!!to_duckdb_exprs_meta(conds)),
      !!join,
      !!join_ref_type
    )))
  }

  out
}

#' @export
rel_limit.duckdb_relation <- function(rel, n, ...) {
  out <- duckdb:::rel_limit(rel, n)

  meta_rel_register(out, expr(duckdb:::rel_limit(
    !!meta_rel_get(rel)$name,
    !!n
  )))

  out
}

#' @export
rel_distinct.duckdb_relation <- function(rel, ...) {
  out <- duckdb:::rel_distinct(rel)

  meta_rel_register(out, expr(duckdb:::rel_distinct(
    !!meta_rel_get(rel)$name
  )))

  out
}

#' @export
rel_set_intersect.duckdb_relation <- function(rel_a, rel_b, ...) {
  out <- duckdb:::rel_set_intersect(rel_a, rel_b)

  meta_rel_register(out, expr(duckdb:::rel_set_intersect(
    !!meta_rel_get(rel_a)$name,
    !!meta_rel_get(rel_b)$name
  )))

  out
}

#' @export
rel_set_diff.duckdb_relation <- function(rel_a, rel_b, ...) {
  out <- duckdb:::rel_set_diff(rel_a, rel_b)

  meta_rel_register(out, expr(duckdb:::rel_set_diff(
    !!meta_rel_get(rel_a)$name,
    !!meta_rel_get(rel_b)$name
  )))

  out
}

#' @export
rel_set_symdiff.duckdb_relation <- function(rel_a, rel_b, ...) {
  out <- duckdb:::rel_set_symdiff(rel_a, rel_b)

  meta_rel_register(out, expr(duckdb:::rel_set_symdiff(
    !!meta_rel_get(rel_a)$name,
    !!meta_rel_get(rel_b)$name
  )))

  out
}

#' @export
rel_union_all.duckdb_relation <- function(rel_a, rel_b, ...) {
  out <- duckdb:::rel_union_all(rel_a, rel_b)

  meta_rel_register(out, expr(duckdb:::rel_union_all(
    !!meta_rel_get(rel_a)$name,
    !!meta_rel_get(rel_b)$name
  )))

  out
}

#' @export
rel_tostring.duckdb_relation <- function(rel, ...) {
}

#' @export
rel_explain.duckdb_relation <- function(rel, ...) {
  duckdb:::rel_explain(rel)
}

#' @export
rel_alias.duckdb_relation <- function(rel, ...) {
}

#' @export
rel_set_alias.duckdb_relation <- function(rel, alias, ...) {
  out <- duckdb:::rel_set_alias(rel, alias)

  meta_rel_register(out, expr(duckdb:::rel_set_alias(
    !!meta_rel_get(rel)$name,
    !!alias
  )))

  out
}

#' @export
rel_names.duckdb_relation <- function(rel, ...) {
  duckdb:::rapi_rel_names(rel)
}

to_duckdb_exprs <- function(exprs) {
  lapply(exprs, to_duckdb_expr)
}

to_duckdb_expr <- function(x) {
  switch(class(x)[[1]],
    relational_relexpr_reference = {
      out <- duckdb:::expr_reference(x$name, if (is.null(x$rel)) "" else x$rel)
      if (!is.null(x$alias)) {
        duckdb:::expr_set_alias(out, x$alias)
      }
      out
    },
    relational_relexpr_function = {
      out <- duckdb:::expr_function(x$name, to_duckdb_exprs(x$args))
      if (!is.null(x$alias)) {
        duckdb:::expr_set_alias(out, x$alias)
      }
      out
    },
    relational_relexpr_window = {
      out <- duckdb:::expr_window(
        to_duckdb_expr(x$expr),
        to_duckdb_exprs(x$partitions),
        to_duckdb_exprs(x$order_bys),
        offset_expr = to_duckdb_expr(x$offset_expr),
        default_expr = to_duckdb_expr(x$default_expr)
      )
      if (!is.null(x$alias)) {
        duckdb:::expr_set_alias(out, x$alias)
      }
      out
    },
    relational_relexpr_constant = {
      if ("experimental" %in% names(formals(duckdb:::expr_constant))) {
        experimental <- (Sys.getenv("DUCKPLYR_EXPERIMENTAL") == "TRUE")
        out <- duckdb:::expr_constant(x$val, experimental = experimental)
      } else {
        out <- duckdb:::expr_constant(x$val)
      }
      if (!is.null(x$alias)) {
        duckdb:::expr_set_alias(out, x$alias)
      }
      out
    },
    NULL = NULL,
    stop("Unknown expr class: ", class(x)[[1]])
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
      out <- expr(duckdb:::expr_reference(!!!args))
      if (!is.null(x$alias)) {
        out <- expr({
          tmp_expr <- !!out
          duckdb:::expr_set_alias(tmp_expr, !!x$alias)
          tmp_expr
        })
      }
      out
    },
    relational_relexpr_function = {
      meta_macro_register(x$name)
      out <- expr(duckdb:::expr_function(!!x$name, list(!!!to_duckdb_exprs_meta(x$args))))
      if (!is.null(x$alias)) {
        out <- expr({
          tmp_expr <- !!out
          duckdb:::expr_set_alias(tmp_expr, !!x$alias)
          tmp_expr
        })
      }
      out
    },
    relational_relexpr_window = {
      out <- expr(duckdb:::expr_window(
        !!to_duckdb_expr_meta(x$expr),
        list(!!!to_duckdb_exprs_meta(x$partitions)),
        list(!!!to_duckdb_exprs_meta(x$order_bys)),
        offset_expr = !!to_duckdb_expr_meta(x$offset_expr),
        default_expr = !!to_duckdb_expr_meta(x$default_expr)
      ))
      if (!is.null(x$alias)) {
        out <- expr({
          tmp_expr <- !!out
          duckdb:::expr_set_alias(tmp_expr, !!x$alias)
          tmp_expr
        })
      }
      out
    },
    relational_relexpr_constant = {
      out <- expr(
        # FIXME: always pass experimental flag once it's merged
        if ("experimental" %in% names(formals(duckdb:::expr_constant))) {
          # experimental is set at the top,
          # the sym() gymnastics are to satisfy R CMD check
          duckdb:::expr_constant(!!x$val, experimental = !!sym("experimental"))
        } else {
          duckdb:::expr_constant(!!x$val)
        }
      )

      if (!is.null(x$alias)) {
        out <- expr({
          tmp_expr <- !!out
          duckdb:::expr_set_alias(tmp_expr, !!x$alias)
          tmp_expr
        })
      }
      out
    },
    NULL = expr(NULL),
    stop("Unknown expr class: ", class(x)[[1]])
  )
}
