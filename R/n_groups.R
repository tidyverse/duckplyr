#' @importFrom dplyr n_groups
#' @export
n_groups.duckplyr_df <- function(x) {
  #
  out <- NextMethod()
  out <- duckplyr_df_reconstruct(out)
  return(out)
}
