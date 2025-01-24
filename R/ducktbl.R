#' duckplyr data frames
#'
#' @description
#' Data frames backed by duckplyr have a special class, `"duckplyr_df"`,
#' in addition to the default classes.
#' This ensures that dplyr methods are dispatched correctly.
#' For such objects,
#' dplyr verbs such as [mutate()], [select()] or [filter()]  will use DuckDB.
#'
#' `duckdb_tibble()` works like [tibble()], returning an "eager" duckplyr data frame by default.
#' See the "Eager and lazy" section below.
#'
#' @section Eager and lazy:
#' Data frames backed by duckplyr, with class `"duckplyr_df"`,
#' behave as regular data frames in almost all respects.
#' In particular, direct column access like `df$x`,
#' or retrieving the number of rows with [nrow()], works identically.
#' Conceptually, duckplyr frames are "eager": from a user's perspective,
#' they behave like regular data frames.
#' Under the hood, two key differences provide improved performance and usability:
#' lazy materialization and lazying.
#'
#' For a duckplyr frame that is the result of a dplyr operation,
#' accessing column data or retrieving the number of rows will trigger a computation
#' that is carried out by DuckDB, not dplyr.
#' In this sense, duckplyr frames are also "lazy":
#' the computation is deferred until the last possible moment,
#' allowing DuckDB to optimize the whole pipeline.
#' This is similar to lazy tables in \pkg{dbplyr} and \pkg{dtplyr},
#' but different from \pkg{dplyr} where each intermediate step is computed.
#'
#' Being both "eager" and "lazy" at the same time introduces a challenge:
#' it is too easy to accidentally trigger computation,
#' which may be prohibitive if an intermediate result is too large.
#' This is where lazying comes in.
#'
#' - For eager duckplyr frames, the underlying DuckDB computation is carried out
#'   upon the first request.
#'   Once the results are computed, they are cached and subsequent requests are fast.
#'   This is a good choice for small to medium-sized data,
#'   where DuckDB can provide a nice speedup but materializing the data is affordable
#'   at any stage.
#'   This is the default for `duckdb_tibble()` and `as_duckdb_tibble()`.
#'
#' - For lazy duckplyr frames, accessing a column or requesting the number of rows
#'   triggers an error, either unconditionally, or if the result exceeds a certain size.
#'   This is a good choice for large data sets where the cost of materializing the data
#'   may be prohibitive due to size or computation time,
#'   and the user wants to control when the computation is carried out.
#'   The default for the ingestion functions like [read_parquet_duckdb()]
#'   is to limit the result size to one million cells (values in the resulting data frame).
#'
#' Lazy duckplyr frames behave like [`dtplyr`'s lazy frames](https://dtplyr.tidyverse.org/reference/lazy_dt.html),
#' or dbplyr's lazy frames:
#' the computation only starts when you **explicitly** request it with a "collect"
#' function.
#' In dtplyr and dbplyr, there are no eager frames: collection always needs to be
#' explicit.
#'
#' A lazy duckplyr frame can be converted to an eager one with `as_duckdb_tibble(lazy = FALSE)`.
#' The [collect.duckplyr_df()] method triggers computation and converts to a plain tibble.
#' Other useful methods include [compute_file()] for storing results in a file,
#' and [compute.duckplyr_df()] for storing results in temporary storage on disk.
#'
#' Beyond safety regarding memory usage, lazy frames also allow you
#' to check that all operations are supported by DuckDB:
#' for a lazy frame with `lazy = FALSE`, fallbacks to dplyr are not possible.
#' As a reminder, computing via DuckDB is currently not always possible,
#' see `vignette("limits")` for the supported operations.
#' In such cases, the original dplyr implementation is used, see [fallback] for details.
#' As the original dplyr implementation accesses columns directly,
#' the data must be materialized before a fallback can be executed.
#' This means that automatic fallback is only possible for "eager" duckplyr frames,
#' while for "lazy" duckplyr frames, one of the aforementioned collection methods must be used first.
#'
#'
#' @param ... For `duckdb_tibble()`, passed on to [tibble()].
#'   For `as_duckdb_tibble()`, passed on to methods.
#' @param .lazy,lazy Logical, whether to create a lazy duckplyr frame.
#'   See the section "Eager and lazy" for details.
#'
#' @return For `duckdb_tibble()` and `as_duckdb_tibble()`, an object with the following classes:
#'   - `"lazy_duckplyr_df"` if `.lazy` is `TRUE`
#'   - `"duckplyr_df"`
#'   - Classes of a [tibble]
#'
#' @examples
#' x <- duckdb_tibble(a = 1)
#' x
#'
#' library(dplyr)
#' x %>%
#'   mutate(b = 2)
#'
#' x$a
#'
#' y <- duckdb_tibble(a = 1, .lazy = TRUE)
#' y
#' try(length(y$a))
#' length(collect(y)$a)
#' @export
duckdb_tibble <- function(..., .lazy = FALSE) {
  out <- tibble::tibble(...)
  as_duckdb_tibble(out, lazy = .lazy)
}

