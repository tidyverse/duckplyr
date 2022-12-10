#' @importFrom dplyr arrange
#' @export
arrange.duckplyr_df <- function(.data, ..., .by_group = FALSE, .locale = NULL) {
  #
  out <- NextMethod()
  out <- dplyr_reconstruct(out, .data)
  return(out)
}
