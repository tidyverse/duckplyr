#' @importFrom dplyr slice_head
#' @export
slice_head.duckplyr_df <- function(.data, ..., n, prop, by = NULL) {
  #
  force(.data)
  out <- NextMethod()
  out <- dplyr_reconstruct(out, .data)
  return(out)
}
