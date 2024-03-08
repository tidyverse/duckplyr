telemetry <- new_environment()

tel_fallback_logging <- function() {
  val <- Sys.getenv("DUCKPLYR_FALLBACK_COLLECT")
  if (val == "") {
    return(NA)
  }
  if (!grepl("^[0-9]+$", val)) {
    return(FALSE)
  }
  as.integer(val) >= 1
}

tel_fallback_uploading <- function() {
  val <- Sys.getenv("DUCKPLYR_FALLBACK_AUTOUPLOAD")
  if (val == "") {
    return(NA)
  }
  if (!grepl("^[0-9]+$", val)) {
    return(FALSE)
  }
  as.integer(val) >= 1
}

tel_fallback_log_dir <- function() {
  if (Sys.getenv("DUCKPLYR_FALLBACK_LOG_DIR") != "") {
    return(Sys.getenv("DUCKPLYR_FALLBACK_LOG_DIR"))
  }

  cache_path <- tools::R_user_dir("duckplyr", "cache")
  telemetry_path <- file.path(cache_path, "telemetry")

  # We do not distinguish between an empty an a missing directory.
  # From that perspective, this is still a pure function.
  dir.create(telemetry_path, recursive = TRUE, showWarnings = FALSE)

  telemetry_path
}

tel_fallback_logs <- function() {
  # For mocking
  if (Sys.getenv("DUCKPLYR_TELEMETRY_FALLBACK_LOGS") != "") {
    return(strsplit(Sys.getenv("DUCKPLYR_TELEMETRY_FALLBACK_LOGS"), ",")[[1]])
  }

  telemetry_path <- tel_fallback_log_dir()
  list.files(telemetry_path, full.names = TRUE, pattern = "[.]ndjson$")
}

tel_collect <- function(cnd, call) {
  logging <- tel_fallback_logging()
  if (!isTRUE(logging) && !is.na(logging)) {
    return()
  }

  if (is.na(logging)) {
    # Deferred evaluation of call_to_json(...)
    tel_ask(call_to_json(cnd, call))
    return()
  }
}

tel_ask <- function(call_json) {
  time <- Sys.time()
  old_time <- telemetry$time
  eight_hours <- 60 * 60 * 8
  if (!is.null(old_time) && time - old_time < eight_hours) {
    return(FALSE)
  }

  fallback_nudge(call_json)
}

# ---

call_to_json <- function(cnd, call) {
  name_map <- get_name_map(c(names(call$x), names(call$y), names(call$args$dots)))
  if (!is.null(names(call$args$dots))) {
    names(call$args$dots) <- name_map[names2(call$args$dots)]
  }

  out <- list2(
    message = conditionMessage(cnd),
    name = call$name,
    x = df_to_json(call$x, name_map),
    y = df_to_json(call$y, name_map),
    args = map(compact(call$args), arg_to_json, name_map)
  )

  jsonlite::toJSON(compact(out), auto_unbox = TRUE, null = "null")
}

get_name_map <- function(x) {
  unique <- unique(x)
  new_names <- paste0("...", seq_along(unique))
  names(new_names) <- unique
  new_names
}

df_to_json <- function(df, name_map) {
  if (is.null(df)) {
    return(NULL)
  }
  if (length(df) == 0) {
    return(list())
  }

  out <- map(df, ~ paste0(class(.x), collapse = "/"))
  names(out) <- name_map[names(df)]
  out
}

arg_to_json <- function(x, name_map) {
  if (is.atomic(x)) {
    x
  } else if (is_quosures(x)) {
    quos_to_json(x, name_map)
  } else if (is_quosure(x)) {
    quo_to_json(x, name_map)
  } else if (is_call(x) || is_symbol(x)) {
    expr_to_json(x, name_map)
  } else if (inherits(x, "dplyr_join_by")) {
    list(
      condition = x$condition,
      filter = x$filter,
      x = arg_to_json(syms(x$x), name_map),
      y = arg_to_json(syms(x$y), name_map)
    )
  } else if (is.list(x)) {
    map(x, ~ arg_to_json(.x, name_map))
  } else {
    paste0("Can't translate object of class ", paste(class(x), collapse = "/"))
  }
}

quos_to_json <- function(x, name_map) {
  map(x, ~ quo_to_json(.x, name_map))
}

quo_to_json <- function(x, name_map) {
  expr_to_json(quo_get_expr(x), name_map)
}

expr_to_json <- function(x, name_map) {
  scrubbed <- expr_scrub(x, name_map)
  expr_deparse(scrubbed, width = 500L)
}

expr_scrub <- function(x, name_map) {
  do_scrub <- function(xx, callee = FALSE) {
    if (is_symbol(xx)) {
      if (callee) {
        return(xx)
      }

      match <- name_map[as.character(xx)]
      if (is.na(match)) {
        new_pos <- length(name_map) + 1
        match <- paste0("...", new_pos)
        name_map[as.character(xx)] <<- match
      }

      sym(unname(match))
    } else if (is_call(xx)) {
      args <- map(as.list(xx)[-1], do_scrub)
      call2(do_scrub(xx[[1]], callee = TRUE), !!!args)
    } else {
      paste0("Don't know how to scrub ", paste(class(xx), collapse = "/"))
    }
  }

  do_scrub(x)
}
