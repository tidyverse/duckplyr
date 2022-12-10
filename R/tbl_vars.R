#' @importFrom dplyr tbl_vars
#' @export
tbl_vars.duckplyr_df <- function(x) {
  #
  out <- NextMethod()
  out <- dplyr_reconstruct(out, x)
  return(out)
}
