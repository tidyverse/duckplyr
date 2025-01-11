#' @title Left join
#'
#' @description  This is a method for the [dplyr::left_join()] generic.
#' See "Fallbacks" section for differences in implementation.
#' A `left_join()` keeps all observations in `x`.
#'
#' @inheritParams dplyr::left_join
#' @examples
#' library("dplyr")
#' left_join(band_members, band_instruments)
#' @seealso [dplyr::left_join()]
#' @rdname left_join.duckplyr_df
#' @name left_join.duckplyr_df
NULL
