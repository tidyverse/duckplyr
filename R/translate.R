# Documented in `.github/CONTRIBUTING.md`

rel_find_call <- function(fun, env) {
  name <- as.character(fun)

  if (name[[1]] == "::") {
    # Fully qualified name, no check needed
    return(c(name[[2]], name[[3]]))
  } else if (length(name) != 1) {
    cli::cli_abort("Can't translate function {.code {expr_deparse(fun)}}.")
  }

  # Order from https://docs.google.com/spreadsheets/d/1j3AFOKiAknTGpXU1uSH7JzzscgYjVbUEwmdRHS7268E/edit?gid=769885824#gid=769885824,
  # generated as `expr_result` by 63-gh-detail.R
  pkgs <- switch(name,
    # Handled in a special way, not mentioned here
    # "desc" = c("dplyr", "duckplyr"),
    "==" = "base",
    "/" = "base",
    "$" = "base", # very special, also with constant folding
    "mean" = "base",
    "n" = c("dplyr", "duckplyr"),
    ">" = "base",
    "%in%" = "base",
    "sum" = "base",
    "!" = "base",
    "&" = "base",
    "-" = "base",
    "(" = "base",
    "is.na" = "base",
    # "ifelse" = "base",
    "!=" = "base",
    # "c" = "base",
    "*" = "base",
    "+" = "base",
    "<" = "base",
    # "[" = "base", # won't implement?
    ">=" = "base",
    "n_distinct" = c("dplyr", "duckplyr"),
    "max" = "base",
    "<=" = "base",
    # "as.numeric" = "base",
    "|" = "base",
    # "factor" = "base",
    # "^" = "base",
    "min" = "base",
    # "replace" = "base",
    "grepl" = "base",
    # ":" = "base",
    # "as.character" = "base",
    # "paste" = "base",
    # "round" = "base",
    # "paste0" = "base",
    # "length" = "base",
    # ".data$" = c("dplyr", "duckplyr"), # implemented
    "sd" = "stats",
    # "[[" = "base", # won't implement?
    # "gsub" = "base",
    # "str_detect" = "stringr",
    "median" = "stats",
    # "~" = "base", # won't implement?
    # "unique" = "base", # what's the use case?
    # ".$" = c("dplyr", "duckplyr"), # won't implement?
    # "%>%" = "magrittr", # with the help of magrittr?
    # "as.Date" = "base",
    "as.integer" = "base",
    # "nrow" = "base",
    # "as.factor" = "base",
    # "%<=>%" = "???", # what is this?
    "row_number" = c("dplyr", "duckplyr"),
    # "rev" = "base", # what's the use case?
    # "seq" = "base", # what's the use case?
    # "sqrt" = "base",
    # "abs" = "base",
    "if_else" = c("dplyr", "duckplyr"),

    "any" = "base",
    "suppressWarnings" = "base",
    "lag" = c("dplyr", "duckplyr"),
    "lead" = c("dplyr", "duckplyr"),
    "first" = c("dplyr", "duckplyr"),
    "last" = c("dplyr", "duckplyr"),
    "nth" = c("dplyr", "duckplyr"),
    "log10" = "base",
    "log" = "base",
    "rank" = "base",
    "min_rank" = c("dplyr", "duckplyr"),
    "dense_rank" = c("dplyr", "duckplyr"),
    "percent_rank" = c("dplyr", "duckplyr"),
    "cume_dist" = c("dplyr", "duckplyr"),
    "ntile" = c("dplyr", "duckplyr"),
    "hour" = "lubridate",
    "minute" = "lubridate",
    "second" = "lubridate",
    "wday" = "lubridate",
    "strftime" = "base",
    "abs" = "base",
    "substr" = "base",
    NULL
  )

  if (is.null(pkgs)) {
    cli::cli_abort("No translation for function {.code {name}}.")
  }

  # https://github.com/tidyverse/dplyr/pull/7046
  if (name == "n") {
    return(c("dplyr", "n"))
  }

  fun_val <- get0(fun, env, mode = "function", inherits = TRUE)

  for (pkg in pkgs) {
    if (identical(fun_val, get(name, envir = asNamespace(pkg)))) {
      return(c(pkg, name))
    }
  }

  if (length(pkgs) == 1) {
    cli::cli_abort("Function {.code {name}} does not map to {.code {pkgs}::{name}}.")
  } else {
    cli::cli_abort("Function {.code {name}} does not map to the corresponding function in {.pkg {pkgs}}.")
  }
}

infer_type_of_expr <- function(
    expr,
    types_data,
    names_data
) {
  if (typeof(expr) == 'symbol') {
    name <- as.character(expr)
    col_idx <- which(name == names_data)
    if (col_idx == 0) stop(paste0("Unable to find column '",name,"'"))
    return(types_data[col_idx])
  }
  return(typeof(expr))
}

types_are_comparable <- function(types) {
  # TODO: Incomplete, written for demo
  left  = types[1]
  right = types[2]

  if (left == right) return(TRUE)
  if (left == "integer" && right == "double") return(TRUE)
  if (left == "double"  && right == "integer") return(TRUE)

  return(FALSE)
}

rel_translate_lang <- function(
    expr,
    do_translate,
    # FIXME: Perform constant folding instead
    names_data,
    types_data,
    env,
    # FIXME: Perform constant folding instead
    partition,
    in_window,
    need_window
) {
  pkg_name <- rel_find_call(expr[[1]], env)
  pkg <- pkg_name[[1]]
  name <- pkg_name[[2]]


  if (name %in% c(">","<","=",">=","<=") && !is.null(types_data)) {
    
    types <- sapply(
        expr[2:3],
        infer_type_of_expr,
        types_data,
        names_data
    )

    if (types_are_comparable(types)) {
      return(
        relexpr_comparison(
          list(do_translate(expr[[2]]), do_translate(expr[[3]]))
          ,name
        )
      )  
    }
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
    "rank", "dense_rank", "percent_rank",
    "row_number", "first", "last", "nth",
    "cume_dist", "lead", "lag", "ntile",

    # Aggregates
    "sum", "mean", "sd", "min", "max", "median",
    #
    NULL
  )

  window <- need_window && (name %in% known_window)

  if (name %in% names(aliases)) {
    name <- aliases[[name]]
    if (grepl("^r_base::", name)) {
      meta_ext_register()
    }
  }
  # name <- aliases[name] %|% name

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

  types_data = NULL
  if (hasArg(data) && !is.null(data)) {
    types_data <- sapply(data,typeof)
  }

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
      language = rel_translate_lang(
        expr,
        do_translate,
        names_data,
        types_data,
        env,
        partition,
        in_window,
        need_window
      ),
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
