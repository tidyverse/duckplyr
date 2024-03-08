telemetry <- new_environment()

tel_upload_error <- function(cnd, call) {
  telemetry_env <- Sys.getenv("DUCKPLYR_FALLBACK_COLLECT")
  if (telemetry_env != "" && telemetry_env != "TRUE") {
    return()
  }

  call_json <- call_to_json(cnd, call)

  if (telemetry_env == "") {
    if (!tel_ask(call_json)) {
      return()
    }
  }

  tel_post_async(call_json)
}

tel_ask <- function() {
  time <- Sys.time()
  old_time <- telemetry$time
  eight_hours <- 60 * 60 * 8
  if (!is.null(old_time) && time - old_time < eight_hours) {
    return(FALSE)
  }

  cache_path <- tools::R_user_dir("duckplyr", "cache")
  telemetry_path <- file.path(cache_path, "telemetry")
  dir.create(telemetry_path, recursive = TRUE, showWarnings = FALSE)

  cli::cli_inform(c(
    "{.pkg duckplyr} was unable to process a query, a fallback to {.pkg dplyr} has been triggered. Would you like to help us improve the package by collecting anonymized queries that {.pkg duckplyr} failed to process?",
    "i" = "Set the {.envvar DUCKPLYR_FALLBACK_COLLECT} environment variable, e.g., in your {.file ~/.Renviron}, to silence this message.",
    "v" = "If {.envvar DUCKPLYR_FALLBACK_COLLECT} is set to an integer of {.val 1} or greater, {.pkg duckplyr} will collect anonymized details of all queries for which fallback is triggered. See {.help duckplyr::fallback} for more information.",
    "x" = "Any other value, e.g., {.val 0}, disables the data collection.",
    # "*" = "The name of the attempted operation",
    # "*" = "The structure of the input data (but not the column names or any values)",
    # "*" = "The arguments passed to the operation, with column names replaced with the names in the dummy data",
    # "i" = "The files can be reviewed at any time and uploaded manually with {.code duckplyr::fallback_upload()}.",
    # "i" = "Automatic uploads are attempted on package load if the {.envvar DUCKPLYR_FALLBACK_AUTOUPLOAD} environment variable is set to an integer value of {.val 1} or greater.",
    "i" = cli::col_silver("This message will be displayed once every eight hours.")
  ))

  FALSE
}

tel_post_async_fail <- function(message) {
  if (!isTRUE(telemetry$error)) {
    telemetry$error <- TRUE
    message("Error uploading telemetry, avoiding further uploads: ", message)
  }
}

tel_post_async <- function(json_data) {
  pool <- tel_pool()

  url <- "https://duckplyr-telemetry.duckdblabs.com/"

  # Create a new curl handle
  handle <- curl::new_handle()
  curl::handle_setopt(handle, customrequest = "POST")
  curl::handle_setheaders(handle, "Content-Type" = "text/plain")
  curl::handle_setopt(handle, postfields = json_data)
  curl::curl_fetch_multi(
    url,
    done = function(...) { message("Upload successful") },
    fail = tel_post_async_fail,
    pool = pool,
    handle = handle
  )

  tel_loop_start(pool)
}

tel_pool <- function() {
  pool <- telemetry$pool
  if (is.null(pool)) {
    pool <- curl::new_pool()
    telemetry$pool <- pool
  }

  pool
}

tel_loop_start <- function(pool) {
  loop <- telemetry$loop
  if (is.null(loop)) {
    loop <- later::create_loop(parent = later::global_loop())
    telemetry$loop <- loop
    reg.finalizer(telemetry, tel_finalize, onexit = TRUE)
  }

  if (!later::loop_empty(loop)) {
    return()
  }

  later::later(
    function() { curl::multi_run(timeout = 2, pool = pool) },
    loop = loop
  )
}

tel_finalize <- function(e) {
  loop <- telemetry$loop
  if (!is.null(loop)) {
    later::run_now(loop = loop)
  }
}

call_to_json <- function(cnd, call) {
  out <- list2(
    message = conditionMessage(cnd),
    name = call$name,
    x = df_to_json(call$x),
    y = df_to_json(call$y, names(call$x)),
    args = map(compact(call$args), arg_to_json, unique(c(names(call$x), names(call$y))))
  )

  jsonlite::toJSON(compact(out), auto_unbox = TRUE, null = "null")
}

df_to_json <- function(df, known_names = NULL) {
  if (is.null(df)) {
    return(NULL)
  }
  if (length(df) == 0) {
    return(list())
  }
  new_names <- paste0("...", seq_along(df))
  known <- match(names(df), known_names)
  new_names[!is.na(known)] <- known_names[known[!is.na(known)]]

  out <- map(df, ~ paste0(class(.x), collapse = "/"))
  names(out) <- new_names
  out
}

arg_to_json <- function(x, known_names) {
  if (is.atomic(x)) {
    x
  } else if (is_quosures(x)) {
    quos_to_json(x, known_names)
  } else if (is_quosure(x)) {
    quo_to_json(x, known_names)
  } else if (is_call(x)) {
    expr_to_json(x, known_names)
  } else {
    paste0("Can't translate object of class ", paste(class(x), collapse = "/"))
  }
}

quos_to_json <- function(x, known_names) {
  map(x, ~ quo_to_json(.x, known_names))
}

quo_to_json <- function(x, known_names) {
  expr_to_json(quo_get_expr(x), known_names)
}

expr_to_json <- function(x, known_names) {
  scrubbed <- expr_scrub(x, known_names)
  expr_deparse(scrubbed, width = 500L)
}

expr_scrub <- function(x, known_names) {
  do_scrub <- function(xx) {
    if (is_call(xx)) {
      args <- map(as.list(xx)[-1], do_scrub)
      call2(xx[[1]], !!!args)
    } else if (is_symbol(xx)) {
      match <- match(as.character(xx), known_names)
      if (is.na(match)) {
        xx
      } else {
        sym(paste0("...", match))
      }
    } else {
      paste0("Don't know how to scrub ", paste(class(xx), collapse = "/"))
    }
  }

  do_scrub(x)
}
