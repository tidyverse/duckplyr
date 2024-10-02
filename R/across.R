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
    fns <- quo_eval_fns(fns, mask = env, error_call = error_call)
  } else {
    # To be deprecated, let dplyr deal with this
    return(list(quo))
  }

  # duckplyr doesn't currently support >1 function so we bail if we
  # see that potential case, but to potentially allow for this in the future we
  # manually wrap in a list using the default name of `"1"`.
  if (!is.function(fns)) {
    return(list(quo))
  }
  fns <- list("1" = fns)

  # In dplyr this evaluates in the mask to reproduce the `mutate()` or
  # `summarise()` context. We don't have a mask here but it's probably fine in
  # almost all cases.
  names <- eval_tidy(expr$.names, env = env)
  names <- names %||% "{.col}"

  setup <- across_setup(
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
    return(list())
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
      # `mask` isn't actually used inside this
      fn_call <- as_across_fn_call(fns[[j]], var, env, mask = env)

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
                         error_call = caller_env()) {
  stopifnot(
    is.list(fns),
    length(fns) == 1
  )

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

  glue_mask <- across_glue_mask(
    .col = names_vars,
    .fn = names_fns,
    .caller_env = .caller_env
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
