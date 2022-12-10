#' @importFrom dplyr auto_copy
#' @export
auto_copy.duckplyr_df <- function(x, y, copy = FALSE, ...) {
  #
  out <- NextMethod()
  out <- duckplyr_df_reconstruct(out)
  return(out)
}
