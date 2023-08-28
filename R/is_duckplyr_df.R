#' Class predicate for duckplyr data frames
#'
#' @param .data Data
#'
#' @export
is_duckplyr_df <- function(.data) {
  inherits(.data, "duckplyr_df")
}
