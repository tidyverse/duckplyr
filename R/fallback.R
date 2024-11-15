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
#' Logging is opt-out but uploading is opt-in.
#'
#' The following functions control the logging and uploading:
#'
#' - To opt the current machine out of logging, run [`fallback_logging_optout()`].
#'
#' - To opt in again for logging, run [`fallback_logging_optin()`].
#'
#' - \code{DUCKPLYR_FALLBACK_VERBOSE} controls printing, set it
#'   to \code{TRUE} or \code{FALSE} to enable or disable printing.
#'   If the value is \code{TRUE}, a message is printed to the console
#'   for each fallback situation.
#'   This setting is only relevant if logging is enabled.
#'
#' - To opt the current machine in automatic report uploads, run [`fallback_reporting_optin()`].
#'
#' - To opt out again of automatic report uploads, run [`fallback_reporting_optout()`].
#'
#' - \code{DUCKPLYR_FALLBACK_LOG_DIR} controls the location of the logs.
#'   It must point to a directory (existing or not) where the logs will be written.
#'   By default, logs are written to a directory in the user's cache directory
#'   as returned by \code{tools::R_user_dir("duckplyr", "cache")}.
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
  fallback_logging <- !fallback_logging_opted_out()
  fallback_verbose <- fallback_verbose_opted_in()
  fallback_uploading <- fallback_reporting_opted_in()
  fallback_log_dir <- tel_fallback_log_dir()
  fallback_logs <- tel_fallback_logs()

  msg <- c(
    fallback_txt_header(),
    #
    if (fallback_logging) {
      c(
        "v" = "Fallback logging is on. Disable it with {.fun duckplyr::fallback_logging_optout}.",
        "i" = "Logs are written to {.file {fallback_log_dir}}. View them with {.fun duckplyr::fallback_review}."
      )
    } else {
      c("x" = "Fallback logging is off. Enable it with {.fun duckplyr::fallback_logging_optin}.")
    },
    #
    if (fallback_verbose) {
      c(
        "v" = "Fallback messaging on screen is on. Disable it with {.fun duckplyr::fallback_verbose_optout}."
      )
    } else {
      c("x" = "Fallback messaging on screen is off. Enable it with {.fun duckplyr::fallback_verbose_optin}.")
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
  "duckplyr falls back to dplyr when it encounters an incompatibility. We would like to find out about these events so we can make duckplyr better."
}

fallback_txt_uploading <- function(fallback_uploading) {
  if (is.na(fallback_uploading)) {
    c(
      i = "Use {.fun duckplyr::fallback_upload} to upload this report and existing reports.",
      i = "Use {.fun duckplyr::fallback_reporting_optin} to automatically upload future reports.",
      i = "Use {.fun duckplyr::fallback_review} to review existing reports."
    )
  } else if (fallback_uploading) {
    c("v" = "Fallback automatic uploading is on. Disable it with {.fun duckplyr::fallback_reporting_optout}.")
  } else {
    c("x" = "Fallback automatic uploading is off. Enable it with {.fun duckplyr::fallback_reporting_optin}.")
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
#'   Set to \code{FALSE} to only print the file names.
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
#' @param strict If \code{TRUE}, the function aborts if any of the reports fail to upload.
#'   With \code{FALSE}, only a message is printed.
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
  # To opt out of messages about uploading,
  # you opt out of logging in the first place.
  if (fallback_logging_opted_out()) {
    return(invisible())
  }
  if (fallback_reporting_opted_in()) {
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
  } else {
    fallback_logs <- tel_fallback_logs()
    if (length(fallback_logs) > 0) {
      msg <- c(
        fallback_txt_header(),
        fallback_txt_uploading(fallback_reporting_opted_in()),
        fallback_txt_sitrep_logs(fallback_logs),
        "i" = cli::col_silver("Opt out of logging with {.fun duckplyr::fallback_logging_optout}")
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

#' fallback_logging_optout
#'
#' `fallback_logging_optout()` opts the machine out of fallback logging.
#' @param purge Logical. Whether to delete currently available reports.
#' @rdname fallback
#' @export
fallback_logging_optout <- function(purge = TRUE) {

  file.create(fallback_logging_optout_path())
  writeLines("opted out", fallback_logging_optout_path())

  cli::cli_inform(c(
    "Opted out of logging fallback reports.",
    i = "Opt in again at any time with {.fun fallback_logging_optin()}."
  ))

  if (purge) {
    fallback_purge()
  }
}

#' fallback_logging_optin
#'
#' `fallback_logging_optin()` opts the machine in fallback logging.
#' @rdname fallback
#' @export
fallback_logging_optin <- function() {
  if (fallback_logging_opted_out()) {
    unlink(fallback_logging_optout_path())
  }
}

fallback_logging_opted_out <- function() {
  file.exists(fallback_logging_optout_path())
}

fallback_logging_optout_path <- function() {
  file.path(tools::R_user_dir("duckplyr", "cache"), "fallback-logging-optout")
}

#' fallback_reporting_optin
#'
#' `fallback_reporting_optin()` opts the machine in automatic report uploads.
#' @rdname fallback
#' @export
fallback_reporting_optin <- function() {

  file.create(fallback_reporting_optin_path())
  writeLines("opted in", fallback_reporting_optin_path())

  cli::cli_inform(c(
    "Opted in automatically uploading fallback reports.",
    i = "Opt out again at any time with {.fun fallback_reporting_optout}."
  ))

}

#' fallback_reporting_optout
#'
#' `fallback_reporting_optout()` opts out the machine of automatic report uploads.
#' @rdname fallback
#' @export
fallback_reporting_optout <- function() {
  if (fallback_reporting_opted_in()) {
    unlink(fallback_reporting_optin_path())
  }
}

fallback_reporting_optin_path <- function() {
  file.path(tools::R_user_dir("duckplyr", "cache"), "fallback-reporting-optin")
}

fallback_reporting_opted_in <- function() {
  file.exists(fallback_reporting_optin_path())
}



#' fallback_verbose_optin
#'
#' `fallback_verbose_optin()` opts the machine in messages about fallbacks.
#' @rdname fallback
#' @export
fallback_verbose_optin <- function() {

  file.create(fallback_verbose_optin_path())
  writeLines("opted in", fallback_verbose_optin_path())

  cli::cli_inform(c(
    "Opted in automatically uploading fallback reports.",
    i = "Opt out again at any time with {.fun fallback_verbose_optout}."
  ))

}

#' fallback_verbose_optout
#'
#' `fallback_verbose_optout()` opts out the machine of messages about fallbacks.
#' @rdname fallback
#' @export
fallback_verbose_optout <- function() {
  if (fallback_verbose_opted_in()) {
    unlink(fallback_verbose_optin_path())
  }
}

fallback_verbose_optin_path <- function() {
  file.path(tools::R_user_dir("duckplyr", "cache"), "fallback-verbose-optin")
}

fallback_verbose_opted_in <- function() {
  file.exists(fallback_verbose_optin_path())
}
