#' @importFrom dplyr left_join
#' @export
left_join.duckplyr_df <- function(x, y, by = NULL, copy = FALSE, suffix = c(".x", ".y"), ..., keep = NULL, na_matches = c("na", "never"), multiple = NULL, unmatched = "drop") {
  #
  out <- NextMethod()
  out <- duckplyr_df_reconstruct(out)
  return(out)
}
