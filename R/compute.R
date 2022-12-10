#' @importFrom dplyr compute
#' @export
compute.duckplyr_df <- function(x, ...) {
  #
  out <- NextMethod()
  out <- duckplyr_df_reconstruct(out)
  return(out)
}
