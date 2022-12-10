#' @importFrom dplyr do
#' @export
do.duckplyr_df <- function(.data, ...) {
  #
  out <- NextMethod()
  out <- dplyr_reconstruct(out, .data)
  return(out)
}
