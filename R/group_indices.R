#' @importFrom dplyr group_indices
#' @export
group_indices.duckplyr_df <- function(.data, ...) {
  #
  out <- NextMethod()
  out <- dplyr_reconstruct(out, .data)
  return(out)
}
