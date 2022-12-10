#' @importFrom dplyr group_keys
#' @export
group_keys.duckplyr_df <- function(.tbl, ...) {
  #
  out <- NextMethod()
  out <- duckplyr_df_reconstruct(out)
  return(out)
}
