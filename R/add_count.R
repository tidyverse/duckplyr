#' @importFrom dplyr add_count
#' @export
add_count.duckplyr_df <- function(x, ..., wt = NULL, sort = FALSE, name = NULL, .drop = deprecated()) {
  #
  out <- NextMethod()
  out <- dplyr_reconstruct(out, x)
  return(out)
}
