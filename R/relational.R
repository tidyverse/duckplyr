rel_try <- function(rel, fallback, ...) {
  # return(rel)

  dots <- as.logical(list(...))
  for (i in seq_along(dots)) {
    if (dots[[i]]) {
      # FIXME: enable always
      if (!identical(Sys.getenv("TESTTHAT"), "true")) {
        inform(message = c("Requested fallback for relational:", i = names(dots)[[i]]))
      }
      return(fallback)
    }
  }

  out <- rlang::try_fetch(rel, error = identity)
  if (inherits(out, "error")) {
    # FIXME: enable always
    if (!identical(Sys.getenv("TESTTHAT"), "true")) {
      rlang::cnd_signal(rlang::message_cnd(message = "Error processing with relational.", parent = out))
    }

    fallback
  } else {
    out
  }
}

rel_translate_dots <- function(dots, data) {
  if (is.null(names(dots))) {
    map(dots, rel_translate, data)
  } else {
    imap(dots, rel_translate, data = data)
  }
}

rel_translate <- function(quo, data, alias = NULL) {
  env <- quo_get_env(quo)

  do_translate <- function(expr) {
    # I don't understand yet how this can be a quosure
    stopifnot(!is_quosure(expr))

    switch(typeof(expr),
      character = ,
      logical = ,
      integer = ,
      double = relexpr_constant(expr),
      #
      symbol = {
        if (as.character(expr) %in% names(data)) {
          relexpr_reference(as.character(expr))
        } else {
          val <- eval_tidy(expr, env = env)
          relexpr_constant(val)
        }
      },
      #
      language = {
        args <- map(expr[-1], do_translate)
        relexpr_function(as.character(expr[[1]]), args)
      },
      #
      abort(paste0("Internal: Unknown type ", typeof(expr)))
    )
  }

  out <- do_translate(quo_get_expr(quo))

  if (!is.null(alias) && !identical(alias, "")) {
    out <- relexpr_set_alias(out, alias)
  }

  out
}

default_duckdb_connection <- new.env(parent = emptyenv())
get_default_duckdb_connection <- function() {
  if (!exists("con", default_duckdb_connection)) {
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

on_load({
  if (!identical(Sys.getenv("TESTTHAT"), "true")) {
    options(duckdb.materialize_message = TRUE)
  }
})
