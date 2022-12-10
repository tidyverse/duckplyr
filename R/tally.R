#' @importFrom dplyr tally
#' @export
tally.duckplyr_df <- function(x, wt = NULL, sort = FALSE, name = NULL) {
  #
  out <- NextMethod()
  out <- duckplyr_df_reconstruct(out)
  return(out)
}
