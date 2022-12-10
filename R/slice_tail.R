#' @importFrom dplyr slice_tail
#' @export
slice_tail.duckplyr_df <- function(.data, ..., n, prop, by = NULL) {
  #
  out <- NextMethod()
  out <- dplyr_reconstruct(out, .data)
  return(out)
}
