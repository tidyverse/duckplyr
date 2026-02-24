# Documented in `.github/CONTRIBUTING.md`

duckplyr_macros <- c(
  # https://github.com/duckdb/duckdb-r/pull/156
  "___null" = "() AS CAST(NULL AS BOOLEAN)",
  #
  "<" = "(x, y) AS (x < y)",
  "<=" = "(x, y) AS (x <= y)",
  ">" = "(x, y) AS (x > y)",
  ">=" = "(x, y) AS (x >= y)",
  "==" = "(x, y) AS (x == y)",
  "!=" = "(x, y) AS (x != y)",
  #
  "___divide" = "(x, y) AS CASE WHEN y = 0 THEN CASE WHEN x = 0 THEN CAST('NaN' AS double) WHEN x > 0 THEN CAST('+Infinity' AS double) ELSE CAST('-Infinity' AS double) END ELSE CAST(x AS double) / y END",
  #
  "is.na" = "(x) AS (x IS NULL)",
  "n" = "() AS CAST(COUNT(*) AS int32)",
  #
  "___log10" = "(x) AS CASE WHEN x < 0 THEN CAST('NaN' AS double) WHEN x = 0 THEN CAST('-Inf' AS double) ELSE log10(x) END",
  "___log" = "(x) AS CASE WHEN x < 0 THEN CAST('NaN' AS double) WHEN x = 0 THEN CAST('-Inf' AS double) ELSE ln(x) END",
  # TPCH

  # https://github.com/duckdb/duckdb/discussions/8599
  # "as.Date" = '(x) AS strptime(x, \'%Y-%m-%d\')',

  "sub" = "(pattern, replacement, x) AS (regexp_replace(x, pattern, replacement))",
  "gsub" = "(pattern, replacement, x) AS (regexp_replace(x, pattern, replacement, 'g'))",
  "grepl" = "(pattern, x) AS (CASE WHEN x IS NULL THEN FALSE ELSE regexp_matches(x, pattern) END)",
  "if_else" = "(test, yes, no) AS (CASE WHEN test IS NULL THEN NULL ELSE CASE WHEN test THEN yes ELSE no END END)",
  "|" = "(x, y) AS (x OR y)",
  "&" = "(x, y) AS (x AND y)",
  "!" = "(x) AS (NOT x)",
  #
  "wday" = "(x) AS CAST(weekday(CAST (x AS DATE)) + 1 AS int32)",
  #
  "___eq_na_matches_na" = "(x, y) AS (x IS NOT DISTINCT FROM y)",
  "___coalesce" = "(x, y) AS COALESCE(x, y)",
  #
  # FIXME: Need a better way?
  "suppressWarnings" = "(x) AS (x)",
  #
  "___sum_na" = "(x) AS (CASE WHEN SUM(CASE WHEN x IS NULL THEN 1 ELSE 0 END) > 0 THEN NULL ELSE SUM(x) END)",
  "___min_na" = "(x) AS (CASE WHEN SUM(CASE WHEN x IS NULL THEN 1 ELSE 0 END) > 0 THEN NULL ELSE MIN(x) END)",
  "___max_na" = "(x) AS (CASE WHEN SUM(CASE WHEN x IS NULL THEN 1 ELSE 0 END) > 0 THEN NULL ELSE MAX(x) END)",
  "___any_na" = "(x) AS (CASE WHEN SUM(CASE WHEN x IS NULL THEN 1 ELSE 0 END) > 0 THEN NULL ELSE bool_or(x) END)",
  "___all_na" = "(x) AS (CASE WHEN SUM(CASE WHEN x IS NULL THEN 1 ELSE 0 END) > 0 THEN NULL ELSE bool_and(x) END)",
  "___mean_na" = "(x) AS (CASE WHEN SUM(CASE WHEN x IS NULL THEN 1 ELSE 0 END) > 0 THEN NULL ELSE AVG(x) END)",
  "___sd_na" = "(x) AS (CASE WHEN SUM(CASE WHEN x IS NULL THEN 1 ELSE 0 END) > 0 THEN NULL ELSE STDDEV(x) END)",
  "___median_na" = "(x) AS (CASE WHEN SUM(CASE WHEN x IS NULL THEN 1 ELSE 0 END) > 0 THEN NULL ELSE percentile_cont(0.5) WITHIN GROUP (ORDER BY x) END)",
  #
  # In n_distinct() many NAs count as 1 if not filtered out with na.rm = TRUE
  "___n_distinct_na" = "(x) AS (CASE WHEN SUM(CASE WHEN x IS NULL THEN 1 ELSE 0 END) > 0 THEN (COUNT(DISTINCT x)+1) ELSE COUNT(DISTINCT x) END)",
  "___n_distinct" = "(x) AS (COUNT(DISTINCT x))",
  #
  NULL
)

