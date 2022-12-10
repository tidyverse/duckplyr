#' @importFrom dplyr dplyr_reconstruct
#' @export
dplyr_reconstruct.duckplyr_df <- function(data, template) {
  #
  force(data)
  out <- NextMethod()
  out <- dplyr_reconstruct(out, data)
  return(out)
}
