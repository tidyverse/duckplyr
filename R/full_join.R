#' @importFrom dplyr full_join
#' @export
full_join.duckplyr_df <- function(x, y, by = NULL, copy = FALSE, suffix = c(".x", ".y"), ..., keep = NULL, na_matches = c("na", "never"), multiple = NULL) {
  #
  out <- NextMethod()
  out <- dplyr_reconstruct(out, x)
  return(out)
}
