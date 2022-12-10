#' @importFrom dplyr slice_head
#' @export
slice_head.duckplyr_df <- function(.data, ..., n, prop, by = NULL) {
  #
  out <- NextMethod()
  out <- duckplyr_df_reconstruct(out)
  return(out)
}
