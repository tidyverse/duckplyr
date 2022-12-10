#' @importFrom dplyr relocate
#' @export
relocate.duckplyr_df <- function(.data, ..., .before = NULL, .after = NULL) {
  #
  out <- NextMethod()
  out <- duckplyr_df_reconstruct(out)
  return(out)
}
