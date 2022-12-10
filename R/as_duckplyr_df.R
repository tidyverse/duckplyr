#' @export
as_duckplyr_df <- function(.data, ...) {
  class(.data) <- c("duckplyr_df", class(.data))
  .data
}
