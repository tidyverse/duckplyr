#' @importFrom dplyr group_data
#' @export
group_data.duckplyr_df <- function(.data) {
  #
  out <- NextMethod()
  out <- dplyr_reconstruct(out, .data)
  return(out)
}