rel_find_packages <- function(name) {
  # Remember to update limits.Rmd when adding new functions!
  switch(name,
    # Handled in a special way, not mentioned here
    "desc" = "dplyr",

    "==" = "base",
    "/" = "base",
    "$" = "base", # very special, also with constant folding
    "mean" = "base",
    "n" = "dplyr",
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
    "n_distinct" = "dplyr",
    "max" = "base",
    "<=" = "base",
    # "as.numeric" = "base",
    "|" = "base",
    # "factor" = "base",
    # "^" = "base",
    "min" = "base",
    # "replace" = "base",
    "sub" = "base",
    "gsub" = "base",
    "grepl" = "base",
    # ":" = "base",
    # "as.character" = "base",
    # "paste" = "base",
    # "round" = "base",
    # "paste0" = "base",
    # "length" = "base",
    # ".data$" = "dplyr",
    "sd" = "stats",
    # "[[" = "base", # won't implement?
    # "gsub" = "base",
    # "str_detect" = "stringr",
    "median" = "stats",
    # "~" = "base", # won't implement?
    # "unique" = "base", # what's the use case?
    # ".$" = "dplyr",
    # "%>%" = "magrittr", # with the help of magrittr?
    # "as.Date" = "base",
    "as.integer" = "base",
    # "nrow" = "base",
    # "as.factor" = "base",
    # "%<=>%" = "???", # what is this?
    "row_number" = "dplyr",
    # "rev" = "base", # what's the use case?
    # "seq" = "base", # what's the use case?
    # "sqrt" = "base",
    "abs" = "base",
    "if_else" = "dplyr",
    #
    "any" = "base",
    "all" = "base",
    "suppressWarnings" = "base",
    "lag" = "dplyr",
    "lead" = "dplyr",
    "first" = "dplyr",
    "last" = "dplyr",
    "nth" = "dplyr",
    # "rank" = "dplyr",
    # "dense_rank" = "dplyr",
    # "percent_rank" = "dplyr",
    # "cume_dist" = "dplyr",
    "log10" = "base",
    "log" = "base",
    "hour" = "lubridate",
    "minute" = "lubridate",
    "second" = "lubridate",
    "wday" = "lubridate",
    "strftime" = "base",
    "substr" = "base",

    "coalesce" = "dplyr",

    NULL
  )
  # Remember to update limits.Rmd when adding new functions!
}

# Operators and primitives that don't need call_match() for named argument normalization
rel_primitives <- c(
  # Comparison operators
  "<", "<=", ">", ">=", "==", "!=",
  # Logical operators
  "|", "&", "!",
  # Arithmetic operators
  "+", "-", "*", "/",
  # Special functions
  "(", "$", "%in%",
  # Aggregation functions with ... signatures (handled specially with custom definitions)
  "sum", "min", "max", "any", "all", "mean", "sd", "median", "n_distinct"
)

rel_find_call_candidates <- function(fun, call = caller_env()) {
  name <- as.character(fun)

  if (length(name) == 1) {
    pkgs <- rel_find_packages(name)

    if (!is.null(pkgs)) {
      return(list(
        packages = pkgs,
        name = name,
        check = TRUE
      ))
    }
  } else if (name[[1]] == "::") {
    my_pkg <- name[[2]]
    name <- name[[3]]

    if (my_pkg == "dd" || my_pkg %in% rel_find_packages(name)) {
      # Package name provided by the user, shortcut if found in list of packages
      # (requires non-NULL pkgs), no check needed
      return(list(
        packages = my_pkg,
        name = name,
        check = FALSE
      ))
    }
  } else if (name[[1]] == "$") {
    # Passthrough for functions prefixed with dd$
    my_pkg <- name[[2]]
    name <- name[[3]]

    if (identical(my_pkg, "dd")) {
      # Check performed by DuckDB
      return(list(
        packages = my_pkg,
        name = name,
        check = FALSE
      ))
    }
  }

  cli::cli_abort("Can't translate function {.code {expr_deparse(fun)}()}.", call = call)
}

