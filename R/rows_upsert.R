#' @importFrom dplyr rows_upsert
#' @export
rows_upsert.duckplyr_df <- function(x, y, by = NULL, ..., copy = FALSE, in_place = FALSE) {
  #
  out <- NextMethod()
  out <- duckplyr_df_reconstruct(out)
  return(out)
}
