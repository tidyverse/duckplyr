#' @importFrom dplyr ungroup
#' @export
ungroup.duckplyr_df <- function(x, ...) {
  #
  out <- NextMethod()
  out <- duckplyr_df_reconstruct(out)
  return(out)
}
