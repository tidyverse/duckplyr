#' @title Count the observations in each group
#'
#' @description  This is a method for the [`dplyr::count()`] generic.
#' See "Fallbacks" section for differences in implementation.
#' `count()` lets you quickly count the unique values of one or more variables:
#' `df %>% count(a, b)` is roughly equivalent to
#' `df %>% group_by(a, b) %>% summarise(n = n())`.
#' `count()` is paired with `tally()`, a lower-level helper that is equivalent
#' to `df %>% summarise(n = n())`. Supply `wt` to perform weighted counts,
#' switching the summary from `n = n()` to `n = sum(wt)`.
#'
#' @inheritParams dplyr::count
#' @examples
#' library("duckplyr")
#' count(mtcars, am)
#' @seealso [`dplyr::count()`]
#' @rdname count.duckplyr_df
#' @name count.duckplyr_df
NULL
