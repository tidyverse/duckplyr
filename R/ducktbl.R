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
#' See `vignette("funnel")` for details.
#'
#' @param ... For `duckdb_tibble()`, passed on to [tibble()].
#'   For `as_duckdb_tibble()`, passed on to methods.
#' @param .funnel,funnel Either a logical:
#'   - Set to `TRUE` to return a funneled data frame.
#'   - Set to `FALSE` to return an unfunneled data frame.
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
#' The default is to inherit the funneling of the input.
#'   see the "Funneling" section.
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
#' y <- duckdb_tibble(a = 1, .funnel = "closed")
#' y
#' try(length(y$a))
#' length(collect(y)$a)
#' @export
duckdb_tibble <- function(..., .funnel = "open") {
  out <- tibble::tibble(...)

  # Side effect: check compatibility
  # No telemetry, this doesn't seem to be useful data
  # (and conflicts with test-telemetry.R)
  # FIXME: May be handled by other methods
  check_df_for_rel(out)

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
as_duckdb_tibble <- function(x, ..., funnel = "open") {
  # Handle the funnel arg in the generic, only the other args will be dispatched
  as_duckdb_tibble <- function(x, ...) {
    UseMethod("as_duckdb_tibble")
  }

  funnel_parsed <- funnel_parse(funnel)
  out <- as_duckdb_tibble(x, ...)

  if (funnel_parsed$funnel == "closed") {
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

#' @export
as_duckdb_tibble.tbl_duckdb_connection <- function(x, ...) {
  check_dots_empty()

  con <- dbplyr::remote_con(x)
  sql <- dbplyr::remote_query(x)

  read_sql_duckdb(sql, funnel = "closed", con = con)
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
