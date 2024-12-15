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
#' @param ... For `ducktbl()`, passed on to [tibble()].
#'   For `as_ducktbl()`, passed on to methods.
#'
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

  out <- as_duckplyr_df_impl(out)

  out
}

#' as_ducktbl
#'
#' `as_ducktbl()` converts a data frame or a dplyr lazy table to a duckplyr data frame.
#' This is a generic function that can be overridden for custom classes.
#'
#' @param x The object to convert or to test.
#' @rdname ducktbl
#' @export
as_ducktbl <- function(x, ...) {
  UseMethod("as_ducktbl")
}

#' @export
as_ducktbl.tbl_duckdb_connection <- function(x, ...) {
  check_dots_empty()

  con <- dbplyr::remote_con(x)
  sql <- dbplyr::remote_query(x)
  rel <- duckdb$rel_from_sql(con, sql)
  out <- rel_to_df(rel)
  class(out) <- c("duckplyr_df", class(new_tibble(list())))
  return(out)
}

#' @export
as_ducktbl.default <- function(x, ...) {
  check_dots_empty()

  # Extra as.data.frame() call for good measure and perhaps https://github.com/tidyverse/tibble/issues/1556
  as_duckplyr_df(as_tibble(as.data.frame(.data)))
}
