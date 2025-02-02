#' Flight data
#'
#' Provides a variant of `nycflights13::flights` that is compatible with duckplyr,
#' as a tibble:
#' the timezone has been set to UTC to work around a current limitation of duckplyr, see `vignette("limits")`.
#' Call [as_duckdb_tibble()] to enable duckplyr operations.
#'
#' @export
#' @examplesIf requireNamespace("nycflights13", quietly = TRUE)
#' flights_df()
flights_df <- function() {
  check_installed("nycflights13")

  out <- nycflights13::flights
  attr(out$time_hour, "tzone") <- "UTC"
  out
}
