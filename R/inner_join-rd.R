#' @title Inner join
#'
#' @description  This is a method for the [dplyr::inner_join()] generic.
#' See "Fallbacks" section for differences in implementation.
#' An `inner_join()` only keeps observations from `x`
#' that have a matching key in `y`.
#'
#' @inheritParams dplyr::inner_join
#' @examples
#' library(duckplyr)
#' inner_join(band_members, band_instruments)
#' @seealso [dplyr::inner_join()]
#' @rdname inner_join.duckplyr_df
#' @name inner_join.duckplyr_df
NULL
