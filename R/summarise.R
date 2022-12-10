#' @importFrom dplyr summarise
#' @export
summarise.duckplyr_df <- function(.data, ..., .by = NULL, .groups = NULL) {
  #
  out <- NextMethod()
  out <- duckplyr_df_reconstruct(out)
  return(out)
}