#' as_duckdb_tibble
#'
#' `as_duckdb_tibble()` converts a data frame or a dplyr lazy table to a duckplyr data frame.
#' This is a generic function that can be overridden for custom classes.
#'
#' @param x The object to convert or to test.
#' @rdname duckdb_tibble
#' @export
as_duckdb_tibble <- function(x, ..., lazy = FALSE) {
  # Handle the lazy arg in the generic, only the other args will be dispatched
  as_duckdb_tibble <- function(x, ...) {
    UseMethod("as_duckdb_tibble")
  }

  out <- as_duckdb_tibble(x, ...)
  lazy_duckdb_tibble(out, lazy)
}

lazy_duckdb_tibble <- function(x, lazy, call = caller_env()) {
  n_rows <- Inf
  n_cells <- Inf

  if (is.numeric(lazy)) {
    if (is.null(names(lazy))) {
      cli::cli_abort("{.arg lazy} must have names if it is a named vector.", call = call)
    }
    extra_names <- setdiff(names(lazy), c("rows", "cells"))
    if (length(extra_names) > 0) {
      cli::cli_abort("Unknown name in {.arg lazy}: {extra_names[[1]]}", call = call)
    }

    if ("rows" %in% names(lazy)) {
      n_rows <- lazy[["rows"]]
      if (is.na(n_rows) || n_rows < 0) {
        cli::cli_abort("The {.val rows} component of {.arg lazy} must be a non-negative integer", call = call)
      }
    }
    if ("cells" %in% names(lazy)) {
      n_cells <- lazy[["cells"]]
      if (is.na(n_cells) || n_cells < 0) {
        cli::cli_abort("The {.val cells} component of {.arg lazy} must be a non-negative integer", call = call)
      }
    }
    allow_materialization <- is.finite(n_rows) || is.finite(n_cells)
    lazy <- TRUE
  } else if (!is.logical(lazy)) {
    cli::cli_abort("{.arg lazy} must be a logical scalar or a named vector", call = call)
  } else {
    allow_materialization <- !isTRUE(lazy)
  }

  if (lazy) {
    as_lazy_duckplyr_df(x, allow_materialization, n_rows, n_cells)
  } else {
    as_eager_duckplyr_df(x)
  }
}

#' @export
as_duckdb_tibble.tbl_duckdb_connection <- function(x, ...) {
  check_dots_empty()

  con <- dbplyr::remote_con(x)
  sql <- dbplyr::remote_query(x)

  read_sql_duckdb(sql, lazy = FALSE, con = con)
}

#' @export
as_duckdb_tibble.duckplyr_df <- function(x, ...) {
  check_dots_empty()
  x
}

#' @export
as_duckdb_tibble.data.frame <- function(x, ...) {
  check_dots_empty()

  tbl <- as_tibble(x)

  # - as_tibble() to remove row names
  new_duckdb_tibble(tbl)
}

#' @export
as_duckdb_tibble.default <- function(x, ...) {
  check_dots_empty()

  # - as.data.frame() call for good measure and perhaps https://github.com/tidyverse/tibble/issues/1556
  # - as_tibble() to remove row names
  # Could call as_duckdb_tibble(as.data.frame(x)) here, but that would be slower
  new_duckdb_tibble(as_tibble(as.data.frame(x)))
}

#' @export
as_duckdb_tibble.grouped_df <- function(x, ...) {
  check_dots_empty()

  cli::cli_abort(c(
    "{.pkg duckplyr} does not support {.code group_by()}.",
    i = "Use {.arg .by} instead.",
    i = "To proceed with {.pkg dplyr}, use {.code as_tibble()} or {.code as.data.frame()}."
  ))
}

#' @export
as_duckdb_tibble.rowwise_df <- function(x, ...) {
  check_dots_empty()

  cli::cli_abort(c(
    "{.pkg duckplyr} does not support {.code rowwise()}.",
    i = "To proceed with {.pkg dplyr}, use {.code as_tibble()} or {.code as.data.frame()}."
  ))
}

#' @export
as_duckdb_tibble.spec_tbl_df <- function(x, ...) {
  check_dots_empty()

  cli::cli_abort(c(
    "The input is data read by {.pkg readr}, and {.pkg duckplyr} supports reading CSV files directly.",
    i = "Use {.code read_csv_duckdb()} to use the built-in reader.",
    i = "To proceed with the data as read by {.pkg readr}, use {.code as_tibble()} before {.code as_duckdb_tibble()}."
  ))
}

#' is_duckdb_tibble
#'
#' `is_duckdb_tibble()` returns `TRUE` if `x` is a duckplyr data frame.
#'
#' @return For `is_duckdb_tibble()`, a scalar logical.
#' @rdname duckdb_tibble
#' @export
is_duckdb_tibble <- function(x) {
  inherits(x, "duckplyr_df")
}


#' @param lazy Only adds the class, does not recreate the relation object!
#' @noRd
new_duckdb_tibble <- function(x, class = NULL, lazy = FALSE, error_call = caller_env()) {
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
