#' duckplyr data frames
#'
#' @description
#' Data frames backed by duckplyr have a special class, `"duckplyr_df"`,
#' in addition to the default classes.
#' This ensures that dplyr methods are dispatched correctly.
#' For such objects,
#' dplyr verbs such as [mutate()], [select()] or [filter()]  will use DuckDB.
#'
#' `duckdb_tibble()` works like [tibble()], returning an "lavish" duckplyr data frame by default.
#' See the "Prudence" section below.
#'
#' @section Prudence:
#' Data frames backed by duckplyr, with class `"duckplyr_df"`,
#' behave as regular data frames in almost all respects.
#' In particular, direct column access like `df$x`,
#' or retrieving the number of rows with [nrow()], works identically.
#' Conceptually, duckplyr frames are "eager": from a user's perspective,
#' they behave like regular data frames.
#' Under the hood, two key differences provide improved performance and usability:
#' lazy materialization and prudence.
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
#' This is where prudence comes in.
#'
#' - For lavish duckplyr frames, the underlying DuckDB computation is carried out
#'   upon the first request.
#'   Once the results are computed, they are cached and subsequent requests are fast.
#'   This is a good choice for small to medium-sized data,
#'   where DuckDB can provide a nice speedup but materializing the data is affordable
#'   at any stage.
#'   This is the default for `duckdb_tibble()` and `as_duckdb_tibble()`.
#'
#' - For frugal duckplyr frames, accessing a column or requesting the number of rows
#'   triggers an error, either unconditionally, or if the result exceeds a certain size.
#'   This is a good choice for large data sets where the cost of materializing the data
#'   may be prohibitive due to size or computation time,
#'   and the user wants to control when the computation is carried out.
#'   The default for the ingestion functions like [read_parquet_duckdb()]
#'   is to limit the result size to one million cells (values in the resulting data frame).
#'
#' Frugal duckplyr frames behave like [`dtplyr`'s lazy frames](https://dtplyr.tidyverse.org/reference/lazy_dt.html),
#' or dbplyr's lazy frames:
#' the computation only starts when you **explicitly** request it with a "collect"
#' function.
#' In dtplyr and dbplyr, there are no lavish frames: collection always needs to be
#' explicit.
#'
#' A frugal duckplyr frame can be converted to an lavish one with `as_duckdb_tibble(collect = "any_size")`.
#' The [collect.duckplyr_df()] method triggers computation and converts to a plain tibble.
#' Other useful methods include [compute_file()] for storing results in a file,
#' and [compute.duckplyr_df()] for storing results in temporary storage on disk.
#'
#' Beyond safety regarding memory usage, frugal frames also allow you
#' to check that all operations are supported by DuckDB:
#' for a frugal frame with `collect = "always_manual"`, fallbacks to dplyr are not possible.
#' As a reminder, computing via DuckDB is currently not always possible,
#' see `vignette("limits")` for the supported operations.
#' In such cases, the original dplyr implementation is used, see [fallback] for details.
#' As the original dplyr implementation accesses columns directly,
#' the data must be materialized before a fallback can be executed.
#' This means that automatic fallback is only possible for "lavish" duckplyr frames,
#' while for "frugal" duckplyr frames, one of the aforementioned collection methods must be used first.
#'
#'
#' @param ... For `duckdb_tibble()`, passed on to [tibble()].
#'   For `as_duckdb_tibble()`, passed on to methods.
#' @param .collect,collect Either a logical:
#'   - Set to `TRUE` to return a frugal data frame.
#'   - Set to `FALSE` to return an lavish data frame.
#'
#' Or a named vector with at least one of
#'   - `cells` (numeric)
#'   - `rows` (numeric)
#'
#' to allow materialization for data up to a certain size,
#'   measured in cells (values) and rows in the resulting data frame.
#'
#' If `cells` is specified but not `rows`, `rows` is `Inf`.
#' If `rows` is specified but not `cells`, `cells` is `Inf`.
#'
#' The default is to inherit the prudence of the input.
#'   see the "Prudence" section.
#'
#' @return For `duckdb_tibble()` and `as_duckdb_tibble()`, an object with the following classes:
#'   - `"frugal_duckplyr_df"` if `.collect` is `TRUE`
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
#' y <- duckdb_tibble(a = 1, .collect = "always_manual")
#' y
#' try(length(y$a))
#' length(collect(y)$a)
#' @export
duckdb_tibble <- function(..., .collect = "any_size") {
  out <- tibble::tibble(...)
  as_duckdb_tibble(out, collect = .collect)
}

