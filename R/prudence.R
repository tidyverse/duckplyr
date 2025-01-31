#' @param collect Only adds the class, does not recreate the relation object!
#' @noRd
new_duckdb_tibble <- function(x, class = NULL, collect = "automatic", adjust_prudence = FALSE, error_call = caller_env()) {
  if (is.null(class)) {
    class <- c("tbl_df", "tbl", "data.frame")
  } else {
    class <- setdiff(class, c("frugal_duckplyr_df", "duckplyr_df"))
  }

  if (!inherits(x, "duckplyr_df")) {
    if (anyNA(names(x)) || any(names(x) == "")) {
      cli::cli_abort("Missing or empty names not allowed.", call = error_call)
    }
  }

  collect_parsed <- collect_parse(collect, error_call)

  # Before setting class, needs collect_parsed
  if (adjust_prudence) {
    rel <- duckdb_rel_from_df(x)

    # Copied from rel_to_df.duckdb_relation(), to avoid recursion
    x <- duckdb$rel_to_altrep(
      rel,
      # FIXME: Remove allow_materialization with duckdb >= 1.2.0
      allow_materialization = collect_parsed$allow_materialization,
      n_rows = collect_parsed$n_rows,
      n_cells = collect_parsed$n_cells
    )
  }

  class(x) <- c(
    if (!identical(collect, "automatic")) "frugal_duckplyr_df",
    "duckplyr_df",
    class
  )

  collect_attr <- c(
    rows = if (is.finite(collect_parsed$n_rows)) collect_parsed$n_rows,
    cells = if (is.finite(collect_parsed$n_cells)) collect_parsed$n_cells
  )
  attr(x, "collect") <- collect_attr

  x
}

is_frugal_duckplyr_df <- function(x) {
  inherits(x, "frugal_duckplyr_df")
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
    if (!allow_materialization) {
      n_cells <- 0
    } else if (identical(collect, "only_small")) {
      n_cells <- 1e6
    }
  }

  list(
    collect = collect,
    # FIXME: Remove allow_materialization with duckdb >= 1.2.0
    allow_materialization = allow_materialization,
    n_rows = n_rows,
    n_cells = n_cells
  )
}

get_collect_duckplyr_df <- function(x) {
  if (!is_frugal_duckplyr_df(x)) {
    return("automatic")
  }

  collect <- attr(x, "collect")
  if (is.null(collect)) {
    return("always_manual")
  }

  if (identical(collect, c(cells = 1e6))) {
    return("only_small")
  }

  collect
}

duckplyr_reconstruct <- function(rel, template) {
  out <- rel_to_df(
    rel,
    collect = get_collect_duckplyr_df(template)
  )
  dplyr_reconstruct(out, template)
}

#' @export
collect.frugal_duckplyr_df <- function(x, ...) {
  # Do nothing if already materialized
  adjust_prudence <- !is.null(duckdb$rel_from_altrep_df(x, strict = FALSE, allow_materialized = FALSE))

  out <- new_duckdb_tibble(x, class(x), adjust_prudence = adjust_prudence, collect = "automatic")
  collect(out)
}

#' @export
as.data.frame.duckplyr_df <- function(x, row.names = NULL, optional = FALSE, ...) {
  out <- collect(x)
  class(out) <- setdiff(class(out), c("duckplyr_df", "tbl_df", "tbl"))
  as.data.frame(out, row.names = row.names, optional = optional, ...)
}

#' @export
as.data.frame.frugal_duckplyr_df <- function(x, row.names = NULL, optional = FALSE, ...) {
  out <- collect(x)
  as.data.frame(out, row.names = row.names, optional = optional, ...)
}

#' @export
as_tibble.duckplyr_df <- function(x, ...) {
  out <- collect(x)
  class(out) <- setdiff(class(out), "duckplyr_df")
  as_tibble(out)
}
