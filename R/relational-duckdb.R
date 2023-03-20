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
  "<" = '(a, b) AS a < b',
  "<=" = '(a, b) AS a <= b',
  ">" = '(a, b) AS a > b',
  ">=" = '(a, b) AS a >= b',
  "==" = '(a, b) AS a = b',
  "!=" = '(a, b) AS a <> b',
  "is.na" = '(a) AS (a IS NULL)',
  "n" = '() AS (COUNT(*))',
  # FIXME: Implement na.rm = FALSE, https://github.com/duckdb/duckdb/issues/5832#issuecomment-1375735472
  "sum" = '(x) AS (CASE WHEN SUM(x) IS NULL THEN 0 ELSE SUM(x) END)',
  "log10" = '(x) AS log(x)',
  "log" = '(x) AS ln(x)',
  # TPCH
  "as.Date" = '(x) AS strptime(x, \'%Y-%m-%d\')',
  "grepl" = '(pattern, x) AS regexp_matches(x, pattern)',
  "as.integer" = '(x) AS CAST(x AS int32)',
  "ifelse" = '(test, yes, no) AS (CASE WHEN test THEN yes ELSE no END)',
  "|" = '(x, y) AS (x OR y)',
  "&" = '(x, y) AS (x AND y)',
  "!" = '(x) AS (NOT x)',
  "any" = '(x) AS (bool_or(x))',
  "desc" = '(x) AS (-x)',
  "n_distinct" = '(x) AS (COUNT(DISTINCT x))',

  "___eq_na_matches_na" = '(a, b) AS ((a IS NULL AND b IS NULL) OR (a = b))',
  "___coalesce" = '(a, b) AS COALESCE(a, b)',

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

  tryCatch(
    {
      # duckdb:::df_is_materialized() is broken and unneeded
      return(duckdb:::rel_from_altrep_df(df))
    },
    error = function(e) {}
  )

  # FIXME: Move to duckdb:::rel_from_df()

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
  }

  # FIXME: For some reason, it's important to create an alias here
  con <- get_default_duckdb_connection()

  # FIXME: For some other reason, it seems crucial to assign the result to a
  # variable before returning it
  experimental <- (Sys.getenv("DUCKPLYR_EXPERIMENTAL") == "TRUE")
  out <- duckdb:::rel_from_df(con, df, experimental = experimental)

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

  out <- duckdb:::rel_aggregate(rel, duckdb_groups, duckdb_aggregates)

  meta_rel_register(out, expr(duckdb:::rel_aggregate(
    !!meta_rel_get(rel)$name,
    list(!!!to_duckdb_exprs_meta(groups)),
    list(!!!to_duckdb_exprs_meta(aggregates))
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
rel_join.duckdb_relation <- function(left, right, conds, join, ...) {
  duckdb_conds <- to_duckdb_exprs(conds)
  if (join == "full") {
    join <- "outer"
  }

  out <- duckdb:::rel_join(left, right, duckdb_conds, join)

  meta_rel_register(out, expr(duckdb:::rel_join(
    !!meta_rel_get(left)$name,
    !!meta_rel_get(right)$name,
    list(!!!to_duckdb_exprs_meta(conds)),
    !!join
  )))

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
    relational_relexpr_constant = {
      out <- expr(
        # FIXME: always pass experimental flag once it's merged
        if ("experimental" %in% names(formals(duckdb:::expr_constant))) {
          duckdb:::expr_constant(!!x$val, experimental = experimental)
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
    stop("Unknown expr class: ", class(x)[[1]])
  )
}
