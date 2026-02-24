#' Fallback to dplyr
#'
#' @description
#' The \pkg{duckplyr} package aims at providing
#' a fully compatible drop-in replacement for \pkg{dplyr}.
#' To achieve this, only a carefully selected subset of \pkg{dplyr}'s operations,
#' R functions, and R data types are implemented.
#' Whenever a request cannot be handled by DuckDB,
#' \pkg{duckplyr} falls back to \pkg{dplyr}.
#' See `vignette("fallback"`)` for details.
#'
#' To assist future development, the fallback situations can be logged
#' to the console or to a local file and uploaded for analysis.
#' By default, \pkg{duckplyr} will not log or upload anything.
#' The functions and environment variables on this page control the process.
#'
#' @details
#' Logging is on by default, but can be turned off.
#' Uploading is opt-in.
#'
#' The following environment variables control the logging and uploading:
#'
#' - `DUCKPLYR_FALLBACK_INFO` controls human-friendly alerts
#'   for fallback events.
#'   If `TRUE`, a message is printed when a fallback to dplyr occurs
#'   because DuckDB cannot handle a request.
#'   These messages are never logged.
#'
#' - `DUCKPLYR_FALLBACK_COLLECT` controls logging, set it
#'   to 1 or greater to enable logging.
#'   If the value is 0, logging is disabled.
#'   Future versions of \pkg{duckplyr} may start logging additional data
#'   and thus require a higher value to enable logging.
#'   Set to 99 to enable logging for all future versions.
#'   Use [usethis::edit_r_environ()] to edit the environment file.
#'
#' - `DUCKPLYR_FALLBACK_AUTOUPLOAD` controls uploading, set it
#'   to 1 or greater to enable uploading.
#'   If the value is 0, uploading is disabled.
#'   Currently, uploading is active if the value is 1 or greater.
#'   Future versions of \pkg{duckplyr} may start logging additional data
#'   and thus require a higher value to enable uploading.
#'   Set to 99 to enable uploading for all future versions.
#'   Use [usethis::edit_r_environ()] to edit the environment file.
#'
#' - `DUCKPLYR_FALLBACK_LOG_DIR` controls the location of the logs.
#'   It must point to a directory (existing or not) where the logs will be written.
#'   By default, logs are written to a directory in the user's cache directory
#'   as returned by `tools::R_user_dir("duckplyr", "cache")`.
#'
#' - `DUCKPLYR_FALLBACK_VERBOSE` controls printing of log data, set it
#'   to `TRUE` or `FALSE` to enable or disable printing.
#'   If the value is `TRUE`, a message is printed to the console
#'   for each fallback situation.
#'   This setting is only relevant if logging is enabled,
#'   and mostly useful for \pkg{duckplyr}'s internal tests.
#'
#' All code related to fallback logging and uploading is in the
#' [`fallback.R`](https://github.com/tidyverse/duckplyr/blob/main/R/fallback.R) and
#' [`telemetry.R`](https://github.com/tidyverse/duckplyr/blob/main/R/telemetry.R) files.
#'
#' @name fallback
#' @examples
#' fallback_sitrep()
NULL

#' fallback_sitrep
#'
#' `fallback_sitrep()` prints the current settings for fallback printing, logging,
#' and uploading, the number of reports ready for upload, and the location of the logs.
#' @rdname fallback
#' @export
fallback_sitrep <- function() {
  fallback_logging <- tel_fallback_logging()
  fallback_info <- (Sys.getenv("DUCKPLYR_FALLBACK_INFO") == TRUE)
  fallback_autoupload <- tel_fallback_autoupload()
  fallback_log_dir <- tel_fallback_log_dir()
  fallback_logs <- tel_fallback_logs()

  msg <- c(
    fallback_txt_header(),
    #
    if (fallback_info) {
      c("v" = "Fallback printing is enabled.")
    } else {
      c("x" = "Fallback printing is disabled.")
    },
    if (isTRUE(fallback_logging)) {
      c(
        "v" = "Fallback logging is enabled.",
        if (is.null(attr(fallback_logging, "val"))) {
          c(
            "i" = "Fallback logging is not controlled, see {.help duckplyr::fallback}."
          )
        },
        "i" = "Logs are written to {.file {fallback_log_dir}}."
      )
    } else {
      c("x" = "Fallback logging is disabled.")
    },
    #
    fallback_txt_autoupload(fallback_autoupload),
    #
    if (isTRUE(fallback_logging)) {
      fallback_txt_sitrep_logs(fallback_logs)
    },
    #
    fallback_txt_help(),
    #
    NULL
  )

  cli::cli_inform(msg)
}

