#' @importFrom dplyr anti_join
#' @export
anti_join.duckplyr_df <- function(x, y, by = NULL, copy = FALSE, ..., na_matches = c("na", "never")) {
  #
  out <- NextMethod()
  out <- duckplyr_df_reconstruct(out)
  return(out)
}
