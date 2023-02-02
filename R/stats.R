stats <- new_environment(list(attempts = 0L, fallback = 0L, calls = character()))

#' @export
stats_show <- function() {
  writeLines(paste0(
    c("\U0001f6e0", "\U0001f528", "\U0001f986"),
    "️: ",
    format(c(stats$attempts, stats$fallback, stats$attempts - stats$fallback))
  ))
  writeLines(sort(stats$calls))
}
