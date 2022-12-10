#' @importFrom dplyr rows_upsert
#' @export
rows_upsert.duckplyr_df <- function(x, y, by = NULL, ..., copy = FALSE, in_place = FALSE) {
  #
  force(x)
  out <- NextMethod()
  out <- dplyr_reconstruct(out, x)
  return(out)
}
