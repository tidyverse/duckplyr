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
#' `duck_tbl()` works like [tibble()].
#' In contrast to dbplyr, duckplyr data frames are "eager" by default.
#' To avoid unwanted expensive computation, they can be converted to "lazy" duckplyr frames
#' on which [collect()] needs to be called explicitly.
#'
#' @details
#' Set the `DUCKPLYR_FALLBACK_INFO` and `DUCKPLYR_FORCE` environment variables
#' for more control over the behavior, see [config] for more details.
#'
#' @param ... For `duck_tbl()`, passed on to [tibble()].
#'   For `as_duck_tbl()`, passed on to methods.
#' @param .lazy Logical, whether to create a lazy duckplyr frame.
#'   If `TRUE`, [collect()] must be called before the data can be accessed.
#'
#' @return For `duck_tbl()` and `as_duck_tbl()`, an object with the following classes:
#'   - `"lazy_duckplyr_df"` if `.lazy` is `TRUE`
#'   - `"duckplyr_df"`
#'   - Classes of a [tibble]
#'
#' @examples
#' x <- duck_tbl(a = 1)
#' x
#'
#' library(dplyr)
#' x %>%
#'   mutate(b = 2)
#'
#' x$a
#'
#' y <- duck_tbl(a = 1, .lazy = TRUE)
#' y
#' try(length(y$a))
#' length(collect(y)$a)
#' @export
duck_tbl <- function(..., .lazy = FALSE) {
  out <- tibble::tibble(...)
  as_duck_tbl(out, .lazy = .lazy)
}

#' as_duck_tbl
#'
#' `as_duck_tbl()` converts a data frame or a dplyr lazy table to a duckplyr data frame.
#' This is a generic function that can be overridden for custom classes.
#'
#' @param x The object to convert or to test.
#' @rdname duck_tbl
#' @export
as_duck_tbl <- function(x, ..., .lazy = FALSE) {
  out <- as_duck_tbl_dispatch(x, ...)

  if (isTRUE(.lazy)) {
    out <- as_lazy_duckplyr_df(out)
  } else {
    out <- as_eager_duckplyr_df(out)
  }

  return(out)
  UseMethod("as_duck_tbl")
}
as_duck_tbl_dispatch <- function(x, ...) {
  UseMethod("as_duck_tbl")
}

#' @export
as_duck_tbl.tbl_duckdb_connection <- function(x, ...) {
  check_dots_empty()

  con <- dbplyr::remote_con(x)
  sql <- dbplyr::remote_query(x)

  duck_sql(sql, lazy = FALSE, con = con)
}

#' @export
as_duck_tbl.duckplyr_df <- function(x, ...) {
  check_dots_empty()
  x
}

#' @export
as_duck_tbl.data.frame <- function(x, ...) {
  check_dots_empty()

  tbl <- as_tibble(x)

  # - as_tibble() to remove row names
  new_duck_tbl(tbl)
}

#' @export
as_duck_tbl.default <- function(x, ...) {
  check_dots_empty()

  # - as.data.frame() call for good measure and perhaps https://github.com/tidyverse/tibble/issues/1556
  # - as_tibble() to remove row names
  # Could call as_duck_tbl(as.data.frame(x)) here, but that would be slower
  new_duck_tbl(as_tibble(as.data.frame(x)))
}

#' @export
as_duck_tbl.grouped_df <- function(x, ...) {
  check_dots_empty()

  cli::cli_abort(c(
    "duckplyr does not support {.code group_by()}.",
    i = "Use `.by` instead.",
    i = "To proceed with dplyr, use {.code as_tibble()} or {.code as.data.frame()}."
  ))
}

#' @export
as_duck_tbl.rowwise_df <- function(x, ...) {
  check_dots_empty()

  cli::cli_abort(c(
    "duckplyr does not support {.code rowwise()}.",
    i = "To proceed with dplyr, use {.code as_tibble()} or {.code as.data.frame()}."
  ))
}

#' is_duck_tbl
#'
#' `is_duck_tbl()` returns `TRUE` if `x` is a duckplyr data frame.
#'
#' @return For `is_duck_tbl()`, a scalar logical.
#' @rdname duck_tbl
#' @export
is_duck_tbl <- function(x) {
  inherits(x, "duckplyr_df")
}


#' @param lazy Only adds the class, does not recreate the relation object!
#' @noRd
new_duck_tbl <- function(x, class = NULL, lazy = FALSE, error_call = caller_env()) {
  if (is.null(class)) {
    class <- c("tbl_df", "tbl", "data.frame")
  }

  if (!inherits(x, "duckplyr_df")) {
    if (anyNA(names(x)) || any(names(x) == "")) {
      cli::cli_abort("Missing or empty names not allowed.", call = error_call)
    }
  }

  class(x) <- unique(c(
    if (lazy) "lazy_duckplyr_df",
    "duckplyr_df",
    class
  ))

  x
}
