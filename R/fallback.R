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
#' to a local file and uploaded for analysis.
#' The functions and environment variables on this page control the process.
#'
#' @details
#' Logging and uploading are both opt-in.
#' By default, for logging, a message is printed to the console
#' for the first time in a session and then once every 8 hours.
#' The number of available logs and instructions for reviewing and uploading
#' are printed when the package is loaded.
#'
#' @name fallback
NULL

#' fallback_sitrep
#'
#' `fallback_sitrep()` prints the current settings for fallback logging and uploading,
#' the number of reports ready for upload, and the location of the logs.
#' @rdname fallback
#' @export
fallback_sitrep <- function() {
  fallback_logging <- tel_fallback_logging()
  fallback_uploading <- tel_fallback_uploading()
  fallback_log_dir <- tel_fallback_log_dir()
  fallback_logs <- tel_fallback_logs()

  msg <- c(
    "The {.pkg duckplyr} package is configured to fall back to {.pkg dplyr} when it encounters an incompatibility. Fallback events can be collected and uploaded for analysis to guide future development. See {.help duckplyr::fallback} for details.",

    if (is.na(fallback_logging)) {
      c("i" = "Fallback logging is not controlled. Enable or disable it by setting the {.envvar DUCKPLYR_FALLBACK_COLLECT} environment variable.")
    } else if (fallback_logging) {
      c("v" = "Fallback logging is enabled.")
    } else {
      c("x" = "Fallback logging is disabled.")
    },

    if (is.na(fallback_uploading)) {
      c("i" = "Fallback uploading is not controlled. Enable or disable it by setting the {.envvar DUCKPLYR_FALLBACK_AUTOUPLOAD} environment variable.")
    } else if (fallback_uploading) {
      c("v" = "Fallback uploading is enabled.")
    } else {
      c("x" = "Fallback uploading is disabled.")
    },

    "i" = "If enabled, logs are written to {.file {fallback_log_dir}}.",

    if (length(fallback_logs) > 0) {
      c("v" = "Number of reports ready for upload: {.strong {length(fallback_logs)}}. Review with {.code duckplyr::fallback_review()}, upload with {.code duckplyr::fallback_upload()}}")
    } else {
      c("i" = "No reports ready for upload.")
    }
  )

  cli::cli_inform(msg)
}
