rel_try <- function(rel, ...) {
  call <- as.character(sys.call(-1)[[1]])

  if (!(list(call) %in% stats$calls)) {
    stats$calls <- c(stats$calls, call)
  }

  stats$attempts <- stats$attempts + 1L

  dots <- list(...)
  for (i in seq_along(dots)) {
    if (dots[[i]]) {
      # FIXME: enable always
      if (!identical(Sys.getenv("TESTTHAT"), "true")) {
        inform(message = c("Requested fallback for relational:", i = names(dots)[[i]]))
      }
      stats$fallback <- stats$fallback + 1L
      if (Sys.getenv("DUCKPLYR_FORCE") == "TRUE") {
        abort("Fallback requested with DUCKPLYR_FORCE")
      }

      return()
    }
  }

  if (Sys.getenv("DUCKPLYR_FORCE") == "TRUE") {
    return(rel)
  }

  out <- rlang::try_fetch(rel, error = identity)
  if (inherits(out, "error")) {
    # FIXME: enable always
    if (!identical(Sys.getenv("TESTTHAT"), "true")) {
      rlang::cnd_signal(rlang::message_cnd(message = "Error processing with relational.", parent = out))
    }
    stats$fallback <- stats$fallback + 1L
    return()
  }

  # Never reached due to return() in code
  stop("Must use a return() in rel_try().")
}

rel_translate_dots <- function(dots, data) {
  if (is.null(names(dots))) {
    map(dots, rel_translate, data)
  } else {
    imap(dots, rel_translate, data = data)
  }
}

rel_translate <- function(quo, data, alias = NULL, partition = NULL) {
  env <- quo_get_env(quo)

  used <- character()

  do_translate <- function(expr, in_window = FALSE) {
    if (is_quosure(expr)) {
      # FIXME: What to do with the environment here?
      expr <- quo_get_expr(expr)
    }

    switch(typeof(expr),
      character = ,
      logical = ,
      integer = ,
      double = relexpr_constant(expr),
      #
      symbol = {
        if (as.character(expr) %in% names(data)) {
          ref <- as.character(expr)
          if (!(ref %in% used)) {
            used <<- c(used, ref)
          }
          relexpr_reference(ref)
        } else {
          val <- eval_tidy(expr, env = env)
          relexpr_constant(val)
        }
      },
      #
      language = {
        switch(as.character(expr[[1]]),
          "(" = {
            return(do_translate(expr[[2]], in_window = in_window))
          },
          "%in%" = {
            tryCatch(
              {
                values <- eval(expr[[3]], env = baseenv())
                consts <- map(values, do_translate, in_window = in_window)
                ops <- map(consts, list, do_translate(expr[[2]]))
                cmp <- map(ops, relexpr_function, name = "==")
                alt <- reduce(cmp, ~ relexpr_function("|", list(.x, .y)))
                return(alt)
              },
              error = identity
            )
          }
        )

        name <- as.character(expr[[1]])

        window <- name %in% c(
          # Window functions
          "rank", "rank_dense", "dense_rank", "percent_rank",
          "row_number", "first_value", "first", "last_value", "last", "nth_value",
          "cume_dist", "lead", "lag", "ntile",

          # Aggregates
          "sum", "mean",

          NULL
        )

        args <- map(as.list(expr[-1]), do_translate, in_window = in_window || window)
        fun <- relexpr_function(name, args)
        if (window) {
          part <- map(partition, relexpr_reference)
          fun <- relexpr_window(fun, part)
        }
        fun
      },
      #
      abort(paste0("Internal: Unknown type ", typeof(expr)))
    )
  }

  out <- do_translate(quo_get_expr(quo))

  if (!is.null(alias) && !identical(alias, "")) {
    out <- relexpr_set_alias(out, alias)
  }

  structure(out, used = used)
}

on_load({
  if (!identical(Sys.getenv("TESTTHAT"), "true")) {
    options(duckdb.materialize_message = TRUE)
  }
})
