#' @export
is_duckplyr_df <- function(.data) {
  inherits(.data, "duckplyr_df")
}
