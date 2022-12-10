#' @importFrom dplyr count
#' @export
count.duckplyr_df <- function(x, ..., wt = NULL, sort = FALSE, name = NULL, .drop = group_by_drop_default(x)) {
  #
  out <- NextMethod()
  out <- dplyr_reconstruct(out, x)
  return(out)
}
