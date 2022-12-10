#' @importFrom dplyr group_modify
#' @export
group_modify.duckplyr_df <- function(.data, .f, ..., .keep = FALSE, keep = deprecated()) {
  #
  out <- NextMethod()
  out <- duckplyr_df_reconstruct(out)
  return(out)
}
