#' @importFrom dplyr sample_n
#' @export
sample_n.duckplyr_df <- function(tbl, size, replace = FALSE, weight = NULL, .env = NULL, ...) {
  #
  out <- NextMethod()
  out <- duckplyr_df_reconstruct(out)
  return(out)
}
