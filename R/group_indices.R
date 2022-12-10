#' @importFrom dplyr group_indices
#' @export
group_indices.duckplyr_df <- function(.data, ...) {
  #
  out <- NextMethod()
  out <- duckplyr_df_reconstruct(out)
  return(out)
}
