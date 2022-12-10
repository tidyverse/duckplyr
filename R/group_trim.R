#' @importFrom dplyr group_trim
#' @export
group_trim.duckplyr_df <- function(.tbl, .drop = group_by_drop_default(.tbl)) {
  #
  force(.tbl)
  out <- NextMethod()
  out <- dplyr_reconstruct(out, .tbl)
  return(out)
}
