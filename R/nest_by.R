#' @importFrom dplyr nest_by
#' @export
nest_by.duckplyr_df <- function(.data, ..., .key = "data", .keep = FALSE) {
  #
  out <- NextMethod()
  out <- duckplyr_df_reconstruct(out)
  return(out)
}
