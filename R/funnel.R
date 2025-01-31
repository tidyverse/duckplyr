#' @param prudence Only adds the class, does not recreate the relation object!
#' @noRd
new_duckdb_tibble <- function(x, class = NULL, prudence = "lavish", adjust_prudence = FALSE, error_call = caller_env()) {
  if (is.null(class)) {
    class <- c("tbl_df", "tbl", "data.frame")
  } else {
    class <- setdiff(class, c("prudent_duckplyr_df", "duckplyr_df"))
  }

  if (!inherits(x, "duckplyr_df")) {
    if (anyNA(names(x)) || any(names(x) == "")) {
      cli::cli_abort("Missing or empty names not allowed.", call = error_call)
    }
  }

  prudence_parsed <- prudence_parse(prudence, error_call)

  # Before setting class, needs prudence_parsed
  if (adjust_prudence) {
    rel <- duckdb_rel_from_df(x)

    # Copied from rel_to_df.duckdb_relation(), to avoid recursion
    x <- duckdb$rel_to_altrep(
      rel,
      # FIXME: Remove allow_materialization with duckdb >= 1.2.0
      allow_materialization = prudence_parsed$allow_materialization,
      n_rows = prudence_parsed$n_rows,
      n_cells = prudence_parsed$n_cells
    )
  }

  class(x) <- c(
    if (!identical(prudence_parsed$prudence, "lavish")) "prudent_duckplyr_df",
    "duckplyr_df",
    class
  )

  prudence_attr <- c(
    rows = if (is.finite(prudence_parsed$n_rows)) prudence_parsed$n_rows,
    cells = if (is.finite(prudence_parsed$n_cells)) prudence_parsed$n_cells
  )
  attr(x, "prudence") <- prudence_attr

  x
}

is_prudent_duckplyr_df <- function(x) {
  inherits(x, "prudent_duckplyr_df")
}

prudence_parse <- function(prudence, call = caller_env()) {
  n_rows <- Inf
  n_cells <- Inf

  if (is.numeric(prudence)) {
    if (is.null(names(prudence))) {
      cli::cli_abort("{.arg prudence} must have names if it is a named vector.", call = call)
    }
    extra_names <- setdiff(names(prudence), c("rows", "cells"))
    if (length(extra_names) > 0) {
      cli::cli_abort("Unknown name in {.arg prudence}: {extra_names[[1]]}", call = call)
    }

    if ("rows" %in% names(prudence)) {
      n_rows <- prudence[["rows"]]
      if (is.na(n_rows) || n_rows < 0) {
        cli::cli_abort("The {.val rows} component of {.arg prudence} must be a non-negative integer", call = call)
      }
    }
    if ("cells" %in% names(prudence)) {
      n_cells <- prudence[["cells"]]
      if (is.na(n_cells) || n_cells < 0) {
        cli::cli_abort("The {.val cells} component of {.arg prudence} must be a non-negative integer", call = call)
      }
    }
    allow_materialization <- is.finite(n_rows) || is.finite(n_cells)
    prudence <- "frugal"
  } else if (!is.character(prudence)) {
    cli::cli_abort("{.arg prudence} must be an unnamed character vector or a named numeric vector", call = call)
  } else {
    prudence <- arg_match(prudence, c("lavish", "frugal", "thrifty"), error_call = call)

    allow_materialization <- !identical(prudence, "frugal")
    if (!allow_materialization) {
      n_cells <- 0
    } else if (identical(prudence, "thrifty")) {
      n_cells <- 1e6
    }
  }

  list(
    prudence = prudence,
    # FIXME: Remove allow_materialization with duckdb >= 1.2.0
    allow_materialization = allow_materialization,
    n_rows = n_rows,
    n_cells = n_cells
  )
}

get_prudence_duckplyr_df <- function(x) {
  if (!is_prudent_duckplyr_df(x)) {
    return("lavish")
  }

  prudence <- attr(x, "prudence")
  if (is.null(prudence)) {
    return("frugal")
  }

  if (identical(prudence, c(cells = 1e6))) {
    return("thrifty")
  }

  prudence
}

duckplyr_reconstruct <- function(rel, template) {
  out <- rel_to_df(
    rel,
    prudence = get_prudence_duckplyr_df(template)
  )
  dplyr_reconstruct(out, template)
}

#' @export
collect.prudent_duckplyr_df <- function(x, ...) {
  # Do nothing if already materialized
  adjust_prudence <- !is.null(duckdb$rel_from_altrep_df(x, strict = FALSE, allow_materialized = FALSE))

  out <- new_duckdb_tibble(x, class(x), adjust_prudence = adjust_prudence, prudence = "lavish")
  collect(out)
}

#' @export
as.data.frame.duckplyr_df <- function(x, row.names = NULL, optional = FALSE, ...) {
  out <- collect(x)
  class(out) <- setdiff(class(out), c("duckplyr_df", "tbl_df", "tbl"))
  as.data.frame(out, row.names = row.names, optional = optional, ...)
}

#' @export
as.data.frame.prudent_duckplyr_df <- function(x, row.names = NULL, optional = FALSE, ...) {
  out <- collect(x)
  as.data.frame(out, row.names = row.names, optional = optional, ...)
}

#' @export
as_tibble.duckplyr_df <- function(x, ...) {
  out <- collect(x)
  class(out) <- setdiff(class(out), "duckplyr_df")
  as_tibble(out)
}
