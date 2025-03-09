#' @title Subset rows using their positions
#'
#' @description  This is a method for the [dplyr::slice_head()] generic.
#' `slice_head()` selects the first rows.
#'
#' @inheritParams dplyr::slice_head
#' @examples
#' library(duckplyr)
#' df <- data.frame(x = 1:3)
#' df <- slice_head(df, n = 2)
#' df
#' @seealso [dplyr::slice_head()]
#' @rdname slice_head.duckplyr_df
#' @name slice_head.duckplyr_df
NULL
