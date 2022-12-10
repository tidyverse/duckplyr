#' @importFrom dplyr reframe
#' @export
reframe.duckplyr_df <- function(.data, ..., .by = NULL) {
  #
  out <- NextMethod()
  out <- dplyr_reconstruct(out, .data)
  return(out)
}