fallback_txt_header <- function() {
  "The {.pkg duckplyr} package is configured to fall back to {.pkg dplyr} when it encounters an incompatibility. Fallback events can be collected and uploaded for analysis to guide future development. By default, data will be collected but no data will be uploaded."
}

fallback_txt_autoupload <- function(fallback_autoupload) {
  if (is.na(fallback_autoupload)) {
    c(
      "i" = "Automatic fallback uploading is not controlled and therefore disabled, see {.help duckplyr::fallback}."
    )
  } else if (fallback_autoupload) {
    c("v" = "Automatic fallback uploading is enabled.")
  } else {
    c("x" = "Automatic fallback uploading is disabled.")
  }
}

fallback_txt_sitrep_logs <- function(fallback_logs) {
  if (length(fallback_logs) > 0) {
    c(
      "v" = "Number of reports ready for upload: {.strong {length(fallback_logs)}}.",
      ">" = "Review with {.run duckplyr::fallback_review()}, upload with {.run duckplyr::fallback_upload()}."
    )
  } else {
    c("i" = "No reports ready for upload.")
  }
}

fallback_txt_run_sitrep <- function() {
  c(
    ">" = "Run {.run duckplyr::fallback_sitrep()} to review the current settings."
  )
}

fallback_txt_help <- function() {
  c(
    "i" = "See {.help duckplyr::fallback_config} for details."
  )
}

#' fallback_config
#'
#' `fallback_config()` configures the current settings for fallback printing,
#' logging, and uploading.
#' Only settings that do not affect computation results can be configured,
#' this is by design.
#' The configuration is stored in a file under `tools::R_user_dir("duckplyr", "config")` .
#' When the \pkg{duckplyr} package is loaded, the configuration is read from this file,
#' and the corresponding environment variables are set.
#'
#' @inheritParams rlang::args_dots_empty
#' @param reset_all Set to `TRUE` to reset all settings to their defaults.
#'   The R session must be restarted for the changes to take effect.
#' @param info Set to `TRUE` to enable fallback printing.
#' @param logging Set to `FALSE` to disable fallback logging,
#'   set to `TRUE` to explicitly enable it.
#' @param autoupload Set to `TRUE` to enable automatic fallback uploading,
#'   set to `FALSE` to disable it.
#' @param log_dir Set the location of the logs in the file system.
#'   The directory will be created if it does not exist.
#' @param verbose Set to `TRUE` to enable verbose logging.
#' @rdname fallback
#' @export
fallback_config <- function(
  ...,
  reset_all = FALSE,
  info = NULL,
  logging = NULL,
  autoupload = NULL,
  log_dir = NULL,
  verbose = NULL
) {
  check_dots_empty()

  if (isTRUE(reset_all)) {
    config <- list()
  } else {
    config <- fallback_config_read()
  }

  if (!is.null(logging)) {
    if (isTRUE(logging)) {
      logging <- 1
    } else {
      logging <- 0
    }
  }

  if (!is.null(autoupload)) {
    if (isTRUE(autoupload)) {
      autoupload <- 1
    } else {
      autoupload <- 0
    }
  }

  config <- fallback_config_set(config, info, "info")
  config <- fallback_config_set(config, logging, "logging")
  config <- fallback_config_set(config, autoupload, "autoupload")
  config <- fallback_config_set(config, log_dir, "log_dir")
  config <- fallback_config_set(config, verbose, "verbose")

  fallback_config_write(config)
  fallback_config_apply(config)

  if (isTRUE(reset_all)) {
    cli::cli_alert_info(
      "Restart the R session to reset all values to their defaults."
    )
  }
}

