#' @importFrom dplyr select
#' @export
select.duckplyr_df <- function(.data, ...) {
  #
  out <- NextMethod()
  out <- dplyr_reconstruct(out, .data)
  return(out)
}
