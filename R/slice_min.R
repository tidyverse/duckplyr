#' @importFrom dplyr slice_min
#' @export
slice_min.duckplyr_df <- function(.data, order_by, ..., n, prop, by = NULL, with_ties = TRUE, na_rm = FALSE) {
  #
  out <- NextMethod()
  out <- duckplyr_df_reconstruct(out)
  return(out)
}
