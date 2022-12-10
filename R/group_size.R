#' @importFrom dplyr group_size
#' @export
group_size.duckplyr_df <- function(x) {
  #
  out <- NextMethod()
  out <- dplyr_reconstruct(out, x)
  return(out)
}
