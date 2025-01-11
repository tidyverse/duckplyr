#' @title Right join
#'
#' @description  This is a method for the [dplyr::right_join()] generic.
#' See "Fallbacks" section for differences in implementation.
#' A `right_join()` keeps all observations in `y`.
#'
#' @inheritParams dplyr::right_join
#' @examples
#' library("dplyr")
#' right_join(band_members, band_instruments)
#' @seealso [dplyr::right_join()]
#' @rdname right_join.duckplyr_df
#' @name right_join.duckplyr_df
NULL
