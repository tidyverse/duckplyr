#' Configuration options
#'
#' The behavior of duckplyr can be fine-tuned with several environment variables,
#' and one option.
#'
#' @section Options:
#'
#' `duckdb.materialize_message`: Set to `FALSE` to turn off diagnostic output from duckdb
#' on data frame materialization.
#' Currenty set to `TRUE` when duckplyr is loaded.
#'
#' @section Environment variables:
#'
#' `DUCKPLYR_OUTPUT_ORDER`: If `TRUE`, row output order is preserved.
#' If `FALSE`,
#'
#' `DUCKPLYR_FORCE`: If `TRUE`, fail if duckdb cannot handle a request.
#'
#' `DUCKPLYR_FALLBACK_INFO`: If `TRUE`, print a message when a fallback to dplyr occurs
#' because duckdb cannot handle a request.
#'
#' `DUCKPLYR_CHECK_ROUNDTRIP`: If `TRUE`, check if all columns are roundtripped perfectly
#' when creating a relational object from a data frame,
#' This is slow, and mostly useful for debugging.
#' The default is to check roundtrip of attributes.
#'
#' `DUCKPLYR_EXPERIMENTAL`: If `TRUE`, pass `experimental = TRUE`
#' to certain duckdb functions.
#' Currently unused.
#'
# Not available in the CRAN package:
# `DUCKPLYR_META_GLOBAL`: Assume data frames in the global environment as "known".
# `DUCKPLYR_META_SKIP`: Skip recording the operations, replay not available.
#' @name config
NULL
