#' @title Union of all
#'
#' @description  This is a method for the [dplyr::union_all()] generic.
#' See "Fallbacks" section for differences in implementation.
#' `union_all(x, y)` finds all rows in either x or y, including duplicates.
#'
#' @inheritParams dplyr::union_all
#' @examples
#' df1 <- tibble(x = 1:3)
#' df2 <- tibble(x = 3:5)
#' union_all(df1, df2)
#' @seealso [dplyr::union_all()]
#' @rdname union_all.duckplyr_df
#' @name union_all.duckplyr_df
NULL
