#' @title Symmetric difference
#'
#' @description  This is a method for the [dplyr::symdiff()] generic.
#' See "Fallbacks" section for differences in implementation.
#' `symdiff(x, y)`  computes the symmetric difference,
#' i.e. all rows in `x` that aren't in `y` and all rows in `y` that aren't in `x`.
#'
#' @inheritParams dplyr::symdiff
#' @seealso [dplyr::symdiff()]
#' @rdname symdiff.duckplyr_df
#' @name symdiff.duckplyr_df
NULL
