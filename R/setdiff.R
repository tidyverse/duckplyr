#' @importFrom dplyr setdiff
#' @export
setdiff.duckplyr_df <- function(x, y, ...) {
  #
  force(x)
  out <- NextMethod()
  out <- dplyr_reconstruct(out, x)
  return(out)
}
