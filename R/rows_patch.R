#' @importFrom dplyr rows_patch
#' @export
rows_patch.duckplyr_df <- function(x, y, by = NULL, ..., unmatched = c("error", "ignore"), copy = FALSE, in_place = FALSE) {
  #
  force(x)
  out <- NextMethod()
  out <- dplyr_reconstruct(out, x)
  return(out)
}
