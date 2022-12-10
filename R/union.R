#' @importFrom dplyr union
#' @export
union.duckplyr_df <- function(x, y, ...) {
  #
  out <- NextMethod()
  out <- duckplyr_df_reconstruct(out)
  return(out)
}
