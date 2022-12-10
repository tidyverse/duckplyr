#' @importFrom dplyr group_vars
#' @export
group_vars.duckplyr_df <- function(x) {
  #
  force(x)
  out <- NextMethod()
  out <- dplyr_reconstruct(out, x)
  return(out)
}
