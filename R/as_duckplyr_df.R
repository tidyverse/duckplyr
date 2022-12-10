#' @export
as_duckplyr_df <- function(.data, ...) {
  stopifnot(is.data.frame(.data))
  class(.data) <- c("duckplyr_df", class(.data))
  .data
}