#' as_duckdb_tibble
#'
#' `as_duckdb_tibble()` converts a data frame or a dplyr lazy table to a duckplyr data frame.
#' This is a generic function that can be overridden for custom classes.
#'
#' @param x The object to convert or to test.
#' @rdname duckdb_tibble
#' @export
as_duckdb_tibble <- function(x, ..., collect = "any_size") {
  # Handle the collect arg in the generic, only the other args will be dispatched
  as_duckdb_tibble <- function(x, ...) {
    UseMethod("as_duckdb_tibble")
  }

  collect_parsed <- collect_parse(collect)
  out <- as_duckdb_tibble(x, ...)

  if (collect_parsed$collect == "always_manual") {
    as_frugal_duckplyr_df(
      out,
      collect_parsed$allow_materialization,
      collect_parsed$n_rows,
      collect_parsed$n_cells
    )
  } else {
    as_lavish_duckplyr_df(out)
  }
}

collect_parse <- function(collect, call = caller_env()) {
  n_rows <- Inf
  n_cells <- Inf

  if (is.numeric(collect)) {
    if (is.null(names(collect))) {
      cli::cli_abort("{.arg collect} must have names if it is a named vector.", call = call)
    }
    extra_names <- setdiff(names(collect), c("rows", "cells"))
    if (length(extra_names) > 0) {
      cli::cli_abort("Unknown name in {.arg collect}: {extra_names[[1]]}", call = call)
    }

    if ("rows" %in% names(collect)) {
      n_rows <- collect[["rows"]]
      if (is.na(n_rows) || n_rows < 0) {
        cli::cli_abort("The {.val rows} component of {.arg collect} must be a non-negative integer", call = call)
      }
    }
    if ("cells" %in% names(collect)) {
      n_cells <- collect[["cells"]]
      if (is.na(n_cells) || n_cells < 0) {
        cli::cli_abort("The {.val cells} component of {.arg collect} must be a non-negative integer", call = call)
      }
    }
    allow_materialization <- is.finite(n_rows) || is.finite(n_cells)
    collect <- "always_manual"
  } else if (!is.character(collect)) {
    cli::cli_abort("{.arg collect} must be an unnamed character vector or a named numeric vector", call = call)
  } else {
    allow_materialization <- !identical(collect, "always_manual")
  }

  list(
    collect = collect,
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

  read_sql_duckdb(sql, collect = "always_manual", con = con)
}

#' @export
as_duckdb_tibble.duckplyr_df <- function(x, ...) {
  check_dots_empty()
  x
}

#' @export
as_duckdb_tibble.data.frame <- function(x, ...) {
  check_dots_empty()

  # - Avoid as_tibble() here, we don't want to materialize
  if (is.null(duckdb$rel_from_altrep_df(x, strict = FALSE, allow_materialized = FALSE))) {
    x <- as_tibble(x)
  }

  new_duckdb_tibble(x)
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


#' @param collect Only adds the class, does not recreate the relation object!
#' @noRd
new_duckdb_tibble <- function(x, class = NULL, collect = "any_size", error_call = caller_env()) {
  if (is.null(class)) {
    class <- c("tbl_df", "tbl", "data.frame")
  }

  if (!inherits(x, "duckplyr_df")) {
    if (anyNA(names(x)) || any(names(x) == "")) {
      cli::cli_abort("Missing or empty names not allowed.", call = error_call)
    }
  }

  class(x) <- unique(c(
    if (!identical(collect, "any_size")) "frugal_duckplyr_df",
    "duckplyr_df",
    class
  ))

  x
}
