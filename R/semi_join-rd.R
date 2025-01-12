#' @title Semi join
#'
#' @description  This is a method for the [dplyr::semi_join()] generic.
#' `semi_join()` returns all rows from x with a match in y.
#'
#' @inheritParams dplyr::semi_join
#' @examples
#' library(duckplyr)
#' library(dplyr)
#' band_members %>% semi_join(band_instruments)
#' @seealso [dplyr::semi_join()]
#' @rdname semi_join.duckplyr_df
#' @name semi_join.duckplyr_df
NULL
