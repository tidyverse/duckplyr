#' @importFrom dplyr same_src
#' @export
same_src.duckplyr_df <- function(x, y) {
  #
  out <- NextMethod()
  out <- dplyr_reconstruct(out, x)
  return(out)
}
