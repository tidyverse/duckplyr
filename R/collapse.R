#' @importFrom dplyr collapse
#' @export
collapse.duckplyr_df <- function(x, ...) {
  #
  out <- NextMethod()
  out <- duckplyr_df_reconstruct(out)
  return(out)
}
