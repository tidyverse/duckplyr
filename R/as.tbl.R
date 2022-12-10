#' @importFrom dplyr as.tbl
#' @export
as.tbl.duckplyr_df <- function(x, ...) {
  #
  force(x)
  out <- NextMethod()
  out <- dplyr_reconstruct(out, x)
  return(out)
}
