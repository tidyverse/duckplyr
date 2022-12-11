# To be moved to duckdb

# singleton DuckDB instance since we need only one really
# we need a finalizer to disconnect on exit otherwise we get a warning
default_duckdb_connection <- new.env(parent=emptyenv())
get_default_duckdb_connection <- function() {
  if(!exists("con", default_duckdb_connection)) {
    con <- DBI::dbConnect(duckdb::duckdb())

    DBI::dbExecute(con, 'CREATE MACRO "<"(a, b) AS a < b')
    DBI::dbExecute(con, 'CREATE MACRO "<="(a, b) AS a <= b')
    DBI::dbExecute(con, 'CREATE MACRO ">"(a, b) AS a > b')
    DBI::dbExecute(con, 'CREATE MACRO ">="(a, b) AS a >= b')
    DBI::dbExecute(con, 'CREATE MACRO "=="(a, b) AS a = b')
    DBI::dbExecute(con, 'CREATE MACRO "!="(a, b) AS a <> b')
    DBI::dbExecute(con, 'CREATE MACRO "is.na"(a) AS (a IS NULL)')

    default_duckdb_connection$con <- con

    reg.finalizer(default_duckdb_connection, onexit = TRUE, function(e) {
      DBI::dbDisconnect(e$con, shutdown = TRUE)
    })
  }
  default_duckdb_connection$con
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

  if (!identical(class(df), "data.frame") && !identical(class(df), c("tbl_df", "tbl", "data.frame"))) {
    stop("Need data frame or tibble to convert to relational.")
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

  duckdb:::rel_from_df(get_default_duckdb_connection(), df)
}

#' @export
rel_to_df.duckdb_relation <- function(rel, ...) {
  duckdb:::rel_to_altrep(rel)
}

#' @export
rel_filter.duckdb_relation <- function(rel, exprs, ...) {
  duckdb_exprs <- to_duckdb_exprs(exprs)
  duckdb:::rel_filter(rel, duckdb_exprs)
}

#' @export
rel_project.duckdb_relation <- function(rel, exprs, ...) {
  duckdb_exprs <- to_duckdb_exprs(exprs)
  duckdb:::rel_project(rel, duckdb_exprs)
}

#' @export
rel_aggregate.duckdb_relation <- function(rel, groups, aggregates, ...) {
}

#' @export
rel_order.duckdb_relation <- function(rel, orders, ...) {
}

#' @export
rel_inner_join.duckdb_relation <- function(left, right, conds, ...) {
}

#' @export
rel_limit.duckdb_relation <- function(rel, n, ...) {
  duckdb:::rapi_rel_limit(rel, n)
}

#' @export
rel_distinct.duckdb_relation <- function(rel, ...) {
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
}

#' @export
rel_names.duckdb_relation <- function(rel, ...) {
}

to_duckdb_exprs <- function(exprs) {
  lapply(exprs, to_duckdb_expr)
}

to_duckdb_expr <- function(x) {
  switch(class(x)[[1]],
    relational_expr_reference = {
      out <- duckdb:::expr_reference(x$name, if (is.null(x$rel)) "" else x$rel)
      if (!is.null(x$alias)) {
        duckdb:::expr_set_alias(out, x$alias)
      }
      out
    },
    relational_expr_function = {
      out <- duckdb:::expr_function(x$name, to_duckdb_exprs(x$args))
      if (!is.null(x$alias)) {
        duckdb:::expr_set_alias(out, x$alias)
      }
      out
    },
    relational_expr_constant = {
      out <- duckdb:::expr_constant(x$val)
      if (!is.null(x$alias)) {
        duckdb:::expr_set_alias(out, x$alias)
      }
      out
    },
    stop("Unknown expr class: ", class(x)[[1]])
  )
}
