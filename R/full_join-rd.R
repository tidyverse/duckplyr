#' @title Full join
#'
#' @description  This is a method for the [dplyr::full_join()] generic.
#' See "Fallbacks" section for differences in implementation.
#' A `full_join()` keeps all observations in `x` and `y`.
#'
#' @inheritParams dplyr::full_join
#' @examples
#' library(dplyr)
#' full_join(band_members, band_instruments)
#' @seealso [dplyr::full_join()]
#' @rdname full_join.duckplyr_df
#' @name full_join.duckplyr_df
NULL
