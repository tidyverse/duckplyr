#' @importFrom dplyr transmute
#' @export
transmute.duckplyr_df <- function(.data, ...) {
  #
  out <- NextMethod()
  out <- duckplyr_df_reconstruct(out)
  return(out)
}
