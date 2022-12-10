#' @importFrom dplyr rows_insert
#' @export
rows_insert.duckplyr_df <- function(x, y, by = NULL, ..., conflict = c("error", "ignore"), copy = FALSE, in_place = FALSE) {
  #
  out <- NextMethod()
  out <- dplyr_reconstruct(out, x)
  return(out)
}
