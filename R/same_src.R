#' @importFrom dplyr same_src
#' @export
same_src.duckplyr_df <- function(x, y) {
  #
  out <- NextMethod()
  out <- duckplyr_df_reconstruct(out)
  return(out)
}
