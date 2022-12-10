#' @importFrom dplyr pull
#' @export
pull.duckplyr_df <- function(.data, var = -1, name = NULL, ...) {
  #
  out <- NextMethod()
  out <- dplyr_reconstruct(out, .data)
  return(out)
}
