#' @title Summarise each group down to one row
#'
#' @description  This is a method for the [dplyr::summarise()] generic.
#' See "Fallbacks" section for differences in implementation.
#' `summarise()` creates a new data frame.
#' It returns one row for each combination of grouping variables;
#' if there are no grouping variables,
#' the output will have a single row summarising all observations in the input.
#' It will contain one column for each grouping variable
#' and one column for each of the summary statistics that you have specified.
#'
#' @inheritParams dplyr::summarise
#' @examples
#' library(duckplyr)
#' summarise(mtcars, mean = mean(disp), n = n())
#' @seealso [dplyr::summarise()]
#' @rdname summarise.duckplyr_df
#' @name summarise.duckplyr_df
NULL
