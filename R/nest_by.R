#' @importFrom dplyr nest_by
#' @export
nest_by.duckplyr_df <- function(.data, ..., .key = "data", .keep = FALSE) {
  #
  out <- NextMethod()
  out <- dplyr_reconstruct(out, .data)
  return(out)
}
