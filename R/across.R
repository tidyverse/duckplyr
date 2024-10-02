# Works expr by expr?
#   duckplyr might not even call us for the next expression

# Takes current state of the data (only names)
# Returns named expressions
#   We'll have to deal with inlining of lambdas?
#   Or just support bare symbols for now?
#   Nope because `...` is deprecated... Need lambdas
#   Only support lambdas?

# .fns: mutate()

fn <- function(duck, ...) {
  mutate(duck, across(...))
}

# Argument matching, dots expansion

# mutate.duck captures a `quo(across(everything(), \(x) mean(x, na.rm = TRUE)))`
# mutate.duck captures a `quo(across(...))`
# mutate.duck captures a `quo(across(...))` with `name = foo` (packed case)

expand_across <- function(data, quo) {
  stopifnot(is.character(data))

  quo_data <- attr(quo, "dplyr:::data")
  if (!quo_is_call(quo, "across", ns = c("", "dplyr")) || quo_data$is_named) {
    return(list(quo))
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
    return(list(quo))
  }

  # FIXME: Needed? Can we get away with the names
  # dplyr_mask <- peek_mask()
  # mask <- dplyr_mask$get_rlang_mask()

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
    return(list(quo))
  }

  # Differentiate between missing and null (`match.call()` doesn't
  # expand default argument)
  if (".cols" %in% names(expr)) {
    cols <- expr$.cols
  } else {
    # This is deprecated, let dplyr warn
    return(list(quo))
  }
  cols <- as_quosure(cols, env)

  if (".fns" %in% names(expr)) {
    fns <- as_quosure(expr$.fns, env)
  } else {
    # To be deprecated, let dplyr deal with this
    return(list(quo))
  }

  # TODO: inline lambdas, check for NULL

  setup <- across_setup(
    !!cols,
    fns = fns,
    names = eval_tidy(expr$.names, mask, env = env),
    .caller_env = env,
    mask = dplyr_mask,
    error_call = error_call,
    across_if_fn = across_if_fn
  )

  vars <- setup$vars

  # Empty expansion
  if (length(vars) == 0L) {
    return(list())
  }

  fns <- setup$fns
  names <- setup$names %||% vars

  # No functions, so just return a list of symbols
  if (is.null(fns)) {
    # TODO: Deprecate and remove the `.fns = NULL` path in favor of `pick()`
    exprs <- pmap(list(vars, names, seq_along(vars)), function(var, name, k) {
      quo <- new_quosure(sym(var), empty_env())
      quo <- new_dplyr_quosure(
        quo,
        name = name,
        is_named = TRUE,
        index = c(quo_data$index, k),
        column = var
      )
    })
    names(exprs) <- names
    return(exprs)
  }

  n_vars <- length(vars)
  n_fns <- length(fns)

  seq_vars <- seq_len(n_vars)
  seq_fns  <- seq_len(n_fns)

  exprs <- new_list(n_vars * n_fns, names = names)

  k <- 1L
  for (i in seq_vars) {
    var <- vars[[i]]

    for (j in seq_fns) {
      fn_call <- as_across_fn_call(fns[[j]], var, env, mask)

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

across_setup <- function(data,
                         cols,
                         fns,
                         names,
                         .caller_env,
                         mask,
                         error_call = caller_env(),
                         across_if_fn = "across") {
  stopifnot(
    is.list(fns),
    length(fns) != 1
  )

  cols <- enquo(cols)
  data <- set_names(seq_along(data), data)

  vars <- tidyselect::eval_select(
    cols,
    data = data,
    allow_predicates = FALSE,
    error_call = error_call
  )
  names_vars <- names(vars)
  vars <- names(data)[vars]

  glue_mask <- across_glue_mask(.caller_env,
    .col = names_vars,
    .fn  = rep("1", length(vars))
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
