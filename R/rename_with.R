#' @importFrom dplyr rename_with
#' @export
rename_with.duckplyr_df <- function(.data, .fn, .cols = everything(), ...) {
  #
  force(.data)
  out <- NextMethod()
  out <- dplyr_reconstruct(out, .data)
  return(out)
}
