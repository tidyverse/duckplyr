#' @importFrom dplyr rows_delete
#' @export
rows_delete.duckplyr_df <- function(x, y, by = NULL, ..., unmatched = c("error", "ignore"), copy = FALSE, in_place = FALSE) {
  #
  out <- NextMethod()
  out <- duckplyr_df_reconstruct(out)
  return(out)
}
