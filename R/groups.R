#' @importFrom dplyr groups
#' @export
groups.duckplyr_df <- function(x) {
  #
  out <- NextMethod()
  out <- duckplyr_df_reconstruct(out)
  return(out)
}
