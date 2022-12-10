#' @importFrom dplyr slice
#' @export
slice.duckplyr_df <- function(.data, ..., .by = NULL, .preserve = FALSE) {
  #
  out <- NextMethod()
  out <- duckplyr_df_reconstruct(out)
  return(out)
}
