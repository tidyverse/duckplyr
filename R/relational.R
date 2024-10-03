rel_try <- function(call, rel, ...) {
  call_name <- as.character(sys.call(-1)[[1]])

  if (!is.null(call$name)) {
    meta_call_start(call$name)
    withr::defer(meta_call_end())
  }

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
          inform(message = c("Requested fallback for relational:", i = message))
        }
        if (Sys.getenv("DUCKPLYR_FORCE") == "TRUE") {
          cli::cli_abort("Fallback not available with {.envvar DUCKPLYR_FORCE}.")
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
    tel_collect(out, call)

    # FIXME: enable always
    if (Sys.getenv("DUCKPLYR_FALLBACK_INFO") == "TRUE") {
      rlang::cnd_signal(rlang::message_cnd(message = "Error processing with relational.", parent = out))
    }
    stats$fallback <- stats$fallback + 1L
    return()
  }

  # Never reached due to return() in code
  cli::cli_abort("Must use a return() in rel_try().")
}

rel_translate_dots <- function(dots, data, forbid_new = FALSE) {
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
