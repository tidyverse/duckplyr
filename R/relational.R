rel_try <- function(rel, ..., call = NULL) {
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

  # https://github.com/duckdb/duckdb-r/issues/101
  max_expression_depth <- DBI::dbGetQuery(get_default_duckdb_connection(), "SELECT current_setting('max_expression_depth')")[[1]]
  if (max_expression_depth != 100) {
    # Only reset if this hasn't been set already
    # NeuroDecodeR, delayed evaluation
    DBI::dbExecute(get_default_duckdb_connection(), "SET max_expression_depth TO 100")
    withr::defer({
      DBI::dbExecute(get_default_duckdb_connection(), "SET max_expression_depth TO 200")
    })
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

new_failing_mask <- function(names_data) {
  env <- new_environment()
  walk(names_data, ~ env_bind_lazy(env, !!.x := stop("Can't access data in this context")))
  new_data_mask(env)
}
