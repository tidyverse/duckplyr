#' @title Create, modify, and delete columns (duckplyr)
#'
#' @description  This is a method for the [dplyr::collect()] generic.
#' `collect()` converts the input to a tibble, materializing any lazy operations.
#'
#' @inheritParams dplyr::collect
#' @examples
#' library("duckplyr")
#' df <- duckdb_tibble(x = c(1, 2), .lazy = TRUE)
#' df
#' try(print(df$x))
#' df <- collect(df)
#' df
#' @seealso [dplyr::collect()]
#' @rdname collect.duckplyr_df
#' @name collect.duckplyr_df
NULL
