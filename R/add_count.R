#' @importFrom dplyr add_count
#' @export
add_count.duckplyr_df <- function(x, ..., wt = NULL, sort = FALSE, name = NULL, .drop = deprecated()) {
  #
  out <- NextMethod()
  out <- duckplyr_df_reconstruct(out)
  return(out)
}
