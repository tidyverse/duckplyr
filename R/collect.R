#' @importFrom dplyr collect
#' @export
collect.duckplyr_df <- function(x, ...) {
  #
  out <- NextMethod()
  out <- duckplyr_df_reconstruct(out)
  return(out)
}
