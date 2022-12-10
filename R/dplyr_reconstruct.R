#' @importFrom dplyr dplyr_reconstruct
#' @export
dplyr_reconstruct.duckplyr_df <- function(data, template) {
  #
  out <- NextMethod()
  out <- duckplyr_df_reconstruct(out)
  return(out)
}
