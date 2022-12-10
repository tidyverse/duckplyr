#' @importFrom dplyr slice
#' @export
slice.duckplyr_df <- function(.data, ..., .by = NULL, .preserve = FALSE) {
  #
  out <- NextMethod()
  out <- dplyr_reconstruct(out, .data)
  return(out)
}
