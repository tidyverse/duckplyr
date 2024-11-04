# A simplified version of functions in dplyr's across.R

duckplyr_expand_across <- function(data, quo) {
  stopifnot(is.character(data))

  quo_data <- attr(quo, "dplyr:::data")
  if (!quo_is_call(quo, "across", ns = c("", "dplyr")) || quo_data$is_named) {
    return(NULL)
  }

  # Expand dots in lexical env
  env <- quo_get_env(quo)
  expr <- match.call(
    definition = dplyr::across,
    call = quo_get_expr(quo),
    expand.dots = FALSE,
    envir = env
  )

  # Abort expansion if there are any expression supplied because dots
  # must be evaluated once per group in the data mask. Expanding the
  # `across()` call would lead to either `n_group * n_col` evaluations
  # if dots are delayed or only 1 evaluation if they are eagerly
  # evaluated.
  if (!is_null(expr$...)) {
    return(NULL)
  }

  if (".unpack" %in% names(expr)) {
    # In dplyr this evaluates in the mask to reproduce the `mutate()` or
    # `summarise()` context. We don't have a mask here but it's probably fine in
    # almost all cases.
    unpack <- eval_tidy(expr$.unpack, env = env)
  } else {
    unpack <- FALSE
  }

  # Abort expansion if unpacking as expansion makes named expressions and we
  # need the expressions to remain unnamed
  if (!is_false(unpack)) {
    return(NULL)
  }

  # Differentiate between missing and null (`match.call()` doesn't
  # expand default argument)
  if (!(".cols" %in% names(expr))) {
    # This is deprecated, let dplyr warn
    return(NULL)
  }

  if (!(".fns" %in% names(expr))) {
    # To be deprecated, let dplyr deal with this
    return(NULL)
  }

  cols <- as_quosure(expr$.cols, env)

  fns <- as_quosure(expr$.fns, env)
  fns <- quo_eval_fns(fns, mask = env, error_call = error_call)

  # In dplyr this evaluates in the mask to reproduce the `mutate()` or
  # `summarise()` context. We don't have a mask here but it's probably fine in
  # almost all cases.
  names <- eval_tidy(expr$.names, env = env)

  setup <- duckplyr_across_setup(
    data,
    cols,
    fns = fns,
    names = names,
    .caller_env = env,
    error_call = error_call
  )

  vars <- setup$vars

  # Empty expansion
  if (length(vars) == 0L) {
    return(NULL)
  }

  fns <- setup$fns
  names <- setup$names %||% vars

  n_vars <- length(vars)
  n_fns <- length(fns)

  seq_vars <- seq_len(n_vars)
  seq_fns  <- seq_len(n_fns)

  exprs <- new_list(n_vars * n_fns, names = names)

  k <- 1L
  for (i in seq_vars) {
    var <- vars[[i]]

    for (j in seq_fns) {
      fn_expr <- fn_to_expr(fns[[j]], env)
      # Note: `mask` isn't actually used inside this helper
      fn_call <- as_across_fn_call(fn_expr, var, env, mask = env)

      # We can't translate spliced functions:
      if (is.function(quo_get_expr(fn_call)[[1]])) {
        return(NULL)
      }

      name <- names[[k]]

      exprs[[k]] <- new_dplyr_quosure(
        fn_call,
        name = name,
        is_named = TRUE,
        index = c(quo_data$index, k),
        column = var
      )

      k <- k + 1L
    }
  }

  exprs
}

duckplyr_across_setup <- function(data,
                                  cols,
                                  fns,
                                  names,
                                  .caller_env,
                                  error_call = caller_env()) {
  data <- set_names(seq_along(data), data)

  vars <- tidyselect::eval_select(
    cols,
    data = data,
    allow_predicates = FALSE,
    error_call = error_call
  )
  names_vars <- names(vars)
  vars <- names(data)[vars]

  names_fns <- names(fns)

  # apply `.names` smart default
  if (is.function(fns)) {
    names <- names %||% "{.col}"
    fns <- list("1" = fns)
  } else {
    names <- names %||% "{.col}_{.fn}"
  }

  if (!is.list(fns)) {
    abort("Expected a list.", .internal = TRUE)
  }

  # make sure fns has names, use number to replace unnamed
  if (is.null(names(fns))) {
    names_fns <- seq_along(fns)
  } else {
    names_fns <- names(fns)
    empties <- which(names_fns == "")
    if (length(empties)) {
      names_fns[empties] <- empties
    }
  }

  glue_mask <- across_glue_mask(.caller_env,
    .col = rep(names_vars, each = length(fns)),
    .fn  = rep(names_fns , length(vars))
  )
  names <- vec_as_names(
    glue(names, .envir = glue_mask),
    repair = "check_unique",
    call = error_call
  )

  list(
    vars = vars,
    fns = fns,
    names = names
  )
}

fn_to_expr <- function(fn, env) {
  fn_env <- environment(fn)
  if (!is_namespace(fn_env)) {
    return(fn)
  }

  # This is an environment that maps hashes to function names
  ns_exports_lookup <- get_ns_exports_lookup(fn_env)

  # Can we find the function among the exports in the namespace?
  fun_name <- ns_exports_lookup[[hash(fn)]]
  if (is.null(fun_name)) {
    return(fn)
  }

  # Triple-check: Does the expression actually evaluate to fn?
  ns_name <- getNamespaceName(fn_env)
  out <- call2("::", sym(ns_name), sym(fun_name))
  if (!identical(eval(out, env), fn)) {
    return(fn)
  }

  out
}

# Memoize get_ns_exports_lookup() to avoid recomputing the hash of
# every function in every namespace every time
on_load({
  get_ns_exports_lookup <<- memoise::memoise(get_ns_exports_lookup)
})

get_ns_exports_lookup <- function(ns) {
  names <- getNamespaceExports(ns)
  objs <- mget(names, ns)
  funs <- objs[map_lgl(objs, is.function)]

  hashes <- map_chr(funs, hash)
  # Reverse, return as environment
  new_environment(set_names(as.list(names(hashes)), hashes))
}

test_duckplyr_expand_across <- function(data, expr) {
  quo <- new_dplyr_quosure(enquo(expr), is_named = FALSE, index = 1L)
  out <- duckplyr_expand_across(data, quo)
  if (is.null(out)) {
    return(NULL)
  }
  call2(rlang::expr(tibble), !!!map(out, quo_get_expr))
}
