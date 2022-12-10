#' @importFrom dplyr group_data
#' @export
group_data.duckplyr_df <- function(.data) {
  #
  out <- NextMethod()
  out <- duckplyr_df_reconstruct(out)
  return(out)
}
