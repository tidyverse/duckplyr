#' @title Explain details of a tbl
#'
#' @description  This is a method for the [`dplyr::explain()`] generic.
#' This is a generic function which gives more details about an object
#' than `print()`, and is more focused on human readable output than `str()`.
#'
#' @inheritParams dplyr::explain
#' @examples
#' library("duckplyr")
#' df <- tibble(x = c(1, 2))
#' df <- mutate(df, y = 2)
#' explain(df)
#' @seealso [`dplyr::explain()`]
#' @rdname explain.duckplyr_df
#' @name explain.duckplyr_df
NULL
