#' @importFrom dplyr summarise
#' @export
summarise.duckplyr_df <- function(.data, ..., .by = NULL, .groups = NULL) {
  #
  out <- NextMethod()
  out <- dplyr_reconstruct(out, .data)
  return(out)
}
