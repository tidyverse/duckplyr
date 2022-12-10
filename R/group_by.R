#' @importFrom dplyr group_by
#' @export
group_by.duckplyr_df <- function(.data, ..., .add = FALSE, .drop = group_by_drop_default(.data)) {
  #
  out <- NextMethod()
  out <- duckplyr_df_reconstruct(out)
  return(out)
}