fallback_config_read <- function() {
  config_file <- fallback_config_path()

  if (!file.exists(config_file)) {
    return(list())
  }

  tryCatch(
    {
      as.list(read.dcf(config_file, all = TRUE))
    },
    error = function(e) {
      rlang::cnd_signal(rlang::message_cnd(
        message = "Error reading duckplyr, fallback configuration, deleting file.",
        parent = e
      ))
      unlink(config_file)
      list()
    }
  )
}

fallback_config_write <- function(config) {
  config_path <- fallback_config_path()

  if (length(config) == 0) {
    unlink(config_path, force = TRUE)
  } else {
    write.dcf(config, config_path)
  }
}

fallback_config_set <- function(config, value, name) {
  if (!is.null(value)) {
    config[[name]] <- value
  }
  config
}

fallback_config_apply <- function(config) {
  if (!is.null(config$info)) {
    Sys.setenv(DUCKPLYR_FALLBACK_INFO = config$info)
  }
  if (!is.null(config$logging)) {
    Sys.setenv(DUCKPLYR_FALLBACK_LOGGING = config$logging)
  }
  if (!is.null(config$autoupload)) {
    Sys.setenv(DUCKPLYR_FALLBACK_AUTOUPLOAD = config$autoupload)
  }
  if (!is.null(config$log_dir)) {
    Sys.setenv(DUCKPLYR_FALLBACK_LOG_DIR = config$log_dir)
  }
  if (!is.null(config$verbose)) {
    Sys.setenv(DUCKPLYR_FALLBACK_VERBOSE = config$verbose)
  }
}

on_load({
  fallback_config_load()
})

fallback_config_load <- function() {
  config <- fallback_config_read()
  orig_config <- config

  config <- fallback_config_reset(config, "info", "DUCKPLYR_FALLBACK_INFO")
  config <- fallback_config_reset(
    config,
    "logging",
    "DUCKPLYR_FALLBACK_LOGGING"
  )
  config <- fallback_config_reset(
    config,
    "autoupload",
    "DUCKPLYR_FALLBACK_AUTOUPLOAD"
  )
  config <- fallback_config_reset(
    config,
    "log_dir",
    "DUCKPLYR_FALLBACK_LOG_DIR"
  )
  config <- fallback_config_reset(
    config,
    "verbose",
    "DUCKPLYR_FALLBACK_VERBOSE"
  )

  msg <- setdiff(names(orig_config), names(config))
  if (length(msg) > 0) {
    msg <- set_names(paste0("{.envvar ", msg, "}"), rep_along(msg, "*"))
    packageStartupMessage(cli::format_message(c(
      "Some configuration values are set as environment variables and in the configuration file {.file {fallback_config_path()}}:",
      msg,
      i = "Use {.run duckplyr::fallback_config(reset_all = TRUE)} to reset the configuration.",
      i = "Use {.run usethis::edit_r_environ()} to edit {.file ~/.Renviron}."
    )))
  }

  fallback_config_apply(config)
}

fallback_config_reset <- function(config, name, envvar) {
  if (is.null(config[[name]])) {
    return(config)
  }

  val <- Sys.getenv(envvar, unset = NA)
  if (!is.na(val) && !identical(val, config[[name]])) {
    config[[name]] <- NULL
  }
  config
}

# Side effect: create directory if it doesn't exist
fallback_config_path <- function() {
  config_root <- tools::R_user_dir("duckplyr", "config")
  dir.create(config_root, showWarnings = FALSE)
  file.path(config_root, "fallback.dcf")
}

#' fallback_review
#'
#' `fallback_review()` prints the available reports for review to the console.
#'
#' @param oldest,newest The number of oldest or newest reports to review.
#'   If not specified, all reports are dispayed.
#' @param detail Print the full content of the reports.
#'   Set to `FALSE` to only print the file names.
#' @rdname fallback
#' @export
fallback_review <- function(oldest = NULL, newest = NULL, detail = TRUE) {
  fallback_logs <- tel_fallback_logs(oldest, newest, detail)
  if (length(fallback_logs) == 0) {
    cli::cli_inform("No reports ready for upload.")
    return(invisible())
  }

  for (i in seq_along(fallback_logs)) {
    file <- names(fallback_logs)[[i]]

    cli::cli_inform(c(
      "*" = "{.file {file}}",
      " " = if (detail) "{fallback_logs[[i]]}"
    ))
  }

  invisible()
}

