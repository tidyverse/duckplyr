#' @title Intersect
#'
#' @description  This is a method for the [`dplyr::intersect()`] generic.
#' See "Fallbacks" section for differences in implementation.
#' `intersect(x, y)` finds all rows in both `x` and `y`.
#'
#' @inheritParams dplyr::intersect
#' @examples
#' df1 <- tibble(x = 1:3)
#' df2 <- tibble(x = 3:5)
#' intersect(df1, df2)
#' @seealso [`dplyr::intersect()`]
#' @rdname intersect.duckplyr_df
#' @name intersect.duckplyr_df
NULL
