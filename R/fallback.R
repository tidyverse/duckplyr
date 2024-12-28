#' Fallback to dplyr
#'
#' @description
#' The \pkg{duckplyr} package aims at providing
#' a fully compatible drop-in replacement for \pkg{dplyr}.
#' To achieve this, only a carefully selected subset of dplyr's operations,
#' R functions, and R data types are implemented.
#' Whenever duckplyr encounters an incompatibility, it falls back to dplyr.
#'
#' To assist future development, the fallback situations can be logged
#' to the console or to a local file and uploaded for analysis.
#' By default, \pkg{duckplyr} will not log or upload anything.
#' The functions and environment variables on this page control the process.
#'
#' @details
#' Logging and uploading are both opt-in.
#' By default, for logging, a message is printed to the console
#' for the first time in a session and then once every 8 hours.
#'
#' The following environment variables control the logging and uploading:
#'
#' - `DUCKPLYR_FALLBACK_COLLECT` controls logging, set it
#'   to 1 or greater to enable logging.
#'   If the value is 0, logging is disabled.
#'   Future versions of duckplyr may start logging additional data
#'   and thus require a higher value to enable logging.
#'   Set to 99 to enable logging for all future versions.
#'   Use [usethis::edit_r_environ()] to edit the environment file.
#'
#' - `DUCKPLYR_FALLBACK_VERBOSE` controls printing, set it
#'   to `TRUE` or `FALSE` to enable or disable printing.
#'   If the value is `TRUE`, a message is printed to the console
#'   for each fallback situation.
#'   This setting is only relevant if logging is enabled.
#'
#' - `DUCKPLYR_FALLBACK_AUTOUPLOAD` controls uploading, set it
#'   to 1 or greater to enable uploading.
#'   If the value is 0, uploading is disabled.
#'   Currently, uploading is active if the value is 1 or greater.
#'   Future versions of duckplyr may start logging additional data
#'   and thus require a higher value to enable uploading.
#'   Set to 99 to enable uploading for all future versions.
#'   Use [usethis::edit_r_environ()] to edit the environment file.
#'
#' - `DUCKPLYR_FALLBACK_LOG_DIR` controls the location of the logs.
#'   It must point to a directory (existing or not) where the logs will be written.
#'   By default, logs are written to a directory in the user's cache directory
#'   as returned by `tools::R_user_dir("duckplyr", "cache")`.
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
#' `fallback_sitrep()` prints the current settings for fallback logging and uploading,
#' the number of reports ready for upload, and the location of the logs.
#' @rdname fallback
#' @export
fallback_sitrep <- function() {
  fallback_logging <- tel_fallback_logging()
  fallback_verbose <- tel_fallback_verbose()
  fallback_uploading <- tel_fallback_uploading()
  fallback_log_dir <- tel_fallback_log_dir()
  fallback_logs <- tel_fallback_logs()

  msg <- c(
    fallback_txt_header(),
    #
    if (isTRUE(fallback_logging)) {
      c(
        "v" = "Fallback logging is enabled.",
        if (is.null(attr(fallback_logging, "val"))) {
          c("i" = "Fallback logging is not controlled, see {.help duckplyr::fallback}.")
        },
        "i" = "Logs are written to {.file {fallback_log_dir}}.",
        if (is.na(fallback_verbose)) {
          c("i" = "Fallback printing is not controlled and therefore disabled, see {.help duckplyr::fallback}.")
        } else if (fallback_verbose) {
          c("v" = "Fallback printing is enabled.")
        } else {
          c("x" = "Fallback printing is disabled.")
        }
      )
    } else {
      c("x" = "Fallback logging is disabled.")
    },
    #
    fallback_txt_uploading(fallback_uploading),
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

fallback_txt_uploading <- function(fallback_uploading) {
  if (is.na(fallback_uploading)) {
    c("i" = "Fallback uploading is not controlled and therefore disabled, see {.help duckplyr::fallback}.")
  } else if (fallback_uploading) {
    c("v" = "Fallback uploading is enabled.")
  } else {
    c("x" = "Fallback uploading is disabled.")
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
    "i" = "See {.help duckplyr::fallback} for details."
  )
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
    cli::cli_inform("Skipping upload of duckplyr fallback reports because the {.pkg curl} package is not installed.")
    return(invisible())
  }

  fallback_logs <- tel_fallback_logs(oldest, newest, detail = TRUE)
  if (length(fallback_logs) == 0) {
    cli::cli_inform("No {.pkg duckplyr} fallback reports ready for upload.")
    return(invisible())
  }

  cli::cli_inform("Uploading {.strong {length(fallback_logs)}} {.pkg duckplyr} fallback report{?s}.")

  failures <- character()

  pool <- curl::new_pool()
  imap(fallback_logs, ~ {
    contents <- .x
    file <- .y

    done <- function(request) {
      unlink(file)
    }

    fail <- function(message) {
      failures <<- c(failures, message)
    }

    tel_post_async(contents, done, fail, pool)
  })

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
    cli::cli_inform("All {.pkg duckplyr} fallback reports uploaded successfully.")
  }

  invisible()
}

on_load({
  fallback_autoupload()
})

fallback_autoupload <- function() {
  uploading <- tel_fallback_uploading()
  if (isTRUE(uploading)) {
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
  } else if (is.na(uploading)) {
    fallback_logs <- tel_fallback_logs()
    if (length(fallback_logs) > 0) {
      msg <- c(
        fallback_txt_header(),
        fallback_txt_uploading(uploading),
        fallback_txt_sitrep_logs(fallback_logs),
        "i" = cli::col_silver("This message can be disabled by setting {.envvar DUCKPLYR_FALLBACK_AUTOUPLOAD}.")
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
  cli::cli_inform("Deleted {.strong {length(fallback_logs)}} {.pkg duckplyr} fallback report{?s}.")
  invisible()
}
