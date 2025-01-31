#' @param funnel Only adds the class, does not recreate the relation object!
#' @noRd
new_duckdb_tibble <- function(x, class = NULL, funnel = "open", refunnel = FALSE, error_call = caller_env()) {
  if (is.null(class)) {
    class <- c("tbl_df", "tbl", "data.frame")
  } else {
    class <- setdiff(class, c("funneled_duckplyr_df", "duckplyr_df"))
  }

  if (!inherits(x, "duckplyr_df")) {
    if (anyNA(names(x)) || any(names(x) == "")) {
      cli::cli_abort("Missing or empty names not allowed.", call = error_call)
    }
  }

  funnel_parsed <- funnel_parse(funnel, error_call)

  # Before setting class, needs funnel_parsed
  if (refunnel) {
    rel <- duckdb_rel_from_df(x)

    x <- rel_to_df(
      rel,
      allow_materialization = funnel_parsed$allow_materialization,
      n_rows = funnel_parsed$n_rows,
      n_cells = funnel_parsed$n_cells
    )
  }

  class(x) <- c(
    if (!identical(funnel, "open")) "funneled_duckplyr_df",
    "duckplyr_df",
    class
  )

  funnel_attr <- c(
    rows = if (is.finite(funnel_parsed$n_rows)) funnel_parsed$n_rows,
    cells = if (is.finite(funnel_parsed$n_cells)) funnel_parsed$n_cells
  )
  attr(x, "funnel") <- funnel_attr

  x
}

is_funneled_duckplyr_df <- function(x) {
  inherits(x, "funneled_duckplyr_df")
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
    funnel <- "closed"
  } else if (!is.character(funnel)) {
    cli::cli_abort("{.arg funnel} must be an unnamed character vector or a named numeric vector", call = call)
  } else {
    allow_materialization <- !identical(funnel, "closed")
  }

  list(
    funnel = funnel,
    allow_materialization = allow_materialization,
    n_rows = n_rows,
    n_cells = n_cells
  )
}

get_funnel_duckplyr_df <- function(x) {
  if (!is_funneled_duckplyr_df(x)) {
    return("open")
  }

  funnel <- attr(x, "funnel")
  if (is.null(funnel)) {
    return("closed")
  }

  funnel
}

duckplyr_reconstruct <- function(rel, template) {
  out <- rel_to_df(
    rel,
    funnel = get_funnel_duckplyr_df(template)
  )
  dplyr_reconstruct(out, template)
}

#' @export
collect.funneled_duckplyr_df <- function(x, ...) {
  # Do nothing if already materialized
  refunnel <- !is.null(duckdb$rel_from_altrep_df(x, strict = FALSE, allow_materialized = FALSE))

  out <- new_duckdb_tibble(x, class(x), refunnel = refunnel, funnel = "open")
  collect(out)
}

#' @export
as.data.frame.duckplyr_df <- function(x, row.names = NULL, optional = FALSE, ...) {
  out <- collect(x)
  class(out) <- setdiff(class(out), c("duckplyr_df", "tbl_df", "tbl"))
  as.data.frame(out, row.names = row.names, optional = optional, ...)
}

#' @export
as.data.frame.funneled_duckplyr_df <- function(x, row.names = NULL, optional = FALSE, ...) {
  out <- collect(x)
  as.data.frame(out, row.names = row.names, optional = optional, ...)
}

#' @export
as_tibble.duckplyr_df <- function(x, ...) {
  out <- collect(x)
  class(out) <- setdiff(class(out), "duckplyr_df")
  as_tibble(out)
}
