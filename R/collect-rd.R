#' @title Force conversion to a data frame
#'
#' @description  This is a method for the [dplyr::collect()] generic.
#' `collect()` converts the input to a tibble, materializing any lazy operations.
#'
#' @details
#' Due to the way duckplyr uses ALTREP (Alternative Representation for R),
#' string columns are not fully materialized in R memory immediately upon calling `collect()`.
#' Instead, memory allocation for strings is deferred until the values are explicitly accessed
#' (for instance, when printing to the console or calling `str()`).
#' This makes `collect()` fast, but doing operations that access all string values
#' directly after `collect()` will suffer a one-time performance hit as the strings are materialized.
#'
#' @inheritParams dplyr::collect
#' @examples
#' library(duckplyr)
#' df <- duckdb_tibble(x = c(1, 2), .lazy = TRUE)
#' df
#' try(print(df$x))
#' df <- collect(df)
#' df
#' @seealso [dplyr::collect()]
#' @rdname collect.duckplyr_df
#' @name collect.duckplyr_df
NULL
