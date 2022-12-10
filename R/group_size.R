#' @importFrom dplyr group_size
#' @export
group_size.duckplyr_df <- function(x) {
  #
  out <- NextMethod()
  out <- duckplyr_df_reconstruct(out)
  return(out)
}
