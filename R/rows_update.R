#' @importFrom dplyr rows_update
#' @export
rows_update.duckplyr_df <- function(x, y, by = NULL, ..., unmatched = c("error", "ignore"), copy = FALSE, in_place = FALSE) {
  #
  force(x)
  out <- NextMethod()
  out <- dplyr_reconstruct(out, x)
  return(out)
}
