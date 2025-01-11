#' Flight data
#'
#' Provides a copy of `nycflights13::flights` that is compatible with duckplyr,
#' as a tibble.
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
