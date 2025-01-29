as_inert_duckplyr_df <- function(x, allow_materialization, n_rows, n_cells) {
  rel <- duckdb_rel_from_df(x)

  out <- rel_to_df(
    rel,
    allow_materialization = allow_materialization,
    n_rows = n_rows,
    n_cells = n_cells
  )

  out <- dplyr_reconstruct(out, x)
  add_inert_duckplyr_df_class(out, n_rows, n_cells)
}

add_inert_duckplyr_df_class <- function(x, n_rows, n_cells) {
  class(x) <- unique(c("inert_duckplyr_df", class(x)))

  inert <- c(
    rows = if (is.finite(n_rows)) n_rows,
    cells = if (is.finite(n_cells)) n_cells
  )
  attr(x, "inert") <- inert

  x
}

as_non_inert_duckplyr_df <- function(x) {
  if (!inherits(x, "inert_duckplyr_df")) {
    return(x)
  }

  rel <- duckdb_rel_from_df(x)

  out <- rel_to_df(rel, allow_materialization = TRUE)

  out <- dplyr_reconstruct(out, x)
  remove_inert_duckplyr_df_class(out)
}

is_inert_duckplyr_df <- function(x) {
  inherits(x, "inert_duckplyr_df")
}

get_inert_duckplyr_df <- function(x) {
  if (!is_inert_duckplyr_df(x)) {
    return("never")
  }

  inert <- attr(x, "inert")
  if (is.null(inert)) {
    return("always")
  }

  inert
}

remove_inert_duckplyr_df_class <- function(x) {
  class(x) <- setdiff(class(x), "inert_duckplyr_df")
  attr(x, "inert") <- NULL
  x
}

duckplyr_reconstruct <- function(rel, template) {
  inert <- get_inert_duckplyr_df(template)
  inert_parsed <- inert_parse(inert)
  out <- rel_to_df(
    rel,
    allow_materialization = inert_parsed$allow_materialization,
    n_rows = inert_parsed$n_rows,
    n_cells = inert_parsed$n_cells
  )
  dplyr_reconstruct(out, template)
}

#' @export
collect.inert_duckplyr_df <- function(x, ...) {
  # Do nothing if already materialized
  if (is.null(duckdb$rel_from_altrep_df(x, allow_materialized = FALSE))) {
    out <- x
  } else {
    rel <- duckdb_rel_from_df(x)
    out <- rel_to_df(rel, allow_materialization = TRUE)
    out <- dplyr_reconstruct(out, x)
  }

  out <- remove_inert_duckplyr_df_class(out)
  collect(out)
}

#' @export
as.data.frame.duckplyr_df <- function(x, row.names = NULL, optional = FALSE, ...) {
  out <- collect(x)
  class(out) <- setdiff(class(out), c("duckplyr_df", "tbl_df", "tbl"))
  as.data.frame(out, row.names = row.names, optional = optional, ...)
}

#' @export
as.data.frame.inert_duckplyr_df <- function(x, row.names = NULL, optional = FALSE, ...) {
  out <- collect(x)
  as.data.frame(out, row.names = row.names, optional = optional, ...)
}

#' @export
as_tibble.duckplyr_df <- function(x, ...) {
  out <- collect(x)
  class(out) <- setdiff(class(out), "duckplyr_df")
  as_tibble(out)
}
