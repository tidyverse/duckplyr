#' @importFrom dplyr intersect
#' @export
intersect.duckplyr_df <- function(x, y, ...) {
  #
  out <- NextMethod()
  out <- duckplyr_df_reconstruct(out)
  return(out)
}
