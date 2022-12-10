#' @importFrom dplyr rename_with
#' @export
rename_with.duckplyr_df <- function(.data, .fn, .cols = everything(), ...) {
  #
  out <- NextMethod()
  out <- duckplyr_df_reconstruct(out)
  return(out)
}
