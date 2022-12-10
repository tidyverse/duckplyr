#' @importFrom dplyr slice_max
#' @export
slice_max.duckplyr_df <- function(.data, order_by, ..., n, prop, by = NULL, with_ties = TRUE, na_rm = FALSE) {
  #
  force(.data)
  out <- NextMethod()
  out <- dplyr_reconstruct(out, .data)
  return(out)
}
