#' duckplyr data frames
#'
#' @description
#' Data frames backed by duckplyr have a special class, `"duckplyr_df"`,
#' in addition to the default classes.
#' This ensures that dplyr methods are dispatched correctly.
#' For such objects,
#' dplyr verbs such as [mutate()], [select()] or [filter()]  will use DuckDB.
#'
#' `duckdb_tibble()` works like [tibble()].
#'
#' @param ... For `duckdb_tibble()`, passed on to [tibble()].
#'   For `as_duckdb_tibble()`, passed on to methods.
#' @param prudence,.prudence Memory protection, controls if DuckDB may convert
#'   intermediate results in DuckDB-managed memory to data frames in R memory.
#'
#'   - `"lavish"`: regardless of size,
#'   - `"stingy"`: never,
#'   - `"thrifty"`: up to a maximum size of 1 million cells.
#'
#' The default is `"lavish"` for `duckdb_tibble()` and `as_duckdb_tibble()`,
#' and may be different for other functions.
#' See `vignette("prudence")` for more information.
#'
#' @section Fine-tuning prudence:
#' `r lifecycle::badge("experimental")`
#'
#' The `prudence` argument can also be a named numeric vector
#' with at least one of `cells` or `rows`
#' to limit the cells (values) and rows in the resulting data frame
#' after automatic materialization.
#' If both limits are specified, both are enforced.
#' The equivalent of `"thrifty"` is `c(cells = 1e6)`.
#'
#' @return For `duckdb_tibble()` and `as_duckdb_tibble()`, an object with the following classes:
#'   - `"prudent_duckplyr_df"` if `prudence` is not `"lavish"`
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
#' y <- duckdb_tibble(a = 1, .prudence = "stingy")
#' y
#' try(length(y$a))
#' length(collect(y)$a)
#'
#' # Convert a dbplyr connection to a duckplyr tibble:
#' @examplesIf requireNamespace("dbplyr", quietly = TRUE)
#' library(duckdb)
#' con <- DBI::dbConnect(duckdb())
#' DBI::dbWriteTable(con, "data", data.frame(a = 1:3))
#' tbl <- dplyr::tbl(con, "data")
#' tbl
#'
#' as_duckdb_tibble(tbl)
#'
#' DBI::dbDisconnect(con)
#' @export
duckdb_tibble <- function(..., .prudence = c("lavish", "thrifty", "stingy")) {
  out <- tibble::tibble(...)

  new_duckdb_tibble(out, class(out), prudence = .prudence, adjust_prudence = TRUE)
}

#' as_duckdb_tibble
#'
#' `as_duckdb_tibble()` converts a data frame or a dplyr lazy table to a duckplyr data frame.
#' This is a generic function that can be overridden for custom classes.
#'
#' @param x The object to convert or to test.
#' @rdname duckdb_tibble
#' @export
as_duckdb_tibble <- function(x, ..., prudence = c("lavish", "thrifty", "stingy")) {
  # Handle the prudence arg in the generic, only the other args will be dispatched
  as_duckdb_tibble <- function(x, ...) {
    UseMethod("as_duckdb_tibble")
  }

  out <- as_duckdb_tibble(x, ...)
  new_duckdb_tibble(out, class(out), prudence = prudence, adjust_prudence = TRUE)
}

#' @export
as_duckdb_tibble.tbl_duckdb_connection <- function(x, ...) {
  check_dots_empty()

  con <- dbplyr::remote_con(x)
  sql <- dbplyr::remote_query(x)

  # Start restrictive to avoid accidental materialization
  read_sql_duckdb(sql, prudence = "stingy", con = con)
}

#' @export
as_duckdb_tibble.duckplyr_df <- function(x, ...) {
  check_dots_empty()
  x
}

#' @export
as_duckdb_tibble.data.frame <- function(x, ...) {
  check_dots_empty()

  # Only if not materialized yet
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
