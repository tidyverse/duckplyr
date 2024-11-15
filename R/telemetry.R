telemetry <- new_environment()

try_list <- function(...) {
  out <- vector("list", length = ...length())
  for (i in seq_len(...length())) {
    # Single-bracket assignment for the handling of NULLs
    out[i] <- list(tryCatch(
      ...elt(i),
      error = function(e) {
        paste0("<Error: ", conditionMessage(e), ">")
      }
    ))
  }
  names(out) <- ...names()
  out
}

on_load({
  # ...names() needs R 4.1:
  if (getRversion() < "4.1") {
    env <- environment()
    assign("try_list", list, env)
  }
})

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

tel_fallback_verbose <- function() {
  val <- Sys.getenv("DUCKPLYR_FALLBACK_VERBOSE")
  val == "TRUE"
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
  if (nzchar(Sys.getenv("DUCKPLYR_FALLBACK_LOG_DIR"))) {
    return(Sys.getenv("DUCKPLYR_FALLBACK_LOG_DIR"))
  }

  cache_path <- tools::R_user_dir("duckplyr", "cache")
  telemetry_path <- file.path(cache_path, "telemetry")

  # We do not distinguish between an empty an a missing directory.
  # From that perspective, this is still a pure function.
  dir.create(telemetry_path, recursive = TRUE, showWarnings = FALSE)

  telemetry_path
}

tel_fallback_logs <- function(oldest = NULL, newest = NULL, detail = FALSE, envir = parent.frame()) {
  if (!is.null(oldest) && !is.null(newest)) {
    cli::cli_abort("Specify either {.arg oldest} or {.arg newest}, not both.", .envir = envir)
  }

  # For mocking
  if (nzchar(Sys.getenv("DUCKPLYR_TELEMETRY_FALLBACK_LOGS"))) {
    return(strsplit(Sys.getenv("DUCKPLYR_TELEMETRY_FALLBACK_LOGS"), ",")[[1]])
  }

  telemetry_path <- tel_fallback_log_dir()
  fallback_logs <- list.files(telemetry_path, full.names = TRUE, pattern = "[.]ndjson$")

  info <- file.info(fallback_logs)
  info <- info[order(info$mtime), ]

  review <- rownames(info)
  if (!is.null(oldest)) {
    review <- utils::head(review, oldest)
  } else if (!is.null(newest)) {
    review <- utils::tail(review, newest)
  }

  if (isTRUE(detail)) {
    contents <- map_chr(review, ~ paste0(readLines(.x), "\n", collapse = ""))
  } else {
    contents <- rep_along(review, NA_character_)
  }

  set_names(contents, review)
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

  tel_record(call_to_json(cnd, call))
}

tel_ask <- function(call_json) {
  time <- Sys.time()
  old_time <- telemetry$time
  eight_hours <- 60 * 60 * 8
  if (!is.null(old_time) && time - old_time < eight_hours) {
    return()
  }

  telemetry$time <- time

  fallback_nudge(call_json)
}

tel_record <- function(call_json) {
  telemetry_path <- tel_fallback_log_dir()
  telemetry_file <- file.path(telemetry_path, paste0(Sys.getpid(), ".ndjson"))

  cat(call_json, "\n", sep = "", file = telemetry_file, append = TRUE)

  if (tel_fallback_verbose()) {
    cli::cli_inform(c(
      "i" = "dplyr fallback recorded",
      " " = "{call_json}"
    ))
  }
}

tel_post_async <- function(content, done = NULL, fail = NULL, pool = NULL) {
  url <- "https://duckplyr-telemetry.duckdblabs.com/"

  # Create a new curl handle
  handle <- curl::new_handle()
  curl::handle_setopt(handle, customrequest = "POST")
  curl::handle_setheaders(handle, "Content-Type" = "text/plain")
  curl::handle_setopt(handle, postfields = content)
  curl::curl_fetch_multi(
    url,
    done = done,
    fail = fail,
    pool = pool,
    handle = handle
  )
}

# ---

call_to_json <- function(cnd, call) {
  name_map <- get_name_map(c(names(call$x), names(call$y), names(call$args$dots)))
  if (!is.null(names(call$args$dots))) {
    names(call$args$dots) <- name_map[names2(call$args$dots)]
  }

  if (identical(Sys.getenv("TESTTHAT"), "true")) {
    log_version <- "0.3.1"
  } else {
    version <- getNamespaceInfo("duckplyr", "spec")["version"]
    semantic <- strsplit(version, ".", fixed = TRUE)[[1]][1:3]
    log_version <- paste0(semantic, collapse = ".")
  }

  out <- list2(
    version = log_version,
    message = cnd_to_json(cnd, name_map),
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

cnd_to_json <- function(cnd, name_map) {
  if (is_condition(cnd)) {
    # If conditionMessage() is called at the call site,
    # the error message changes
    msg <- cli::ansi_strip(conditionMessage(cnd))
  } else if (is.character(cnd)) {
    msg <- cnd
  } else {
    msg <- paste0("Unknown message of class ", paste(class(cnd), collapse = "/"))
  }

  search <- paste0("`", names(name_map), "`")
  replace <- paste0("`", name_map, "`")

  for (i in seq_along(search)) {
    msg <- gsub(search[[i]], replace[[i]], msg, fixed = TRUE)
  }
  msg
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

expr_scrub <- function(x, name_map = character()) {
  do_scrub <- function(xx, callee = FALSE) {
    if (is.character(xx)) {
      return("<character>")
    } else if (is.factor(xx)) {
      return("<factor>")
    } else if (is.null(xx)) {
      # Needed for R 4.4
      return(xx)
    } else if (is.atomic(xx)) {
      return(xx)
    } else if (is_missing(xx)) {
      # Arguments without default values are empty
      return(xx)
    } else if (is_symbol(xx)) {
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
    } else if (is_pairlist(xx)) {
      as.pairlist(map(as.list(xx), do_scrub))
    } else {
      paste0("Don't know how to scrub ", paste(class(xx), collapse = "/"))
    }
  }

  do_scrub(x)
}
