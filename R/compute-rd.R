#' @title Compute results
#'
#' @description  This is a method for the [dplyr::compute()] generic.
#' For a duckplyr frame,
#' `compute()` executes a query but stores it in a (temporary) table,
#' or in a Parquet or CSV file.
#' The result is a duckplyr frame that can be used with subsequent dplyr verbs.
#'
#' @inheritParams dplyr::compute
#' @inheritParams duckdb_tibble
#' @param x A duckplyr frame.
#' @param name The name of the table to store the result in.
#' @param schema_name The schema to store the result in, defaults to the current schema.
#' @param temporary Set to `FALSE` to store the result in a permanent table.
#' @param prudence Controls automatic materialization of data, for memory protection.
#'
#'   - `"lavish"`: regardless of size,
#'   - `"frugal"`: never,
#'   - `"thrifty"`: up to a maximum size of 1 million cells.
#'
#' The default is to inherit from the input.
#' This argument is provided here only for convenience.
#' The same effect can be achieved by forwarding the output to [as_duckdb_tibble()]
#' with the desired prudence.
#' See `vignette("prudence")` for more information.
#'
# @inheritSection duckdb_tibble Fine-tuning prudence # Omitting here, too much detail
#'
#' @return A duckplyr frame.
#'
#' @examples
#' library(duckplyr)
#' df <- duckdb_tibble(x = c(1, 2))
#' df <- mutate(df, y = 2)
#' explain(df)
#' df <- compute(df)
#' explain(df)
#' @seealso [dplyr::collect()]
#' @rdname compute.duckplyr_df
#' @name compute.duckplyr_df
NULL
