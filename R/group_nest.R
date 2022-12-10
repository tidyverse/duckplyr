#' @importFrom dplyr group_nest
#' @export
group_nest.duckplyr_df <- function(.tbl, ..., .key = "data", keep = FALSE) {
  #
  out <- NextMethod()
  out <- duckplyr_df_reconstruct(out)
  return(out)
}
