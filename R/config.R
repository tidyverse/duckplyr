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
#' The default may change the row order where dplyr would keep it stable.
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
#' @examples
#' # options(duckdb.materialize_message = FALSE)
#' data.frame(a = 3:1) %>%
#'   as_duckplyr_df() %>%
#'   inner_join(data.frame(a = 1:4), by = "a")
#'
#' rlang::with_options(duckdb.materialize_message = FALSE, {
#'   data.frame(a = 3:1) %>%
#'     as_duckplyr_df() %>%
#'     inner_join(data.frame(a = 1:4), by = "a") %>%
#'     print()
#' })
#'
#' # Sys.setenv(DUCKPLYR_OUTPUT_ORDER = TRUE)
#' data.frame(a = 3:1) %>%
#'   as_duckplyr_df() %>%
#'   inner_join(data.frame(a = 1:4), by = "a")
#'
#' withr::with_envvar(c(DUCKPLYR_OUTPUT_ORDER = "TRUE"), {
#'   data.frame(a = 3:1) %>%
#'     as_duckplyr_df() %>%
#'     inner_join(data.frame(a = 1:4), by = "a")
#' })
#'
#' # Sys.setenv(DUCKPLYR_FORCE = TRUE)
#' add_one <- function(x) {
#'   x + 1
#' }
#'
#' data.frame(a = 3:1) %>%
#'   as_duckplyr_df() %>%
#'   mutate(b = add_one(a))
#'
#' try(withr::with_envvar(c(DUCKPLYR_FORCE = "TRUE"), {
#'   data.frame(a = 3:1) %>%
#'     as_duckplyr_df() %>%
#'     mutate(b = add_one(a))
#' }))
#'
#' # Sys.setenv(DUCKPLYR_FALLBACK_INFO = TRUE)
#' withr::with_envvar(c(DUCKPLYR_FALLBACK_INFO = "TRUE"), {
#'   data.frame(a = 3:1) %>%
#'     as_duckplyr_df() %>%
#'     mutate(b = add_one(a))
#' })
NULL
