#' @importFrom dplyr arrange
#' @export
arrange.duckplyr_df <- function(.data, ..., .by_group = FALSE, .locale = NULL) {
  #
  out <- NextMethod()
  out <- duckplyr_df_reconstruct(out)
  return(out)
}
