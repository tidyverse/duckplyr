#' @importFrom dplyr tbl_vars
#' @export
tbl_vars.duckplyr_df <- function(x) {
  #
  out <- NextMethod()
  out <- duckplyr_df_reconstruct(out)
  return(out)
}
