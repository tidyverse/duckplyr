#' @title Keep or drop columns using their names and types
#'
#' @description  This is a method for the [dplyr::select()] generic.
#' See "Fallbacks" section for differences in implementation.
#' Select (and optionally rename) variables in a data frame,
#' using a concise mini-language that makes it easy to refer to variables
#' based on their name (e.g. `a:f` selects all columns from a on the left
#' to f on the right) or type
#' (e.g. `where(is.numeric)` selects all numeric columns).
#'
#' @inheritParams dplyr::select
#' @examples
#' library(duckplyr)
#' select(mtcars, mpg)
#' @seealso [dplyr::select()]
#' @rdname select.duckplyr_df
#' @name select.duckplyr_df
NULL
