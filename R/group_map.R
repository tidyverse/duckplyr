#' @importFrom dplyr group_map
#' @export
group_map.duckplyr_df <- function(.data, .f, ..., .keep = FALSE, keep = deprecated()) {
  #
  out <- NextMethod()
  out <- duckplyr_df_reconstruct(out)
  return(out)
}
