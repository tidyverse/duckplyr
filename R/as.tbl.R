#' @importFrom dplyr as.tbl
#' @export
as.tbl.duckplyr_df <- function(x, ...) {
  #
  out <- NextMethod()
  out <- duckplyr_df_reconstruct(out)
  return(out)
}
