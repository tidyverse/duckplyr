#' @title Create, modify, and delete columns
#'
#' @description  This is a method for the [dplyr::transmute()] generic.
#' See "Fallbacks" section for differences in implementation.
#' `transmute()` creates a new data frame containing only the specified computations.
#' It's superseded because you can perform the same job with `mutate(.keep = "none")`.


#'
#' @inheritParams dplyr::transmute
#' @seealso [dplyr::transmute()]
#' @rdname transmute.duckplyr_df
#' @name transmute.duckplyr_df
NULL
