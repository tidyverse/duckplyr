#' @importFrom dplyr rename_with
#' @export
rename_with.duckplyr_df <- function(.data, .fn, .cols = everything(), ...) {
  #
  out <- NextMethod()
  out <- dplyr_reconstruct(out, .data)
  return(out)
}
