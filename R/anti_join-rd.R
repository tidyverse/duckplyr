#' @title Anti join
#'
#' @description  This is a method for the [dplyr::anti_join()] generic.
#' `anti_join()` returns all rows from `x` with**out** a match in `y`.
#'
#' @inheritParams dplyr::anti_join
#' @examples
#' library(duckplyr)
#' band_members %>% anti_join(band_instruments)
#' @seealso [dplyr::anti_join()]
#' @rdname anti_join.duckplyr_df
#' @name anti_join.duckplyr_df
NULL
