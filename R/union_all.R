#' @importFrom dplyr union_all
#' @export
union_all.duckplyr_df <- function(x, y, ...) {
  #
  out <- NextMethod()
  out <- duckplyr_df_reconstruct(out)
  return(out)
}
