#' @importFrom dplyr sample_frac
#' @export
sample_frac.duckplyr_df <- function(tbl, size = 1, replace = FALSE, weight = NULL, .env = NULL, ...) {
  #
  force(tbl)
  out <- NextMethod()
  out <- dplyr_reconstruct(out, tbl)
  return(out)
}
