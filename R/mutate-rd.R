#' @title Create, modify, and delete columns
#'
#' @description  This is a method for the [dplyr::mutate()] generic.
#' `mutate()` creates new columns that are functions of existing variables.
#' It can also modify (if the name is the same as an existing column)
#' and delete columns (by setting their value to `NULL`).
#'
#' @inheritParams dplyr::mutate
#' @examples
#' library(duckplyr)
#' df <- data.frame(x = c(1, 2))
#' df <- mutate(df, y = 2)
#' df
#' @seealso [dplyr::mutate()]
#' @rdname mutate.duckplyr_df
#' @name mutate.duckplyr_df
NULL
