#' @importFrom dplyr pull
#' @export
pull.duckplyr_df <- function(.data, var = -1, name = NULL, ...) {
  #
  out <- NextMethod()
  out <- duckplyr_df_reconstruct(out)
  return(out)
}
