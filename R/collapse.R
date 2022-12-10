#' @importFrom dplyr collapse
#' @export
collapse.duckplyr_df <- function(x, ...) {
  #
  out <- NextMethod()
  out <- dplyr_reconstruct(out, x)
  return(out)
}
