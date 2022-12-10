#' @importFrom dplyr mutate
#' @export
mutate.duckplyr_df <- function(.data, ..., .by = NULL, .keep = c("all", "used", "unused", "none"), .before = NULL, .after = NULL) {
  #
  out <- NextMethod()
  out <- duckplyr_df_reconstruct(out)
  return(out)
}
