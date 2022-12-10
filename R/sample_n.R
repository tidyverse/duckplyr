#' @importFrom dplyr sample_n
#' @export
sample_n.duckplyr_df <- function(tbl, size, replace = FALSE, weight = NULL, .env = NULL, ...) {
  #
  force(tbl)
  out <- NextMethod()
  out <- dplyr_reconstruct(out, tbl)
  return(out)
}
