#' @title Order rows using column values
#'
#' @description  This is a method for the [dplyr::arrange()] generic.
#' See "Fallbacks" section for differences in implementation.
#' `arrange()` orders the rows of a data frame by the values of selected
#' columns.
#'
#' Unlike other dplyr verbs, `arrange()` largely ignores grouping; you
#' need to explicitly mention grouping variables (or use  `.by_group = TRUE`)
#' in order to group by them, and functions of variables are evaluated
#' once per data frame, not once per group.
#'
#'
#' @inheritParams dplyr::arrange
#' @seealso [dplyr::arrange()]
#' @rdname arrange.duckplyr_df
#' @name arrange.duckplyr_df
NULL
