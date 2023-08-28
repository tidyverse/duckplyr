stats <- new_environment(list(attempts = 0L, fallback = 0L, calls = character()))

#' Show stats
#'
#' @export
stats_show <- function() {
  writeLines(paste0(
    c("\U0001f6e0", "\U0001f528", "\U0001f986"),
    paste0("\u003A", " "),
    format(c(stats$attempts, stats$fallback, stats$attempts - stats$fallback))
  ))
  calls <- sort(gsub("[.]duckplyr_df", "", stats$calls))
  writeLines(paste(calls, collapse = ", "))
}
