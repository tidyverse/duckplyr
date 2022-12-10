#' @importFrom dplyr slice_min
#' @export
slice_min.duckplyr_df <- function(.data, order_by, ..., n, prop, by = NULL, with_ties = TRUE, na_rm = FALSE) {
  #
  force(.data)
  out <- NextMethod()
  out <- dplyr_reconstruct(out, .data)
  return(out)
}
