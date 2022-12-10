#' @importFrom dplyr reframe
#' @export
reframe.duckplyr_df <- function(.data, ..., .by = NULL) {
  #
  out <- NextMethod()
  out <- duckplyr_df_reconstruct(out)
  return(out)
}
