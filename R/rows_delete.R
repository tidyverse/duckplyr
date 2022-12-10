#' @importFrom dplyr rows_delete
#' @export
rows_delete.duckplyr_df <- function(x, y, by = NULL, ..., unmatched = c("error", "ignore"), copy = FALSE, in_place = FALSE) {
  #
  force(x)
  out <- NextMethod()
  out <- dplyr_reconstruct(out, x)
  return(out)
}
