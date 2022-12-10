#' @importFrom dplyr distinct
#' @export
distinct.duckplyr_df <- function(.data, ..., .keep_all = FALSE) {
  #
  out <- NextMethod()
  out <- duckplyr_df_reconstruct(out)
  return(out)
}
