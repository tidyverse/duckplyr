#' @importFrom dplyr group_keys
#' @export
group_keys.duckplyr_df <- function(.tbl, ...) {
  #
  out <- NextMethod()
  out <- dplyr_reconstruct(out, .tbl)
  return(out)
}
