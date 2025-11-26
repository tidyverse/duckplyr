#' Configuration options
#'
#' The behavior of duckplyr can be fine-tuned with several environment variables,
#' and one option.
#'
#' @section Environment variables:
#'
#' `DUCKPLYR_TEMP_DIR`: Set to a path where temporary files can be created.
#' By default, [tempdir()] is used.
#'
#' `DUCKPLYR_OUTPUT_ORDER`: If `TRUE`, row output order is preserved.
#' The default may change the row order where dplyr would keep it stable.
#' Preserving the order leads to more complicated execution plans
#' with less potential for optimization, and thus may be slower.
#'
#' `DUCKPLYR_FORCE`: If `TRUE`, fail if duckdb cannot handle a request.
#'
#' `DUCKPLYR_CHECK_ROUNDTRIP`: If `TRUE`, check if all columns are roundtripped perfectly
#' when creating a relational object from a data frame,
#' This is slow, and mostly useful for debugging.
#' The default is to check roundtrip of attributes.
#'
#' `DUCKPLYR_METHODS_OVERWRITE`: If `TRUE`, call `methods_overwrite()`
#' when the package is loaded.
#'
#' See [fallback] for more options related to printing, logging, and uploading
#' of fallback events.
#'
# Not available in the CRAN package:
# `DUCKPLYR_META_ENABLE`: Skip recording the operations, replay not available.
# `DUCKPLYR_META_GLOBAL`: Assume data frames in the global environment as "known".
# `DUCKPLYR_SKIP_DPLYR_TESTS`: Skip dplyr tests for performance
#' @name config
#' @examples
#' # Sys.setenv(DUCKPLYR_OUTPUT_ORDER = TRUE)
#' data.frame(a = 3:1) %>%
#'   as_duckdb_tibble() %>%
#'   inner_join(data.frame(a = 1:4), by = "a")
#'
#' withr::with_envvar(c(DUCKPLYR_OUTPUT_ORDER = "TRUE"), {
#'   data.frame(a = 3:1) %>%
#'     as_duckdb_tibble() %>%
#'     inner_join(data.frame(a = 1:4), by = "a")
#' })
#'
#' # Sys.setenv(DUCKPLYR_FORCE = TRUE)
#' add_one <- function(x) {
#'   x + 1
#' }
#'
#' data.frame(a = 3:1) %>%
#'   as_duckdb_tibble() %>%
#'   mutate(b = add_one(a))
#'
#' try(withr::with_envvar(c(DUCKPLYR_FORCE = "TRUE"), {
#'   data.frame(a = 3:1) %>%
#'     as_duckdb_tibble() %>%
#'     mutate(b = add_one(a))
#' }))
#'
#' # Sys.setenv(DUCKPLYR_FALLBACK_INFO = TRUE)
#' withr::with_envvar(c(DUCKPLYR_FALLBACK_INFO = "TRUE"), {
#'   data.frame(a = 3:1) %>%
#'     as_duckdb_tibble() %>%
#'     mutate(b = add_one(a))
#' })
NULL
