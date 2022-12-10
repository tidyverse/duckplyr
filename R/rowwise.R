#' @importFrom dplyr rowwise
#' @export
rowwise.duckplyr_df <- function(data, ...) {
  #
  out <- NextMethod()
  out <- duckplyr_df_reconstruct(out)
  return(out)
}
