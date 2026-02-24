stats <- new_environment(list(
  attempts = 0L,
  fallback = 0L,
  calls = character()
))

#' Show stats
#'
#' Prints statistics on how many calls were handled by DuckDB.
#' The output shows the total number of requests in the current session,
#' split by fallbacks to dplyr and requests handled by duckdb.
#'
#' @return Called for its side effect.
#'
#' @export
#' @examples
#' stats_show()
#'
#' tibble(a = 1:3) %>%
#'   as_duckplyr_tibble() %>%
#'   mutate(b = a + 1)
#'
#' stats_show()
stats_show <- function() {
  writeLines(paste0(
    c("\U0001f6e0", "\U0001f528", "\U0001f986"),
    paste0("\u003A", " "),
    format(c(stats$attempts, stats$fallback, stats$attempts - stats$fallback))
  ))
  calls <- sort(gsub("[.]duckplyr_df", "", stats$calls))
  writeLines(paste(calls, collapse = ", "))
  invisible()
}
