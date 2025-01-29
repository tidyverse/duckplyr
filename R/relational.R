#' @return A string or a condition object.
#' @noRd
rel_try <- function(call, rel, ...) {
  call_name <- as.character(sys.call(-1)[[1]])

  meta_call(gsub("[.]duckplyr_df$", "", call_name))

  # Avoid error when called via dplyr:::filter.data.frame() (in yamlet)
  if (length(call_name) == 1 && !(call_name %in% stats$calls)) {
    stats$calls <- c(stats$calls, call_name)
  }

  stats$attempts <- stats$attempts + 1L

  if (Sys.getenv("DUCKPLYR_TELEMETRY_PREP_TEST") == "TRUE") {
    force(call)
  }

  if (Sys.getenv("DUCKPLYR_TELEMETRY_TEST") == "TRUE") {
    force(call)
    json <- call_to_json(
      error_cnd(message = paste0("Error in ", call$name)),
      call
    )
    cli::cli_abort("{call$name}: {json}")
  }

  if (Sys.getenv("DUCKPLYR_FALLBACK_FORCE") == "TRUE") {
    stats$fallback <- stats$fallback + 1L
    return()
  }

  dots <- list(...)
  for (i in seq_along(dots)) {
    if (isTRUE(dots[[i]])) {
      stats$fallback <- stats$fallback + 1L
      if (!dplyr_mode) {
        message <- names(dots)[[i]]
        if (message != "-") {
          tel_collect(message, call)
        }

        if (Sys.getenv("DUCKPLYR_FALLBACK_INFO") == "TRUE") {
          inform(message = c(
            "Cannot process duckplyr query with DuckDB, falling back to dplyr.",
            i = message
          ))
        }
        if (Sys.getenv("DUCKPLYR_FORCE") == "TRUE") {
          cli::cli_abort(c(
            "Fallback not available with {.envvar DUCKPLYR_FORCE}.",
            i = message
          ))
        }
      }

      return(message)
    }
  }

  if (Sys.getenv("DUCKPLYR_FORCE") == "TRUE") {
    force(rel)
    cli::cli_abort("Internal: Must use a {.code return()} in {.code rel_try()}.")
  }

  out <- rlang::try_fetch(rel, error = identity)
  if (inherits(out, "error")) {
    tel_collect(out, call)

    if (Sys.getenv("DUCKPLYR_FALLBACK_INFO") == "TRUE") {
      rlang::cnd_signal(rlang::message_cnd(message = "Error processing duckplyr query with DuckDB, falling back to dplyr.", parent = out))
    }
    stats$fallback <- stats$fallback + 1L
    return(out)
  }

  # Never reached due to return() in code
  cli::cli_abort("Must use a return() in rel_try().")
}

rel_translate_dots <- function(dots, data) {
  if (is.null(names(dots))) {
    map(dots, rel_translate, data)
  } else {
    imap(dots, rel_translate, data = data)
  }
}

# Currently does not support referring to names created during the `summarise()` call.
# Also has specific support for `across()`.
rel_translate_dots_summarise <- function(dots, data) {
  stopifnot(
    !is.null(names(dots))
  )

  out <- reduce(seq_along(dots), .init = NULL, function(.x, .y) {
    current_names <- c(names(data), .x$new)

    dot <- dots[[.y]]
    expanded <- duckplyr_expand_across(current_names, dot)

    if (is.null(expanded)) {
      new <- names(dots)[[.y]]
      translation <- list(rel_translate(dots[[.y]], alias = new, data, names_forbidden = .x$new))
    } else {
      new <- names(expanded)
      translation <- imap(expanded, function(expr, name) rel_translate(expr, alias = name, data, names_forbidden = .x$new))
    }

    list(
      new = c(.x$new, new),
      translation = c(.x$translation, translation)
    )
  })
  out$translation
}

new_failing_mask <- function(names_data) {
  env <- new_environment()
  walk(names_data, ~ env_bind_lazy(env, !!.x := stop("Can't access data in this context")))
  new_data_mask(env)
}

#' @param duckplyr_error Return value from rel_try()
#' @noRd
check_inertia <- function(x, duckplyr_error, call = caller_env()) {
  msg <- tryCatch(nrow(x), error = conditionMessage)
  if (is.character(msg)) {
    duckplyr_error_msg <- if (is.character(duckplyr_error)) duckplyr_error
    duckplyr_error_parent <- if (is_condition(duckplyr_error)) duckplyr_error
    cli::cli_abort(parent = duckplyr_error_parent, call = call, c(
      "This operation cannot be carried out by DuckDB, and the input is an inert duckplyr frame.",
      "*" = duckplyr_error_msg,
      "i" = 'Use {.code compute(inert = "never")} to materialize to temporary storage and continue with {.pkg duckplyr}.',
      "i" = 'See {.run vignette("inert")} for other options.'
    ))
  }
}