#' fallback_upload
#'
#' `fallback_upload()` uploads the available reports to a central server for analysis.
#' The server is hosted on AWS and the reports are stored in a private S3 bucket.
#' Only authorized personnel have access to the reports.
#'
#' @param strict If `TRUE`, the function aborts if any of the reports fail to upload.
#'   With `FALSE`, only a message is printed.
#'
#' @rdname fallback
#' @export
fallback_upload <- function(oldest = NULL, newest = NULL, strict = TRUE) {
  if (strict) {
    check_installed(
      "curl",
      reason = "to upload duckplyr fallback reports."
    )
  } else if (!is_installed("curl")) {
    cli::cli_inform(
      "Skipping upload of duckplyr fallback reports because the {.pkg curl} package is not installed."
    )
    return(invisible())
  }

  fallback_logs <- tel_fallback_logs(oldest, newest, detail = TRUE)
  if (length(fallback_logs) == 0) {
    cli::cli_inform("No {.pkg duckplyr} fallback reports ready for upload.")
    return(invisible())
  }

  cli::cli_inform(
    "Uploading {.strong {length(fallback_logs)}} {.pkg duckplyr} fallback report{?s}."
  )

  failures <- character()

  pool <- curl::new_pool()
  imap(
    fallback_logs,
    ~ {
      contents <- .x
      file <- .y

      done <- function(request) {
        unlink(file)
      }

      fail <- function(message) {
        failures <<- c(failures, message)
      }

      tel_post_async(contents, done, fail, pool)
    }
  )

  curl::multi_run(pool = pool)

  if (length(failures) > 0) {
    msg <- c(
      "Failed to upload {length(failures)} {.pkg duckplyr} fallback report{?s}.",
      "i" = "The upload will be attempted again the next time {.code duckplyr::fallback_upload()} is called.",
      " " = '{paste(unique(failures), collapse = "\n")}'
    )

    if (strict) {
      cli::cli_abort(msg)
    } else {
      cli::cli_inform(msg)
    }
  } else {
    cli::cli_inform(
      "All {.pkg duckplyr} fallback reports uploaded successfully."
    )
  }

  invisible()
}

on_load({
  fallback_autoupload()
})

fallback_autoupload <- function() {
  autoupload <- tel_fallback_autoupload()
  if (isTRUE(autoupload)) {
    msg <- character()
    suppressMessages(withCallingHandlers(
      fallback_upload(strict = FALSE),
      message = function(e) {
        msg <<- c(msg, conditionMessage(e))
      }
    ))
    if (length(msg) > 0) {
      packageStartupMessage(paste(msg, collapse = "\n"))
    }
  } else if (is.na(autoupload)) {
    fallback_logs <- tel_fallback_logs()
    if (length(fallback_logs) > 0) {
      msg <- c(
        fallback_txt_header(),
        fallback_txt_autoupload(autoupload),
        fallback_txt_sitrep_logs(fallback_logs),
        "i" = cli::col_silver(
          "Configure automatic uploading with {.code duckplyr::fallback_config()}."
        )
      )
      packageStartupMessage(cli::format_message(msg))
    }
  }
}

#' fallback_purge
#'
#' `fallback_purge()` deletes some or all available reports.
#'
#' @rdname fallback
#' @export
fallback_purge <- function(oldest = NULL, newest = NULL) {
  fallback_logs <- tel_fallback_logs(oldest, newest, detail = FALSE)
  if (length(fallback_logs) == 0) {
    cli::cli_inform("No {.pkg duckplyr} fallback reports ready to delete.")
    return(invisible())
  }

  unlink(names(fallback_logs))
  cli::cli_inform(
    "Deleted {.strong {length(fallback_logs)}} {.pkg duckplyr} fallback report{?s}."
  )
  invisible()
}
