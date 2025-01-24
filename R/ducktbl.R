#' duckplyr data frames
#'
#' @description
#' Data frames backed by duckplyr have a special class, `"duckplyr_df"`,
#' in addition to the default classes.
#' This ensures that dplyr methods are dispatched correctly.
#' For such objects,
#' dplyr verbs such as [mutate()], [select()] or [filter()]  will use DuckDB.
#'
#' `duckdb_tibble()` works like [tibble()], returning an "untethered" duckplyr data frame by default.
#' See the "Tethering" section below.
#'
#' @section Tethering:
#' Data frames backed by duckplyr, `"duckplyr_df"`, behave as regular data frames in almost all respects.
#' In particular, direct column access like `df$x`,
#' or retrieving the number of rows with [nrow()], works identically.
#'
#' A key difference is that for a duckplyr frame that is the result of a dplyr operation,
#' accessing column data or retrieving the number of rows will trigger a computation
#' that is carried out by DuckDB, not dplyr.
#'
#' Another difference is that duckplyr frames can be safer to use with bigger data
#' thanks to _tethering_.
#' Tethering duckplyr frames differ in their behavior for column access and row count.
#'
#' - For untethered duckplyr frames, the underlying DuckDB computation is carried out
#' upon the first request.
#' Once the results are computed, they are cached and subsequent requests are fast.
#' This is a good choice for small to medium-sized data,
#' where DuckDB can provide a nice speedup but materializing the data is affordable.
#' This is the default for `duckdb_tibble()` and `as_duckdb_tibble()`.
#'
#' - For tethered duckplyr frames, accessing a column or requesting the number of rows
#' triggers an error.
#' This is a good choice for large data sets where the cost of materializing the data
#' may be prohibitive due to size or computation time,
#' and the user wants to control when the computation is carried out.
#' This is the default for the ingestion functions like [read_parquet_duckdb()].
#' It is safe to use `read_parquet_duckdb(tether = FALSE)`
#' if the data is small enough to be materialized at any stage.
#'
#' Tethered duckplyr frames behave like [`dtplyr`'s lazy frames](https://dtplyr.tidyverse.org/reference/lazy_dt.html),
#' or dbplyr's lazy frames:
#' the computation only starts when you **explicitly** request it with a "collect"
#' function.
#' In dtplyr and dbplyr, there are no untethered frames: collection always needs to be
#' explicit.
#'
#' A tethered duckplyr frame can be converted to an untethered one with `as_duckdb_tibble(tether = FALSE)`.
#' The [collect.duckplyr_df()] method triggers computation and converts to a plain tibble.
#' Other useful methods include [compute_file()] for storing results in a file,
#' and [compute.duckplyr_df()] for storing results in temporary storage on disk.
#'
#' Beyond safety regarding memory usage, tethered frames also allow you
#' to check that all operations are supported by DuckDB:
#' for a tethered frame, fallbacks to dplyr are not possible.
#' As a reminder, computing via DuckDB is currently not always possible,
#' see `vignette("limits")` for the supported operations.
#' In such cases, the original dplyr implementation is used, see [fallback] for details.
#' As the original dplyr implementation accesses columns directly,
#' the data must be materialized before a fallback can be executed.
#' This means that automatic fallback is only possible for "untethered" duckplyr frames,
#' while for "tethered" duckplyr frames, one of the aforementioned collection methods must be used first.
#'
#'
#' @param ... For `duckdb_tibble()`, passed on to [tibble()].
#'   For `as_duckdb_tibble()`, passed on to methods.
#' @param .tether,tether Logical, whether to create a tether duckplyr frame.
#'   See the section "Tethering" for details.
#'
#' @return For `duckdb_tibble()` and `as_duckdb_tibble()`, an object with the following classes:
#'   - `"tethered_duckplyr_df"` if `.tether` is `TRUE`
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
#' y <- duckdb_tibble(a = 1, .tether = TRUE)
#' y
#' try(length(y$a))
#' length(collect(y)$a)
#' @export
duckdb_tibble <- function(..., .tether = FALSE) {
  out <- tibble::tibble(...)
  as_duckdb_tibble(out, tether = .tether)
}

#' as_duckdb_tibble
#'
#' `as_duckdb_tibble()` converts a data frame or a dplyr tether table to a duckplyr data frame.
#' This is a generic function that can be overridden for custom classes.
#'
#' @param x The object to convert or to test.
#' @rdname duckdb_tibble
#' @export
as_duckdb_tibble <- function(x, ..., tether = FALSE) {
  # Handle the tether arg in the generic, only the other args will be dispatched
  as_duckdb_tibble <- function(x, ...) {
    UseMethod("as_duckdb_tibble")
  }

  out <- as_duckdb_tibble(x, ...)
  tether_duckdb_tibble(out, tether)
}

tether_duckdb_tibble <- function(x, tether, call = caller_env()) {
  n_rows <- Inf
  n_cells <- Inf

  if (is.numeric(tether)) {
    if (is.null(names(tether))) {
      cli::cli_abort("{.arg tether} must have names if it is a named vector.", call = call)
    }
    extra_names <- setdiff(names(tether), c("rows", "cells"))
    if (length(extra_names) > 0) {
      cli::cli_abort("Unknown name in {.arg tether}: {extra_names[[1]]}", call = call)
    }

    if ("rows" %in% names(tether)) {
      n_rows <- tether[["rows"]]
      if (is.na(n_rows) || n_rows < 0) {
        cli::cli_abort("The {.val rows} component of {.arg tether} must be a non-negative integer", call = call)
      }
    }
    if ("cells" %in% names(tether)) {
      n_cells <- tether[["cells"]]
      if (is.na(n_cells) || n_cells < 0) {
        cli::cli_abort("The {.val cells} component of {.arg tether} must be a non-negative integer", call = call)
      }
    }
    allow_materialization <- is.finite(n_rows) || is.finite(n_cells)
    tether <- TRUE
  } else if (!is.logical(tether)) {
    cli::cli_abort("{.arg tether} must be a logical scalar or a named vector", call = call)
  } else {
    allow_materialization <- !isTRUE(tether)
  }

  if (tether) {
    as_tethered_duckplyr_df(x, allow_materialization, n_rows, n_cells)
  } else {
    as_untethered_duckplyr_df(x)
  }
}

#' @export
as_duckdb_tibble.tbl_duckdb_connection <- function(x, ...) {
  check_dots_empty()

  con <- dbplyr::remote_con(x)
  sql <- dbplyr::remote_query(x)

  read_sql_duckdb(sql, tether = FALSE, con = con)
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


#' @param tether Only adds the class, does not recreate the relation object!
#' @noRd
new_duckdb_tibble <- function(x, class = NULL, tether = FALSE, error_call = caller_env()) {
  if (is.null(class)) {
    class <- c("tbl_df", "tbl", "data.frame")
  }

  if (!inherits(x, "duckplyr_df")) {
    if (anyNA(names(x)) || any(names(x) == "")) {
      cli::cli_abort("Missing or empty names not allowed.", call = error_call)
    }
  }

  class(x) <- unique(c(
    if (tether) "tethered_duckplyr_df",
    "duckplyr_df",
    class
  ))

  x
}
