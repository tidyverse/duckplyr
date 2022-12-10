#' @importFrom dplyr group_trim
#' @export
group_trim.duckplyr_df <- function(.tbl, .drop = group_by_drop_default(.tbl)) {
  #
  out <- NextMethod()
  out <- duckplyr_df_reconstruct(out)
  return(out)
}
