#' @importFrom dplyr slice_sample
#' @export
slice_sample.duckplyr_df <- function(.data, ..., n, prop, by = NULL, weight_by = NULL, replace = FALSE) {
  #
  out <- NextMethod()
  out <- duckplyr_df_reconstruct(out)
  return(out)
}
