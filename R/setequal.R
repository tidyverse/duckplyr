#' @importFrom dplyr setequal
#' @export
setequal.duckplyr_df <- function(x, y, ...) {
  #
  out <- NextMethod()
  out <- dplyr_reconstruct(out, x)
  return(out)
}
