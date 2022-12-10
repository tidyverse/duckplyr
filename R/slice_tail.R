#' @importFrom dplyr slice_tail
#' @export
slice_tail.duckplyr_df <- function(.data, ..., n, prop, by = NULL) {
  #
  out <- NextMethod()
  out <- duckplyr_df_reconstruct(out)
  return(out)
}
