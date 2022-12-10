#' @importFrom dplyr union_all
#' @export
union_all.duckplyr_df <- function(x, y, ...) {
  #
  out <- NextMethod()
  out <- dplyr_reconstruct(out, x)
  return(out)
}
