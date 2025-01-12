#' @title Change column order
#'
#' @description  This is a method for the [dplyr::relocate()] generic.
#' See "Fallbacks" section for differences in implementation.
#' Use `relocate()` to change column positions,
#' using the same syntax as `select()` to make it easy to move blocks of columns at once.
#'
#' @inheritParams dplyr::relocate
#' @examples
#' df <- tibble(a = 1, b = 1, c = 1, d = "a", e = "a", f = "a")
#' relocate(df, f)
#' @seealso [dplyr::relocate()]
#' @rdname relocate.duckplyr_df
#' @name relocate.duckplyr_df
NULL
