#' @importFrom dplyr relocate
#' @export
relocate.duckplyr_df <- function(.data, ..., .before = NULL, .after = NULL) {
  #
  out <- NextMethod()
  out <- dplyr_reconstruct(out, .data)
  return(out)
}
