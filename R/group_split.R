#' @importFrom dplyr group_split
#' @export
group_split.duckplyr_df <- function(.tbl, ..., .keep = TRUE, keep = deprecated()) {
  #
  out <- NextMethod()
  out <- dplyr_reconstruct(out, .tbl)
  return(out)
}
