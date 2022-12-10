#' @importFrom dplyr group_vars
#' @export
group_vars.duckplyr_df <- function(x) {
  #
  out <- NextMethod()
  out <- duckplyr_df_reconstruct(out)
  return(out)
}