rel_find_call <- function(fun, env, call = caller_env()) {
  call_cand <- rel_find_call_candidates(fun, call = call)
  pkgs <- call_cand$packages
  name <- call_cand$name

  if (!isTRUE(call_cand$check)) {
    return(c(pkgs, name))
  }

  # Order from https://docs.google.com/spreadsheets/d/1j3AFOKiAknTGpXU1uSH7JzzscgYjVbUEwmdRHS7268E/edit?gid=769885824#gid=769885824,
  # generated as `expr_result` by 63-gh-detail.R

  # https://github.com/tidyverse/dplyr/pull/7046
  if (name == "n") {
    return(c("dplyr", "n"))
  }

  fun_val <- get0(as.character(fun), env, mode = "function", inherits = TRUE)
  if (is.null(fun_val)) {
    cli::cli_abort("Function {.fun {name}} not found.", call = call)
  }

  for (pkg in pkgs) {
    if (identical(fun_val, get(name, envir = asNamespace(pkg)))) {
      return(c(pkg, name))
    }
  }

  if (length(pkgs) == 1) {
    cli::cli_abort("Function {.fun {name}} does not map to {.fun {pkgs}::{name}}.", call = call)
  } else {
    cli::cli_abort("Function {.fun {name}} does not map to the corresponding function in {.pkg {pkgs}}.", call = call)
  }
}

infer_class_of_expr <- function(expr, data) {
  if (typeof(expr) == "symbol") {
    name <- as.character(expr)
    if (name %in% names(data)) {
      return(class(data[[name]])[[1]])
    }
  }
  return(class(expr)[[1]])
}

classes_are_comparable <- function(left, right) {
  if (left == "integer" && right == "numeric") {
    return(TRUE)
  }
  if (left == "numeric" && right == "integer") {
    return(TRUE)
  }
  left == right
}

