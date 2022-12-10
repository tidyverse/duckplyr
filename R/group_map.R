#' @importFrom dplyr group_map
#' @export
group_map.duckplyr_df <- function(.data, .f, ..., .keep = FALSE, keep = deprecated()) {
  #
  force(.data)
  out <- NextMethod()
  out <- dplyr_reconstruct(out, .data)
  return(out)
}
