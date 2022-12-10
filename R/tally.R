#' @importFrom dplyr tally
#' @export
tally.duckplyr_df <- function(x, wt = NULL, sort = FALSE, name = NULL) {
  #
  force(x)
  out <- NextMethod()
  out <- dplyr_reconstruct(out, x)
  return(out)
}
