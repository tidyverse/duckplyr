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

  do_translate <- function(expr, in_window = FALSE, top_level = FALSE) {
    stopifnot(!is_quosure(expr))
    switch(typeof(expr),
      character = ,
      integer = ,
      double = relexpr_constant(expr),
      # https://github.com/duckdb/duckdb-r/pull/156
      logical = if (top_level && length(expr) == 1 && is.na(expr)) relexpr_function("___null", list()) else relexpr_constant(expr),
      #
      symbol = {
        if (as.character(expr) %in% names_forbidden) {
          cli::cli_abort("Can't reuse summary variable {.var {as.character(expr)}}.")
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

        if (name[[1]] == "::") {
          pkg <- name[[2]]
          name <- name[[3]]
        } else {
          pkg <- NULL
        }

        if (!(name %in% c("wday", "strftime", "lag", "lead"))) {
          if (!is.null(names(expr)) && any(names(expr) != "")) {
            # Fix grepl() logic below when allowing matching by argument name
            cli::cli_abort("Can't translate named argument {.code {name}({names(expr)[names(expr) != ''][[1]]} = )}.")
          }
        }

        switch(name,
          "(" = {
            return(do_translate(expr[[2]], in_window = in_window))
          },
          # Hack
          "wday" = {
            if (!is.null(pkg) && pkg != "lubridate") {
              cli::cli_abort("Don't know how to translate {.code {pkg}::{name}}.")
            }
            def <- lubridate::wday
            call <- match.call(def, expr, envir = env)
            args <- as.list(call[-1])
            bad <- !(names(args) %in% c("x"))
            if (any(bad)) {
              cli::cli_abort("{name}({names(args)[which(bad)[[1]]]} = ) not supported")
            }
            if (!is.null(getOption("lubridate.week.start"))) {
              cli::cli_abort('{.code wday()} with {.code option("lubridate.week.start")} not supported')
            }
          },
          "strftime" = {
            def <- strftime
            call <- match.call(def, expr, envir = env)
            args <- as.list(call[-1])
            bad <- !(names(args) %in% c("x", "format"))
            if (any(bad)) {
              cli::cli_abort("{name}({names(args)[which(bad)[[1]]]} = ) not supported")
            }
          },
          "%in%" = {
            values <- eval_tidy(expr[[3]], data = new_failing_mask(names_data), env = env)
            if (length(values) == 0) {
              return(relexpr_constant(FALSE))
            }

            lhs <- do_translate(expr[[2]])

            if (anyNA(values)) {
              has_na <- TRUE
              values <- values[!is.na(values)]
              if (length(values) == 0) {
                return(relexpr_function("is.na", list(lhs)))
              }
            } else {
              has_na <- FALSE
            }

            consts <- map(values, do_translate)
            ops <- map(consts, ~ list(lhs, .x))
            cmp <- map(ops, relexpr_function, name = "r_base::==")
            alt <- reduce(cmp, function(.x, .y) {
              relexpr_function("|", list(.x, .y))
            })
            coalesce <- relexpr_function("___coalesce", list(alt, relexpr_constant(has_na)))
            meta_ext_register()
            return(coalesce)
          },
          "$" = {
            if (expr[[2]] == ".data") {
              return(do_translate(expr[[3]], in_window = in_window))
            } else if (expr[[2]] == ".env") {
              var_name <- as.character(expr[[3]])
              if (exists(var_name, envir = env)) {
                return(do_translate(get(var_name, env), in_window = in_window))
              } else {
                cli::cli_abort("internal: object not found, should also be triggered by the dplyr fallback")
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
          "as.integer" = "r_base::as.integer",
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
          cli::cli_abort("Unknown function: {.code {name}()}")
        }

        if (name %in% names(aliases)) {
          name <- aliases[[name]]
          if (grepl("^r_base::", name)) {
            meta_ext_register()
          }
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

        if (name == "grepl") {
          if (!inherits(args[[1]], "relational_relexpr_constant")) {
            cli::cli_abort("Only constant patterns are supported in {.code grepl()}")
          }
        }

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

          if (name == "row_number") {
            fun <- relexpr_function("r_base::as.integer", list(fun))
            meta_ext_register()
          }
        }
        fun
      },
      #
      cli::cli_abort("Internal: Unknown type {.val {typeof(expr)}}")
    )
  }

  out <- do_translate(expr, top_level = TRUE)

  if (!is.null(alias) && !identical(alias, "")) {
    out <- relexpr_set_alias(out, alias)
  }

  structure(out, used = used)
}
