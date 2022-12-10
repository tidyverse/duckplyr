#' @importFrom dplyr rename
#' @export
rename.duckplyr_df <- function(.data, ...) {
  #
  out <- NextMethod()
  out <- dplyr_reconstruct(out, .data)
  return(out)
}
