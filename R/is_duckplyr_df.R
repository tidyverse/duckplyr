#' Class predicate for duckplyr data frames
#'
#' @description
#' `r lifecycle::badge("deprecated")`
#'
#' Tests if the input object is of class `"duckplyr_df"`.
#'
#' @param .data The object to test
#'
#' @return `TRUE` if the input object is of class `"duckplyr_df"`,
#'   otherwise `FALSE`.
#'
#' @keywords internal
#' @export
#' @examples
#' tibble(a = 1:3) %>%
#'   is_duckplyr_df()
#'
#' tibble(a = 1:3) %>%
#'   as_duckplyr_df() %>%
#'   is_duckplyr_df()
is_duckplyr_df <- function(.data) {
  lifecycle::deprecate_soft("1.0.0", "is_duckplyr_df()", "is_duckdb_tibble()")

  inherits(.data, "duckplyr_df")
}
