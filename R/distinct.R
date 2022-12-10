#' @importFrom dplyr distinct
#' @export
distinct.duckplyr_df <- function(.data, ..., .keep_all = FALSE) {
  #
  out <- NextMethod()
  out <- dplyr_reconstruct(out, .data)
  return(out)
}
