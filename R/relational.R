rel_try <- function(rel, ...) {
  call <- as.character(sys.call(-1)[[1]])

  if (!(list(call) %in% stats$calls)) {
    stats$calls <- c(stats$calls, call)
  }

  stats$attempts <- stats$attempts + 1L

  if (Sys.getenv("DUCKPLYR_FALLBACK_FORCE") == "TRUE") {
    stats$fallback <- stats$fallback + 1L
    return()
  }

  dots <- list(...)
  for (i in seq_along(dots)) {
    if (isTRUE(dots[[i]])) {
      stats$fallback <- stats$fallback + 1L
      if (!dplyr_mode) {
        if (Sys.getenv("DUCKPLYR_FALLBACK_INFO") == "TRUE") {
          inform(message = c("Requested fallback for relational:", i = names(dots)[[i]]))
        }
        if (Sys.getenv("DUCKPLYR_FORCE") == "TRUE") {
          abort("Fallback not available with DUCKPLYR_FORCE")
        }
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
    if (Sys.getenv("DUCKPLYR_FALLBACK_INFO") == "TRUE") {
      rlang::cnd_signal(rlang::message_cnd(message = "Error processing with relational.", parent = out))
    }
    stats$fallback <- stats$fallback + 1L
    return()
  }

  # Never reached due to return() in code
  stop("Must use a return() in rel_try().")
}

rel_translate_dots <- function(dots, data, forbid_new = FALSE) {
  if (is.null(names(dots))) {
    map(dots, rel_translate, data)
  } else if (forbid_new) {
    out <- accumulate(seq_along(dots), .init = NULL, function(.x, .y) {
      new <- names(dots)[[.y]]
      translation <- rel_translate(dots[[.y]], alias = new, data, names_forbidden = .x$new)
      list(
        new = c(.x$new, new),
        translation = c(.x$translation, list(translation))
      )
    })
    out[[length(out)]]$translation
  } else {
    imap(dots, rel_translate, data = data)
  }
}

rel_translate <- function(
    quo, data,
    alias = NULL,
    partition = NULL,
    need_window = FALSE,
    names_data = names(data),
    names_forbidden = NULL) {
  if (is_expression(quo)) {
    expr <- quo
    env <- baseenv()
  } else {
    expr <- quo_get_expr(quo)
    env <- quo_get_env(quo)
  }

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
        if (as.character(expr) %in% names_forbidden) {
          abort(paste0("Can't reuse summary variable `", as.character(expr), "`."))
        }
        if (as.character(expr) %in% names_data) {
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
        name <- as.character(expr[[1]])

        switch(name,
          "(" = {
            return(do_translate(expr[[2]], in_window = in_window))
          },
          # Hack
          "wday" = {
            def <- lubridate::wday
            call <- match.call(def, expr, envir = env)
            args <- as.list(call[-1])
            bad <- !(names(args) %in% c("x"))
            if (any(bad)) {
              abort(paste0(name, "(", names(args)[which(bad)[[1]]], " = ) not supported"))
            }
            if (!is.null(getOption("lubridate.week.start"))) {
              abort('wday() with option("lubridate.week.start") not supported')
            }
          },
          "strftime" = {
            def <- strftime
            call <- match.call(def, expr, envir = env)
            args <- as.list(call[-1])
            bad <- !(names(args) %in% c("x", "format"))
            if (any(bad)) {
              abort(paste0(name, "(", names(args)[which(bad)[[1]]], " = ) not supported"))
            }
          },
          "%in%" = {
            tryCatch(
              {
                values <- eval(expr[[3]], envir = baseenv())
                consts <- map(values, do_translate, in_window = in_window)
                ops <- map(consts, list, do_translate(expr[[2]]))
                cmp <- map(ops, relexpr_function, name = "==")
                alt <- reduce(cmp, function(.x, .y) {
                  relexpr_function("|", list(.x, .y))
                })
                return(alt)
              },
              error = identity
            )
          },
          "$" = {
            if (expr[[2]] == ".data") {
              return(do_translate(expr[[3]], in_window = in_window))
            } else if (expr[[2]] == ".env") {
              var_name <- as.character(expr[[3]])
              if (exists(var_name, envir = env)) {
                return(do_translate(get(var_name, env), in_window = in_window))
              } else {
                abort(paste0("object `", var_name, "` not found"))
              }
            }
          }
        )

        aliases <- c(
          sd = "stddev",
          first = "first_value",
          last = "last_value",
          nth = "nth_value",
          "/" = "___divide",
          "log10" = "___log10",
          "log" = "___log",
          NULL
        )

        known_window <- c(
          # Window functions
          "rank", "rank_dense", "dense_rank", "percent_rank",
          "row_number", "first_value", "last_value", "nth_value",
          "cume_dist", "lead", "lag", "ntile",

          # Aggregates
          "sum", "mean", "stddev", "min", "max", "median",
          #
          NULL
        )

        known_ops <- c("+", "-", "*", "/")

        known_funs <- c(
          # FIXME: How to indicate these are from lubridate?
          "hour",
          "minute",
          "second",
          "strftime",
          "abs",
          "%in%",
          "substr",
          #
          NULL
        )

        known <- c(names(duckplyr_macros), names(aliases), known_window, known_ops, known_funs)

        if (!(name %in% known)) {
          abort(paste0("Unknown function: ", name))
        }

        if (name %in% names(aliases)) {
          name <- aliases[[name]]
        }
        # name <- aliases[name] %|% name

        window <- need_window && (name %in% known_window)

        order_bys <- list()
        offset_expr <- NULL
        default_expr <- NULL
        if (name %in% c("lag", "lead")) {
          # x, n = 1L, default = NULL, order_by = NULL
          expr <- match.call(lag, expr)

          offset_expr <- relexpr_constant(expr$n %||% 1L)
          expr$n <- NULL

          if (!is.null(expr$default)) {
            default_expr <- do_translate(expr$default, in_window = TRUE)
            expr$default <- NULL
          }

          if (!is.null(expr$order_by)) {
            order_bys <- list(do_translate(expr$order_by, in_window = TRUE))
            expr$order_by <- NULL
          }
        }

        args <- map(as.list(expr[-1]), do_translate, in_window = in_window || window)
        fun <- relexpr_function(name, args)
        if (window) {
          partitions <- map(partition, relexpr_reference)
          fun <- relexpr_window(
            fun,
            partitions,
            order_bys,
            offset_expr = offset_expr,
            default_expr = default_expr
          )
        }
        fun
      },
      #
      abort(paste0("Internal: Unknown type ", typeof(expr)))
    )
  }

  out <- do_translate(expr)

  if (!is.null(alias) && !identical(alias, "")) {
    out <- relexpr_set_alias(out, alias)
  }

  structure(out, used = used)
}
