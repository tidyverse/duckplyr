#' @title Create, modify, and delete columns
#'
#' @description
#' `r lifecycle::badge("superseded")`
#'
#' This is a method for the [dplyr::transmute()] generic.
#' See "Fallbacks" section for differences in implementation.
#' `transmute()` creates a new data frame containing only the specified computations.
#' It's superseded because you can perform the same job with `mutate(.keep = "none")`.


#'
#' @inheritParams dplyr::transmute
#' @examples
#' library(duckplyr)
#' transmute(mtcars, mpg2 = mpg*2)
#' @seealso [dplyr::transmute()]
#' @rdname transmute.duckplyr_df
#' @name transmute.duckplyr_df
NULL
