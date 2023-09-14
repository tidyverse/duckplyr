#' Class predicate for duckplyr data frames
#'
#' Tests if the input object is of class `"duckplyr_df"`.
#'
#' @param .data The object to test
#'
#' @return `TRUE` if the input object is of class `"duckplyr_df"`,
#'   otherwise `FALSE`.
#'
#' @export
#' @examples
#' tibble(a = 1:3) %>%
#'   is_duckplyr_df()
#'
#' tibble(a = 1:3) %>%
#'   as_duckplyr_df() %>%
#'   is_duckplyr_df()
is_duckplyr_df <- function(.data) {
  inherits(.data, "duckplyr_df")
}
