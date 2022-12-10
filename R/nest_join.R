#' @importFrom dplyr nest_join
#' @export
nest_join.duckplyr_df <- function(x, y, by = NULL, copy = FALSE, keep = NULL, name = NULL, ..., na_matches = c("na", "never"), unmatched = "drop") {
  #
  out <- NextMethod()
  out <- dplyr_reconstruct(out, x)
  return(out)
}
