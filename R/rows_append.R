#' @importFrom dplyr rows_append
#' @export
rows_append.duckplyr_df <- function(x, y, ..., copy = FALSE, in_place = FALSE) {
  #
  out <- NextMethod()
  out <- duckplyr_df_reconstruct(out)
  return(out)
}
