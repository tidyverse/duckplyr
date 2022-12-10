#' @importFrom dplyr transmute
#' @export
transmute.duckplyr_df <- function(.data, ...) {
  #
  force(.data)
  out <- NextMethod()
  out <- dplyr_reconstruct(out, .data)
  return(out)
}