rel_translate_lang <- function(
  expr,
  do_translate,
  data,
  # FIXME: Perform constant folding instead
  env,
  # FIXME: Perform constant folding instead
  partition,
  in_window,
  need_window,
  call = caller_env()
) {
  pkg_name <- rel_find_call(expr[[1]], env, call = call)
  pkg <- pkg_name[[1]]
  name <- pkg_name[[2]]

  # Special case: passthrough to DuckDB
  if (pkg == "dd") {
    args_r <- as.list(expr[-1])

    # FIXME: How to deal with window functions?
    args <- map(args_r, do_translate, in_window = in_window)

    if (!is.null(names(args_r))) {
      need_names <- (names(args_r) != "")
      args[need_names] <- map2(args[need_names], names(args_r)[need_names], relexpr_set_alias)
    }
    fun <- relexpr_function(name, args)
    return(fun)
  }

  if (name %in% c(">", "<", "==", ">=", "<=")) {
    if (length(expr) != 3) {
      cli::cli_abort("Expected three expressions for comparison. Got {length(expr)}", call = call)
    }

    class_left <- infer_class_of_expr(expr[[2]], data)
    class_right <- infer_class_of_expr(expr[[3]], data)

    if (classes_are_comparable(class_left, class_right)) {
      return(
        relexpr_comparison(
          name,
          list(do_translate(expr[[2]]), do_translate(expr[[3]]))
        )
      )
    }
  }

  # Apply call_match() to normalize named arguments for non-primitive functions
  # For primitives/operators, skip call_match and rely on positional argument handling
  if (!(name %in% rel_primitives)) {
    # Get function definition from the package namespace
    fn_def <- get0(name, envir = asNamespace(pkg), mode = "function")
    if (!is.null(fn_def)) {
      expr <- call_match(expr, fn_def, dots_env = env)
    }
  }

  switch(name,
    "(" = {
      return(do_translate(expr[[2]], in_window = in_window))
    },
    # Hack
    "wday" = {
      if (!is.null(pkg) && pkg != "lubridate") {
        cli::cli_abort("Don't know how to translate {.code {pkg}::{name}}.", call = call)
      }
      # call_match() already applied above
      args <- as.list(expr[-1])
      bad <- !(names(args) %in% c("x"))
      if (any(bad)) {
        cli::cli_abort("{.code {name}({names(args)[which(bad)[[1]]]} = )} not supported", call = call)
      }
      if (!is.null(getOption("lubridate.week.start"))) {
        cli::cli_abort('{.code wday()} with {.code option("lubridate.week.start")} not supported', call = call)
      }
    },
    "strftime" = {
      # call_match() already applied above
      args <- as.list(expr[-1])
      bad <- !(names(args) %in% c("x", "format"))
      if (any(bad)) {
        cli::cli_abort("{.code {name}({names(args)[which(bad)[[1]]]} = )} not supported", call = call)
      }
    },
    "if_else" = {
      # call_match() already applied above; validate only supported args are used
      args <- as.list(expr[-1])
      bad <- !(names(args) %in% c("condition", "true", "false"))
      if (any(bad)) {
        cli::cli_abort("{.code {name}({names(args)[which(bad)[[1]]]} = )} not supported", call = call)
      }
    },
    "%in%" = {
      values <- eval_tidy(expr[[3]], data = new_failing_mask(names(data)), env = env)
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

      if (length(values) > 100) {
        cli::cli_abort("Can't translate {.code {name}} with more than 100 values.", call = call)
      }

      consts <- map(values, do_translate)
      ops <- map(consts, ~ list(lhs, .x))
      cmp <- map(ops, relexpr_function, name = "r_base::==")
      alt <- bisect_reduce(cmp, function(.x, .y) {
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
          cli::cli_abort("object not found, should also be triggered by the dplyr fallback", call = call)
        }
      }
    },
    "coalesce" = {
      if (length(expr) != 3) {
        cli::cli_abort("Can only translate {.call coalesce(x, y)} with two arguments.", call = call)
      }
    },
    "nth" = {
      n <- expr$n
      if (!is.numeric(n) || length(n) != 1L || is.na(n) || n <= 0) {
        cli::cli_abort("{.fun nth} can only be translated with a positive scalar {.arg n}", call = call)
      }
    }
  )

  aliases <- c(
    "sd" = "stddev",
    "first" = "first_value",
    "last" = "last_value",
    "nth" = "nth_value",
    "/" = "___divide",
    "log10" = "___log10",
    "log" = "___log",
    "as.integer" = "r_base::as.integer",
    "<" = "r_base::<",
    "<=" = "r_base::<=",
    ">" = "r_base::>",
    ">=" = "r_base::>=",
    "==" = "r_base::==",
    "!=" = "r_base::!=",
    "coalesce" = "___coalesce",

    NULL
  )

  known_window <- c(
    # Window functions
    "row_number",
    # Not yet implemented
    "ntile",
    "first", "last", "nth",
    # Difficult to implement
    "rank", "dense_rank", "percent_rank", "cume_dist",
    "lead", "lag",

    # Aggregates
    "sum", "min", "max", "any", "all", "mean", "sd", "median",
    "n_distinct",
    "n",
    #
    NULL
  )

  window <- need_window && (name %in% known_window)

  if (name %in% names(aliases)) {
    aliased_name <- aliases[[name]]
    if (grepl("^r_base::", aliased_name)) {
      meta_ext_register()
    }
  } else {
    aliased_name <- name
  }

  # In aggregate context (not window), use DuckDB aggregate functions
  # instead of window function aliases
  if (!window) {
    if (name == "first") aliased_name <- "first"
    else if (name == "last") aliased_name <- "last"
  }

  order_bys <- list()
  offset_expr <- NULL
  default_expr <- NULL
  nth_n <- NULL
  if (name %in% c("lag", "lead", "first", "last", "nth")) {
    # call_match() already applied above; extract special arguments
    # x, n = 1L, default = NULL, order_by = NULL

    if (name %in% c("lag", "lead")) {
      offset_expr <- relexpr_constant(expr$n %||% 1L)
      expr$n <- NULL
    }

    if (name == "nth" && !window) {
      # Extract n as integer for aggregate context (array_extract requires BIGINT)
      nth_n <- relexpr_constant(as.integer(expr$n))
      expr$n <- NULL
    }

    if (!is.null(expr$default)) {
      default_expr <- do_translate(expr$default, in_window = TRUE)
      expr$default <- NULL
    }

    if (!is.null(expr$order_by)) {
      order_by_expr <- expr$order_by
      if (is_desc(order_by_expr, env, call)) {
        order_bys <- list(relexpr_function("-", list(do_translate(order_by_expr[[2]], in_window = in_window || window))))
      } else {
        order_bys <- list(do_translate(order_by_expr, in_window = in_window || window))
      }
      expr$order_by <- NULL
    }
  }

  # Other primitives: prod, range
  # Other aggregates: var(), cum*(), quantile()
  if (name %in% c("sum", "min", "max", "any", "all", "mean", "sd", "median", "n_distinct")) {
    is_primitive <- (name %in% c("sum", "min", "max", "any", "all"))

    if (is_primitive) {
      def_primitive <- function(..., na.rm = FALSE) {}
      def <- def_primitive
      good_names <- c("", "na.rm")
      unnamed_args <- 1
    } else {
      def_regular <- function(x, ..., na.rm = FALSE) {}
      def <- def_regular
      good_names <- c("x", "na.rm")
      unnamed_args <- 0
    }

    expr <- call_match(expr, def, dots_env = env)
    args <- as.list(expr[-1])
    bad <- !(names(args) %in% good_names)
    if (sum(names2(args) == "") != unnamed_args) {
      cli::cli_abort("{.fun {name}} needs exactly one argument besides the optional {.arg na.rm}", call = call)
    }
    if (any(bad)) {
      cli::cli_abort("{.code {name}({names(args)[which(bad)[[1]]]} = )} not supported", call = call)
    }

    na_rm <- FALSE
    if (length(args) > 1) {
      na_rm <- eval(args[[2]], env)
    }

    if (window) {
      if (name == "n_distinct") {
        cli::cli_abort("{.code {name}()} not supported in window functions", call = call)
      } else {
        if (identical(na_rm, FALSE)) {
          cli::cli_abort(call = call, c(
            "{.code {name}(na.rm = FALSE)} not supported in window functions",
            i = "Use {.code {name}(na.rm = TRUE)} after checking for missing values"
          ))
        } else if (!identical(na_rm, TRUE)) {
          cli::cli_abort("Invalid value for {.arg na.rm} in call to {.fun {name}}", call = call)
        }
      }
    } else {
      if (identical(na_rm, FALSE)) {
        aliased_name <- paste0("___", name, "_na") # ___sum_na, ___min_na, ___max_na
      } else if (identical(na_rm, TRUE)) {
        if (name == "n_distinct") {
          aliased_name <- paste0("___", name)
        }
      } else {
        cli::cli_abort("Invalid value for {.arg na.rm} in call to {.fun {name}}", call = call)
      }
    }

    expr <- expr[1:2]
  }

  if (name == "n" && window) {
    aliased_name <- "count_star"
  }

  args <- map(as.list(expr[-1]), do_translate, in_window = in_window || window)

  if (name == "grepl") {
    if (!inherits(args[[1]], "relational_relexpr_constant")) {
      cli::cli_abort("Only constant patterns are supported in {.fun grepl}", call = call)
    }
  }

  # Special handling for nth() in aggregate context (not window):
  # translate to array_extract(list(x ORDER BY ...), n)
  if (name == "nth" && !window) {
    x_arg <- args[[1]]
    list_agg <- relexpr_function("list", list(x_arg), order_bys = order_bys)
    fun <- relexpr_function("array_extract", list(list_agg, nth_n))
  } else if (!window && name %in% c("first", "last") && length(order_bys) > 0) {
    # first()/last() in aggregate context: pass order_bys to aggregate function
    fun <- relexpr_function(aliased_name, args, order_bys = order_bys)
  } else {
    fun <- relexpr_function(aliased_name, args)
  }
  if (window) {
    partitions <- map(partition, relexpr_reference)
    fun <- relexpr_window(
      fun,
      partitions,
      order_bys,
      offset_expr = offset_expr,
      default_expr = default_expr
    )

    if (name == "row_number" || name == "n") {
      fun <- relexpr_function("r_base::as.integer", list(fun))
      meta_ext_register()
    }
  }
  fun
}

rel_translate <- function(
  quo,
  data,
  alias = NULL,
  partition = NULL,
  need_window = FALSE,
  names_forbidden = NULL,
  call = caller_env()
) {
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
          cli::cli_abort("Can't reuse summary variable {.var {as.character(expr)}}.", call = call)
        }
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
      language = rel_translate_lang(
        expr,
        do_translate,
        data,
        env,
        partition,
        in_window,
        need_window,
        call = call
      ),
      #
      cli::cli_abort("Internal: Unknown type {.val {typeof(expr)}}", call = call)
    )
  }

  out <- do_translate(expr, top_level = TRUE)

  if (!is.null(alias) && !identical(alias, "")) {
    out <- relexpr_set_alias(out, alias)
  }

  structure(out, used = used)
}
