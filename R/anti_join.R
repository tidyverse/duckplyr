#' @importFrom dplyr anti_join
#' @export
anti_join.duckplyr_df <- function(x, y, by = NULL, copy = FALSE, ..., na_matches = c("na", "never")) {
  #
  force(x)
  out <- NextMethod()
  out <- dplyr_reconstruct(out, x)
  return(out)
}
