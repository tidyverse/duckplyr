#' @importFrom dplyr union
#' @export
union.duckplyr_df <- function(x, y, ...) {
  #
  force(x)
  out <- NextMethod()
  out <- dplyr_reconstruct(out, x)
  return(out)
}
