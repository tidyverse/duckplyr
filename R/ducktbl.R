#' duckplyr data frames
#'
#' @description
#' Data frames backed by duckplyr have a special class, `"duckplyr_df"`,
#' in addition to the default classes.
#' This ensures that dplyr methods are dispatched correctly.
#' For such objects,
#' dplyr verbs such as [mutate()], [select()] or [filter()]  will use DuckDB.
#'
#' `duckdb_tibble()` works like [tibble()], returning an "unfunneled" duckplyr data frame by default.
#' See the "Funneling" section below.
#'
#' @section Funneling:
#' Data frames backed by duckplyr, with class `"duckplyr_df"`,
#' behave as regular data frames in almost all respects.
#' In particular, direct column access like `df$x`,
#' or retrieving the number of rows with [nrow()], works identically.
#' Conceptually, duckplyr frames are "eager": from a user's perspective,
#' they behave like regular data frames.
#' Under the hood, two key differences provide improved performance and usability:
#' lazy materialization and funneling.
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
#' This is where funneling comes in.
#'
#' - For unfunneled duckplyr frames, the underlying DuckDB computation is carried out
#'   upon the first request.
#'   Once the results are computed, they are cached and subsequent requests are fast.
#'   This is a good choice for small to medium-sized data,
#'   where DuckDB can provide a nice speedup but materializing the data is affordable
#'   at any stage.
#'   This is the default for `duckdb_tibble()` and `as_duckdb_tibble()`.
#'
#' - For funneled duckplyr frames, accessing a column or requesting the number of rows
#'   triggers an error, either unconditionally, or if the result exceeds a certain size.
#'   This is a good choice for large data sets where the cost of materializing the data
#'   may be prohibitive due to size or computation time,
#'   and the user wants to control when the computation is carried out.
#'   The default for the ingestion functions like [read_parquet_duckdb()]
#'   is to limit the result size to one million cells (values in the resulting data frame).
#'
#' Funneled duckplyr frames behave like [`dtplyr`'s lazy frames](https://dtplyr.tidyverse.org/reference/lazy_dt.html),
#' or dbplyr's lazy frames:
#' the computation only starts when you **explicitly** request it with a "collect"
#' function.
#' In dtplyr and dbplyr, there are no unfunneled frames: collection always needs to be
#' explicit.
#'
#' A funneled duckplyr frame can be converted to an unfunneled one with `as_duckdb_tibble(funnel = FALSE)`.
#' The [collect.duckplyr_df()] method triggers computation and converts to a plain tibble.
#' Other useful methods include [compute_file()] for storing results in a file,
#' and [compute.duckplyr_df()] for storing results in temporary storage on disk.
#'
#' Beyond safety regarding memory usage, funneled frames also allow you
#' to check that all operations are supported by DuckDB:
#' for a funneled frame with `funnel = FALSE`, fallbacks to dplyr are not possible.
#' As a reminder, computing via DuckDB is currently not always possible,
#' see `vignette("limits")` for the supported operations.
#' In such cases, the original dplyr implementation is used, see [fallback] for details.
#' As the original dplyr implementation accesses columns directly,
#' the data must be materialized before a fallback can be executed.
#' This means that automatic fallback is only possible for "unfunneled" duckplyr frames,
#' while for "funneled" duckplyr frames, one of the aforementioned collection methods must be used first.
#'
#'
#' @param ... For `duckdb_tibble()`, passed on to [tibble()].
#'   For `as_duckdb_tibble()`, passed on to methods.
#' @param .funnel,funnel Logical, whether to create a funneled duckplyr frame.
#'   See the section "Funneling" for details.
#'
#' @return For `duckdb_tibble()` and `as_duckdb_tibble()`, an object with the following classes:
#'   - `"funneled_duckplyr_df"` if `.funnel` is `TRUE`
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
#' y <- duckdb_tibble(a = 1, .funnel = TRUE)
#' y
#' try(length(y$a))
#' length(collect(y)$a)
#' @export
duckdb_tibble <- function(..., .funnel = FALSE) {
  out <- tibble::tibble(...)
  as_duckdb_tibble(out, funnel = .funnel)
}

#' as_duckdb_tibble
#'
#' `as_duckdb_tibble()` converts a data frame or a dplyr lazy table to a duckplyr data frame.
#' This is a generic function that can be overridden for custom classes.
#'
#' @param x The object to convert or to test.
#' @rdname duckdb_tibble
#' @export
as_duckdb_tibble <- function(x, ..., funnel = FALSE) {
  # Handle the funnel arg in the generic, only the other args will be dispatched
  as_duckdb_tibble <- function(x, ...) {
    UseMethod("as_duckdb_tibble")
  }

  funnel_parsed <- funnel_parse(funnel)
  out <- as_duckdb_tibble(x, ...)

  if (funnel_parsed$funnel) {
    as_funneled_duckplyr_df(
      out,
      funnel_parsed$allow_materialization,
      funnel_parsed$n_rows,
      funnel_parsed$n_cells
    )
  } else {
    as_unfunneled_duckplyr_df(out)
  }
}

funnel_parse <- function(funnel, call = caller_env()) {
  n_rows <- Inf
  n_cells <- Inf

  if (is.numeric(funnel)) {
    if (is.null(names(funnel))) {
      cli::cli_abort("{.arg funnel} must have names if it is a named vector.", call = call)
    }
    extra_names <- setdiff(names(funnel), c("rows", "cells"))
    if (length(extra_names) > 0) {
      cli::cli_abort("Unknown name in {.arg funnel}: {extra_names[[1]]}", call = call)
    }

    if ("rows" %in% names(funnel)) {
      n_rows <- funnel[["rows"]]
      if (is.na(n_rows) || n_rows < 0) {
        cli::cli_abort("The {.val rows} component of {.arg funnel} must be a non-negative integer", call = call)
      }
    }
    if ("cells" %in% names(funnel)) {
      n_cells <- funnel[["cells"]]
      if (is.na(n_cells) || n_cells < 0) {
        cli::cli_abort("The {.val cells} component of {.arg funnel} must be a non-negative integer", call = call)
      }
    }
    allow_materialization <- is.finite(n_rows) || is.finite(n_cells)
    funnel <- TRUE
  } else if (!is.logical(funnel)) {
    cli::cli_abort("{.arg funnel} must be a logical scalar or a named vector", call = call)
  } else {
    allow_materialization <- !isTRUE(funnel)
  }

  list(
    funnel = funnel,
    allow_materialization = allow_materialization,
    n_rows = n_rows,
    n_cells = n_cells
  )
}

#' @export
as_duckdb_tibble.tbl_duckdb_connection <- function(x, ...) {
  check_dots_empty()

  con <- dbplyr::remote_con(x)
  sql <- dbplyr::remote_query(x)

  read_sql_duckdb(sql, funnel = FALSE, con = con)
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
    i = "Use {.code read_csv_duckdb()} to read with the built-in reader.",
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


#' @param funnel Only adds the class, does not recreate the relation object!
#' @noRd
new_duckdb_tibble <- function(x, class = NULL, funnel = FALSE, error_call = caller_env()) {
  if (is.null(class)) {
    class <- c("tbl_df", "tbl", "data.frame")
  }

  if (!inherits(x, "duckplyr_df")) {
    if (anyNA(names(x)) || any(names(x) == "")) {
      cli::cli_abort("Missing or empty names not allowed.", call = error_call)
    }
  }

  class(x) <- unique(c(
    if (funnel) "funneled_duckplyr_df",
    "duckplyr_df",
    class
  ))

  x
}
