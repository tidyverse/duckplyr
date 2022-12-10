#' @importFrom dplyr n_groups
#' @export
n_groups.duckplyr_df <- function(x) {
  #
  out <- NextMethod()
  out <- dplyr_reconstruct(out, x)
  return(out)
}
