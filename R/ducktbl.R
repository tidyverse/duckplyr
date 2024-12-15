#' duckplyr data frames
#'
#' @description
#' Data frames backed by duckplyr have a special class, `"duckplyr_df"`,
#' in addition to the default classes.
#' This ensures that dplyr methods are dispatched correctly.
#' For such objects,
#' dplyr verbs such as [mutate()], [select()] or [filter()]  will attempt to use DuckDB.
#' If this is not possible, the original dplyr implementation is used.
#'
#' `ducktbl()` works like [tibble()].
#' In contrast to dbplyr, duckplyr data frames are "eager" by default.
#' To avoid unwanted expensive computation, they can be converted to "lazy" duckplyr frames
#' on which [collect()] needs to be called explicitly.
#'
#' @details
#' Set the `DUCKPLYR_FALLBACK_INFO` and `DUCKPLYR_FORCE` environment variables
#' for more control over the behavior, see [config] for more details.
#'
#' @param ... Passed on to [tibble()].
#' @return An object with the following classes:
#'   - `"duckplyr_df"`
#'   - Classes of a [tibble]
#'
#' @examples
#' x <- ducktbl(a = 1)
#' x
#'
#' library(dplyr)
#' x %>%
#'   mutate(b = 2)
#'
#' x$a
#'
#' y <- ducktbl(a = 1, .lazy = TRUE)
#' y
#' try(y$a)
#' collect(y)$a
#' @export
ducktbl <- function(...) {
  out <- tibble::tibble(...)

  out <- as_duckplyr_df_(out)

  out
}
